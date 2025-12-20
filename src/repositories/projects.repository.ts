import { supabase } from '@/lib/supabase'
import type { Project } from '@/types/project.types'

/**
 * Database input types (snake_case)
 */
export interface ProjectDbInput {
  user_id: string
  name: string
  description?: string | null
  visibility?: 'private' | 'unlisted' | 'public'
  is_library?: boolean
}

export interface ProjectDbUpdate {
  name?: string
  description?: string | null
  visibility?: 'private' | 'unlisted' | 'public'
  updated_at?: string
}

/**
 * Repository for projects data access
 * Handles all Supabase interactions (no business logic)
 */
class ProjectsRepository {
  /**
   * Find all projects for a user (owned or shared)
   */
  async findAll(userId: string): Promise<Project[]> {
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

    return (data || []).map(this.mapToProject)
  }

  /**
   * Find a single project by ID
   */
  async findById(id: string): Promise<Project | null> {
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
      .eq('id', id)
      .single()

    if (error) {
      if (error.code === 'PGRST116') return null // Not found
      throw error
    }

    return data ? this.mapToProject(data) : null
  }

  /**
   * Create a new project
   */
  async create(input: ProjectDbInput): Promise<Project> {
    const { data, error } = await supabase
      .from('projects')
      .insert(input)
      .select(
        `
        *,
        project_files (*),
        project_shares (*),
        project_tags (
          tags (*)
        )
      `
      )
      .single()

    if (error) throw error

    return this.mapToProject(data)
  }

  /**
   * Update an existing project
   */
  async update(id: string, input: ProjectDbUpdate): Promise<Project> {
    const { data, error } = await supabase
      .from('projects')
      .update({
        ...input,
        updated_at: new Date().toISOString()
      })
      .eq('id', id)
      .select(
        `
        *,
        project_files (*),
        project_shares (*),
        project_tags (
          tags (*)
        )
      `
      )
      .single()

    if (error) throw error

    return this.mapToProject(data)
  }

  /**
   * Delete a project
   */
  async delete(id: string): Promise<void> {
    const { error } = await supabase.from('projects').delete().eq('id', id)

    if (error) throw error
  }

  /**
   * Update project visibility
   */
  async updateVisibility(
    projectId: string,
    visibility: 'private' | 'unlisted' | 'public'
  ): Promise<void> {
    const { error } = await supabase
      .from('projects')
      .update({
        visibility,
        updated_at: new Date().toISOString()
      })
      .eq('id', projectId)

    if (error) throw error
  }

  /**
   * Find user ID by username
   */
  async findUserIdByUsername(username: string): Promise<string | null> {
    const { data, error } = await supabase
      .from('profiles')
      .select('user_id')
      .eq('username', username)
      .single()

    if (error) {
      if (error.code === 'PGRST116') return null // Not found
      throw error
    }

    return data?.user_id || null
  }

  /**
   * Create a project share
   */
  async createShare(projectId: string, userId: string): Promise<void> {
    const { error } = await supabase.from('project_shares').insert({
      project_id: projectId,
      user_id: userId
    })

    if (error) throw error
  }

  /**
   * Delete a project share
   */
  async deleteShare(projectId: string, userId: string): Promise<void> {
    const { error } = await supabase
      .from('project_shares')
      .delete()
      .eq('project_id', projectId)
      .eq('user_id', userId)

    if (error) throw error
  }

  /**
   * Get dependency files for a project
   */
  async findDependencyFiles(projectId: string): Promise<any> {
    const { data, error } = await supabase
      .from('projects')
      .select(
        `
        project_dependencies (
          dependency:projects!project_dependencies_dependency_id_fkey (
            id,
            name,
            is_library,
            project_files (*)
          )
        )
      `
      )
      .eq('id', projectId)
      .single()

    if (error) throw error

    return data
  }

  /**
   * Create a dependency relationship
   */
  async createDependency(
    projectId: string,
    dependencyId: string
  ): Promise<void> {
    const { error } = await supabase.from('project_dependencies').insert({
      project_id: projectId,
      dependency_id: dependencyId
    })

    if (error) throw error
  }

  /**
   * Delete a dependency relationship
   */
  async deleteDependency(
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

  /**
   * Map database row to Project domain type
   */
  private mapToProject(data: any): Project {
    return {
      id: data.id,
      userId: data.user_id,
      name: data.name,
      description: data.description,
      visibility: data.visibility,
      isLibrary: data.is_library,
      files: (data.project_files || []).map((f: any) => ({
        id: f.id,
        projectId: f.project_id,
        name: f.name,
        content: f.content,
        isMain: f.is_main,
        order: f.order,
        createdAt: f.created_at,
        updatedAt: f.updated_at
      })),
      shares:
        data.project_shares?.map((s: any) => ({
          projectId: s.project_id,
          userId: s.user_id,
          createdAt: s.created_at
        })) || [],
      tags:
        data.project_tags?.map((pt: any) => ({
          id: pt.tags.id,
          name: pt.tags.name,
          createdAt: pt.tags.created_at
        })) || [],
      dependencies:
        data.project_dependencies?.map((pd: any) => ({
          id: pd.dependency.id,
          name: pd.dependency.name,
          isLibrary: pd.dependency.is_library
        })) || [],
      createdAt: data.created_at,
      updatedAt: data.updated_at
    }
  }
}

// Export singleton instance
export const projectsRepository = new ProjectsRepository()
