import { describe, expect, it } from 'vitest'
import { ValidationError } from '../../errors/domain.error'
import { createUsername, isUsername, USERNAME_ERRORS } from '../username.vo'

describe('Username Value Object', () => {
  describe('createUsername', () => {
    it('should create a valid username', () => {
      const username = createUsername('john_doe')
      expect(username.value).toBe('john_doe')
    })

    it('should normalize to lowercase', () => {
      const username = createUsername('John_Doe')
      expect(username.value).toBe('john_doe')
    })

    it('should trim whitespace', () => {
      const username = createUsername('  john_doe  ')
      expect(username.value).toBe('john_doe')
    })

    it('should accept numbers', () => {
      const username = createUsername('john123')
      expect(username.value).toBe('john123')
    })

    it('should accept hyphens', () => {
      const username = createUsername('john-doe')
      expect(username.value).toBe('john-doe')
    })

    it('should accept underscores', () => {
      const username = createUsername('john_doe')
      expect(username.value).toBe('john_doe')
    })

    it('should throw for empty username', () => {
      expect(() => createUsername('')).toThrow(ValidationError)
      expect(() => createUsername('')).toThrow(USERNAME_ERRORS.EMPTY)
    })

    it('should throw for whitespace-only username', () => {
      expect(() => createUsername('   ')).toThrow(ValidationError)
      expect(() => createUsername('   ')).toThrow(USERNAME_ERRORS.EMPTY)
    })

    it('should throw for username too short', () => {
      expect(() => createUsername('ab')).toThrow(ValidationError)
      expect(() => createUsername('ab')).toThrow(USERNAME_ERRORS.TOO_SHORT)
    })

    it('should accept username at minimum length', () => {
      const username = createUsername('abc')
      expect(username.value).toBe('abc')
    })

    it('should throw for username too long', () => {
      const longUsername = 'a'.repeat(31)
      expect(() => createUsername(longUsername)).toThrow(ValidationError)
      expect(() => createUsername(longUsername)).toThrow(
        USERNAME_ERRORS.TOO_LONG
      )
    })

    it('should accept username at maximum length', () => {
      const maxUsername = 'a'.repeat(30)
      const username = createUsername(maxUsername)
      expect(username.value).toBe(maxUsername)
    })

    it('should throw for username with spaces', () => {
      expect(() => createUsername('john doe')).toThrow(ValidationError)
      expect(() => createUsername('john doe')).toThrow(
        USERNAME_ERRORS.INVALID_CHARS
      )
    })

    it('should throw for username with special characters', () => {
      expect(() => createUsername('john@doe')).toThrow(ValidationError)
      expect(() => createUsername('john.doe')).toThrow(ValidationError)
      expect(() => createUsername('john!doe')).toThrow(ValidationError)
    })

    it('should create immutable username', () => {
      const username = createUsername('john_doe')
      expect(Object.isFrozen(username)).toBe(true)
    })
  })

  describe('isUsername', () => {
    it('should return true for valid Username', () => {
      const username = createUsername('john_doe')
      expect(isUsername(username)).toBe(true)
    })

    it('should return false for plain objects', () => {
      expect(isUsername({ value: 'john_doe' })).toBe(false)
    })

    it('should return false for strings', () => {
      expect(isUsername('john_doe')).toBe(false)
    })

    it('should return false for null', () => {
      expect(isUsername(null)).toBe(false)
    })

    it('should return false for undefined', () => {
      expect(isUsername(undefined)).toBe(false)
    })
  })
})
