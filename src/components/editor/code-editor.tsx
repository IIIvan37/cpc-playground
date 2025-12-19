import { useAtom, useAtomValue } from 'jotai'
import { useCallback, useEffect, useRef, useState } from 'react'
import { codeAtom, errorLinesAtom, goToLineAtom } from '@/store'
import styles from './code-editor.module.css'

const LINE_HEIGHT = 21
const PADDING = 16

export function CodeEditor() {
  const [code, setCode] = useAtom(codeAtom)
  const [goToLine, setGoToLine] = useAtom(goToLineAtom)
  const errorLines = useAtomValue(errorLinesAtom)
  const textareaRef = useRef<HTMLTextAreaElement>(null)
  const lineNumbersRef = useRef<HTMLDivElement>(null)
  const [scrollTop, setScrollTop] = useState(0)

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
          const indented = selected.replace(/^/gm, '    ')
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

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <span className={styles.title}>Z80 Assembly</span>
        <span className={styles.hint}>RASM Syntax</span>
      </div>
      <div className={styles.editorWrapper}>
        <div
          ref={lineNumbersRef}
          className={styles.lineNumbers}
          style={{ marginTop: -scrollTop }}
        >
          {lines.map((_, index) => {
            const lineNum = index + 1
            const hasError = errorLines.includes(lineNum)
            return (
              <div
                key={lineNum}
                className={`${styles.lineNumber} ${
                  hasError ? styles.error : ''
                }`}
              >
                {lineNum}
              </div>
            )
          })}
        </div>
        <div className={styles.editorContent}>
          <div className={styles.errorHighlights}>
            {errorLines.map((lineNum) => (
              <div
                key={`error-${lineNum}`}
                className={styles.errorHighlight}
                style={{
                  top: PADDING + (lineNum - 1) * LINE_HEIGHT - scrollTop
                }}
              />
            ))}
          </div>
          <textarea
            ref={textareaRef}
            className={styles.editor}
            value={code}
            onChange={handleChange}
            onKeyDown={handleKeyDown}
            onScroll={handleScroll}
            spellCheck={false}
            autoComplete='off'
            autoCorrect='off'
            autoCapitalize='off'
          />
        </div>
      </div>
    </div>
  )
}
