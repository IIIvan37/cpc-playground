/**
 * React hooks for tag use-cases
 * Provides a clean interface to interact with the domain layer
 */

import { useMutation, useQueryClient } from '@tanstack/react-query'
import type { Project } from '@/domain/entities/project.entity'
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
      return { result, userId, projectId, tagName }
    },
    onSuccess: ({ userId, projectId, tagName }) => {
      // Update the project in cache directly to add the new tag
      queryClient.setQueryData<Project>(
        ['project', projectId],
        (oldProject) => {
          if (!oldProject) return oldProject
          return {
            ...oldProject,
            tags: [...(oldProject.tags || []), tagName]
          }
        }
      )
      queryClient.invalidateQueries({ queryKey: ['projects', 'user', userId] })
      queryClient.invalidateQueries({ queryKey: ['projects', 'visible'] })
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
      return { result, userId, projectId, tagIdOrName }
    },
    onSuccess: ({ userId, projectId, tagIdOrName }) => {
      // Update the project in cache directly to remove the tag
      queryClient.setQueryData<Project>(
        ['project', projectId],
        (oldProject) => {
          if (!oldProject) return oldProject
          return {
            ...oldProject,
            tags: (oldProject.tags || []).filter((tag) => tag !== tagIdOrName)
          }
        }
      )
      queryClient.invalidateQueries({ queryKey: ['projects', 'user', userId] })
      queryClient.invalidateQueries({ queryKey: ['projects', 'visible'] })
    }
  })
}
