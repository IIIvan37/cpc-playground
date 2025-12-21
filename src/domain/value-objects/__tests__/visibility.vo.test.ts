import { describe, expect, it } from 'vitest'
import { ValidationError } from '@/domain/errors/domain.error'
import {
  canBeShared,
  createVisibility,
  isPrivate,
  isPublic,
  isVisibility,
  VISIBILITY_VALUES,
  Visibility
} from '../visibility.vo'

describe('Visibility Value Object', () => {
  describe('createVisibility', () => {
    it('should create private visibility', () => {
      const visibility = createVisibility('private')

      expect(visibility.value).toBe('private')
      expect(typeof visibility._brand).toBe('symbol')
    })

    it('should create unlisted visibility', () => {
      const visibility = createVisibility('unlisted')

      expect(visibility.value).toBe('unlisted')
    })

    it('should create public visibility', () => {
      const visibility = createVisibility('public')

      expect(visibility.value).toBe('public')
    })

    it('should reject invalid visibility', () => {
      expect(() => createVisibility('invalid')).toThrow(ValidationError)
      expect(() => createVisibility('invalid')).toThrow('Invalid visibility')
    })

    it('should list valid values in error message', () => {
      try {
        createVisibility('wrong')
      } catch (error) {
        expect((error as Error).message).toContain('private')
        expect((error as Error).message).toContain('unlisted')
        expect((error as Error).message).toContain('public')
      }
    })
  })

  describe('predefined instances', () => {
    it('should have PRIVATE constant', () => {
      expect(Visibility.PRIVATE.value).toBe('private')
    })

    it('should have UNLISTED constant', () => {
      expect(Visibility.UNLISTED.value).toBe('unlisted')
    })

    it('should have PUBLIC constant', () => {
      expect(Visibility.PUBLIC.value).toBe('public')
    })
  })

  describe('canBeShared', () => {
    it('should allow sharing for public visibility', () => {
      expect(canBeShared(Visibility.PUBLIC)).toBe(true)
    })

    it('should allow sharing for unlisted visibility', () => {
      expect(canBeShared(Visibility.UNLISTED)).toBe(true)
    })

    it('should not allow sharing for private visibility', () => {
      expect(canBeShared(Visibility.PRIVATE)).toBe(false)
    })
  })

  describe('isPublic', () => {
    it('should return true for public visibility', () => {
      expect(isPublic(Visibility.PUBLIC)).toBe(true)
    })

    it('should return false for non-public visibility', () => {
      expect(isPublic(Visibility.PRIVATE)).toBe(false)
      expect(isPublic(Visibility.UNLISTED)).toBe(false)
    })
  })

  describe('isPrivate', () => {
    it('should return true for private visibility', () => {
      expect(isPrivate(Visibility.PRIVATE)).toBe(true)
    })

    it('should return false for non-private visibility', () => {
      expect(isPrivate(Visibility.PUBLIC)).toBe(false)
      expect(isPrivate(Visibility.UNLISTED)).toBe(false)
    })
  })

  describe('isVisibility', () => {
    it('should return true for valid Visibility', () => {
      const visibility = createVisibility('public')

      expect(isVisibility(visibility)).toBe(true)
    })

    it('should return false for invalid values', () => {
      expect(isVisibility('public')).toBe(false)
      expect(isVisibility(123)).toBe(false)
      expect(isVisibility(null)).toBe(false)
    })
  })

  describe('VISIBILITY_VALUES constant', () => {
    it('should contain all valid values', () => {
      expect(VISIBILITY_VALUES).toEqual(['private', 'unlisted', 'public'])
    })

    it('should be readonly', () => {
      expect(() => {
        ;(VISIBILITY_VALUES as any).push('invalid')
      }).toThrow()
    })
  })
})
