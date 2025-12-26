import { render, screen } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'
import styles from './code-editor.module.css'
import { CodeEditorView, EditorHeaderView } from './code-editor.view'

describe('EditorHeaderView', () => {
  it('renders file name when provided', () => {
    render(<EditorHeaderView fileName='main.asm' fileType='project-saved' />)
    expect(screen.getByText('main.asm')).toBeInTheDocument()
  })

  it('renders Scratch when fileName is undefined', () => {
    render(<EditorHeaderView fileName={undefined} fileType='scratch' />)
    expect(screen.getByText('Scratch')).toBeInTheDocument()
  })

  it('shows Project File Saved hint for project-saved type', () => {
    render(<EditorHeaderView fileName='main.asm' fileType='project-saved' />)
    expect(screen.getByText('Project File • Saved')).toBeInTheDocument()
  })

  it('shows Project File Modified hint for project-modified type', () => {
    render(<EditorHeaderView fileName='main.asm' fileType='project-modified' />)
    expect(screen.getByText('Project File • Modified')).toBeInTheDocument()
  })

  it('shows Saved hint for saved type', () => {
    render(<EditorHeaderView fileName='program' fileType='saved' />)
    expect(screen.getByText('Saved • RASM Syntax')).toBeInTheDocument()
  })

  it('shows Modified hint for modified type', () => {
    render(<EditorHeaderView fileName='program' fileType='modified' />)
    expect(screen.getByText('Modified • RASM Syntax')).toBeInTheDocument()
  })

  it('shows Unsaved hint for scratch type', () => {
    render(<EditorHeaderView fileName={undefined} fileType='scratch' />)
    expect(screen.getByText('Unsaved • RASM Syntax')).toBeInTheDocument()
  })

  it('shows Dependency hint for dependency type', () => {
    render(<EditorHeaderView fileName='lib.asm' fileType='dependency' />)
    expect(screen.getByText('Dependency • Read-only')).toBeInTheDocument()
  })
})

describe('CodeEditorView', () => {
  const defaultProps = {
    fileName: 'test.asm',
    fileType: 'project-saved' as const,
    editorKey: 'test-editor-key',
    code: 'LD A, 0\nLD B, 1',
    errorLines: [] as readonly number[],
    onInput: vi.fn()
  }

  it('renders header with file name', () => {
    render(<CodeEditorView {...defaultProps} />)
    expect(screen.getByText('test.asm')).toBeInTheDocument()
  })

  it('renders container with proper class', () => {
    const { container } = render(<CodeEditorView {...defaultProps} />)
    expect(container.querySelector(`.${styles.container}`)).toBeInTheDocument()
  })

  it('renders CodeMirror container', () => {
    const { container } = render(<CodeEditorView {...defaultProps} />)
    expect(
      container.querySelector(`.${styles.codemirrorContainer}`)
    ).toBeInTheDocument()
  })
})
