import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'

/**
 * Use Case: Sign Out
 */
export type SignOutOutput = {
  error: Error | null
}

export type SignOutUseCase = {
  execute(): Promise<SignOutOutput>
}

export function createSignOutUseCase(
  authRepository: IAuthRepository
): SignOutUseCase {
  return {
    async execute(): Promise<SignOutOutput> {
      const result = await authRepository.signOut()
      return { error: result.error }
    }
  }
}
