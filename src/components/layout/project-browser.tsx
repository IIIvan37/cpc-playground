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
import { useAtom, useAtomValue, useSetAtom } from 'jotai'
import { useEffect, useState } from 'react'
import Button from '@/components/ui/button/button'
import Checkbox from '@/components/ui/checkbox/checkbox'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
import { useAuth } from '@/hooks'
import { codeAtom, currentProgramIdAtom } from '@/store'
import {
  createFileAtom,
  createProjectAtom,
  currentFileIdAtom,
  currentProjectAtom,
  currentProjectIdAtom,
  deleteFileAtom,
  deleteProjectAtom,
  dependencyFilesAtom,
  fetchDependencyFilesAtom,
  fetchProjectsAtom,
  projectsAtom,
  setMainFileAtom
} from '@/store/projects'
import styles from './project-browser.module.css'

export function ProjectBrowser() {
  const { user, loading: authLoading } = useAuth()
  const projects = useAtomValue(projectsAtom)
  const [currentProjectId, setCurrentProjectId] = useAtom(currentProjectIdAtom)
  const currentProject = useAtomValue(currentProjectAtom)
  const [currentFileId, setCurrentFileId] = useAtom(currentFileIdAtom)
  const [code, setCode] = useAtom(codeAtom)
  const setCurrentProgramId = useSetAtom(currentProgramIdAtom)
  const dependencyFiles = useAtomValue(dependencyFilesAtom)
  const fetchDependencyFiles = useSetAtom(fetchDependencyFilesAtom)

  const fetchProjects = useSetAtom(fetchProjectsAtom)
  const createProject = useSetAtom(createProjectAtom)
  const deleteProject = useSetAtom(deleteProjectAtom)
  const createFile = useSetAtom(createFileAtom)
  const deleteFile = useSetAtom(deleteFileAtom)
  const setMainFile = useSetAtom(setMainFileAtom)

  const [showNewProjectDialog, setShowNewProjectDialog] = useState(false)
  const [showNewFileDialog, setShowNewFileDialog] = useState(false)
  const [newProjectName, setNewProjectName] = useState('')
  const [newProjectIsLibrary, setNewProjectIsLibrary] = useState(false)
  const [newFileName, setNewFileName] = useState('')
  const [loading, setLoading] = useState(false)
  const [loadingDeps, setLoadingDeps] = useState(false)
  const [expandedDeps, setExpandedDeps] = useState<Set<string>>(new Set())
  const [saveCurrentCode, setSaveCurrentCode] = useState(false)

  // Load projects on mount
  useEffect(() => {
    if (user) {
      fetchProjects(user.id)
    }
  }, [user, fetchProjects])

  // Load dependency files when project changes or dependencies are updated
  // biome-ignore lint/correctness/useExhaustiveDependencies: We want to reload when dependencies change
  useEffect(() => {
    if (currentProjectId) {
      setLoadingDeps(true)
      fetchDependencyFiles().finally(() => setLoadingDeps(false))
    }
  }, [currentProjectId, currentProject?.dependencies, fetchDependencyFiles])

  // Don't show anything for non-authenticated users
  if (!user && !authLoading) {
    return null
  }

  const toggleDependency = (depId: string) => {
    setExpandedDeps((prev) => {
      const newSet = new Set(prev)
      if (newSet.has(depId)) {
        newSet.delete(depId)
      } else {
        newSet.add(depId)
      }
      return newSet
    })
  }

  const handleSelectDependencyFile = (file: {
    id: string
    content: string
    projectId: string
  }) => {
    // Set the code to view the file (read-only)
    setCode(file.content)
    // Clear selection since it's a dependency file
    setCurrentFileId(null)
  }

  const handleCreateProject = async () => {
    if (!newProjectName.trim() || !user) return
    setLoading(true)
    try {
      // Always create at least one initial file
      const initialFile = {
        name: newProjectIsLibrary ? 'lib.asm' : 'main.asm',
        content: saveCurrentCode ? code : '',
        isMain: !newProjectIsLibrary
      }

      await createProject({
        userId: user.id,
        name: newProjectName.trim(),
        visibility: 'private',
        isLibrary: newProjectIsLibrary,
        files: [initialFile]
      })
      setShowNewProjectDialog(false)
      setNewProjectName('')
      setNewProjectIsLibrary(false)
      setSaveCurrentCode(false)
    } catch (error) {
      console.error('Failed to create project:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleSelectProject = (projectId: string) => {
    setCurrentProjectId(projectId)
    setCurrentProgramId(null) // Deselect localStorage program
    const project = projects.find((p) => p.id === projectId)
    if (project?.files.length) {
      const mainFile = project.files.find((f) => f.isMain) || project.files[0]
      setCurrentFileId(mainFile.id)
    }
  }

  const handleSelectFile = (fileId: string) => {
    setCurrentFileId(fileId)
    setCurrentProgramId(null) // Deselect localStorage program
  }

  const handleCreateFile = async () => {
    if (!currentProjectId || !newFileName.trim() || !user) return
    setLoading(true)
    try {
      await createFile({
        projectId: currentProjectId,
        userId: user.id,
        name: newFileName.trim()
      })
      setShowNewFileDialog(false)
      setNewFileName('')
      // Le nouveau fichier est déjà sélectionné et son contenu vide chargé par createFileAtom
    } catch (error) {
      console.error('Failed to create file:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleDeleteFile = async (fileId: string, e: React.MouseEvent) => {
    e.stopPropagation()
    if (!confirm('Delete this file?') || !currentProjectId || !user) return
    try {
      await deleteFile({
        projectId: currentProjectId,
        userId: user.id,
        fileId
      })
    } catch (error) {
      console.error('Failed to delete file:', error)
    }
  }

  const handleSetMainFile = async (fileId: string, e: React.MouseEvent) => {
    e.stopPropagation()
    if (!currentProjectId || !user) return
    try {
      await setMainFile({
        projectId: currentProjectId,
        userId: user.id,
        fileId
      })
    } catch (error) {
      console.error('Failed to set main file:', error)
    }
  }

  const handleDeleteProject = async () => {
    if (!currentProjectId || !confirm('Delete this project?') || !user) return
    try {
      await deleteProject({
        projectId: currentProjectId,
        userId: user.id
      })
    } catch (error) {
      console.error('Failed to delete project:', error)
    }
  }

  const handleSaveToProject = () => {
    setSaveCurrentCode(true)
    setShowNewProjectDialog(true)
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
            onClick={handleSaveToProject}
            title='Create a project to save your work'
          >
            Save to Project
          </Button>
        </div>
      )}

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
                <span className={styles.fileName}>{file.name.value}</span>
                {!currentProject.isLibrary &&
                  (file.isMain ? (
                    <StarFilledIcon className={styles.mainStar} />
                  ) : (
                    <Button
                      type='button'
                      variant='icon'
                      className={styles.iconButton}
                      onClick={(e) => handleSetMainFile(file.id, e)}
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
                    onClick={(e) => handleDeleteFile(file.id, e)}
                    title='Delete file'
                  >
                    <TrashIcon />
                  </Button>
                )}
              </div>
            ))}

            {/* Dependencies as subfolders */}
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
                  <div key={dep.id} className={styles.dependency}>
                    <div
                      className={styles.dependencyFolder}
                      onClick={() => toggleDependency(dep.id)}
                    >
                      {expandedDeps.has(dep.id) ? (
                        <ChevronDownIcon />
                      ) : (
                        <ChevronRightIcon />
                      )}
                      <span className={styles.dependencyName}>/{dep.name}</span>
                      <span className={styles.readOnly}>(read-only)</span>
                    </div>
                    {expandedDeps.has(dep.id) && (
                      <div className={styles.dependencyFiles}>
                        {dep.files.map((file: any) => (
                          <div
                            key={file.id}
                            className={`${styles.file} ${styles.dependencyFile}`}
                            onClick={() => handleSelectDependencyFile(file)}
                          >
                            <FileIcon />
                            <span className={styles.fileName}>{file.name}</span>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>
        </>
      )}

      {/* New Project Dialog */}
      <Modal
        open={showNewProjectDialog}
        onClose={() => {
          setShowNewProjectDialog(false)
          setSaveCurrentCode(false)
        }}
        title='New Project'
        actions={
          <>
            <Button
              variant='outline'
              onClick={() => {
                setShowNewProjectDialog(false)
                setSaveCurrentCode(false)
              }}
            >
              Cancel
            </Button>
            <Button
              onClick={handleCreateProject}
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
          onChange={(e) => setNewProjectName(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && handleCreateProject()}
        />
        <Checkbox
          label='Library/Utility project (no entry point, cannot be assembled)'
          checked={newProjectIsLibrary}
          onChange={(e) => setNewProjectIsLibrary(e.target.checked)}
          style={{ marginTop: '1rem' }}
        />
      </Modal>

      {/* New File Dialog */}
      <Modal
        open={showNewFileDialog}
        onClose={() => setShowNewFileDialog(false)}
        title='New File'
        actions={
          <>
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
          </>
        }
      >
        <Input
          type='text'
          placeholder='File name (e.g., sprite.asm)'
          value={newFileName}
          onChange={(e) => setNewFileName(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && handleCreateFile()}
        />
      </Modal>
    </div>
  )
}
