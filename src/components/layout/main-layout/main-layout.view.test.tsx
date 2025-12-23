import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import styles from './main-layout.module.css'
import { MainLayoutView } from './main-layout.view'

describe('MainLayoutView', () => {
  const defaultProps = {
    viewMode: 'split' as const,
    showSidebar: false,
    toolbar: <div data-testid='toolbar'>Toolbar</div>,
    editor: <div data-testid='editor'>Editor</div>,
    emulator: <div data-testid='emulator'>Emulator</div>,
    console: <div data-testid='console'>Console</div>
  }

  describe('rendering slots', () => {
    it('renders toolbar', () => {
      render(<MainLayoutView {...defaultProps} />)
      expect(screen.getByTestId('toolbar')).toBeInTheDocument()
    })

    it('renders editor', () => {
      render(<MainLayoutView {...defaultProps} />)
      expect(screen.getByTestId('editor')).toBeInTheDocument()
    })

    it('renders emulator', () => {
      render(<MainLayoutView {...defaultProps} />)
      expect(screen.getByTestId('emulator')).toBeInTheDocument()
    })

    it('renders console in footer', () => {
      render(<MainLayoutView {...defaultProps} />)
      expect(screen.getByTestId('console')).toBeInTheDocument()
    })
  })

  describe('readOnlyBanner slot', () => {
    it('does not render readOnlyBanner when undefined', () => {
      render(<MainLayoutView {...defaultProps} />)
      expect(screen.queryByTestId('banner')).not.toBeInTheDocument()
    })

    it('renders readOnlyBanner when provided', () => {
      render(
        <MainLayoutView
          {...defaultProps}
          readOnlyBanner={<div data-testid='banner'>Read Only</div>}
        />
      )
      expect(screen.getByTestId('banner')).toBeInTheDocument()
    })
  })

  describe('sidebar', () => {
    it('does not render sidebar when showSidebar is false', () => {
      render(<MainLayoutView {...defaultProps} showSidebar={false} />)
      expect(screen.queryByTestId('sidebar')).not.toBeInTheDocument()
    })

    it('renders sidebar when showSidebar is true', () => {
      render(
        <MainLayoutView
          {...defaultProps}
          showSidebar={true}
          sidebar={<div data-testid='sidebar'>Sidebar</div>}
        />
      )
      expect(screen.getByTestId('sidebar')).toBeInTheDocument()
    })
  })

  describe('viewMode', () => {
    it('hides editor panel in emulator mode', () => {
      const { container } = render(
        <MainLayoutView {...defaultProps} viewMode='emulator' />
      )
      const editorPanel = container.querySelector(`.${styles.editorPanel}`)
      expect(editorPanel).toHaveAttribute('data-hidden', 'true')
    })

    it('shows editor panel in editor mode', () => {
      const { container } = render(
        <MainLayoutView {...defaultProps} viewMode='editor' />
      )
      const editorPanel = container.querySelector(`.${styles.editorPanel}`)
      expect(editorPanel).toHaveAttribute('data-hidden', 'false')
    })

    it('hides emulator panel in editor mode', () => {
      const { container } = render(
        <MainLayoutView {...defaultProps} viewMode='editor' />
      )
      const emulatorPanel = container.querySelector(`.${styles.emulatorPanel}`)
      expect(emulatorPanel).toHaveAttribute('data-hidden', 'true')
    })

    it('shows emulator panel in emulator mode', () => {
      const { container } = render(
        <MainLayoutView {...defaultProps} viewMode='emulator' />
      )
      const emulatorPanel = container.querySelector(`.${styles.emulatorPanel}`)
      expect(emulatorPanel).toHaveAttribute('data-hidden', 'false')
    })

    it('shows both panels in split mode', () => {
      const { container } = render(
        <MainLayoutView {...defaultProps} viewMode='split' />
      )
      const editorPanel = container.querySelector(`.${styles.editorPanel}`)
      const emulatorPanel = container.querySelector(`.${styles.emulatorPanel}`)
      expect(editorPanel).toHaveAttribute('data-hidden', 'false')
      expect(emulatorPanel).toHaveAttribute('data-hidden', 'false')
    })
  })

  describe('layout structure', () => {
    it('renders main element', () => {
      render(<MainLayoutView {...defaultProps} />)
      expect(screen.getByRole('main')).toBeInTheDocument()
    })

    it('renders footer element', () => {
      render(<MainLayoutView {...defaultProps} />)
      expect(screen.getByRole('contentinfo')).toBeInTheDocument()
    })
  })
})
