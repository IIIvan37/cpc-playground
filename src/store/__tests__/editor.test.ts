import { createStore } from 'jotai'
import { beforeEach, describe, expect, it } from 'vitest'
import {
  clearConsoleAtom,
  clearErrorLinesAtom,
  codeAtom,
  compilationErrorAtom,
  compilationOutputAtom,
  compilationStatusAtom,
  consoleMessagesAtom,
  errorLinesAtom,
  goToLineAtom,
  outputFormatAtom,
  selectedAssemblerAtom
} from '../editor'

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
      expect(store.get(outputFormatAtom)).toBe('dsk')
    })
  })

  describe('selectedAssemblerAtom', () => {
    it('should default to rasm', () => {
      expect(store.get(selectedAssemblerAtom)).toBe('rasm')
    })

    it('should allow changing assembler', () => {
      store.set(selectedAssemblerAtom, 'pasmo')
      expect(store.get(selectedAssemblerAtom)).toBe('pasmo')
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

    it('should allow setting messages directly', () => {
      const message = {
        id: 'msg-1',
        type: 'info' as const,
        text: 'Test',
        timestamp: new Date()
      }
      store.set(consoleMessagesAtom, [message])
      expect(store.get(consoleMessagesAtom)).toEqual([message])
    })
  })

  describe('clearConsoleAtom', () => {
    it('should clear all console messages', () => {
      store.set(consoleMessagesAtom, [
        { id: 'msg-1', type: 'info', text: 'Message 1', timestamp: new Date() },
        { id: 'msg-2', type: 'info', text: 'Message 2', timestamp: new Date() }
      ])
      expect(store.get(consoleMessagesAtom)).toHaveLength(2)

      store.set(clearConsoleAtom)
      expect(store.get(consoleMessagesAtom)).toEqual([])
    })

    it('should also clear errorLines', () => {
      store.set(errorLinesAtom, [5, 10])
      expect(store.get(errorLinesAtom).length).toBeGreaterThan(0)

      store.set(clearConsoleAtom)
      expect(store.get(errorLinesAtom)).toEqual([])
    })
  })

  describe('clearErrorLinesAtom', () => {
    it('should clear only error lines, not console messages', () => {
      store.set(consoleMessagesAtom, [
        { id: 'msg-1', type: 'error', text: 'Error', timestamp: new Date() }
      ])
      store.set(errorLinesAtom, [5])
      expect(store.get(consoleMessagesAtom)).toHaveLength(1)
      expect(store.get(errorLinesAtom).length).toBeGreaterThan(0)

      store.set(clearErrorLinesAtom)
      expect(store.get(errorLinesAtom)).toEqual([])
      expect(store.get(consoleMessagesAtom)).toHaveLength(1)
    })
  })
})
