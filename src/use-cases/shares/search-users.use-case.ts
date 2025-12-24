import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

// ============================================================================
// Types
// ============================================================================

export type UserSearchResult = {
  id: string
  username: string
}

export type SearchUsersInput = {
  query: string
  limit?: number
}

export type SearchUsersOutput = {
  users: readonly UserSearchResult[]
}

export type SearchUsersUseCase = {
  execute(input: SearchUsersInput): Promise<SearchUsersOutput>
}

// ============================================================================
// Use Case Factory
// ============================================================================

export function createSearchUsersUseCase(
  projectsRepository: IProjectsRepository
): SearchUsersUseCase {
  return {
    async execute(input: SearchUsersInput): Promise<SearchUsersOutput> {
      const { query, limit = 10 } = input

      const users = await projectsRepository.searchUsers(query, limit)

      return { users }
    }
  }
}
