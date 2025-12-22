import { FileIcon, GearIcon, PlusIcon, TrashIcon } from '@radix-ui/react-icons'
import Button from '@/components/ui/button/button'
import { Select, SelectItem } from '@/components/ui/select/select'
import styles from './program-manager.module.css'

interface ProgramItem {
  id: string
  name: string
}

export interface ProgramManagerViewProps {
  // Data
  savedPrograms: ProgramItem[]
  currentProgramName: string | undefined
  currentProgramId: string | null
  selectKey: number
  hasCurrentProject: boolean

  // Dialog states
  showSaveDialog: boolean
  showDeleteDialog: boolean
  programName: string

  // Handlers
  onLoad: (id: string) => void
  onNew: () => void
  onSave: () => void
  onDelete: () => void
  onOpenSettings: () => void
  onSaveConfirm: () => void
  onDeleteConfirm: () => void
  onCloseSaveDialog: () => void
  onCloseDeleteDialog: () => void
  onProgramNameChange: (value: string) => void

  // Refs
  inputRef: React.RefObject<HTMLInputElement | null>
}

/**
 * Sub-component for save dialog
 */
function SaveDialog({
  programName,
  onProgramNameChange,
  onSaveConfirm,
  onClose,
  inputRef
}: {
  programName: string
  onProgramNameChange: (value: string) => void
  onSaveConfirm: () => void
  onClose: () => void
  inputRef: React.RefObject<HTMLInputElement | null>
}) {
  const handleOverlayKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Escape') onClose()
  }

  return (
    <div
      role='dialog'
      aria-modal='true'
      aria-labelledby='save-dialog-title'
      className={styles.dialogOverlay}
      onClick={onClose}
      onKeyDown={handleOverlayKeyDown}
    >
      <div
        role='document'
        className={styles.dialog}
        onClick={(e) => e.stopPropagation()}
        onKeyDown={(e) => e.stopPropagation()}
      >
        <h3 id='save-dialog-title' className={styles.dialogTitle}>
          Save Program
        </h3>
        <input
          ref={inputRef}
          className={styles.dialogInput}
          type='text'
          placeholder='Program name'
          value={programName}
          onChange={(e) => onProgramNameChange(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && onSaveConfirm()}
        />
        <div className={styles.dialogActions}>
          <Button variant='secondary' onClick={onClose}>
            Cancel
          </Button>
          <Button onClick={onSaveConfirm}>Save</Button>
        </div>
      </div>
    </div>
  )
}

/**
 * Sub-component for delete dialog
 */
function DeleteDialog({
  programName,
  onDeleteConfirm,
  onClose
}: {
  programName: string | undefined
  onDeleteConfirm: () => void
  onClose: () => void
}) {
  const handleOverlayKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Escape') onClose()
  }

  return (
    <div
      role='dialog'
      aria-modal='true'
      aria-labelledby='delete-dialog-title'
      className={styles.dialogOverlay}
      onClick={onClose}
      onKeyDown={handleOverlayKeyDown}
    >
      <div
        role='document'
        className={styles.dialog}
        onClick={(e) => e.stopPropagation()}
        onKeyDown={(e) => e.stopPropagation()}
      >
        <h3 id='delete-dialog-title' className={styles.dialogTitle}>
          Delete Program
        </h3>
        <p className={styles.deleteConfirm}>
          Are you sure you want to delete &quot;{programName}&quot;?
        </p>
        <div className={styles.dialogActions}>
          <Button variant='secondary' onClick={onClose}>
            Cancel
          </Button>
          <Button onClick={onDeleteConfirm}>Delete</Button>
        </div>
      </div>
    </div>
  )
}

/**
 * Pure view component for program manager
 * All state and handlers come from props
 */
export function ProgramManagerView({
  savedPrograms,
  currentProgramName,
  currentProgramId,
  selectKey,
  hasCurrentProject,
  showSaveDialog,
  showDeleteDialog,
  programName,
  onLoad,
  onNew,
  onSave,
  onDelete,
  onOpenSettings,
  onSaveConfirm,
  onDeleteConfirm,
  onCloseSaveDialog,
  onCloseDeleteDialog,
  onProgramNameChange,
  inputRef
}: ProgramManagerViewProps) {
  return (
    <>
      <div className={styles.programManager}>
        <Select
          key={selectKey}
          value={undefined}
          onValueChange={onLoad}
          placeholder={currentProgramName || 'Select program...'}
        >
          {savedPrograms.map((p) => (
            <SelectItem key={p.id} value={p.id}>
              {p.name}
            </SelectItem>
          ))}
        </Select>

        <div className={styles.programActions}>
          <Button variant='icon' onClick={onNew} title='New program'>
            <PlusIcon />
          </Button>
          <Button variant='icon' onClick={onSave} title='Save'>
            <FileIcon />
          </Button>
          <Button
            variant='icon'
            onClick={onDelete}
            disabled={!currentProgramId}
            title='Delete'
          >
            <TrashIcon />
          </Button>
          {hasCurrentProject && (
            <Button
              variant='icon'
              onClick={onOpenSettings}
              title='Project Settings'
            >
              <GearIcon />
            </Button>
          )}
        </div>
      </div>

      {showSaveDialog && (
        <SaveDialog
          programName={programName}
          onProgramNameChange={onProgramNameChange}
          onSaveConfirm={onSaveConfirm}
          onClose={onCloseSaveDialog}
          inputRef={inputRef}
        />
      )}

      {showDeleteDialog && (
        <DeleteDialog
          programName={currentProgramName}
          onDeleteConfirm={onDeleteConfirm}
          onClose={onCloseDeleteDialog}
        />
      )}
    </>
  )
}
