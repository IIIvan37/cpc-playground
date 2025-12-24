/**
 * React hooks for dependency use-cases
 * Provides a clean interface to interact with the domain layer
 */

import { useAtomValue, useSetAtom } from 'jotai'
import { useCallback } from 'react'
import { container } from '@/infrastructure/container'
import {
  currentProjectIdAtom,
  type DependencyProject,
  dependencyFilesAtom,
  isReadOnlyModeAtom,
  projectsAtom,
  viewOnlyProjectAtom
} from '@/store/projects'
import { useUseCase } from '../core'

/**
 * Hook to add a dependency to a project
 */
export function useAddDependency() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.addDependency
  )

  const addDependency = useCallback(
    (projectId: string, userId: string, dependencyId: string) =>
      execute({ projectId, userId, dependencyId }),
    [execute]
  )

  return { addDependency, loading, error, reset, data }
}

/**
 * Hook to remove a dependency from a project
 */
export function useRemoveDependency() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.removeDependency
  )

  const removeDependency = useCallback(
    (projectId: string, userId: string, dependencyId: string) =>
      execute({ projectId, userId, dependencyId }),
    [execute]
  )

  return { removeDependency, loading, error, reset, data }
}

/**
 * Hook to fetch dependency files for the current project
 * Groups files by their parent project
 */
export function useFetchDependencyFiles() {
  const isReadOnly = useAtomValue(isReadOnlyModeAtom)
  const currentProjectId = useAtomValue(currentProjectIdAtom)
  const viewOnlyProject = useAtomValue(viewOnlyProjectAtom)
  const projects = useAtomValue(projectsAtom)
  const setDependencyFiles = useSetAtom(dependencyFilesAtom)

  const fetchDependencyFiles = useCallback(async (): Promise<
    DependencyProject[]
  > => {
    // Get the active project based on mode
    const currentProject = isReadOnly
      ? viewOnlyProject
      : projects.find((p) => p.id === currentProjectId)

    if (!currentProject || currentProject.dependencies.length === 0) {
      setDependencyFiles([])
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
        if (file.projectId === currentProject.id) continue

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
  }, [
    isReadOnly,
    currentProjectId,
    viewOnlyProject,
    projects,
    setDependencyFiles
  ])

  return { fetchDependencyFiles }
}
