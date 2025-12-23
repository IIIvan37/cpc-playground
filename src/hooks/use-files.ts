/**
 * React hooks for file use-cases
 *
 * Uses the generic useUseCase hook to reduce boilerplate
 */

import { container } from '@/infrastructure/container'
import { useUseCase } from './use-use-case'

/**
 * Hook for creating a file in a project
 */
export function useCreateFile() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.createFile
  )
  return { createFile: execute, loading, error, reset, data }
}

/**
 * Hook for updating a file
 */
export function useUpdateFile() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.updateFile
  )
  return { updateFile: execute, loading, error, reset, data }
}

/**
 * Hook for deleting a file
 */
export function useDeleteFile() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.deleteFile
  )
  return { deleteFile: execute, loading, error, reset, data }
}
