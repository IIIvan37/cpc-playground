import { render, screen } from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
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
        <BrowserRouter>
          <ExplorePage />
        </BrowserRouter>
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
        <BrowserRouter>
          <ExplorePage />
        </BrowserRouter>
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
        <BrowserRouter>
          <ExplorePage />
        </BrowserRouter>
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
        <BrowserRouter>
          <ExplorePage />
        </BrowserRouter>
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
        <BrowserRouter>
          <ExplorePage />
        </BrowserRouter>
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
})
