/**
 * React hooks for tag use-cases
 * Provides a clean interface to interact with the domain layer
 */

import { useMutation, useQueryClient } from '@tanstack/react-query'
import { container } from '@/infrastructure/container'

/**
 * Hook to add a tag to a project
 */
export function useAddTag() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({
      projectId,
      userId,
      tagName
    }: {
      projectId: string
      userId: string
      tagName: string
    }) => {
      const result = await container.addTag.execute({
        projectId,
        userId,
        tagName
      })
      return { result, userId, projectId }
    },
    onSuccess: ({ projectId }) => {
      queryClient.invalidateQueries({ queryKey: ['project', projectId] })
    }
  })
}

/**
 * Hook to remove a tag from a project
 */
export function useRemoveTag() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({
      projectId,
      userId,
      tagIdOrName
    }: {
      projectId: string
      userId: string
      tagIdOrName: string
    }) => {
      const result = await container.removeTag.execute({
        projectId,
        userId,
        tagIdOrName
      })
      return { result, userId, projectId }
    },
    onSuccess: ({ userId, projectId }) => {
      queryClient.invalidateQueries({ queryKey: ['project', projectId] })
      queryClient.invalidateQueries({ queryKey: ['projects', 'user', userId] })
      queryClient.invalidateQueries({ queryKey: ['projects', 'visible'] })
    }
  })
}
