import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'

/**
 * Use Case: Request Password Reset
 * Sends a password reset email to the user
 */
export type RequestPasswordResetInput = {
  email: string
  redirectTo?: string
}

export type RequestPasswordResetOutput = {
  error: Error | null
}

export type RequestPasswordResetUseCase = {
  execute(input: RequestPasswordResetInput): Promise<RequestPasswordResetOutput>
}

export function createRequestPasswordResetUseCase(
  authRepository: IAuthRepository
): RequestPasswordResetUseCase {
  return {
    async execute(
      input: RequestPasswordResetInput
    ): Promise<RequestPasswordResetOutput> {
      const result = await authRepository.resetPasswordForEmail(
        input.email,
        input.redirectTo
      )

      return {
        error: result.error
      }
    }
  }
}
