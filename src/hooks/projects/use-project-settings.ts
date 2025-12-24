/**
 * Hooks for project settings operations
 * Uses a generic pattern to reduce duplication
 */

import { useCallback, useState } from 'react'
import { createLogger } from '@/lib/logger'

const logger = createLogger('ProjectSettings')

import {
  useAddDependency,
  useAddTag,
  useAddUserShare,
  useDeleteProject,
  useRemoveDependency,
  useRemoveTag,
  useRemoveUserShare,
  useUpdateProject
} from '.'

// ============================================================================
// Types
// ============================================================================

type OperationResult = {
  success: boolean
  error?: string
}

// ============================================================================
// Project Settings Hooks
// ============================================================================

type SaveProjectParams = {
  projectId: string
  userId: string
  name: string
  description: string
  visibility: 'private' | 'public'
  isLibrary: boolean
}

/**
 * Hook to handle saving/updating project settings
 * Special case: params is an object, so we handle refresh manually
 */
export function useHandleSaveProject() {
  const { update } = useUpdateProject()
  const [loading, setLoading] = useState(false)

  const handleSave = useCallback(
    async (params: SaveProjectParams): Promise<OperationResult> => {
      setLoading(true)
      try {
        // Transform flat params to use-case input structure
        await update({
          projectId: params.projectId,
          userId: params.userId,
          updates: {
            name: params.name,
            description: params.description,
            visibility: params.visibility,
            isLibrary: params.isLibrary
          }
        })
        return { success: true }
      } catch (error) {
        logger.error('Error updating project:', error)
        return {
          success: false,
          error:
            error instanceof Error ? error.message : 'Error updating project'
        }
      } finally {
        setLoading(false)
      }
    },
    [update]
  )

  return { handleSave, loading }
}

/**
 * Hook to handle deleting a project
 * Note: Confirmation should be handled by the calling component
 */
export function useHandleDeleteProject() {
  const { deleteProject } = useDeleteProject()
  const [loading, setLoading] = useState(false)

  const handleDelete = useCallback(
    async (projectId: string, userId: string): Promise<OperationResult> => {
      setLoading(true)
      try {
        await deleteProject({ projectId, userId })
        return { success: true }
      } catch (error) {
        logger.error('Error deleting project:', error)
        return {
          success: false,
          error:
            error instanceof Error ? error.message : 'Error deleting project'
        }
      } finally {
        setLoading(false)
      }
    },
    [deleteProject]
  )

  return { handleDelete, loading }
}

/**
 * Hook to handle adding a tag to a project
 */
export function useHandleAddTag() {
  const mutation = useAddTag()

  const handleAddTag = useCallback(
    async (
      projectId: string,
      userId: string,
      tagName: string
    ): Promise<OperationResult> => {
      if (!tagName.trim()) return { success: false }

      try {
        await mutation.mutateAsync({
          projectId,
          userId,
          tagName: tagName.trim()
        })
        return { success: true }
      } catch (error) {
        return {
          success: false,
          error: error instanceof Error ? error.message : 'Error adding tag'
        }
      }
    },
    [mutation.mutateAsync]
  )

  return { handleAddTag, loading: mutation.isPending }
}

/**
 * Hook to handle removing a tag from a project
 */
export function useHandleRemoveTag() {
  const mutation = useRemoveTag()

  const handleRemoveTag = useCallback(
    async (
      projectId: string,
      userId: string,
      tagIdOrName: string
    ): Promise<OperationResult> => {
      try {
        await mutation.mutateAsync({ projectId, userId, tagIdOrName })
        return { success: true }
      } catch (error) {
        return {
          success: false,
          error: error instanceof Error ? error.message : 'Error removing tag'
        }
      }
    },
    [mutation.mutateAsync]
  )

  return { handleRemoveTag, loading: mutation.isPending }
}

/**
 * Hook to handle adding a dependency to a project
 */
export function useHandleAddDependency() {
  const mutation = useAddDependency()

  const handleAddDependency = useCallback(
    async (
      projectId: string,
      userId: string,
      dependencyId: string
    ): Promise<OperationResult> => {
      if (!dependencyId) return { success: false }

      try {
        await mutation.mutateAsync({ projectId, userId, dependencyId })
        return { success: true }
      } catch (error) {
        return {
          success: false,
          error:
            error instanceof Error ? error.message : 'Error adding dependency'
        }
      }
    },
    [mutation.mutateAsync]
  )

  return { handleAddDependency, loading: mutation.isPending }
}

/**
 * Hook to handle removing a dependency from a project
 */
export function useHandleRemoveDependency() {
  const mutation = useRemoveDependency()

  const handleRemoveDependency = useCallback(
    async (
      projectId: string,
      userId: string,
      dependencyId: string
    ): Promise<OperationResult> => {
      try {
        await mutation.mutateAsync({ projectId, userId, dependencyId })
        return { success: true }
      } catch (error) {
        return {
          success: false,
          error:
            error instanceof Error ? error.message : 'Error removing dependency'
        }
      }
    },
    [mutation.mutateAsync]
  )

  return { handleRemoveDependency, loading: mutation.isPending }
}

/**
 * Hook to handle adding a user share to a project
 */
export function useHandleAddShare() {
  const mutation = useAddUserShare()

  const handleAddShare = useCallback(
    async (
      projectId: string,
      userId: string,
      username: string
    ): Promise<OperationResult> => {
      if (!username.trim()) return { success: false }

      try {
        await mutation.mutateAsync({
          projectId,
          userId,
          username: username.trim()
        })
        return { success: true }
      } catch (error) {
        return {
          success: false,
          error: error instanceof Error ? error.message : 'Error adding share'
        }
      }
    },
    [mutation.mutateAsync]
  )

  return { handleAddShare, loading: mutation.isPending }
}

/**
 * Hook to handle removing a user share from a project
 */
export function useHandleRemoveShare() {
  const mutation = useRemoveUserShare()

  const handleRemoveShare = useCallback(
    async (
      projectId: string,
      userId: string,
      targetUserId: string
    ): Promise<OperationResult> => {
      try {
        await mutation.mutateAsync({ projectId, userId, targetUserId })
        return { success: true }
      } catch (error) {
        return {
          success: false,
          error: error instanceof Error ? error.message : 'Error removing share'
        }
      }
    },
    [mutation.mutateAsync]
  )

  return { handleRemoveShare, loading: mutation.isPending }
}
