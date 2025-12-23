import type { User } from '@/domain/entities/user.entity'
import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'

/**
 * Use Case: Sign Up
 */
export type SignUpInput = {
  email: string
  password: string
  username?: string
}

export type SignUpOutput = {
  user: User | null
  error: Error | null
}

export type SignUpUseCase = {
  execute(input: SignUpInput): Promise<SignUpOutput>
}

export function createSignUpUseCase(
  authRepository: IAuthRepository
): SignUpUseCase {
  return {
    async execute(input: SignUpInput): Promise<SignUpOutput> {
      const result = await authRepository.signUp({
        email: input.email,
        password: input.password,
        username: input.username
      })

      return {
        user: result.user,
        error: result.error
      }
    }
  }
}
