import { beforeEach, describe, expect, it, vi } from 'vitest'
import type { User, UserProfile } from '@/domain/entities/user.entity'
import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'
import { createGetCurrentUserUseCase } from '../get-current-user.use-case'
import { createGetUserProfileUseCase } from '../get-user-profile.use-case'
import { createSignInUseCase } from '../sign-in.use-case'
import { createSignInWithOAuthUseCase } from '../sign-in-with-oauth.use-case'
import { createSignOutUseCase } from '../sign-out.use-case'
import { createSignUpUseCase } from '../sign-up.use-case'
import { createUpdateUserProfileUseCase } from '../update-user-profile.use-case'

// Mock repository
function createMockAuthRepository(): IAuthRepository {
  return {
    signIn: vi.fn(),
    signUp: vi.fn(),
    signOut: vi.fn(),
    signInWithOAuth: vi.fn(),
    getCurrentUser: vi.fn(),
    onAuthStateChange: vi.fn(() => vi.fn()),
    getUserProfile: vi.fn(),
    updateUserProfile: vi.fn()
  }
}

const mockUser: User = {
  id: 'user-123',
  email: 'test@example.com'
}

const mockProfile: UserProfile = {
  id: 'user-123',
  username: 'testuser',
  createdAt: new Date(),
  updatedAt: new Date()
}

