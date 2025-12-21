import { beforeEach, describe, expect, it, vi } from 'vitest'

// Mock the supabase module first, before importing anything
vi.mock('@/lib/supabase', () => ({
  supabase: {
    auth: {
      signInWithPassword: vi.fn(),
      signUp: vi.fn(),
      signOut: vi.fn(),
      signInWithOAuth: vi.fn(),
      getSession: vi.fn(),
      getUser: vi.fn(),
      onAuthStateChange: vi.fn()
    },
    from: vi.fn()
  }
}))

import { supabase } from '@/lib/supabase'
// Now import after the mock is set up
import { AuthService } from '../auth.service'

const mockSupabase = supabase as any

describe('AuthService', () => {
  let authService: AuthService

  beforeEach(() => {
    vi.clearAllMocks()
    authService = new AuthService()
  })

  describe('signIn', () => {
    it('should sign in successfully with valid credentials', async () => {
      const mockUser = {
        id: 'user-123',
        email: 'test@example.com'
      }

      mockSupabase.auth.signInWithPassword.mockResolvedValue({
        data: { user: mockUser, session: {} },
        error: null
      })

      const result = await authService.signIn({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toEqual(mockUser)
      expect(result.error).toBeNull()
      expect(mockSupabase.auth.signInWithPassword).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123'
      })
    })

    it('should return error when sign in fails', async () => {
      mockSupabase.auth.signInWithPassword.mockResolvedValue({
        data: { user: null, session: null },
        error: { message: 'Invalid credentials' }
      })

      const result = await authService.signIn({
        email: 'test@example.com',
        password: 'wrong'
      })

      expect(result.user).toBeNull()
      expect(result.error).toEqual({ message: 'Invalid credentials' })
    })

    it('should handle exceptions gracefully', async () => {
      mockSupabase.auth.signInWithPassword.mockRejectedValue(
        new Error('Network error')
      )

      const result = await authService.signIn({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toBeNull()
      expect(result.error?.message).toBe('Network error')
    })
  })

  describe('signUp', () => {
    it('should sign up successfully with email and password', async () => {
      const mockUser = {
        id: 'user-456',
        email: 'newuser@example.com'
      }

      mockSupabase.auth.signUp.mockResolvedValue({
        data: { user: mockUser, session: null },
        error: null
      })

      const result = await authService.signUp({
        email: 'newuser@example.com',
        password: 'password123'
      })

      expect(result.user).toEqual(mockUser)
      expect(result.error).toBeNull()
      expect(mockSupabase.auth.signUp).toHaveBeenCalledWith({
        email: 'newuser@example.com',
        password: 'password123',
        options: { data: {} }
      })
    })

    it('should include username in metadata when provided', async () => {
      mockSupabase.auth.signUp.mockResolvedValue({
        data: { user: {}, session: null },
        error: null
      })

      await authService.signUp({
        email: 'test@example.com',
        password: 'password123',
        username: 'testuser'
      })

      expect(mockSupabase.auth.signUp).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
        options: { data: { username: 'testuser' } }
      })
    })

    it('should return error when email already exists', async () => {
      mockSupabase.auth.signUp.mockResolvedValue({
        data: { user: null, session: null },
        error: { message: 'User already registered' }
      })

      const result = await authService.signUp({
        email: 'existing@example.com',
        password: 'password123'
      })

      expect(result.user).toBeNull()
      expect(result.error?.message).toBe('User already registered')
    })
  })

  describe('signOut', () => {
    it('should sign out successfully', async () => {
      mockSupabase.auth.signOut.mockResolvedValue({
        error: null
      })

      const result = await authService.signOut()

      expect(result.error).toBeNull()
      expect(mockSupabase.auth.signOut).toHaveBeenCalled()
    })

    it('should return error when sign out fails', async () => {
      mockSupabase.auth.signOut.mockResolvedValue({
        error: { message: 'Failed to sign out' }
      })

      const result = await authService.signOut()

      expect(result.error?.message).toBe('Failed to sign out')
    })
  })

  describe('signInWithGithub', () => {
    it('should initiate GitHub OAuth flow', async () => {
      mockSupabase.auth.signInWithOAuth.mockResolvedValue({
        data: { provider: 'github', url: 'https://github.com/oauth' },
        error: null
      })

      const result = await authService.signInWithGithub()

      expect(result.error).toBeNull()
      expect(mockSupabase.auth.signInWithOAuth).toHaveBeenCalledWith({
        provider: 'github',
        options: {
          redirectTo: window.location.origin
        }
      })
    })
  })

  describe('getUserProfile', () => {
    it('should fetch user profile by ID', async () => {
      const mockProfile = {
        id: 'user-123',
        username: 'testuser',
        created_at: '2024-01-01',
        updated_at: '2024-01-02'
      }

      const mockFrom = {
        select: vi.fn().mockReturnThis(),
        eq: vi.fn().mockReturnThis(),
        single: vi.fn().mockResolvedValue({ data: mockProfile, error: null })
      }

      mockSupabase.from.mockReturnValue(mockFrom)

      const result = await authService.getUserProfile('user-123')

      expect(result).toEqual({
        id: 'user-123',
        username: 'testuser',
        createdAt: '2024-01-01',
        updatedAt: '2024-01-02'
      })
      expect(mockSupabase.from).toHaveBeenCalledWith('user_profiles')
    })

    it('should return null when profile not found', async () => {
      const mockFrom = {
        select: vi.fn().mockReturnThis(),
        eq: vi.fn().mockReturnThis(),
        single: vi
          .fn()
          .mockResolvedValue({ data: null, error: { message: 'Not found' } })
      }

      mockSupabase.from.mockReturnValue(mockFrom)

      const result = await authService.getUserProfile('nonexistent')

      expect(result).toBeNull()
    })
  })

  describe('updateUserProfile', () => {
    it('should update user profile successfully', async () => {
      const mockFrom = {
        update: vi.fn().mockReturnThis(),
        eq: vi.fn().mockResolvedValue({ error: null })
      }

      mockSupabase.from.mockReturnValue(mockFrom)

      const result = await authService.updateUserProfile('user-123', {
        username: 'newusername'
      })

      expect(result.error).toBeNull()
      expect(mockFrom.update).toHaveBeenCalledWith({ username: 'newusername' })
      expect(mockFrom.eq).toHaveBeenCalledWith('id', 'user-123')
    })

    it('should return error when update fails', async () => {
      const mockFrom = {
        update: vi.fn().mockReturnThis(),
        eq: vi.fn().mockResolvedValue({ error: { message: 'Username taken' } })
      }

      mockSupabase.from.mockReturnValue(mockFrom)

      const result = await authService.updateUserProfile('user-123', {
        username: 'taken'
      })

      expect(result.error?.message).toBe('Username taken')
    })
  })

  describe('onAuthStateChange', () => {
    it('should subscribe to auth state changes', () => {
      const mockCallback = vi.fn()
      const mockUnsubscribe = vi.fn()

      mockSupabase.auth.onAuthStateChange.mockReturnValue({
        data: { subscription: { unsubscribe: mockUnsubscribe } }
      })

      const subscription = authService.onAuthStateChange(mockCallback)

      expect(mockSupabase.auth.onAuthStateChange).toHaveBeenCalled()
      expect(subscription).toBeDefined()
    })
  })
})
