import { useAtom, useAtomValue, useSetAtom } from 'jotai'
import { ProgramManager } from '@/components/program/program-manager'
import { useAssembler, useEmulator } from '@/hooks'
import {
  codeAtom,
  compilationStatusAtom,
  type OutputFormat,
  outputFormatAtom,
  type ViewMode,
  viewModeAtom
} from '@/store'
import {
  currentFileAtom,
  currentProjectAtom,
  fetchProjectWithDependenciesAtom
} from '@/store/projects'
import { ToolbarView } from './toolbar.view'

/**
 * Container component for toolbar
 * Handles business logic and delegates rendering to ToolbarView
 */
export function Toolbar() {
  const code = useAtomValue(codeAtom)
  const compilationStatus = useAtomValue(compilationStatusAtom)
  const [viewMode, setViewMode] = useAtom(viewModeAtom)
  const [outputFormat, setOutputFormat] = useAtom(outputFormatAtom)
  const currentProject = useAtomValue(currentProjectAtom)
  const currentFile = useAtomValue(currentFileAtom)
  const fetchProjectWithDependencies = useSetAtom(
    fetchProjectWithDependenciesAtom
  )
  const { compile } = useAssembler()
  const { isReady, loadSna, loadDsk, reset } = useEmulator()

  const handleCompileAndRun = async () => {
    // Collect files from the current project and its dependencies
    let additionalFiles:
      | { name: string; content: string; projectName?: string }[]
      | undefined

    if (currentProject && currentFile) {
      try {
        // Get all files including dependencies
        const allFiles = await fetchProjectWithDependencies({
          projectId: currentProject.id,
          userId: currentProject.userId
        })

        // Separate current project files from dependency files
        additionalFiles = allFiles
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
        console.error('Error fetching dependencies:', error)
        // Fallback to just current project files
        additionalFiles = currentProject.files
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

  const isCompiling = compilationStatus === 'compiling'

  return (
    <ToolbarView
      programManager={<ProgramManager />}
      outputFormat={outputFormat}
      onOutputFormatChange={(v) => setOutputFormat(v as OutputFormat)}
      isReady={isReady}
      isCompiling={isCompiling}
      isLibrary={currentProject?.isLibrary ?? false}
      onRun={handleCompileAndRun}
      onReset={reset}
      viewMode={viewMode}
      onViewModeChange={(v) => setViewMode(v as ViewMode)}
    />
  )
}
