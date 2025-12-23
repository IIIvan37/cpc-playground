import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { createRef } from 'react'
import { describe, expect, it, vi } from 'vitest'
import styles from './console-panel.module.css'
import { ConsolePanelView } from './console-panel.view'

describe('ConsolePanelView', () => {
  const defaultProps = {
    messages: [],
    messagesRef: createRef<HTMLDivElement>(),
    onClear: vi.fn(),
    onLineClick: vi.fn()
  }

  describe('rendering', () => {
    it('renders the console title', () => {
      render(<ConsolePanelView {...defaultProps} />)
      expect(screen.getByText('Console')).toBeInTheDocument()
    })

    it('renders clear button', () => {
      render(<ConsolePanelView {...defaultProps} />)
      expect(screen.getByRole('button', { name: '✕' })).toBeInTheDocument()
    })

    it('renders empty messages container when no messages', () => {
      const { container } = render(<ConsolePanelView {...defaultProps} />)
      expect(container.querySelector(`.${styles.messages}`)).toBeInTheDocument()
    })
  })

  describe('messages', () => {
    const mockMessages = [
      {
        id: '1',
        type: 'info' as const,
        text: 'Info message',
        timestamp: new Date('2024-01-01T10:00:00')
      },
      {
        id: '2',
        type: 'error' as const,
        text: 'Error message',
        timestamp: new Date('2024-01-01T10:00:01')
      },
      {
        id: '3',
        type: 'success' as const,
        text: 'Success message',
        timestamp: new Date('2024-01-01T10:00:02')
      },
      {
        id: '4',
        type: 'warning' as const,
        text: 'Warning message',
        timestamp: new Date('2024-01-01T10:00:03')
      }
    ]

    it('renders all messages', () => {
      render(<ConsolePanelView {...defaultProps} messages={mockMessages} />)

      expect(screen.getByText('Info message')).toBeInTheDocument()
      expect(screen.getByText('Error message')).toBeInTheDocument()
      expect(screen.getByText('Success message')).toBeInTheDocument()
      expect(screen.getByText('Warning message')).toBeInTheDocument()
    })

    it('renders timestamps for messages', () => {
      render(
        <ConsolePanelView {...defaultProps} messages={[mockMessages[0]]} />
      )
      expect(screen.getByText(/10:00:00/)).toBeInTheDocument()
    })
  })

  describe('clickable messages', () => {
    it('renders clickable message as button when line is provided', () => {
      const messageWithLine = {
        id: '1',
        type: 'error' as const,
        text: 'Error at line',
        timestamp: new Date(),
        line: 42
      }

      render(
        <ConsolePanelView {...defaultProps} messages={[messageWithLine]} />
      )

      const button = screen.getByRole('button', { name: /Error at line/i })
      expect(button).toBeInTheDocument()
    })

    it('shows line hint for clickable messages', () => {
      const messageWithLine = {
        id: '1',
        type: 'error' as const,
        text: 'Error at line',
        timestamp: new Date(),
        line: 42
      }

      render(
        <ConsolePanelView {...defaultProps} messages={[messageWithLine]} />
      )

      expect(screen.getByText('(line 42)')).toBeInTheDocument()
    })

    it('calls onLineClick when clickable message is clicked', async () => {
      const user = userEvent.setup()
      const handleLineClick = vi.fn()
      const messageWithLine = {
        id: '1',
        type: 'error' as const,
        text: 'Error at line',
        timestamp: new Date(),
        line: 42
      }

      render(
        <ConsolePanelView
          {...defaultProps}
          messages={[messageWithLine]}
          onLineClick={handleLineClick}
        />
      )

      await user.click(screen.getByRole('button', { name: /Error at line/i }))

      expect(handleLineClick).toHaveBeenCalledWith(42)
    })
  })

  describe('interactions', () => {
    it('calls onClear when clear button is clicked', async () => {
      const user = userEvent.setup()
      const handleClear = vi.fn()

      render(<ConsolePanelView {...defaultProps} onClear={handleClear} />)

      await user.click(screen.getByRole('button', { name: '✕' }))

      expect(handleClear).toHaveBeenCalledTimes(1)
    })
  })

  describe('messagesRef', () => {
    it('attaches ref to messages container', () => {
      const ref = createRef<HTMLDivElement>()

      render(<ConsolePanelView {...defaultProps} messagesRef={ref} />)

      expect(ref.current).toBeInstanceOf(HTMLDivElement)
      expect(ref.current).toHaveClass(styles.messages)
    })
  })
})
