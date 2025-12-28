import { useAtom, useAtomValue } from 'jotai'
import { useState } from 'react'
import { ProgramManager } from '@/components/program/program-manager'
import {
  useActiveProject,
  useAssembler,
  useAuth,
  useCurrentFile,
  useEmulator,
  useExport,
  useGetProjectWithDependencies,
  useHandleCreateProject,
  useToastActions
} from '@/hooks'
import { createLogger } from '@/lib/logger'

const logger = createLogger('Toolbar')

import {
  codeAtom,
  compilationStatusAtom,
  currentProgramIdAtom,
  type OutputFormat,
  outputFormatAtom,
  type ViewMode,
  viewModeAtom
} from '@/store'
import { ToolbarView } from './toolbar.view'

/**
 * Container component for toolbar
 * Handles business logic and delegates rendering to ToolbarView
 */
export function Toolbar() {
  const code = useAtomValue(codeAtom)
  const compilationStatus = useAtomValue(compilationStatusAtom)
  const currentProgramId = useAtomValue(currentProgramIdAtom)
  const [viewMode, setViewMode] = useAtom(viewModeAtom)
  const [outputFormat, setOutputFormat] = useAtom(outputFormatAtom)

  // Project creation modal state
  const [showCreateProjectDialog, setShowCreateProjectDialog] = useState(false)
  const [newProjectName, setNewProjectName] = useState('')
  const [newProjectIsLibrary, setNewProjectIsLibrary] = useState(false)

  const { activeProject: currentProject } = useActiveProject()
  const { user } = useAuth()
  const currentFile = useCurrentFile()
  const { getProjectWithDependencies } = useGetProjectWithDependencies()
  const { compile } = useAssembler()
  const { isReady, loadSna, loadDsk, injectDsk, isInjectAvailable, reset } =
    useEmulator()
  const { exportBinary, exportProject, hasCompiledOutput, exportingProject } =
    useExport()
  const toast = useToastActions()
  const { handleCreate: createProject, loading: creating } =
    useHandleCreateProject()

  const handleExportBinary = () => {
    const success = exportBinary(currentProject?.name?.value)
    if (success) {
      toast.success(
        'Binary exported',
        `${outputFormat.toUpperCase()} file downloaded`
      )
    } else {
      toast.error('No compiled output', 'Compile your project first')
    }
  }

  const handleExportProject = async () => {
    if (!currentProject) return
    const success = await exportProject(currentProject, user?.id)
    if (success) {
      toast.success(
        'Project exported',
        'Project files downloaded as ZIP archive'
      )
    } else {
      toast.error('Export failed', 'Failed to export project')
    }
  }

  const handleCompileAndRun = async () => {
    // Collect files from the current project and its dependencies
    let additionalFiles:
      | { name: string; content: string; projectName?: string }[]
      | undefined

    if (currentProject && currentFile) {
      try {
        // Get all files including dependencies
        const result = await getProjectWithDependencies({
          projectId: currentProject.id,
          userId: user?.id
        })

        // Separate current project files from dependency files
        additionalFiles = result.files
          .filter((f) => f.id !== currentFile.id)
          .map((f) => ({
            name: f.name,
            content: f.content,
            // Only add projectName for dependency files (not current project)
            ...(f.projectId !== currentProject.id && {
              projectName: f.projectName
            })
          }))
      } catch (error) {
        logger.error('Error fetching dependencies:', error)
        // Fallback to just current project files
        additionalFiles = (currentProject.files ?? [])
          .filter((f) => f.id !== currentFile.id)
          .map((f) => ({
            name: f.name.value,
            content: f.content.value
          }))
      }
    }

    const binary = await compile(code, outputFormat, additionalFiles)
    if (binary && isReady) {
      if (outputFormat === 'dsk') {
        loadDsk(binary)
      } else {
        loadSna(binary)
      }
    }
  }

  const handleCompileAndInject = async () => {
    // Only available for DSK format
    if (outputFormat !== 'dsk') {
      return
    }

    // Collect files from the current project and its dependencies
    let additionalFiles:
      | { name: string; content: string; projectName?: string }[]
      | undefined

    if (currentProject && currentFile) {
      try {
        // Get all files including dependencies
        const result = await getProjectWithDependencies({
          projectId: currentProject.id,
          userId: user?.id
        })

        // Separate current project files from dependency files
        additionalFiles = result.files
          .filter((f) => f.id !== currentFile.id)
          .map((f) => ({
            name: f.name,
            content: f.content,
            // Only add projectName for dependency files (not current project)
            ...(f.projectId !== currentProject.id && {
              projectName: f.projectName
            })
          }))
      } catch (error) {
        logger.error('Error fetching dependencies:', error)
        // Fallback to just current project files
        additionalFiles = (currentProject.files ?? [])
          .filter((f) => f.id !== currentFile.id)
          .map((f) => ({
            name: f.name.value,
            content: f.content.value
          }))
      }
    }

    const binary = await compile(code, outputFormat, additionalFiles)
    if (binary && isReady) {
      injectDsk(binary)
      toast.success(
        'DSK injected successfully',
        'The disk is ready to be accessed in the emulator'
      )
    }
  }

  const isCompiling = compilationStatus === 'compiling'

  // Project creation handlers
  const handleCreateProjectFromCode = () => {
    if (!user) {
      toast.error(
        'Authentication required',
        'You must be logged in to create projects'
      )
      return
    }
    setShowCreateProjectDialog(true)
    // Pre-fill project name based on current program or use default
    if (currentProgramId) {
      // If we have a current program, use its name as base
      const programName = `Project from ${currentProgramId}`
      setNewProjectName(programName)
    } else {
      setNewProjectName('New Project')
    }
  }

  const handleCreateProjectSubmit = async () => {
    if (!newProjectName.trim() || !user) return

    const result = await createProject({
      userId: user.id,
      name: newProjectName.trim(),
      isLibrary: newProjectIsLibrary,
      initialCode: code
    })

    if (result.success) {
      setShowCreateProjectDialog(false)
      setNewProjectName('')
      setNewProjectIsLibrary(false)
      toast.success(
        'Project created',
        'Your new project has been created successfully'
      )
    }
  }

  const handleCloseCreateProjectDialog = () => {
    setShowCreateProjectDialog(false)
    setNewProjectName('')
    setNewProjectIsLibrary(false)
  }

  return (
    <ToolbarView
      programManager={<ProgramManager />}
      outputFormat={outputFormat}
      onOutputFormatChange={(v) => setOutputFormat(v as OutputFormat)}
      isReady={isReady}
      isCompiling={isCompiling}
      isLibrary={currentProject?.isLibrary ?? false}
      onRun={handleCompileAndRun}
      onInject={handleCompileAndInject}
      isInjectAvailable={isInjectAvailable()}
      onReset={reset}
      onExportBinary={handleExportBinary}
      hasCompiledOutput={hasCompiledOutput}
      viewMode={viewMode}
      onViewModeChange={(v) => setViewMode(v as ViewMode)}
      isAuthenticated={!!user}
      hasActiveProject={!!currentProject}
      onExportProject={handleExportProject}
      exportingProject={exportingProject}
      onCreateProjectFromCode={handleCreateProjectFromCode}
      showCreateProjectDialog={showCreateProjectDialog}
      newProjectName={newProjectName}
      newProjectIsLibrary={newProjectIsLibrary}
      creatingProject={creating}
      onNewProjectNameChange={setNewProjectName}
      onNewProjectIsLibraryChange={setNewProjectIsLibrary}
      onCreateProjectSubmit={handleCreateProjectSubmit}
      onCloseCreateProjectDialog={handleCloseCreateProjectDialog}
    />
  )
}
