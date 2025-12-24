import type { Project } from '@/domain/entities/project.entity'
import { NotFoundError } from '@/domain/errors/domain.error'
import { PROJECT_ERRORS } from '@/domain/errors/error-messages'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'

/**
 * Use Case: Get a single project by ID
 */

export type GetProjectInput = {
  projectId: string
  userId?: string // For authorization check
}

export type GetProjectOutput = {
  project: Project
}

export type GetProjectUseCase = {
  execute(input: GetProjectInput): Promise<GetProjectOutput>
}

/**
 * Factory function that creates GetProjectUseCase
 */
export function createGetProjectUseCase(
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): GetProjectUseCase {
  return {
    async execute(input: GetProjectInput): Promise<GetProjectOutput> {
      const project = await projectsRepository.findById(input.projectId)

      if (!project) {
        throw new NotFoundError(PROJECT_ERRORS.NOT_FOUND(input.projectId))
      }

      // If no userId provided, only allow access to public projects
      if (!input.userId) {
        if (project.visibility.value !== 'public') {
          throw new NotFoundError(PROJECT_ERRORS.NOT_FOUND(input.projectId))
        }
        return { project }
      }

      // Authorization check for authenticated users
      // Pass the already-fetched project to avoid refetching
      const canRead = await authorizationService.canReadProject(
        project,
        input.userId
      )
      if (!canRead) {
        throw new NotFoundError(PROJECT_ERRORS.NOT_FOUND(input.projectId))
      }

      return { project }
    }
  }
}
