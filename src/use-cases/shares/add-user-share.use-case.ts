import type { UserShare } from '@/domain/entities/project.entity'
import {
  NotFoundError,
  UnauthorizedError,
  ValidationError
} from '@/domain/errors'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

// ============================================================================
// Types
// ============================================================================

export type AddUserShareInput = {
  projectId: string
  userId: string
  username: string
}

export type AddUserShareOutput = {
  share: UserShare
}

export type AddUserShareUseCase = {
  execute(input: AddUserShareInput): Promise<AddUserShareOutput>
}

// ============================================================================
// Use Case Factory
// ============================================================================

export function createAddUserShareUseCase(
  projectsRepository: IProjectsRepository
): AddUserShareUseCase {
  return {
    async execute(input: AddUserShareInput): Promise<AddUserShareOutput> {
      const { projectId, userId, username } = input

      // Validate username
      const trimmedUsername = username.trim()
      if (!trimmedUsername) {
        throw new ValidationError('Username cannot be empty')
      }

      // Check project exists
      const project = await projectsRepository.findById(projectId)
      if (!project) {
        throw new NotFoundError(`Project with id ${projectId} not found`)
      }

      // Check user owns the project
      if (project.userId !== userId) {
        throw new UnauthorizedError(
          'You are not authorized to share this project'
        )
      }

      // Find user by username
      const targetUser =
        await projectsRepository.findUserByUsername(trimmedUsername)
      if (!targetUser) {
        throw new NotFoundError(
          `User with username "${trimmedUsername}" not found`
        )
      }

      // Cannot share with yourself
      if (targetUser.id === userId) {
        throw new ValidationError('Cannot share project with yourself')
      }

      // Add user share
      const share = await projectsRepository.addUserShare(
        projectId,
        targetUser.id
      )

      return { share }
    }
  }
}
