import { type Toast as ToastType, useToast } from '@/hooks/core/use-toast'
import styles from './toast.module.css'

function CheckIcon() {
  return (
    <svg
      viewBox='0 0 20 20'
      fill='currentColor'
      className={styles.icon}
      aria-hidden='true'
    >
      <path
        fillRule='evenodd'
        d='M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z'
        clipRule='evenodd'
      />
    </svg>
  )
}

function ErrorIcon() {
  return (
    <svg
      viewBox='0 0 20 20'
      fill='currentColor'
      className={styles.icon}
      aria-hidden='true'
    >
      <path
        fillRule='evenodd'
        d='M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z'
        clipRule='evenodd'
      />
    </svg>
  )
}

function WarningIcon() {
  return (
    <svg
      viewBox='0 0 20 20'
      fill='currentColor'
      className={styles.icon}
      aria-hidden='true'
    >
      <path
        fillRule='evenodd'
        d='M8.485 2.495c.673-1.167 2.357-1.167 3.03 0l6.28 10.875c.673 1.167-.17 2.625-1.516 2.625H3.72c-1.347 0-2.189-1.458-1.515-2.625L8.485 2.495zM10 5a.75.75 0 01.75.75v3.5a.75.75 0 01-1.5 0v-3.5A.75.75 0 0110 5zm0 9a1 1 0 100-2 1 1 0 000 2z'
        clipRule='evenodd'
      />
    </svg>
  )
}

function InfoIcon() {
  return (
    <svg
      viewBox='0 0 20 20'
      fill='currentColor'
      className={styles.icon}
      aria-hidden='true'
    >
      <path
        fillRule='evenodd'
        d='M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a.75.75 0 000 1.5h.253a.25.25 0 01.244.304l-.459 2.066A1.75 1.75 0 0010.747 15H11a.75.75 0 000-1.5h-.253a.25.25 0 01-.244-.304l.459-2.066A1.75 1.75 0 009.253 9H9z'
        clipRule='evenodd'
      />
    </svg>
  )
}

function CloseIcon() {
  return (
    <svg
      viewBox='0 0 20 20'
      fill='currentColor'
      width='16'
      height='16'
      aria-hidden='true'
    >
      <path d='M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z' />
    </svg>
  )
}

const icons: Record<ToastType['type'], React.FC> = {
  success: CheckIcon,
  error: ErrorIcon,
  warning: WarningIcon,
  info: InfoIcon
}

type ToastItemProps = Readonly<{
  toast: ToastType
  onClose: (id: string) => void
}>

function ToastItem({ toast, onClose }: ToastItemProps) {
  const Icon = icons[toast.type]

  return (
    <div
      className={`${styles.toast} ${styles[toast.type]}`}
      role='alert'
      aria-live='polite'
    >
      <Icon />
      <div className={styles.content}>
        <p className={styles.title}>{toast.title}</p>
        {toast.message && <p className={styles.message}>{toast.message}</p>}
      </div>
      <button
        type='button'
        className={styles.closeButton}
        onClick={() => onClose(toast.id)}
        aria-label='Dismiss notification'
      >
        <CloseIcon />
      </button>
    </div>
  )
}

/**
 * Toast container component - renders all active toasts
 * Should be placed at the root of the app
 */
export function ToastContainer() {
  const { toasts, removeToast } = useToast()

  if (toasts.length === 0) return null

  return (
    <div
      className={styles.toastContainer}
      role='region'
      aria-label='Notifications'
    >
      {toasts.map((toast) => (
        <ToastItem key={toast.id} toast={toast} onClose={removeToast} />
      ))}
    </div>
  )
}
