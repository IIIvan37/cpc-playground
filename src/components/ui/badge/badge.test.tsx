import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import { Badge } from './badge'
import styles from './badge.module.css'

describe('Badge', () => {
  describe('rendering', () => {
    it('renders children text', () => {
      render(<Badge variant='info'>Test Badge</Badge>)
      expect(screen.getByText('Test Badge')).toBeInTheDocument()
    })

    it('renders as span element', () => {
      render(<Badge variant='info'>Badge</Badge>)
      expect(screen.getByText('Badge').tagName).toBe('SPAN')
    })

    it('applies base badge class', () => {
      render(<Badge variant='info'>Badge</Badge>)
      expect(screen.getByText('Badge')).toHaveClass(styles.badge)
    })
  })

  describe('variants', () => {
    it('applies public variant class', () => {
      render(<Badge variant='public'>Public</Badge>)
      expect(screen.getByText('Public')).toHaveClass(styles.public)
    })

    it('applies shared variant class', () => {
      render(<Badge variant='shared'>Shared</Badge>)
      expect(screen.getByText('Shared')).toHaveClass(styles.shared)
    })

    it('applies owner variant class', () => {
      render(<Badge variant='owner'>Owner</Badge>)
      expect(screen.getByText('Owner')).toHaveClass(styles.owner)
    })

    it('applies library variant class', () => {
      render(<Badge variant='library'>Library</Badge>)
      expect(screen.getByText('Library')).toHaveClass(styles.library)
    })

    it('applies readOnly variant class', () => {
      render(<Badge variant='readOnly'>Read-only</Badge>)
      expect(screen.getByText('Read-only')).toHaveClass(styles.readOnly)
    })

    it('applies info variant class', () => {
      render(<Badge variant='info'>Info</Badge>)
      expect(screen.getByText('Info')).toHaveClass(styles.info)
    })

    it('applies success variant class', () => {
      render(<Badge variant='success'>Success</Badge>)
      expect(screen.getByText('Success')).toHaveClass(styles.success)
    })

    it('applies warning variant class', () => {
      render(<Badge variant='warning'>Warning</Badge>)
      expect(screen.getByText('Warning')).toHaveClass(styles.warning)
    })

    it('applies error variant class', () => {
      render(<Badge variant='error'>Error</Badge>)
      expect(screen.getByText('Error')).toHaveClass(styles.error)
    })
  })

  describe('custom className', () => {
    it('applies custom className', () => {
      render(
        <Badge variant='info' className='custom-class'>
          Badge
        </Badge>
      )
      expect(screen.getByText('Badge')).toHaveClass('custom-class')
    })

    it('combines base, variant, and custom classes', () => {
      render(
        <Badge variant='success' className='my-badge'>
          Combined
        </Badge>
      )
      const badge = screen.getByText('Combined')
      expect(badge).toHaveClass(styles.badge)
      expect(badge).toHaveClass(styles.success)
      expect(badge).toHaveClass('my-badge')
    })
  })
})
