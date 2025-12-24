import type { RefObject } from 'react'
import styles from './emulator-canvas.module.css'

type EmulatorCanvasViewProps = Readonly<{
  wrapperRef: RefObject<HTMLButtonElement | null>
  containerRef: RefObject<HTMLDivElement | null>
  hasFocus: boolean
  statusText: string
  onFocus: () => void
  onBlur: () => void
}>

export function EmulatorCanvasView({
  wrapperRef,
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
      {/* Canvas is appended here programmatically to persist across mounts */}
      <button
        ref={wrapperRef}
        type='button'
        className={`${styles.canvasWrapper} ${hasFocus ? styles.focused : ''}`}
        onFocus={onFocus}
        onBlur={onBlur}
      />
    </div>
  )
}
