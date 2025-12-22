import { describe, expect, it } from 'vitest'
import { createRasmWorkerAdapter } from '../rasm-worker-adapter'

describe('RasmWorkerAdapter', () => {
  describe('createRasmWorkerAdapter', () => {
    it('should create an adapter with type rasm', () => {
      const adapter = createRasmWorkerAdapter()

      expect(adapter.type).toBe('rasm')
    })

    it('should not be ready initially', () => {
      const adapter = createRasmWorkerAdapter()

      expect(adapter.isReady()).toBe(false)
    })

    it('should have required methods', () => {
      const adapter = createRasmWorkerAdapter()

      expect(typeof adapter.initialize).toBe('function')
      expect(typeof adapter.isReady).toBe('function')
      expect(typeof adapter.compile).toBe('function')
      expect(typeof adapter.dispose).toBe('function')
    })

    it('should reset ready state after dispose', () => {
      const adapter = createRasmWorkerAdapter()

      // Dispose without initialization should work
      adapter.dispose()

      expect(adapter.isReady()).toBe(false)
    })
  })
})
