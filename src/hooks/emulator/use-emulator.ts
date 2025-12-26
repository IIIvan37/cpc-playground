import { useAtomValue, useSetAtom } from 'jotai'
import { useCallback, useEffect } from 'react'
import {
  emulatorReadyAtom,
  emulatorResetTriggerAtom,
  emulatorRunningAtom
} from '@/store'
import { useConsoleMessages } from './use-console-messages'

const CPCEC_BASE_URL = import.meta.env.DEV
  ? 'https://cpcec-web.iiivan.org'
  : '/cdn'

// Singleton for CPCEC module - prevents multiple loads
let cpcecModule: any = null
let cpcecLoadPromise: Promise<any> | null = null
let cpcecScriptLoaded = false

// Track the last processed reset trigger to avoid processing it multiple times
let lastProcessedResetTrigger = 0

export function useEmulator() {
  const isReady = useAtomValue(emulatorReadyAtom)
  const isRunning = useAtomValue(emulatorRunningAtom)
  const resetTrigger = useAtomValue(emulatorResetTriggerAtom)
  const setEmulatorReady = useSetAtom(emulatorReadyAtom)
  const setEmulatorRunning = useSetAtom(emulatorRunningAtom)
  const { addMessage: addConsoleMessage } = useConsoleMessages()

  // Listen for external reset triggers (e.g., when switching projects)
  useEffect(() => {
    // Only process if the trigger has actually changed
    if (resetTrigger === lastProcessedResetTrigger) {
      return
    }
    lastProcessedResetTrigger = resetTrigger

    if (cpcecModule?._em_reset) {
      cpcecModule._em_reset()
      setEmulatorRunning(false)
    }
  }, [resetTrigger, setEmulatorRunning])

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

  const injectDsk = useCallback(
    (dskData: Uint8Array) => {
      if (!cpcecModule) {
        addConsoleMessage({ type: 'error', text: 'Emulator not ready' })
        return
      }

      try {
        console.log('[Emulator] Injecting DSK, size:', dskData.length)
        console.log(
          '[Emulator] Available CPCEC functions:',
          Object.keys(cpcecModule).filter((key) => key.startsWith('_em_'))
        )

        // Write DSK to MEMFS
        const filename = '/program.dsk'
        cpcecModule.FS.writeFile(filename, dskData)
        console.log('[Emulator] DSK written to MEMFS')

        // Check if _em_inject_file exists
        if (typeof cpcecModule._em_inject_file === 'function') {
          cpcecModule._em_inject_file(cpcecModule.allocateUTF8(filename))
          addConsoleMessage({
            type: 'success',
            text: `DSK injected (${dskData.length} bytes) - Ready to be accessed`
          })
        } else {
          // Function not available yet
          addConsoleMessage({
            type: 'warning',
            text: `Inject function not available - use Run instead`
          })
        }
      } catch (error) {
        console.error('[Emulator] DSK inject error:', error)
        const message =
          error instanceof Error ? error.message : 'Failed to inject DSK'
        addConsoleMessage({ type: 'error', text: message })
      }
    },
    [addConsoleMessage]
  )

  const reset = useCallback(() => {
    if (cpcecModule?._em_reset) {
      cpcecModule._em_reset()
      setEmulatorRunning(false)
      addConsoleMessage({ type: 'info', text: 'Emulator reset' })
    }
  }, [setEmulatorRunning, addConsoleMessage])

  const isInjectAvailable = useCallback(() => {
    return cpcecModule
      ? typeof cpcecModule._em_inject_file === 'function'
      : false
  }, [])

  return {
    isReady,
    isRunning,
    initialize,
    loadSna,
    loadDsk,
    injectDsk,
    isInjectAvailable,
    reset
  }
}
