/**
 * useConsoleMessages Hook
 * Manages console messages with error line extraction
 * Encapsulates the business logic that was previously in the store
 */

import { useAtom, useAtomValue, useSetAtom } from 'jotai'
import { useCallback } from 'react'
import { getAssemblerRegistry } from '@/infrastructure/assemblers'
import {
  type ConsoleMessage,
  clearConsoleAtom,
  clearErrorLinesAtom,
  consoleMessagesAtom,
  errorLinesAtom,
  selectedAssemblerAtom
} from '@/store'

// Global counter to ensure unique message IDs across hook instances
let globalMessageCounter = 0

export function useConsoleMessages() {
  const assemblerType = useAtomValue(selectedAssemblerAtom)
  const [messages, setMessages] = useAtom(consoleMessagesAtom)
  const [errorLines, setErrorLines] = useAtom(errorLinesAtom)
  const clearConsole = useSetAtom(clearConsoleAtom)
  const clearErrorLines = useSetAtom(clearErrorLinesAtom)

  const addMessage = useCallback(
    (message: Omit<ConsoleMessage, 'timestamp' | 'id' | 'line'>) => {
      globalMessageCounter += 1

      // Get the error parser for the selected assembler
      const registry = getAssemblerRegistry()
      const assembler = registry.get(assemblerType) ?? registry.getDefault()
      const line = assembler.config.errorParser.extractLineNumber(message.text)

      // If we extracted a line number, it's an error line - add to highlights
      // (RASM outputs errors to stdout, so we can't rely on message type)
      if (line !== undefined) {
        setErrorLines((currentErrors) =>
          currentErrors.includes(line)
            ? currentErrors
            : [...currentErrors, line]
        )
      }

      setMessages((currentMessages) => [
        ...currentMessages,
        {
          ...message,
          id: `msg-${globalMessageCounter}`,
          timestamp: new Date(),
          line
        }
      ])
    },
    [assemblerType, setMessages, setErrorLines]
  )

  return {
    messages,
    errorLines,
    addMessage,
    clearConsole,
    clearErrorLines
  }
}
