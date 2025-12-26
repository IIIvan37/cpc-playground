import { useAtomValue, useSetAtom } from 'jotai'
import { memo, useEffect } from 'react'
import { ConsolePanel } from '@/components/console'
import { CodeEditor } from '@/components/editor'
import { EmulatorCanvas } from '@/components/emulator'
import { MarkdownPreview } from '@/components/markdown-preview'
import { FileBrowser } from '@/components/project/file-browser'
import { ResizableSidebar } from '@/components/ui/resizable-sidebar'
import {
  useActiveProject,
  useAutoSaveFile,
  useIsMarkdownFile,
  useProjectFromUrl,
  useSharedCode
} from '@/hooks'
import { viewModeAtom } from '@/store'
import { Toolbar } from '../toolbar/toolbar'
import { MainLayoutView } from './main-layout.view'

/**
 * Right panel showing emulator or markdown preview.
 * EmulatorCanvas uses a persistent canvas element that survives component
 * unmounts, so CPCEC binding is preserved during navigation.
 */
const RightPanel = memo(function RightPanel({
  isMarkdownFile,
  viewMode
}: {
  isMarkdownFile: boolean
  viewMode: 'editor' | 'emulator' | 'split' | 'markdown'
}) {
  const showMarkdown = isMarkdownFile && viewMode !== 'markdown'

  return (
    <>
      <div style={{ display: showMarkdown ? 'none' : 'contents' }}>
        <EmulatorCanvas />
      </div>
      {showMarkdown && <MarkdownPreview />}
    </>
  )
})

/**
 * Markdown panel for fullscreen markdown view
 */
const MarkdownPanel = memo(function MarkdownPanel() {
  return <MarkdownPreview />
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
  const setViewMode = useSetAtom(viewModeAtom)
  const { activeProject } = useActiveProject()
  const isMarkdownFile = useIsMarkdownFile()

  // Load shared code from URL if present
  useSharedCode()

  // Load project from URL if present (handles public projects)
  useProjectFromUrl()

  // Auto-save file content (only for authenticated users with cloud projects)
  useAutoSaveFile()

  // Automatically adjust view mode based on file type
  useEffect(() => {
    if (viewMode === 'markdown' && !isMarkdownFile) {
      // If we're in markdown mode but the current file is not markdown, switch to split mode
      setViewMode('split')
    }
  }, [viewMode, isMarkdownFile, setViewMode])

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
      emulator={
        <RightPanel isMarkdownFile={isMarkdownFile} viewMode={viewMode} />
      }
      markdown={<MarkdownPanel />}
      console={<ConsolePanel />}
    />
  )
}
