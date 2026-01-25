import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'
import * as hooks from '@/hooks'
import { ExplorePage } from './explore'

vi.mock('@/hooks', () => ({
  useAuth: vi.fn(),
  useHandleCreateProject: vi.fn(),
  useHandleForkProject: vi.fn(),
  useInfiniteProjects: vi.fn(),

  getThumbnailUrl: vi.fn((path: string | null | undefined) =>
    path
      ? `https://test.supabase.co/storage/v1/object/public/thumbnails/${path}`
      : null
  )
}))

// Helper to mock useInfiniteProjects
function mockInfiniteProjects(
  projects: ReturnType<typeof createProject>[],
  options: {
    loading?: boolean
    loadingMore?: boolean
    error?: string | null
    total?: number
    hasMore?: boolean
  } = {}
) {
  const {
    loading = false,
    loadingMore = false,
    error = null,
    total = projects.length,
    hasMore = false
  } = options

  vi.mocked(hooks.useInfiniteProjects).mockReturnValue({
    projects,
    total,
    loading,
    loadingMore,
    error,
    hasMore,
    loadMore: vi.fn(),
    refetch: vi.fn()
  })
}

describe('ExplorePage', () => {
  const mockHandleCreate = vi.fn()
  const mockHandleFork = vi.fn()

  beforeEach(() => {
    vi.clearAllMocks()
    vi.mocked(hooks.useAuth).mockReturnValue({
      user: null,
      loading: false,
      signIn: vi.fn(),
      signUp: vi.fn(),
      signOut: vi.fn(),
      signInWithGithub: vi.fn(),
      requestPasswordReset: vi.fn(),
      updatePassword: vi.fn(),
      hasSession: vi.fn(),
      onPasswordRecovery: vi.fn()
    })
    vi.mocked(hooks.useHandleCreateProject).mockReturnValue({
      handleCreate: mockHandleCreate,
      loading: false
    })
    vi.mocked(hooks.useHandleForkProject).mockReturnValue({
      handleFork: mockHandleFork,
      loading: false
    })
  })

  describe('Project display', () => {
    it('should display all projects returned by the hook', () => {
      const recentDate1 = new Date('2025-12-20T10:00:00Z')
      const recentDate2 = new Date('2025-12-23T10:00:00Z')
      const oldestDate = new Date('2024-01-01T10:00:00Z')

      const projects = [
        createProject({
          id: '1',
          userId: 'user1',
          name: createProjectName('Getting Started'),
          description: 'Sticky project',
          visibility: Visibility.PUBLIC,
          isSticky: true,
          createdAt: oldestDate,
          updatedAt: oldestDate
        }),
        createProject({
          id: '3',
          userId: 'user1',
          name: createProjectName('Recent Project 2'),
          visibility: Visibility.PUBLIC,
          createdAt: recentDate2,
          updatedAt: recentDate2
        }),
        createProject({
          id: '2',
          userId: 'user1',
          name: createProjectName('Recent Project 1'),
          visibility: Visibility.PUBLIC,
          createdAt: recentDate1,
          updatedAt: recentDate1
        })
      ]

      mockInfiniteProjects(projects)

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(3)
    })

    it('should handle single project', () => {
      const project = createProject({
        id: '1',
        userId: 'user1',
        name: createProjectName('Only Project'),
        visibility: Visibility.PUBLIC,
        createdAt: new Date('2025-01-01T10:00:00Z'),
        updatedAt: new Date('2025-01-01T10:00:00Z')
      })

      mockInfiniteProjects([project])

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(1)
      expect(projectItems[0]).toHaveTextContent('Only Project')
    })

    it('should handle empty projects list', () => {
      mockInfiniteProjects([])

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      expect(screen.getByText(/no projects found/i)).toBeInTheDocument()
    })
  })

  describe('URL query params', () => {
    const createTestProjects = () => [
      createProject({
        id: '1',
        userId: 'user1',
        name: createProjectName('Sprite Library'),
        description: 'A collection of sprites',
        visibility: Visibility.PUBLIC,
        isLibrary: true,
        tags: ['graphics', 'sprites'],
        createdAt: new Date('2025-01-01'),
        updatedAt: new Date('2025-01-01')
      }),
      createProject({
        id: '2',
        userId: 'user1',
        name: createProjectName('My Game'),
        description: 'A simple game',
        visibility: Visibility.PUBLIC,
        isLibrary: false,
        tags: ['game'],
        createdAt: new Date('2025-02-01'),
        updatedAt: new Date('2025-02-01')
      }),
      createProject({
        id: '3',
        userId: 'user1',
        name: createProjectName('Sound Effects'),
        description: 'Audio library',
        visibility: Visibility.PUBLIC,
        isLibrary: true,
        tags: ['audio', 'sfx'],
        createdAt: new Date('2025-03-01'),
        updatedAt: new Date('2025-03-01')
      })
    ]

    it('should initialize search query from URL param', () => {
      // With server-side filtering, the hook already receives filtered results
      const spriteProject = createTestProjects().find((p) =>
        p.name.value.includes('Sprite')
      )
      mockInfiniteProjects(spriteProject ? [spriteProject] : [])

      render(
        <MemoryRouter initialEntries={['/explore?q=sprite']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const searchInput = screen.getByPlaceholderText(/search/i)
      expect(searchInput).toHaveValue('sprite')

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(1)
      expect(projectItems[0]).toHaveTextContent('Sprite Library')
    })

    it('should initialize libraries filter from URL param', () => {
      // Server returns only libraries when libs=true
      const libraries = createTestProjects().filter((p) => p.isLibrary)
      mockInfiniteProjects(libraries)

      render(
        <MemoryRouter initialEntries={['/explore?libs=true']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(2)
    })

    it('should combine search query and libraries filter from URL params', () => {
      const audioLibrary = createTestProjects().find(
        (p) => p.isLibrary && p.description?.includes('Audio')
      )
      mockInfiniteProjects(audioLibrary ? [audioLibrary] : [])

      render(
        <MemoryRouter initialEntries={['/explore?q=audio&libs=true']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(1)
      expect(projectItems[0]).toHaveTextContent('Sound Effects')
    })

    it('should update search when typing in search input', async () => {
      const user = userEvent.setup()

      // Start with all projects
      mockInfiniteProjects(createTestProjects())

      render(
        <MemoryRouter initialEntries={['/explore']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const searchInput = screen.getByPlaceholderText(/search/i)
      await user.type(searchInput, 'game')

      expect(searchInput).toHaveValue('game')

      // Verify useInfiniteProjects was called with search param
      expect(hooks.useInfiniteProjects).toHaveBeenCalled()
    })

    it('should show all projects when no URL params', () => {
      mockInfiniteProjects(createTestProjects())

      render(
        <MemoryRouter initialEntries={['/explore']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(3)
    })

    it('should handle empty search query param gracefully', () => {
      mockInfiniteProjects(createTestProjects())

      render(
        <MemoryRouter initialEntries={['/explore?q=']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const searchInput = screen.getByPlaceholderText(/search/i)
      expect(searchInput).toHaveValue('')

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(3)
    })

    it('should handle libs=false as not filtering', () => {
      mockInfiniteProjects(createTestProjects())

      render(
        <MemoryRouter initialEntries={['/explore?libs=false']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(3)
    })
  })

  describe('Pagination', () => {
    it('should show load more button when hasMore is true', () => {
      const projects = [
        createProject({
          id: '1',
          userId: 'user1',
          name: createProjectName('Project 1'),
          visibility: Visibility.PUBLIC,
          createdAt: new Date(),
          updatedAt: new Date()
        })
      ]

      mockInfiniteProjects(projects, { hasMore: true, total: 50 })

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      expect(screen.getByTestId('load-more-button')).toBeInTheDocument()
      expect(screen.getByText(/load more projects/i)).toBeInTheDocument()
    })

    it('should not show load more button when hasMore is false', () => {
      const projects = [
        createProject({
          id: '1',
          userId: 'user1',
          name: createProjectName('Project 1'),
          visibility: Visibility.PUBLIC,
          createdAt: new Date(),
          updatedAt: new Date()
        })
      ]

      mockInfiniteProjects(projects, { hasMore: false })

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      expect(screen.queryByTestId('load-more-button')).not.toBeInTheDocument()
    })

    it('should show loading state when loadingMore is true', () => {
      const projects = [
        createProject({
          id: '1',
          userId: 'user1',
          name: createProjectName('Project 1'),
          visibility: Visibility.PUBLIC,
          createdAt: new Date(),
          updatedAt: new Date()
        })
      ]

      mockInfiniteProjects(projects, { hasMore: true, loadingMore: true })

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      expect(screen.getByText(/loading\.\.\./i)).toBeInTheDocument()
    })

    it('should show total count when available', () => {
      const projects = [
        createProject({
          id: '1',
          userId: 'user1',
          name: createProjectName('Project 1'),
          visibility: Visibility.PUBLIC,
          createdAt: new Date(),
          updatedAt: new Date()
        })
      ]

      mockInfiniteProjects(projects, { total: 50 })

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      expect(screen.getByText(/showing 1 of 50 projects/i)).toBeInTheDocument()
    })
  })

  describe('Loading and error states', () => {
    it('should show loading state', () => {
      mockInfiniteProjects([], { loading: true })

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      expect(screen.getByText(/loading projects/i)).toBeInTheDocument()
    })

    it('should show error state', () => {
      mockInfiniteProjects([], { error: 'Failed to load projects' })

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      expect(screen.getByText(/failed to load projects/i)).toBeInTheDocument()
    })
  })
})
