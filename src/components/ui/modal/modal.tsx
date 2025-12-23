import { type ReactNode, useCallback, useEffect, useRef } from 'react'
import styles from './modal.module.css'

type ModalSize = 'sm' | 'md' | 'lg' | 'xl'

type ModalProps = Readonly<{
  /** Whether the modal is open */
  open: boolean
  /** Called when the modal should close (clicking overlay or close button) */
  onClose: () => void
  /** Modal title */
  title?: string
  /** Modal content */
  children: ReactNode
  /** Modal size */
  size?: ModalSize
  /** Whether to show the close button */
  showCloseButton?: boolean
  /** Footer actions */
  actions?: ReactNode
  /** Additional class name for the modal */
  className?: string
}>

export function Modal({
  open,
  onClose,
  title,
  children,
  size = 'md',
  showCloseButton = true,
  actions,
  className
}: ModalProps) {
  const overlayRef = useRef<HTMLDialogElement>(null)

  const handleKeyDown = useCallback(
    (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        e.preventDefault()
        e.stopPropagation()
        onClose()
      }
    },
    [onClose]
  )

  useEffect(() => {
    if (!open) return

    // Use capture phase to intercept before other handlers
    document.addEventListener('keydown', handleKeyDown, true)
    return () => document.removeEventListener('keydown', handleKeyDown, true)
  }, [open, handleKeyDown])

  // Focus the overlay when modal opens
  useEffect(() => {
    if (open && overlayRef.current) {
      overlayRef.current.focus()
    }
  }, [open])

  if (!open) return null

  const sizeClass =
    styles[`size${size.charAt(0).toUpperCase()}${size.slice(1)}`]

  return (
    <dialog
      ref={overlayRef}
      open
      className={`${styles.overlay} ${styles.nativeDialog}`}
      onClose={onClose}
    >
      <div className={`${styles.modal} ${sizeClass} ${className ?? ''}`}>
        {(title || showCloseButton) && (
          <div className={styles.header}>
            {title && <h3 className={styles.title}>{title}</h3>}
            {showCloseButton && (
              <button
                type='button'
                className={styles.closeButton}
                onClick={onClose}
                aria-label='Close'
              >
                ×
              </button>
            )}
          </div>
        )}
        <div className={styles.content}>{children}</div>
        {actions && <div className={styles.actions}>{actions}</div>}
      </div>
    </dialog>
  )
}
