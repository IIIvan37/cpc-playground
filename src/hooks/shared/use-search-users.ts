/**
 * Hook for searching users by username
 */
import { useCallback, useState } from 'react'
import { container } from '@/infrastructure/container'
import type { UserSearchResult } from '@/use-cases/shares'

export type { UserSearchResult } from '@/use-cases/shares'

type UseSearchUsersResult = {
  users: readonly UserSearchResult[]
  loading: boolean
  error: Error | null
  searchUsers: (query: string, limit?: number) => Promise<void>
}

export function useSearchUsers(): UseSearchUsersResult {
  const [users, setUsers] = useState<readonly UserSearchResult[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<Error | null>(null)

  const { searchUsers: searchUsersUseCase } = container

  const searchUsers = useCallback(
    async (query: string, limit?: number) => {
      try {
        setLoading(true)
        setError(null)

        const { users: foundUsers } = await searchUsersUseCase.execute({
          query,
          limit
        })

        setUsers(foundUsers)
      } catch (err) {
        setError(
          err instanceof Error ? err : new Error('Failed to search users')
        )
        setUsers([])
      } finally {
        setLoading(false)
      }
    },
    [searchUsersUseCase]
  )

  return { users, loading, error, searchUsers }
}
