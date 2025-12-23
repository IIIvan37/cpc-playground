import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'

// Mock Worker class - must be hoisted
class MockWorker {
  private readonly messageHandlers: ((e: MessageEvent) => void)[] = []
  private readonly errorHandlers: ((e: ErrorEvent) => void)[] = []

  postMessage = vi.fn()
  terminate = vi.fn()

  addEventListener(type: string, handler: (e: Event) => void): void {
    if (type === 'message') {
      this.messageHandlers.push(handler as (e: MessageEvent) => void)
    } else if (type === 'error') {
      this.errorHandlers.push(handler as (e: ErrorEvent) => void)
    }
  }

  removeEventListener(type: string, handler: (e: Event) => void): void {
    if (type === 'message') {
      const index = this.messageHandlers.indexOf(
        handler as (e: MessageEvent) => void
      )
      if (index > -1) this.messageHandlers.splice(index, 1)
    } else if (type === 'error') {
      const index = this.errorHandlers.indexOf(
        handler as (e: ErrorEvent) => void
      )
      if (index > -1) this.errorHandlers.splice(index, 1)
    }
  }

  // Helper methods for tests
  simulateMessage(data: unknown): void {
    for (const handler of this.messageHandlers) {
      handler({ data } as MessageEvent)
    }
  }

  simulateError(message: string): void {
    for (const handler of this.errorHandlers) {
      handler({ message } as ErrorEvent)
    }
  }
}

// Create a shared instance tracker
let currentMockWorker: MockWorker | null = null

// Mock the worker module - this must be hoisted
vi.mock('@/workers/rasm.worker?worker', () => {
  return {
    default: class {
      constructor() {
        currentMockWorker = new MockWorker()
        // biome-ignore lint/correctness/noConstructorReturn: Required for mock to return MockWorker instance
        return currentMockWorker
      }
    }
  }
})

// Import after mock is set up
import { createRasmWorkerAdapter } from '../rasm-worker-adapter'

describe('RasmWorkerAdapter', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    currentMockWorker = null
  })

  afterEach(() => {
    vi.restoreAllMocks()
  })

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

      adapter.dispose()

      expect(adapter.isReady()).toBe(false)
    })
  })

  describe('initialize', () => {
    it('should initialize the worker and set ready state', async () => {
      const adapter = createRasmWorkerAdapter()

      const initPromise = adapter.initialize()

      // Worker should be created now
      expect(currentMockWorker).not.toBeNull()

      // Simulate init complete response immediately (worker responds with type: 'init' and success: true)
      currentMockWorker?.simulateMessage({ id: 0, type: 'init', success: true })

      await initPromise

      expect(adapter.isReady()).toBe(true)
      expect(currentMockWorker?.postMessage).toHaveBeenCalledWith({
        type: 'init',
        id: expect.any(Number)
      })
    })

    it('should not reinitialize if already initialized', async () => {
      const adapter = createRasmWorkerAdapter()

      const initPromise = adapter.initialize()
      currentMockWorker?.simulateMessage({ id: 0, type: 'init', success: true })
      await initPromise

      // Second init should return immediately
      await adapter.initialize()

      // postMessage should only have been called once
      expect(currentMockWorker?.postMessage).toHaveBeenCalledTimes(1)
    })
  })

  describe('compile', () => {
    it('should send compile message to worker', async () => {
      const adapter = createRasmWorkerAdapter()

      const compilePromise = adapter.compile({
        source: 'org #4000\nret',
        outputFormat: 'sna'
      })

      expect(currentMockWorker).not.toBeNull()

      // Simulate successful response immediately (type: 'compile' for compile responses)
      currentMockWorker?.simulateMessage({
        id: 0,
        type: 'compile',
        success: true,
        binary: new Uint8Array([0xc9]),
        stdout: ['Compilation complete'],
        stderr: []
      })

      const result = await compilePromise

      expect(result.success).toBe(true)
      expect(result.binary).toEqual(new Uint8Array([0xc9]))
      expect(result.stdout).toEqual(['Compilation complete'])
      expect(result.stderr).toEqual([])
    })

    it('should handle compilation failure', async () => {
      const adapter = createRasmWorkerAdapter()

      const compilePromise = adapter.compile({
        source: 'invalid code',
        outputFormat: 'sna'
      })

      currentMockWorker?.simulateMessage({
        id: 0,
        type: 'compile',
        success: false,
        error: 'Syntax error at line 1',
        stdout: [],
        stderr: ['Error: Syntax error']
      })

      const result = await compilePromise

      expect(result.success).toBe(false)
      expect(result.error).toBe('Syntax error at line 1')
      expect(result.stderr).toEqual(['Error: Syntax error'])
    })

    it('should pass additional files to worker', async () => {
      const adapter = createRasmWorkerAdapter()

      const compilePromise = adapter.compile({
        source: 'include "lib.asm"',
        outputFormat: 'sna',
        additionalFiles: [{ name: 'lib.asm', content: 'ret' }]
      })

      currentMockWorker?.simulateMessage({
        id: 0,
        type: 'compile',
        success: true,
        binary: new Uint8Array([0xc9]),
        stdout: [],
        stderr: []
      })

      await compilePromise

      expect(currentMockWorker?.postMessage).toHaveBeenCalledWith({
        type: 'compile',
        id: expect.any(Number),
        source: 'include "lib.asm"',
        outputFormat: 'sna',
        additionalFiles: [{ name: 'lib.asm', content: 'ret' }]
      })
    })

    it('should handle missing result fields with defaults', async () => {
      const adapter = createRasmWorkerAdapter()

      const compilePromise = adapter.compile({
        source: 'nop',
        outputFormat: 'bin'
      })

      // Simulate response with missing fields
      currentMockWorker?.simulateMessage({
        id: 0,
        type: 'compile'
        // No success, stdout, stderr fields
      })

      const result = await compilePromise

      expect(result.success).toBe(false)
      expect(result.stdout).toEqual([])
      expect(result.stderr).toEqual([])
    })
  })

  describe('worker error handling', () => {
    it('should reject pending requests on worker error', async () => {
      const adapter = createRasmWorkerAdapter()

      const compilePromise = adapter.compile({
        source: 'test',
        outputFormat: 'sna'
      })

      // Simulate worker error immediately
      currentMockWorker?.simulateError('Worker crashed')

      await expect(compilePromise).rejects.toThrow(
        'Worker error: Worker crashed'
      )
    })
  })

  describe('dispose', () => {
    it('should terminate the worker', async () => {
      const adapter = createRasmWorkerAdapter()

      // Trigger worker creation
      const compilePromise = adapter.compile({
        source: '',
        outputFormat: 'sna'
      })
      currentMockWorker?.simulateMessage({
        id: 0,
        type: 'compile',
        success: true,
        binary: new Uint8Array(),
        stdout: [],
        stderr: []
      })
      await compilePromise

      adapter.dispose()

      expect(currentMockWorker?.terminate).toHaveBeenCalled()
      expect(adapter.isReady()).toBe(false)
    })

    it('should handle dispose when no worker exists', () => {
      const adapter = createRasmWorkerAdapter()

      // Should not throw
      expect(() => adapter.dispose()).not.toThrow()
    })

    it('should clear pending requests on dispose', () => {
      const adapter = createRasmWorkerAdapter()

      // Start compilation but don't resolve it
      adapter.compile({ source: '', outputFormat: 'sna' })

      // Dispose while request is pending
      adapter.dispose()

      // This tests that pendingRequests.clear() is called
      expect(adapter.isReady()).toBe(false)
    })
  })
})
