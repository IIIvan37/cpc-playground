import { useInfiniteQuery } from '@tanstack/react-query'
import { DEFAULT_PAGE_SIZE } from '@/domain/types/pagination'
import { container } from '@/infrastructure/container'

export type UseInfiniteProjectsParams = {
  userId?: string
  search?: string
  librariesOnly?: boolean
  enabled?: boolean
  pageSize?: number
}

/**
 * Hook for fetching visible projects with infinite scroll pagination
 * Uses server-side search and filtering for better performance with large datasets
 */
export function useInfiniteProjects({
  userId,
  search,
  librariesOnly,
  enabled = true,
  pageSize = DEFAULT_PAGE_SIZE
}: UseInfiniteProjectsParams) {
  const {
    data,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
    isLoading,
    error,
    refetch
  } = useInfiniteQuery({
    queryKey: ['projects', 'infinite', userId, search, librariesOnly],
    queryFn: async ({ pageParam = 0 }) => {
      const result = await container.getVisibleProjectsPaginated.execute({
        userId,
        limit: pageSize,
        offset: pageParam,
        search: search || undefined,
        librariesOnly
      })
      return result
    },
    getNextPageParam: (lastPage, allPages) => {
      if (!lastPage.hasMore) return undefined
      // Calculate next offset based on all items fetched so far
      const totalFetched = allPages.reduce(
        (sum, page) => sum + page.items.length,
        0
      )
      return totalFetched
    },
    initialPageParam: 0,
    staleTime: 1000 * 30, // 30 seconds
    enabled
  })

  // Flatten all pages into a single array of projects
  const projects = data?.pages.flatMap((page) => page.items) ?? []
  const total = data?.pages[0]?.total ?? 0

  return {
    projects,
    total,
    loading: isLoading,
    loadingMore: isFetchingNextPage,
    error: error?.message ?? null,
    hasMore: hasNextPage ?? false,
    loadMore: fetchNextPage,
    refetch
  }
}
