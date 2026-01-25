import type { SupabaseClient } from '@supabase/supabase-js'
import type {
  DependencyInfo,
  Project,
  ProjectShare,
  UserShare
} from '@/domain/entities/project.entity'
import type { PaginatedResult } from '@/domain/types/pagination'
import { createLogger } from '@/lib/logger'

const logger = createLogger('SupabaseProjectsRepository')

import { createProject } from '@/domain/entities/project.entity'
import type { ProjectFile } from '@/domain/entities/project-file.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import type {
  IProjectsRepository,
  ProjectSearchParams,
  Tag
} from '@/domain/repositories/projects.repository.interface'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import type { Database, Tables } from '@/types/database.types'

// =============================================================================
// Supabase Query Result Types
// =============================================================================
// These types represent the shape of data returned by Supabase queries with relations.
// Supabase doesn't generate types for nested selects, so we define them explicitly.

type ProjectRow = Tables<'projects'>
type ProjectFileRow = Tables<'project_files'>
type TagRow = Tables<'tags'>

/** DB visibility enum - maps to domain VisibilityValue */
type DbVisibility = Database['public']['Enums']['project_visibility']

/** Result of project query with nested relations */
interface ProjectWithRelations extends ProjectRow {
  author?: { username: string } | null
  project_files: ProjectFileRow[]
  project_shares: Array<{
    project_id: string
    user_id: string
    created_at: string
    user?: { username: string } | null
  }>
  project_tags: Array<{ tags: TagRow | null }>
  project_dependencies: Array<{
    dependency: { id: string; name: string; is_library: boolean } | null
  }>
}

/** Result of project_shares query with nested project */
interface ShareWithProject {
  project: ProjectWithRelations
}

/** Result of project_tags query with nested tag */
interface ProjectTagWithTag {
  tag_id: string
  tags: { id: string; name: string } | null
}

/** Result of project_shares query with nested user_profiles */
interface ShareWithUserProfile {
  project_id: string
  user_id: string
  created_at: string
  user_profiles: { username: string } | null
}

/**
 * Map Supabase data to domain entity with embedded author and user shares (using JOINs)
 */
function mapToDomainWithEmbeddedRelations(data: ProjectWithRelations): Project {
  // Map files
  const files: ProjectFile[] = (data.project_files || []).map((f) =>
    createProjectFile({
      id: f.id,
      projectId: f.project_id,
      name: createFileName(f.name),
      content: createFileContent(f.content),
      isMain: f.is_main,
      order: f.order,
      createdAt: new Date(f.created_at),
      updatedAt: new Date(f.updated_at)
    })
  )

  // Map shares - project_shares table is for user shares, not link shares
  // Link shares (with shareCode) would come from a separate table if implemented
  const shares: ProjectShare[] = []

  // Map tags
  const tags: string[] = (data.project_tags || [])
    .map((pt) => pt.tags?.name || '')
    .filter(Boolean)

  // Map dependencies with full info (id + name)
  const dependencies: DependencyInfo[] = (data.project_dependencies || [])
    .filter((pd) => pd.dependency?.id && pd.dependency?.name)
    .map((pd) => ({
      id: pd.dependency!.id,
      name: pd.dependency!.name
    }))

  // Map user shares from embedded data
  const userShares: UserShare[] = (data.project_shares || [])
    .filter((share) => share.user?.username)
    .map((share) => ({
      projectId: data.id,
      userId: share.user_id,
      username: share.user!.username,
      createdAt: new Date(share.created_at)
    }))

  // Get author username from embedded relation
  const authorUsername = data.author?.username ?? null

  return createProject({
    id: data.id,
    userId: data.user_id,
    authorUsername,
    name: createProjectName(data.name),
    description: data.description,
    thumbnailPath: data.thumbnail_path ?? null,
    visibility: createVisibility(data.visibility),
    isLibrary: data.is_library,
    isSticky: data.is_sticky ?? false,
    files,
    shares,
    tags,
    dependencies,
    userShares,
    createdAt: new Date(data.created_at),
    updatedAt: new Date(data.updated_at)
  })
}

