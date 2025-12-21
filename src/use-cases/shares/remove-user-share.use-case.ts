import { NotFoundError, UnauthorizedError } from '@/domain/errors'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

// ============================================================================
// Types
// ============================================================================

export type RemoveUserShareInput = {
  projectId: string
  userId: string
  targetUserId: string
}

export type RemoveUserShareOutput = {
  success: boolean
}

export type RemoveUserShareUseCase = {
  execute(input: RemoveUserShareInput): Promise<RemoveUserShareOutput>
}

// ============================================================================
// Use Case Factory
// ============================================================================

export function createRemoveUserShareUseCase(
  projectsRepository: IProjectsRepository
): RemoveUserShareUseCase {
  return {
    async execute(input: RemoveUserShareInput): Promise<RemoveUserShareOutput> {
      const { projectId, userId, targetUserId } = input

      // Check project exists
      const project = await projectsRepository.findById(projectId)
      if (!project) {
        throw new NotFoundError(`Project with id ${projectId} not found`)
      }

      // Check user owns the project
      if (project.userId !== userId) {
        throw new UnauthorizedError(
          'You are not authorized to modify shares for this project'
        )
      }

      // Remove user share
      await projectsRepository.removeUserShare(projectId, targetUserId)

      return { success: true }
    }
  }
}
