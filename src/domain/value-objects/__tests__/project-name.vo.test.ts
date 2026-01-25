import { describe, expect, it } from 'vitest'
import { ValidationError } from '@/domain/errors/domain.error'
import { PROJECT_NAME_ERRORS } from '@/domain/errors/error-messages'
import {
  createProjectName,
  isProjectName,
  PROJECT_NAME_MAX_LENGTH,
  PROJECT_NAME_MIN_LENGTH
} from '../project-name.vo'

describe('ProjectName Value Object', () => {
  describe('createProjectName', () => {
    it('should create valid project name', () => {
      const name = createProjectName('Valid Project')

      expect(name.value).toBe('Valid Project')
      expect(typeof name._brand).toBe('symbol')
    })

    it('should trim whitespace', () => {
      const name = createProjectName('  Spaced Name  ')

      expect(name.value).toBe('Spaced Name')
    })

    it('should accept letters, numbers, spaces, hyphens and underscores', () => {
      const name = createProjectName('Project-123_Name Test')

      expect(name.value).toBe('Project-123_Name Test')
    })

    it('should reject name too short', () => {
      const shortName = 'ab'
      expect(() => createProjectName(shortName)).toThrow(ValidationError)
      expect(() => createProjectName(shortName)).toThrow(
        PROJECT_NAME_ERRORS.TOO_SHORT(PROJECT_NAME_MIN_LENGTH)
      )
    })

    it('should reject name too long', () => {
      const longName = 'a'.repeat(PROJECT_NAME_MAX_LENGTH + 1)

      expect(() => createProjectName(longName)).toThrow(ValidationError)
      expect(() => createProjectName(longName)).toThrow(
        PROJECT_NAME_ERRORS.TOO_LONG(PROJECT_NAME_MAX_LENGTH)
      )
    })

    it('should reject empty name', () => {
      expect(() => createProjectName('')).toThrow(ValidationError)
      expect(() => createProjectName('  ')).toThrow(ValidationError)
    })

    it('should reject names with invalid characters', () => {
      // < > ; : * ? | \ are not in the allowed pattern
      expect(() => createProjectName('Project<Name')).toThrow(ValidationError)
      expect(() => createProjectName('Project>Name')).toThrow(ValidationError)
      expect(() => createProjectName('Project;Name')).toThrow(ValidationError)
    })
  })

  describe('isProjectName', () => {
    it('should return true for valid ProjectName', () => {
      const name = createProjectName('Test')

      expect(isProjectName(name)).toBe(true)
    })

    it('should return false for invalid values', () => {
      expect(isProjectName('string')).toBe(false)
      expect(isProjectName(123)).toBe(false)
      expect(isProjectName(null)).toBe(false)
      expect(isProjectName(undefined)).toBe(false)
      expect(isProjectName({ value: 'test' })).toBe(false)
    })
  })

  describe('immutability', () => {
    it('should be immutable', () => {
      const name = createProjectName('Test')

      // TypeScript should prevent this at compile time
      // Runtime check to ensure readonly works
      expect(() => {
        ;(name as any).value = 'Changed'
      }).toThrow()
    })
  })
})
