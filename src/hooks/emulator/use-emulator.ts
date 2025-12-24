import { useAtomValue, useSetAtom } from 'jotai'
import { useCallback } from 'react'
import {
  addConsoleMessageAtom,
  emulatorReadyAtom,
  emulatorRunningAtom
} from '@/store'

const CPCEC_BASE_URL = import.meta.env.DEV
  ? 'https://cpcec-web.iiivan.org'
  : '/cdn'

// Singleton for CPCEC module - prevents multiple loads
let cpcecModule: any = null
let cpcecLoadPromise: Promise<any> | null = null
let cpcecScriptLoaded = false

export function useEmulator() {
  const isReady = useAtomValue(emulatorReadyAtom)
  const isRunning = useAtomValue(emulatorRunningAtom)
  const setEmulatorReady = useSetAtom(emulatorReadyAtom)
  const setEmulatorRunning = useSetAtom(emulatorRunningAtom)
  const addConsoleMessage = useSetAtom(addConsoleMessageAtom)

  const initialize = useCallback(
    async (canvas: HTMLCanvasElement) => {
      // Already initialized - update canvas reference for remounted component
      if (cpcecModule) {
        // Update canvas dimensions
        canvas.width = 768
        canvas.height = 576

        // Get new 2D context
        const ctx = canvas.getContext('2d', {
          alpha: false,
          desynchronized: true
        })

        if (ctx) {
          // Update Module references to point to new canvas
          cpcecModule.canvas = canvas
          cpcecModule.ctx = ctx
          ;(globalThis as any).Module.canvas = canvas
          ;(globalThis as any).Module.ctx = ctx
        }

        setEmulatorReady(true)
        return
      }

      // Already loading - wait and then update canvas
      if (cpcecLoadPromise) {
        await cpcecLoadPromise
        // Recursively call to update canvas references
        await initialize(canvas)
        return
      }

      addConsoleMessage({ type: 'info', text: 'Loading CPCEC emulator...' })

      cpcecLoadPromise = (async () => {
        try {
          const wasmResponse = await fetch(`${CPCEC_BASE_URL}/cpcec.wasm`)
          const wasmBinary = await wasmResponse.arrayBuffer()

          return new Promise<void>((resolve, reject) => {
            // Ensure canvas has proper dimensions
            canvas.width = 768
            canvas.height = 576

            // Get 2D context - CPCEC needs this
            const ctx = canvas.getContext('2d', {
              alpha: false,
              desynchronized: true
            })

            if (!ctx) {
              reject(new Error('Failed to get canvas 2D context'))
              return
            }

            const Module = {
              canvas,
              ctx,
              wasmBinary,
              locateFile: (path: string) => `${CPCEC_BASE_URL}/${path}`,
              preRun: [],
              postRun: [],
              print: (text: string) => console.log('[CPCEC]', text),
              printErr: (text: string) => console.error('[CPCEC]', text),
              onRuntimeInitialized: () => {
                cpcecModule = Module
                setEmulatorReady(true)
                addConsoleMessage({
                  type: 'success',
                  text: 'CPCEC emulator loaded successfully!'
                })
                resolve()
              }
            }

            ;(globalThis as any).Module = Module

            // Only load script once
            if (!cpcecScriptLoaded) {
              cpcecScriptLoaded = true
              const script = document.createElement('script')
              script.src = `${CPCEC_BASE_URL}/cpcec.js`
              script.async = true
              script.onerror = () => {
                cpcecScriptLoaded = false
                cpcecLoadPromise = null
                reject(new Error('Failed to load cpcec.js'))
              }
              document.head.appendChild(script)
            }
          })
        } catch (error) {
          cpcecLoadPromise = null
          throw error
        }
      })()

      try {
        await cpcecLoadPromise
      } catch (error) {
        const message =
          error instanceof Error ? error.message : 'Failed to load emulator'
        addConsoleMessage({ type: 'error', text: message })
      }
    },
    [setEmulatorReady, addConsoleMessage]
  )

  const loadSna = useCallback(
    (snaData: Uint8Array) => {
      if (!cpcecModule) {
        addConsoleMessage({ type: 'error', text: 'Emulator not ready' })
        return
      }

      try {
        console.log('[Emulator] Loading SNA, size:', snaData.length)

        // Write SNA to MEMFS
        const filename = '/program.sna'
        cpcecModule.FS.writeFile(filename, snaData)
        console.log('[Emulator] SNA written to MEMFS')

        // Use em_load_file to load the SNA
        cpcecModule._em_load_file(cpcecModule.allocateUTF8(filename))

        setEmulatorRunning(true)
        addConsoleMessage({
          type: 'success',
          text: `SNA loaded (${snaData.length} bytes)`
        })
      } catch (error) {
        console.error('[Emulator] SNA load error:', error)
        const message =
          error instanceof Error ? error.message : 'Failed to load SNA'
        addConsoleMessage({ type: 'error', text: message })
      }
    },
    [setEmulatorRunning, addConsoleMessage]
  )

  const loadDsk = useCallback(
    (dskData: Uint8Array) => {
      if (!cpcecModule) {
        addConsoleMessage({ type: 'error', text: 'Emulator not ready' })
        return
      }

      try {
        console.log('[Emulator] Loading DSK, size:', dskData.length)

        // Write DSK to MEMFS
        const filename = '/program.dsk'
        cpcecModule.FS.writeFile(filename, dskData)
        console.log('[Emulator] DSK written to MEMFS')

        // Use em_load_file to load the DSK
        cpcecModule._em_load_file(cpcecModule.allocateUTF8(filename))

        setEmulatorRunning(true)
        addConsoleMessage({
          type: 'success',
          text: `DSK loaded (${dskData.length} bytes) - Type CAT then RUN"PROGRAM`
        })
      } catch (error) {
        console.error('[Emulator] DSK load error:', error)
        const message =
          error instanceof Error ? error.message : 'Failed to load DSK'
        addConsoleMessage({ type: 'error', text: message })
      }
    },
    [setEmulatorRunning, addConsoleMessage]
  )

  const reset = useCallback(() => {
    if (cpcecModule?._em_reset) {
      cpcecModule._em_reset()
      setEmulatorRunning(false)
      addConsoleMessage({ type: 'info', text: 'Emulator reset' })
    }
  }, [setEmulatorRunning, addConsoleMessage])

  return {
    isReady,
    isRunning,
    initialize,
    loadSna,
    loadDsk,
    reset
  }
}
