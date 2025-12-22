import { beforeEach, describe, expect, it, vi } from 'vitest'
import type { IAssemblerAdapter } from '@/domain/services/assembler-adapter.interface'
import {
  disposeAllAdapters,
  getAssemblerAdapter,
  getAvailableAssemblerTypes,
  registerAssemblerAdapter
} from '../adapter-registry'

// Mock the rasm-worker-adapter module
vi.mock('../rasm-worker-adapter', () => ({
  createRasmWorkerAdapter: vi.fn(() => ({
    type: 'rasm',
    initialize: vi.fn().mockResolvedValue(undefined),
    isReady: vi.fn().mockReturnValue(false),
    compile: vi.fn().mockResolvedValue({
      success: true,
      binary: new Uint8Array([1, 2, 3]),
      stdout: [],
      stderr: []
    }),
    dispose: vi.fn()
  }))
}))

describe('AdapterRegistry', () => {
  beforeEach(() => {
    // Clean up adapters between tests
    disposeAllAdapters()
    vi.clearAllMocks()
  })

  describe('getAssemblerAdapter', () => {
    it('should return RASM adapter by default', () => {
      const adapter = getAssemblerAdapter('rasm')

      expect(adapter).toBeDefined()
      expect(adapter.type).toBe('rasm')
    })

    it('should return the same instance for multiple calls', () => {
      const adapter1 = getAssemblerAdapter('rasm')
      const adapter2 = getAssemblerAdapter('rasm')

      expect(adapter1).toBe(adapter2)
    })

    it('should throw for unknown assembler type', () => {
      expect(() => getAssemblerAdapter('unknown' as any)).toThrow(
        'No adapter registered for assembler type: unknown'
      )
    })
  })

  describe('registerAssemblerAdapter', () => {
    it('should register a new adapter factory', () => {
      const mockAdapter: IAssemblerAdapter = {
        type: 'pasmo',
        initialize: vi.fn().mockResolvedValue(undefined),
        isReady: vi.fn().mockReturnValue(true),
        compile: vi.fn(),
        dispose: vi.fn()
      }

      registerAssemblerAdapter('pasmo', () => mockAdapter)

      const adapter = getAssemblerAdapter('pasmo')
      expect(adapter).toBe(mockAdapter)
    })

    it('should dispose existing adapter when re-registering', () => {
      const disposeMock = vi.fn()
      const oldAdapter: IAssemblerAdapter = {
        type: 'pasmo',
        initialize: vi.fn(),
        isReady: vi.fn(),
        compile: vi.fn(),
        dispose: disposeMock
      }

      const newAdapter: IAssemblerAdapter = {
        type: 'pasmo',
        initialize: vi.fn(),
        isReady: vi.fn(),
        compile: vi.fn(),
        dispose: vi.fn()
      }

      // Register and get old adapter
      registerAssemblerAdapter('pasmo', () => oldAdapter)
      getAssemblerAdapter('pasmo')

      // Re-register with new adapter
      registerAssemblerAdapter('pasmo', () => newAdapter)

      expect(disposeMock).toHaveBeenCalled()
    })
  })

  describe('getAvailableAssemblerTypes', () => {
    it('should return available assembler types', () => {
      const types = getAvailableAssemblerTypes()

      expect(types).toContain('rasm')
    })

    it('should include registered adapters', () => {
      registerAssemblerAdapter('pasmo', () => ({
        type: 'pasmo',
        initialize: vi.fn(),
        isReady: vi.fn(),
        compile: vi.fn(),
        dispose: vi.fn()
      }))

      const types = getAvailableAssemblerTypes()

      expect(types).toContain('rasm')
      expect(types).toContain('pasmo')
    })
  })

  describe('disposeAllAdapters', () => {
    it('should dispose all cached adapters', () => {
      const adapter = getAssemblerAdapter('rasm')
      const disposeSpy = vi.spyOn(adapter, 'dispose')

      disposeAllAdapters()

      expect(disposeSpy).toHaveBeenCalled()
    })

    it('should clear the cache', () => {
      const adapter1 = getAssemblerAdapter('rasm')
      disposeAllAdapters()
      const adapter2 = getAssemblerAdapter('rasm')

      expect(adapter1).not.toBe(adapter2)
    })
  })
})
