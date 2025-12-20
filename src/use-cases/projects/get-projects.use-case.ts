import type { Project } from '@/domain/entities/project.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

/**
 * Use Case: Get all projects for a user
 * Application logic layer - orchestrates domain entities and repositories
 */

export type GetProjectsInput = {
  userId: string
}

export type GetProjectsOutput = {
  projects: readonly Project[]
}

export class GetProjectsUseCase {
  constructor(private readonly projectsRepository: IProjectsRepository) {}

  async execute(input: GetProjectsInput): Promise<GetProjectsOutput> {
    const projects = await this.projectsRepository.findAll(input.userId)

    return {
      projects
    }
  }
}

// Factory function (TypeScript idiomatic)
export function createGetProjectsUseCase(
  projectsRepository: IProjectsRepository
): GetProjectsUseCase {
  return new GetProjectsUseCase(projectsRepository)
}
