import {
  FileIcon,
  FilePlusIcon,
  StarFilledIcon,
  StarIcon,
  TrashIcon
} from '@radix-ui/react-icons'
import type { ReactNode } from 'react'
import Button from '@/components/ui/button/button'
import type { VisibilityValue } from '@/domain/value-objects'
import styles from './file-browser.module.css'

// ============================================================================
// Types
// ============================================================================

type FileItem = Readonly<{
  id: string
  name: string
  isMain: boolean
}>

type ProjectInfo = Readonly<{
  name: string
  visibility: VisibilityValue
  isLibrary: boolean
  tags: readonly string[]
}>

// ============================================================================
// Sub-component Props (Interface Segregation)
// ============================================================================

type ProjectHeaderViewProps = Readonly<{
  projectName: string
  canEdit: boolean
  onNewFile: () => void
}>

type ProjectBadgesViewProps = Readonly<{
  visibility: VisibilityValue
  isLibrary: boolean
}>

type FileListViewProps = Readonly<{
  files: readonly FileItem[]
  selectedFileId: string | null
  canEdit: boolean
  isLibrary: boolean
  onSelectFile: (fileId: string) => void
  onSetMainFile: (fileId: string) => void
  onDeleteFile: (fileId: string) => void
}>

type FileItemViewProps = Readonly<{
  file: FileItem
  isSelected: boolean
  canEdit: boolean
  isLibrary: boolean
  canDelete: boolean
  onSelect: () => void
  onSetMain: () => void
  onDelete: () => void
}>

type TagsViewProps = Readonly<{
  tags: readonly string[]
}>

// ============================================================================
// Main View Props (reduced via composition)
// ============================================================================

export type FileBrowserViewProps = Readonly<{
  project: ProjectInfo
  files: readonly FileItem[]
  selectedFileId: string | null
  canEdit: boolean
  onSelectFile: (fileId: string) => void
  onNewFileClick: () => void
  onSetMainFile: (fileId: string) => void
  onDeleteFile: (fileId: string) => void
  /** Slot for the new file dialog - container handles state */
  newFileDialog?: ReactNode
}>

// ============================================================================
// Sub-components
// ============================================================================

function ProjectHeaderView({
  projectName,
  canEdit,
  onNewFile
}: ProjectHeaderViewProps) {
  return (
    <div className={styles.headerRow}>
      <div className={styles.projectName}>{projectName}</div>
      {canEdit && (
        <Button variant='ghost' size='sm' onClick={onNewFile} title='New File'>
          <FilePlusIcon />
        </Button>
      )}
    </div>
  )
}

function ProjectBadgesView({ visibility, isLibrary }: ProjectBadgesViewProps) {
  const hasAnyBadge = visibility === 'public' || isLibrary
  if (!hasAnyBadge) return null

  return (
    <div className={styles.badges}>
      {visibility === 'public' && (
        <span className={`${styles.badge} ${styles.badgePublic}`}>Public</span>
      )}
      {isLibrary && (
        <span className={`${styles.badge} ${styles.badgeLibrary}`}>Lib</span>
      )}
    </div>
  )
}

function FileItemView({
  file,
  isSelected,
  canEdit,
  isLibrary,
  canDelete,
  onSelect,
  onSetMain,
  onDelete
}: FileItemViewProps) {
  const handleSetMain = (e: React.MouseEvent) => {
    e.stopPropagation()
    onSetMain()
  }

  const handleDelete = (e: React.MouseEvent) => {
    e.stopPropagation()
    onDelete()
  }

  return (
    <div className={`${styles.fileItem} ${isSelected ? styles.active : ''}`}>
      <button type='button' className={styles.fileButton} onClick={onSelect}>
        <FileIcon className={styles.fileIcon} />
        <span className={styles.fileName}>{file.name}</span>
        {file.isMain && <StarFilledIcon className={styles.mainIcon} />}
      </button>
      <div className={styles.fileActions}>
        {!file.isMain && canEdit && !isLibrary && (
          <button
            type='button'
            className={styles.actionButton}
            onClick={handleSetMain}
            title='Set as main file'
          >
            <StarIcon />
          </button>
        )}
        {canEdit && canDelete && (
          <button
            type='button'
            className={styles.actionButton}
            onClick={handleDelete}
            title='Delete file'
          >
            <TrashIcon />
          </button>
        )}
      </div>
    </div>
  )
}

function FileListView({
  files,
  selectedFileId,
  canEdit,
  isLibrary,
  onSelectFile,
  onSetMainFile,
  onDeleteFile
}: FileListViewProps) {
  const canDeleteFiles = files.length > 1

  return (
    <div className={styles.fileList}>
      {files.map((file) => (
        <FileItemView
          key={file.id}
          file={file}
          isSelected={selectedFileId === file.id}
          canEdit={canEdit}
          isLibrary={isLibrary}
          canDelete={canDeleteFiles}
          onSelect={() => onSelectFile(file.id)}
          onSetMain={() => onSetMainFile(file.id)}
          onDelete={() => onDeleteFile(file.id)}
        />
      ))}
    </div>
  )
}

function TagsView({ tags }: TagsViewProps) {
  if (tags.length === 0) return null

  return (
    <div className={styles.tags}>
      {tags.map((tag) => (
        <span key={tag} className={styles.tag}>
          {tag}
        </span>
      ))}
    </div>
  )
}

// ============================================================================
// Main View Component
// ============================================================================

export function FileBrowserView({
  project,
  files,
  selectedFileId,
  canEdit,
  onSelectFile,
  onNewFileClick,
  onSetMainFile,
  onDeleteFile,
  newFileDialog
}: FileBrowserViewProps) {
  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <ProjectHeaderView
          projectName={project.name}
          canEdit={canEdit}
          onNewFile={onNewFileClick}
        />
        <ProjectBadgesView
          visibility={project.visibility}
          isLibrary={project.isLibrary}
        />
      </div>

      <FileListView
        files={files}
        selectedFileId={selectedFileId}
        canEdit={canEdit}
        isLibrary={project.isLibrary}
        onSelectFile={onSelectFile}
        onSetMainFile={onSetMainFile}
        onDeleteFile={onDeleteFile}
      />

      <TagsView tags={project.tags} />

      {newFileDialog}
    </div>
  )
}
