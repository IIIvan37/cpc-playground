/**
 * React hooks for dependency use-cases
 * Provides a clean interface to interact with the domain layer
 */

import { useCallback } from 'react'
import { container } from '@/infrastructure/container'
import { useUseCase } from './use-use-case'

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
