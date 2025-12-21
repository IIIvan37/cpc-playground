import { NotFoundError, UnauthorizedError } from '@/domain/errors'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

// ============================================================================
// Types
// ============================================================================

export type RemoveTagInput = {
  projectId: string
  userId: string
  /** Can be either tag ID (UUID) or tag name */
  tagIdOrName: string
}

export type RemoveTagOutput = {
  success: boolean
}

export type RemoveTagUseCase = {
  execute(input: RemoveTagInput): Promise<RemoveTagOutput>
}

// ============================================================================
// Use Case Factory
// ============================================================================

export function createRemoveTagUseCase(
  projectsRepository: IProjectsRepository
): RemoveTagUseCase {
  return {
    async execute(input: RemoveTagInput): Promise<RemoveTagOutput> {
      const { projectId, userId, tagIdOrName } = input

      // Check project exists
      const project = await projectsRepository.findById(projectId)
      if (!project) {
        throw new NotFoundError(`Project with id ${projectId} not found`)
      }

      // Check user owns the project
      if (project.userId !== userId) {
        throw new UnauthorizedError(
          'You are not authorized to modify this project'
        )
      }

      // Remove tag (accepts either id or name)
      await projectsRepository.removeTag(projectId, tagIdOrName)

      return { success: true }
    }
  }
}
