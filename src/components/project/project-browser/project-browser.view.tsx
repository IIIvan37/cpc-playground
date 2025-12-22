import {
  ChevronDownIcon,
  ChevronRightIcon,
  FileIcon,
  FilePlusIcon,
  PlusIcon,
  StarFilledIcon,
  StarIcon,
  TrashIcon
} from '@radix-ui/react-icons'
import Button from '@/components/ui/button/button'
import Checkbox from '@/components/ui/checkbox/checkbox'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import type { Project } from '@/domain/entities/project.entity'
import styles from './project-browser.module.css'

// ============================================================================
// Types
// ============================================================================

export type DependencyProject = {
  id: string
  name: string
  files: Array<{
    id: string
    name: string
    content: string
    projectId: string
  }>
}

export type ProjectBrowserViewProps = {
  // Data
  projects: Project[]
  currentProjectId: string | null
  currentProject: Project | null
  currentFileId: string | null
  dependencyFiles: DependencyProject[]
  expandedDeps: Set<string>
  loadingDeps: boolean

  // Modal state
  showNewProjectDialog: boolean
  showNewFileDialog: boolean
  newProjectName: string
  newProjectIsLibrary: boolean
  newFileName: string
  saveCurrentCode: boolean
  loading: boolean

  // Handlers
  onSelectProject: (projectId: string) => void
  onSelectFile: (fileId: string) => void
  onSelectDependencyFile: (file: {
    id: string
    content: string
    projectId: string
  }) => void
  onToggleDependency: (depId: string) => void
  onDeleteProject: () => void
  onDeleteFile: (fileId: string, e: React.MouseEvent) => void
  onSetMainFile: (fileId: string, e: React.MouseEvent) => void
  onCreateProject: () => void
  onCreateFile: () => void
  onSaveToProject: () => void

  // Modal handlers
  onOpenNewProjectDialog: () => void
  onCloseNewProjectDialog: () => void
  onOpenNewFileDialog: () => void
  onCloseNewFileDialog: () => void
  onNewProjectNameChange: (value: string) => void
  onNewProjectIsLibraryChange: (checked: boolean) => void
  onNewFileNameChange: (value: string) => void
}

// ============================================================================
// Sub-components
// ============================================================================

function ProjectListItem({
  project,
  isActive,
  onSelect,
  onDelete
}: {
  project: Project
  isActive: boolean
  onSelect: () => void
  onDelete: () => void
}) {
  return (
    <div
      className={`${styles.project} ${isActive ? styles.active : ''}`}
      onClick={onSelect}
      role='button'
      tabIndex={0}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') onSelect()
      }}
    >
      <div className={styles.projectMeta}>
        <div className={styles.projectName}>
          <span>{project.name.value}</span>
          {project.visibility.value === 'public' && (
            <span className={`${styles.badge} ${styles.badgePublic}`}>
              Public
            </span>
          )}
          {project.visibility.value === 'unlisted' && (
            <span className={`${styles.badge} ${styles.badgeShared}`}>
              Shared
            </span>
          )}
          {project.isLibrary && (
            <span className={`${styles.badge} ${styles.badgeLibrary}`}>
              Lib
            </span>
          )}
        </div>
        {project.tags && project.tags.length > 0 && (
          <div className={styles.projectTags}>
            {project.tags.map((tag) => (
              <span key={tag} className={styles.tag}>
                {tag}
              </span>
            ))}
          </div>
        )}
      </div>
      {isActive && (
        <Button
          variant='ghost'
          size='sm'
          onClick={(e) => {
            e.stopPropagation()
            onDelete()
          }}
          title='Delete Project'
        >
          <TrashIcon />
        </Button>
      )}
    </div>
  )
}

function FileListItem({
  file,
  isActive,
  isLibrary,
  onSelect,
  onSetMain,
  onDelete
}: {
  file: { id: string; name: { value: string }; isMain: boolean }
  isActive: boolean
  isLibrary: boolean
  onSelect: () => void
  onSetMain: (e: React.MouseEvent) => void
  onDelete: (e: React.MouseEvent) => void
}) {
  return (
    <div
      className={`${styles.file} ${isActive ? styles.active : ''}`}
      onClick={onSelect}
    >
      <FileIcon />
      <span className={styles.fileName}>{file.name.value}</span>
      {!isLibrary &&
        (file.isMain ? (
          <StarFilledIcon className={styles.mainStar} />
        ) : (
          <Button
            type='button'
            variant='icon'
            className={styles.iconButton}
            onClick={onSetMain}
            title='Set as main file'
          >
            <StarIcon />
          </Button>
        ))}
      {!file.isMain && (
        <Button
          type='button'
          variant='icon'
          className={styles.iconButton}
          onClick={onDelete}
          title='Delete file'
        >
          <TrashIcon />
        </Button>
      )}
    </div>
  )
}

