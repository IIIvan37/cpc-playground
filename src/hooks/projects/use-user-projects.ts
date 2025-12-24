/**
 * Hook to fetch and manage user's projects using React Query
 * This is the single source of truth for the projects list
 */

import { useQuery, useQueryClient } from '@tanstack/react-query'
import type { Project } from '@/domain/entities/project.entity'
import { useAuth } from '@/hooks/auth/use-auth'
import { container } from '@/infrastructure/container'

/**
 * Query key factory for projects
 */
export const projectsKeys = {
  all: ['projects'] as const,
  user: (userId: string) => ['projects', 'user', userId] as const,
  visible: (userId?: string) => ['projects', 'visible', userId] as const
}

/**
 * Hook to fetch all projects for the current user
 * Replaces projectsAtom as the single source of truth
 */
export function useUserProjects() {
  const { user } = useAuth()

  const query = useQuery({
    queryKey: projectsKeys.user(user?.id ?? ''),
    queryFn: async () => {
      if (!user?.id) return { projects: [] as Project[] }
      const result = await container.getProjects.execute({ userId: user.id })
      return result
    },
    enabled: !!user?.id,
    staleTime: 1000 * 30, // 30 seconds
    select: (data) => data.projects
  })

  return {
    projects: query.data ?? [],
    isLoading: query.isLoading,
    isError: query.isError,
    error: query.error,
    refetch: query.refetch
  }
}

/**
 * Hook to get a project by ID from the cache or fetch it
 * Can be used to find a project in the user's list without refetching
 */
export function useProjectFromCache(projectId: string | null) {
  const queryClient = useQueryClient()
  const { user } = useAuth()

  if (!projectId || !user?.id) return null

  // Try to get from user's projects cache first
  const cachedProjects = queryClient.getQueryData<{ projects: Project[] }>(
    projectsKeys.user(user.id)
  )

  return cachedProjects?.projects.find((p) => p.id === projectId) ?? null
}

/**
 * Hook to get available libraries (projects marked as is_library)
 * Used for dependency selection
 */
export function useAvailableLibraries() {
  const { projects } = useUserProjects()

  return projects.filter((p) => p.isLibrary)
}

/**
 * Hook to get projects that can be dependencies for a given project
 * Excludes the current project itself
 */
export function useAvailableDependencies(currentProjectId: string | null) {
  const { projects } = useUserProjects()

  if (!currentProjectId) return []

  return projects.filter((p) => p.isLibrary && p.id !== currentProjectId)
}
