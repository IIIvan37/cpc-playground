/**
 * Hooks for project settings operations
 * Uses a generic pattern to reduce duplication
 */

import { useCallback, useState } from 'react'
import {
  useAddDependency,
  useAddTag,
  useAddUserShare,
  useDeleteProject,
  useRefreshProjects,
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

type OperationFn<TArgs extends unknown[]> = (
  ...args: TArgs
) => Promise<OperationResult>

// ============================================================================
// Generic Hook Factory
// ============================================================================

/**
 * Creates a hook for project operations with loading state, error handling, and refresh
 * Inspired by useUseCase pattern but tailored for operations that need to refresh global state
 *
 * Convention: userId must be the second argument for auto-refresh to work
 */
function useProjectOperation<TArgs extends unknown[]>(
  operation: (...args: TArgs) => Promise<unknown>,
  errorMessage: string
): { execute: OperationFn<TArgs>; loading: boolean } {
  const { refreshProjects } = useRefreshProjects()
  const [loading, setLoading] = useState(false)

  const execute = useCallback(
    async (...args: TArgs): Promise<OperationResult> => {
      setLoading(true)
      try {
        await operation(...args)
        const userId = args[1] as string
        await refreshProjects(userId)
        return { success: true }
      } catch (error) {
        console.error(`${errorMessage}:`, error)
        return {
          success: false,
          error: error instanceof Error ? error.message : errorMessage
        }
      } finally {
        setLoading(false)
      }
    },
    [operation, refreshProjects, errorMessage]
  )

  return { execute, loading }
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
  const { refreshProjects } = useRefreshProjects()
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
        await refreshProjects(params.userId)
        return { success: true }
      } catch (error) {
        console.error('Error updating project:', error)
        return {
          success: false,
          error:
            error instanceof Error ? error.message : 'Error updating project'
        }
      } finally {
        setLoading(false)
      }
    },
    [update, refreshProjects]
  )

  return { handleSave, loading }
}

/**
 * Hook to handle deleting a project
 * Special case: requires confirmation dialog
 */
export function useHandleDeleteProject() {
  const { deleteProject } = useDeleteProject()
  const { refreshProjects } = useRefreshProjects()
  const [loading, setLoading] = useState(false)

  const handleDelete = useCallback(
    async (
      projectId: string,
      userId: string,
      projectName: string
    ): Promise<OperationResult> => {
      const confirmed = globalThis.confirm(
        `Are you sure you want to delete "${projectName}"? This action cannot be undone.`
      )
      if (!confirmed) return { success: false }

      setLoading(true)
      try {
        await deleteProject(projectId, userId)
        await refreshProjects(userId)
        return { success: true }
      } catch (error) {
        console.error('Error deleting project:', error)
        return {
          success: false,
          error:
            error instanceof Error ? error.message : 'Error deleting project'
        }
      } finally {
        setLoading(false)
      }
    },
    [deleteProject, refreshProjects]
  )

  return { handleDelete, loading }
}

/**
 * Hook to handle adding a tag to a project
 */
export function useHandleAddTag() {
  const { addTag } = useAddTag()
  const { execute, loading } = useProjectOperation(addTag, 'Error adding tag')

  const handleAddTag = useCallback(
    async (
      projectId: string,
      userId: string,
      tagName: string
    ): Promise<OperationResult> => {
      if (!tagName.trim()) return { success: false }
      return execute(projectId, userId, tagName.trim())
    },
    [execute]
  )

  return { handleAddTag, loading }
}

/**
 * Hook to handle removing a tag from a project
 */
export function useHandleRemoveTag() {
  const { removeTag } = useRemoveTag()
  const { execute, loading } = useProjectOperation(
    removeTag,
    'Error removing tag'
  )

  return { handleRemoveTag: execute, loading }
}

/**
 * Hook to handle adding a dependency to a project
 */
export function useHandleAddDependency() {
  const { addDependency } = useAddDependency()
  const { execute, loading } = useProjectOperation(
    addDependency,
    'Error adding dependency'
  )

  const handleAddDependency = useCallback(
    async (
      projectId: string,
      userId: string,
      dependencyId: string
    ): Promise<OperationResult> => {
      if (!dependencyId) return { success: false }
      return execute(projectId, userId, dependencyId)
    },
    [execute]
  )

  return { handleAddDependency, loading }
}

/**
 * Hook to handle removing a dependency from a project
 */
export function useHandleRemoveDependency() {
  const { removeDependency } = useRemoveDependency()
  const { execute, loading } = useProjectOperation(
    removeDependency,
    'Error removing dependency'
  )

  return { handleRemoveDependency: execute, loading }
}

/**
 * Hook to handle adding a user share to a project
 */
export function useHandleAddShare() {
  const { addUserShare } = useAddUserShare()
  const { execute, loading } = useProjectOperation(
    addUserShare,
    'Error adding share'
  )

  const handleAddShare = useCallback(
    async (
      projectId: string,
      userId: string,
      username: string
    ): Promise<OperationResult> => {
      if (!username.trim()) return { success: false }
      return execute(projectId, userId, username.trim())
    },
    [execute]
  )

  return { handleAddShare, loading }
}

/**
 * Hook to handle removing a user share from a project
 */
export function useHandleRemoveShare() {
  const { removeUserShare } = useRemoveUserShare()
  const { execute, loading } = useProjectOperation(
    removeUserShare,
    'Error removing share'
  )

  return { handleRemoveShare: execute, loading }
}
