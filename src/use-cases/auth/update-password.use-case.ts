import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'

/**
 * Use Case: Update Password
 * Updates the password for the authenticated user (after password reset)
 */
export type UpdatePasswordInput = {
  newPassword: string
}

export type UpdatePasswordOutput = {
  error: Error | null
}

export type UpdatePasswordUseCase = {
  execute(input: UpdatePasswordInput): Promise<UpdatePasswordOutput>
}

export function createUpdatePasswordUseCase(
  authRepository: IAuthRepository
): UpdatePasswordUseCase {
  return {
    async execute(input: UpdatePasswordInput): Promise<UpdatePasswordOutput> {
      const result = await authRepository.updatePassword(input.newPassword)

      return {
        error: result.error
      }
    }
  }
}
