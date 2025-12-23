import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import { Tag, TagsList } from './tag'

describe('Tag', () => {
  it('renders a tag', () => {
    render(<Tag>test-tag</Tag>)
    expect(screen.getByText('test-tag')).toBeInTheDocument()
  })

  it('renders tag as a span', () => {
    const { container } = render(<Tag>test</Tag>)
    const span = container.querySelector('span')
    expect(span).toBeInTheDocument()
    expect(span?.textContent).toBe('test')
  })
})

describe('TagsList', () => {
  it('renders nothing when tags array is empty', () => {
    const { container } = render(<TagsList tags={[]} />)
    expect(container.firstChild).toBeNull()
  })

  it('renders a list of tags', () => {
    render(<TagsList tags={['tag1', 'tag2', 'tag3']} />)
    expect(screen.getByText('tag1')).toBeInTheDocument()
    expect(screen.getByText('tag2')).toBeInTheDocument()
    expect(screen.getByText('tag3')).toBeInTheDocument()
  })

  it('renders tags with correct structure', () => {
    const { container } = render(<TagsList tags={['tag1', 'tag2']} />)
    const tagsList = container.firstChild
    expect(tagsList).toBeInTheDocument()
    const tags = container.querySelectorAll('span')
    expect(tags).toHaveLength(2)
  })
})
