import { fireEvent, render, screen } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'
import { ExploreListView } from './explore.view'

describe('ExploreListView', () => {
  const baseProject = {
    id: '1',
    name: 'Test Project',
    authorName: 'testuser',
    description: 'A test project',
    tags: ['asm', 'demo'],
    isOwner: false,
    isShared: false,
    visibility: 'public',
    isLibrary: false,
    filesCount: 2,
    sharesCount: 1,
    updatedAt: new Date('2025-12-20T12:00:00Z'),
    createdAt: new Date('2025-12-20T10:00:00Z'),
    onClick: vi.fn()
  }

  it('renders loading state', () => {
    render(<ExploreListView projects={[]} loading error={null} />)
    expect(screen.getByText(/loading projects/i)).toBeInTheDocument()
  })

  it('renders error state', () => {
    render(<ExploreListView projects={[]} error='Oops!' />)
    expect(screen.getByText('Oops!')).toBeInTheDocument()
  })

  it('renders empty state', () => {
    render(<ExploreListView projects={[]} />)
    expect(screen.getByText(/no projects found/i)).toBeInTheDocument()
  })

  it('renders a project', () => {
    render(<ExploreListView projects={[baseProject]} />)
    expect(screen.getByText('Test Project')).toBeInTheDocument()
    expect(screen.getByText('A test project')).toBeInTheDocument()
    expect(screen.getByText('asm')).toBeInTheDocument()
    expect(screen.getByText('demo')).toBeInTheDocument()
    expect(screen.getByText(/2 files/)).toBeInTheDocument()
    expect(screen.getByText(/1 share/)).toBeInTheDocument()
    expect(screen.getByText(/Updated/)).toBeInTheDocument()
  })

  it('calls onClick when project is clicked', () => {
    const onClick = vi.fn()
    render(<ExploreListView projects={[{ ...baseProject, onClick }]} />)
    fireEvent.click(screen.getByTestId('project-item'))
    expect(onClick).toHaveBeenCalled()
  })

  it('shows badges for owner/shared/public/library', () => {
    render(
      <ExploreListView
        projects={[
          { ...baseProject, isOwner: true, isShared: false, isLibrary: true },
          { ...baseProject, isOwner: false, isShared: true, isLibrary: false }
        ]}
      />
    )
    expect(screen.getAllByText('Owner')[0]).toBeInTheDocument()
    expect(screen.getAllByText('Library')[0]).toBeInTheDocument()
    expect(screen.getAllByText('Shared')[0]).toBeInTheDocument()
    expect(screen.getAllByText('Public')[0]).toBeInTheDocument()
  })

  it('renders search input when onSearchChange is provided', () => {
    const onSearchChange = vi.fn()
    render(
      <ExploreListView
        projects={[baseProject]}
        searchQuery=''
        onSearchChange={onSearchChange}
      />
    )
    const searchInput = screen.getByTestId('search-input')
    expect(searchInput).toBeInTheDocument()
    expect(searchInput).toHaveAttribute(
      'placeholder',
      'Search by name, author, or tag...'
    )
  })

  it('does not render search input when onSearchChange is not provided', () => {
    render(<ExploreListView projects={[baseProject]} />)
    expect(screen.queryByTestId('search-input')).not.toBeInTheDocument()
  })

  it('calls onSearchChange when user types in search input', () => {
    const onSearchChange = vi.fn()
    render(
      <ExploreListView
        projects={[baseProject]}
        searchQuery=''
        onSearchChange={onSearchChange}
      />
    )
    const searchInput = screen.getByTestId('search-input')
    fireEvent.change(searchInput, { target: { value: 'test' } })
    expect(onSearchChange).toHaveBeenCalledWith('test')
  })

  it('shows "Try a different search term" when no results found with search query', () => {
    const onSearchChange = vi.fn()
    render(
      <ExploreListView
        projects={[]}
        searchQuery='nonexistent'
        onSearchChange={onSearchChange}
      />
    )
    expect(screen.getByText(/no projects found/i)).toBeInTheDocument()
    expect(screen.getByText(/try a different search term/i)).toBeInTheDocument()
    expect(screen.queryByText(/be the first to share/i)).not.toBeInTheDocument()
  })
})
