import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { act, renderHook, waitFor } from '@testing-library/react'
import { createStore, Provider } from 'jotai'
import type { ReactNode } from 'react'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import type { User } from '@/domain/entities/user.entity'
import { useAuth, userAtom } from '../use-auth'

// Mock the container
const mockSignIn = vi.fn()
const mockSignUp = vi.fn()
const mockSignOut = vi.fn()
const mockSignInWithOAuth = vi.fn()
const mockGetCurrentUser = vi.fn()
const mockRequestPasswordReset = vi.fn()
const mockUpdatePassword = vi.fn()
const mockOnAuthStateChange = vi.fn()

vi.mock('@/infrastructure/container', () => ({
  container: {
    signIn: { execute: (...args: unknown[]) => mockSignIn(...args) },
    signUp: { execute: (...args: unknown[]) => mockSignUp(...args) },
    signOut: { execute: (...args: unknown[]) => mockSignOut(...args) },
    signInWithOAuth: {
      execute: (...args: unknown[]) => mockSignInWithOAuth(...args)
    },
    getCurrentUser: {
      execute: (...args: unknown[]) => mockGetCurrentUser(...args)
    },
    requestPasswordReset: {
      execute: (...args: unknown[]) => mockRequestPasswordReset(...args)
    },
    updatePassword: {
      execute: (...args: unknown[]) => mockUpdatePassword(...args)
    },
    authRepository: {
      onAuthStateChange: (callback: (user: User | null) => void) =>
        mockOnAuthStateChange(callback)
    }
  }
}))

const mockUser: User = {
  id: 'user-123',
  email: 'test@example.com',
  profile: {
    id: 'profile-123',
    username: 'testuser',
    createdAt: new Date(),
    updatedAt: new Date()
  }
}

