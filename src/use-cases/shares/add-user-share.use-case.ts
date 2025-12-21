import type { UserShare } from '@/domain/entities/project.entity'
import { NotFoundError, ValidationError } from '@/domain/errors'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'

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
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): AddUserShareUseCase {
  return {
    async execute(input: AddUserShareInput): Promise<AddUserShareOutput> {
      const { projectId, userId, username } = input

      // Validate username
      const trimmedUsername = username.trim()
      if (!trimmedUsername) {
        throw new ValidationError('Username cannot be empty')
      }

      // Check user owns the project
      await authorizationService.mustOwnProject(projectId, userId)

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
