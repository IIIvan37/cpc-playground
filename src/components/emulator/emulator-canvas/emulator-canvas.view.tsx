import { CameraIcon } from '@radix-ui/react-icons'
import type { RefObject } from 'react'
import styles from './emulator-canvas.module.css'

type EmulatorCanvasViewProps = Readonly<{
  wrapperRef: RefObject<HTMLButtonElement | null>
  containerRef: RefObject<HTMLDivElement | null>
  hasFocus: boolean
  statusText: string
  canSaveThumbnail: boolean
  savingThumbnail: boolean
  onFocus: () => void
  onBlur: () => void
  onSaveThumbnail: () => void
}>

export function EmulatorCanvasView({
  wrapperRef,
  containerRef,
  hasFocus,
  statusText,
  canSaveThumbnail,
  savingThumbnail,
  onFocus,
  onBlur,
  onSaveThumbnail
}: EmulatorCanvasViewProps) {
  return (
    <div className={styles.container} ref={containerRef}>
      <div className={styles.header}>
        <span className={styles.title}>CPC Emulator</span>
        <div className={styles.headerActions}>
          {canSaveThumbnail && (
            <button
              type='button'
              className={styles.screenshotButton}
              onClick={onSaveThumbnail}
              disabled={savingThumbnail}
              title='Save as project thumbnail'
            >
              <CameraIcon />
            </button>
          )}
          <span className={styles.status}>{statusText}</span>
        </div>
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
