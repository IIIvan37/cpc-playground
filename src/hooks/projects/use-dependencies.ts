/**
 * React hooks for dependency use-cases
 * Provides a clean interface to interact with the domain layer
 */

import { useMutation, useQueryClient } from '@tanstack/react-query'
import type { Project } from '@/domain/entities/project.entity'
import { createLogger } from '@/lib/logger'

const logger = createLogger('Dependencies')

import { useSetAtom } from 'jotai'
import { useCallback } from 'react'
import { container } from '@/infrastructure/container'
import { type DependencyProject, dependencyFilesAtom } from '@/store/projects'
import { useAuth } from '../auth'
import { invalidateProjectCaches } from './invalidate-project-caches'
import { useActiveProject } from './use-current-project'

/**
 * Hook to add a dependency to a project
 */
export function useAddDependency() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({
      projectId,
      userId,
      dependencyId,
      dependencyName
    }: {
      projectId: string
      userId: string
      dependencyId: string
      dependencyName: string
    }) => {
      const result = await container.addDependency.execute({
        projectId,
        userId,
        dependencyId
      })
      return {
        result,
        userId,
        projectId,
        dependency: { id: dependencyId, name: dependencyName }
      }
    },
    onSuccess: ({ projectId, dependency }) => {
      // Update the project in cache directly to add the new dependency
      queryClient.setQueryData<Project>(
        ['project', projectId],
        (oldProject) => {
          if (!oldProject) return oldProject
          return {
            ...oldProject,
            dependencies: [...(oldProject.dependencies || []), dependency]
          }
        }
      )
    }
  })
}

/**
 * Hook to remove a dependency from a project
 */
export function useRemoveDependency() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({
      projectId,
      userId,
      dependencyId
    }: {
      projectId: string
      userId: string
      dependencyId: string
    }) => {
      const result = await container.removeDependency.execute({
        projectId,
        userId,
        dependencyId
      })
      return { result, userId, projectId, dependencyId }
    },
    onSuccess: ({ userId, projectId, dependencyId }) => {
      // Update the project in cache directly to remove the dependency
      queryClient.setQueryData<Project>(
        ['project', projectId],
        (oldProject) => {
          if (!oldProject) return oldProject
          return {
            ...oldProject,
            dependencies: (oldProject.dependencies || []).filter(
              (dep) => dep.id !== dependencyId
            )
          }
        }
      )
      invalidateProjectCaches(queryClient, { userId })
    }
  })
}

/**
 * Pending dependency fetch promises by project ID
 * Used to deduplicate concurrent fetches for dependencies
 */
const pendingDependencyFetches = new Map<string, Promise<DependencyProject[]>>()

/**
 * Hook to fetch dependency files for the current project
 * Groups files by their parent project
 * Uses manual deduplication to prevent multiple concurrent fetches
 */
export function useFetchDependencyFiles() {
  const { activeProject } = useActiveProject()
  const { user } = useAuth()
  const setDependencyFiles = useSetAtom(dependencyFilesAtom)

  // Extract stable values from activeProject to avoid reference changes
  const projectId = activeProject?.id
  const hasDependencies = (activeProject?.dependencies?.length ?? 0) > 0

  const fetchDependencyFiles = useCallback(async (): Promise<
    DependencyProject[]
  > => {
    if (!projectId || !hasDependencies) {
      setDependencyFiles([])
      return []
    }

    // Check if there's already a pending fetch for this project's dependencies
    const pendingKey = `${projectId}:${user?.id ?? ''}`
    const pendingFetch = pendingDependencyFetches.get(pendingKey)
    if (pendingFetch) {
      // Wait for the existing fetch to complete
      return pendingFetch
    }

    // Create a new fetch promise
    const fetchPromise = (async () => {
      try {
        const result = await container.getProjectWithDependencies.execute({
          projectId,
          userId: user?.id
        })

        // Group files by project (excluding the current project's files)
        const projectsMap = new Map<string, DependencyProject>()

        for (const file of result.files) {
          // Skip files from the current project
          if (file.projectId === projectId) continue

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
        setDependencyFiles(dependencyProjects)
        return dependencyProjects
      } catch (error) {
        logger.error('Failed to fetch dependency files:', error)
        setDependencyFiles([])
        return []
      }
    })()

    // Store the pending promise
    pendingDependencyFetches.set(pendingKey, fetchPromise)

    try {
      return await fetchPromise
    } finally {
      // Clean up the pending promise
      pendingDependencyFetches.delete(pendingKey)
    }
  }, [projectId, hasDependencies, setDependencyFiles, user?.id])

  return { fetchDependencyFiles }
}
