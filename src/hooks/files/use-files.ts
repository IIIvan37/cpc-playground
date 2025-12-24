/**
 * React hooks for file use-cases
 *
 * Uses the generic useUseCase hook to reduce boilerplate
 * Hooks automatically refresh the global projects state after mutations
 */

import { useSetAtom } from 'jotai'
import { useCallback, useState } from 'react'
import { container } from '@/infrastructure/container'
import { currentFileIdAtom, projectsAtom } from '@/store/projects'
import { useUseCase } from '../core'

/**
 * Hook for creating a file in a project
 * Automatically updates the global projects state
 */
export function useCreateFile() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.createFile
  )
  const setProjects = useSetAtom(projectsAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)

  const createFile = useCallback(
    async (params: Parameters<typeof execute>[0]) => {
      const result = await execute(params)
      if (result?.file) {
        // Update projects state with the new file
        setProjects((prev) =>
          prev.map((p) => {
            if (p.id === params.projectId) {
              return { ...p, files: [...p.files, result.file] }
            }
            return p
          })
        )
        // Set as current file if it's main or if requested
        if (result.file.isMain) {
          setCurrentFileId(result.file.id)
        }
      }
      return result
    },
    [execute, setProjects, setCurrentFileId]
  )

  return { createFile, loading, error, reset, data }
}

/**
 * Hook for updating a file
 * Automatically updates the global projects state
 */
export function useUpdateFile() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.updateFile
  )
  const setProjects = useSetAtom(projectsAtom)

  const updateFile = useCallback(
    async (params: Parameters<typeof execute>[0]) => {
      const result = await execute(params)
      if (result?.file) {
        // Update projects state with the updated file
        setProjects((prev) =>
          prev.map((p) => {
            if (p.id === params.projectId) {
              // If setting as main, update all files' isMain flag
              if (params.isMain) {
                return {
                  ...p,
                  files: p.files.map((f) => ({
                    ...f,
                    isMain: f.id === result.file.id
                  }))
                }
              }
              return {
                ...p,
                files: p.files.map((f) =>
                  f.id === result.file.id ? result.file : f
                )
              }
            }
            return p
          })
        )
      }
      return result
    },
    [execute, setProjects]
  )

  return { updateFile, loading, error, reset, data }
}

/**
 * Hook for deleting a file
 * Automatically updates the global projects state
 */
export function useDeleteFile() {
  const { execute, loading, error, reset, data } = useUseCase(
    container.deleteFile
  )
  const setProjects = useSetAtom(projectsAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)

  const deleteFile = useCallback(
    async (params: Parameters<typeof execute>[0]) => {
      await execute(params)
      // Update projects state, removing the file
      setProjects((prev) =>
        prev.map((p) => {
          if (p.id === params.projectId) {
            const remainingFiles = p.files.filter((f) => f.id !== params.fileId)
            return { ...p, files: remainingFiles }
          }
          return p
        })
      )
      // Clear current file if it was deleted, select main file instead
      setCurrentFileId((current) => {
        if (current === params.fileId) {
          return null // Will be handled by component to select another file
        }
        return current
      })
    },
    [execute, setProjects, setCurrentFileId]
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
