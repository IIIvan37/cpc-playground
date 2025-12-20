import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

/**
 * Use Case: Delete a project
 */

export type DeleteProjectInput = {
  projectId: string
  userId: string
}

export type DeleteProjectOutput = {
  success: boolean
}

export type DeleteProjectUseCase = {
  execute(input: DeleteProjectInput): Promise<DeleteProjectOutput>
}

/**
 * Factory function that creates DeleteProjectUseCase
 */
export function createDeleteProjectUseCase(
  projectsRepository: IProjectsRepository
): DeleteProjectUseCase {
  return {
    async execute(input: DeleteProjectInput): Promise<DeleteProjectOutput> {
      // Get existing project for authorization
      const existingProject = await projectsRepository.findById(input.projectId)

      if (!existingProject) {
        throw new NotFoundError(`Project ${input.projectId} not found`)
      }

      // Authorization check
      if (existingProject.userId !== input.userId) {
        throw new UnauthorizedError(
          'You are not authorized to delete this project'
        )
      }

      // Delete
      await projectsRepository.delete(input.projectId)

      return { success: true }
    }
  }
}