describe('Auth Use Cases', () => {
  let mockRepo: IAuthRepository

  beforeEach(() => {
    mockRepo = createMockAuthRepository()
  })

  describe('SignInUseCase', () => {
    it('should sign in successfully', async () => {
      vi.mocked(mockRepo.signIn).mockResolvedValue({
        user: mockUser,
        error: null
      })

      const useCase = createSignInUseCase(mockRepo)
      const result = await useCase.execute({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toEqual(mockUser)
      expect(result.error).toBeNull()
      expect(mockRepo.signIn).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123'
      })
    })

    it('should return error on failure', async () => {
      const error = new Error('Invalid credentials')
      vi.mocked(mockRepo.signIn).mockResolvedValue({
        user: null,
        error
      })

      const useCase = createSignInUseCase(mockRepo)
      const result = await useCase.execute({
        email: 'test@example.com',
        password: 'wrong'
      })

      expect(result.user).toBeNull()
      expect(result.error).toBe(error)
    })
  })

  describe('SignUpUseCase', () => {
    it('should sign up successfully', async () => {
      vi.mocked(mockRepo.signUp).mockResolvedValue({
        user: mockUser,
        error: null
      })

      const useCase = createSignUpUseCase(mockRepo)
      const result = await useCase.execute({
        email: 'test@example.com',
        password: 'password123',
        username: 'testuser'
      })

      expect(result.user).toEqual(mockUser)
      expect(result.error).toBeNull()
      expect(mockRepo.signUp).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
        username: 'testuser'
      })
    })

    it('should sign up without username', async () => {
      vi.mocked(mockRepo.signUp).mockResolvedValue({
        user: mockUser,
        error: null
      })

      const useCase = createSignUpUseCase(mockRepo)
      await useCase.execute({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(mockRepo.signUp).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
        username: undefined
      })
    })

    it('should return error on failure', async () => {
      const error = new Error('Email already exists')
      vi.mocked(mockRepo.signUp).mockResolvedValue({
        user: null,
        error
      })

      const useCase = createSignUpUseCase(mockRepo)
      const result = await useCase.execute({
        email: 'test@example.com',
        password: 'password123'
      })

      expect(result.user).toBeNull()
      expect(result.error).toBe(error)
    })
  })

  describe('SignOutUseCase', () => {
    it('should sign out successfully', async () => {
      vi.mocked(mockRepo.signOut).mockResolvedValue({ error: null })

      const useCase = createSignOutUseCase(mockRepo)
      const result = await useCase.execute()

      expect(result.error).toBeNull()
      expect(mockRepo.signOut).toHaveBeenCalled()
    })

    it('should return error on failure', async () => {
      const error = new Error('Sign out failed')
      vi.mocked(mockRepo.signOut).mockResolvedValue({ error })

      const useCase = createSignOutUseCase(mockRepo)
      const result = await useCase.execute()

      expect(result.error).toBe(error)
    })
  })

  describe('SignInWithOAuthUseCase', () => {
    it('should initiate OAuth sign in', async () => {
      vi.mocked(mockRepo.signInWithOAuth).mockResolvedValue({
        user: null,
        error: null
      })

      const useCase = createSignInWithOAuthUseCase(mockRepo)
      const result = await useCase.execute({ provider: 'github' })

      expect(result.error).toBeNull()
      expect(mockRepo.signInWithOAuth).toHaveBeenCalledWith('github')
    })

    it('should return error on OAuth failure', async () => {
      const error = new Error('OAuth failed')
      vi.mocked(mockRepo.signInWithOAuth).mockResolvedValue({
        user: null,
        error
      })

      const useCase = createSignInWithOAuthUseCase(mockRepo)
      const result = await useCase.execute({ provider: 'github' })

      expect(result.error).toBe(error)
    })
  })

  describe('GetCurrentUserUseCase', () => {
    it('should return current user', async () => {
      vi.mocked(mockRepo.getCurrentUser).mockResolvedValue(mockUser)

      const useCase = createGetCurrentUserUseCase(mockRepo)
      const result = await useCase.execute()

      expect(result.user).toEqual(mockUser)
    })

    it('should return null when not authenticated', async () => {
      vi.mocked(mockRepo.getCurrentUser).mockResolvedValue(null)

      const useCase = createGetCurrentUserUseCase(mockRepo)
      const result = await useCase.execute()

      expect(result.user).toBeNull()
    })
  })

  describe('GetUserProfileUseCase', () => {
    it('should return user profile', async () => {
      vi.mocked(mockRepo.getUserProfile).mockResolvedValue(mockProfile)

      const useCase = createGetUserProfileUseCase(mockRepo)
      const result = await useCase.execute({ userId: 'user-123' })

      expect(result.profile).toEqual(mockProfile)
      expect(mockRepo.getUserProfile).toHaveBeenCalledWith('user-123')
    })

    it('should return null when profile not found', async () => {
      vi.mocked(mockRepo.getUserProfile).mockResolvedValue(null)

      const useCase = createGetUserProfileUseCase(mockRepo)
      const result = await useCase.execute({ userId: 'user-123' })

      expect(result.profile).toBeNull()
    })
  })

  describe('UpdateUserProfileUseCase', () => {
    it('should update profile successfully', async () => {
      vi.mocked(mockRepo.updateUserProfile).mockResolvedValue({ error: null })

      const useCase = createUpdateUserProfileUseCase(mockRepo)
      const result = await useCase.execute({
        userId: 'user-123',
        username: 'newusername'
      })

      expect(result.error).toBeNull()
      expect(mockRepo.updateUserProfile).toHaveBeenCalledWith('user-123', {
        username: 'newusername'
      })
    })

    it('should normalize username to lowercase', async () => {
      vi.mocked(mockRepo.updateUserProfile).mockResolvedValue({ error: null })

      const useCase = createUpdateUserProfileUseCase(mockRepo)
      await useCase.execute({
        userId: 'user-123',
        username: 'NewUserName'
      })

      expect(mockRepo.updateUserProfile).toHaveBeenCalledWith('user-123', {
        username: 'newusername'
      })
    })

    it('should throw ValidationError for invalid username', async () => {
      const useCase = createUpdateUserProfileUseCase(mockRepo)

      await expect(
        useCase.execute({
          userId: 'user-123',
          username: 'ab' // too short
        })
      ).rejects.toThrow('at least 3 characters')
    })

    it('should throw ValidationError for username with invalid characters', async () => {
      const useCase = createUpdateUserProfileUseCase(mockRepo)

      await expect(
        useCase.execute({
          userId: 'user-123',
          username: 'user@name'
        })
      ).rejects.toThrow('lowercase letters, numbers, underscores and hyphens')
    })

    it('should allow undefined username', async () => {
      vi.mocked(mockRepo.updateUserProfile).mockResolvedValue({ error: null })

      const useCase = createUpdateUserProfileUseCase(mockRepo)
      const result = await useCase.execute({
        userId: 'user-123'
      })

      expect(result.error).toBeNull()
      expect(mockRepo.updateUserProfile).toHaveBeenCalledWith('user-123', {
        username: undefined
      })
    })

    it('should return error on failure', async () => {
      const error = new Error('Update failed')
      vi.mocked(mockRepo.updateUserProfile).mockResolvedValue({ error })

      const useCase = createUpdateUserProfileUseCase(mockRepo)
      const result = await useCase.execute({
        userId: 'user-123',
        username: 'newusername'
      })

      expect(result.error).toBe(error)
    })
  })
})
