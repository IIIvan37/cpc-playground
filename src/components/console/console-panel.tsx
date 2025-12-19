import Ansi from 'ansi-to-react'
import { useAtomValue, useSetAtom } from 'jotai'
import Button from '@/components/ui/button/button'
import { clearConsoleAtom, consoleMessagesAtom } from '@/store'
import styles from './console-panel.module.css'

export function ConsolePanel() {
  const messages = useAtomValue(consoleMessagesAtom)
  const clearConsole = useSetAtom(clearConsoleAtom)

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <span className={styles.title}>Console</span>
        <Button variant='icon' onClick={() => clearConsole()}>
          ✕
        </Button>
      </div>
      <div className={styles.messages}>
        {messages.map((msg) => (
          <div key={msg.id} className={`${styles.message} ${styles[msg.type]}`}>
            <span className={styles.timestamp}>
              {msg.timestamp.toLocaleTimeString()}
            </span>
            <span className={styles.text}>
              <Ansi>{msg.text}</Ansi>
            </span>
          </div>
        ))}
      </div>
    </div>
  )
}
