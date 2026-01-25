import type { Project } from '@/domain/entities/project.entity'
import type {
  IProjectsRepository,
  ProjectSearchParams
} from '@/domain/repositories/projects.repository.interface'
import type { PaginatedResult } from '@/domain/types/pagination'

/**
 * Use Case: Get visible projects with pagination
 * - Authenticated user: public projects + own projects + shared projects
 * - Anonymous user: only public projects
 * - Supports server-side search and filtering
 */

export type GetVisibleProjectsPaginatedInput = {
  userId?: string
  limit: number
  offset: number
  search?: string
  librariesOnly?: boolean
}

export type GetVisibleProjectsPaginatedOutput = PaginatedResult<Project>

export type GetVisibleProjectsPaginatedUseCase = {
  execute(
    input: GetVisibleProjectsPaginatedInput
  ): Promise<GetVisibleProjectsPaginatedOutput>
}

/**
 * Factory function that creates GetVisibleProjectsPaginatedUseCase
 */
export function createGetVisibleProjectsPaginatedUseCase(
  projectsRepository: IProjectsRepository
): GetVisibleProjectsPaginatedUseCase {
  return {
    async execute(
      input: GetVisibleProjectsPaginatedInput
    ): Promise<GetVisibleProjectsPaginatedOutput> {
      const params: ProjectSearchParams = {
        limit: input.limit,
        offset: input.offset,
        search: input.search,
        librariesOnly: input.librariesOnly
      }

      return projectsRepository.findVisiblePaginated(input.userId, params)
    }
  }
}
