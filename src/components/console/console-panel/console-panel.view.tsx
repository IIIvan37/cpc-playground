import Ansi from 'ansi-to-react'
import type { RefObject } from 'react'
import Button from '@/components/ui/button/button'
import styles from './console-panel.module.css'

// ============================================================================
// Types
// ============================================================================

type ConsoleMessage = Readonly<{
  id: string
  type: 'info' | 'error' | 'success' | 'warning'
  text: string
  timestamp: Date
  line?: number
}>

// ============================================================================
// Sub-component Props
// ============================================================================

type MessageViewProps = Readonly<{
  message: ConsoleMessage
  onLineClick: (line: number) => void
}>

// ============================================================================
// Main View Props
// ============================================================================

export type ConsolePanelViewProps = Readonly<{
  messages: readonly ConsoleMessage[]
  messagesRef: RefObject<HTMLDivElement | null>
  onClear: () => void
  onLineClick: (line: number) => void
}>

// ============================================================================
// Sub-components
// ============================================================================

function MessageView({ message, onLineClick }: MessageViewProps) {
  const isClickable = message.line !== undefined
  const baseClassName = `${styles.message} ${styles[message.type]} ${
    isClickable ? styles.clickable : ''
  }`

  if (isClickable) {
    return (
      <button
        type='button'
        className={baseClassName}
        onClick={() => onLineClick(message.line!)}
      >
        <span className={styles.timestamp}>
          {message.timestamp.toLocaleTimeString()}
        </span>
        <span className={styles.text}>
          <Ansi>{message.text}</Ansi>
          <span className={styles.lineHint}> (line {message.line})</span>
        </span>
      </button>
    )
  }

  return (
    <div className={baseClassName}>
      <span className={styles.timestamp}>
        {message.timestamp.toLocaleTimeString()}
      </span>
      <span className={styles.text}>
        <Ansi>{message.text}</Ansi>
      </span>
    </div>
  )
}

// ============================================================================
// Main View Component
// ============================================================================

export function ConsolePanelView({
  messages,
  messagesRef,
  onClear,
  onLineClick
}: ConsolePanelViewProps) {
  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <span className={styles.title}>Console</span>
        <Button variant='icon' onClick={onClear}>
          ✕
        </Button>
      </div>
      <div className={styles.messages} ref={messagesRef}>
        {messages.map((msg) => (
          <MessageView key={msg.id} message={msg} onLineClick={onLineClick} />
        ))}
      </div>
    </div>
  )
}
