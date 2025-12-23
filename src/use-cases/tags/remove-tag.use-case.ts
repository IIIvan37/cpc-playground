import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'

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
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): RemoveTagUseCase {
  return {
    async execute(input: RemoveTagInput): Promise<RemoveTagOutput> {
      const { projectId, userId, tagIdOrName } = input

      // Check user owns the project
      await authorizationService.mustOwnProject(projectId, userId)

      // Remove tag (accepts either id or name)
      await projectsRepository.removeTag(projectId, tagIdOrName)

      return { success: true }
    }
  }
}
