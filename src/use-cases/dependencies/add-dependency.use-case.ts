import {
  NotFoundError,
  UnauthorizedError,
  ValidationError
} from '@/domain/errors'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

// ============================================================================
// Types
// ============================================================================

export type AddDependencyInput = {
  projectId: string
  userId: string
  dependencyId: string
}

export type AddDependencyOutput = {
  success: boolean
}

export type AddDependencyUseCase = {
  execute(input: AddDependencyInput): Promise<AddDependencyOutput>
}

// ============================================================================
// Use Case Factory
// ============================================================================

export function createAddDependencyUseCase(
  projectsRepository: IProjectsRepository
): AddDependencyUseCase {
  return {
    async execute(input: AddDependencyInput): Promise<AddDependencyOutput> {
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

      // Prevent self-dependency
      if (projectId === dependencyId) {
        throw new ValidationError('A project cannot depend on itself')
      }

      // Check dependency exists
      const dependency = await projectsRepository.findById(dependencyId)
      if (!dependency) {
        throw new NotFoundError(
          `Dependency project with id ${dependencyId} not found`
        )
      }

      // Check dependency is a library
      if (!dependency.isLibrary) {
        throw new ValidationError(
          `Project ${dependencyId} is not a library and cannot be used as a dependency`
        )
      }

      // Add dependency
      await projectsRepository.addDependency(projectId, dependencyId)

      return { success: true }
    }
  }
}
