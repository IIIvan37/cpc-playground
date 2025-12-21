import type { AuthorizationService } from '@/domain/services'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

// ============================================================================
// Types
// ============================================================================

export type RemoveDependencyInput = {
  projectId: string
  userId: string
  dependencyId: string
}

export type RemoveDependencyOutput = {
  success: boolean
}

export type RemoveDependencyUseCase = {
  execute(input: RemoveDependencyInput): Promise<RemoveDependencyOutput>
}

// ============================================================================
// Use Case Factory
// ============================================================================

export function createRemoveDependencyUseCase(
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): RemoveDependencyUseCase {
  return {
    async execute(
      input: RemoveDependencyInput
    ): Promise<RemoveDependencyOutput> {
      const { projectId, userId, dependencyId } = input

      // Check user owns the project
      await authorizationService.mustOwnProject(projectId, userId)

      // Remove dependency
      await projectsRepository.removeDependency(projectId, dependencyId)

      return { success: true }
    }
  }
}
