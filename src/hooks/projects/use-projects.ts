/**
 * React hooks for projects use-cases
 * Provides a clean interface to interact with the domain layer
 *
 * Uses React Query as single source of truth for server state
 * Jotai is used only for UI state (current project ID, current file ID, read-only mode)
 */

import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useSetAtom } from 'jotai'
import { useCallback } from 'react'
import type { Project } from '@/domain/entities/project.entity'
import { PROJECT_ERRORS } from '@/domain/errors/error-messages'
import { container } from '@/infrastructure/container'
import {
  clearConsoleAtom,
  compilationErrorAtom,
  compilationStatusAtom
} from '@/store/editor'
import { triggerEmulatorResetAtom } from '@/store/emulator'
import {
  currentFileIdAtom,
  currentProjectIdAtom,
  isReadOnlyModeAtom,
  viewOnlyProjectAtom
} from '@/store/projects'
import { useUseCase } from '../core'

/**
 * Hook to create a new project
 * Invalidates cache to refresh project lists
 */
export function useCreateProject() {
  const queryClient = useQueryClient()
  const setCurrentProjectId = useSetAtom(currentProjectIdAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)

  const mutation = useMutation({
    mutationFn: async (
      params: Parameters<typeof container.createProject.execute>[0]
    ) => {
      return container.createProject.execute(params)
    },
    onSuccess: (result, variables) => {
      if (result?.project) {
        // Put the new project in the cache so it's immediately available
        queryClient.setQueryData(['project', result.project.id], result.project)
        // Set as current project
        setCurrentProjectId(result.project.id)
        // Set main file as current if exists
        const mainFile = result.project.files.find((f) => f.isMain)
        if (mainFile) {
          setCurrentFileId(mainFile.id)
        }
      }
      // Invalidate projects cache to include new project
      queryClient.invalidateQueries({
        queryKey: ['projects', 'user', variables.userId]
      })
      queryClient.invalidateQueries({ queryKey: ['projects', 'visible'] })
    }
  })

  return {
    create: mutation.mutateAsync,
    loading: mutation.isPending,
    error: mutation.error,
    reset: mutation.reset,
    data: mutation.data
  }
}

/**
 * Hook to update an existing project
 */
export function useUpdateProject() {
  const queryClient = useQueryClient()

  const mutation = useMutation({
    mutationFn: async (
      params: Parameters<typeof container.updateProject.execute>[0]
    ) => {
      const result = await container.updateProject.execute(params)
      return { result, userId: params.userId, projectId: params.projectId }
    },
    onSuccess: ({ result, projectId }) => {
      // Update cache directly with the updated project
      queryClient.setQueryData(['project', projectId], result.project)
    }
  })

  return {
    update: mutation.mutateAsync,
    loading: mutation.isPending,
    error: mutation.error,
    reset: mutation.reset,
    data: mutation.data
  }
}

/**
 * Hook to delete a project
 */
export function useDeleteProject() {
  const queryClient = useQueryClient()

  const mutation = useMutation({
    mutationFn: async ({
      projectId,
      userId
    }: {
      projectId: string
      userId: string
    }) => {
      const result = await container.deleteProject.execute({
        projectId,
        userId
      })
      return { result, userId, projectId }
    },
    onSuccess: ({ userId, projectId }) => {
      // Remove the deleted project from cache (don't refetch it!)
      queryClient.removeQueries({ queryKey: ['project', projectId] })
      // Invalidate lists and force refetch even if not currently active
      queryClient.invalidateQueries({
        queryKey: ['projects', 'user', userId],
        refetchType: 'all'
      })
      queryClient.invalidateQueries({
        queryKey: ['projects', 'visible'],
        refetchType: 'all'
      })
    }
  })

  return {
    deleteProject: mutation.mutateAsync,
    loading: mutation.isPending,
    error: mutation.error,
    reset: mutation.reset,
    data: mutation.data
  }
}

/**
 * Hook to fork (copy) a project
 * Creates a copy of an existing project for the current user
 */
