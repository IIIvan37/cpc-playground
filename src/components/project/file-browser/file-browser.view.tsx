import {
  ChevronRightIcon,
  CubeIcon,
  FileIcon,
  FilePlusIcon,
  StarFilledIcon,
  StarIcon,
  TrashIcon
} from '@radix-ui/react-icons'
import { type ReactNode, useState } from 'react'
import { Badge } from '@/components/ui/badge'
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

type DependencyFileItem = Readonly<{
  id: string
  name: string
  content: string
  projectId: string
}>

type DependencyProjectItem = Readonly<{
  id: string
  name: string
  files: readonly DependencyFileItem[]
}>

// ============================================================================
// Sub-component Props (Interface Segregation)
// ============================================================================

type ProjectHeaderViewProps = Readonly<{
  projectName: string
  canEdit: boolean
  isReadOnly: boolean
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

type DependencyFileViewProps = Readonly<{
  file: DependencyFileItem
  isSelected: boolean
  onSelect: () => void
}>

type DependencyProjectViewProps = Readonly<{
  project: DependencyProjectItem
  selectedFileId: string | null
  onSelectFile: (file: DependencyFileItem) => void
}>

type DependenciesSectionViewProps = Readonly<{
  dependencies: readonly DependencyProjectItem[]
  selectedDependencyFileId: string | null
  onSelectDependencyFile: (file: DependencyFileItem) => void
}>

// ============================================================================
// Main View Props (reduced via composition)
// ============================================================================

export type FileBrowserViewProps = Readonly<{
  project: ProjectInfo
  files: readonly FileItem[]
  selectedFileId: string | null
  canEdit: boolean
  isReadOnly: boolean
  dependencies?: readonly DependencyProjectItem[]
  selectedDependencyFileId?: string | null
  onSelectFile: (fileId: string) => void
  onSelectDependencyFile?: (file: DependencyFileItem) => void
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
  isReadOnly,
  onNewFile
}: ProjectHeaderViewProps) {
  return (
    <div className={styles.headerRow}>
      <div className={styles.projectNameRow}>
        <div className={styles.projectName}>{projectName}</div>
        {isReadOnly && <Badge variant='readOnly'>Read-only</Badge>}
      </div>
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
      {visibility === 'public' && <Badge variant='public'>Public</Badge>}
      {isLibrary && <Badge variant='library'>Library</Badge>}
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

function DependencyFileView({
  file,
  isSelected,
  onSelect
}: DependencyFileViewProps) {
  return (
    <div
      className={`${styles.dependencyFileItem} ${
        isSelected ? styles.active : ''
      }`}
      onClick={onSelect}
      onKeyDown={(e) => e.key === 'Enter' && onSelect()}
      role='button'
      tabIndex={0}
    >
      <FileIcon className={styles.fileIcon} />
      <span className={styles.fileName}>{file.name}</span>
    </div>
  )
}

function DependencyProjectView({
  project,
  selectedFileId,
  onSelectFile
}: DependencyProjectViewProps) {
  const [isExpanded, setIsExpanded] = useState(false)

  return (
    <div className={styles.dependencyProject}>
      <div
        className={styles.dependencyHeader}
        onClick={() => setIsExpanded(!isExpanded)}
        onKeyDown={(e) => e.key === 'Enter' && setIsExpanded(!isExpanded)}
        role='button'
        tabIndex={0}
      >
        <ChevronRightIcon
          className={`${styles.collapseIcon} ${
            isExpanded ? styles.expanded : ''
          }`}
        />
        <CubeIcon className={styles.dependencyIcon} />
        <span className={styles.dependencyName}>{project.name}</span>
      </div>
      {isExpanded && (
        <div className={styles.dependencyFiles}>
          {project.files.map((file) => (
            <DependencyFileView
              key={file.id}
              file={file}
              isSelected={selectedFileId === file.id}
              onSelect={() => onSelectFile(file)}
            />
          ))}
        </div>
      )}
    </div>
  )
}

function DependenciesSectionView({
  dependencies,
  selectedDependencyFileId,
  onSelectDependencyFile
}: DependenciesSectionViewProps) {
  const [isExpanded, setIsExpanded] = useState(true)

  if (dependencies.length === 0) return null

  return (
    <div className={styles.dependenciesSection}>
      <div
        className={styles.sectionHeader}
        onClick={() => setIsExpanded(!isExpanded)}
        onKeyDown={(e) => e.key === 'Enter' && setIsExpanded(!isExpanded)}
        role='button'
        tabIndex={0}
      >
        <ChevronRightIcon
          className={`${styles.collapseIcon} ${
            isExpanded ? styles.expanded : ''
          }`}
        />
        <span>Dependencies ({dependencies.length})</span>
      </div>
      {isExpanded &&
        dependencies.map((dep) => (
          <DependencyProjectView
            key={dep.id}
            project={dep}
            selectedFileId={selectedDependencyFileId ?? null}
            onSelectFile={onSelectDependencyFile}
          />
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
  isReadOnly,
  dependencies = [],
  selectedDependencyFileId = null,
  onSelectFile,
  onSelectDependencyFile,
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
          isReadOnly={isReadOnly}
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

      {dependencies.length > 0 && onSelectDependencyFile && (
        <DependenciesSectionView
          dependencies={dependencies}
          selectedDependencyFileId={selectedDependencyFileId}
          onSelectDependencyFile={onSelectDependencyFile}
        />
      )}

      {newFileDialog}
    </div>
  )
}
