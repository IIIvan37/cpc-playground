import type { AuthorizationService } from '@/domain/services'
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
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): RemoveUserShareUseCase {
  return {
    async execute(input: RemoveUserShareInput): Promise<RemoveUserShareOutput> {
      const { projectId, userId, targetUserId } = input

      // Check user owns the project
      await authorizationService.mustOwnProject(projectId, userId)

      // Remove user share
      await projectsRepository.removeUserShare(projectId, targetUserId)

      return { success: true }
    }
  }
}
