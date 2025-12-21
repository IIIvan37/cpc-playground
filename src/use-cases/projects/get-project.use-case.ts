import type { Project } from '@/domain/entities/project.entity'
import { NotFoundError } from '@/domain/errors/domain.error'
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
        throw new NotFoundError(`Project ${input.projectId} not found`)
      }

      // Authorization check if userId is provided
      if (input.userId) {
        const canRead = await authorizationService.canReadProject(
          input.projectId,
          input.userId
        )
        if (!canRead) {
          throw new NotFoundError(`Project ${input.projectId} not found`)
        }
      }

      return { project }
    }
  }
}
