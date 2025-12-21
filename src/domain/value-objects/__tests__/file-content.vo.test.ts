import { describe, expect, it } from 'vitest'
import { ValidationError } from '@/domain/errors/domain.error'
import { FILE_CONTENT_ERRORS } from '@/domain/errors/error-messages'
import {
  createFileContent,
  emptyFileContent,
  FILE_CONTENT_MAX_SIZE,
  getByteSize,
  isEmpty,
  isFileContent
} from '../file-content.vo'

describe('FileContent Value Object', () => {
  describe('createFileContent', () => {
    it('should create valid file content', () => {
      const content = createFileContent('LD A, 10')

      expect(content.value).toBe('LD A, 10')
      expect(content._brand).toBe('FileContent')
    })

    it('should accept empty content', () => {
      const content = createFileContent('')

      expect(content.value).toBe('')
    })

    it('should accept multiline content', () => {
      const code = `
        ORG &4000
        LD A, 10
        RET
      `
      const content = createFileContent(code)

      expect(content.value).toBe(code)
    })

    it('should reject content larger than 1MB', () => {
      const largeContent = 'a'.repeat(FILE_CONTENT_MAX_SIZE + 1)
      const expectedByteSize = new Blob([largeContent]).size

      expect(() => createFileContent(largeContent)).toThrow(ValidationError)
      expect(() => createFileContent(largeContent)).toThrow(
        FILE_CONTENT_ERRORS.TOO_LARGE(expectedByteSize, FILE_CONTENT_MAX_SIZE)
      )
    })

    it('should accept content close to limit', () => {
      // Just under 1MB
      const largeContent = 'a'.repeat(FILE_CONTENT_MAX_SIZE - 100)
      const content = createFileContent(largeContent)

      expect(content.value).toBe(largeContent)
    })
  })

  describe('emptyFileContent', () => {
    it('should create empty content', () => {
      const content = emptyFileContent()

      expect(content.value).toBe('')
      expect(isFileContent(content)).toBe(true)
    })
  })

  describe('isEmpty', () => {
    it('should return true for empty content', () => {
      const content = createFileContent('')

      expect(isEmpty(content)).toBe(true)
    })

    it('should return true for whitespace only', () => {
      const content = createFileContent('   \n\t  ')

      expect(isEmpty(content)).toBe(true)
    })

    it('should return false for non-empty content', () => {
      const content = createFileContent('LD A, 10')

      expect(isEmpty(content)).toBe(false)
    })
  })

  describe('getByteSize', () => {
    it('should return correct byte size for ASCII', () => {
      const content = createFileContent('hello')

      expect(getByteSize(content)).toBe(5)
    })

    it('should return correct byte size for UTF-8', () => {
      const content = createFileContent('€') // 3 bytes in UTF-8

      expect(getByteSize(content)).toBe(3)
    })

    it('should return zero for empty content', () => {
      const content = emptyFileContent()

      expect(getByteSize(content)).toBe(0)
    })
  })

  describe('isFileContent', () => {
    it('should return true for valid FileContent', () => {
      const content = createFileContent('test')

      expect(isFileContent(content)).toBe(true)
    })

    it('should return false for invalid values', () => {
      expect(isFileContent('string')).toBe(false)
      expect(isFileContent(123)).toBe(false)
      expect(isFileContent(null)).toBe(false)
      expect(isFileContent({ value: 'test' })).toBe(false)
    })
  })
})
