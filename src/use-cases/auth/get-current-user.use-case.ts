import type { User } from '@/domain/entities/user.entity'
import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'

/**
 * Use Case: Get Current User
 */
export type GetCurrentUserOutput = {
  user: User | null
}

export type GetCurrentUserUseCase = {
  execute(): Promise<GetCurrentUserOutput>
}

export function createGetCurrentUserUseCase(
  authRepository: IAuthRepository
): GetCurrentUserUseCase {
  return {
    async execute(): Promise<GetCurrentUserOutput> {
      const user = await authRepository.getCurrentUser()
      return { user }
    }
  }
}
