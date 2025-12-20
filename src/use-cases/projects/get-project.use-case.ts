import type { Project } from '@/domain/entities/project.entity'
import { NotFoundError } from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

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

export class GetProjectUseCase {
  constructor(private readonly projectsRepository: IProjectsRepository) {}

  async execute(input: GetProjectInput): Promise<GetProjectOutput> {
    const project = await this.projectsRepository.findById(input.projectId)

    if (!project) {
      throw new NotFoundError(`Project ${input.projectId} not found`)
    }

    // Authorization check if userId is provided
    if (input.userId && project.userId !== input.userId) {
      throw new NotFoundError(`Project ${input.projectId} not found`)
    }

    return { project }
  }
}

export function createGetProjectUseCase(
  projectsRepository: IProjectsRepository
): GetProjectUseCase {
  return new GetProjectUseCase(projectsRepository)
}
