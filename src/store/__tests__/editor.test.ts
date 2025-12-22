import { createStore } from 'jotai'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import {
  addConsoleMessageAtom,
  clearConsoleAtom,
  clearErrorLinesAtom,
  codeAtom,
  compilationErrorAtom,
  compilationOutputAtom,
  compilationStatusAtom,
  consoleMessagesAtom,
  errorLinesAtom,
  goToLineAtom,
  outputFormatAtom
} from '../editor'

// Mock the rasmErrorParser
vi.mock('@/infrastructure/assemblers/rasm-error-parser', () => ({
  rasmErrorParser: {
    extractLineNumber: (text: string): number | undefined => {
      const match = text.match(/\[\/?\w+\.asm:(\d+)\]/)
      if (match) {
        return Math.max(1, Number.parseInt(match[1], 10) - 2)
      }
      return undefined
    }
  }
}))

describe('Editor Store', () => {
  let store: ReturnType<typeof createStore>

  beforeEach(() => {
    store = createStore()
  })

  describe('codeAtom', () => {
    it('should have default Z80 assembly code', () => {
      const code = store.get(codeAtom)
      expect(code).toContain('; CPC Playground - Z80 Assembly')
      expect(code).toContain('org #4000')
      expect(code).toContain('Hello from CPC Playground!')
    })

    it('should allow setting code', () => {
      const newCode = '; Custom code\norg #1000\nret'
      store.set(codeAtom, newCode)
      expect(store.get(codeAtom)).toBe(newCode)
    })
  })

  describe('outputFormatAtom', () => {
    it('should default to sna format', () => {
      expect(store.get(outputFormatAtom)).toBe('sna')
    })

    it('should allow setting to dsk format', () => {
      store.set(outputFormatAtom, 'dsk')
      expect(store.get(outputFormatAtom)).toBe('dsk')
    })

    it('should allow switching back to sna format', () => {
      store.set(outputFormatAtom, 'dsk')
      store.set(outputFormatAtom, 'sna')
      expect(store.get(outputFormatAtom)).toBe('sna')
    })
  })

  describe('compilationStatusAtom', () => {
    it('should default to idle', () => {
      expect(store.get(compilationStatusAtom)).toBe('idle')
    })

    it('should allow setting to compiling', () => {
      store.set(compilationStatusAtom, 'compiling')
      expect(store.get(compilationStatusAtom)).toBe('compiling')
    })

    it('should allow setting to success', () => {
      store.set(compilationStatusAtom, 'success')
      expect(store.get(compilationStatusAtom)).toBe('success')
    })

    it('should allow setting to error', () => {
      store.set(compilationStatusAtom, 'error')
      expect(store.get(compilationStatusAtom)).toBe('error')
    })
  })

  describe('compilationErrorAtom', () => {
    it('should default to null', () => {
      expect(store.get(compilationErrorAtom)).toBeNull()
    })

    it('should allow setting error message', () => {
      store.set(compilationErrorAtom, 'Syntax error at line 5')
      expect(store.get(compilationErrorAtom)).toBe('Syntax error at line 5')
    })

    it('should allow clearing error', () => {
      store.set(compilationErrorAtom, 'Some error')
      store.set(compilationErrorAtom, null)
      expect(store.get(compilationErrorAtom)).toBeNull()
    })
  })

  describe('compilationOutputAtom', () => {
    it('should default to null', () => {
      expect(store.get(compilationOutputAtom)).toBeNull()
    })

    it('should allow setting binary output', () => {
      const binary = new Uint8Array([0x00, 0x01, 0x02])
      store.set(compilationOutputAtom, binary)
      expect(store.get(compilationOutputAtom)).toBe(binary)
    })
  })

  describe('goToLineAtom', () => {
    it('should default to null', () => {
      expect(store.get(goToLineAtom)).toBeNull()
    })

    it('should allow setting line number', () => {
      store.set(goToLineAtom, 42)
      expect(store.get(goToLineAtom)).toBe(42)
    })

    it('should allow clearing', () => {
      store.set(goToLineAtom, 10)
      store.set(goToLineAtom, null)
      expect(store.get(goToLineAtom)).toBeNull()
    })
  })

  describe('errorLinesAtom', () => {
    it('should default to empty array', () => {
      expect(store.get(errorLinesAtom)).toEqual([])
    })

    it('should allow setting error lines', () => {
      store.set(errorLinesAtom, [5, 10, 15])
      expect(store.get(errorLinesAtom)).toEqual([5, 10, 15])
    })
  })

  describe('consoleMessagesAtom', () => {
    it('should default to empty array', () => {
      expect(store.get(consoleMessagesAtom)).toEqual([])
    })
  })

  describe('addConsoleMessageAtom', () => {
    it('should add info message to console', () => {
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Test message' })
      const messages = store.get(consoleMessagesAtom)

      expect(messages).toHaveLength(1)
      expect(messages[0].type).toBe('info')
      expect(messages[0].text).toBe('Test message')
      expect(messages[0].timestamp).toBeInstanceOf(Date)
      expect(messages[0].id).toMatch(/^msg-\d+$/)
    })

    it('should add error message to console', () => {
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error occurred'
      })
      const messages = store.get(consoleMessagesAtom)

      expect(messages).toHaveLength(1)
      expect(messages[0].type).toBe('error')
    })

    it('should add success message to console', () => {
      store.set(addConsoleMessageAtom, {
        type: 'success',
        text: 'Compilation successful'
      })
      const messages = store.get(consoleMessagesAtom)

      expect(messages).toHaveLength(1)
      expect(messages[0].type).toBe('success')
    })

    it('should add warning message to console', () => {
      store.set(addConsoleMessageAtom, {
        type: 'warning',
        text: 'Warning: deprecated'
      })
      const messages = store.get(consoleMessagesAtom)

      expect(messages).toHaveLength(1)
      expect(messages[0].type).toBe('warning')
    })

    it('should append messages preserving order', () => {
      store.set(addConsoleMessageAtom, { type: 'info', text: 'First' })
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Second' })
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Third' })

      const messages = store.get(consoleMessagesAtom)
      expect(messages).toHaveLength(3)
      expect(messages[0].text).toBe('First')
      expect(messages[1].text).toBe('Second')
      expect(messages[2].text).toBe('Third')
    })

    it('should have unique IDs for each message', () => {
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Message 1' })
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Message 2' })

      const messages = store.get(consoleMessagesAtom)
      expect(messages[0].id).not.toBe(messages[1].id)
    })

    it('should extract line number from RASM error and add to errorLines', () => {
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error [/input.asm:12] Unknown instruction'
      })

      const messages = store.get(consoleMessagesAtom)
      expect(messages[0].line).toBe(10) // 12 - 2 offset

      const errorLines = store.get(errorLinesAtom)
      expect(errorLines).toContain(10)
    })

    it('should not add duplicate line numbers to errorLines', () => {
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error [/input.asm:7] First error'
      })
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error [/input.asm:7] Second error'
      })

      const errorLines = store.get(errorLinesAtom)
      expect(errorLines).toEqual([5]) // Line 5 appears only once
    })

    it('should add multiple different error lines', () => {
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error [/input.asm:5]'
      })
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error [/input.asm:10]'
      })
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error [/input.asm:15]'
      })

      const errorLines = store.get(errorLinesAtom)
      expect(errorLines).toEqual([3, 8, 13])
    })

    it('should not add errorLines for messages without line numbers', () => {
      store.set(addConsoleMessageAtom, {
        type: 'info',
        text: 'Compiling...'
      })

      const errorLines = store.get(errorLinesAtom)
      expect(errorLines).toEqual([])
    })

    it('should set line to undefined for messages without line numbers', () => {
      store.set(addConsoleMessageAtom, {
        type: 'info',
        text: 'Just a message'
      })

      const messages = store.get(consoleMessagesAtom)
      expect(messages[0].line).toBeUndefined()
    })
  })

  describe('clearConsoleAtom', () => {
    it('should clear all console messages', () => {
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Message 1' })
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Message 2' })
      expect(store.get(consoleMessagesAtom)).toHaveLength(2)

      store.set(clearConsoleAtom)
      expect(store.get(consoleMessagesAtom)).toEqual([])
    })

    it('should also clear errorLines', () => {
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error [/input.asm:5]'
      })
      expect(store.get(errorLinesAtom).length).toBeGreaterThan(0)

      store.set(clearConsoleAtom)
      expect(store.get(errorLinesAtom)).toEqual([])
    })
  })

  describe('clearErrorLinesAtom', () => {
    it('should clear only error lines, not console messages', () => {
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error [/input.asm:5]'
      })
      expect(store.get(consoleMessagesAtom)).toHaveLength(1)
      expect(store.get(errorLinesAtom).length).toBeGreaterThan(0)

      store.set(clearErrorLinesAtom)
      expect(store.get(errorLinesAtom)).toEqual([])
      expect(store.get(consoleMessagesAtom)).toHaveLength(1)
    })
  })
})
