import type { User } from '@/domain/entities/user.entity'
import type {
  IAuthRepository,
  OAuthProvider
} from '@/domain/repositories/auth.repository.interface'

/**
 * Use Case: Sign In with OAuth
 */
export type SignInWithOAuthInput = {
  provider: OAuthProvider
}

export type SignInWithOAuthOutput = {
  user: User | null
  error: Error | null
}

export type SignInWithOAuthUseCase = {
  execute(input: SignInWithOAuthInput): Promise<SignInWithOAuthOutput>
}

export function createSignInWithOAuthUseCase(
  authRepository: IAuthRepository
): SignInWithOAuthUseCase {
  return {
    async execute(input: SignInWithOAuthInput): Promise<SignInWithOAuthOutput> {
      const result = await authRepository.signInWithOAuth(input.provider)

      return {
        user: result.user,
        error: result.error
      }
    }
  }
}
