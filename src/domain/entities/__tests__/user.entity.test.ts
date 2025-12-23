import { describe, expect, it } from 'vitest'
import {
  createUser,
  createUserProfile,
  type User,
  type UserProfile
} from '../user.entity'

describe('User Entity', () => {
  describe('createUser', () => {
    it('should create a user with required fields', () => {
      const user = createUser({
        id: 'user-123',
        email: 'test@example.com'
      })

      expect(user.id).toBe('user-123')
      expect(user.email).toBe('test@example.com')
      expect(user.profile).toBeUndefined()
    })

    it('should create a user with profile', () => {
      const user = createUser({
        id: 'user-123',
        email: 'test@example.com',
        profile: {
          id: 'profile-123',
          username: 'testuser'
        }
      })

      expect(user.profile).toBeDefined()
      expect(user.profile?.id).toBe('profile-123')
      expect(user.profile?.username).toBe('testuser')
    })

    it('should set default dates for profile', () => {
      const before = new Date()
      const user = createUser({
        id: 'user-123',
        email: 'test@example.com',
        profile: {
          id: 'profile-123',
          username: 'testuser'
        }
      })
      const after = new Date()

      expect(user.profile?.createdAt.getTime()).toBeGreaterThanOrEqual(
        before.getTime()
      )
      expect(user.profile?.createdAt.getTime()).toBeLessThanOrEqual(
        after.getTime()
      )
    })

    it('should use provided dates for profile', () => {
      const createdAt = new Date('2024-01-01')
      const updatedAt = new Date('2024-06-01')

      const user = createUser({
        id: 'user-123',
        email: 'test@example.com',
        profile: {
          id: 'profile-123',
          username: 'testuser',
          createdAt,
          updatedAt
        }
      })

      expect(user.profile?.createdAt).toEqual(createdAt)
      expect(user.profile?.updatedAt).toEqual(updatedAt)
    })

    it('should return a frozen object', () => {
      const user = createUser({
        id: 'user-123',
        email: 'test@example.com'
      })

      expect(Object.isFrozen(user)).toBe(true)
    })

    it('should return a frozen profile', () => {
      const user = createUser({
        id: 'user-123',
        email: 'test@example.com',
        profile: {
          id: 'profile-123',
          username: 'testuser'
        }
      })

      expect(Object.isFrozen(user.profile)).toBe(true)
    })
  })

  describe('createUserProfile', () => {
    it('should create a profile with required fields', () => {
      const profile = createUserProfile({
        id: 'profile-123',
        username: 'testuser'
      })

      expect(profile.id).toBe('profile-123')
      expect(profile.username).toBe('testuser')
    })

    it('should set default dates', () => {
      const before = new Date()
      const profile = createUserProfile({
        id: 'profile-123',
        username: 'testuser'
      })
      const after = new Date()

      expect(profile.createdAt.getTime()).toBeGreaterThanOrEqual(
        before.getTime()
      )
      expect(profile.updatedAt.getTime()).toBeLessThanOrEqual(after.getTime())
    })

    it('should use provided dates', () => {
      const createdAt = new Date('2024-01-01')
      const updatedAt = new Date('2024-06-01')

      const profile = createUserProfile({
        id: 'profile-123',
        username: 'testuser',
        createdAt,
        updatedAt
      })

      expect(profile.createdAt).toEqual(createdAt)
      expect(profile.updatedAt).toEqual(updatedAt)
    })

    it('should return a frozen object', () => {
      const profile = createUserProfile({
        id: 'profile-123',
        username: 'testuser'
      })

      expect(Object.isFrozen(profile)).toBe(true)
    })
  })

  describe('Type safety', () => {
    it('User type should be readonly', () => {
      const user: User = createUser({
        id: 'user-123',
        email: 'test@example.com'
      })

      // Object.freeze throws TypeError in strict mode when attempting to modify
      expect(() => {
        // @ts-expect-error - Testing runtime immutability
        user.id = 'changed'
      }).toThrow(TypeError)

      expect(user.id).toBe('user-123')
    })

    it('UserProfile type should be readonly', () => {
      const profile: UserProfile = createUserProfile({
        id: 'profile-123',
        username: 'testuser'
      })

      // Object.freeze throws TypeError in strict mode when attempting to modify
      expect(() => {
        // @ts-expect-error - Testing runtime immutability
        profile.username = 'changed'
      }).toThrow(TypeError)

      expect(profile.username).toBe('testuser')
    })
  })
})
