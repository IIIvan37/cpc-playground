import type { EditorView } from '@codemirror/view'
import { MoonIcon, SunIcon } from '@radix-ui/react-icons'
import { useRef } from 'react'
import Button from '@/components/ui/button/button'
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
  editorTheme: 'vscode-light' | 'vscode-dark'
  onToggleTheme: () => void
}>

export function EditorHeaderView({
  fileName,
  fileType,
  editorTheme,
  onToggleTheme
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
      <div className={styles.headerActions}>
        <span className={styles.hint}>{getHintText()}</span>
        <Button
          variant='ghost'
          size='sm'
          onClick={onToggleTheme}
          title={`Switch to ${
            editorTheme === 'vscode-dark' ? 'light' : 'dark'
          } theme`}
        >
          {editorTheme === 'vscode-dark' ? <SunIcon /> : <MoonIcon />}
        </Button>
      </div>
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
  theme?: 'vscode-light' | 'vscode-dark'
}>

function CodeMirrorEditorView({
  code,
  readOnly = false,
  errorLines,
  onInput,
  onViewCreated,
  theme = 'vscode-dark'
}: CodeMirrorEditorViewProps) {
  const containerRef = useRef<HTMLDivElement>(null)

  useCodeMirror({
    initialCode: code,
    readOnly,
    errorLines,
    onInput,
    containerRef,
    onViewCreated,
    theme
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
  theme?: 'vscode-light' | 'vscode-dark'

  // Theme controls
  editorTheme: 'vscode-light' | 'vscode-dark'
  onToggleTheme: () => void

  // File identification for remounting
  fileId?: string

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
  fileId,
  theme = 'vscode-dark',
  editorTheme,
  onToggleTheme,
  onInput,
  onViewCreated
}: CodeEditorViewProps) {
  return (
    <div className={styles.container}>
      <EditorHeaderView
        fileName={fileName}
        fileType={fileType}
        editorTheme={editorTheme}
        onToggleTheme={onToggleTheme}
      />
      <div
        className={`${styles.editorWrapper} ${
          editorTheme === 'vscode-dark' ? styles.transparentBg : ''
        }`}
      >
        <CodeMirrorEditorView
          key={fileId}
          code={code}
          readOnly={readOnly}
          errorLines={errorLines}
          onInput={onInput}
          onViewCreated={onViewCreated}
          theme={theme}
        />
      </div>
    </div>
  )
}
