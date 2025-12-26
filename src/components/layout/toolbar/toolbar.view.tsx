import { PlayIcon, ResetIcon } from '@radix-ui/react-icons'
import type { ReactNode } from 'react'
import Button from '@/components/ui/button/button'
import Flex from '@/components/ui/flex/flex'
import { Select, SelectItem } from '@/components/ui/select/select'
import styles from './toolbar.module.css'

// --- OutputFormatSelectView ---
type OutputFormatSelectViewProps = Readonly<{
  value: string
  onChange: (value: string) => void
}>

export function OutputFormatSelectView({
  value,
  onChange
}: OutputFormatSelectViewProps) {
  return (
    <Flex gap='var(--spacing-sm)' align='center'>
      <span className={styles.label}>Output:</span>
      <Select value={value} onValueChange={onChange}>
        <SelectItem value='sna'>SNA</SelectItem>
        <SelectItem value='dsk'>DSK</SelectItem>
      </Select>
    </Flex>
  )
}

// --- RunControlsView ---
type RunControlsViewProps = Readonly<{
  isReady: boolean
  isCompiling: boolean
  isLibrary: boolean
  outputFormat: string
  onRun: () => void
  onInject: () => void
  isInjectAvailable: boolean
  onReset: () => void
}>

export function RunControlsView({
  isReady,
  isCompiling,
  isLibrary,
  outputFormat,
  onRun,
  onInject,
  isInjectAvailable,
  onReset
}: RunControlsViewProps) {
  const canInject = outputFormat === 'dsk' && isInjectAvailable

  return (
    <>
      <Button
        onClick={onRun}
        disabled={!isReady || isCompiling || isLibrary}
        title={
          isLibrary ? 'Library projects cannot be assembled or run' : undefined
        }
      >
        <PlayIcon />
        <span>{isCompiling ? 'Compiling...' : 'Run'}</span>
      </Button>
      {canInject && (
        <Button
          variant='secondary'
          onClick={onInject}
          disabled={!isReady || isCompiling || isLibrary}
          title='Inject DSK without running it'
        >
          <span>Inject</span>
        </Button>
      )}
      <Button variant='secondary' onClick={onReset} disabled={!isReady}>
        <ResetIcon />
        <span>Reset</span>
      </Button>
    </>
  )
}

// --- ViewModeSelectView ---
type ViewModeSelectViewProps = Readonly<{
  value: string
  onChange: (value: string) => void
  isMarkdownFile?: boolean
}>

export function ViewModeSelectView({
  value,
  onChange,
  isMarkdownFile = false
}: ViewModeSelectViewProps) {
  return (
    <Flex gap='var(--spacing-sm)' align='center'>
      <span className={styles.label}>View:</span>
      <Select value={value} onValueChange={onChange}>
        <SelectItem value='split'>Split</SelectItem>
        <SelectItem value='editor'>Editor</SelectItem>
        {!isMarkdownFile && <SelectItem value='emulator'>Emulator</SelectItem>}
        {isMarkdownFile && <SelectItem value='markdown'>Markdown</SelectItem>}
      </Select>
    </Flex>
  )
}

// --- ToolbarView (main composition) ---
export type ToolbarViewProps = Readonly<{
  // Program manager slot
  programManager: ReactNode

  // Output controls
  outputFormat: string
  onOutputFormatChange: (value: string) => void

  // Run controls
  isReady: boolean
  isCompiling: boolean
  isLibrary: boolean
  onRun: () => void
  onInject: () => void
  isInjectAvailable: boolean
  onReset: () => void

  // View mode controls
  viewMode: string
  onViewModeChange: (value: string) => void
  isMarkdownFile?: boolean
}>

export function ToolbarView({
  programManager,
  outputFormat,
  onOutputFormatChange,
  isReady,
  isCompiling,
  isLibrary,
  onRun,
  onInject,
  isInjectAvailable,
  onReset,
  viewMode,
  onViewModeChange,
  isMarkdownFile = false
}: ToolbarViewProps) {
  return (
    <div className={styles.toolbar}>
      <Flex gap='var(--spacing-md)' align='center'>
        {programManager}

        <div className={styles.separator} />

        <OutputFormatSelectView
          value={outputFormat}
          onChange={onOutputFormatChange}
        />

        <RunControlsView
          isReady={isReady}
          isCompiling={isCompiling}
          isLibrary={isLibrary}
          outputFormat={outputFormat}
          onRun={onRun}
          onInject={onInject}
          isInjectAvailable={isInjectAvailable}
          onReset={onReset}
        />
      </Flex>

      <ViewModeSelectView
        value={viewMode}
        onChange={onViewModeChange}
        isMarkdownFile={isMarkdownFile}
      />
    </div>
  )
}
