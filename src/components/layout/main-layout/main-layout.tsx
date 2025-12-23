import { useAtomValue } from 'jotai'
import { memo } from 'react'
import { ConsolePanel } from '@/components/console'
import { CodeEditor } from '@/components/editor'
import { EmulatorCanvas } from '@/components/emulator'
import { MarkdownPreview } from '@/components/markdown-preview'
import { FileBrowser } from '@/components/project/file-browser'
import { ResizableSidebar } from '@/components/ui/resizable-sidebar'
import { useProjectFromUrl } from '@/hooks'
import { useAutoSaveFile } from '@/hooks/use-auto-save-file'
import { useSharedCode } from '@/hooks/use-shared-code'
import { activeProjectAtom, isMarkdownFileAtom, viewModeAtom } from '@/store'
import { Toolbar } from '../toolbar/toolbar'
import { MainLayoutView } from './main-layout.view'

// Keep both components mounted to avoid unmounting EmulatorCanvas
// which causes input issues with the editor
const RightPanel = memo(function RightPanel({
  isMarkdownFile
}: {
  isMarkdownFile: boolean
}) {
  return (
    <>
      <div style={{ display: isMarkdownFile ? 'none' : 'contents' }}>
        <EmulatorCanvas />
      </div>
      {isMarkdownFile && <MarkdownPreview />}
    </>
  )
})

// Memoized editor that never re-renders
const MemoizedEditor = memo(function MemoizedEditor() {
  return <CodeEditor />
})

/**
 * Container component for the main IDE layout
 * Handles URL loading, auto-save, and view mode state
 */
export function MainLayout() {
  const viewMode = useAtomValue(viewModeAtom)
  const activeProject = useAtomValue(activeProjectAtom)
  const isMarkdownFile = useAtomValue(isMarkdownFileAtom)

  // Load shared code from URL if present
  useSharedCode()

  // Load project from URL if present (handles public projects)
  useProjectFromUrl()

  // Auto-save file content (only for authenticated users with cloud projects)
  useAutoSaveFile()

  return (
    <MainLayoutView
      viewMode={viewMode}
      showSidebar={!!activeProject}
      toolbar={<Toolbar />}
      sidebar={
        <ResizableSidebar storageKey='file-browser-width'>
          <FileBrowser />
        </ResizableSidebar>
      }
      editor={<MemoizedEditor />}
      emulator={<RightPanel isMarkdownFile={isMarkdownFile} />}
      console={<ConsolePanel />}
    />
  )
}
