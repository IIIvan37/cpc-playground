import { render, screen } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { describe, expect, it } from 'vitest'
import { AppHeaderView } from './app-header.view'

const renderWithRouter = (ui: React.ReactElement) => {
  return render(<MemoryRouter>{ui}</MemoryRouter>)
}

describe('AppHeaderView', () => {
  describe('branding', () => {
    it('renders the title', () => {
      renderWithRouter(<AppHeaderView authSection={null} />)
      expect(
        screen.getByRole('heading', { name: 'CPC PLAYGROUND' })
      ).toBeInTheDocument()
    })

    it('renders the subtitle', () => {
      renderWithRouter(<AppHeaderView authSection={null} />)
      expect(
        screen.getByText('Z80 Assembly IDE for Amstrad CPC')
      ).toBeInTheDocument()
    })

    it('title links to explore page', () => {
      renderWithRouter(<AppHeaderView authSection={null} />)
      const link = screen.getByRole('link', { name: 'CPC PLAYGROUND' })
      expect(link).toHaveAttribute('href', '/explore')
    })
  })

  describe('navigation', () => {
    it('renders explore link', () => {
      renderWithRouter(<AppHeaderView authSection={null} />)
      const exploreLink = screen.getByRole('link', { name: 'Explore' })
      expect(exploreLink).toHaveAttribute('href', '/explore')
    })
  })

  describe('authSection slot', () => {
    it('renders authSection content', () => {
      renderWithRouter(
        <AppHeaderView authSection={<button type='button'>Sign In</button>} />
      )
      expect(
        screen.getByRole('button', { name: 'Sign In' })
      ).toBeInTheDocument()
    })

    it('renders complex authSection content', () => {
      renderWithRouter(
        <AppHeaderView
          authSection={
            <div>
              <span>Welcome, User</span>
              <button type='button'>Sign Out</button>
            </div>
          }
        />
      )
      expect(screen.getByText('Welcome, User')).toBeInTheDocument()
      expect(
        screen.getByRole('button', { name: 'Sign Out' })
      ).toBeInTheDocument()
    })
  })

  describe('authModal slot', () => {
    it('does not render authModal when undefined', () => {
      renderWithRouter(<AppHeaderView authSection={null} />)
      expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
    })

    it('renders authModal when provided', () => {
      renderWithRouter(
        <AppHeaderView
          authSection={null}
          authModal={<div role='dialog'>Login Modal</div>}
        />
      )
      expect(screen.getByRole('dialog')).toBeInTheDocument()
      expect(screen.getByText('Login Modal')).toBeInTheDocument()
    })
  })

  describe('GitHub link', () => {
    it('renders GitHub link', () => {
      renderWithRouter(<AppHeaderView authSection={null} />)
      const link = screen.getByRole('link', { name: /github/i })
      expect(link).toHaveAttribute(
        'href',
        'https://github.com/IIIvan37/cpc-playground'
      )
    })

    it('GitHub link opens in new tab', () => {
      renderWithRouter(<AppHeaderView authSection={null} />)
      const link = screen.getByRole('link', { name: /github/i })
      expect(link).toHaveAttribute('target', '_blank')
      expect(link).toHaveAttribute('rel', 'noopener noreferrer')
    })
  })

  describe('Pixsaur link', () => {
    it('renders Pixsaur link', () => {
      renderWithRouter(<AppHeaderView authSection={null} />)
      const link = screen.getByRole('link', { name: /pixsaur/i })
      expect(link).toHaveAttribute('href', 'https://pixsaur.iiivan.org')
    })

    it('Pixsaur link opens in new tab', () => {
      renderWithRouter(<AppHeaderView authSection={null} />)
      const link = screen.getByRole('link', { name: /pixsaur/i })
      expect(link).toHaveAttribute('target', '_blank')
      expect(link).toHaveAttribute('rel', 'noopener noreferrer')
    })
  })
})
