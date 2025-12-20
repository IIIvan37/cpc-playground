import {
  FileIcon,
  FilePlusIcon,
  PlusIcon,
  StarFilledIcon,
  StarIcon,
  TrashIcon
} from '@radix-ui/react-icons'
import { useAtom, useAtomValue, useSetAtom } from 'jotai'
import { useEffect, useState } from 'react'
import Button from '@/components/ui/button/button'
import { useAuth } from '@/hooks'
import { codeAtom } from '@/store/editor'
import {
  createFileAtom,
  createProjectAtom,
  currentFileAtom,
  currentFileIdAtom,
  currentProjectAtom,
  currentProjectIdAtom,
  deleteFileAtom,
  deleteProjectAtom,
  fetchProjectsAtom,
  projectsAtom,
  setMainFileAtom,
  updateFileAtom
} from '@/store/projects-v2'
import styles from './project-browser.module.css'

export function ProjectBrowser() {
  const { user, loading: authLoading } = useAuth()
  const projects = useAtomValue(projectsAtom)
  const [currentProjectId, setCurrentProjectId] = useAtom(currentProjectIdAtom)
  const currentProject = useAtomValue(currentProjectAtom)
  const [currentFileId, setCurrentFileId] = useAtom(currentFileIdAtom)
  const _currentFile = useAtomValue(currentFileAtom)
  const [_code, setCode] = useAtom(codeAtom)

  const fetchProjects = useSetAtom(fetchProjectsAtom)
  const createProject = useSetAtom(createProjectAtom)
  const deleteProject = useSetAtom(deleteProjectAtom)
  const createFile = useSetAtom(createFileAtom)
  const _updateFile = useSetAtom(updateFileAtom)
  const deleteFile = useSetAtom(deleteFileAtom)
  const setMainFile = useSetAtom(setMainFileAtom)

  // Don't show anything for non-authenticated users
  if (!user && !authLoading) {
    return null
  }

  const [showNewProjectDialog, setShowNewProjectDialog] = useState(false)
  const [showNewFileDialog, setShowNewFileDialog] = useState(false)
  const [newProjectName, setNewProjectName] = useState('')
  const [newFileName, setNewFileName] = useState('')
  const [loading, setLoading] = useState(false)

  // Load projects on mount
  useEffect(() => {
    if (user) {
      fetchProjects()
    }
  }, [user, fetchProjects])

  const handleCreateProject = async () => {
    if (!newProjectName.trim()) return
    setLoading(true)
    try {
      await createProject({ name: newProjectName.trim() })
      setShowNewProjectDialog(false)
      setNewProjectName('')
    } catch (error) {
      console.error('Failed to create project:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleSelectProject = (projectId: string) => {
    setCurrentProjectId(projectId)
    const project = projects.find((p) => p.id === projectId)
    if (project?.files.length) {
      const mainFile = project.files.find((f) => f.isMain) || project.files[0]
      setCurrentFileId(mainFile.id)
      setCode(mainFile.content)
    }
  }

  const handleSelectFile = (fileId: string) => {
    setCurrentFileId(fileId)
    const file = currentProject?.files.find((f) => f.id === fileId)
    if (file) {
      setCode(file.content)
    }
  }

  const handleCreateFile = async () => {
    if (!currentProjectId || !newFileName.trim()) return
    setLoading(true)
    try {
      const file = await createFile({
        projectId: currentProjectId,
        name: newFileName.trim()
      })
      setShowNewFileDialog(false)
      setNewFileName('')
      setCode(file.content)
    } catch (error) {
      console.error('Failed to create file:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleDeleteFile = async (fileId: string, e: React.MouseEvent) => {
    e.stopPropagation()
    if (!confirm('Delete this file?')) return
    try {
      await deleteFile(fileId)
    } catch (error) {
      console.error('Failed to delete file:', error)
    }
  }

  const handleSetMainFile = async (fileId: string, e: React.MouseEvent) => {
    e.stopPropagation()
    try {
      await setMainFile(fileId)
    } catch (error) {
      console.error('Failed to set main file:', error)
    }
  }

  const handleDeleteProject = async () => {
    if (!currentProjectId || !confirm('Delete this project?')) return
    try {
      await deleteProject(currentProjectId)
    } catch (error) {
      console.error('Failed to delete project:', error)
    }
  }

  // Show cloud projects only for authenticated users
  // Non-authenticated users still have the old localStorage system (ProgramManager)

  return (
    <div className={styles.browser}>
      <div className={styles.header}>
        <h3>Projects</h3>
        <Button
          variant='ghost'
          size='sm'
          onClick={() => setShowNewProjectDialog(true)}
          title='New Project'
        >
          <PlusIcon />
        </Button>
      </div>

      <div className={styles.projectList}>
        {projects.map((project) => (
          <div
            key={project.id}
            className={`${styles.project} ${
              project.id === currentProjectId ? styles.active : ''
            }`}
            onClick={() => handleSelectProject(project.id)}
            role='button'
            tabIndex={0}
            onKeyDown={(e) => {
              if (e.key === 'Enter' || e.key === ' ') {
                handleSelectProject(project.id)
              }
            }}
          >
            <div className={styles.projectName}>{project.name}</div>
            {project.id === currentProjectId && (
              <Button
                variant='ghost'
                size='sm'
                onClick={(e) => {
                  e.stopPropagation()
                  handleDeleteProject()
                }}
                title='Delete Project'
              >
                <TrashIcon />
              </Button>
            )}
          </div>
        ))}
      </div>

      {currentProject && (
        <>
          <div className={styles.header}>
            <h3>Files</h3>
            <Button
              variant='ghost'
              size='sm'
              onClick={() => setShowNewFileDialog(true)}
              title='New File'
            >
              <FilePlusIcon />
            </Button>
          </div>

          <div className={styles.fileList}>
            {currentProject.files.map((file) => (
              <div
                key={file.id}
                className={`${styles.file} ${
                  file.id === currentFileId ? styles.active : ''
                }`}
                onClick={() => handleSelectFile(file.id)}
              >
                <FileIcon />
                <span className={styles.fileName}>{file.name}</span>
                {file.isMain ? (
                  <StarFilledIcon
                    className={styles.mainStar}
                    title='Main file'
                  />
                ) : (
                  <button
                    type='button'
                    className={styles.iconButton}
                    onClick={(e) => handleSetMainFile(file.id, e)}
                    title='Set as main file'
                  >
                    <StarIcon />
                  </button>
                )}
                {!file.isMain && (
                  <button
                    type='button'
                    className={styles.iconButton}
                    onClick={(e) => handleDeleteFile(file.id, e)}
                    title='Delete file'
                  >
                    <TrashIcon />
                  </button>
                )}
              </div>
            ))}
          </div>
        </>
      )}

      {/* New Project Dialog */}
      {showNewProjectDialog && (
        <div
          className={styles.overlay}
          onClick={() => setShowNewProjectDialog(false)}
        >
          <div className={styles.dialog} onClick={(e) => e.stopPropagation()}>
            <h3>New Project</h3>
            <input
              type='text'
              placeholder='Project name'
              value={newProjectName}
              onChange={(e) => setNewProjectName(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleCreateProject()}
            />
            <div className={styles.dialogActions}>
              <Button
                variant='outline'
                onClick={() => setShowNewProjectDialog(false)}
              >
                Cancel
              </Button>
              <Button
                onClick={handleCreateProject}
                disabled={loading || !newProjectName.trim()}
              >
                Create
              </Button>
            </div>
          </div>
        </div>
      )}

      {/* New File Dialog */}
      {showNewFileDialog && (
        <div
          className={styles.overlay}
          onClick={() => setShowNewFileDialog(false)}
        >
          <div className={styles.dialog} onClick={(e) => e.stopPropagation()}>
            <h3>New File</h3>
            <input
              type='text'
              placeholder='File name (e.g., sprite.asm)'
              value={newFileName}
              onChange={(e) => setNewFileName(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleCreateFile()}
            />
            <div className={styles.dialogActions}>
              <Button
                variant='outline'
                onClick={() => setShowNewFileDialog(false)}
              >
                Cancel
              </Button>
              <Button
                onClick={handleCreateFile}
                disabled={loading || !newFileName.trim()}
              >
                Create
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
