import { FileIcon, GearIcon, PlusIcon, TrashIcon } from '@radix-ui/react-icons'
import { useAtom, useAtomValue, useSetAtom } from 'jotai'
import { useCallback, useEffect, useRef, useState } from 'react'
import { ProjectSettingsModal } from '@/components/project/project-settings-modal'
import Button from '@/components/ui/button/button'
import { Select, SelectItem } from '@/components/ui/select/select'
import {
  codeAtom,
  currentProgramIdAtom,
  deleteProgramAtom,
  newProgramAtom,
  savedProgramsAtom,
  saveProgramAtom
} from '@/store'
import {
  currentFileIdAtom,
  currentProjectAtom,
  currentProjectIdAtom
} from '@/store/projects'
import styles from './program-manager.module.css'

export function ProgramManager() {
  const [code, setCode] = useAtom(codeAtom)
  const savedPrograms = useAtomValue(savedProgramsAtom)
  const [currentProgramId, setCurrentProgramId] = useAtom(currentProgramIdAtom)
  const saveProgram = useSetAtom(saveProgramAtom)
  const deleteProgram = useSetAtom(deleteProgramAtom)
  const newProgram = useSetAtom(newProgramAtom)
  const setCurrentProjectId = useSetAtom(currentProjectIdAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)

  const [showSaveDialog, setShowSaveDialog] = useState(false)
  const [showDeleteDialog, setShowDeleteDialog] = useState(false)
  const [showSettings, setShowSettings] = useState(false)
  const [programName, setProgramName] = useState('')
  const [selectKey, setSelectKey] = useState(0)
  const inputRef = useRef<HTMLInputElement>(null)

  const currentProgram = savedPrograms.find((p) => p.id === currentProgramId)
  const currentProject = useAtomValue(currentProjectAtom)

  // Focus input when dialog opens
  useEffect(() => {
    if (showSaveDialog && inputRef.current) {
      inputRef.current.focus()
    }
  }, [showSaveDialog])

  const handleNew = () => {
    newProgram()
    setCode(`; New Program
org #4000

start:
    ret
`)
  }

  const handleSave = () => {
    if (currentProgram) {
      // Update existing - save directly
      saveProgram({ name: currentProgram.name.value, code })
    } else {
      // New - show dialog to enter name
      setProgramName('')
      setShowSaveDialog(true)
    }
  }

  const handleSaveConfirm = () => {
    if (programName.trim()) {
      // Create new program with this name
      setCurrentProgramId(null) // Force create new
      saveProgram({ name: programName.trim(), code })
      setShowSaveDialog(false)
    }
  }

  const handleLoad = (id: string) => {
    const program = savedPrograms.find((p) => p.id === id)
    if (program) {
      setCurrentProgramId(id)
      setCode(program.code)
      // Switch to scratch mode (deselect any project)
      setCurrentProjectId(null)
      setCurrentFileId(null)
      // Reset select key to allow re-selecting same value
      setSelectKey((k) => k + 1)
    }
  }

  const handleDelete = () => {
    if (currentProgramId) {
      setShowDeleteDialog(true)
    }
  }

  const handleDeleteConfirm = () => {
    if (currentProgramId) {
      deleteProgram(currentProgramId)
      handleNew()
    }
    setShowDeleteDialog(false)
  }

  const closeSaveDialog = useCallback(() => setShowSaveDialog(false), [])
  const closeDeleteDialog = useCallback(() => setShowDeleteDialog(false), [])

  const handleOverlayKeyDown = useCallback(
    (e: React.KeyboardEvent, closeHandler: () => void) => {
      if (e.key === 'Escape') {
        closeHandler()
      }
    },
    []
  )

  return (
    <>
      <div className={styles.programManager}>
        <Select
          key={selectKey}
          value={undefined}
          onValueChange={handleLoad}
          placeholder={currentProgram?.name.value || 'Select program...'}
        >
          {savedPrograms.map((p) => (
            <SelectItem key={p.id} value={p.id}>
              {p.name.value}
            </SelectItem>
          ))}
        </Select>

        <div className={styles.programActions}>
          <Button variant='icon' onClick={handleNew} title='New program'>
            <PlusIcon />
          </Button>
          <Button variant='icon' onClick={handleSave} title='Save'>
            <FileIcon />
          </Button>
          <Button
            variant='icon'
            onClick={handleDelete}
            disabled={!currentProgramId}
            title='Delete'
          >
            <TrashIcon />
          </Button>
          {currentProject && (
            <Button
              variant='icon'
              onClick={() => setShowSettings(true)}
              title='Project Settings'
            >
              <GearIcon />
            </Button>
          )}
        </div>
      </div>

      {/* Save Dialog */}
      {showSaveDialog && (
        <div
          role='dialog'
          aria-modal='true'
          aria-labelledby='save-dialog-title'
          className={styles.dialogOverlay}
          onClick={closeSaveDialog}
          onKeyDown={(e) => handleOverlayKeyDown(e, closeSaveDialog)}
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
              onChange={(e) => setProgramName(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSaveConfirm()}
            />
            <div className={styles.dialogActions}>
              <Button variant='secondary' onClick={closeSaveDialog}>
                Cancel
              </Button>
              <Button onClick={handleSaveConfirm}>Save</Button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Dialog */}
      {showDeleteDialog && (
        <div
          role='dialog'
          aria-modal='true'
          aria-labelledby='delete-dialog-title'
          className={styles.dialogOverlay}
          onClick={closeDeleteDialog}
          onKeyDown={(e) => handleOverlayKeyDown(e, closeDeleteDialog)}
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
              Are you sure you want to delete &quot;{currentProgram?.name.value}
              &quot;?
            </p>
            <div className={styles.dialogActions}>
              <Button variant='secondary' onClick={closeDeleteDialog}>
                Cancel
              </Button>
              <Button onClick={handleDeleteConfirm}>Delete</Button>
            </div>
          </div>
        </div>
      )}

      {showSettings && currentProject && (
        <ProjectSettingsModal onClose={() => setShowSettings(false)} />
      )}
    </>
  )
}
