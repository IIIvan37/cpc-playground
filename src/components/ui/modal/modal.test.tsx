import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'
import { Modal } from './modal'
import styles from './modal.module.css'

describe('Modal', () => {
  describe('visibility', () => {
    it('renders nothing when open is false', () => {
      render(
        <Modal open={false} onClose={vi.fn()}>
          Content
        </Modal>
      )
      expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
    })

    it('renders dialog when open is true', () => {
      render(
        <Modal open={true} onClose={vi.fn()}>
          Content
        </Modal>
      )
      expect(screen.getByRole('dialog')).toBeInTheDocument()
    })
  })

  describe('content', () => {
    it('renders children', () => {
      render(
        <Modal open={true} onClose={vi.fn()}>
          <p>Modal content</p>
        </Modal>
      )
      expect(screen.getByText('Modal content')).toBeInTheDocument()
    })

    it('renders title when provided', () => {
      render(
        <Modal open={true} onClose={vi.fn()} title='Modal Title'>
          Content
        </Modal>
      )
      expect(
        screen.getByRole('heading', { name: 'Modal Title' })
      ).toBeInTheDocument()
    })

    it('does not render title when not provided', () => {
      render(
        <Modal open={true} onClose={vi.fn()}>
          Content
        </Modal>
      )
      expect(screen.queryByRole('heading')).not.toBeInTheDocument()
    })

    it('renders actions when provided', () => {
      render(
        <Modal
          open={true}
          onClose={vi.fn()}
          actions={<button type='button'>Save</button>}
        >
          Content
        </Modal>
      )
      expect(screen.getByRole('button', { name: 'Save' })).toBeInTheDocument()
    })
  })

  describe('close button', () => {
    it('shows close button by default', () => {
      render(
        <Modal open={true} onClose={vi.fn()}>
          Content
        </Modal>
      )
      expect(screen.getByRole('button', { name: /close/i })).toBeInTheDocument()
    })

    it('hides close button when showCloseButton is false', () => {
      render(
        <Modal open={true} onClose={vi.fn()} showCloseButton={false}>
          Content
        </Modal>
      )
      expect(
        screen.queryByRole('button', { name: /close/i })
      ).not.toBeInTheDocument()
    })

    it('calls onClose when close button is clicked', async () => {
      const user = userEvent.setup()
      const handleClose = vi.fn()
      render(
        <Modal open={true} onClose={handleClose}>
          Content
        </Modal>
      )

      await user.click(screen.getByRole('button', { name: /close/i }))

      expect(handleClose).toHaveBeenCalledTimes(1)
    })
  })

  describe('keyboard', () => {
    it('calls onClose when Escape is pressed', async () => {
      const user = userEvent.setup()
      const handleClose = vi.fn()
      render(
        <Modal open={true} onClose={handleClose}>
          Content
        </Modal>
      )

      await user.keyboard('{Escape}')

      expect(handleClose).toHaveBeenCalledTimes(1)
    })
  })

  describe('sizes', () => {
    it('applies medium size by default', () => {
      render(
        <Modal open={true} onClose={vi.fn()}>
          Content
        </Modal>
      )
      const dialog = screen.getByRole('dialog')
      const modal = dialog.querySelector(`.${styles.modal}`)
      expect(modal).toHaveClass(styles.sizeMd)
    })

    it('applies small size when specified', () => {
      render(
        <Modal open={true} onClose={vi.fn()} size='sm'>
          Content
        </Modal>
      )
      const dialog = screen.getByRole('dialog')
      const modal = dialog.querySelector(`.${styles.modal}`)
      expect(modal).toHaveClass(styles.sizeSm)
    })

    it('applies large size when specified', () => {
      render(
        <Modal open={true} onClose={vi.fn()} size='lg'>
          Content
        </Modal>
      )
      const dialog = screen.getByRole('dialog')
      const modal = dialog.querySelector(`.${styles.modal}`)
      expect(modal).toHaveClass(styles.sizeLg)
    })

    it('applies extra large size when specified', () => {
      render(
        <Modal open={true} onClose={vi.fn()} size='xl'>
          Content
        </Modal>
      )
      const dialog = screen.getByRole('dialog')
      const modal = dialog.querySelector(`.${styles.modal}`)
      expect(modal).toHaveClass(styles.sizeXl)
    })
  })

  describe('custom className', () => {
    it('applies custom className to modal', () => {
      render(
        <Modal open={true} onClose={vi.fn()} className='custom-modal'>
          Content
        </Modal>
      )
      const dialog = screen.getByRole('dialog')
      expect(dialog.querySelector('.custom-modal')).toBeInTheDocument()
    })
  })
})
