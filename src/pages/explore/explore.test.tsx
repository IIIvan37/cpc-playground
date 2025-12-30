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
  useFetchVisibleProjects: vi.fn(),

  getThumbnailUrl: vi.fn((path: string | null | undefined) =>
    path
      ? `https://test.supabase.co/storage/v1/object/public/thumbnails/${path}`
      : null
  )
}))

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

  describe('Project sorting', () => {
    it('should pin the oldest project (documentation) at the top', () => {
      const oldestDate = new Date('2024-01-01T10:00:00Z')
      const recentDate1 = new Date('2025-12-20T10:00:00Z')
      const recentDate2 = new Date('2025-12-23T10:00:00Z')

      const projects = [
        createProject({
          id: '2',
          userId: 'user1',
          name: createProjectName('Recent Project 1'),
          visibility: Visibility.PUBLIC,
          createdAt: recentDate1,
          updatedAt: recentDate1
        }),
        createProject({
          id: '1',
          userId: 'user1',
          name: createProjectName('Documentation'),
          description: 'Doc project',
          visibility: Visibility.PUBLIC,
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
        })
      ]

      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects,
        loading: false,
        error: null
      })

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(3)

      // First project should be the documentation (oldest)
      expect(projectItems[0]).toHaveTextContent('Documentation')

      // Next should be the most recent projects in descending order
      expect(projectItems[1]).toHaveTextContent('Recent Project 2')
      expect(projectItems[2]).toHaveTextContent('Recent Project 1')
    })

    it('should sort remaining projects by createdAt descending', () => {
      const date1 = new Date('2025-01-01T10:00:00Z')
      const date2 = new Date('2025-06-01T10:00:00Z')
      const date3 = new Date('2025-12-01T10:00:00Z')
      const oldestDate = new Date('2024-01-01T10:00:00Z')

      const projects = [
        createProject({
          id: '1',
          userId: 'user1',
          name: createProjectName('January Project'),
          visibility: Visibility.PUBLIC,
          createdAt: date1,
          updatedAt: date1
        }),
        createProject({
          id: '2',
          userId: 'user1',
          name: createProjectName('December Project'),
          visibility: Visibility.PUBLIC,
          createdAt: date3,
          updatedAt: date3
        }),
        createProject({
          id: '3',
          userId: 'user1',
          name: createProjectName('June Project'),
          visibility: Visibility.PUBLIC,
          createdAt: date2,
          updatedAt: date2
        }),
        createProject({
          id: '0',
          userId: 'user1',
          name: createProjectName('Documentation'),
          visibility: Visibility.PUBLIC,
          createdAt: oldestDate,
          updatedAt: oldestDate
        })
      ]

      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects,
        loading: false,
        error: null
      })

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(4)

      // First should be documentation (oldest)
      expect(projectItems[0]).toHaveTextContent('Documentation')

      // Rest should be sorted by createdAt descending
      expect(projectItems[1]).toHaveTextContent('December Project')
      expect(projectItems[2]).toHaveTextContent('June Project')
      expect(projectItems[3]).toHaveTextContent('January Project')
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

      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects: [project],
        loading: false,
        error: null
      })

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
      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects: [],
        loading: false,
        error: null
      })

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      expect(screen.getByText(/no projects found/i)).toBeInTheDocument()
    })

    it('should handle projects with same createdAt dates', () => {
      const sameDate = new Date('2025-06-01T10:00:00Z')
      const oldestDate = new Date('2024-01-01T10:00:00Z')

      const projects = [
        createProject({
          id: '1',
          userId: 'user1',
          name: createProjectName('Project A'),
          visibility: Visibility.PUBLIC,
          createdAt: sameDate,
          updatedAt: sameDate
        }),
        createProject({
          id: '2',
          userId: 'user1',
          name: createProjectName('Project B'),
          visibility: Visibility.PUBLIC,
          createdAt: sameDate,
          updatedAt: sameDate
        }),
        createProject({
          id: '0',
          userId: 'user1',
          name: createProjectName('Documentation'),
          visibility: Visibility.PUBLIC,
          createdAt: oldestDate,
          updatedAt: oldestDate
        })
      ]

      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects,
        loading: false,
        error: null
      })

      render(
        <MemoryRouter>
          <ExplorePage />
        </MemoryRouter>
      )

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(3)

      // First should be documentation (oldest)
      expect(projectItems[0]).toHaveTextContent('Documentation')

      // Projects A and B can be in any order since they have the same date
      const projectNames = projectItems.map((item) => item.textContent)
      expect(projectNames.some((text) => text?.includes('Project A'))).toBe(
        true
      )
      expect(projectNames.some((text) => text?.includes('Project B'))).toBe(
        true
      )
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
      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects: createTestProjects(),
        loading: false,
        error: null
      })

      render(
        <MemoryRouter initialEntries={['/explore?q=sprite']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const searchInput = screen.getByPlaceholderText(/search/i)
      expect(searchInput).toHaveValue('sprite')

      // Should only show projects matching "sprite"
      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(1)
      expect(projectItems[0]).toHaveTextContent('Sprite Library')
    })

    it('should initialize libraries filter from URL param', () => {
      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects: createTestProjects(),
        loading: false,
        error: null
      })

      render(
        <MemoryRouter initialEntries={['/explore?libs=true']}>
          <ExplorePage />
        </MemoryRouter>
      )

      // Should only show library projects
      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(2)
      expect(
        projectItems.some((item) =>
          item.textContent?.includes('Sprite Library')
        )
      ).toBe(true)
      expect(
        projectItems.some((item) => item.textContent?.includes('Sound Effects'))
      ).toBe(true)
    })

    it('should combine search query and libraries filter from URL params', () => {
      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects: createTestProjects(),
        loading: false,
        error: null
      })

      render(
        <MemoryRouter initialEntries={['/explore?q=audio&libs=true']}>
          <ExplorePage />
        </MemoryRouter>
      )

      // Should only show library projects matching "audio"
      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(1)
      expect(projectItems[0]).toHaveTextContent('Sound Effects')
    })

    it('should update search when typing in search input', async () => {
      const user = userEvent.setup()

      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects: createTestProjects(),
        loading: false,
        error: null
      })

      render(
        <MemoryRouter initialEntries={['/explore']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const searchInput = screen.getByPlaceholderText(/search/i)
      await user.type(searchInput, 'game')

      expect(searchInput).toHaveValue('game')

      // Should filter projects
      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(1)
      expect(projectItems[0]).toHaveTextContent('My Game')
    })

    it('should show all projects when no URL params', () => {
      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects: createTestProjects(),
        loading: false,
        error: null
      })

      render(
        <MemoryRouter initialEntries={['/explore']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(3)
    })

    it('should handle empty search query param gracefully', () => {
      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects: createTestProjects(),
        loading: false,
        error: null
      })

      render(
        <MemoryRouter initialEntries={['/explore?q=']}>
          <ExplorePage />
        </MemoryRouter>
      )

      const searchInput = screen.getByPlaceholderText(/search/i)
      expect(searchInput).toHaveValue('')

      // Should show all projects
      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(3)
    })

    it('should handle libs=false as not filtering', () => {
      vi.mocked(hooks.useFetchVisibleProjects).mockReturnValue({
        projects: createTestProjects(),
        loading: false,
        error: null
      })

      render(
        <MemoryRouter initialEntries={['/explore?libs=false']}>
          <ExplorePage />
        </MemoryRouter>
      )

      // libs=false should not filter to libraries only
      const projectItems = screen.getAllByTestId('project-item')
      expect(projectItems).toHaveLength(3)
    })
  })
})
