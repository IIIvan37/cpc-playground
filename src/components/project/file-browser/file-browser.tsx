import {
  FileIcon,
  FilePlusIcon,
  StarFilledIcon,
  StarIcon,
  TrashIcon
} from '@radix-ui/react-icons'
import { useAtomValue, useSetAtom } from 'jotai'
import { useState } from 'react'
import Button from '@/components/ui/button/button'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import { useAuth } from '@/hooks'
import {
  activeProjectAtom,
  codeAtom,
  currentFileIdAtom,
  isReadOnlyModeAtom
} from '@/store'
import {
  createFileAtom,
  currentProjectIdAtom,
  deleteFileAtom,
  setMainFileAtom
} from '@/store/projects'
import styles from './file-browser.module.css'

/**
 * File browser component for displaying and navigating project files
 * Works for both owned projects and view-only projects
 * Provides edit capabilities (add/delete files) for project owners
 */
export function FileBrowser() {
  const { user } = useAuth()
  const project = useAtomValue(activeProjectAtom)
  const isReadOnlyMode = useAtomValue(isReadOnlyModeAtom)
  const currentProjectId = useAtomValue(currentProjectIdAtom)
  const setCode = useSetAtom(codeAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)
  const createFile = useSetAtom(createFileAtom)
  const deleteFile = useSetAtom(deleteFileAtom)
  const setMainFile = useSetAtom(setMainFileAtom)

  const [selectedFileId, setSelectedFileId] = useState<string | null>(null)
  const [showNewFileDialog, setShowNewFileDialog] = useState(false)
  const [newFileName, setNewFileName] = useState('')
  const [loading, setLoading] = useState(false)

  if (!project) {
    return null
  }

  // Check if user can edit (is owner and not in read-only mode)
  const canEdit = user && !isReadOnlyMode && project.userId === user.id

  const handleSelectFile = (file: {
    id: string
    content: { value: string }
  }) => {
    setSelectedFileId(file.id)
    setCurrentFileId(file.id)
    setCode(file.content.value)
  }

  const handleCreateFile = async () => {
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
      console.error('Failed to create file:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleDeleteFile = async (fileId: string, e: React.MouseEvent) => {
    e.stopPropagation()
    const projectId = currentProjectId || project?.id
    if (!confirm('Delete this file?') || !projectId || !user) return
    try {
      await deleteFile({
        projectId,
        userId: user.id,
        fileId
      })
    } catch (error) {
      console.error('Failed to delete file:', error)
    }
  }

  const handleSetMainFile = async (fileId: string, e: React.MouseEvent) => {
    e.stopPropagation()
    const projectId = currentProjectId || project?.id
    if (!projectId || !user) return
    try {
      await setMainFile({
        projectId,
        userId: user.id,
        fileId
      })
    } catch (error) {
      console.error('Failed to set main file:', error)
    }
  }

  // Auto-select main file on first render
  if (selectedFileId === null && project.files.length > 0) {
    const mainFile = project.files.find((f) => f.isMain) || project.files[0]
    setSelectedFileId(mainFile.id)
  }

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <div className={styles.headerRow}>
          <div className={styles.projectName}>{project.name.value}</div>
          {canEdit && (
            <Button
              variant='ghost'
              size='sm'
              onClick={() => setShowNewFileDialog(true)}
              title='New File'
            >
              <FilePlusIcon />
            </Button>
          )}
        </div>
        <div className={styles.badges}>
          {project.visibility.value === 'public' && (
            <span className={`${styles.badge} ${styles.badgePublic}`}>
              Public
            </span>
          )}
          {project.isLibrary && (
            <span className={`${styles.badge} ${styles.badgeLibrary}`}>
              Lib
            </span>
          )}
        </div>
      </div>

      <div className={styles.fileList}>
        {project.files.map((file) => (
          <div
            key={file.id}
            className={`${styles.fileItem} ${
              selectedFileId === file.id ? styles.active : ''
            }`}
          >
            <button
              type='button'
              className={styles.fileButton}
              onClick={() => handleSelectFile(file)}
            >
              <FileIcon className={styles.fileIcon} />
              <span className={styles.fileName}>{file.name.value}</span>
              {file.isMain && <StarFilledIcon className={styles.mainIcon} />}
            </button>
            <div className={styles.fileActions}>
              {!file.isMain && canEdit && !project.isLibrary && (
                <button
                  type='button'
                  className={styles.actionButton}
                  onClick={(e) => handleSetMainFile(file.id, e)}
                  title='Set as main file'
                >
                  <StarIcon />
                </button>
              )}
              {canEdit && project.files.length > 1 && (
                <button
                  type='button'
                  className={styles.actionButton}
                  onClick={(e) => handleDeleteFile(file.id, e)}
                  title='Delete file'
                >
                  <TrashIcon />
                </button>
              )}
            </div>
          </div>
        ))}
      </div>

      {project.tags && project.tags.length > 0 && (
        <div className={styles.tags}>
          {project.tags.map((tag) => (
            <span key={tag} className={styles.tag}>
              {tag}
            </span>
          ))}
        </div>
      )}

      {showNewFileDialog && (
        <Modal
          open={showNewFileDialog}
          title='New File'
          onClose={() => setShowNewFileDialog(false)}
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
              <Button
                variant='outline'
                onClick={() => setShowNewFileDialog(false)}
              >
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
      )}
    </div>
  )
}
