import { render, screen } from '@testing-library/react'
import { createRef } from 'react'
import { describe, expect, it, vi } from 'vitest'
import styles from './emulator-canvas.module.css'
import { EmulatorCanvasView } from './emulator-canvas.view'

describe('EmulatorCanvasView', () => {
  const defaultProps = {
    wrapperRef: createRef<HTMLDivElement>(),
    containerRef: createRef<HTMLDivElement>(),
    hasFocus: false,
    statusText: '○ Click to type',
    canSaveThumbnail: false,
    savingThumbnail: false,
    currentKeyboardLayout: 'azerty',
    onFocus: vi.fn(),
    onBlur: vi.fn(),
    onSaveThumbnail: vi.fn(),
    onKeyboardLayoutChange: vi.fn()
  }

  describe('rendering', () => {
    it('renders the title', () => {
      render(<EmulatorCanvasView {...defaultProps} />)
      expect(screen.getByText('CPC Emulator')).toBeInTheDocument()
    })

    it('renders the status text', () => {
      render(<EmulatorCanvasView {...defaultProps} statusText='○ Loading...' />)
      expect(screen.getByText('○ Loading...')).toBeInTheDocument()
    })

    it('renders button wrapper for canvas', () => {
      render(<EmulatorCanvasView {...defaultProps} />)
      expect(screen.getByRole('button')).toBeInTheDocument()
    })
  })

  describe('focus state', () => {
    it('does not have focused class when hasFocus is false', () => {
      render(<EmulatorCanvasView {...defaultProps} hasFocus={false} />)
      expect(screen.getByRole('button')).not.toHaveClass('focused')
    })

    it('has focused class when hasFocus is true', () => {
      render(<EmulatorCanvasView {...defaultProps} hasFocus={true} />)
      expect(screen.getByRole('button')).toHaveClass(styles.focused)
    })
  })

  describe('status text variations', () => {
    it('displays loading status', () => {
      render(<EmulatorCanvasView {...defaultProps} statusText='○ Loading...' />)
      expect(screen.getByText('○ Loading...')).toBeInTheDocument()
    })

    it('displays active status', () => {
      render(<EmulatorCanvasView {...defaultProps} statusText='● Active' />)
      expect(screen.getByText('● Active')).toBeInTheDocument()
    })

    it('displays click to type status', () => {
      render(
        <EmulatorCanvasView {...defaultProps} statusText='○ Click to type' />
      )
      expect(screen.getByText('○ Click to type')).toBeInTheDocument()
    })
  })

  describe('refs', () => {
    it('attaches wrapperRef to div element', () => {
      const wrapperRef = createRef<HTMLDivElement>()
      render(<EmulatorCanvasView {...defaultProps} wrapperRef={wrapperRef} />)

      expect(wrapperRef.current).toBeInstanceOf(HTMLDivElement)
    })

    it('attaches containerRef to container element', () => {
      const containerRef = createRef<HTMLDivElement>()
      render(
        <EmulatorCanvasView {...defaultProps} containerRef={containerRef} />
      )

      expect(containerRef.current).toBeInstanceOf(HTMLDivElement)
      expect(containerRef.current).toHaveClass(styles.container)
    })
  })

  describe('interactions', () => {
    it('calls onFocus when button receives focus', () => {
      const handleFocus = vi.fn()
      render(<EmulatorCanvasView {...defaultProps} onFocus={handleFocus} />)

      screen.getByRole('button').focus()

      expect(handleFocus).toHaveBeenCalledTimes(1)
    })

    it('calls onBlur when button loses focus', () => {
      const handleBlur = vi.fn()
      render(<EmulatorCanvasView {...defaultProps} onBlur={handleBlur} />)

      const button = screen.getByRole('button')
      button.focus()
      button.blur()

      expect(handleBlur).toHaveBeenCalledTimes(1)
    })
  })
})
