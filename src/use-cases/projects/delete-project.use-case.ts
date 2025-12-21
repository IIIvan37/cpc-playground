import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'

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
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): DeleteProjectUseCase {
  return {
    async execute(input: DeleteProjectInput): Promise<DeleteProjectOutput> {
      // Verify ownership
      await authorizationService.mustOwnProject(input.projectId, input.userId)

      // Delete
      await projectsRepository.delete(input.projectId)

      return { success: true }
    }
  }
}
