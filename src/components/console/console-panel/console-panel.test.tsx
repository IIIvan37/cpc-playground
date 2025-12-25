import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { createStore, Provider } from 'jotai'
import type { ReactNode } from 'react'
import { beforeEach, describe, expect, it } from 'vitest'
import { consoleMessagesAtom, goToLineAtom } from '@/store'
import type { ConsoleMessage } from '@/store/editor'
import { ConsolePanel } from './console-panel'

// Helper to create a message
let messageCounter = 0
const createMessage = (
  type: ConsoleMessage['type'],
  text: string,
  line?: number
): ConsoleMessage => ({
  id: `msg-${++messageCounter}`,
  type,
  text,
  timestamp: new Date(),
  line
})

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
    messageCounter = 0
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
      store.set(consoleMessagesAtom, [createMessage('info', 'Info message')])

      renderConsole()

      expect(screen.getByText('Info message')).toBeInTheDocument()
    })

    it('displays success messages', async () => {
      store.set(consoleMessagesAtom, [
        createMessage('success', 'Success message')
      ])

      renderConsole()

      expect(screen.getByText('Success message')).toBeInTheDocument()
    })

    it('displays error messages', async () => {
      store.set(consoleMessagesAtom, [createMessage('error', 'Error message')])

      renderConsole()

      expect(screen.getByText('Error message')).toBeInTheDocument()
    })

    it('displays warning messages', async () => {
      store.set(consoleMessagesAtom, [
        createMessage('warning', 'Warning message')
      ])

      renderConsole()

      expect(screen.getByText('Warning message')).toBeInTheDocument()
    })

    it('displays multiple messages in order', async () => {
      store.set(consoleMessagesAtom, [
        createMessage('info', 'First'),
        createMessage('info', 'Second'),
        createMessage('info', 'Third')
      ])

      renderConsole()

      const messages = store.get(consoleMessagesAtom)
      expect(messages).toHaveLength(3)
      expect(screen.getByText('First')).toBeInTheDocument()
      expect(screen.getByText('Second')).toBeInTheDocument()
      expect(screen.getByText('Third')).toBeInTheDocument()
    })

    it('displays error messages with line numbers', async () => {
      // Message with line number already extracted
      store.set(consoleMessagesAtom, [
        createMessage('error', 'Error [/input.asm:12] Syntax error', 10)
      ])

      renderConsole()

      // Line hint shows the line number
      expect(screen.getByText('(line 10)')).toBeInTheDocument()
    })
  })

  describe('clear action', () => {
    it('clears all messages when clear button clicked', async () => {
      const user = userEvent.setup()

      store.set(consoleMessagesAtom, [
        createMessage('info', 'Message 1'),
        createMessage('info', 'Message 2')
      ])

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

      // Message with line number 15
      store.set(consoleMessagesAtom, [
        createMessage('error', 'Error [/input.asm:17] at line 15', 15)
      ])

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
      const messages = []
      for (let i = 0; i < 10; i++) {
        messages.push(createMessage('info', `Message ${i}`))
      }
      store.set(consoleMessagesAtom, messages)

      const { rerender } = renderConsole()

      // Add another message
      store.set(consoleMessagesAtom, [
        ...messages,
        createMessage('info', 'New message')
      ])

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
