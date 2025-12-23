import { fireEvent, render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { createRef } from 'react'
import { describe, expect, it, vi } from 'vitest'
import styles from './resizable-sidebar.module.css'
import { ResizableSidebarView } from './resizable-sidebar.view'

describe('ResizableSidebarView', () => {
  const defaultProps = {
    children: <div>Sidebar Content</div>,
    width: 220,
    isCollapsed: false,
    isResizing: false,
    sidebarRef: createRef<HTMLDivElement>(),
    onToggleCollapse: vi.fn(),
    onStartResizing: vi.fn()
  }

  describe('rendering', () => {
    it('renders children content', () => {
      render(<ResizableSidebarView {...defaultProps} />)
      expect(screen.getByText('Sidebar Content')).toBeInTheDocument()
    })

    it('renders collapse button', () => {
      render(<ResizableSidebarView {...defaultProps} />)
      expect(
        screen.getByRole('button', { name: /collapse sidebar/i })
      ).toBeInTheDocument()
    })

    it('renders resize handle when not collapsed', () => {
      const { container } = render(<ResizableSidebarView {...defaultProps} />)
      expect(
        container.querySelector(`.${styles.resizeHandle}`)
      ).toBeInTheDocument()
    })

    it('does not render resize handle when collapsed', () => {
      const { container } = render(
        <ResizableSidebarView {...defaultProps} isCollapsed={true} />
      )
      expect(
        container.querySelector(`.${styles.resizeHandle}`)
      ).not.toBeInTheDocument()
    })
  })

  describe('width', () => {
    it('applies width style when not collapsed', () => {
      const { container } = render(
        <ResizableSidebarView {...defaultProps} width={250} />
      )
      const wrapper = container.querySelector(`.${styles.wrapper}`)
      expect(wrapper).toHaveStyle({ width: '250px' })
    })

    it('does not apply width style when collapsed', () => {
      const { container } = render(
        <ResizableSidebarView
          {...defaultProps}
          isCollapsed={true}
          width={250}
        />
      )
      const wrapper = container.querySelector(`.${styles.wrapper}`)
      expect(wrapper).not.toHaveStyle({ width: '250px' })
    })
  })

  describe('collapsed state', () => {
    it('applies collapsed class when isCollapsed is true', () => {
      const { container } = render(
        <ResizableSidebarView {...defaultProps} isCollapsed={true} />
      )
      expect(container.querySelector(`.${styles.wrapper}`)).toHaveClass(
        styles.collapsed
      )
    })

    it('does not apply collapsed class when isCollapsed is false', () => {
      const { container } = render(
        <ResizableSidebarView {...defaultProps} isCollapsed={false} />
      )
      expect(container.querySelector(`.${styles.wrapper}`)).not.toHaveClass(
        styles.collapsed
      )
    })

    it('shows "Expand sidebar" title when collapsed', () => {
      render(<ResizableSidebarView {...defaultProps} isCollapsed={true} />)
      expect(
        screen.getByRole('button', { name: /expand sidebar/i })
      ).toBeInTheDocument()
    })

    it('shows "Collapse sidebar" title when expanded', () => {
      render(<ResizableSidebarView {...defaultProps} isCollapsed={false} />)
      expect(
        screen.getByRole('button', { name: /collapse sidebar/i })
      ).toBeInTheDocument()
    })
  })

  describe('resizing state', () => {
    it('applies resizing class to handle when isResizing is true', () => {
      const { container } = render(
        <ResizableSidebarView {...defaultProps} isResizing={true} />
      )
      expect(container.querySelector(`.${styles.resizeHandle}`)).toHaveClass(
        styles.resizing
      )
    })

    it('does not apply resizing class when isResizing is false', () => {
      const { container } = render(
        <ResizableSidebarView {...defaultProps} isResizing={false} />
      )
      expect(
        container.querySelector(`.${styles.resizeHandle}`)
      ).not.toHaveClass(styles.resizing)
    })
  })

  describe('interactions', () => {
    it('calls onToggleCollapse when collapse button is clicked', async () => {
      const user = userEvent.setup()
      const handleToggle = vi.fn()
      render(
        <ResizableSidebarView
          {...defaultProps}
          onToggleCollapse={handleToggle}
        />
      )

      await user.click(
        screen.getByRole('button', { name: /collapse sidebar/i })
      )

      expect(handleToggle).toHaveBeenCalledTimes(1)
    })

    it('calls onStartResizing when resize handle is mouse downed', () => {
      const handleStartResizing = vi.fn()
      const { container } = render(
        <ResizableSidebarView
          {...defaultProps}
          onStartResizing={handleStartResizing}
        />
      )

      const resizeHandle = container.querySelector(`.${styles.resizeHandle}`)
      fireEvent.mouseDown(resizeHandle!)

      expect(handleStartResizing).toHaveBeenCalledTimes(1)
    })
  })

  describe('ref', () => {
    it('attaches sidebarRef to wrapper element', () => {
      const ref = createRef<HTMLDivElement>()
      render(<ResizableSidebarView {...defaultProps} sidebarRef={ref} />)

      expect(ref.current).toBeInstanceOf(HTMLDivElement)
      expect(ref.current).toHaveClass(styles.wrapper)
    })
  })
})
