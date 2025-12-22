import type { Subscription, SupabaseClient, User } from '@supabase/supabase-js'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import type { Database } from '@/types/database.types'
import { createSupabaseAuthRepository } from '../supabase-auth.repository'

// Helper to create a mock User with all required properties
function createMockUser(overrides: Partial<User> = {}): User {
  return {
    id: 'user-123',
    email: 'test@example.com',
    app_metadata: {},
    user_metadata: {},
    aud: 'authenticated',
    created_at: new Date().toISOString(),
    ...overrides
  }
}

// Helper to create a mock Subscription with all required properties
function createMockSubscription(
  unsubscribeFn: () => void = vi.fn()
): Subscription {
  return {
    id: 'subscription-123',
    callback: vi.fn() as never,
    unsubscribe: unsubscribeFn
  }
}

// Mock Supabase client
function createMockSupabase() {
  return {
    auth: {
      signInWithPassword: vi.fn(),
      signUp: vi.fn(),
      signOut: vi.fn(),
      signInWithOAuth: vi.fn(),
      getUser: vi.fn(),
      onAuthStateChange: vi.fn(() => ({
        data: {
          subscription: createMockSubscription()
        }
      }))
    },
    from: vi.fn(() => ({
      select: vi.fn(() => ({
        eq: vi.fn(() => ({
          single: vi.fn()
        }))
      })),
      update: vi.fn(() => ({
        eq: vi.fn()
      }))
    }))
  } as unknown as SupabaseClient<Database>
}

