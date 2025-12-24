/**
 * React hooks for user share use-cases
 * Provides a clean interface to interact with the domain layer
 */

import { useMutation, useQueryClient } from '@tanstack/react-query'
import { container } from '@/infrastructure/container'

/**
 * Hook to add a user share to a project
 */
export function useAddUserShare() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({
      projectId,
      userId,
      username
    }: {
      projectId: string
      userId: string
      username: string
    }) => {
      const result = await container.addUserShare.execute({
        projectId,
        userId,
        username
      })
      return { result, userId, projectId }
    },
    onSuccess: ({ projectId }) => {
      queryClient.invalidateQueries({ queryKey: ['project', projectId] })
    }
  })
}

/**
 * Hook to remove a user share from a project
 */
export function useRemoveUserShare() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({
      projectId,
      userId,
      targetUserId
    }: {
      projectId: string
      userId: string
      targetUserId: string
    }) => {
      const result = await container.removeUserShare.execute({
        projectId,
        userId,
        targetUserId
      })
      return { result, userId, projectId }
    },
    onSuccess: ({ projectId }) => {
      queryClient.invalidateQueries({ queryKey: ['project', projectId] })
    }
  })
}
