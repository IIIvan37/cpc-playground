import { PlayIcon, ResetIcon } from '@radix-ui/react-icons'
import { useAtom, useAtomValue, useSetAtom } from 'jotai'
import { ProgramManager } from '@/components/program/program-manager'
import Button from '@/components/ui/button/button'
import Flex from '@/components/ui/flex/flex'
import { Select, SelectItem } from '@/components/ui/select/select'
import { useEmulator, useRasm } from '@/hooks'
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
import styles from './toolbar.module.css'

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
  const { compile } = useRasm()
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
    <div className={styles.toolbar}>
      <Flex gap='var(--spacing-md)' align='center'>
        <ProgramManager />

        <div className={styles.separator} />

        <Flex gap='var(--spacing-sm)' align='center'>
          <span className={styles.label}>Output:</span>
          <Select
            value={outputFormat}
            onValueChange={(v) => setOutputFormat(v as OutputFormat)}
          >
            <SelectItem value='sna'>SNA</SelectItem>
            <SelectItem value='dsk'>DSK</SelectItem>
          </Select>
        </Flex>

        <Button
          onClick={handleCompileAndRun}
          disabled={!isReady || isCompiling || currentProject?.isLibrary}
          title={
            currentProject?.isLibrary
              ? 'Library projects cannot be assembled or run'
              : undefined
          }
        >
          <PlayIcon />
          <span>{isCompiling ? 'Compiling...' : 'Run'}</span>
        </Button>
        <Button variant='secondary' onClick={reset} disabled={!isReady}>
          <ResetIcon />
          <span>Reset</span>
        </Button>
      </Flex>

      <Flex gap='var(--spacing-sm)' align='center'>
        <span className={styles.label}>View:</span>
        <Select
          value={viewMode}
          onValueChange={(v) => setViewMode(v as ViewMode)}
        >
          <SelectItem value='split'>Split</SelectItem>
          <SelectItem value='editor'>Editor</SelectItem>
          <SelectItem value='emulator'>Emulator</SelectItem>
        </Select>
      </Flex>
    </div>
  )
}
