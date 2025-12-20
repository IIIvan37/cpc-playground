/**
 * React hooks for file use-cases
 */

import { useState } from 'react'
import { container } from '@/infrastructure/container'
import type {
  CreateFileInput,
  DeleteFileInput,
  UpdateFileInput
} from '@/use-cases/files'

/**
 * Hook for creating a file in a project
 */
export function useCreateFile() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<Error | null>(null)

  const createFile = async (input: CreateFileInput) => {
    setLoading(true)
    setError(null)
    try {
      const result = await container.createFile.execute(input)
      return result.file
    } catch (err) {
      setError(err as Error)
      throw err
    } finally {
      setLoading(false)
    }
  }

  return { createFile, loading, error }
}

/**
 * Hook for updating a file
 */
export function useUpdateFile() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<Error | null>(null)

  const updateFile = async (input: UpdateFileInput) => {
    setLoading(true)
    setError(null)
    try {
      const result = await container.updateFile.execute(input)
      return result.file
    } catch (err) {
      setError(err as Error)
      throw err
    } finally {
      setLoading(false)
    }
  }

  return { updateFile, loading, error }
}

/**
 * Hook for deleting a file
 */
export function useDeleteFile() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<Error | null>(null)

  const deleteFile = async (input: DeleteFileInput) => {
    setLoading(true)
    setError(null)
    try {
      const result = await container.deleteFile.execute(input)
      return result.success
    } catch (err) {
      setError(err as Error)
      throw err
    } finally {
      setLoading(false)
    }
  }

  return { deleteFile, loading, error }
}
