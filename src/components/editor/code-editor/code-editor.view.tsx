import type { RefObject } from 'react'
import styles from './code-editor.module.css'

const LINE_HEIGHT = 21
const PADDING = 16

// --- LineNumbersView ---
type LineNumbersViewProps = Readonly<{
  lines: readonly string[]
  errorLines: readonly number[]
  scrollTop: number
  lineNumbersRef: RefObject<HTMLDivElement | null>
}>

export function LineNumbersView({
  lines,
  errorLines,
  scrollTop,
  lineNumbersRef
}: LineNumbersViewProps) {
  return (
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
  )
}

// --- ErrorHighlightsView ---
type ErrorHighlightsViewProps = Readonly<{
  errorLines: readonly number[]
  scrollTop: number
}>

export function ErrorHighlightsView({
  errorLines,
  scrollTop
}: ErrorHighlightsViewProps) {
  return (
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
  )
}

// --- EditorTextareaView ---
type EditorTextareaViewProps = Readonly<{
  code: string
  textareaRef: RefObject<HTMLTextAreaElement | null>
  onChange: (e: React.ChangeEvent<HTMLTextAreaElement>) => void
  onKeyDown: (e: React.KeyboardEvent<HTMLTextAreaElement>) => void
  onScroll: (e: React.UIEvent<HTMLTextAreaElement>) => void
}>

export function EditorTextareaView({
  code,
  textareaRef,
  onChange,
  onKeyDown,
  onScroll
}: EditorTextareaViewProps) {
  return (
    <textarea
      ref={textareaRef}
      className={styles.editor}
      value={code}
      onChange={onChange}
      onKeyDown={onKeyDown}
      onScroll={onScroll}
      spellCheck={false}
      autoComplete='off'
      autoCorrect='off'
      autoCapitalize='off'
    />
  )
}

// --- EditorHeaderView ---
type EditorHeaderViewProps = Readonly<{
  fileName: string | undefined
  isProjectFile: boolean
}>

export function EditorHeaderView({
  fileName,
  isProjectFile
}: EditorHeaderViewProps) {
  return (
    <div className={styles.header}>
      <span className={styles.title}>{fileName ?? 'Scratch'}</span>
      <span className={styles.hint}>
        {isProjectFile ? 'Project File' : 'Unsaved • RASM Syntax'}
      </span>
    </div>
  )
}

// --- CodeEditorView (main composition) ---
export type CodeEditorViewProps = Readonly<{
  // Header props
  fileName: string | undefined
  isProjectFile: boolean

  // Editor state
  code: string
  lines: readonly string[]
  errorLines: readonly number[]
  scrollTop: number

  // Refs
  textareaRef: RefObject<HTMLTextAreaElement | null>
  lineNumbersRef: RefObject<HTMLDivElement | null>

  // Handlers
  onChange: (e: React.ChangeEvent<HTMLTextAreaElement>) => void
  onKeyDown: (e: React.KeyboardEvent<HTMLTextAreaElement>) => void
  onScroll: (e: React.UIEvent<HTMLTextAreaElement>) => void
}>

export function CodeEditorView({
  fileName,
  isProjectFile,
  code,
  lines,
  errorLines,
  scrollTop,
  textareaRef,
  lineNumbersRef,
  onChange,
  onKeyDown,
  onScroll
}: CodeEditorViewProps) {
  return (
    <div className={styles.container}>
      <EditorHeaderView fileName={fileName} isProjectFile={isProjectFile} />
      <div className={styles.editorWrapper}>
        <LineNumbersView
          lines={lines}
          errorLines={errorLines}
          scrollTop={scrollTop}
          lineNumbersRef={lineNumbersRef}
        />
        <div className={styles.editorContent}>
          <ErrorHighlightsView errorLines={errorLines} scrollTop={scrollTop} />
          <EditorTextareaView
            code={code}
            textareaRef={textareaRef}
            onChange={onChange}
            onKeyDown={onKeyDown}
            onScroll={onScroll}
          />
        </div>
      </div>
    </div>
  )
}
