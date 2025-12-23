import type { RefObject } from 'react'
import styles from './emulator-canvas.module.css'

type EmulatorCanvasViewProps = Readonly<{
  canvasRef: RefObject<HTMLCanvasElement | null>
  containerRef: RefObject<HTMLDivElement | null>
  hasFocus: boolean
  statusText: string
  onFocus: () => void
  onBlur: () => void
}>

export function EmulatorCanvasView({
  canvasRef,
  containerRef,
  hasFocus,
  statusText,
  onFocus,
  onBlur
}: EmulatorCanvasViewProps) {
  return (
    <div className={styles.container} ref={containerRef}>
      <div className={styles.header}>
        <span className={styles.title}>CPC Emulator</span>
        <span className={styles.status}>{statusText}</span>
      </div>
      <button
        type='button'
        className={`${styles.canvasWrapper} ${hasFocus ? styles.focused : ''}`}
        onFocus={onFocus}
        onBlur={onBlur}
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
