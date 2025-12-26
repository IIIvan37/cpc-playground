import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

export type GetAllTagsInput = Record<string, never>

export type GetAllTagsOutput = Readonly<{
  tags: readonly string[]
}>

export interface GetAllTagsUseCase {
  execute(input: GetAllTagsInput): Promise<GetAllTagsOutput>
}

/**
 * Factory function to create the GetAllTagsUseCase
 */
export function createGetAllTagsUseCase(
  projectsRepository: IProjectsRepository
): GetAllTagsUseCase {
  return {
    async execute(): Promise<GetAllTagsOutput> {
      const tags = await projectsRepository.getAllTags()
      return { tags: tags.map((tag) => tag.name) }
    }
  }
}
