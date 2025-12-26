import type { EditorView } from '@codemirror/view'
import { useRef } from 'react'
import styles from './code-editor.module.css'
import { useCodeMirror } from './use-codemirror'

// --- EditorHeaderView ---
type EditorHeaderViewProps = Readonly<{
  fileName: string | undefined
  fileType:
    | 'project-saved'
    | 'project-modified'
    | 'saved'
    | 'modified'
    | 'scratch'
    | 'dependency'
}>

export function EditorHeaderView({
  fileName,
  fileType
}: EditorHeaderViewProps) {
  const getHintText = () => {
    switch (fileType) {
      case 'project-saved':
        return 'Project File • Saved'
      case 'project-modified':
        return 'Project File • Modified'
      case 'saved':
        return 'Saved • RASM Syntax'
      case 'modified':
        return 'Modified • RASM Syntax'
      case 'scratch':
        return 'Unsaved • RASM Syntax'
      case 'dependency':
        return 'Dependency • Read-only'
    }
  }

  return (
    <div className={styles.header}>
      <span className={styles.title}>{fileName ?? 'Scratch'}</span>
      <span className={styles.hint}>{getHintText()}</span>
    </div>
  )
}

// --- CodeMirrorEditorView ---

type CodeMirrorEditorViewProps = Readonly<{
  code: string
  readOnly?: boolean
  errorLines: readonly number[]
  onInput: (value: string) => void
  onViewCreated?: (view: EditorView) => void
}>

function CodeMirrorEditorView({
  code,
  readOnly = false,
  errorLines,
  onInput,
  onViewCreated
}: CodeMirrorEditorViewProps) {
  const containerRef = useRef<HTMLDivElement>(null)

  useCodeMirror({
    initialCode: code,
    readOnly,
    errorLines,
    onInput,
    containerRef,
    onViewCreated
  })

  return <div ref={containerRef} className={styles.codemirrorContainer} />
}

// --- CodeEditorView (main composition) ---

export type CodeEditorViewProps = Readonly<{
  // Header props
  fileName: string | undefined
  fileType:
    | 'project-saved'
    | 'project-modified'
    | 'saved'
    | 'modified'
    | 'scratch'
    | 'dependency'

  // Editor state
  code: string
  errorLines: readonly number[]
  readOnly?: boolean

  // Handlers
  onInput: (value: string) => void
  onViewCreated?: (view: EditorView) => void
}>

export function CodeEditorView({
  fileName,
  fileType,
  code,
  errorLines,
  readOnly = false,
  onInput,
  onViewCreated
}: CodeEditorViewProps) {
  return (
    <div className={styles.container}>
      <EditorHeaderView fileName={fileName} fileType={fileType} />
      <div className={styles.editorWrapper}>
        <CodeMirrorEditorView
          code={code}
          readOnly={readOnly}
          errorLines={errorLines}
          onInput={onInput}
          onViewCreated={onViewCreated}
        />
      </div>
    </div>
  )
}
