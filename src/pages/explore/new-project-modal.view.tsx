import Button from '@/components/ui/button/button'
import { Checkbox } from '@/components/ui/checkbox'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import styles from './explore.module.css'

export interface NewProjectModalViewProps {
  readonly open: boolean
  readonly name: string
  readonly isLibrary: boolean
  readonly creating: boolean
  readonly onNameChange: (name: string) => void
  readonly onIsLibraryChange: (isLibrary: boolean) => void
  readonly onSubmit: () => void
  readonly onClose: () => void
}

export function NewProjectModalView({
  open,
  name,
  isLibrary,
  creating,
  onNameChange,
  onIsLibraryChange,
  onSubmit,
  onClose
}: NewProjectModalViewProps) {
  if (!open) return null

  return (
    <Modal open={open} title='Create New Project' onClose={onClose}>
      <div className={styles.modalContent}>
        <Input
          label='Project Name'
          value={name}
          onChange={(e) => onNameChange(e.target.value)}
          placeholder='My Awesome Project'
          autoFocus
        />
        <Checkbox
          label='Library Project'
          checked={isLibrary}
          onChange={(e) => onIsLibraryChange(e.target.checked)}
        />
        <div className={styles.modalActions}>
          <Button variant='ghost' onClick={onClose}>
            Cancel
          </Button>
          <Button onClick={onSubmit} disabled={!name.trim() || creating}>
            {creating ? 'Creating...' : 'Create'}
          </Button>
        </div>
      </div>
    </Modal>
  )
}
