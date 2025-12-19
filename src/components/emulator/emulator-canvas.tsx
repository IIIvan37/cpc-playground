import { useEffect, useRef, useState } from 'react'
import { useEmulator } from '@/hooks'
import styles from './emulator-canvas.module.css'

// Flag to control whether CPCEC should receive keyboard events
let emulatorHasFocus = false

export function getEmulatorFocus() {
  return emulatorHasFocus
}

export function EmulatorCanvas() {
  const canvasRef = useRef<HTMLCanvasElement>(null)
  const containerRef = useRef<HTMLDivElement>(null)
  const { initialize, isReady } = useEmulator()
  const [hasFocus, setHasFocus] = useState(false)

  useEffect(() => {
    if (canvasRef.current && !isReady) {
      initialize(canvasRef.current)
    }
  }, [initialize, isReady])

  // Intercept ALL keyboard events and block them from CPCEC when not focused
  useEffect(() => {
    const blockKeyboardForCPCEC = (e: KeyboardEvent) => {
      // If emulator doesn't have focus, stop the event completely
      if (!emulatorHasFocus) {
        // Don't block if target is the emulator canvas wrapper itself
        if (containerRef.current?.contains(e.target as Node)) {
          return
        }
        // Stop propagation and prevent CPCEC from seeing this event
        e.stopImmediatePropagation()
      }
    }

    // Add at capture phase with highest priority
    document.addEventListener('keydown', blockKeyboardForCPCEC, true)
    document.addEventListener('keyup', blockKeyboardForCPCEC, true)
    document.addEventListener('keypress', blockKeyboardForCPCEC, true)

    return () => {
      document.removeEventListener('keydown', blockKeyboardForCPCEC, true)
      document.removeEventListener('keyup', blockKeyboardForCPCEC, true)
      document.removeEventListener('keypress', blockKeyboardForCPCEC, true)
    }
  }, [])

  const handleFocus = () => {
    emulatorHasFocus = true
    setHasFocus(true)
  }

  const handleBlur = () => {
    emulatorHasFocus = false
    setHasFocus(false)
  }

  return (
    <div className={styles.container} ref={containerRef}>
      <div className={styles.header}>
        <span className={styles.title}>CPC Emulator</span>
        <span className={styles.status}>
          {isReady
            ? hasFocus
              ? '● Active'
              : '○ Click to type'
            : '○ Loading...'}
        </span>
      </div>
      <button
        type='button'
        className={`${styles.canvasWrapper} ${hasFocus ? styles.focused : ''}`}
        onFocus={handleFocus}
        onBlur={handleBlur}
      >
        <canvas
          ref={canvasRef}
          className={styles.canvas}
          width={768}
          height={544}
        />
      </button>
    </div>
  )
}
