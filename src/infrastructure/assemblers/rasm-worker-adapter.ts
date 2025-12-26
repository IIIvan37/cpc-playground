/**
 * RASM Worker Adapter
 * Implements IAssemblerAdapter for the RASM assembler
 */

import type { AssemblerType } from '@/domain/services/assembler.interface'
import type {
  CompilationOptions,
  CompilationResult,
  IAssemblerAdapter
} from '@/domain/services/assembler-adapter.interface'
import { createLogger } from '@/lib/logger'
import RasmWorker from '@/workers/rasm.worker?worker'

/**
 * Create a RASM worker adapter
 */
export function createRasmWorkerAdapter(): IAssemblerAdapter {
  // Message ID counter for request/response matching (per-adapter instance)
  let messageId = 0
  let worker: Worker | null = null
  let isInitialized = false
  const pendingRequests = new Map<
    number,
    {
      resolve: (result: CompilationResult) => void
      reject: (error: Error) => void
    }
  >()
  const logger = createLogger('RasmWorkerAdapter')

  function getWorker(): Worker {
    if (!worker) {
      worker = new RasmWorker()

      worker.addEventListener('message', (e: MessageEvent) => {
        const { id, ...result } = e.data
        const pending = pendingRequests.get(id)

        if (pending) {
          pendingRequests.delete(id)

          // Normalize result to CompilationResult
          pending.resolve({
            success: result.success ?? false,
            binary: result.binary,
            error: result.error,
            stdout: result.stdout ?? [],
            stderr: result.stderr ?? []
          })
        }
      })

      worker.addEventListener('error', (e: ErrorEvent) => {
        logger.error('Worker error', e)
        // Reject all pending requests
        for (const [id, pending] of pendingRequests) {
          pending.reject(new Error(`Worker error: ${e.message}`))
          pendingRequests.delete(id)
        }
      })
    }

    return worker
  }

  return {
    type: 'rasm' as AssemblerType,

    async initialize(): Promise<void> {
      if (isInitialized) return

      const w = getWorker()
      const id = messageId++

      await new Promise<void>((resolve, reject) => {
        const timeout = setTimeout(() => {
          reject(new Error('RASM initialization timeout'))
        }, 30000) // 30 second timeout

        const handler = (e: MessageEvent) => {
          if (e.data.id === id && e.data.type === 'init') {
            clearTimeout(timeout)
            w.removeEventListener('message', handler)
            if (e.data.success) {
              resolve()
            } else {
              reject(new Error(e.data.error || 'RASM initialization failed'))
            }
          }
        }

        w.addEventListener('message', handler)
        w.postMessage({ type: 'init', id })
      })

      isInitialized = true
    },

    isReady(): boolean {
      return isInitialized
    },

    async compile(options: CompilationOptions): Promise<CompilationResult> {
      const w = getWorker()
      const id = messageId++

      return new Promise((resolve, reject) => {
        pendingRequests.set(id, { resolve, reject })

        w.postMessage({
          type: 'compile',
          id,
          source: options.source,
          outputFormat: options.outputFormat,
          additionalFiles: options.additionalFiles
        })
      })
    },

    dispose(): void {
      if (worker) {
        worker.terminate()
        worker = null
        isInitialized = false
        pendingRequests.clear()
      }
    }
  }
}
