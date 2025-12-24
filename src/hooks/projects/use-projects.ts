/**
 * React hooks for projects use-cases
 * Provides a clean interface to interact with the domain layer
 *
 * Uses the generic useUseCase hook to reduce boilerplate
 * Hooks automatically update the global Jotai state after mutations
 */

import { useSetAtom } from 'jotai'
import { useCallback } from 'react'
import type { Project } from '@/domain/entities/project.entity'
import { PROJECT_ERRORS } from '@/domain/errors/error-messages'
import { container } from '@/infrastructure/container'
import {
  currentFileIdAtom,
  currentProjectIdAtom,
  isReadOnlyModeAtom,
  projectsAtom,
  viewOnlyProjectAtom
} from '@/store/projects'
import { useUseCase } from '../core'

/**
 * Hook to create a new project
 * Automatically updates the global projects state
 */
export function useCreateProject() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.createProject
  )
  const setProjects = useSetAtom(projectsAtom)
  const setCurrentProjectId = useSetAtom(currentProjectIdAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)

  const create = useCallback(
    async (params: Parameters<typeof execute>[0]) => {
      const result = await execute(params)
      if (result?.project) {
        // Add to projects list
        setProjects((prev) => [...prev, result.project])
        // Set as current project
        setCurrentProjectId(result.project.id)
        // Set main file as current if exists
        const mainFile = result.project.files.find((f) => f.isMain)
        if (mainFile) {
          setCurrentFileId(mainFile.id)
        }
      }
      return result
    },
    [execute, setProjects, setCurrentProjectId, setCurrentFileId]
  )

  return { create, loading, error, reset, data }
}

/**
 * Hook to update an existing project
 */
export function useUpdateProject() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.updateProject
  )
  return { update: execute, loading, error, reset, data }
}

/**
 * Hook to delete a project
 */
export function useDeleteProject() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.deleteProject
  )

  const deleteProject = useCallback(
    (projectId: string, userId: string) => execute({ projectId, userId }),
    [execute]
  )

  return { deleteProject, loading, error, reset, data }
}

/**
 * Hook to fetch all projects for a user
 */
export function useGetProjects() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.getProjects
  )

  const getProjects = useCallback(
    (userId: string) => execute({ userId }),
    [execute]
  )

  return { getProjects, loading, error, reset, data }
}

/**
 * Hook to fetch a single project by ID
 */
export function useGetProject() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.getProject
  )

  const getProject = useCallback(
    (projectId: string, userId?: string) => execute({ projectId, userId }),
    [execute]
  )

  return { getProject, loading, error, reset, data }
}

/**
 * Hook to fetch a project and update global state
 * Handles both owner mode (adds to projects list) and read-only mode (public projects)
 */
export function useFetchProject() {
  const { getProject, loading, error, reset, data } = useGetProject()
  const setProjects = useSetAtom(projectsAtom)
  const setCurrentProjectId = useSetAtom(currentProjectIdAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)
  const setIsReadOnlyMode = useSetAtom(isReadOnlyModeAtom)
  const setViewOnlyProject = useSetAtom(viewOnlyProjectAtom)

  const fetchProject = useCallback(
    async (params: {
      projectId: string
      userId?: string
    }): Promise<Project | null> => {
      const result = await getProject(params.projectId, params.userId)

      if (!result?.project) {
        throw new Error(PROJECT_ERRORS.NOT_FOUND(params.projectId))
      }

      const isOwner = params.userId && result.project.userId === params.userId

      if (isOwner) {
        // User owns this project - add to their list and set as current
        setIsReadOnlyMode(false)
        setViewOnlyProject(null)
        setProjects((prev) => {
          const index = prev.findIndex((p) => p.id === result.project.id)
          if (index >= 0) {
            const updated = [...prev]
            updated[index] = result.project
            return updated
          }
          return [...prev, result.project]
        })
        // Set the project as the current project
        setCurrentProjectId(result.project.id)
        // Select the main file or first file
        const mainFile =
          result.project.files.find((f) => f.isMain) || result.project.files[0]
        if (mainFile) {
          setCurrentFileId(mainFile.id)
        }
      } else {
        // User is viewing someone else's public project - read-only mode
        setIsReadOnlyMode(true)
        setViewOnlyProject(result.project)
        setCurrentProjectId(null)
        setCurrentFileId(null)
      }

      return result.project
    },
    [
      getProject,
      setProjects,
      setCurrentProjectId,
      setCurrentFileId,
      setIsReadOnlyMode,
      setViewOnlyProject
    ]
  )

  return { fetchProject, loading, error, reset, data }
}

/**
 * Hook to fetch a project with all its dependencies
 */
export function useGetProjectWithDependencies() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.getProjectWithDependencies
  )
  return { getProjectWithDependencies: execute, loading, error, reset, data }
}
