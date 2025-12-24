/**
 * React hooks for tag use-cases
 * Provides a clean interface to interact with the domain layer
 */

import { useCallback } from 'react'
import { container } from '@/infrastructure/container'
import { useUseCase } from '../core'

/**
 * Hook to add a tag to a project
 */
export function useAddTag() {
  const { execute, loading, error, reset, data } = useUseCase(container.addTag)

  const addTag = useCallback(
    (projectId: string, userId: string, tagName: string) =>
      execute({ projectId, userId, tagName }),
    [execute]
  )

  return { addTag, loading, error, reset, data }
}

/**
 * Hook to remove a tag from a project
 */
export function useRemoveTag() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.removeTag
  )

  const removeTag = useCallback(
    (projectId: string, userId: string, tagIdOrName: string) =>
      execute({ projectId, userId, tagIdOrName }),
    [execute]
  )

  return { removeTag, loading, error, reset, data }
}
