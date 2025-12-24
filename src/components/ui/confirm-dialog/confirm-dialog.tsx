import Button from '../button/button'
import { Modal } from '../modal'
import styles from './confirm-dialog.module.css'

type ConfirmDialogProps = Readonly<{
  open: boolean
  title: string
  message: string
  confirmLabel?: string
  cancelLabel?: string
  variant?: 'danger' | 'warning' | 'default'
  onConfirm: () => void
  onCancel: () => void
}>

/**
 * Confirmation dialog component
 * Replaces native confirm() with a styled modal
 */
export function ConfirmDialog({
  open,
  title,
  message,
  confirmLabel = 'Confirm',
  cancelLabel = 'Cancel',
  variant = 'default',
  onConfirm,
  onCancel
}: ConfirmDialogProps) {
  return (
    <Modal open={open} onClose={onCancel} title={title} size='sm'>
      <div className={styles.content}>
        <p className={styles.message}>{message}</p>
        <div className={styles.actions}>
          <Button variant='outline' onClick={onCancel}>
            {cancelLabel}
          </Button>
          <Button
            variant='primary'
            className={variant === 'danger' ? styles.dangerButton : undefined}
            onClick={onConfirm}
          >
            {confirmLabel}
          </Button>
        </div>
      </div>
    </Modal>
  )
}
