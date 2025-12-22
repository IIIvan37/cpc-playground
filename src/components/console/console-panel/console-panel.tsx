import Ansi from 'ansi-to-react'
import { useAtomValue, useSetAtom } from 'jotai'
import { useEffect, useRef } from 'react'
import Button from '@/components/ui/button/button'
import { clearConsoleAtom, consoleMessagesAtom, goToLineAtom } from '@/store'
import styles from './console-panel.module.css'

export function ConsolePanel() {
  const messages = useAtomValue(consoleMessagesAtom)
  const clearConsole = useSetAtom(clearConsoleAtom)
  const setGoToLine = useSetAtom(goToLineAtom)
  const messagesRef = useRef<HTMLDivElement>(null)

  // biome-ignore lint/correctness/useExhaustiveDependencies: scroll when messages change
  useEffect(() => {
    const container = messagesRef.current
    if (container) {
      container.scrollTop = container.scrollHeight
    }
  }, [messages.length])

  const handleMessageClick = (line: number | undefined) => {
    if (line !== undefined) {
      setGoToLine(line)
    }
  }

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <span className={styles.title}>Console</span>
        <Button variant='icon' onClick={() => clearConsole()}>
          ✕
        </Button>
      </div>
      <div className={styles.messages} ref={messagesRef}>
        {messages.map((msg) => {
          const isClickable = msg.line !== undefined
          const baseClassName = `${styles.message} ${styles[msg.type]} ${isClickable ? styles.clickable : ''}`

          if (isClickable) {
            return (
              <button
                type='button'
                key={msg.id}
                className={baseClassName}
                onClick={() => handleMessageClick(msg.line)}
              >
                <span className={styles.timestamp}>
                  {msg.timestamp.toLocaleTimeString()}
                </span>
                <span className={styles.text}>
                  <Ansi>{msg.text}</Ansi>
                  <span className={styles.lineHint}> (line {msg.line})</span>
                </span>
              </button>
            )
          }

          return (
            <div key={msg.id} className={baseClassName}>
              <span className={styles.timestamp}>
                {msg.timestamp.toLocaleTimeString()}
              </span>
              <span className={styles.text}>
                <Ansi>{msg.text}</Ansi>
              </span>
            </div>
          )
        })}
      </div>
    </div>
  )
}