function DependencyFolder({
  dependency,
  isExpanded,
  onToggle,
  onSelectFile
}: {
  dependency: DependencyProject
  isExpanded: boolean
  onToggle: () => void
  onSelectFile: (file: {
    id: string
    content: string
    projectId: string
  }) => void
}) {
  return (
    <div className={styles.dependency}>
      <div className={styles.dependencyFolder} onClick={onToggle}>
        {isExpanded ? <ChevronDownIcon /> : <ChevronRightIcon />}
        <span className={styles.dependencyName}>/{dependency.name}</span>
        <span className={styles.readOnly}>(read-only)</span>
      </div>
      {isExpanded && (
        <div className={styles.dependencyFiles}>
          {dependency.files.map((file) => (
            <div
              key={file.id}
              className={`${styles.file} ${styles.dependencyFile}`}
              onClick={() => onSelectFile(file)}
            >
              <FileIcon />
              <span className={styles.fileName}>{file.name}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

// ============================================================================
// Main View Component
// ============================================================================

export function ProjectBrowserView({
  projects,
  currentProjectId,
  currentProject,
  currentFileId,
  dependencyFiles,
  expandedDeps,
  loadingDeps,
  showNewProjectDialog,
  showNewFileDialog,
  newProjectName,
  newProjectIsLibrary,
  newFileName,
  saveCurrentCode,
  loading,
  onSelectProject,
  onSelectFile,
  onSelectDependencyFile,
  onToggleDependency,
  onDeleteProject,
  onDeleteFile,
  onSetMainFile,
  onCreateProject,
  onCreateFile,
  onSaveToProject,
  onOpenNewProjectDialog,
  onCloseNewProjectDialog,
  onOpenNewFileDialog,
  onCloseNewFileDialog,
  onNewProjectNameChange,
  onNewProjectIsLibraryChange,
  onNewFileNameChange
}: ProjectBrowserViewProps) {
  return (
    <div className={styles.browser}>
      {/* Header */}
      <div className={styles.header}>
        <h3>Projects</h3>
        <Button
          variant='ghost'
          size='sm'
          onClick={onOpenNewProjectDialog}
          title='New Project'
        >
          <PlusIcon />
        </Button>
      </div>

      {/* Scratch mode indicator */}
      {!currentProjectId && (
        <div className={styles.scratchMode}>
          <div className={styles.scratchModeContent}>
            <FileIcon />
            <div>
              <div className={styles.scratchModeTitle}>Scratch Mode</div>
              <div className={styles.scratchModeHint}>
                Code not saved to any project
              </div>
            </div>
          </div>
          <Button
            variant='ghost'
            size='sm'
            onClick={onSaveToProject}
            title='Create a project to save your work'
          >
            Save to Project
          </Button>
        </div>
      )}

      {/* Project list */}
      <div className={styles.projectList}>
        {projects.map((project) => (
          <ProjectListItem
            key={project.id}
            project={project}
            isActive={project.id === currentProjectId}
            onSelect={() => onSelectProject(project.id)}
            onDelete={onDeleteProject}
          />
        ))}
      </div>

      {/* Files section */}
      {currentProject && (
        <>
          <div className={styles.header}>
            <h3>Files</h3>
            <Button
              variant='ghost'
              size='sm'
              onClick={onOpenNewFileDialog}
              title='New File'
            >
              <FilePlusIcon />
            </Button>
          </div>

          <div className={styles.fileList}>
            {currentProject.files.map((file) => (
              <FileListItem
                key={file.id}
                file={file}
                isActive={file.id === currentFileId}
                isLibrary={currentProject.isLibrary}
                onSelect={() => onSelectFile(file.id)}
                onSetMain={(e) => onSetMainFile(file.id, e)}
                onDelete={(e) => onDeleteFile(file.id, e)}
              />
            ))}

            {/* Dependencies */}
            {loadingDeps && (
              <div className={styles.dependenciesLoading}>
                Loading dependencies...
              </div>
            )}
            {!loadingDeps && dependencyFiles.length > 0 && (
              <div className={styles.dependencies}>
                <div className={styles.dependenciesHeader}>
                  <span>Dependencies</span>
                </div>
                {dependencyFiles.map((dep) => (
                  <DependencyFolder
                    key={dep.id}
                    dependency={dep}
                    isExpanded={expandedDeps.has(dep.id)}
                    onToggle={() => onToggleDependency(dep.id)}
                    onSelectFile={onSelectDependencyFile}
                  />
                ))}
              </div>
            )}
          </div>
        </>
      )}

      {/* New Project Modal */}
      <Modal
        open={showNewProjectDialog}
        onClose={onCloseNewProjectDialog}
        title='New Project'
        actions={
          <>
            <Button variant='outline' onClick={onCloseNewProjectDialog}>
              Cancel
            </Button>
            <Button
              onClick={onCreateProject}
              disabled={loading || !newProjectName.trim()}
            >
              Create
            </Button>
          </>
        }
      >
        {saveCurrentCode && (
          <div
            style={{
              padding: '0.75rem',
              marginBottom: '1rem',
              backgroundColor: 'rgba(34, 197, 94, 0.1)',
              border: '1px solid rgba(34, 197, 94, 0.3)',
              borderRadius: '0.5rem',
              fontSize: '0.875rem'
            }}
          >
            ✓ Current editor content will be saved to main.asm
          </div>
        )}
        <Input
          type='text'
          placeholder='Project name'
          value={newProjectName}
          onChange={(e) => onNewProjectNameChange(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && onCreateProject()}
        />
        <Checkbox
          label='Library/Utility project (no entry point, cannot be assembled)'
          checked={newProjectIsLibrary}
          onChange={(e) => onNewProjectIsLibraryChange(e.target.checked)}
          style={{ marginTop: '1rem' }}
        />
      </Modal>

      {/* New File Modal */}
      <Modal
        open={showNewFileDialog}
        onClose={onCloseNewFileDialog}
        title='New File'
        actions={
          <>
            <Button variant='outline' onClick={onCloseNewFileDialog}>
              Cancel
            </Button>
            <Button
              onClick={onCreateFile}
              disabled={loading || !newFileName.trim()}
            >
              Create
            </Button>
          </>
        }
      >
        <Input
          type='text'
          placeholder='File name (e.g., sprite.asm)'
          value={newFileName}
          onChange={(e) => onNewFileNameChange(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && onCreateFile()}
        />
      </Modal>
    </div>
  )
}
