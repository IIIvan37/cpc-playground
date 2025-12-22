import { useAtom } from 'jotai'
import { atomWithStorage } from 'jotai/utils'
import { useCallback, useEffect, useState } from 'react'
import type { User } from '@/domain/entities/user.entity'
import { container } from '@/infrastructure/container'

// Auth state atom - stores user in localStorage for persistence
export const userAtom = atomWithStorage<User | null>('auth-user', null)

/**
 * Hook for authentication operations using Clean Architecture
 */
export function useAuth() {
  const [user, setUser] = useAtom(userAtom)
  const [loading, setLoading] = useState(true)

  // Get use cases from container
  const {
    signIn: signInUseCase,
    signUp: signUpUseCase,
    signOut: signOutUseCase,
    signInWithOAuth: signInWithOAuthUseCase,
    getCurrentUser: getCurrentUserUseCase,
    authRepository
  } = container

  useEffect(() => {
    // Get initial user
    getCurrentUserUseCase.execute().then(({ user: currentUser }) => {
      setUser(currentUser)
      setLoading(false)
    })

    // Listen for auth changes
    const unsubscribe = authRepository.onAuthStateChange((newUser) => {
      setUser(newUser)
    })

    return unsubscribe
  }, [setUser, getCurrentUserUseCase, authRepository])

  const signIn = useCallback(
    async (email: string, password: string) => {
      const result = await signInUseCase.execute({ email, password })
      return {
        data: result.user ? { user: result.user } : null,
        error: result.error
      }
    },
    [signInUseCase]
  )

  const signUp = useCallback(
    async (email: string, password: string) => {
      const result = await signUpUseCase.execute({ email, password })
      return {
        data: result.user ? { user: result.user } : null,
        error: result.error
      }
    },
    [signUpUseCase]
  )

  const signOut = useCallback(async () => {
    const result = await signOutUseCase.execute()
    if (!result.error) {
      setUser(null)
    }
    return { error: result.error }
  }, [signOutUseCase, setUser])

  const signInWithGithub = useCallback(async () => {
    const result = await signInWithOAuthUseCase.execute({ provider: 'github' })
    return {
      data: result.user ? { user: result.user } : null,
      error: result.error
    }
  }, [signInWithOAuthUseCase])

  return {
    user,
    loading,
    signIn,
    signUp,
    signOut,
    signInWithGithub
  }
}
