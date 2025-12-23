import { FileIcon, GearIcon, PlusIcon, TrashIcon } from '@radix-ui/react-icons'
import Button from '@/components/ui/button/button'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import { Select, SelectItem } from '@/components/ui/select/select'
import styles from './program-manager.module.css'

type ProgramItem = Readonly<{
  id: string
  name: string
}>

export type ProgramManagerViewProps = Readonly<{
  // Data
  savedPrograms: readonly ProgramItem[]
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
}>

/**
 * Sub-component for save dialog
 */
type SaveDialogProps = Readonly<{
  open: boolean
  programName: string
  onProgramNameChange: (value: string) => void
  onSaveConfirm: () => void
  onClose: () => void
}>

function SaveDialog({
  open,
  programName,
  onProgramNameChange,
  onSaveConfirm,
  onClose
}: SaveDialogProps) {
  return (
    <Modal open={open} title='Save Program' onClose={onClose}>
      <div className={styles.modalContent}>
        <Input
          placeholder='Program name'
          value={programName}
          onChange={(e) => onProgramNameChange(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && onSaveConfirm()}
          autoFocus
        />
        <div className={styles.modalActions}>
          <Button variant='outline' onClick={onClose}>
            Cancel
          </Button>
          <Button onClick={onSaveConfirm} disabled={!programName.trim()}>
            Save
          </Button>
        </div>
      </div>
    </Modal>
  )
}

/**
 * Sub-component for delete dialog
 */
type DeleteDialogProps = Readonly<{
  open: boolean
  programName: string | undefined
  onDeleteConfirm: () => void
  onClose: () => void
}>

function DeleteDialog({
  open,
  programName,
  onDeleteConfirm,
  onClose
}: DeleteDialogProps) {
  return (
    <Modal open={open} title='Delete Program' onClose={onClose}>
      <div className={styles.modalContent}>
        <p className={styles.deleteConfirm}>
          Are you sure you want to delete &quot;{programName}&quot;?
        </p>
        <div className={styles.modalActions}>
          <Button variant='outline' onClick={onClose}>
            Cancel
          </Button>
          <Button onClick={onDeleteConfirm}>Delete</Button>
        </div>
      </div>
    </Modal>
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
  onProgramNameChange
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
          open={showSaveDialog}
          programName={programName}
          onProgramNameChange={onProgramNameChange}
          onSaveConfirm={onSaveConfirm}
          onClose={onCloseSaveDialog}
        />
      )}

      {showDeleteDialog && (
        <DeleteDialog
          open={showDeleteDialog}
          programName={currentProgramName}
          onDeleteConfirm={onDeleteConfirm}
          onClose={onCloseDeleteDialog}
        />
      )}
    </>
  )
}
