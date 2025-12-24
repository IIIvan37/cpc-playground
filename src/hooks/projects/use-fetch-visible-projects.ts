import { useQuery } from '@tanstack/react-query'
import { container } from '@/infrastructure/container'

export function useFetchVisibleProjects(userId?: string, enabled = true) {
  const { data, isLoading, error } = useQuery({
    queryKey: ['projects', 'visible', userId],
    queryFn: async () => {
      const result = await container.getVisibleProjects.execute({ userId })
      return result.projects
    },
    staleTime: 1000 * 30, // 30 seconds
    enabled // Only run when explicitly enabled
  })

  return {
    projects: data ?? [],
    loading: isLoading,
    error: error?.message ?? null
  }
}