// =============================================================================
// Query Select Strings (reusable across repository methods)
// =============================================================================

/** Full project select with all relations (for authenticated users) */
const PROJECT_SELECT_FULL = `
  *,
  author:user_profiles!projects_user_id_fkey_user_profiles (username),
  project_files (*),
  project_shares (
    project_id,
    user_id,
    created_at,
    user:user_profiles!project_shares_user_id_fkey_user_profiles (username)
  ),
  project_tags (
    tags (*)
  ),
  project_dependencies!project_dependencies_project_id_fkey (
    dependency:projects!project_dependencies_dependency_id_fkey (
      id,
      name,
      is_library
    )
  )
`

/** Simplified project select for anonymous users (no user-related joins) */
const PROJECT_SELECT_ANON = `
  *,
  author:user_profiles!projects_user_id_fkey_user_profiles (username),
  project_files (*),
  project_tags (
    tags (*)
  ),
  project_dependencies!project_dependencies_project_id_fkey (
    dependency:projects!project_dependencies_dependency_id_fkey (
      id,
      name,
      is_library
    )
  )
`

// =============================================================================
// Helper Functions for Repository
// =============================================================================

/**
 * Deduplicate and merge project arrays, keeping the order
 */
function mergeAndDeduplicateProjects(
  ...projectArrays: ProjectWithRelations[][]
): ProjectWithRelations[] {
  const result: ProjectWithRelations[] = []
  const seenIds = new Set<string>()

  for (const projects of projectArrays) {
    for (const project of projects) {
      if (!seenIds.has(project.id)) {
        seenIds.add(project.id)
        result.push(project)
      }
    }
  }

  return result
}

/**
 * Sort projects by updated_at descending
 */
function sortProjectsByUpdatedAt(
  projects: ProjectWithRelations[]
): ProjectWithRelations[] {
  return projects.sort(
    (a, b) =>
      new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime()
  )
}

/**
 * Factory function that creates a Supabase implementation of IProjectsRepository
 * Pure functional approach - returns an object implementing the interface
 * @param supabase - The Supabase client instance (injectable for testing)
 */