export function useForkProject() {
  const queryClient = useQueryClient()
  const setCurrentProjectId = useSetAtom(currentProjectIdAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)

  const mutation = useMutation({
    mutationFn: async (
      params: Parameters<typeof container.forkProject.execute>[0]
    ) => {
      return container.forkProject.execute(params)
    },
    onSuccess: (result, variables) => {
      if (result?.project) {
        // Put the forked project in the cache
        queryClient.setQueryData(['project', result.project.id], result.project)
        // Set as current project
        setCurrentProjectId(result.project.id)
        // Set main file as current if exists
        const mainFile = result.project.files.find((f) => f.isMain)
        if (mainFile) {
          setCurrentFileId(mainFile.id)
        }
      }
      // Invalidate projects cache to include new project
      queryClient.invalidateQueries({
        queryKey: ['projects', 'user', variables.userId]
      })
      queryClient.invalidateQueries({ queryKey: ['projects', 'visible'] })
    }
  })

  return {
    forkProject: mutation.mutateAsync,
    loading: mutation.isPending,
    error: mutation.error,
    reset: mutation.reset,
    data: mutation.data
  }
}

/**
 * Hook to fetch all projects for a user with caching
 */
export function useGetProjects() {
  const queryClient = useQueryClient()

  const getProjects = useCallback(
    async (userId: string) => {
      const data = await queryClient.fetchQuery({
        queryKey: ['projects', 'user', userId],
        queryFn: async () => {
          const result = await container.getProjects.execute({ userId })
          return result
        }
        // Use default staleTime from QueryClient (5 min) for consistency
      })
      return data
    },
    [queryClient]
  )

  return { getProjects }
}

/**
 * Hook to fetch a single project by ID with caching
 */
export function useGetProject() {
  const queryClient = useQueryClient()

  const getProject = useCallback(
    async (projectId: string, userId?: string) => {
      const data = await queryClient.fetchQuery({
        queryKey: ['project', projectId],
        queryFn: async () => {
          const result = await container.getProject.execute({
            projectId,
            userId
          })
          return result.project
        }
      })
      return { project: data }
    },
    [queryClient]
  )

  return { getProject }
}

/**
 * Hook to fetch a project and update UI state
 * Handles both owner mode (sets as current) and read-only mode (public projects)
 * Data is stored in React Query cache, not Jotai
 */
export function useFetchProject() {
  const { getProject } = useGetProject()
  const setCurrentProjectId = useSetAtom(currentProjectIdAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)
  const setIsReadOnlyMode = useSetAtom(isReadOnlyModeAtom)
  const setViewOnlyProject = useSetAtom(viewOnlyProjectAtom)
  const clearConsole = useSetAtom(clearConsoleAtom)
  const setCompilationStatus = useSetAtom(compilationStatusAtom)
  const setCompilationError = useSetAtom(compilationErrorAtom)
  const triggerEmulatorReset = useSetAtom(triggerEmulatorResetAtom)

  const fetchProject = useCallback(
    async (params: {
      projectId: string
      userId?: string
    }): Promise<Project | null> => {
      const result = await getProject(params.projectId, params.userId)

      if (!result?.project) {
        throw new Error(PROJECT_ERRORS.NOT_FOUND(params.projectId))
      }

      // Clear compilation state and reset emulator when switching projects
      clearConsole()
      setCompilationStatus('idle')
      setCompilationError(null)
      triggerEmulatorReset()

      const isOwner = params.userId && result.project.userId === params.userId

      if (isOwner) {
        // User owns this project - set as current
        setIsReadOnlyMode(false)
        setViewOnlyProject(null)
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
        // Select the main file or first file in read-only mode too
        const mainFile =
          result.project.files?.find((f) => f.isMain) ||
          result.project.files?.[0]
        if (mainFile) {
          setCurrentFileId(mainFile.id)
        } else {
          setCurrentFileId(null)
        }
      }

      return result.project
    },
    [
      getProject,
      setCurrentProjectId,
      setCurrentFileId,
      setIsReadOnlyMode,
      setViewOnlyProject,
      clearConsole,
      setCompilationStatus,
      setCompilationError,
      triggerEmulatorReset
    ]
  )

  return { fetchProject }
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
