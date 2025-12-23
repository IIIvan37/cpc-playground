import type { User } from '@/domain/entities/user.entity'
import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'

/**
 * Use Case: Sign In
 */
export type SignInInput = {
  email: string
  password: string
}

export type SignInOutput = {
  user: User | null
  error: Error | null
}

export type SignInUseCase = {
  execute(input: SignInInput): Promise<SignInOutput>
}

export function createSignInUseCase(
  authRepository: IAuthRepository
): SignInUseCase {
  return {
    async execute(input: SignInInput): Promise<SignInOutput> {
      const result = await authRepository.signIn({
        email: input.email,
        password: input.password
      })

      return {
        user: result.user,
        error: result.error
      }
    }
  }
}
