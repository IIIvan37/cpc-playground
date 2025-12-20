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
      set(projectsAtom, result.projects)
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
    }
  ) => {
    try {
      const result = await container.updateProject.execute(params)

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
