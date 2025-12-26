import type { EditorView } from '@codemirror/view'
import { getDefaultStore, useAtom, useAtomValue } from 'jotai'
import { useCallback, useEffect, useRef, useState } from 'react'
import { useCurrentFile } from '@/hooks/projects/use-current-project'
import {
  codeAtom,
  consoleMessagesAtom,
  editorThemeAtom,
  goToLineAtom
} from '@/store'
import { currentProgramAtom } from '@/store/programs'
import { isDependencyFileAtom, isReadOnlyModeAtom } from '@/store/projects'
import { CodeEditorView } from './code-editor.view'
import { useCodeMirrorMethods } from './use-codemirror'

// Store reference for external sync (bypasses React re-renders)
const store = getDefaultStore()

/**
 * Container component for code editor
 * Handles business logic and delegates rendering to CodeEditorView
 *
 * Uses CodeMirror for syntax highlighting and advanced editing features.
 */
export function CodeEditor() {
  const [goToLine, setGoToLine] = useAtom(goToLineAtom)
  const consoleMessages = useAtomValue(consoleMessagesAtom)
  const [editorTheme, setEditorTheme] = useAtom(editorThemeAtom)
  const currentFile = useCurrentFile()
  const currentProgram = useAtomValue(currentProgramAtom)
  const globalCode = useAtomValue(codeAtom)
  const isDependencyFile = useAtomValue(isDependencyFileAtom)
  const isReadOnlyMode = useAtomValue(isReadOnlyModeAtom)
  const editorViewRef = useRef<EditorView | null>(null)

  // Local state for display
  const [localCode, setLocalCode] = useState(
    currentFile?.content.value ?? globalCode
  )

  // Editor key for remounting CodeMirror on content source change
  const fileId = currentFile?.id

  // Track current fileId to prevent stale syncs
  const currentFileIdRef = useRef(fileId)

  // CodeMirror methods
  const { goToLine: goToLineInEditor } = useCodeMirrorMethods(editorViewRef)

  // Sync local -> global using store.set (bypasses React subscription)
  const syncTimeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  useEffect(() => {
    const syncFileId = fileId // Capture current fileId
    syncTimeoutRef.current = setTimeout(() => {
      // Only sync if we're still on the same file
      if (currentFileIdRef.current === syncFileId) {
        store.set(codeAtom, localCode)
      }
    }, 300)
    return () => {
      if (syncTimeoutRef.current) {
        clearTimeout(syncTimeoutRef.current)
      }
    }
  }, [localCode, fileId])

  // Reset local code when file changes
  useEffect(() => {
    currentFileIdRef.current = fileId

    if (syncTimeoutRef.current) {
      clearTimeout(syncTimeoutRef.current)
      syncTimeoutRef.current = null
    }
    if (currentFile) {
      setLocalCode(currentFile.content.value)
    }
  }, [fileId, currentFile])

  // Sync from globalCode only when NOT in project file mode
  useEffect(() => {
    if (!currentFile && globalCode) {
      setLocalCode(globalCode)
    }
  }, [currentFile, globalCode])

  const handleInput = useCallback((value: string) => {
    setLocalCode(value)
  }, [])

  const handleViewCreated = useCallback((view: EditorView) => {
    editorViewRef.current = view
  }, [])

  const handleToggleTheme = useCallback(() => {
    setEditorTheme(
      editorTheme === 'vscode-dark' ? 'vscode-light' : 'vscode-dark'
    )
  }, [editorTheme, setEditorTheme])

  // Navigate to line when goToLine changes
  useEffect(() => {
    if (goToLine !== null) {
      goToLineInEditor(goToLine)
      setGoToLine(null)
    }
  }, [goToLine, goToLineInEditor, setGoToLine])

  // Determine file name and type for header
  const fileName =
    currentFile?.name.value ?? currentProgram?.name.value ?? undefined
  const getFileType = ():
    | 'project-saved'
    | 'project-modified'
    | 'saved'
    | 'modified'
    | 'scratch'
    | 'dependency' => {
    if (isDependencyFile) return 'dependency'
    if (currentFile) {
      return localCode === currentFile.content.value
        ? 'project-saved'
        : 'project-modified'
    }
    if (currentProgram) {
      return localCode === currentProgram.code ? 'saved' : 'modified'
    }
    return 'scratch'
  }
  const fileType = getFileType()

  // Use the correct source for initial code
  const initialCode = currentFile?.content.value ?? globalCode

  // Dependency files are always read-only
  const isReadOnly = isDependencyFile || isReadOnlyMode

  return (
    <CodeEditorView
      fileName={fileName}
      fileType={fileType}
      code={initialCode}
      consoleMessages={consoleMessages}
      readOnly={isReadOnly}
      fileId={fileId}
      theme={editorTheme}
      editorTheme={editorTheme}
      onToggleTheme={handleToggleTheme}
      onInput={handleInput}
      onViewCreated={handleViewCreated}
    />
  )
}
