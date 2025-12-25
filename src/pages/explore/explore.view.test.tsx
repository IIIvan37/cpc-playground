import { fireEvent, render, screen } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { describe, expect, it, vi } from 'vitest'
import { ExploreListView } from './explore-list.view'

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
    render(
      <ExploreListView
        libraryProjects={[]}
        regularProjects={[]}
        loading
        error={null}
      />
    )
    expect(screen.getByText(/loading projects/i)).toBeInTheDocument()
  })

  it('renders error state', () => {
    render(
      <ExploreListView
        libraryProjects={[]}
        regularProjects={[]}
        error='Oops!'
      />
    )
    expect(screen.getByText('Oops!')).toBeInTheDocument()
  })

  it('renders empty state', () => {
    render(
      <MemoryRouter>
        <ExploreListView libraryProjects={[]} regularProjects={[]} />
      </MemoryRouter>
    )
    expect(screen.getByText(/no projects found/i)).toBeInTheDocument()
    expect(
      screen.getByRole('button', { name: /playground/i })
    ).toBeInTheDocument()
  })

  it('renders a project', () => {
    render(
      <ExploreListView libraryProjects={[]} regularProjects={[baseProject]} />
    )
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
    render(
      <ExploreListView
        libraryProjects={[]}
        regularProjects={[{ ...baseProject, onClick }]}
      />
    )
    fireEvent.click(screen.getByTestId('project-item'))
    expect(onClick).toHaveBeenCalled()
  })

  it('shows badges for owner/shared/public/library', () => {
    render(
      <ExploreListView
        libraryProjects={[
          { ...baseProject, isOwner: true, isShared: false, isLibrary: true }
        ]}
        regularProjects={[
          {
            ...baseProject,
            id: '2',
            isOwner: false,
            isShared: true,
            isLibrary: false
          }
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
        libraryProjects={[]}
        regularProjects={[baseProject]}
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
    render(
      <ExploreListView libraryProjects={[]} regularProjects={[baseProject]} />
    )
    expect(screen.queryByTestId('search-input')).not.toBeInTheDocument()
  })

  it('calls onSearchChange when user types in search input', () => {
    const onSearchChange = vi.fn()
    render(
      <ExploreListView
        libraryProjects={[]}
        regularProjects={[baseProject]}
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
        libraryProjects={[]}
        regularProjects={[]}
        searchQuery='nonexistent'
        onSearchChange={onSearchChange}
      />
    )
    expect(screen.getByText(/no projects found/i)).toBeInTheDocument()
    expect(
      screen.getByText(/try a different search term or filter/i)
    ).toBeInTheDocument()
    expect(screen.queryByText(/be the first to share/i)).not.toBeInTheDocument()
  })

  it('renders libraries and projects in separate sections', () => {
    const libraryProject = {
      ...baseProject,
      id: 'lib-1',
      name: 'My Library',
      isLibrary: true
    }
    const regularProject = {
      ...baseProject,
      id: 'proj-1',
      name: 'My Project',
      isLibrary: false
    }
    render(
      <ExploreListView
        libraryProjects={[libraryProject]}
        regularProjects={[regularProject]}
      />
    )
    expect(screen.getByText('Libraries')).toBeInTheDocument()
    expect(screen.getByText('Projects')).toBeInTheDocument()
    expect(screen.getByText('My Library')).toBeInTheDocument()
    expect(screen.getByText('My Project')).toBeInTheDocument()
  })

  it('hides regular projects when showLibrariesOnly is true', () => {
    const libraryProject = {
      ...baseProject,
      id: 'lib-1',
      name: 'My Library',
      isLibrary: true
    }
    const regularProject = {
      ...baseProject,
      id: 'proj-1',
      name: 'My Project',
      isLibrary: false
    }
    render(
      <ExploreListView
        libraryProjects={[libraryProject]}
        regularProjects={[regularProject]}
        showLibrariesOnly
        onShowLibrariesOnlyChange={vi.fn()}
      />
    )
    expect(screen.getByText('My Library')).toBeInTheDocument()
    expect(screen.queryByText('My Project')).not.toBeInTheDocument()
  })
})
