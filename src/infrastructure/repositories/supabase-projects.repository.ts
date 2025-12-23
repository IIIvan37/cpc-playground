import type { SupabaseClient } from '@supabase/supabase-js'
import type {
  DependencyInfo,
  Project,
  ProjectShare,
  UserShare
} from '@/domain/entities/project.entity'
import { createProject } from '@/domain/entities/project.entity'
import type { ProjectFile } from '@/domain/entities/project-file.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import type {
  IProjectsRepository,
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
type ProjectShareRow = Tables<'project_shares'>
type TagRow = Tables<'tags'>

/** DB visibility enum - maps to domain VisibilityValue */
type DbVisibility = Database['public']['Enums']['project_visibility']

/** Result of project query with nested relations */
interface ProjectWithRelations extends ProjectRow {
  project_files: ProjectFileRow[]
  project_shares: ProjectShareRow[]
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
 * Supabase project_shares table result with share_code
 * Note: This assumes the DB schema has share_code column which may not match generated types
 */
interface ProjectShareDbRow {
  id: string
  project_id: string
  share_code: string
  created_at: string
}

/**
 * Map Supabase data to domain entity
 */
function mapToDomain(data: ProjectWithRelations): Project {
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

  // Map shares
  // Note: The DB schema for project_shares may have share_code (production) or not (local)
  // We cast to the expected shape with share_code
  const shares: ProjectShare[] = (
    data.project_shares as unknown as ProjectShareDbRow[]
  ).map((s) => ({
    id: s.id,
    shareCode: s.share_code,
    createdAt: new Date(s.created_at)
  }))

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

  return createProject({
    id: data.id,
    userId: data.user_id,
    authorUsername: null, // Will be enriched separately
    name: createProjectName(data.name),
    description: data.description,
    visibility: createVisibility(data.visibility),
    isLibrary: data.is_library,
    files,
    shares,
    tags,
    dependencies,
    userShares: [], // Loaded separately via getUserShares()
    createdAt: new Date(data.created_at),
    updatedAt: new Date(data.updated_at)
  })
}

/**
 * Enrich projects with author usernames
 * Fetches usernames from user_profiles and updates projects
 */
async function enrichWithAuthorUsernames(
  supabase: SupabaseClient<Database>,
  projects: readonly Project[]
): Promise<readonly Project[]> {
  if (projects.length === 0) return projects

  // Get unique user IDs
  const userIds = [...new Set(projects.map((p) => p.userId))]

  // Fetch all usernames in one query
  const { data: profiles, error } = await supabase
    .from('user_profiles')
    .select('id, username')
    .in('id', userIds)

  if (error) {
    // If we can't fetch usernames, just return projects without them
    console.warn('Failed to fetch author usernames:', error)
    return projects
  }

  // Create a map of userId -> username
  const usernameMap = new Map((profiles || []).map((p) => [p.id, p.username]))

  // Update projects with usernames
  return projects.map((project) =>
    createProject({
      ...project,
      authorUsername: usernameMap.get(project.userId) ?? null
    })
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
  return {
    async findAll(userId: string): Promise<readonly Project[]> {
      const projectSelect = `
        *,
        project_files (*),
        project_shares (*),
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

      // First, get user's own projects
      const { data: ownProjects, error: ownError } = await supabase
        .from('projects')
        .select(projectSelect)
        .eq('user_id', userId)
        .order('updated_at', { ascending: false })

      if (ownError) throw ownError

      // Then, get project IDs shared with this user
      const { data: sharedProjectIds, error: sharedIdsError } = await supabase
        .from('project_shares')
        .select('project_id')
        .eq('user_id', userId)

      if (sharedIdsError) throw sharedIdsError

      // Fetch shared projects if any
      let sharedProjects: ProjectWithRelations[] = []
      if (sharedProjectIds && sharedProjectIds.length > 0) {
        const ids = sharedProjectIds.map((s) => s.project_id)
        const { data, error } = await supabase
          .from('projects')
          .select(projectSelect)
          .in('id', ids)
          .order('updated_at', { ascending: false })

        if (error) throw error
        sharedProjects = data || []
      }

      // Combine and deduplicate (in case user owns a project that's also shared)
      const allProjects: Array<(typeof ownProjects)[number]> = [
        ...(ownProjects || [])
      ]
      const ownIds = new Set(allProjects.map((p) => p.id))
      for (const p of sharedProjects) {
        if (!ownIds.has(p.id)) {
          allProjects.push(p as (typeof ownProjects)[number])
        }
      }

      // Sort by updated_at descending
      allProjects.sort(
        (a, b) =>
          new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime()
      )

      const projects = allProjects.map((p) =>
        mapToDomain(p as unknown as ProjectWithRelations)
      )

      return enrichWithAuthorUsernames(supabase, projects)
    },

    async findVisible(userId?: string): Promise<readonly Project[]> {
      const projectSelect = `
        *,
        project_files (*),
        project_shares (*),
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

      // Simpler select for anonymous users (no user-related joins)
      const anonProjectSelect = `
        *,
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

      // If no user, return only public projects with simpler query
      if (!userId) {
        const { data: publicProjects, error: publicError } = await supabase
          .from('projects')
          .select(anonProjectSelect)
          .eq('visibility', 'public')
          .order('updated_at', { ascending: false })

        if (publicError) throw publicError

        // Map with empty shares for anonymous users
        const projects = (publicProjects || []).map((p) =>
          mapToDomain({
            ...p,
            project_shares: []
          } as unknown as ProjectWithRelations)
        )

        return enrichWithAuthorUsernames(supabase, projects)
      }

      // Get public projects
      const { data: publicProjects, error: publicError } = await supabase
        .from('projects')
        .select(projectSelect)
        .eq('visibility', 'public')
        .order('updated_at', { ascending: false })

      if (publicError) throw publicError

      // Get user's own projects (all visibilities)
      const { data: ownProjects, error: ownError } = await supabase
        .from('projects')
        .select(projectSelect)
        .eq('user_id', userId)
        .order('updated_at', { ascending: false })

      if (ownError) throw ownError

      // Get project IDs shared with this user
      const { data: sharedProjectIds, error: sharedIdsError } = await supabase
        .from('project_shares')
        .select('project_id')
        .eq('user_id', userId)

      if (sharedIdsError) throw sharedIdsError

      // Fetch shared projects if any
      let sharedProjects: ProjectWithRelations[] = []
      if (sharedProjectIds && sharedProjectIds.length > 0) {
        const ids = sharedProjectIds.map((s) => s.project_id)
        const { data, error } = await supabase
          .from('projects')
          .select(projectSelect)
          .in('id', ids)
          .order('updated_at', { ascending: false })

        if (error) throw error
        sharedProjects = data || []
      }

      // Combine and deduplicate
      const allProjects: Array<(typeof publicProjects)[number]> = []
      const seenIds = new Set<string>()

      // Add own projects first
      for (const p of ownProjects || []) {
        if (!seenIds.has(p.id)) {
          seenIds.add(p.id)
          allProjects.push(p)
        }
      }

      // Add shared projects
      for (const p of sharedProjects) {
        if (!seenIds.has(p.id)) {
          seenIds.add(p.id)
          allProjects.push(p as (typeof publicProjects)[number])
        }
      }

      // Add public projects
      for (const p of publicProjects || []) {
        if (!seenIds.has(p.id)) {
          seenIds.add(p.id)
          allProjects.push(p)
        }
      }

      // Sort by updated_at descending
      allProjects.sort(
        (a, b) =>
          new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime()
      )

      const projects = allProjects.map((p) =>
        mapToDomain(p as unknown as ProjectWithRelations)
      )

      return enrichWithAuthorUsernames(supabase, projects)
    },

    async findById(projectId: string): Promise<Project | null> {
      const { data, error } = await supabase
        .from('projects')
        .select(
          `
          *,
          project_files (*),
          project_shares (*),
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

      const project = mapToDomain(data)
      const enriched = await enrichWithAuthorUsernames(supabase, [project])
      return enriched[0] ?? null
    },

    async findByShareCode(shareCode: string): Promise<Project | null> {
      const { data, error } = await supabase
        .from('project_shares')
        .select(
          `
          project:projects (
            *,
            project_files (*),
            project_shares (*),
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

      const project = mapToDomain((data as unknown as ShareWithProject).project)
      const enriched = await enrichWithAuthorUsernames(supabase, [project])
      return enriched[0] ?? null
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
        visibility: DbVisibility
        is_library: boolean
        updated_at: string
      }> = {}

      if (updates.name) dbUpdates.name = updates.name.value
      if (updates.description !== undefined)
        dbUpdates.description = updates.description
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

    async getShares(projectId: string): Promise<readonly ProjectShare[]> {
      const { data, error } = await supabase
        .from('project_shares')
        .select('*')
        .eq('project_id', projectId)

      if (error) throw error
      if (!data) return []

      // Cast to expected shape - DB may have share_code column not in generated types
      return (data as unknown as ProjectShareDbRow[]).map((share) => ({
        id: share.id,
        shareCode: share.share_code,
        createdAt: new Date(share.created_at)
      }))
    },

    async createShare(projectId: string): Promise<ProjectShare> {
      const shareCode = crypto.randomUUID()

      // Cast insert data - DB may have share_code column not in generated types
      const { data, error } = await supabase
        .from('project_shares')
        .insert({
          project_id: projectId,
          share_code: shareCode
        } as unknown as Tables<'project_shares'>)
        .select()
        .single()

      if (error) throw error

      const shareData = data as unknown as ProjectShareDbRow
      return {
        id: shareData.id,
        shareCode: shareData.share_code,
        createdAt: new Date(shareData.created_at)
      }
    },

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
          user_profiles!project_shares_user_id_fkey (
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
