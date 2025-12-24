/**
 * React hooks for dependency use-cases
 * Provides a clean interface to interact with the domain layer
 */

import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useSetAtom } from 'jotai'
import { useCallback } from 'react'
import { container } from '@/infrastructure/container'
import { type DependencyProject, dependencyFilesAtom } from '@/store/projects'
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
      dependencyId
    }: {
      projectId: string
      userId: string
      dependencyId: string
    }) => {
      const result = await container.addDependency.execute({
        projectId,
        userId,
        dependencyId
      })
      return { result, userId, projectId }
    },
    onSuccess: ({ projectId }) => {
      queryClient.invalidateQueries({ queryKey: ['project', projectId] })
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
      return { result, userId, projectId }
    },
    onSuccess: ({ userId, projectId }) => {
      queryClient.invalidateQueries({ queryKey: ['project', projectId] })
      queryClient.invalidateQueries({ queryKey: ['projects', 'user', userId] })
      queryClient.invalidateQueries({ queryKey: ['projects', 'visible'] })
    }
  })
}

/**
 * Hook to fetch dependency files for the current project
 * Groups files by their parent project
 */
export function useFetchDependencyFiles() {
  const { activeProject } = useActiveProject()
  const setDependencyFiles = useSetAtom(dependencyFilesAtom)

  const fetchDependencyFiles = useCallback(async (): Promise<
    DependencyProject[]
  > => {
    if (!activeProject || activeProject.dependencies.length === 0) {
      setDependencyFiles([])
      return []
    }

    try {
      const result = await container.getProjectWithDependencies.execute({
        projectId: activeProject.id,
        userId: activeProject.userId
      })

      // Group files by project (excluding the current project's files)
      const projectsMap = new Map<string, DependencyProject>()

      for (const file of result.files) {
        // Skip files from the current project
        if (file.projectId === activeProject.id) continue

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
      console.error('Failed to fetch dependency files:', error)
      setDependencyFiles([])
      return []
    }
  }, [activeProject, setDependencyFiles])

  return { fetchDependencyFiles }
}