describe('useAuth', () => {
  let store: ReturnType<typeof createStore>
  let queryClient: QueryClient
  let authStateCallback: ((user: User | null) => void) | null = null

  const wrapper = ({ children }: { children: ReactNode }) => (
    <QueryClientProvider client={queryClient}>
      <Provider store={store}>{children}</Provider>
    </QueryClientProvider>
  )

  beforeEach(() => {
    vi.clearAllMocks()
    store = createStore()
    queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
        mutations: { retry: false }
      }
    })
    authStateCallback = null

    // Default mock implementations
    mockGetCurrentUser.mockResolvedValue({ user: null })
    mockOnAuthStateChange.mockImplementation((callback) => {
      authStateCallback = callback
      return vi.fn() // unsubscribe function
    })
  })

  describe('initialization', () => {
    it('fetches current user on mount', async () => {
      mockGetCurrentUser.mockResolvedValue({ user: mockUser })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })

      expect(mockGetCurrentUser).toHaveBeenCalled()
      expect(result.current.user).toEqual(mockUser)
    })

    it('subscribes to auth state changes', async () => {
      renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(mockOnAuthStateChange).toHaveBeenCalled()
      })
    })

    it('updates user when auth state changes', async () => {
      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })

      // Simulate auth state change
      act(() => {
        authStateCallback?.(mockUser)
      })

      expect(result.current.user).toEqual(mockUser)
    })

    it('unsubscribes on unmount', async () => {
      const unsubscribe = vi.fn()
      mockOnAuthStateChange.mockReturnValue(unsubscribe)

      const { unmount } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(mockOnAuthStateChange).toHaveBeenCalled()
      })

      unmount()
      expect(unsubscribe).toHaveBeenCalled()
    })
  })

  describe('signIn', () => {
    it('calls signIn use case with credentials', async () => {
      mockSignIn.mockResolvedValue({ user: mockUser, error: null })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })

      const response = await result.current.signIn(
        'test@example.com',
        'password123'
      )

      expect(mockSignIn).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123'
      })
      expect(response.data?.user).toEqual(mockUser)
      expect(response.error).toBeNull()
    })

    it('returns error on sign in failure', async () => {
      const error = new Error('Invalid credentials')
      mockSignIn.mockResolvedValue({ user: null, error })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })

      const response = await result.current.signIn(
        'test@example.com',
        'wrong-password'
      )

      expect(response.data).toBeNull()
      expect(response.error).toEqual(error)
    })
  })

  describe('signUp', () => {
    it('calls signUp use case with credentials', async () => {
      mockSignUp.mockResolvedValue({ user: mockUser, error: null })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })

      const response = await result.current.signUp(
        'new@example.com',
        'password123'
      )

      expect(mockSignUp).toHaveBeenCalledWith({
        email: 'new@example.com',
        password: 'password123'
      })
      expect(response.data?.user).toEqual(mockUser)
    })

    it('returns error on sign up failure', async () => {
      const error = new Error('Email already exists')
      mockSignUp.mockResolvedValue({ user: null, error })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })

      const response = await result.current.signUp(
        'existing@example.com',
        'password123'
      )

      expect(response.data).toBeNull()
      expect(response.error).toEqual(error)
    })
  })

  describe('signOut', () => {
    it('calls signOut use case and clears user', async () => {
      mockGetCurrentUser.mockResolvedValue({ user: mockUser })
      mockSignOut.mockResolvedValue({ error: null })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.user).toEqual(mockUser)
      })

      await act(async () => {
        await result.current.signOut()
      })

      expect(mockSignOut).toHaveBeenCalled()
      expect(result.current.user).toBeNull()
    })

    it('does not clear user on sign out error', async () => {
      mockGetCurrentUser.mockResolvedValue({ user: mockUser })
      const error = new Error('Network error')
      mockSignOut.mockResolvedValue({ error })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.user).toEqual(mockUser)
      })

      const response = await act(async () => {
        return await result.current.signOut()
      })

      expect(response.error).toEqual(error)
      expect(result.current.user).toEqual(mockUser)
    })
  })

  describe('signInWithGithub', () => {
    it('calls signInWithOAuth use case with github provider', async () => {
      mockSignInWithOAuth.mockResolvedValue({ user: mockUser, error: null })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })

      const response = await result.current.signInWithGithub()

      expect(mockSignInWithOAuth).toHaveBeenCalledWith({ provider: 'github' })
      expect(response.data?.user).toEqual(mockUser)
    })
  })

  describe('requestPasswordReset', () => {
    it('calls requestPasswordReset use case', async () => {
      mockRequestPasswordReset.mockResolvedValue({ error: null })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })

      const response =
        await result.current.requestPasswordReset('test@example.com')

      expect(mockRequestPasswordReset).toHaveBeenCalledWith({
        email: 'test@example.com'
      })
      expect(response.error).toBeNull()
    })

    it('returns error on password reset failure', async () => {
      const error = new Error('User not found')
      mockRequestPasswordReset.mockResolvedValue({ error })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })

      const response = await result.current.requestPasswordReset(
        'unknown@example.com'
      )

      expect(response.error).toEqual(error)
    })
  })

  describe('updatePassword', () => {
    it('calls updatePassword use case', async () => {
      mockUpdatePassword.mockResolvedValue({ error: null })

      const { result } = renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        expect(result.current.loading).toBe(false)
      })

      const response = await result.current.updatePassword('newPassword123')

      expect(mockUpdatePassword).toHaveBeenCalledWith({
        newPassword: 'newPassword123'
      })
      expect(response.error).toBeNull()
    })
  })

  describe('user atom persistence', () => {
    it('persists user to store', async () => {
      mockGetCurrentUser.mockResolvedValue({ user: mockUser })

      renderHook(() => useAuth(), { wrapper })

      await waitFor(() => {
        const storedUser = store.get(userAtom)
        expect(storedUser?.id).toBe(mockUser.id)
        expect(storedUser?.email).toBe(mockUser.email)
      })
    })

    it('uses persisted user from store', async () => {
      store.set(userAtom, mockUser)

      const { result } = renderHook(() => useAuth(), { wrapper })

      // Initially uses persisted user
      expect(result.current.user?.id).toBe(mockUser.id)
      expect(result.current.user?.email).toBe(mockUser.email)
    })
  })
})
