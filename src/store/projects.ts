/**
 * Projects Store - Clean Architecture version
 * Uses use-cases instead of direct Supabase calls
 */

import { atom } from 'jotai'
import type { Project } from '@/domain/entities/project.entity'
import { container } from '@/infrastructure/container'

// ============================================================================
// State Atoms (Simple data holders)
// ============================================================================

export const projectsAtom = atom<Project[]>([])
export const currentProjectIdAtom = atom<string | null>(null)
export const currentFileIdAtom = atom<string | null>(null)

// ============================================================================
// Derived Atoms (Computed values)
// ============================================================================

export const currentProjectAtom = atom((get) => {
  const projects = get(projectsAtom)
  const currentId = get(currentProjectIdAtom)
  return projects.find((p) => p.id === currentId) ?? null
})

export const currentFileAtom = atom((get) => {
  const project = get(currentProjectAtom)
  const currentFileId = get(currentFileIdAtom)
  return project?.files.find((f) => f.id === currentFileId) ?? null
})

export const mainFileAtom = atom((get) => {
  const project = get(currentProjectAtom)
  return project?.files.find((f) => f.isMain) ?? null
})

// ============================================================================
// Action Atoms (Side effects via use-cases)
// ============================================================================

/**
 * Fetch all projects for the current user
 */
export const fetchProjectsAtom = atom(
  null,
  async (_get, set, userId: string) => {
    try {
      const result = await container.getProjects.execute({ userId })
      set(projectsAtom, [...result.projects])
    } catch (error) {
      console.error('Failed to fetch projects:', error)
      throw error
    }
  }
)

/**
 * Fetch a single project by ID
 */
export const fetchProjectAtom = atom(
  null,
  async (_get, set, params: { projectId: string; userId: string }) => {
    try {
      const result = await container.getProject.execute(params)

      if (!result.project) {
        throw new Error('Project not found')
      }

      // Update the project in the list or add it
      set(projectsAtom, (prev) => {
        const index = prev.findIndex((p) => p.id === result.project.id)
        if (index >= 0) {
          const updated = [...prev]
          updated[index] = result.project
          return updated
        }
        return [...prev, result.project]
      })

      return result.project
    } catch (error) {
      console.error('Failed to fetch project:', error)
      throw error
    }
  }
)

/**
 * Fetch a project with all its dependencies files
 * Returns an array of files from the project and all dependencies
 */
export const fetchProjectWithDependenciesAtom = atom(
  null,
  async (_get, _set, params: { projectId: string; userId: string }) => {
    try {
      const result = await container.getProjectWithDependencies.execute(params)
      return result.files
    } catch (error) {
      console.error('Failed to fetch project with dependencies:', error)
      throw error
    }
  }
)

/**
 * Create a new project
 */
export const createProjectAtom = atom(
  null,
  async (
    _get,
    set,
    params: {
      userId: string
      name: string
      visibility?: 'public' | 'private'
      files?: Array<{ name: string; content: string; isMain: boolean }>
    }
  ) => {
    try {
      const result = await container.createProject.execute(params)

      // Add to projects list
      set(projectsAtom, (prev) => [...prev, result.project])

      // Set as current project
      set(currentProjectIdAtom, result.project.id)

      // Set main file as current if exists
      const mainFile = result.project.files.find((f) => f.isMain)
      if (mainFile) {
        set(currentFileIdAtom, mainFile.id)
      }

      return result.project
    } catch (error) {
      console.error('Failed to create project:', error)
      throw error
    }
  }
)

/**
 * Update an existing project
 */
export const updateProjectAtom = atom(
  null,
  async (
    _get,
    set,
    params: {
      projectId: string
      userId: string
      name?: string
      description?: string | null
      visibility?: 'public' | 'private'
      isLibrary?: boolean
    }
  ) => {
    try {
      const { projectId, userId, ...updates } = params
      const result = await container.updateProject.execute({
        projectId,
        userId,
        updates
      })

      // Update in projects list
      set(projectsAtom, (prev) =>
        prev.map((p) => (p.id === result.project.id ? result.project : p))
      )

      return result.project
    } catch (error) {
      console.error('Failed to update project:', error)
      throw error
    }
  }
)

/**
 * Delete a project
 */
export const deleteProjectAtom = atom(
  null,
  async (get, set, params: { projectId: string; userId: string }) => {
    try {
      await container.deleteProject.execute(params)

      // Remove from projects list
      set(projectsAtom, (prev) => prev.filter((p) => p.id !== params.projectId))

      // Clear current project if it was deleted
      const currentId = get(currentProjectIdAtom)
      if (currentId === params.projectId) {
        set(currentProjectIdAtom, null)
        set(currentFileIdAtom, null)
      }
    } catch (error) {
      console.error('Failed to delete project:', error)
      throw error
    }
  }
)

/**
 * Set the current project
 */
export const setCurrentProjectAtom = atom(
  null,
  (get, set, projectId: string | null) => {
    set(currentProjectIdAtom, projectId)

    if (projectId) {
      // Set the main file as current
      const projects = get(projectsAtom)
      const project = projects.find((p) => p.id === projectId)
      const mainFile = project?.files.find((f) => f.isMain)
      set(currentFileIdAtom, mainFile?.id ?? null)
    } else {
      set(currentFileIdAtom, null)
    }
  }
)

/**
 * Set the current file
 */
export const setCurrentFileAtom = atom(
  null,
  (_get, set, fileId: string | null) => {
    set(currentFileIdAtom, fileId)
  }
)

