import type { UserProfile } from '@/domain/entities/user.entity'
import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'

/**
 * Use Case: Get User Profile
 */
export type GetUserProfileInput = {
  userId: string
}

export type GetUserProfileOutput = {
  profile: UserProfile | null
}

export type GetUserProfileUseCase = {
  execute(input: GetUserProfileInput): Promise<GetUserProfileOutput>
}

export function createGetUserProfileUseCase(
  authRepository: IAuthRepository
): GetUserProfileUseCase {
  return {
    async execute(input: GetUserProfileInput): Promise<GetUserProfileOutput> {
      const profile = await authRepository.getUserProfile(input.userId)
      return { profile }
    }
  }
}
