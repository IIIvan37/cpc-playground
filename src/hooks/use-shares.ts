/**
 * React hooks for user share use-cases
 * Provides a clean interface to interact with the domain layer
 */

import { useCallback } from 'react'
import { container } from '@/infrastructure/container'
import { useUseCase } from './use-use-case'

/**
 * Hook to add a user share to a project
 */
export function useAddUserShare() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.addUserShare
  )

  const addUserShare = useCallback(
    (projectId: string, userId: string, username: string) =>
      execute({ projectId, userId, username }),
    [execute]
  )

  return { addUserShare, loading, error, reset, data }
}

/**
 * Hook to remove a user share from a project
 */
export function useRemoveUserShare() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.removeUserShare
  )

  const removeUserShare = useCallback(
    (projectId: string, userId: string, targetUserId: string) =>
      execute({ projectId, userId, targetUserId }),
    [execute]
  )

  return { removeUserShare, loading, error, reset, data }
}
