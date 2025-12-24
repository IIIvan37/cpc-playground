/**
 * Hook to get the current project using React Query
 * Combines currentProjectIdAtom (UI state) with React Query (server state)
 *
 * IMPORTANT: This hook NEVER triggers fetches - it only reads from cache.
 * The cache is populated by useFetchProject via ensureQueryData.
 * This prevents duplicate requests when multiple components use this hook.
 */

import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useAtomValue } from 'jotai'
import type { Project } from '@/domain/entities/project.entity'
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
 * Uses currentProjectIdAtom to determine which project to read from cache
 * Returns null if no project is selected or not in cache
 *
 * NOTE: This hook does NOT fetch data - it only reads from React Query cache.
 * Use useFetchProject to load a project into the cache.
 */
export function useCurrentProject() {
  const queryClient = useQueryClient()
  const currentProjectId = useAtomValue(currentProjectIdAtom)

  // Read directly from cache - never trigger a fetch
  const query = useQuery({
    queryKey: projectKeys.detail(currentProjectId ?? ''),
    // Return cached data or null - never fetch
    queryFn: () => {
      // This should never be called because we set staleTime to Infinity
      // and the data is populated by ensureQueryData in useFetchProject
      return (
        queryClient.getQueryData<Project>(
          projectKeys.detail(currentProjectId ?? '')
        ) ?? null
      )
    },
    enabled: !!currentProjectId,
    // Never consider data stale - prevents automatic refetches
    staleTime: Number.POSITIVE_INFINITY,
    // Never refetch - data is managed by useFetchProject
    refetchOnMount: false,
    refetchOnWindowFocus: false,
    refetchOnReconnect: false
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

  if (!activeProject?.files || !currentFileId) return null

  return activeProject.files.find((f) => f.id === currentFileId) ?? null
}

/**
 * Hook to get the main file from the active project
 * Replaces mainFileAtom
 */
export function useMainFile() {
  const { activeProject } = useActiveProject()

  if (!activeProject?.files) return null

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

/**
 * Hook to check if the current file is a markdown file
 * Uses React Query data instead of atoms
 */
export function useIsMarkdownFile() {
  const currentFile = useCurrentFile()
  if (!currentFile) return false
  return currentFile.name.value.toLowerCase().endsWith('.md')
}
