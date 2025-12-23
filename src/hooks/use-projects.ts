/**
 * React hooks for projects use-cases
 * Provides a clean interface to interact with the domain layer
 *
 * Uses the generic useUseCase hook to reduce boilerplate
 */

import { useCallback } from 'react'
import { container } from '@/infrastructure/container'
import { useUseCase } from './use-use-case'

/**
 * Hook to create a new project
 */
export function useCreateProject() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.createProject
  )
  return { create: execute, loading, error, reset, data }
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
    (projectId: string, userId: string) => execute({ projectId, userId }),
    [execute]
  )

  return { getProject, loading, error, reset, data }
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
