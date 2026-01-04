import { getDefaultStore, useAtomValue, useSetAtom } from 'jotai'
import { useCallback, useEffect, useRef, useState } from 'react'
import { ConfirmDialog } from '@/components/ui/confirm-dialog'
import {
  useActiveProject,
  useAuth,
  useConfirmDialog,
  useCreateFile,
  useCurrentFile,
  useCurrentProject,
  useDeleteFile,
  useFetchDependencyFiles,
  useSetMainFile,
  useToastActions,
  useUpdateFile
} from '@/hooks'
import { createLogger } from '@/lib/logger'
import { codeAtom, currentFileIdAtom } from '@/store'
import { currentProjectIdAtom, dependencyFilesAtom } from '@/store/projects'

// Store reference for reading codeAtom without subscription
const store = getDefaultStore()

import { FileBrowserView } from './file-browser.view'
import { FileDialog } from './file-dialog'

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
  const { updateFile } = useUpdateFile()
  const { fetchDependencyFiles } = useFetchDependencyFiles()
  const toast = useToastActions()
  const { confirm, dialogProps } = useConfirmDialog()
  const currentFile = useCurrentFile()
  const { project: currentProject } = useCurrentProject()

  const [selectedFileId, setSelectedFileId] = useState<string | null>(null)
  const [selectedDependencyFileId, setSelectedDependencyFileId] = useState<
    string | null
  >(null)
  const [showNewFileDialog, setShowNewFileDialog] = useState(false)
  const [newFileName, setNewFileName] = useState('')
  const [showRenameDialog, setShowRenameDialog] = useState(false)
  const [renameFileId, setRenameFileId] = useState<string | null>(null)
  const [renameFileName, setRenameFileName] = useState('')
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
        const mainFileContent = mainFile.content?.value
        if (mainFileContent === undefined) return // Don't set empty content
        setSelectedFileId(mainFile.id)
        setCurrentFileId(mainFile.id)
        setCode(mainFileContent)
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
        .sort((a, b) => a.localeCompare(b))
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
    async (fileId: string) => {
      if (!project?.files) return
      const file = project.files.find((f) => f.id === fileId)
      const fileContent = file?.content?.value
      if (!file || fileContent === undefined) return

      // Save unsaved changes of the current file before switching
      if (currentFile && currentProject && user) {
        const currentCode = store.get(codeAtom)
        if (currentCode !== currentFile.content.value) {
          try {
            await updateFile({
              projectId: currentProject.id,
              userId: user.id,
              fileId: currentFile.id,
              content: currentCode
            })
            logger.debug('Saved unsaved changes before switching file', {
              fileId: currentFile.id
            })
          } catch (error) {
            logger.error('Failed to save file before switching:', error)
          }
        }
      }

      // IMPORTANT: Set fileId BEFORE setting code to prevent race conditions
      // The auto-save hook checks if currentFileId matches currentFile.id
      setSelectedFileId(file.id)
      setSelectedDependencyFileId(null) // Clear dependency selection
      setCurrentFileId(file.id)
      setCode(fileContent)
    },
    [
      project,
      setCurrentFileId,
      setCode,
      currentFile,
      currentProject,
      user,
      updateFile
    ]
  )

  const handleSelectDependencyFile = useCallback(
    async (file: DependencyFile) => {
      // Save unsaved changes of the current file before switching
      if (currentFile && currentProject && user) {
        const currentCode = store.get(codeAtom)
        if (currentCode !== currentFile.content.value) {
          try {
            await updateFile({
              projectId: currentProject.id,
              userId: user.id,
              fileId: currentFile.id,
              content: currentCode
            })
            logger.debug(
              'Saved unsaved changes before switching to dependency',
              {
                fileId: currentFile.id
              }
            )
          } catch (error) {
            logger.error('Failed to save file before switching:', error)
          }
        }
      }

      setSelectedFileId(null) // Clear project file selection
      setSelectedDependencyFileId(file.id)
      setCurrentFileId(file.id)
      setCode(file.content)
    },
    [setCurrentFileId, setCode, currentFile, currentProject, user, updateFile]
  )

  const handleCreateFile = useCallback(async () => {
    const projectId = currentProjectId || project?.id
    if (!projectId || !newFileName.trim() || !user || loading) return

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
  }, [
    currentProjectId,
    project?.id,
    newFileName,
    user,
    createFile,
    toast,
    loading
  ])

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

  const openRenameDialog = useCallback(
    (fileId: string) => {
      const file = project?.files?.find((f) => f.id === fileId)
      if (file) {
        setRenameFileId(fileId)
        setRenameFileName(file.name?.value ?? '')
        setShowRenameDialog(true)
      }
    },
    [project?.files]
  )

  const closeRenameDialog = useCallback(() => {
    setShowRenameDialog(false)
    setRenameFileId(null)
    setRenameFileName('')
  }, [])

  const handleRenameFile = useCallback(async () => {
    const projectId = currentProjectId || project?.id
    if (
      !projectId ||
      !renameFileId ||
      !renameFileName.trim() ||
      !user ||
      loading
    )
      return

    setLoading(true)
    try {
      await updateFile({
        projectId,
        userId: user.id,
        fileId: renameFileId,
        name: renameFileName.trim()
      })
      closeRenameDialog()
    } catch (error) {
      logger.error('Failed to rename file:', error)
      toast.error('Failed to rename file')
    } finally {
      setLoading(false)
    }
  }, [
    currentProjectId,
    project?.id,
    renameFileId,
    renameFileName,
    user,
    updateFile,
    toast,
    loading,
    closeRenameDialog
  ])

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
  const newFileDialog = (
    <FileDialog
      open={showNewFileDialog}
      title='New File'
      value={newFileName}
      submitLabel='Create'
      loading={loading}
      onClose={closeNewFileDialog}
      onChange={setNewFileName}
      onSubmit={handleCreateFile}
    />
  )

  // Render the rename file dialog
  const renameFileDialog = (
    <FileDialog
      open={showRenameDialog}
      title='Rename File'
      value={renameFileName}
      submitLabel='Rename'
      loading={loading}
      onClose={closeRenameDialog}
      onChange={setRenameFileName}
      onSubmit={handleRenameFile}
    />
  )

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
        onRenameFile={openRenameDialog}
        onDeleteFile={handleDeleteFile}
        newFileDialog={newFileDialog}
        renameFileDialog={renameFileDialog}
      />
      <ConfirmDialog {...dialogProps} />
    </>
  )
}
