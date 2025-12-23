import { fireEvent, render, screen } from '@testing-library/react'
import { createRef } from 'react'
import { describe, expect, it, vi } from 'vitest'
import styles from './code-editor.module.css'
import {
  CodeEditorView,
  EditorHeaderView,
  EditorTextareaView,
  ErrorHighlightsView,
  LineNumbersView
} from './code-editor.view'

describe('LineNumbersView', () => {
  const defaultProps = {
    lines: ['line1', 'line2', 'line3'],
    errorLines: [] as readonly number[],
    scrollTop: 0,
    lineNumbersRef: createRef<HTMLDivElement>()
  }

  it('renders line numbers', () => {
    const { container } = render(<LineNumbersView {...defaultProps} />)
    expect(
      container.querySelector(`.${styles.lineNumbers}`)
    ).toBeInTheDocument()
  })

  it('renders correct number of lines', () => {
    const { container } = render(<LineNumbersView {...defaultProps} />)
    const lineNumbers = container.querySelectorAll(`.${styles.lineNumber}`)
    expect(lineNumbers).toHaveLength(3)
  })

  it('displays line numbers 1, 2, 3', () => {
    render(<LineNumbersView {...defaultProps} />)
    expect(screen.getByText('1')).toBeInTheDocument()
    expect(screen.getByText('2')).toBeInTheDocument()
    expect(screen.getByText('3')).toBeInTheDocument()
  })

  it('applies error class to error lines', () => {
    const { container } = render(
      <LineNumbersView {...defaultProps} errorLines={[2]} />
    )
    const lineNumbers = container.querySelectorAll(`.${styles.lineNumber}`)
    expect(lineNumbers[1]).toHaveClass(styles.error)
  })

  it('attaches ref to container', () => {
    const ref = createRef<HTMLDivElement>()
    render(<LineNumbersView {...defaultProps} lineNumbersRef={ref} />)
    expect(ref.current).toBeInstanceOf(HTMLDivElement)
  })

  it('applies scroll offset', () => {
    const { container } = render(
      <LineNumbersView {...defaultProps} scrollTop={100} />
    )
    const lineNumbers = container.querySelector(`.${styles.lineNumbers}`)
    expect(lineNumbers).toHaveStyle({ marginTop: '-100px' })
  })
})

describe('ErrorHighlightsView', () => {
  it('renders nothing when no error lines', () => {
    const { container } = render(
      <ErrorHighlightsView errorLines={[]} scrollTop={0} />
    )
    expect(
      container.querySelector(`.${styles.errorHighlight}`)
    ).not.toBeInTheDocument()
  })

  it('renders highlights for error lines', () => {
    const { container } = render(
      <ErrorHighlightsView errorLines={[1, 3]} scrollTop={0} />
    )
    const highlights = container.querySelectorAll(`.${styles.errorHighlight}`)
    expect(highlights).toHaveLength(2)
  })
})

describe('EditorTextareaView', () => {
  const defaultProps = {
    code: 'test code',
    textareaRef: createRef<HTMLTextAreaElement>(),
    onChange: vi.fn(),
    onKeyDown: vi.fn(),
    onScroll: vi.fn()
  }

  it('renders textarea', () => {
    render(<EditorTextareaView {...defaultProps} />)
    expect(screen.getByRole('textbox')).toBeInTheDocument()
  })

  it('displays code value', () => {
    render(<EditorTextareaView {...defaultProps} code='LD A, 0' />)
    expect(screen.getByRole('textbox')).toHaveValue('LD A, 0')
  })

  it('has spellCheck disabled', () => {
    render(<EditorTextareaView {...defaultProps} />)
    expect(screen.getByRole('textbox')).toHaveAttribute('spellcheck', 'false')
  })

  it('calls onChange when text changes', () => {
    const handleChange = vi.fn()
    render(<EditorTextareaView {...defaultProps} onChange={handleChange} />)

    fireEvent.change(screen.getByRole('textbox'), {
      target: { value: 'new code' }
    })

    expect(handleChange).toHaveBeenCalled()
  })

  it('calls onKeyDown when key is pressed', () => {
    const handleKeyDown = vi.fn()
    render(<EditorTextareaView {...defaultProps} onKeyDown={handleKeyDown} />)

    fireEvent.keyDown(screen.getByRole('textbox'), { key: 'Tab' })

    expect(handleKeyDown).toHaveBeenCalled()
  })

  it('calls onScroll when scrolled', () => {
    const handleScroll = vi.fn()
    render(<EditorTextareaView {...defaultProps} onScroll={handleScroll} />)

    fireEvent.scroll(screen.getByRole('textbox'))

    expect(handleScroll).toHaveBeenCalled()
  })

  it('attaches ref to textarea', () => {
    const ref = createRef<HTMLTextAreaElement>()
    render(<EditorTextareaView {...defaultProps} textareaRef={ref} />)
    expect(ref.current).toBeInstanceOf(HTMLTextAreaElement)
  })
})

describe('EditorHeaderView', () => {
  it('renders file name when provided', () => {
    render(<EditorHeaderView fileName='main.asm' fileType='project' />)
    expect(screen.getByText('main.asm')).toBeInTheDocument()
  })

  it('renders Scratch when fileName is undefined', () => {
    render(<EditorHeaderView fileName={undefined} fileType='scratch' />)
    expect(screen.getByText('Scratch')).toBeInTheDocument()
  })

  it('shows Project File hint for project type', () => {
    render(<EditorHeaderView fileName='main.asm' fileType='project' />)
    expect(screen.getByText('Project File')).toBeInTheDocument()
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
})

describe('CodeEditorView', () => {
  const defaultProps = {
    fileName: 'test.asm',
    fileType: 'project' as const,
    code: 'LD A, 0\nLD B, 1',
    lines: ['LD A, 0', 'LD B, 1'],
    errorLines: [] as readonly number[],
    scrollTop: 0,
    textareaRef: createRef<HTMLTextAreaElement>(),
    lineNumbersRef: createRef<HTMLDivElement>(),
    onChange: vi.fn(),
    onKeyDown: vi.fn(),
    onScroll: vi.fn()
  }

  it('renders header with file name', () => {
    render(<CodeEditorView {...defaultProps} />)
    expect(screen.getByText('test.asm')).toBeInTheDocument()
  })

  it('renders line numbers', () => {
    render(<CodeEditorView {...defaultProps} />)
    expect(screen.getByText('1')).toBeInTheDocument()
    expect(screen.getByText('2')).toBeInTheDocument()
  })

  it('renders textarea with code', () => {
    render(<CodeEditorView {...defaultProps} />)
    expect(screen.getByRole('textbox')).toHaveValue('LD A, 0\nLD B, 1')
  })

  it('renders container with proper class', () => {
    const { container } = render(<CodeEditorView {...defaultProps} />)
    expect(container.querySelector(`.${styles.container}`)).toBeInTheDocument()
  })

  it('renders error highlights when errorLines present', () => {
    const { container } = render(
      <CodeEditorView {...defaultProps} errorLines={[1]} />
    )
    expect(
      container.querySelector(`.${styles.errorHighlight}`)
    ).toBeInTheDocument()
  })
})
