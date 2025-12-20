import { useSetAtom } from 'jotai'
import { useCallback, useEffect, useRef } from 'react'
import type { OutputFormat } from '@/store'
import {
  addConsoleMessageAtom,
  clearErrorLinesAtom,
  compilationErrorAtom,
  compilationOutputAtom,
  compilationStatusAtom
} from '@/store'
import RasmWorker from '@/workers/rasm.worker?worker'

// Singleton worker instance
let worker: Worker | null = null
let messageId = 0

function getWorker(): Worker {
  if (!worker) {
    worker = new RasmWorker()
  }
  return worker
}

interface CompileResponse {
  success: boolean
  binary?: Uint8Array
  error?: string
  stdout?: string[]
  stderr?: string[]
}

interface ProjectFile {
  name: string
  content: string
  projectName?: string // Optional project name for namespacing
}

export function useRasm() {
  const setCompilationStatus = useSetAtom(compilationStatusAtom)
  const setCompilationError = useSetAtom(compilationErrorAtom)
  const setCompilationOutput = useSetAtom(compilationOutputAtom)
  const addConsoleMessage = useSetAtom(addConsoleMessageAtom)
  const clearErrorLines = useSetAtom(clearErrorLinesAtom)

  const pendingRef = useRef<Map<number, (result: CompileResponse) => void>>(
    new Map()
  )

  useEffect(() => {
    const w = getWorker()

    const handleMessage = (e: MessageEvent) => {
      const { id, ...result } = e.data
      const resolver = pendingRef.current.get(id)
      if (resolver) {
        pendingRef.current.delete(id)
        resolver(result)
      }
    }

    w.addEventListener('message', handleMessage)

    // Initialize worker
    const initId = messageId++
    w.postMessage({ type: 'init', id: initId })

    return () => {
      w.removeEventListener('message', handleMessage)
    }
  }, [])

  const compile = useCallback(
    async (
      source: string,
      outputFormat: OutputFormat = 'sna',
      additionalFiles?: ProjectFile[]
    ): Promise<Uint8Array | null> => {
      setCompilationStatus('compiling')
      setCompilationError(null)
      clearErrorLines() // Clear previous error highlights
      addConsoleMessage({
        type: 'info',
        text: `Compiling to ${outputFormat.toUpperCase()}...`
      })

      try {
        const w = getWorker()
        const id = messageId++

        const result = await new Promise<CompileResponse>((resolve) => {
          pendingRef.current.set(id, resolve)
          w.postMessage({
            type: 'compile',
            id,
            source,
            outputFormat,
            additionalFiles
          })
        })

        // Display stdout lines
        if (result.stdout && result.stdout.length > 0) {
          for (const line of result.stdout) {
            if (line.trim()) {
              addConsoleMessage({ type: 'info', text: line })
            }
          }
        }

        // Display stderr lines (these will add to errorLinesAtom via addConsoleMessageAtom)
        if (result.stderr && result.stderr.length > 0) {
          for (const line of result.stderr) {
            if (line.trim()) {
              addConsoleMessage({ type: 'error', text: line })
            }
          }
        }

        if (!result.success) {
          setCompilationStatus('error')
          setCompilationError(result.error || 'Compilation failed')
          if (!result.stderr?.length) {
            addConsoleMessage({
              type: 'error',
              text: result.error || 'Compilation failed'
            })
          }
          return null
        }

        const binary = result.binary as Uint8Array
        setCompilationStatus('success')
        setCompilationOutput(binary)
        addConsoleMessage({
          type: 'success',
          text: `Compilation successful! ${outputFormat.toUpperCase()} size: ${binary.length} bytes`
        })

        return binary
      } catch (error) {
        const message =
          error instanceof Error ? error.message : 'Compilation failed'
        setCompilationStatus('error')
        setCompilationError(message)
        addConsoleMessage({ type: 'error', text: message })
        return null
      }
    },
    [
      setCompilationStatus,
      setCompilationError,
      setCompilationOutput,
      addConsoleMessage,
      clearErrorLines
    ]
  )

  return { compile }
}
