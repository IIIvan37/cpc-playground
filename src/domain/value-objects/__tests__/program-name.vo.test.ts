import { describe, expect, it } from 'vitest'
import { ValidationError } from '@/domain/errors/domain.error'
import { PROGRAM_NAME_ERRORS } from '@/domain/errors/error-messages'
import {
  createProgramName,
  isProgramName,
  PROGRAM_NAME_MAX_LENGTH
} from '../program-name.vo'

describe('ProgramName Value Object', () => {
  describe('createProgramName', () => {
    it('should create a valid program name', () => {
      const name = createProgramName('My Program')

      expect(name.value).toBe('My Program')
    })

    it('should trim whitespace', () => {
      const name = createProgramName('  My Program  ')

      expect(name.value).toBe('My Program')
    })

    it('should allow single character names', () => {
      const name = createProgramName('A')

      expect(name.value).toBe('A')
    })

    it('should allow names with special characters', () => {
      const name = createProgramName('Test: Demo #1!')

      expect(name.value).toBe('Test: Demo #1!')
    })

    it('should throw ValidationError for empty name', () => {
      expect(() => createProgramName('')).toThrow(ValidationError)
      expect(() => createProgramName('')).toThrow(PROGRAM_NAME_ERRORS.EMPTY)
    })

    it('should throw ValidationError for whitespace-only name', () => {
      expect(() => createProgramName('   ')).toThrow(ValidationError)
      expect(() => createProgramName('   ')).toThrow(PROGRAM_NAME_ERRORS.EMPTY)
    })

    it('should throw ValidationError for name too long', () => {
      const longName = 'a'.repeat(PROGRAM_NAME_MAX_LENGTH + 1)

      expect(() => createProgramName(longName)).toThrow(ValidationError)
      expect(() => createProgramName(longName)).toThrow(
        PROGRAM_NAME_ERRORS.TOO_LONG(PROGRAM_NAME_MAX_LENGTH)
      )
    })

    it('should allow name at max length', () => {
      const maxName = 'a'.repeat(PROGRAM_NAME_MAX_LENGTH)
      const name = createProgramName(maxName)

      expect(name.value).toBe(maxName)
    })
  })

  describe('isProgramName', () => {
    it('should return true for valid ProgramName', () => {
      const name = createProgramName('Test')

      expect(isProgramName(name)).toBe(true)
    })

    it('should return false for null', () => {
      expect(isProgramName(null)).toBe(false)
    })

    it('should return false for undefined', () => {
      expect(isProgramName(undefined)).toBe(false)
    })

    it('should return false for plain string', () => {
      expect(isProgramName('Test')).toBe(false)
    })

    it('should return false for object without brand', () => {
      expect(isProgramName({ value: 'Test' })).toBe(false)
    })
  })
})
