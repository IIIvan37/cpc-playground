import type { Project } from '@/domain/entities/project.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

/**
 * Use Case: Get all projects visible to a user
 * - Authenticated user: public projects + own projects + shared projects
 * - Anonymous user: only public projects
 */

export type GetVisibleProjectsInput = {
  userId?: string
}

export type GetVisibleProjectsOutput = {
  projects: readonly Project[]
}

export type GetVisibleProjectsUseCase = {
  execute(input: GetVisibleProjectsInput): Promise<GetVisibleProjectsOutput>
}

/**
 * Factory function that creates GetVisibleProjectsUseCase
 */
export function createGetVisibleProjectsUseCase(
  projectsRepository: IProjectsRepository
): GetVisibleProjectsUseCase {
  return {
    async execute(
      input: GetVisibleProjectsInput
    ): Promise<GetVisibleProjectsOutput> {
      const projects = await projectsRepository.findVisible(input.userId)

      return {
        projects
      }
    }
  }
}
