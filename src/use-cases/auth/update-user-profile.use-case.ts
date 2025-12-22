import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'

/**
 * Use Case: Update User Profile
 */
export type UpdateUserProfileInput = {
  userId: string
  username?: string
}

export type UpdateUserProfileOutput = {
  error: Error | null
}

export type UpdateUserProfileUseCase = {
  execute(input: UpdateUserProfileInput): Promise<UpdateUserProfileOutput>
}

export function createUpdateUserProfileUseCase(
  authRepository: IAuthRepository
): UpdateUserProfileUseCase {
  return {
    async execute(
      input: UpdateUserProfileInput
    ): Promise<UpdateUserProfileOutput> {
      const result = await authRepository.updateUserProfile(input.userId, {
        username: input.username
      })

      return { error: result.error }
    }
  }
}
