import { describe, expect, it } from 'vitest'
import { ValidationError } from '@/domain/errors/domain.error'
import { FILE_NAME_ERRORS } from '@/domain/errors/error-messages'
import {
  createFileName,
  FILE_NAME_MAX_LENGTH,
  getBaseName,
  hasExtension,
  isAssemblyFile,
  isFileName
} from '../file-name.vo'

describe('FileName Value Object', () => {
  describe('createFileName', () => {
    it('should create valid file name', () => {
      const name = createFileName('main.asm')

      expect(name.value).toBe('main.asm')
      expect(name.extension).toBe('asm')
      expect(typeof name._brand).toBe('symbol')
    })

    it('should extract extension correctly', () => {
      expect(createFileName('file.txt').extension).toBe('txt')
      expect(createFileName('archive.tar.gz').extension).toBe('gz')
      expect(createFileName('README').extension).toBeNull()
      expect(createFileName('.gitignore').extension).toBeNull()
    })

    it('should normalize extension to lowercase', () => {
      const name = createFileName('File.ASM')

      expect(name.extension).toBe('asm')
    })

    it('should trim whitespace', () => {
      const name = createFileName('  file.asm  ')

      expect(name.value).toBe('file.asm')
    })

    it('should reject empty name', () => {
      expect(() => createFileName('')).toThrow(ValidationError)
      expect(() => createFileName('  ')).toThrow(FILE_NAME_ERRORS.EMPTY)
    })

    it('should reject name too long', () => {
      const longName = 'a'.repeat(FILE_NAME_MAX_LENGTH + 1)

      expect(() => createFileName(longName)).toThrow(ValidationError)
      expect(() => createFileName(longName)).toThrow(
        FILE_NAME_ERRORS.TOO_LONG(FILE_NAME_MAX_LENGTH)
      )
    })

    it('should reject names with invalid characters', () => {
      expect(() => createFileName('file<>.txt')).toThrow(ValidationError)
      expect(() => createFileName('file|name.txt')).toThrow(ValidationError)
      expect(() => createFileName('file?.txt')).toThrow(ValidationError)
      expect(() => createFileName('file*.txt')).toThrow(ValidationError)
    })

    it('should accept valid special characters', () => {
      expect(() => createFileName('file-name_123.txt')).not.toThrow()
      expect(() => createFileName('My File (1).txt')).not.toThrow()
    })
  })

  describe('hasExtension', () => {
    it('should return true for matching extension', () => {
      const name = createFileName('file.asm')

      expect(hasExtension(name, 'asm')).toBe(true)
    })

    it('should be case-insensitive', () => {
      const name = createFileName('file.ASM')

      expect(hasExtension(name, 'asm')).toBe(true)
      expect(hasExtension(name, 'ASM')).toBe(true)
    })

    it('should return false for non-matching extension', () => {
      const name = createFileName('file.txt')

      expect(hasExtension(name, 'asm')).toBe(false)
    })

    it('should return false for files without extension', () => {
      const name = createFileName('README')

      expect(hasExtension(name, 'txt')).toBe(false)
    })
  })

  describe('isAssemblyFile', () => {
    it('should return true for .asm files', () => {
      const name = createFileName('main.asm')

      expect(isAssemblyFile(name)).toBe(true)
    })

    it('should return true for .s files', () => {
      const name = createFileName('main.s')

      expect(isAssemblyFile(name)).toBe(true)
    })

    it('should be case-insensitive', () => {
      expect(isAssemblyFile(createFileName('file.ASM'))).toBe(true)
      expect(isAssemblyFile(createFileName('file.S'))).toBe(true)
    })

    it('should return false for other files', () => {
      expect(isAssemblyFile(createFileName('file.txt'))).toBe(false)
      expect(isAssemblyFile(createFileName('README'))).toBe(false)
    })
  })

  describe('getBaseName', () => {
    it('should return name without extension', () => {
      const name = createFileName('file.asm')

      expect(getBaseName(name)).toBe('file')
    })

    it('should handle multiple dots', () => {
      const name = createFileName('archive.tar.gz')

      expect(getBaseName(name)).toBe('archive.tar')
    })

    it('should return full name if no extension', () => {
      const name = createFileName('README')

      expect(getBaseName(name)).toBe('README')
    })
  })

  describe('isFileName', () => {
    it('should return true for valid FileName', () => {
      const name = createFileName('test.txt')

      expect(isFileName(name)).toBe(true)
    })

    it('should return false for invalid values', () => {
      expect(isFileName('string')).toBe(false)
      expect(isFileName(123)).toBe(false)
      expect(isFileName(null)).toBe(false)
    })
  })
})
