import { useAtomValue } from 'jotai'
import { memo } from 'react'
import { ConsolePanel } from '@/components/console'
import { CodeEditor } from '@/components/editor'
import { EmulatorCanvas } from '@/components/emulator'
import { MarkdownPreview } from '@/components/markdown-preview'
import { FileBrowser } from '@/components/project/file-browser'
import { ResizableSidebar } from '@/components/ui/resizable-sidebar'
import { useAutoSaveFile, useProjectFromUrl, useSharedCode } from '@/hooks'
import { activeProjectAtom, isMarkdownFileAtom, viewModeAtom } from '@/store'
import { Toolbar } from '../toolbar/toolbar'
import { MainLayoutView } from './main-layout.view'

/**
 * Right panel showing emulator or markdown preview.
 * EmulatorCanvas uses a persistent canvas element that survives component
 * unmounts, so CPCEC binding is preserved during navigation.
 */
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
