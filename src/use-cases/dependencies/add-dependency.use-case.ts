import { NotFoundError, ValidationError } from '@/domain/errors'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'

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
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): AddDependencyUseCase {
  return {
    async execute(input: AddDependencyInput): Promise<AddDependencyOutput> {
      const { projectId, userId, dependencyId } = input

      // Check user owns the project
      await authorizationService.mustOwnProject(projectId, userId)

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
