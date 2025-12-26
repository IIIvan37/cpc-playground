import { PlayIcon, ResetIcon } from '@radix-ui/react-icons'
import type { ReactNode } from 'react'
import Button from '@/components/ui/button/button'
import { Checkbox } from '@/components/ui/checkbox'
import Flex from '@/components/ui/flex/flex'
import { Input } from '@/components/ui/input'
import { Modal } from '@/components/ui/modal'
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
        <SelectItem value='markdown'>Markdown</SelectItem>
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

  // Authentication and project state
  isAuthenticated: boolean
  hasActiveProject: boolean

  // Project creation
  onCreateProjectFromCode: () => void
  showCreateProjectDialog: boolean
  newProjectName: string
  newProjectIsLibrary: boolean
  creatingProject: boolean
  onNewProjectNameChange: (name: string) => void
  onNewProjectIsLibraryChange: (isLibrary: boolean) => void
  onCreateProjectSubmit: () => void
  onCloseCreateProjectDialog: () => void
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
  isAuthenticated,
  hasActiveProject,
  onCreateProjectFromCode,
  showCreateProjectDialog,
  newProjectName,
  newProjectIsLibrary,
  creatingProject,
  onNewProjectNameChange,
  onNewProjectIsLibraryChange,
  onCreateProjectSubmit,
  onCloseCreateProjectDialog
}: ToolbarViewProps) {
  return (
    <div className={styles.toolbar}>
      <Flex gap='var(--spacing-md)' align='center'>
        {programManager}

        {isAuthenticated && !hasActiveProject && (
          <Button
            variant='outline'
            size='sm'
            onClick={onCreateProjectFromCode}
            title='Create a new project from current code'
          >
            New Project
          </Button>
        )}

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

      <ViewModeSelectView value={viewMode} onChange={onViewModeChange} />

      <Modal
        open={showCreateProjectDialog}
        title='Create New Project'
        onClose={onCloseCreateProjectDialog}
      >
        <div style={{ padding: '1rem' }}>
          <Input
            label='Project Name'
            value={newProjectName}
            onChange={(e) => onNewProjectNameChange(e.target.value)}
            placeholder='My Awesome Project'
            autoFocus
          />
          <Checkbox
            label='Library Project'
            checked={newProjectIsLibrary}
            onChange={(e) => onNewProjectIsLibraryChange(e.target.checked)}
          />
          <div
            style={{
              marginTop: '1rem',
              display: 'flex',
              gap: '0.5rem',
              justifyContent: 'flex-end'
            }}
          >
            <Button variant='ghost' onClick={onCloseCreateProjectDialog}>
              Cancel
            </Button>
            <Button
              onClick={onCreateProjectSubmit}
              disabled={!newProjectName.trim() || creatingProject}
            >
              {creatingProject ? 'Creating...' : 'Create Project'}
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  )
}
