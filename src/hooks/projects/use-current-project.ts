/**
 * Hook to get the current project using React Query
 * Combines currentProjectIdAtom (UI state) with React Query (server state)
 */

import { useQuery } from '@tanstack/react-query'
import { useAtomValue } from 'jotai'
import { useAuth } from '@/hooks/auth/use-auth'
import { container } from '@/infrastructure/container'
import {
  currentFileIdAtom,
  currentProjectIdAtom,
  isReadOnlyModeAtom,
  viewOnlyProjectAtom
} from '@/store/projects'

/**
 * Query key factory for single project
 */
export const projectKeys = {
  detail: (projectId: string) => ['project', projectId] as const
}

/**
 * Hook to get the current project
 * Uses currentProjectIdAtom to determine which project to fetch
 * Returns null if no project is selected
 */
export function useCurrentProject() {
  const { user } = useAuth()
  const currentProjectId = useAtomValue(currentProjectIdAtom)

  const query = useQuery({
    queryKey: projectKeys.detail(currentProjectId ?? ''),
    queryFn: async () => {
      if (!currentProjectId) return null
      const result = await container.getProject.execute({
        projectId: currentProjectId,
        userId: user?.id
      })
      return result.project
    },
    enabled: !!currentProjectId,
    staleTime: 1000 * 30 // 30 seconds
  })

  return {
    project: query.data ?? null,
    isLoading: query.isLoading,
    isError: query.isError,
    error: query.error,
    refetch: query.refetch
  }
}

/**
 * Hook to get the active project (either owned or view-only)
 * Replaces activeProjectAtom
 */
export function useActiveProject() {
  const isReadOnly = useAtomValue(isReadOnlyModeAtom)
  const viewOnlyProject = useAtomValue(viewOnlyProjectAtom)
  const { project: currentProject, isLoading } = useCurrentProject()

  // In read-only mode, return the view-only project (from atom, as it's not the user's)
  // Otherwise, return the current project from React Query
  const activeProject = isReadOnly ? viewOnlyProject : currentProject

  return {
    activeProject,
    isReadOnly,
    isLoading: !isReadOnly && isLoading
  }
}

/**
 * Hook to get the current file from the active project
 * Replaces currentFileAtom
 */
export function useCurrentFile() {
  const { activeProject } = useActiveProject()
  const currentFileId = useAtomValue(currentFileIdAtom)

  if (!activeProject || !currentFileId) return null

  return activeProject.files.find((f) => f.id === currentFileId) ?? null
}

/**
 * Hook to get the main file from the active project
 * Replaces mainFileAtom
 */
export function useMainFile() {
  const { activeProject } = useActiveProject()

  if (!activeProject) return null

  return activeProject.files.find((f) => f.isMain) ?? null
}

/**
 * Hook to get files from the active project
 */
export function useProjectFiles() {
  const { activeProject, isLoading } = useActiveProject()

  return {
    files: activeProject?.files ?? [],
    isLoading
  }
}
