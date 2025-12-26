import type { QueryClient } from '@tanstack/react-query'

type InvalidateOptions = {
  readonly projectId?: string
  readonly userId?: string
  readonly project?: unknown
}

/**
 * Invalidates all project-related caches after a mutation
 * Use this to ensure Explore page and user projects list are updated
 *
 * @param queryClient - The React Query client
 * @param options.projectId - The project ID to update in cache (optional)
 * @param options.userId - The user ID for user-specific cache invalidation (optional)
 * @param options.project - The updated project data to set in cache (optional)
 */
export function invalidateProjectCaches(
  queryClient: QueryClient,
  options: InvalidateOptions = {}
) {
  const { projectId, userId, project } = options

  // Update individual project cache if project data provided
  if (projectId && project) {
    queryClient.setQueryData(['project', projectId], project)
  }

  // Invalidate visible projects list (Explore page)
  queryClient.invalidateQueries({
    queryKey: ['projects', 'visible'],
    refetchType: 'all'
  })

  // Invalidate user's projects list if userId provided
  if (userId) {
    queryClient.invalidateQueries({
      queryKey: ['projects', 'user', userId]
    })
  }
}
