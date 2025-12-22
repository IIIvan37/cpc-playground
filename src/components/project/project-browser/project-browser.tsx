import { useAtom, useAtomValue, useSetAtom } from 'jotai'
import { useEffect, useState } from 'react'
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
import { ProjectBrowserView } from './project-browser.view'

/**
 * Container component for the project browser
 * Handles business logic and delegates rendering to ProjectBrowserView
 */
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

  // Load dependency files when project changes
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

  const handleToggleDependency = (depId: string) => {
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
    setCode(file.content)
    setCurrentFileId(null)
  }

  const handleCreateProject = async () => {
    if (!newProjectName.trim() || !user) return
    setLoading(true)
    try {
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
    setCurrentProgramId(null)
    const project = projects.find((p) => p.id === projectId)
    if (project?.files.length) {
      const mainFile = project.files.find((f) => f.isMain) || project.files[0]
      setCurrentFileId(mainFile.id)
    }
  }

  const handleSelectFile = (fileId: string) => {
    setCurrentFileId(fileId)
    setCurrentProgramId(null)
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

  const handleCloseNewProjectDialog = () => {
    setShowNewProjectDialog(false)
    setSaveCurrentCode(false)
  }

  return (
    <ProjectBrowserView
      projects={projects}
      currentProjectId={currentProjectId}
      currentProject={currentProject}
      currentFileId={currentFileId}
      dependencyFiles={dependencyFiles}
      expandedDeps={expandedDeps}
      loadingDeps={loadingDeps}
      showNewProjectDialog={showNewProjectDialog}
      showNewFileDialog={showNewFileDialog}
      newProjectName={newProjectName}
      newProjectIsLibrary={newProjectIsLibrary}
      newFileName={newFileName}
      saveCurrentCode={saveCurrentCode}
      loading={loading}
      onSelectProject={handleSelectProject}
      onSelectFile={handleSelectFile}
      onSelectDependencyFile={handleSelectDependencyFile}
      onToggleDependency={handleToggleDependency}
      onDeleteProject={handleDeleteProject}
      onDeleteFile={handleDeleteFile}
      onSetMainFile={handleSetMainFile}
      onCreateProject={handleCreateProject}
      onCreateFile={handleCreateFile}
      onSaveToProject={handleSaveToProject}
      onOpenNewProjectDialog={() => setShowNewProjectDialog(true)}
      onCloseNewProjectDialog={handleCloseNewProjectDialog}
      onOpenNewFileDialog={() => setShowNewFileDialog(true)}
      onCloseNewFileDialog={() => setShowNewFileDialog(false)}
      onNewProjectNameChange={setNewProjectName}
      onNewProjectIsLibraryChange={setNewProjectIsLibrary}
      onNewFileNameChange={setNewFileName}
    />
  )
}