describe('SupabaseAuthRepository', () => {
  let mockSupabase: ReturnType<typeof createMockSupabase>
  let repository: ReturnType<typeof createSupabaseAuthRepository>

  beforeEach(() => {
    mockSupabase = createMockSupabase()
    repository = createSupabaseAuthRepository(mockSupabase)
    vi.clearAllMocks()
  })

  describe('signIn', () => {
    it('should sign in successfully', async () => {
      const mockUser = createMockUser()
      vi.mocked(mockSupabase.auth.signInWithPassword).mockResolvedValue({
        data: { user: mockUser, session: {} as never },
        error: null
      })

      const result = await repository.signIn({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toBeDefined()
      expect(result.user?.id).toBe('user-123')
      expect(result.user?.email).toBe('test@example.com')
      expect(result.error).toBeNull()
      expect(mockSupabase.auth.signInWithPassword).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123'
      })
    })

    it('should return error on invalid credentials', async () => {
      vi.mocked(mockSupabase.auth.signInWithPassword).mockResolvedValue({
        data: { user: null, session: null },
        error: { message: 'Invalid credentials' } as never
      })

      const result = await repository.signIn({
        email: 'test@example.com',
        password: 'wrong'
      })

      expect(result.user).toBeNull()
      expect(result.error?.message).toBe('Invalid credentials')
    })

    it('should return null user when no user returned', async () => {
      vi.mocked(mockSupabase.auth.signInWithPassword).mockResolvedValue({
        data: { user: null, session: null },
        error: null
      } as never)

      const result = await repository.signIn({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toBeNull()
      expect(result.error).toBeNull()
    })

    it('should handle exceptions', async () => {
      vi.mocked(mockSupabase.auth.signInWithPassword).mockRejectedValue(
        new Error('Network error')
      )

      const result = await repository.signIn({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toBeNull()
      expect(result.error?.message).toBe('Network error')
    })

    it('should handle non-Error exceptions', async () => {
      vi.mocked(mockSupabase.auth.signInWithPassword).mockRejectedValue(
        'Unknown error'
      )

      const result = await repository.signIn({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toBeNull()
      expect(result.error?.message).toBe('Failed to sign in')
    })
  })

  describe('signUp', () => {
    it('should sign up successfully', async () => {
      const mockUser = createMockUser()
      vi.mocked(mockSupabase.auth.signUp).mockResolvedValue({
        data: { user: mockUser, session: {} as never },
        error: null
      })

      const result = await repository.signUp({
        email: 'test@example.com',
        password: 'password123',
        username: 'testuser'
      })

      expect(result.user).toBeDefined()
      expect(result.user?.id).toBe('user-123')
      expect(result.error).toBeNull()
      expect(mockSupabase.auth.signUp).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
        options: {
          data: { username: 'testuser' }
        }
      })
    })

    it('should sign up without username', async () => {
      const mockUser = createMockUser()
      vi.mocked(mockSupabase.auth.signUp).mockResolvedValue({
        data: { user: mockUser, session: {} as never },
        error: null
      })

      await repository.signUp({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(mockSupabase.auth.signUp).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
        options: {
          data: {}
        }
      })
    })

    it('should return error on failure', async () => {
      vi.mocked(mockSupabase.auth.signUp).mockResolvedValue({
        data: { user: null, session: null },
        error: { message: 'Email already exists' } as never
      })

      const result = await repository.signUp({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toBeNull()
      expect(result.error?.message).toBe('Email already exists')
    })

    it('should return null user when no user returned', async () => {
      vi.mocked(mockSupabase.auth.signUp).mockResolvedValue({
        data: { user: null, session: null },
        error: null
      })

      const result = await repository.signUp({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toBeNull()
      expect(result.error).toBeNull()
    })

    it('should handle exceptions', async () => {
      vi.mocked(mockSupabase.auth.signUp).mockRejectedValue(
        new Error('Network error')
      )

      const result = await repository.signUp({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toBeNull()
      expect(result.error?.message).toBe('Network error')
    })

    it('should handle non-Error exceptions', async () => {
      vi.mocked(mockSupabase.auth.signUp).mockRejectedValue('Unknown error')

      const result = await repository.signUp({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toBeNull()
      expect(result.error?.message).toBe('Failed to sign up')
    })
  })

  describe('signOut', () => {
    it('should sign out successfully', async () => {
      vi.mocked(mockSupabase.auth.signOut).mockResolvedValue({
        error: null
      })

      const result = await repository.signOut()

      expect(result.error).toBeNull()
      expect(mockSupabase.auth.signOut).toHaveBeenCalledWith({ scope: 'local' })
    })

    it('should return error on failure (non-403)', async () => {
      vi.mocked(mockSupabase.auth.signOut).mockResolvedValue({
        error: { message: 'Server error' } as never
      })

      const result = await repository.signOut()

      expect(result.error?.message).toBe('Server error')
    })

    it('should ignore 403 errors', async () => {
      vi.mocked(mockSupabase.auth.signOut).mockResolvedValue({
        error: { message: 'Error 403: Forbidden' } as never
      })

      const result = await repository.signOut()

      expect(result.error).toBeNull()
    })

    it('should handle exceptions gracefully', async () => {
      const consoleSpy = vi.spyOn(console, 'warn').mockImplementation(() => {})
      vi.mocked(mockSupabase.auth.signOut).mockRejectedValue(
        new Error('Network error')
      )

      const result = await repository.signOut()

      expect(result.error).toBeNull()
      expect(consoleSpy).toHaveBeenCalled()
      consoleSpy.mockRestore()
    })
  })

  describe('signInWithOAuth', () => {
    it('should initiate OAuth sign in', async () => {
      vi.mocked(mockSupabase.auth.signInWithOAuth).mockResolvedValue({
        data: { provider: 'github', url: 'https://github.com/login' },
        error: null
      })

      const result = await repository.signInWithOAuth('github')

      expect(result.error).toBeNull()
      expect(result.user).toBeNull() // OAuth redirects, no immediate user
      expect(mockSupabase.auth.signInWithOAuth).toHaveBeenCalledWith({
        provider: 'github',
        options: {
          redirectTo: globalThis.location.origin
        }
      })
    })

    it('should return error on OAuth failure', async () => {
      vi.mocked(mockSupabase.auth.signInWithOAuth).mockResolvedValue({
        data: { provider: 'github', url: null },
        error: { message: 'OAuth failed' } as never
      })

      const result = await repository.signInWithOAuth('github')

      expect(result.error?.message).toBe('OAuth failed')
    })

    it('should handle exceptions', async () => {
      vi.mocked(mockSupabase.auth.signInWithOAuth).mockRejectedValue(
        new Error('Network error')
      )

      const result = await repository.signInWithOAuth('github')

      expect(result.error?.message).toBe('Network error')
    })

    it('should handle non-Error exceptions', async () => {
      vi.mocked(mockSupabase.auth.signInWithOAuth).mockRejectedValue(
        'Unknown error'
      )

      const result = await repository.signInWithOAuth('github')

      expect(result.error?.message).toBe('Failed to sign in with github')
    })
  })

  describe('getCurrentUser', () => {
    it('should return current user', async () => {
      const mockUser = createMockUser()
      vi.mocked(mockSupabase.auth.getUser).mockResolvedValue({
        data: { user: mockUser },
        error: null
      })

      const result = await repository.getCurrentUser()

      expect(result).toBeDefined()
      expect(result?.id).toBe('user-123')
      expect(result?.email).toBe('test@example.com')
    })

    it('should return null on error', async () => {
      vi.mocked(mockSupabase.auth.getUser).mockResolvedValue({
        data: { user: null },
        error: { message: 'Not authenticated' } as never
      })

      const result = await repository.getCurrentUser()

      expect(result).toBeNull()
    })

    it('should return null when no user', async () => {
      vi.mocked(mockSupabase.auth.getUser).mockResolvedValue({
        data: { user: null },
        error: null
      } as never)

      const result = await repository.getCurrentUser()

      expect(result).toBeNull()
    })

    it('should handle exceptions', async () => {
      vi.mocked(mockSupabase.auth.getUser).mockRejectedValue(
        new Error('Network error')
      )

      const result = await repository.getCurrentUser()

      expect(result).toBeNull()
    })
  })

  describe('onAuthStateChange', () => {
    it('should subscribe to auth state changes', () => {
      const callback = vi.fn()
      const unsubscribe = repository.onAuthStateChange(callback)

      expect(mockSupabase.auth.onAuthStateChange).toHaveBeenCalled()
      expect(typeof unsubscribe).toBe('function')
    })

    it('should call callback with user on state change', () => {
      const callback = vi.fn()
      let capturedCallback: (
        event: string,
        session: { user: { id: string; email: string } } | null
      ) => void

      vi.mocked(mockSupabase.auth.onAuthStateChange).mockImplementation(
        (cb) => {
          capturedCallback = cb as typeof capturedCallback
          return {
            data: {
              subscription: createMockSubscription()
            }
          }
        }
      )

      repository.onAuthStateChange(callback)

      // Simulate auth state change with user
      capturedCallback!('SIGNED_IN', {
        user: { id: 'user-123', email: 'test@example.com' }
      })

      expect(callback).toHaveBeenCalledWith(
        expect.objectContaining({
          id: 'user-123',
          email: 'test@example.com'
        })
      )
    })

    it('should call callback with null on sign out', () => {
      const callback = vi.fn()
      let capturedCallback: (
        event: string,
        session: { user: { id: string; email: string } } | null
      ) => void

      vi.mocked(mockSupabase.auth.onAuthStateChange).mockImplementation(
        (cb) => {
          capturedCallback = cb as typeof capturedCallback
          return {
            data: {
              subscription: createMockSubscription()
            }
          }
        }
      )

      repository.onAuthStateChange(callback)

      // Simulate sign out
      capturedCallback!('SIGNED_OUT', null)

      expect(callback).toHaveBeenCalledWith(null)
    })

    it('should unsubscribe when called', () => {
      const unsubscribeMock = vi.fn()
      vi.mocked(mockSupabase.auth.onAuthStateChange).mockReturnValue({
        data: {
          subscription: createMockSubscription(unsubscribeMock)
        }
      })

      const unsubscribe = repository.onAuthStateChange(vi.fn())
      unsubscribe()

      expect(unsubscribeMock).toHaveBeenCalled()
    })
  })

  describe('getUserProfile', () => {
    it('should return user profile', async () => {
      const mockProfile = {
        id: 'user-123',
        username: 'testuser',
        created_at: '2024-01-01T00:00:00Z',
        updated_at: '2024-06-01T00:00:00Z'
      }

      const singleMock = vi.fn().mockResolvedValue({
        data: mockProfile,
        error: null
      })
      const eqMock = vi.fn(() => ({ single: singleMock }))
      const selectMock = vi.fn(() => ({ eq: eqMock }))
      vi.mocked(mockSupabase.from).mockReturnValue({
        select: selectMock
      } as never)

      const result = await repository.getUserProfile('user-123')

      expect(result).toBeDefined()
      expect(result?.id).toBe('user-123')
      expect(result?.username).toBe('testuser')
      expect(mockSupabase.from).toHaveBeenCalledWith('user_profiles')
      expect(selectMock).toHaveBeenCalledWith('*')
      expect(eqMock).toHaveBeenCalledWith('id', 'user-123')
    })

    it('should return null on error', async () => {
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})
      const singleMock = vi.fn().mockResolvedValue({
        data: null,
        error: { message: 'Not found' }
      })
      const eqMock = vi.fn(() => ({ single: singleMock }))
      const selectMock = vi.fn(() => ({ eq: eqMock }))
      vi.mocked(mockSupabase.from).mockReturnValue({
        select: selectMock
      } as never)

      const result = await repository.getUserProfile('user-123')

      expect(result).toBeNull()
      expect(consoleSpy).toHaveBeenCalled()
      consoleSpy.mockRestore()
    })

    it('should return null when no data', async () => {
      const singleMock = vi.fn().mockResolvedValue({
        data: null,
        error: null
      })
      const eqMock = vi.fn(() => ({ single: singleMock }))
      const selectMock = vi.fn(() => ({ eq: eqMock }))
      vi.mocked(mockSupabase.from).mockReturnValue({
        select: selectMock
      } as never)

      const result = await repository.getUserProfile('user-123')

      expect(result).toBeNull()
    })

    it('should handle exceptions', async () => {
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})
      const singleMock = vi.fn().mockRejectedValue(new Error('Network error'))
      const eqMock = vi.fn(() => ({ single: singleMock }))
      const selectMock = vi.fn(() => ({ eq: eqMock }))
      vi.mocked(mockSupabase.from).mockReturnValue({
        select: selectMock
      } as never)

      const result = await repository.getUserProfile('user-123')

      expect(result).toBeNull()
      expect(consoleSpy).toHaveBeenCalled()
      consoleSpy.mockRestore()
    })
  })

  describe('updateUserProfile', () => {
    it('should update profile successfully', async () => {
      const eqMock = vi.fn().mockResolvedValue({
        error: null
      })
      const updateMock = vi.fn(() => ({ eq: eqMock }))
      vi.mocked(mockSupabase.from).mockReturnValue({
        update: updateMock
      } as never)

      const result = await repository.updateUserProfile('user-123', {
        username: 'newusername'
      })

      expect(result.error).toBeNull()
      expect(mockSupabase.from).toHaveBeenCalledWith('user_profiles')
      expect(updateMock).toHaveBeenCalledWith({ username: 'newusername' })
      expect(eqMock).toHaveBeenCalledWith('id', 'user-123')
    })

    it('should return error on failure', async () => {
      const eqMock = vi.fn().mockResolvedValue({
        error: { message: 'Update failed' }
      })
      const updateMock = vi.fn(() => ({ eq: eqMock }))
      vi.mocked(mockSupabase.from).mockReturnValue({
        update: updateMock
      } as never)

      const result = await repository.updateUserProfile('user-123', {
        username: 'newusername'
      })

      expect(result.error?.message).toBe('Update failed')
    })

    it('should handle exceptions', async () => {
      const eqMock = vi.fn().mockRejectedValue(new Error('Network error'))
      const updateMock = vi.fn(() => ({ eq: eqMock }))
      vi.mocked(mockSupabase.from).mockReturnValue({
        update: updateMock
      } as never)

      const result = await repository.updateUserProfile('user-123', {
        username: 'newusername'
      })

      expect(result.error?.message).toBe('Network error')
    })

    it('should handle non-Error exceptions', async () => {
      const eqMock = vi.fn().mockRejectedValue('Unknown error')
      const updateMock = vi.fn(() => ({ eq: eqMock }))
      vi.mocked(mockSupabase.from).mockReturnValue({
        update: updateMock
      } as never)

      const result = await repository.updateUserProfile('user-123', {
        username: 'newusername'
      })

      expect(result.error?.message).toBe('Failed to update profile')
    })
  })
})
