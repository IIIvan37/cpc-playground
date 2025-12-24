import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'
import styles from './read-only-project-banner.module.css'
import { ReadOnlyProjectBannerView } from './read-only-project-banner.view'

describe('ReadOnlyProjectBannerView', () => {
  const defaultProps = {
    projectName: 'Test Project',
    onClose: vi.fn()
  }

  describe('rendering', () => {
    it('renders the banner with project name', () => {
      render(<ReadOnlyProjectBannerView {...defaultProps} />)

      expect(screen.getByText('Test Project')).toBeInTheDocument()
      expect(screen.getByText(/read-only mode/)).toBeInTheDocument()
    })

    it('renders close button with title', () => {
      render(<ReadOnlyProjectBannerView {...defaultProps} />)

      expect(
        screen.getByRole('button', { name: /close project/i })
      ).toBeInTheDocument()
    })

    it('applies correct styles', () => {
      const { container } = render(
        <ReadOnlyProjectBannerView {...defaultProps} />
      )

      expect(container.querySelector(`.${styles.banner}`)).toBeInTheDocument()
      expect(
        container.querySelector(`.${styles.projectName}`)
      ).toBeInTheDocument()
    })
  })

  describe('interactions', () => {
    it('calls onClose when close button is clicked', async () => {
      const user = userEvent.setup()
      const handleClose = vi.fn()

      render(
        <ReadOnlyProjectBannerView
          projectName='Test Project'
          onClose={handleClose}
        />
      )

      await user.click(screen.getByRole('button', { name: /close project/i }))

      expect(handleClose).toHaveBeenCalledTimes(1)
    })
  })

  describe('accessibility', () => {
    it('close button has accessible title', () => {
      render(<ReadOnlyProjectBannerView {...defaultProps} />)

      const button = screen.getByRole('button')
      expect(button).toHaveAttribute('title', 'Close project')
    })
  })
})
