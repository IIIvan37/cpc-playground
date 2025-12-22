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
  onRun: () => void
  onReset: () => void
}>

export function RunControlsView({
  isReady,
  isCompiling,
  isLibrary,
  onRun,
  onReset
}: RunControlsViewProps) {
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
}>

export function ViewModeSelectView({
  value,
  onChange
}: ViewModeSelectViewProps) {
  return (
    <Flex gap='var(--spacing-sm)' align='center'>
      <span className={styles.label}>View:</span>
      <Select value={value} onValueChange={onChange}>
        <SelectItem value='split'>Split</SelectItem>
        <SelectItem value='editor'>Editor</SelectItem>
        <SelectItem value='emulator'>Emulator</SelectItem>
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
  onReset: () => void

  // View mode controls
  viewMode: string
  onViewModeChange: (value: string) => void
}>

export function ToolbarView({
  programManager,
  outputFormat,
  onOutputFormatChange,
  isReady,
  isCompiling,
  isLibrary,
  onRun,
  onReset,
  viewMode,
  onViewModeChange
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
          onRun={onRun}
          onReset={onReset}
        />
      </Flex>

      <ViewModeSelectView value={viewMode} onChange={onViewModeChange} />
    </div>
  )
}
