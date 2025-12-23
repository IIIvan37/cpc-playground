import { render, screen, waitFor } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import { MarkdownPreviewView } from './markdown-preview'
import styles from './markdown-preview.module.css'

describe('MarkdownPreview', () => {
  describe('rendering', () => {
    it('renders markdown content as HTML', async () => {
      render(<MarkdownPreviewView content='# Hello World' />)
      await waitFor(() => {
        expect(
          screen.getByRole('heading', { name: 'Hello World', level: 1 })
        ).toBeInTheDocument()
      })
    })

    it('renders paragraphs', async () => {
      render(<MarkdownPreviewView content='This is a paragraph' />)
      await waitFor(() => {
        expect(screen.getByText('This is a paragraph')).toBeInTheDocument()
      })
    })

    it('renders bold text', async () => {
      render(<MarkdownPreviewView content='**bold text**' />)
      await waitFor(() => {
        expect(screen.getByText('bold text')).toBeInTheDocument()
        expect(screen.getByText('bold text').tagName).toBe('STRONG')
      })
    })

    it('renders italic text', async () => {
      render(<MarkdownPreviewView content='*italic text*' />)
      await waitFor(() => {
        expect(screen.getByText('italic text')).toBeInTheDocument()
        expect(screen.getByText('italic text').tagName).toBe('EM')
      })
    })

    it('renders links', async () => {
      render(<MarkdownPreviewView content='[Link](https://example.com)' />)
      await waitFor(() => {
        const link = screen.getByRole('link', { name: 'Link' })
        expect(link).toBeInTheDocument()
        expect(link).toHaveAttribute('href', 'https://example.com')
      })
    })

    it('renders unordered lists', async () => {
      render(
        <MarkdownPreviewView
          content={`- Item 1
- Item 2
- Item 3`}
        />
      )
      await waitFor(() => {
        expect(screen.getByText('Item 1')).toBeInTheDocument()
        expect(screen.getByText('Item 2')).toBeInTheDocument()
        expect(screen.getByText('Item 3')).toBeInTheDocument()
      })
    })

    it('renders ordered lists', async () => {
      render(
        <MarkdownPreviewView
          content={`1. First
2. Second
3. Third`}
        />
      )
      await waitFor(() => {
        expect(screen.getByText('First')).toBeInTheDocument()
        expect(screen.getByText('Second')).toBeInTheDocument()
        expect(screen.getByText('Third')).toBeInTheDocument()
      })
    })

    it('renders code blocks', async () => {
      render(
        <MarkdownPreviewView
          content={`\`\`\`
const x = 1;
\`\`\``}
        />
      )
      await waitFor(() => {
        expect(screen.getByText('const x = 1;')).toBeInTheDocument()
      })
    })

    it('renders inline code', async () => {
      render(<MarkdownPreviewView content='Use `const` for constants' />)
      await waitFor(() => {
        expect(screen.getByText('const').tagName).toBe('CODE')
      })
    })

    it('renders blockquotes', async () => {
      render(<MarkdownPreviewView content='> This is a quote' />)
      await waitFor(() => {
        expect(screen.getByText('This is a quote')).toBeInTheDocument()
      })
    })

    it('renders multiple heading levels', async () => {
      render(
        <MarkdownPreviewView
          content={`# H1
## H2
### H3
#### H4
##### H5
###### H6`}
        />
      )
      await waitFor(() => {
        expect(screen.getByRole('heading', { level: 1 })).toHaveTextContent(
          'H1'
        )
        expect(screen.getByRole('heading', { level: 2 })).toHaveTextContent(
          'H2'
        )
        expect(screen.getByRole('heading', { level: 3 })).toHaveTextContent(
          'H3'
        )
        expect(screen.getByRole('heading', { level: 4 })).toHaveTextContent(
          'H4'
        )
        expect(screen.getByRole('heading', { level: 5 })).toHaveTextContent(
          'H5'
        )
        expect(screen.getByRole('heading', { level: 6 })).toHaveTextContent(
          'H6'
        )
      })
    })
  })

  describe('empty state', () => {
    it('shows empty state when content is empty', () => {
      const { container } = render(<MarkdownPreviewView content='' />)
      expect(container.querySelector(`.${styles.empty}`)).toBeInTheDocument()
    })

    it('shows empty state when content is only whitespace', () => {
      const { container } = render(
        <MarkdownPreviewView content={`   \n\t  `} />
      )
      expect(container.querySelector(`.${styles.empty}`)).toBeInTheDocument()
    })

    it('shows helpful message in empty state', () => {
      render(<MarkdownPreviewView content='' />)
      expect(screen.getByText(/start writing markdown/i)).toBeInTheDocument()
    })

    it('does not show empty state when content exists', () => {
      const { container } = render(<MarkdownPreviewView content='Hello' />)
      expect(
        container.querySelector(`.${styles.empty}`)
      ).not.toBeInTheDocument()
    })
  })

  describe('container styling', () => {
    it('applies container class', () => {
      const { container } = render(<MarkdownPreviewView content='# Test' />)
      expect(
        container.querySelector(`.${styles.container}`)
      ).toBeInTheDocument()
    })

    it('applies content class', () => {
      const { container } = render(<MarkdownPreviewView content='# Test' />)
      expect(container.querySelector(`.${styles.content}`)).toBeInTheDocument()
    })
  })
})
