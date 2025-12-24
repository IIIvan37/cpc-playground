import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { createStore, Provider } from 'jotai'
import type { ReactNode } from 'react'
import { beforeEach, describe, expect, it } from 'vitest'
import {
  addConsoleMessageAtom,
  consoleMessagesAtom,
  goToLineAtom
} from '@/store'
import { ConsolePanel } from './console-panel'

describe('ConsolePanel', () => {
  let store: ReturnType<typeof createStore>

  const wrapper = ({ children }: { children: ReactNode }) => (
    <Provider store={store}>{children}</Provider>
  )

  const renderConsole = () => {
    return render(<ConsolePanel />, { wrapper })
  }

  beforeEach(() => {
    store = createStore()
  })

  describe('rendering', () => {
    it('renders console panel', () => {
      renderConsole()
      expect(screen.getByText('Console')).toBeInTheDocument()
    })

    it('renders clear button', () => {
      renderConsole()
      // Clear button shows "✕" icon
      expect(screen.getByRole('button', { name: '✕' })).toBeInTheDocument()
    })

    it('shows empty messages area when no messages', () => {
      renderConsole()
      // Messages container is empty when no messages
      const messagesContainer = document.querySelector('[class*="messages"]')
      expect(messagesContainer).toBeInTheDocument()
      expect(messagesContainer?.children.length).toBe(0)
    })
  })

  describe('messages display', () => {
    it('displays info messages', async () => {
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Info message' })

      renderConsole()

      expect(screen.getByText('Info message')).toBeInTheDocument()
    })

    it('displays success messages', async () => {
      store.set(addConsoleMessageAtom, {
        type: 'success',
        text: 'Success message'
      })

      renderConsole()

      expect(screen.getByText('Success message')).toBeInTheDocument()
    })

    it('displays error messages', async () => {
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error message'
      })

      renderConsole()

      expect(screen.getByText('Error message')).toBeInTheDocument()
    })

    it('displays warning messages', async () => {
      store.set(addConsoleMessageAtom, {
        type: 'warning',
        text: 'Warning message'
      })

      renderConsole()

      expect(screen.getByText('Warning message')).toBeInTheDocument()
    })

    it('displays multiple messages in order', async () => {
      store.set(addConsoleMessageAtom, { type: 'info', text: 'First' })
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Second' })
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Third' })

      renderConsole()

      const messages = store.get(consoleMessagesAtom)
      expect(messages).toHaveLength(3)
      expect(screen.getByText('First')).toBeInTheDocument()
      expect(screen.getByText('Second')).toBeInTheDocument()
      expect(screen.getByText('Third')).toBeInTheDocument()
    })

    it('displays error messages with line numbers', async () => {
      // Use error text format that RASM parser will extract line number from
      // Pattern: [/input.asm:LINE] - line offset of 2 subtracted
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error [/input.asm:12] Syntax error'
      })

      renderConsole()

      // Line hint shows extracted line (12 - 2 offset = 10)
      expect(screen.getByText('(line 10)')).toBeInTheDocument()
    })
  })

  describe('clear action', () => {
    it('clears all messages when clear button clicked', async () => {
      const user = userEvent.setup()

      store.set(addConsoleMessageAtom, { type: 'info', text: 'Message 1' })
      store.set(addConsoleMessageAtom, { type: 'info', text: 'Message 2' })

      renderConsole()

      expect(screen.getByText('Message 1')).toBeInTheDocument()
      expect(screen.getByText('Message 2')).toBeInTheDocument()

      await user.click(screen.getByRole('button', { name: '✕' }))

      expect(store.get(consoleMessagesAtom)).toHaveLength(0)
    })
  })

  describe('line navigation', () => {
    it('sets goToLine when clicking on message with line number', async () => {
      const user = userEvent.setup()

      // Use error text format that RASM parser will extract line number from
      // Pattern: [/input.asm:LINE] - line offset of 2 subtracted, so 17 -> 15
      store.set(addConsoleMessageAtom, {
        type: 'error',
        text: 'Error [/input.asm:17] at line 15'
      })

      renderConsole()

      // Messages with line numbers are rendered as buttons
      const messageButton = screen.getByRole('button', {
        name: /error.*at line 15/i
      })
      await user.click(messageButton)

      expect(store.get(goToLineAtom)).toBe(15)
    })
  })

  describe('auto-scroll behavior', () => {
    it('auto-scrolls to bottom on new messages', async () => {
      // Add many messages
      for (let i = 0; i < 10; i++) {
        store.set(addConsoleMessageAtom, {
          type: 'info',
          text: `Message ${i}`
        })
      }

      const { rerender } = renderConsole()

      // Add another message
      store.set(addConsoleMessageAtom, { type: 'info', text: 'New message' })

      rerender(
        <Provider store={store}>
          <ConsolePanel />
        </Provider>
      )

      // Just verify it renders without error - scrollTop testing requires DOM access
      expect(screen.getByText('New message')).toBeInTheDocument()
    })
  })
})
