import { describe, expect, it } from 'vitest'
import { createRasmErrorParser, rasmErrorParser } from '../rasm-error-parser'

describe('RASM Error Parser', () => {
  describe('extractLineNumber', () => {
    it('should extract line number from standard RASM error format', () => {
      const line = rasmErrorParser.extractLineNumber(
        '[/input.asm:23] Error: Unknown instruction'
      )

      // Line 23 - 2 (offset) = 21
      expect(line).toBe(21)
    })

    it('should extract line number without leading slash', () => {
      const line = rasmErrorParser.extractLineNumber(
        '[input.asm:15] Syntax error'
      )

      expect(line).toBe(13)
    })

    it('should return undefined for text without line number', () => {
      const line = rasmErrorParser.extractLineNumber(
        'Some generic error message'
      )

      expect(line).toBeUndefined()
    })

    it('should return minimum line 1 when offset would go negative', () => {
      const line = rasmErrorParser.extractLineNumber(
        '[/input.asm:1] Error on first line'
      )

      expect(line).toBe(1)
    })

    it('should handle different file names', () => {
      const line = rasmErrorParser.extractLineNumber('[/myfile.asm:50] Error')

      expect(line).toBe(48)
    })
  })

  describe('extractRawLineNumber', () => {
    it('should extract raw line number without offset adjustment', () => {
      const rawLine = rasmErrorParser.extractRawLineNumber(
        '[/input.asm:23] Error'
      )

      expect(rawLine).toBe(23)
    })

    it('should return undefined for text without line number', () => {
      const rawLine = rasmErrorParser.extractRawLineNumber(
        'No line number here'
      )

      expect(rawLine).toBeUndefined()
    })
  })

  describe('parseError', () => {
    it('should return structured error info', () => {
      const error = rasmErrorParser.parseError(
        '[/input.asm:10] Unknown label "foo"'
      )

      expect(error.text).toBe('[/input.asm:10] Unknown label "foo"')
      expect(error.rawLine).toBe(10)
      expect(error.line).toBe(8)
    })

    it('should handle text without error pattern', () => {
      const error = rasmErrorParser.parseError('Just some info message')

      expect(error.text).toBe('Just some info message')
      expect(error.rawLine).toBeUndefined()
      expect(error.line).toBeUndefined()
    })
  })

  describe('hasError', () => {
    it('should return true for text with error pattern', () => {
      expect(rasmErrorParser.hasError('[/input.asm:5] Error')).toBe(true)
    })

    it('should return false for text without error pattern', () => {
      expect(rasmErrorParser.hasError('Compilation successful')).toBe(false)
    })

    it('should return true for error without slash', () => {
      expect(rasmErrorParser.hasError('[input.asm:5] Error')).toBe(true)
    })
  })

  describe('custom configuration', () => {
    it('should use custom line offset', () => {
      const customParser = createRasmErrorParser({ lineOffset: 5 })
      const line = customParser.extractLineNumber('[/input.asm:10] Error')

      // Line 10 - 5 (custom offset) = 5
      expect(line).toBe(5)
    })

    it('should default to offset of 2', () => {
      const defaultParser = createRasmErrorParser()
      const line = defaultParser.extractLineNumber('[/input.asm:10] Error')

      expect(line).toBe(8)
    })

    it('should handle zero offset', () => {
      const zeroOffsetParser = createRasmErrorParser({ lineOffset: 0 })
      const line = zeroOffsetParser.extractLineNumber('[/input.asm:10] Error')

      expect(line).toBe(10)
    })
  })

  describe('edge cases', () => {
    it('should handle multiple error patterns in same text', () => {
      // Should match first occurrence
      const line = rasmErrorParser.extractLineNumber(
        '[/input.asm:5] Error, see also [/input.asm:10]'
      )

      expect(line).toBe(3)
    })

    it('should handle very large line numbers', () => {
      const line = rasmErrorParser.extractLineNumber('[/input.asm:9999] Error')

      expect(line).toBe(9997)
    })

    it('should not match similar but invalid patterns', () => {
      expect(rasmErrorParser.hasError('[input.txt:10] Error')).toBe(false)
      expect(rasmErrorParser.hasError('input.asm:10 Error')).toBe(false)
      expect(rasmErrorParser.hasError('[/input.asm] Error')).toBe(false)
    })
  })
})
