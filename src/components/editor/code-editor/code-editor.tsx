import { getDefaultStore, useAtom, useAtomValue } from 'jotai'
import { useCallback, useEffect, useRef, useState } from 'react'
import { codeAtom, errorLinesAtom, goToLineAtom } from '@/store'
import { currentProgramAtom } from '@/store/programs'
import { currentFileAtom } from '@/store/projects'
import { CodeEditorView } from './code-editor.view'

const LINE_HEIGHT = 21

// Store reference for external sync (bypasses React re-renders)
const store = getDefaultStore()

/**
 * Container component for code editor
 * Handles business logic and delegates rendering to CodeEditorView
 *
 * Uses uncontrolled textarea with key-based remount to avoid React Concurrent
 * Mode issues where controlled inputs can lose input events.
 */
export function CodeEditor() {
  const [goToLine, setGoToLine] = useAtom(goToLineAtom)
  const errorLines = useAtomValue(errorLinesAtom)
  const currentFile = useAtomValue(currentFileAtom)
  const currentProgram = useAtomValue(currentProgramAtom)
  const textareaRef = useRef<HTMLTextAreaElement>(null)
  const lineNumbersRef = useRef<HTMLDivElement>(null)
  const [scrollTop, setScrollTop] = useState(0)

  // Local state for display (line numbers, etc.)
  const [localCode, setLocalCode] = useState(currentFile?.content.value ?? '')

  // File ID for key-based remount
  const fileId = currentFile?.id

  // Track current fileId to prevent stale syncs
  const currentFileIdRef = useRef(fileId)

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

  // Reset local code when file changes (codeAtom is synced by setCurrentFileAtom)
  useEffect(() => {
    // Update ref immediately
    currentFileIdRef.current = fileId

    // Cancel any pending sync to prevent stale content from overwriting
    if (syncTimeoutRef.current) {
      clearTimeout(syncTimeoutRef.current)
      syncTimeoutRef.current = null
    }
    if (currentFile) {
      setLocalCode(currentFile.content.value)
    }
  }, [fileId, currentFile])

  const lines = localCode.split('\n')

  const handleInput = useCallback((value: string) => {
    setLocalCode(value)
  }, [])

  const handleKeyDown = useCallback(
    (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
      if (e.key === 'Tab') {
        e.preventDefault()
        const textarea = e.currentTarget
        const value = textarea.value
        const start = textarea.selectionStart
        const end = textarea.selectionEnd
        // Multi-line selection ?
        if (start !== end && value.slice(start, end).includes('\n')) {
          // Indent all selected lines
          const before = value.substring(0, start)
          const selected = value.substring(start, end)
          const after = value.substring(end)
          // Indent each line in selection
          const indented = selected.replaceAll(/^/gm, '    ')
          const newValue = before + indented + after
          textarea.value = newValue
          setLocalCode(newValue)
          setTimeout(() => {
            textarea.selectionStart = start
            textarea.selectionEnd = end + (indented.length - selected.length)
          }, 0)
        } else {
          // Single line: insert spaces
          const newValue = `${value.substring(0, start)}    ${value.substring(
            end
          )}`
          textarea.value = newValue
          setLocalCode(newValue)
          setTimeout(() => {
            textarea.selectionStart = textarea.selectionEnd = start + 4
          }, 0)
        }
      }
    },
    []
  )

  const handleScroll = useCallback((e: React.UIEvent<HTMLTextAreaElement>) => {
    const target = e.target as HTMLTextAreaElement
    setScrollTop(target.scrollTop)
    if (lineNumbersRef.current) {
      lineNumbersRef.current.scrollTop = target.scrollTop
    }
  }, [])

  // Navigate to line when goToLine changes
  useEffect(() => {
    if (goToLine !== null && textareaRef.current) {
      const textarea = textareaRef.current

      let charPosition = 0
      for (let i = 0; i < goToLine - 1 && i < lines.length; i++) {
        charPosition += lines[i].length + 1
      }

      textarea.focus()
      textarea.setSelectionRange(charPosition, charPosition)
      textarea.scrollTop = Math.max(0, (goToLine - 5) * LINE_HEIGHT)

      setGoToLine(null)
    }
  }, [goToLine, lines, setGoToLine])

  // Determine file name and type for header
  const fileName =
    currentFile?.name.value ?? currentProgram?.name.value ?? undefined
  const getFileType = (): 'project' | 'saved' | 'modified' | 'scratch' => {
    if (currentFile) return 'project'
    if (currentProgram) {
      // Check if code has been modified from saved version
      return localCode === currentProgram.code ? 'saved' : 'modified'
    }
    return 'scratch'
  }
  const fileType = getFileType()

  // Use currentFile.content.value for initial render to avoid stale content
  // localCode is used for line numbers and sync to codeAtom
  const initialCode = currentFile?.content.value ?? localCode

  return (
    <CodeEditorView
      fileName={fileName}
      fileType={fileType}
      fileId={fileId}
      code={initialCode}
      lines={lines}
      errorLines={errorLines}
      scrollTop={scrollTop}
      textareaRef={textareaRef}
      lineNumbersRef={lineNumbersRef}
      onInput={handleInput}
      onKeyDown={handleKeyDown}
      onScroll={handleScroll}
    />
  )
}
