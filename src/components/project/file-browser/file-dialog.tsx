import Button from '@/components/ui/button/button'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import styles from './file-browser.module.css'

type FileDialogProps = {
  open: boolean
  title: string
  value: string
  submitLabel: string
  loading?: boolean
  onClose: () => void
  onChange: (value: string) => void
  onSubmit: () => void
}

/**
 * Reusable dialog component for file operations (create, rename)
 */
export function FileDialog({
  open,
  title,
  value,
  submitLabel,
  loading = false,
  onClose,
  onChange,
  onSubmit
}: Readonly<FileDialogProps>) {
  if (!open) return null

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      onSubmit()
    }
  }

  return (
    <Modal open={open} title={title} onClose={onClose}>
      <div className={styles.modalContent}>
        <Input
          placeholder='filename.asm'
          value={value}
          onChange={(e) => onChange(e.target.value)}
          onKeyDown={handleKeyDown}
          autoFocus
        />
        <div className={styles.modalActions}>
          <Button variant='outline' onClick={onClose}>
            Cancel
          </Button>
          <Button onClick={onSubmit} disabled={!value.trim() || loading}>
            {submitLabel}
          </Button>
        </div>
      </div>
    </Modal>
  )
}
