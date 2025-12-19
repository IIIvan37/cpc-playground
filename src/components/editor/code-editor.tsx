import { useAtom, useAtomValue } from 'jotai'
import { useCallback, useEffect, useRef, useState } from 'react'
import { codeAtom, errorLinesAtom, goToLineAtom } from '@/store'
import styles from './code-editor.module.css'

const LINE_HEIGHT = 21 // 14px font-size * 1.5 line-height
const PADDING = 16 // var(--spacing-md) = 1rem = 16px

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
        const target = e.target as HTMLTextAreaElement
        const start = target.selectionStart
        const end = target.selectionEnd
        const newValue = `${code.substring(0, start)}    ${code.substring(end)}`
        setCode(newValue)
        requestAnimationFrame(() => {
          target.selectionStart = target.selectionEnd = start + 4
        })
      }
    },
    [code, setCode]
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

      // Calculate character position for the target line
      let charPosition = 0
      for (let i = 0; i < goToLine - 1 && i < lines.length; i++) {
        charPosition += lines[i].length + 1 // +1 for newline
      }

      // Focus and set cursor position
      textarea.focus()
      textarea.setSelectionRange(charPosition, charPosition)

      // Scroll to make the line visible
      textarea.scrollTop = Math.max(0, (goToLine - 5) * LINE_HEIGHT)

      // Clear the goToLine atom
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
                className={`${styles.lineNumber} ${hasError ? styles.error : ''}`}
              >
                {lineNum}
              </div>
            )
          })}
        </div>
        <div className={styles.editorContent}>
          {/* Error highlight overlays container */}
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
