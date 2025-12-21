// TODO: Remove @ts-nocheck - Fix Supabase types by properly typing complex queries with relations
// The issue is with queries that include nested relations (project_files, project_shares, etc.)
// Need to either: 1) Generate proper types from Supabase schema, or 2) Use explicit type assertions
// @ts-nocheck
import type { SupabaseClient } from '@supabase/supabase-js'
import type {
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
import type { Database } from '@/types/database.types'

/**
 * Map Supabase data to domain entity
 */
function mapToDomain(data: any): Project {
  // Map files
  const files: ProjectFile[] = (data.project_files || []).map((f: any) =>
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
  const shares: ProjectShare[] = (data.project_shares || []).map((s: any) => ({
    id: s.id,
    shareCode: s.share_code,
    createdAt: new Date(s.created_at)
  }))

  // Map tags
  const tags: string[] = (data.project_tags || [])
    .map((pt: any) => pt.tags?.name || '')
    .filter(Boolean)

  // Map dependencies
  const dependencies: string[] = (data.project_dependencies || [])
    .map((pd: any) => pd.dependency?.id || '')
    .filter(Boolean)

  return createProject({
    id: data.id,
    userId: data.user_id,
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
      let sharedProjects: any[] = []
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
      const allProjects = [...(ownProjects || [])]
      const ownIds = new Set(allProjects.map((p) => p.id))
      for (const p of sharedProjects) {
        if (!ownIds.has(p.id)) {
          allProjects.push(p)
        }
      }

      // Sort by updated_at descending
      allProjects.sort(
        (a, b) =>
          new Date(b.updated_at).getTime() - new Date(a.updated_at).getTime()
      )

      return allProjects.map((p: any) => mapToDomain(p))
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

      return mapToDomain(data)
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

      return mapToDomain((data as any).project)
    },

    async create(project: Project): Promise<Project> {
      // Insert project
      const { data: projectData, error: projectError } = await supabase
        .from('projects')
        .insert({
          user_id: project.userId,
          name: project.name.value,
          description: project.description,
          visibility: project.visibility.value,
          is_library: project.isLibrary
        } as any)
        .select()
        .single()

      if (projectError) throw projectError

      // Insert files if any
      if (project.files.length > 0) {
        const filesData = project.files.map((file) => ({
          project_id: (projectData as any).id,
          name: file.name.value,
          content: file.content.value,
          is_main: file.isMain,
          order: file.order
        }))

        const { error: filesError } = await supabase
          .from('project_files')
          .insert(filesData as any)

        if (filesError) throw filesError
      }

      // Fetch complete project
      const created = await this.findById((projectData as any).id)
      if (!created) throw new Error('Failed to create project')

      return created
    },

    async update(
      projectId: string,
      updates: Partial<Project>
    ): Promise<Project> {
      const dbUpdates: any = {}

      if (updates.name) dbUpdates.name = updates.name.value
      if (updates.description !== undefined)
        dbUpdates.description = updates.description
      if (updates.visibility) dbUpdates.visibility = updates.visibility.value
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

      return {
        id: data.id,
        projectId: data.project_id,
        name: createFileName(data.name),
        content: createFileContent(data.content),
        isMain: data.is_main,
        order: data.order
      }
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

      return {
        id: data.id,
        projectId: data.project_id,
        name: createFileName(data.name),
        content: createFileContent(data.content),
        isMain: data.is_main,
        order: data.order
      }
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

      return data.map((share: any) => ({
        id: share.id,
        shareCode: share.share_code,
        createdAt: new Date(share.created_at)
      }))
    },

    async createShare(projectId: string): Promise<ProjectShare> {
      const shareCode = crypto.randomUUID()

      const { data, error } = await supabase
        .from('project_shares')
        .insert({
          project_id: projectId,
          share_code: shareCode
        } as any)
        .select()
        .single()

      if (error) throw error

      return {
        id: (data as any).id,
        shareCode: (data as any).share_code,
        createdAt: new Date((data as any).created_at)
      }
    },

    async getDependencies(projectId: string): Promise<readonly string[]> {
      const { data, error } = await supabase
        .from('project_dependencies')
        .select('dependency_id')
        .eq('project_id', projectId)

      if (error) throw error
      if (!data) return []

      return data.map((dep: any) => dep.dependency_id)
    },

    async addDependency(
      projectId: string,
      dependencyId: string
    ): Promise<void> {
      const { error } = await supabase.from('project_dependencies').insert({
        project_id: projectId,
        dependency_id: dependencyId
      } as any)

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

      return data
        .map((pt: any) => ({
          id: pt.tags?.id,
          name: pt.tags?.name
        }))
        .filter((t: any) => t.id && t.name)
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
        .single()

      if (findError && findError.code !== 'PGRST116') {
        throw findError
      }

      if (existingTag) {
        tag = { id: existingTag.id, name: existingTag.name }
      } else {
        // Create new tag
        const { data: newTag, error: createError } = await supabase
          .from('tags')
          .insert({ name: normalizedName } as any)
          .select('id, name')
          .single()

        if (createError) throw createError
        tag = { id: (newTag as any).id, name: (newTag as any).name }
      }

      // Link tag to project
      const { error: linkError } = await supabase.from('project_tags').insert({
        project_id: projectId,
        tag_id: tag.id
      } as any)

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
          .single()

        if (findError || !tag) {
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

      return data.map((share: any) => ({
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
      } as any)

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
