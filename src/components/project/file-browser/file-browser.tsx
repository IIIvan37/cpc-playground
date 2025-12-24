import { useAtomValue, useSetAtom } from 'jotai'
import { useCallback, useEffect, useRef, useState } from 'react'
import Button from '@/components/ui/button/button'
import { ConfirmDialog } from '@/components/ui/confirm-dialog'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import {
  useActiveProject,
  useAuth,
  useConfirmDialog,
  useCreateFile,
  useDeleteFile,
  useFetchDependencyFiles,
  useSetMainFile,
  useToastActions
} from '@/hooks'
import { createLogger } from '@/lib/logger'
import { codeAtom, currentFileIdAtom } from '@/store'
import { currentProjectIdAtom, dependencyFilesAtom } from '@/store/projects'
import styles from './file-browser.module.css'
import { FileBrowserView } from './file-browser.view'

const logger = createLogger('FileBrowser')

type DependencyFile = {
  id: string
  name: string
  content: string
  projectId: string
}

/**
 * Container component for file browser
 * Handles business logic and state management
 * Provides edit capabilities (add/delete files) for project owners
 */
export function FileBrowser() {
  const { user } = useAuth()
  const { activeProject: project, isReadOnly: isReadOnlyMode } =
    useActiveProject()
  const currentProjectId = useAtomValue(currentProjectIdAtom)
  const dependencyFiles = useAtomValue(dependencyFilesAtom)
  const setDependencyFiles = useSetAtom(dependencyFilesAtom)
  const setCode = useSetAtom(codeAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)
  const { createFile } = useCreateFile()
  const { deleteFile } = useDeleteFile()
  const { setMainFile } = useSetMainFile()
  const { fetchDependencyFiles } = useFetchDependencyFiles()
  const toast = useToastActions()
  const { confirm, dialogProps } = useConfirmDialog()

  const [selectedFileId, setSelectedFileId] = useState<string | null>(null)
  const [selectedDependencyFileId, setSelectedDependencyFileId] = useState<
    string | null
  >(null)
  const [showNewFileDialog, setShowNewFileDialog] = useState(false)
  const [newFileName, setNewFileName] = useState('')
  const [loading, setLoading] = useState(false)

  // Track last project ID to only trigger on project change, not on every update
  const lastProjectIdRef = useRef<string | null>(null)
  // Track dependencies to refetch when they change
  const lastDependenciesRef = useRef<string | null>(null)

  // Auto-select main file on project change and fetch dependencies
  useEffect(() => {
    if (project?.files && project.files.length > 0) {
      // Only reset selection when project ID actually changes
      if (project.id !== lastProjectIdRef.current) {
        lastProjectIdRef.current = project.id
        const mainFile = project.files.find((f) => f.isMain) || project.files[0]
        setSelectedFileId(mainFile.id)
        setCurrentFileId(mainFile.id)
        setCode(mainFile.content?.value ?? '')
        setSelectedDependencyFileId(null) // Reset dependency selection
      }
    }
  }, [project, setCurrentFileId, setCode])

  // Fetch dependency files when dependencies change
  useEffect(() => {
    if (!project) return

    // Create a stable key from dependency IDs
    const dependencyKey =
      project.dependencies
        ?.map((d) => d.id)
        .sort()
        .join(',') ?? ''

    if (dependencyKey !== lastDependenciesRef.current) {
      lastDependenciesRef.current = dependencyKey

      if (project.dependencies && project.dependencies.length > 0) {
        fetchDependencyFiles()
      } else {
        // Clear dependency files when no dependencies
        setDependencyFiles([])
      }
    }
  }, [project, fetchDependencyFiles, setDependencyFiles])

  const handleSelectFile = useCallback(
    (fileId: string) => {
      if (!project?.files) return
      const file = project.files.find((f) => f.id === fileId)
      if (file) {
        setSelectedFileId(file.id)
        setSelectedDependencyFileId(null) // Clear dependency selection
        setCurrentFileId(file.id)
        setCode(file.content?.value ?? '')
      }
    },
    [project, setCurrentFileId, setCode]
  )

  const handleSelectDependencyFile = useCallback(
    (file: DependencyFile) => {
      setSelectedFileId(null) // Clear project file selection
      setSelectedDependencyFileId(file.id)
      setCurrentFileId(file.id)
      setCode(file.content)
    },
    [setCurrentFileId, setCode]
  )

  const handleCreateFile = useCallback(async () => {
    const projectId = currentProjectId || project?.id
    if (!projectId || !newFileName.trim() || !user) return

    setLoading(true)
    try {
      await createFile({
        projectId,
        userId: user.id,
        name: newFileName.trim()
      })
      setShowNewFileDialog(false)
      setNewFileName('')
    } catch (error) {
      logger.error('Failed to create file:', error)
      toast.error('Failed to create file')
    } finally {
      setLoading(false)
    }
  }, [currentProjectId, project?.id, newFileName, user, createFile, toast])

  const handleDeleteFile = useCallback(
    async (fileId: string) => {
      const projectId = currentProjectId || project?.id
      if (!projectId || !user) return

      const confirmed = await confirm({
        title: 'Delete file',
        message: 'Are you sure you want to delete this file?',
        confirmLabel: 'Delete',
        variant: 'danger'
      })
      if (!confirmed) return

      try {
        await deleteFile({
          projectId,
          userId: user.id,
          fileId
        })
      } catch (error) {
        logger.error('Failed to delete file:', error)
        toast.error('Failed to delete file')
      }
    },
    [currentProjectId, project?.id, user, deleteFile, toast, confirm]
  )

  const handleSetMainFile = useCallback(
    async (fileId: string) => {
      const projectId = currentProjectId || project?.id
      if (!projectId || !user) return

      try {
        await setMainFile({
          projectId,
          userId: user.id,
          fileId
        })
      } catch (error) {
        logger.error('Failed to set main file:', error)
        toast.error('Failed to set main file')
      }
    },
    [currentProjectId, project?.id, user, setMainFile, toast]
  )

  const openNewFileDialog = useCallback(() => setShowNewFileDialog(true), [])
  const closeNewFileDialog = useCallback(() => {
    setShowNewFileDialog(false)
    setNewFileName('')
  }, [])

  if (!project) {
    return null
  }

  // Check if user can edit (is owner and not in read-only mode)
  const canEdit = !!(user && !isReadOnlyMode && project.userId === user.id)

  // Map project files to view format (extract primitive values from VOs)
  const files = (project.files ?? []).map((f) => ({
    id: f.id,
    name: f.name?.value ?? '',
    isMain: f.isMain
  }))

  // Map project info to view format
  const projectInfo = {
    name: project.name?.value ?? '',
    visibility: project.visibility?.value ?? 'private',
    isLibrary: project.isLibrary ?? false,
    tags: project.tags ?? []
  }

  // Render the new file dialog (composition pattern)
  const newFileDialog = showNewFileDialog ? (
    <Modal
      open={showNewFileDialog}
      title='New File'
      onClose={closeNewFileDialog}
    >
      <div className={styles.modalContent}>
        <Input
          placeholder='filename.asm'
          value={newFileName}
          onChange={(e) => setNewFileName(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && handleCreateFile()}
          autoFocus
        />
        <div className={styles.modalActions}>
          <Button variant='outline' onClick={closeNewFileDialog}>
            Cancel
          </Button>
          <Button
            onClick={handleCreateFile}
            disabled={!newFileName.trim() || loading}
          >
            Create
          </Button>
        </div>
      </div>
    </Modal>
  ) : null

  return (
    <>
      <FileBrowserView
        project={projectInfo}
        files={files}
        selectedFileId={selectedFileId}
        canEdit={canEdit}
        isReadOnly={isReadOnlyMode}
        dependencies={dependencyFiles}
        selectedDependencyFileId={selectedDependencyFileId}
        onSelectFile={handleSelectFile}
        onSelectDependencyFile={handleSelectDependencyFile}
        onNewFileClick={openNewFileDialog}
        onSetMainFile={handleSetMainFile}
        onDeleteFile={handleDeleteFile}
        newFileDialog={newFileDialog}
      />
      <ConfirmDialog {...dialogProps} />
    </>
  )
}
