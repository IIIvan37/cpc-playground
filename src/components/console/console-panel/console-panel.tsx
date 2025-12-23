import { useAtomValue, useSetAtom } from 'jotai'
import { useCallback, useEffect, useRef } from 'react'
import { clearConsoleAtom, consoleMessagesAtom, goToLineAtom } from '@/store'
import { ConsolePanelView } from './console-panel.view'

/**
 * Container component for console panel
 * Handles business logic and state management
 */
export function ConsolePanel() {
  const messages = useAtomValue(consoleMessagesAtom)
  const clearConsole = useSetAtom(clearConsoleAtom)
  const setGoToLine = useSetAtom(goToLineAtom)
  const messagesRef = useRef<HTMLDivElement>(null)

  // Auto-scroll to bottom when new messages arrive
  // biome-ignore lint/correctness/useExhaustiveDependencies: intentional trigger on messages change
  useEffect(() => {
    const container = messagesRef.current
    if (container) {
      container.scrollTop = container.scrollHeight
    }
  }, [messages])

  const handleLineClick = useCallback(
    (line: number) => {
      setGoToLine(line)
    },
    [setGoToLine]
  )

  const handleClear = useCallback(() => {
    clearConsole()
  }, [clearConsole])

  return (
    <ConsolePanelView
      messages={messages}
      messagesRef={messagesRef}
      onClear={handleClear}
      onLineClick={handleLineClick}
    />
  )
}