// ============================================================================
// File Action Atoms
// ============================================================================

/**
 * Create a new file in a project
 */
export const createFileAtom = atom(
  null,
  async (
    get,
    set,
    params: {
      projectId: string
      userId: string
      name: string
      content?: string
      isMain?: boolean
    }
  ) => {
    try {
      const result = await container.createFile.execute(params)

      // Update project in the list with the new file
      set(projectsAtom, (prev) =>
        prev.map((p) => {
          if (p.id === params.projectId) {
            return { ...p, files: [...p.files, result.file] }
          }
          return p
        })
      )

      // Set as current file if it's main or if no current file
      const currentFileId = get(currentFileIdAtom)
      if (result.file.isMain || !currentFileId) {
        set(currentFileIdAtom, result.file.id)
      }

      return result.file
    } catch (error) {
      console.error('Failed to create file:', error)
      throw error
    }
  }
)

/**
 * Update a file
 */
export const updateFileAtom = atom(
  null,
  async (
    _get,
    set,
    params: {
      projectId: string
      userId: string
      fileId: string
      name?: string
      content?: string
      isMain?: boolean
    }
  ) => {
    try {
      const result = await container.updateFile.execute(params)

      // Update project in the list with the updated file
      set(projectsAtom, (prev) =>
        prev.map((p) => {
          if (p.id === params.projectId) {
            return {
              ...p,
              files: p.files.map((f) =>
                f.id === result.file.id ? result.file : f
              )
            }
          }
          return p
        })
      )

      return result.file
    } catch (error) {
      console.error('Failed to update file:', error)
      throw error
    }
  }
)

/**
 * Delete a file
 */
export const deleteFileAtom = atom(
  null,
  async (
    get,
    set,
    params: {
      projectId: string
      userId: string
      fileId: string
    }
  ) => {
    try {
      await container.deleteFile.execute(params)

      // Update project in the list, removing the file
      set(projectsAtom, (prev) =>
        prev.map((p) => {
          if (p.id === params.projectId) {
            return {
              ...p,
              files: p.files.filter((f) => f.id !== params.fileId)
            }
          }
          return p
        })
      )

      // Clear current file if it was deleted
      const currentFileId = get(currentFileIdAtom)
      if (currentFileId === params.fileId) {
        // Set main file as current
        const projects = get(projectsAtom)
        const project = projects.find((p) => p.id === params.projectId)
        const mainFile = project?.files.find((f) => f.isMain)
        set(currentFileIdAtom, mainFile?.id ?? null)
      }

      return true
    } catch (error) {
      console.error('Failed to delete file:', error)
      throw error
    }
  }
)

/**
 * Set a file as the main file
 */
export const setMainFileAtom = atom(
  null,
  async (
    _get,
    set,
    params: {
      projectId: string
      userId: string
      fileId: string
    }
  ) => {
    try {
      await container.updateFile.execute({
        ...params,
        isMain: true
      })

      // Update project in the list
      set(projectsAtom, (prev) =>
        prev.map((p) => {
          if (p.id === params.projectId) {
            return {
              ...p,
              files: p.files.map((f) => ({
                ...f,
                isMain: f.id === params.fileId
              }))
            }
          }
          return p
        })
      )
    } catch (error) {
      console.error('Failed to set main file:', error)
      throw error
    }
  }
)

// ============================================================================
// Tags Management (TODO: Implement with proper use-cases)
// ============================================================================

/**
 * Add a tag to a project
 * TODO: Create add-tag.use-case.ts and wire through container
 */
export const addTagToProjectAtom = atom(
  null,
  async (_get, _set, _params: { projectId: string; tagName: string }) => {
    console.warn('addTagToProjectAtom: Not yet implemented')
    throw new Error('Tags feature not yet implemented in Clean Architecture')
  }
)

/**
 * Remove a tag from a project
 * TODO: Create remove-tag.use-case.ts and wire through container
 */
export const removeTagFromProjectAtom = atom(
  null,
  async (_get, _set, _params: { projectId: string; tagId: string }) => {
    console.warn('removeTagFromProjectAtom: Not yet implemented')
    throw new Error('Tags feature not yet implemented in Clean Architecture')
  }
)

// ============================================================================
// Dependencies Management (TODO: Implement with proper use-cases)
// ============================================================================

/**
 * Add a dependency to a project
 * TODO: Create add-dependency.use-case.ts and wire through container
 */
export const addDependencyToProjectAtom = atom(
  null,
  async (_get, _set, _params: { projectId: string; dependencyId: string }) => {
    console.warn('addDependencyToProjectAtom: Not yet implemented')
    throw new Error(
      'Dependencies feature not yet implemented in Clean Architecture'
    )
  }
)

/**
 * Remove a dependency from a project
 * TODO: Create remove-dependency.use-case.ts and wire through container
 */
export const removeDependencyFromProjectAtom = atom(
  null,
  async (_get, _set, _params: { projectId: string; dependencyId: string }) => {
    console.warn('removeDependencyFromProjectAtom: Not yet implemented')
    throw new Error(
      'Dependencies feature not yet implemented in Clean Architecture'
    )
  }
)

// ============================================================================
// Shares Management (TODO: Implement with proper use-cases)
// ============================================================================

// NOTE: Shares functionality requires direct Supabase calls for now
// as it involves user lookups and complex authorization
// This will be refactored when auth use-cases are implemented
