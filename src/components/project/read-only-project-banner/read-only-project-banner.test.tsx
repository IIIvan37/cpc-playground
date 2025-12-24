import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { createStore, Provider } from 'jotai'
import { describe, expect, it } from 'vitest'
import type { Project } from '@/domain/entities/project.entity'
import { codeAtom, isReadOnlyModeAtom, viewOnlyProjectAtom } from '@/store'
import { ReadOnlyProjectBanner } from './read-only-project-banner'
import styles from './read-only-project-banner.module.css'

// Mock project matching the Project entity type
const mockProject: Project = {
  id: 'test-id',
  userId: 'user-id',
  authorUsername: 'testuser',
  name: { value: 'Test Project' } as Project['name'],
  description: null,
  thumbnailPath: null,
  visibility: { value: 'public' } as Project['visibility'],
  isLibrary: false,
  files: [],
  tags: [],
  dependencies: [],
  shares: [],
  userShares: [],
  createdAt: new Date(),
  updatedAt: new Date()
}

function renderWithStore(initialState: {
  viewOnlyProject: Project | null
  isReadOnlyMode: boolean
}) {
  const store = createStore()
  store.set(viewOnlyProjectAtom, initialState.viewOnlyProject)
  store.set(isReadOnlyModeAtom, initialState.isReadOnlyMode)

  return {
    store,
    ...render(
      <Provider store={store}>
        <ReadOnlyProjectBanner />
      </Provider>
    )
  }
}

describe('ReadOnlyProjectBanner', () => {
  describe('visibility', () => {
    it('does not render when viewOnlyProject is null', () => {
      const { container } = renderWithStore({
        viewOnlyProject: null,
        isReadOnlyMode: false
      })
      expect(
        container.querySelector(`.${styles.banner}`)
      ).not.toBeInTheDocument()
    })

    it('renders when viewOnlyProject is set', () => {
      const { container } = renderWithStore({
        viewOnlyProject: mockProject,
        isReadOnlyMode: true
      })
      expect(container.querySelector(`.${styles.banner}`)).toBeInTheDocument()
    })
  })

  describe('content', () => {
    it('displays project name', () => {
      renderWithStore({
        viewOnlyProject: mockProject,
        isReadOnlyMode: true
      })
      expect(screen.getByText('Test Project')).toBeInTheDocument()
    })

    it('displays read-only mode text', () => {
      renderWithStore({
        viewOnlyProject: mockProject,
        isReadOnlyMode: true
      })
      expect(screen.getByText(/in read-only mode/)).toBeInTheDocument()
    })

    it('displays viewing text', () => {
      renderWithStore({
        viewOnlyProject: mockProject,
        isReadOnlyMode: true
      })
      expect(screen.getByText(/viewing/i)).toBeInTheDocument()
    })
  })

  describe('close button', () => {
    it('renders close button', () => {
      renderWithStore({
        viewOnlyProject: mockProject,
        isReadOnlyMode: true
      })
      expect(
        screen.getByRole('button', { name: /close project/i })
      ).toBeInTheDocument()
    })

    it('clears state when close button is clicked', async () => {
      const user = userEvent.setup()
      const { store } = renderWithStore({
        viewOnlyProject: mockProject,
        isReadOnlyMode: true
      })

      await user.click(screen.getByRole('button', { name: /close project/i }))

      expect(store.get(isReadOnlyModeAtom)).toBe(false)
      expect(store.get(viewOnlyProjectAtom)).toBe(null)
      expect(store.get(codeAtom)).toBe('')
    })
  })

  describe('structure', () => {
    it('has info section', () => {
      const { container } = renderWithStore({
        viewOnlyProject: mockProject,
        isReadOnlyMode: true
      })
      expect(container.querySelector(`.${styles.info}`)).toBeInTheDocument()
    })

    it('has close button with proper class', () => {
      const { container } = renderWithStore({
        viewOnlyProject: mockProject,
        isReadOnlyMode: true
      })
      expect(
        container.querySelector(`.${styles.closeButton}`)
      ).toBeInTheDocument()
    })

    it('has project name with proper class', () => {
      const { container } = renderWithStore({
        viewOnlyProject: mockProject,
        isReadOnlyMode: true
      })
      expect(
        container.querySelector(`.${styles.projectName}`)
      ).toBeInTheDocument()
    })
  })
})
