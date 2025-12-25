/**
 * useAssembler Hook
 * Assembler-agnostic hook for compiling Z80 assembly code
 * Uses the adapter pattern to support multiple assemblers
 */

import { useAtomValue, useSetAtom } from 'jotai'
import { useCallback, useEffect, useRef } from 'react'
import type { OutputFormat } from '@/domain/services/assembler.interface'
import type { CompilationFile } from '@/domain/services/assembler-adapter.interface'
import { getAssemblerAdapter } from '@/infrastructure/assemblers/adapter-registry'
import {
  compilationErrorAtom,
  compilationOutputAtom,
  compilationStatusAtom,
  selectedAssemblerAtom
} from '@/store'
import { useConsoleMessages } from './use-console-messages'

export function useAssembler() {
  const assemblerType = useAtomValue(selectedAssemblerAtom)
  const setCompilationStatus = useSetAtom(compilationStatusAtom)
  const setCompilationError = useSetAtom(compilationErrorAtom)
  const setCompilationOutput = useSetAtom(compilationOutputAtom)
  const { addMessage: addConsoleMessage, clearErrorLines } =
    useConsoleMessages()

  // Track initialization status
  const isInitializedRef = useRef(false)
  const initializingRef = useRef(false)

  // Initialize the adapter on mount or when assembler type changes
  useEffect(() => {
    const initAdapter = async () => {
      if (initializingRef.current || isInitializedRef.current) return

      initializingRef.current = true

      try {
        const adapter = getAssemblerAdapter(assemblerType)
        if (!adapter.isReady()) {
          await adapter.initialize()
        }
        isInitializedRef.current = true
      } catch (error) {
        console.error(`Failed to initialize ${assemblerType} adapter:`, error)
      } finally {
        initializingRef.current = false
      }
    }

    // Reset when assembler type changes
    isInitializedRef.current = false
    initAdapter()
  }, [assemblerType])

  const compile = useCallback(
    async (
      source: string,
      outputFormat: OutputFormat = 'sna',
      additionalFiles?: CompilationFile[]
    ): Promise<Uint8Array | null> => {
      setCompilationStatus('compiling')
      setCompilationError(null)
      clearErrorLines()

      const adapter = getAssemblerAdapter(assemblerType)

      addConsoleMessage({
        type: 'info',
        text: `Compiling with ${assemblerType.toUpperCase()} to ${outputFormat.toUpperCase()}...`
      })

      try {
        // Ensure adapter is initialized
        if (!adapter.isReady()) {
          await adapter.initialize()
        }

        const result = await adapter.compile({
          source,
          outputFormat,
          additionalFiles
        })

        // Display stdout lines
        for (const line of result.stdout) {
          if (line.trim()) {
            addConsoleMessage({ type: 'info', text: line })
          }
        }

        // Display stderr lines (these will add to errorLinesAtom via addConsoleMessageAtom)
        for (const line of result.stderr) {
          if (line.trim()) {
            addConsoleMessage({ type: 'error', text: line })
          }
        }

        if (!result.success) {
          setCompilationStatus('error')
          setCompilationError(result.error || 'Compilation failed')

          if (result.stderr.length === 0 && result.error) {
            addConsoleMessage({
              type: 'error',
              text: result.error
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
      assemblerType,
      setCompilationStatus,
      setCompilationError,
      setCompilationOutput,
      addConsoleMessage,
      clearErrorLines
    ]
  )

  return {
    compile,
    assemblerType
  }
}
