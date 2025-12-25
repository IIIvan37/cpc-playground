import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useAtom } from 'jotai'
import { atomWithStorage } from 'jotai/utils'
import { useCallback, useEffect } from 'react'
import type { User } from '@/domain/entities/user.entity'
import { container } from '@/infrastructure/container'

// Auth state atom - stores user in localStorage for persistence
export const userAtom = atomWithStorage<User | null>('auth-user', null)

/**
 * Hook for authentication operations using Clean Architecture
 */
export function useAuth() {
  const [user, setUser] = useAtom(userAtom)
  const queryClient = useQueryClient()

  // Get use cases from container
  const {
    signIn: signInUseCase,
    signUp: signUpUseCase,
    signOut: signOutUseCase,
    signInWithOAuth: signInWithOAuthUseCase,
    getCurrentUser: getCurrentUserUseCase,
    requestPasswordReset: requestPasswordResetUseCase,
    updatePassword: updatePasswordUseCase,
    authRepository
  } = container

  // Use React Query to fetch and cache current user
  const { data: currentUser, isLoading } = useQuery({
    queryKey: ['auth', 'currentUser'],
    queryFn: async () => {
      const result = await getCurrentUserUseCase.execute()
      return result.user
    },
    staleTime: Number.POSITIVE_INFINITY // Never stale - we manage updates manually
  })

  // Sync React Query data with Jotai atom
  useEffect(() => {
    if (currentUser !== undefined) {
      setUser(currentUser)
    }
  }, [currentUser, setUser])

  // Listen for auth changes and update both React Query cache and atom
  useEffect(() => {
    const unsubscribe = authRepository.onAuthStateChange((newUser) => {
      setUser(newUser)
      queryClient.setQueryData(['auth', 'currentUser'], newUser)
    })

    return unsubscribe
  }, [authRepository, setUser, queryClient])

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
      queryClient.setQueryData(['auth', 'currentUser'], null)
    }
    return { error: result.error }
  }, [signOutUseCase, setUser, queryClient])

  const signInWithGithub = useCallback(async () => {
    const result = await signInWithOAuthUseCase.execute({ provider: 'github' })
    return {
      data: result.user ? { user: result.user } : null,
      error: result.error
    }
  }, [signInWithOAuthUseCase])

  const requestPasswordReset = useCallback(
    async (email: string) => {
      const result = await requestPasswordResetUseCase.execute({ email })
      return { error: result.error }
    },
    [requestPasswordResetUseCase]
  )

  const updatePassword = useCallback(
    async (newPassword: string) => {
      const result = await updatePasswordUseCase.execute({ newPassword })
      return { error: result.error }
    },
    [updatePasswordUseCase]
  )

  const hasSession = useCallback(async () => {
    return authRepository.hasSession()
  }, [authRepository])

  const onPasswordRecovery = useCallback(
    (callback: () => void) => {
      return authRepository.onPasswordRecovery(callback)
    },
    [authRepository]
  )

  return {
    user,
    loading: isLoading,
    signIn,
    signUp,
    signOut,
    signInWithGithub,
    requestPasswordReset,
    updatePassword,
    hasSession,
    onPasswordRecovery
  }
}
