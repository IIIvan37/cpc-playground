import { NotFoundError, UnauthorizedError } from '@/domain/errors'
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
  projectsRepository: IProjectsRepository
): RemoveDependencyUseCase {
  return {
    async execute(
      input: RemoveDependencyInput
    ): Promise<RemoveDependencyOutput> {
      const { projectId, userId, dependencyId } = input

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

      // Remove dependency
      await projectsRepository.removeDependency(projectId, dependencyId)

      return { success: true }
    }
  }
}
