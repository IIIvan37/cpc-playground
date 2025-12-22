import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'
import { createUsername } from '@/domain/value-objects/username.vo'

/**
 * Use Case: Update User Profile
 * Validates and updates user profile data
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
      // Validate username using value object (throws ValidationError if invalid)
      const validatedUsername = input.username
        ? createUsername(input.username).value
        : undefined

      const result = await authRepository.updateUserProfile(input.userId, {
        username: validatedUsername
      })

      return { error: result.error }
    }
  }
}
