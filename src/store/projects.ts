/**
 * Projects Store - Clean Architecture version
 * Uses use-cases instead of direct Supabase calls
 */

import { atom } from 'jotai'
import type { Project } from '@/domain/entities/project.entity'
import { FILE_ERRORS, PROJECT_ERRORS } from '@/domain/errors/error-messages'
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
        throw new Error(PROJECT_ERRORS.NOT_FOUND(params.projectId))
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
      isLibrary?: boolean
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
 * Note: Library projects cannot have a main file
 */
export const setMainFileAtom = atom(
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
      // Check if project is a library
      const projects = get(projectsAtom)
      const project = projects.find((p) => p.id === params.projectId)
      if (project?.isLibrary) {
        throw new Error(FILE_ERRORS.LIBRARY_NO_MAIN)
      }

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
// Tags Management
// ============================================================================

/**
 * Add a tag to a project
 */
export const addTagToProjectAtom = atom(
  null,
  async (get, set, params: { projectId: string; tagName: string }) => {
    const { projectId, tagName } = params

    // Get current project to obtain userId
    const projects = get(projectsAtom)
    const project = projects.find((p) => p.id === projectId)
    if (!project) {
      throw new Error(PROJECT_ERRORS.NOT_FOUND(projectId))
    }

    const { tag } = await container.addTag.execute({
      projectId,
      userId: project.userId,
      tagName
    })

    // Update local state - add tag to project
    set(projectsAtom, (prev) =>
      prev.map((p) =>
        p.id === projectId ? { ...p, tags: [...p.tags, tag.name] } : p
      )
    )

    return tag
  }
)

/**
 * Remove a tag from a project
 */
export const removeTagFromProjectAtom = atom(
  null,
  async (get, set, params: { projectId: string; tagName: string }) => {
    const { projectId, tagName } = params

    // Get current project to obtain userId
    const projects = get(projectsAtom)
    const project = projects.find((p) => p.id === projectId)
    if (!project) {
      throw new Error(PROJECT_ERRORS.NOT_FOUND(projectId))
    }

    await container.removeTag.execute({
      projectId,
      userId: project.userId,
      tagIdOrName: tagName
    })

    // Update local state - remove tag from project
    set(projectsAtom, (prev) =>
      prev.map((p) =>
        p.id === projectId
          ? { ...p, tags: p.tags.filter((t) => t !== tagName) }
          : p
      )
    )
  }
)

// ============================================================================
// Dependencies Management
// ============================================================================

/**
 * Type for dependency files grouped by project
 */
export type DependencyProject = {
  id: string
  name: string
  files: Array<{
    id: string
    name: string
    content: string
    projectId: string
  }>
}

/**
 * Atom to store dependency files grouped by project
 */
export const dependencyFilesAtom = atom<DependencyProject[]>([])

/**
 * Fetch dependency files for the current project
 * Groups files by their parent project
 */
export const fetchDependencyFilesAtom = atom(null, async (get, set) => {
  const currentProjectId = get(currentProjectIdAtom)
  const projects = get(projectsAtom)
  const currentProject = projects.find((p) => p.id === currentProjectId)

  if (!currentProject || currentProject.dependencies.length === 0) {
    set(dependencyFilesAtom, [])
    return []
  }

  try {
    const result = await container.getProjectWithDependencies.execute({
      projectId: currentProject.id,
      userId: currentProject.userId
    })

    // Group files by project (excluding the current project's files)
    const projectsMap = new Map<string, DependencyProject>()

    for (const file of result.files) {
      // Skip files from the current project
      if (file.projectId === currentProjectId) continue

      if (!projectsMap.has(file.projectId)) {
        projectsMap.set(file.projectId, {
          id: file.projectId,
          name: file.projectName,
          files: []
        })
      }

      projectsMap.get(file.projectId)!.files.push({
        id: file.id,
        name: file.name,
        content: file.content,
        projectId: file.projectId
      })
    }

    const dependencyProjects = Array.from(projectsMap.values())
    set(dependencyFilesAtom, dependencyProjects)
    return dependencyProjects
  } catch (error) {
    console.error('Failed to fetch dependency files:', error)
    set(dependencyFilesAtom, [])
    return []
  }
})

/**
 * Add a dependency to a project
 */
export const addDependencyToProjectAtom = atom(
  null,
  async (get, set, params: { projectId: string; dependencyId: string }) => {
    const { projectId, dependencyId } = params

    // Get current project to obtain userId
    const projects = get(projectsAtom)
    const project = projects.find((p) => p.id === projectId)
    if (!project) {
      throw new Error(PROJECT_ERRORS.NOT_FOUND(projectId))
    }

    await container.addDependency.execute({
      projectId,
      userId: project.userId,
      dependencyId
    })

    // Update local state - add dependency to project
    set(projectsAtom, (prev) =>
      prev.map((p) =>
        p.id === projectId
          ? { ...p, dependencies: [...p.dependencies, dependencyId] }
          : p
      )
    )
  }
)

/**
 * Remove a dependency from a project
 */
export const removeDependencyFromProjectAtom = atom(
  null,
  async (get, set, params: { projectId: string; dependencyId: string }) => {
    const { projectId, dependencyId } = params

    // Get current project to obtain userId
    const projects = get(projectsAtom)
    const project = projects.find((p) => p.id === projectId)
    if (!project) {
      throw new Error(PROJECT_ERRORS.NOT_FOUND(projectId))
    }

    await container.removeDependency.execute({
      projectId,
      userId: project.userId,
      dependencyId
    })

    // Update local state - remove dependency from project
    set(projectsAtom, (prev) =>
      prev.map((p) =>
        p.id === projectId
          ? {
              ...p,
              dependencies: p.dependencies.filter((d) => d !== dependencyId)
            }
          : p
      )
    )
  }
)

// ============================================================================
// Shares Management
// ============================================================================

/**
 * Add a user share to a project
 */
export const addUserShareToProjectAtom = atom(
  null,
  async (get, set, params: { projectId: string; username: string }) => {
    const { projectId, username } = params

    // Get current project to obtain userId
    const projects = get(projectsAtom)
    const project = projects.find((p) => p.id === projectId)
    if (!project) {
      throw new Error(PROJECT_ERRORS.NOT_FOUND(projectId))
    }

    const { share } = await container.addUserShare.execute({
      projectId,
      userId: project.userId,
      username
    })

    // Update local state - add share to project
    set(projectsAtom, (prev) =>
      prev.map((p) =>
        p.id === projectId
          ? {
              ...p,
              userShares: [...(p.userShares || []), share]
            }
          : p
      )
    )

    return share
  }
)

/**
 * Remove a user share from a project
 */
export const removeUserShareFromProjectAtom = atom(
  null,
  async (get, set, params: { projectId: string; targetUserId: string }) => {
    const { projectId, targetUserId } = params

    // Get current project to obtain userId
    const projects = get(projectsAtom)
    const project = projects.find((p) => p.id === projectId)
    if (!project) {
      throw new Error(PROJECT_ERRORS.NOT_FOUND(projectId))
    }

    await container.removeUserShare.execute({
      projectId,
      userId: project.userId,
      targetUserId
    })

    // Update local state - remove share from project
    set(projectsAtom, (prev) =>
      prev.map((p) =>
        p.id === projectId
          ? {
              ...p,
              userShares: (p.userShares || []).filter(
                (s) => s.userId !== targetUserId
              )
            }
          : p
      )
    )
  }
)
