/**
 * React hooks for file use-cases
 *
 * Uses React Query for cache management
 * Hooks invalidate queries after mutations to keep cache in sync
 */

import { useQueryClient } from '@tanstack/react-query'
import { useSetAtom } from 'jotai'
import { useCallback, useState } from 'react'
import { container } from '@/infrastructure/container'
import { currentFileIdAtom } from '@/store/projects'
import { useUseCase } from '../core'

/**
 * Hook for creating a file in a project
 * Invalidates project cache to refresh data
 */
export function useCreateFile() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.createFile
  )
  const queryClient = useQueryClient()
  const setCurrentFileId = useSetAtom(currentFileIdAtom)

  const createFile = useCallback(
    async (params: Parameters<typeof execute>[0]) => {
      const result = await execute(params)
      if (result?.file) {
        // Fetch fresh project from API and update cache directly
        const res = await container.getProject.execute({
          projectId: params.projectId,
          userId: params.userId
        })
        if (res.project) {
          queryClient.setQueryData(['project', params.projectId], res.project)
        }
        // Set as current file if it's main or if requested
        if (result.file.isMain) {
          setCurrentFileId(result.file.id)
        }
      }
      return result
    },
    [execute, queryClient, setCurrentFileId]
  )

  return { createFile, loading, error, reset, data }
}

/**
 * Hook for updating a file
 * Invalidates project cache to refresh data
 */
export function useUpdateFile() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.updateFile
  )
  const queryClient = useQueryClient()

  const updateFile = useCallback(
    async (params: Parameters<typeof execute>[0]) => {
      const result = await execute(params)
      if (result?.file) {
        // Fetch fresh project from API and update cache directly
        const res = await container.getProject.execute({
          projectId: params.projectId,
          userId: params.userId
        })
        if (res.project) {
          queryClient.setQueryData(['project', params.projectId], res.project)
        }
      }
      return result
    },
    [execute, queryClient]
  )

  return { updateFile, loading, error, reset, data }
}

/**
 * Hook for deleting a file
 * Invalidates project cache to refresh data
 */
export function useDeleteFile() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.deleteFile
  )
  const queryClient = useQueryClient()
  const setCurrentFileId = useSetAtom(currentFileIdAtom)

  const deleteFile = useCallback(
    async (params: Parameters<typeof execute>[0]) => {
      await execute(params)
      // Invalidate project cache to refresh file list
      queryClient.invalidateQueries({ queryKey: ['project', params.projectId] })
      // Clear current file if it was deleted
      setCurrentFileId((current) => {
        if (current === params.fileId) {
          return null // Will be handled by component to select another file
        }
        return current
      })
    },
    [execute, queryClient, setCurrentFileId]
  )

  return { deleteFile, loading, error, reset, data }
}

/**
 * Hook for setting a file as main
 * Uses updateFile under the hood
 */
export function useSetMainFile() {
  const { updateFile, loading, error, reset } = useUpdateFile()
  const [updating, setUpdating] = useState(false)

  const setMainFile = useCallback(
    async (params: { projectId: string; userId: string; fileId: string }) => {
      setUpdating(true)
      try {
        await updateFile({
          projectId: params.projectId,
          userId: params.userId,
          fileId: params.fileId,
          isMain: true
        })
      } finally {
        setUpdating(false)
      }
    },
    [updateFile]
  )

  return { setMainFile, loading: loading || updating, error, reset }
}
