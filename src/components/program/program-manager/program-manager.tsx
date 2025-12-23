import { useAtom, useAtomValue, useSetAtom } from 'jotai'
import { useCallback, useEffect, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { ProjectSettingsModal } from '@/components/project'
import {
  codeAtom,
  currentProgramIdAtom,
  deleteProgramAtom,
  fetchProgramsAtom,
  newProgramAtom,
  savedProgramsAtom,
  saveProgramAtom
} from '@/store'
import {
  currentFileIdAtom,
  currentProjectAtom,
  currentProjectIdAtom,
  isReadOnlyModeAtom,
  viewOnlyProjectAtom
} from '@/store/projects'
import { ProgramManagerView } from './program-manager.view'

/**
 * Container component for program manager
 * Handles business logic and delegates rendering to ProgramManagerView
 */
export function ProgramManager() {
  const [searchParams, setSearchParams] = useSearchParams()
  const [code, setCode] = useAtom(codeAtom)
  const savedPrograms = useAtomValue(savedProgramsAtom)
  const [currentProgramId, setCurrentProgramId] = useAtom(currentProgramIdAtom)
  const saveProgram = useSetAtom(saveProgramAtom)
  const deleteProgram = useSetAtom(deleteProgramAtom)
  const fetchPrograms = useSetAtom(fetchProgramsAtom)
  const newProgram = useSetAtom(newProgramAtom)
  const setCurrentProjectId = useSetAtom(currentProjectIdAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)
  const setViewOnlyProject = useSetAtom(viewOnlyProjectAtom)
  const setIsReadOnlyMode = useSetAtom(isReadOnlyModeAtom)

  const [showSaveDialog, setShowSaveDialog] = useState(false)
  const [showDeleteDialog, setShowDeleteDialog] = useState(false)
  const [showSettings, setShowSettings] = useState(false)
  const [programName, setProgramName] = useState('')
  const [selectKey, setSelectKey] = useState(0)

  const currentProgram = savedPrograms.find((p) => p.id === currentProgramId)
  const currentProject = useAtomValue(currentProjectAtom)

  // Load programs from localStorage on mount
  useEffect(() => {
    fetchPrograms()
  }, [fetchPrograms])

  // Switch to scratch mode: clear project state and URL
  const switchToScratchMode = useCallback(() => {
    setCurrentProjectId(null)
    setCurrentFileId(null)
    setViewOnlyProject(null)
    setIsReadOnlyMode(false)
    // Remove project param from URL
    if (searchParams.has('project')) {
      searchParams.delete('project')
      setSearchParams(searchParams, { replace: true })
    }
  }, [
    searchParams,
    setSearchParams,
    setCurrentProjectId,
    setCurrentFileId,
    setViewOnlyProject,
    setIsReadOnlyMode
  ])

  const handleNew = () => {
    newProgram()
    switchToScratchMode()
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
      switchToScratchMode()
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

  // Map programs to view format
  const programItems = savedPrograms.map((p) => ({
    id: p.id,
    name: p.name.value
  }))

  // Can save when:
  // - Not viewing a project file
  // - Either it's a new scratch program OR the current program has been modified
  const isModified = currentProgram ? code !== currentProgram.code : false
  const canSave = !currentProject && (!currentProgram || isModified)

  return (
    <>
      <ProgramManagerView
        savedPrograms={programItems}
        currentProgramName={currentProgram?.name.value}
        currentProgramId={currentProgramId}
        selectKey={selectKey}
        hasCurrentProject={!!currentProject}
        canSave={canSave}
        showSaveDialog={showSaveDialog}
        showDeleteDialog={showDeleteDialog}
        programName={programName}
        onLoad={handleLoad}
        onNew={handleNew}
        onSave={handleSave}
        onDelete={handleDelete}
        onOpenSettings={() => setShowSettings(true)}
        onSaveConfirm={handleSaveConfirm}
        onDeleteConfirm={handleDeleteConfirm}
        onCloseSaveDialog={closeSaveDialog}
        onCloseDeleteDialog={closeDeleteDialog}
        onProgramNameChange={setProgramName}
      />

      {showSettings && currentProject && (
        <ProjectSettingsModal onClose={() => setShowSettings(false)} />
      )}
    </>
  )
}
