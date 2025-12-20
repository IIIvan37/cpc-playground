import type { Project, ProjectShare } from '@/domain/entities/project.entity'
import { createProject } from '@/domain/entities/project.entity'
import type { ProjectFile } from '@/domain/entities/project-file.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { supabase } from '@/lib/supabase'

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
    createdAt: new Date(data.created_at),
    updatedAt: new Date(data.updated_at)
  })
}

/**
 * Factory function that creates a Supabase implementation of IProjectsRepository
 * Pure functional approach - returns an object implementing the interface
 */
export function createSupabaseProjectsRepository(): IProjectsRepository {
  return {
    async findAll(userId: string): Promise<readonly Project[]> {
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
          project_dependencies (
            dependency:projects!project_dependencies_dependency_id_fkey (
              id,
              name,
              is_library
            )
          )
        `
        )
        .or(`user_id.eq.${userId},project_shares.user_id.eq.${userId}`)
        .order('updated_at', { ascending: false })

      if (error) throw error
      if (!data) return []

      return data.map((p: any) => mapToDomain(p))
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
          project_dependencies (
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
            project_dependencies (
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
    }
  }
}
