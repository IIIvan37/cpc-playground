import { PlayIcon, ResetIcon } from '@radix-ui/react-icons'
import { useAtom, useAtomValue } from 'jotai'
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
import { currentFileAtom, currentProjectAtom } from '@/store/projects-v2'
import { ProgramManager } from './program-manager'
import styles from './toolbar.module.css'

export function Toolbar() {
  const code = useAtomValue(codeAtom)
  const compilationStatus = useAtomValue(compilationStatusAtom)
  const [viewMode, setViewMode] = useAtom(viewModeAtom)
  const [outputFormat, setOutputFormat] = useAtom(outputFormatAtom)
  const currentProject = useAtomValue(currentProjectAtom)
  const currentFile = useAtomValue(currentFileAtom)
  const { compile } = useRasm()
  const { isReady, loadSna, loadDsk, reset } = useEmulator()

  const handleCompileAndRun = async () => {
    // Collect additional files from the current project (excluding the current file being compiled)
    let additionalFiles: { name: string; content: string }[] | undefined

    if (currentProject && currentFile) {
      additionalFiles = currentProject.files
        .filter((f) => f.id !== currentFile.id) // Exclude the file being compiled
        .map((f) => ({
          name: f.name,
          content: f.content
        }))
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
          disabled={!isReady || isCompiling}
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
