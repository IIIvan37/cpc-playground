import { useAtom, useAtomValue } from 'jotai'
import { useCallback, useEffect, useRef, useState } from 'react'
import { codeAtom, errorLinesAtom, goToLineAtom } from '@/store'
import { currentProgramAtom } from '@/store/programs'
import { currentFileAtom } from '@/store/projects'
import { CodeEditorView } from './code-editor.view'

const LINE_HEIGHT = 21

/**
 * Container component for code editor
 * Handles business logic and delegates rendering to CodeEditorView
 */
export function CodeEditor() {
  const [code, setCode] = useAtom(codeAtom)
  const [goToLine, setGoToLine] = useAtom(goToLineAtom)
  const errorLines = useAtomValue(errorLinesAtom)
  const currentFile = useAtomValue(currentFileAtom)
  const currentProgram = useAtomValue(currentProgramAtom)
  const textareaRef = useRef<HTMLTextAreaElement>(null)
  const lineNumbersRef = useRef<HTMLDivElement>(null)
  const [scrollTop, setScrollTop] = useState(0)

  // Synchronize code with current file when it changes
  useEffect(() => {
    if (currentFile) {
      setCode(currentFile.content.value)
    }
  }, [currentFile, setCode])

  const lines = code.split('\n')

  const handleChange = useCallback(
    (e: React.ChangeEvent<HTMLTextAreaElement>) => {
      setCode(e.target.value)
    },
    [setCode]
  )

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
          setCode(before + indented + after)
          setTimeout(() => {
            textarea.selectionStart = start
            textarea.selectionEnd = end + (indented.length - selected.length)
          }, 0)
        } else {
          // Single line: insert spaces
          const newValue = `${value.substring(0, start)}    ${value.substring(
            end
          )}`
          setCode(newValue)
          setTimeout(() => {
            textarea.selectionStart = textarea.selectionEnd = start + 4
          }, 0)
        }
      }
    },
    [setCode]
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
      return code === currentProgram.code ? 'saved' : 'modified'
    }
    return 'scratch'
  }
  const fileType = getFileType()

  return (
    <CodeEditorView
      fileName={fileName}
      fileType={fileType}
      code={code}
      lines={lines}
      errorLines={errorLines}
      scrollTop={scrollTop}
      textareaRef={textareaRef}
      lineNumbersRef={lineNumbersRef}
      onChange={handleChange}
      onKeyDown={handleKeyDown}
      onScroll={handleScroll}
    />
  )
}