export function createSupabaseProjectsRepository(
  supabase: SupabaseClient<Database>
): IProjectsRepository {
  // Helper to fetch projects shared with a user
  async function fetchSharedProjects(
    userId: string
  ): Promise<ProjectWithRelations[]> {
    const { data: sharedProjectIds, error: sharedIdsError } = await supabase
      .from('project_shares')
      .select('project_id')
      .eq('user_id', userId)

    if (sharedIdsError) throw sharedIdsError
    if (!sharedProjectIds || sharedProjectIds.length === 0) return []

    const ids = sharedProjectIds.map((s) => s.project_id)
    const { data, error } = await supabase
      .from('projects')
      .select(PROJECT_SELECT_FULL)
      .in('id', ids)
      .order('updated_at', { ascending: false })

    if (error) throw error
    return (data || []) as unknown as ProjectWithRelations[]
  }

  return {
    async findAll(userId: string): Promise<readonly Project[]> {
      // Get user's own projects
      const { data: ownProjects, error: ownError } = await supabase
        .from('projects')
        .select(PROJECT_SELECT_FULL)
        .eq('user_id', userId)
        .order('updated_at', { ascending: false })

      if (ownError) throw ownError

      // Fetch projects shared with this user
      const sharedProjects = await fetchSharedProjects(userId)

      // Combine, deduplicate and sort
      const allProjects = mergeAndDeduplicateProjects(
        (ownProjects || []) as unknown as ProjectWithRelations[],
        sharedProjects
      )

      return sortProjectsByUpdatedAt(allProjects).map((p) =>
        mapToDomainWithEmbeddedRelations(p)
      )
    },

    async findVisible(userId?: string): Promise<readonly Project[]> {
      // If no user, return only public projects with simpler query
      if (!userId) {
        const { data: publicProjects, error: publicError } = await supabase
          .from('projects')
          .select(PROJECT_SELECT_ANON)
          .eq('visibility', 'public')
          .order('updated_at', { ascending: false })

        if (publicError) throw publicError

        // Map with empty shares for anonymous users
        return (publicProjects || []).map((p) =>
          mapToDomainWithEmbeddedRelations({
            ...p,
            project_shares: []
          } as unknown as ProjectWithRelations)
        )
      }

      // Get public projects
      const { data: publicProjects, error: publicError } = await supabase
        .from('projects')
        .select(PROJECT_SELECT_FULL)
        .eq('visibility', 'public')
        .order('updated_at', { ascending: false })

      if (publicError) throw publicError

      // Get user's own projects (all visibilities)
      const { data: ownProjects, error: ownError } = await supabase
        .from('projects')
        .select(PROJECT_SELECT_FULL)
        .eq('user_id', userId)
        .order('updated_at', { ascending: false })

      if (ownError) throw ownError

      // Fetch projects shared with this user
      const sharedProjects = await fetchSharedProjects(userId)

      // Combine and deduplicate (own projects first, then shared, then public)
      const allProjects = mergeAndDeduplicateProjects(
        (ownProjects || []) as unknown as ProjectWithRelations[],
        sharedProjects,
        (publicProjects || []) as unknown as ProjectWithRelations[]
      )

      return sortProjectsByUpdatedAt(allProjects).map((p) =>
        mapToDomainWithEmbeddedRelations(p)
      )
    },

    async findVisiblePaginated(
      userId: string | undefined,
      params: ProjectSearchParams
    ): Promise<PaginatedResult<Project>> {
      const { limit, offset, search, librariesOnly } = params

      // Use RPC function to avoid URL length issues with large datasets
      // The RPC function handles visibility, filtering, and pagination server-side
      type RpcResult = {
        id: string
        total_count: number
      }
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const { data: rpcData, error: rpcError } = (await (supabase as any).rpc(
        'get_visible_projects_paginated',
        {
          p_user_id: userId || null,
          p_limit: limit,
          p_offset: offset,
          p_search: search || null,
          p_libraries_only: librariesOnly || false
        }
      )) as { data: RpcResult[] | null; error: Error | null }

      if (rpcError) throw rpcError

      if (!rpcData || rpcData.length === 0) {
        return { items: [], total: 0, hasMore: false }
      }

      // Get total from first row (all rows have same total_count)
      const total = Number(rpcData[0].total_count) || 0
      const projectIds = rpcData.map((p) => p.id)

      // Fetch full project data with relations for the paginated IDs
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const { data: fullData, error: fullError } = (await supabase
        .from('projects')
        .select(userId ? PROJECT_SELECT_FULL : PROJECT_SELECT_ANON)
        .in('id', projectIds)
        .order('is_sticky', { ascending: false, nullsFirst: false })
        .order('updated_at', { ascending: false })) as {
        data: Array<{ id: string } & Record<string, unknown>> | null
        error: Error | null
      }

      if (fullError) throw fullError

      // Maintain the order from RPC result
      const projectMap = new Map((fullData || []).map((p) => [p.id, p]))
      const orderedData = projectIds
        .map((id) => projectMap.get(id))
        .filter(Boolean)

      const items = orderedData.map((p) =>
        mapToDomainWithEmbeddedRelations(
          userId
            ? (p as unknown as ProjectWithRelations)
            : ({
                ...(p as object),
                project_shares: []
              } as unknown as ProjectWithRelations)
        )
      )

      return {
        items,
        total,
        hasMore: offset + items.length < total
      }
    },

    async findById(projectId: string): Promise<Project | null> {
      // Guard against undefined/null projectId
      if (!projectId) {
        logger.warn('findById called with invalid projectId:', projectId)
        return null
      }

      const { data, error } = await supabase
        .from('projects')
        .select(
          `
          *,
          author:user_profiles!projects_user_id_fkey_user_profiles (username),
          project_files (*),
          project_shares (
            project_id,
            user_id,
            created_at,
            user:user_profiles!project_shares_user_id_fkey_user_profiles (username)
          ),
          project_tags (
            tags (*)
          ),
          project_dependencies!project_dependencies_project_id_fkey (
            dependency:projects!project_dependencies_dependency_id_fkey (
              id,
              name,
              is_library
            )
          )
        `
        )
        .eq('id', projectId)
        .single()

      if (error) {
        if (error.code === 'PGRST116') return null
        throw error
      }

      return mapToDomainWithEmbeddedRelations(
        data as unknown as ProjectWithRelations
      )
    },

    async findByShareCode(shareCode: string): Promise<Project | null> {
      const { data, error } = await supabase
        .from('project_shares')
        .select(
          `
          project:projects (
            *,
            author:user_profiles!projects_user_id_fkey_user_profiles (username),
            project_files (*),
            project_shares (
              project_id,
              user_id,
              created_at,
              user:user_profiles!project_shares_user_id_fkey_user_profiles (username)
            ),
            project_tags (
              tags (*)
            ),
            project_dependencies!project_dependencies_project_id_fkey (
              dependency:projects!project_dependencies_dependency_id_fkey (
                id,
                name,
                is_library
              )
            )
          )
        `
        )
        .eq('share_code', shareCode)
        .single()

      if (error) {
        if (error.code === 'PGRST116') return null
        throw error
      }

      return mapToDomainWithEmbeddedRelations(
        (data as unknown as ShareWithProject).project
      )
    },

    async create(project: Project): Promise<Project> {
      // Insert project
      // Note: Domain uses 'unlisted' but DB uses 'shared' - map accordingly
      const { data: projectData, error: projectError } = await supabase
        .from('projects')
        .insert({
          user_id: project.userId,
          name: project.name.value,
          description: project.description,
          visibility: project.visibility.value as DbVisibility,
          is_library: project.isLibrary
        })
        .select()
        .single()

      if (projectError) throw projectError

      // Insert files if any
      if (project.files.length > 0) {
        const filesData = project.files.map((file) => ({
          project_id: projectData.id,
          name: file.name.value,
          content: file.content.value,
          is_main: file.isMain,
          order: file.order
        }))

        const { error: filesError } = await supabase
          .from('project_files')
          .insert(filesData)

        if (filesError) throw filesError
      }

      // Fetch complete project
      const created = await this.findById(projectData.id)
      if (!created) throw new Error('Failed to create project')

      return created
    },

    async update(
      projectId: string,
      updates: Partial<Project>
    ): Promise<Project> {
      const dbUpdates: Partial<{
        name: string
        description: string | null
        thumbnail_path: string | null
        visibility: DbVisibility
        is_library: boolean
        updated_at: string
      }> = {}

      if (updates.name) dbUpdates.name = updates.name.value
      if (updates.description !== undefined)
        dbUpdates.description = updates.description
      if (updates.thumbnailPath !== undefined)
        dbUpdates.thumbnail_path = updates.thumbnailPath
      if (updates.visibility)
        dbUpdates.visibility = updates.visibility.value as DbVisibility
      if (updates.isLibrary !== undefined)
        dbUpdates.is_library = updates.isLibrary

      dbUpdates.updated_at = new Date().toISOString()

      const { error } = await supabase
        .from('projects')
        .update(dbUpdates)
        .eq('id', projectId)

      if (error) throw error

      const updated = await this.findById(projectId)
      if (!updated) throw new Error('Project not found after update')

      return updated
    },

    async delete(projectId: string): Promise<void> {
      // First, get the project to check for thumbnail
      const project = await this.findById(projectId)

      // Delete thumbnail from storage if exists
      if (project?.thumbnailPath) {
        await supabase.storage
          .from('thumbnails')
          .remove([project.thumbnailPath])
      }

      // Then delete the project (cascade will handle files, shares, tags, dependencies)
      const { error } = await supabase
        .from('projects')
        .delete()
        .eq('id', projectId)

      if (error) throw error
    },

    // ========================================================================
    // Files
    // ========================================================================

    async createFile(
      projectId: string,
      file: ProjectFile
    ): Promise<ProjectFile> {
      const { data, error } = await supabase
        .from('project_files')
        .insert({
          id: file.id,
          project_id: projectId,
          name: file.name.value,
          content: file.content.value,
          is_main: file.isMain,
          order: file.order
        })
        .select()
        .single()

      if (error) throw error

      return createProjectFile({
        id: data.id,
        projectId: data.project_id,
        name: createFileName(data.name),
        content: createFileContent(data.content),
        isMain: data.is_main,
        order: data.order,
        createdAt: new Date(data.created_at),
        updatedAt: new Date(data.updated_at)
      })
    },

    async updateFile(
      projectId: string,
      fileId: string,
      updates: Partial<ProjectFile>
    ): Promise<ProjectFile> {
      const dbUpdates: Record<string, unknown> = {}

      if (updates.name) dbUpdates.name = updates.name.value
      if (updates.content) dbUpdates.content = updates.content.value
      if (updates.isMain !== undefined) dbUpdates.is_main = updates.isMain
      if (updates.order !== undefined) dbUpdates.order = updates.order

      // If setting as main, first unset all other main files
      if (updates.isMain === true) {
        await supabase
          .from('project_files')
          .update({ is_main: false })
          .eq('project_id', projectId)
          .neq('id', fileId)
      }

      const { data, error } = await supabase
        .from('project_files')
        .update(dbUpdates)
        .eq('id', fileId)
        .eq('project_id', projectId)
        .select()
        .single()

      if (error) throw error

      return createProjectFile({
        id: data.id,
        projectId: data.project_id,
        name: createFileName(data.name),
        content: createFileContent(data.content),
        isMain: data.is_main,
        order: data.order,
        createdAt: new Date(data.created_at),
        updatedAt: new Date(data.updated_at)
      })
    },

    async deleteFile(projectId: string, fileId: string): Promise<void> {
      const { error } = await supabase
        .from('project_files')
        .delete()
        .eq('id', fileId)
        .eq('project_id', projectId)

      if (error) throw error
    },

    // Note: Link shares (with share_code) are handled by Netlify Blobs, not the database
    // The project_shares table only stores user shares (project_id, user_id)

    async getDependencies(projectId: string): Promise<readonly string[]> {
      const { data, error } = await supabase
        .from('project_dependencies')
        .select('dependency_id')
        .eq('project_id', projectId)

      if (error) throw error
      if (!data) return []

      return data.map((dep) => dep.dependency_id)
    },

    async addDependency(
      projectId: string,
      dependencyId: string
    ): Promise<void> {
      const { error } = await supabase.from('project_dependencies').insert({
        project_id: projectId,
        dependency_id: dependencyId
      })

      if (error) throw error
    },

    async removeDependency(
      projectId: string,
      dependencyId: string
    ): Promise<void> {
      const { error } = await supabase
        .from('project_dependencies')
        .delete()
        .eq('project_id', projectId)
        .eq('dependency_id', dependencyId)

      if (error) throw error
    },

    // ========================================================================
    // Tags
    // ========================================================================

    async getTags(projectId: string): Promise<readonly Tag[]> {
      const { data, error } = await supabase
        .from('project_tags')
        .select(
          `
          tag_id,
          tags (
            id,
            name
          )
        `
        )
        .eq('project_id', projectId)

      if (error) throw error
      if (!data) return []

      return (data as unknown as ProjectTagWithTag[])
        .map((pt) => ({
          id: pt.tags?.id,
          name: pt.tags?.name
        }))
        .filter((t): t is Tag => Boolean(t.id && t.name))
    },

    async getAllTags(): Promise<readonly Tag[]> {
      const { data, error } = await supabase
        .from('tags')
        .select('id, name')
        .order('name')

      if (error) throw error
      if (!data) return []

      return data.map((tag) => ({
        id: tag.id,
        name: tag.name
      }))
    },

    async addTag(projectId: string, tagName: string): Promise<Tag> {
      // Normalize tag name (lowercase, trimmed)
      const normalizedName = tagName.toLowerCase().trim()

      // First, find or create the tag
      let tag: Tag

      const { data: existingTag, error: findError } = await supabase
        .from('tags')
        .select('id, name')
        .eq('name', normalizedName)
        .maybeSingle()

      if (findError) {
        throw findError
      }

      if (existingTag) {
        tag = { id: existingTag.id, name: existingTag.name }
      } else {
        // Create new tag
        const { data: newTag, error: createError } = await supabase
          .from('tags')
          .insert({ name: normalizedName })
          .select('id, name')
          .single()

        if (createError) throw createError
        if (!newTag) throw new Error('Failed to create tag')
        tag = { id: newTag.id, name: newTag.name }
      }

      // Link tag to project
      const { error: linkError } = await supabase.from('project_tags').insert({
        project_id: projectId,
        tag_id: tag.id
      })

      // Ignore duplicate key error (tag already linked)
      if (linkError && linkError.code !== '23505') {
        throw linkError
      }

      return tag
    },

    async removeTag(projectId: string, tagIdOrName: string): Promise<void> {
      // First, check if it's a UUID (tag id) or a name
      const isUuid =
        /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
          tagIdOrName
        )

      let tagId = tagIdOrName

      if (!isUuid) {
        // It's a tag name, find the tag id
        const { data: tag, error: findError } = await supabase
          .from('tags')
          .select('id')
          .eq('name', tagIdOrName.toLowerCase())
          .maybeSingle()

        if (findError) {
          throw findError
        }
        if (!tag) {
          // Tag doesn't exist, nothing to remove
          return
        }
        tagId = tag.id
      }

      const { error } = await supabase
        .from('project_tags')
        .delete()
        .eq('project_id', projectId)
        .eq('tag_id', tagId)

      if (error) throw error
    },

    // ========================================================================
    // User Shares
    // ========================================================================

    async getUserShares(projectId: string): Promise<readonly UserShare[]> {
      const { data, error } = await supabase
        .from('project_shares')
        .select(
          `
          project_id,
          user_id,
          created_at,
          user_profiles!project_shares_user_id_fkey_user_profiles (
            username
          )
        `
        )
        .eq('project_id', projectId)

      if (error) throw error
      if (!data) return []

      return (data as unknown as ShareWithUserProfile[]).map((share) => ({
        projectId: share.project_id,
        userId: share.user_id,
        username: share.user_profiles?.username || 'Unknown',
        createdAt: new Date(share.created_at)
      }))
    },

    async findUserByUsername(
      username: string
    ): Promise<{ id: string; username: string } | null> {
      const { data, error } = await supabase
        .from('user_profiles')
        .select('id, username')
        .eq('username', username.trim().toLowerCase())
        .single()

      if (error) {
        if (error.code === 'PGRST116') {
          // No rows found
          return null
        }
        throw error
      }

      return data ? { id: data.id, username: data.username } : null
    },

    async searchUsers(
      query: string,
      limit = 10
    ): Promise<ReadonlyArray<{ id: string; username: string }>> {
      const trimmedQuery = query.trim().toLowerCase()

      if (!trimmedQuery) {
        return []
      }

      const { data, error } = await supabase
        .from('user_profiles')
        .select('id, username')
        .ilike('username', `${trimmedQuery}%`)
        .order('username')
        .limit(limit)

      if (error) {
        throw error
      }

      return data || []
    },

    async addUserShare(projectId: string, userId: string): Promise<UserShare> {
      // Get the user's username first
      const { data: userProfile, error: profileError } = await supabase
        .from('user_profiles')
        .select('username')
        .eq('id', userId)
        .single()

      if (profileError || !userProfile) {
        throw new Error(`User with id ${userId} not found`)
      }

      const { error } = await supabase.from('project_shares').insert({
        project_id: projectId,
        user_id: userId
      })

      // Ignore duplicate key error (already shared)
      if (error && error.code !== '23505') {
        throw error
      }

      return {
        projectId,
        userId,
        username: userProfile.username,
        createdAt: new Date()
      }
    },

    async removeUserShare(projectId: string, userId: string): Promise<void> {
      const { error } = await supabase
        .from('project_shares')
        .delete()
        .eq('project_id', projectId)
        .eq('user_id', userId)

      if (error) throw error
    }
  }
}
