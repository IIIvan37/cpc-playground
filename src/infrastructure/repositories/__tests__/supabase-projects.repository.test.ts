import type { SupabaseClient } from '@supabase/supabase-js'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import type { Database } from '@/types/database.types'
import { createSupabaseProjectsRepository } from '../supabase-projects.repository'

// Create a properly chainable mock where every method returns the mock itself
const DEFAULT_RESOLVED_VALUE = { data: null, error: null }

function createFullChainMock(resolvedValue?: unknown) {
  const value = resolvedValue ?? DEFAULT_RESOLVED_VALUE
  const mock: Record<string, unknown> = {}
  const methodNames = [
    'select',
    'insert',
    'update',
    'delete',
    'eq',
    'neq',
    'in',
    'order',
    'single',
    'maybeSingle'
  ]

  for (const name of methodNames) {
    if (name === 'single' || name === 'maybeSingle') {
      mock[name] = vi.fn(() => Promise.resolve(value))
    } else {
      mock[name] = vi.fn(() => mock)
    }
  }

  return mock as {
    select: ReturnType<typeof vi.fn>
    insert: ReturnType<typeof vi.fn>
    update: ReturnType<typeof vi.fn>
    delete: ReturnType<typeof vi.fn>
    eq: ReturnType<typeof vi.fn>
    neq: ReturnType<typeof vi.fn>
    in: ReturnType<typeof vi.fn>
    order: ReturnType<typeof vi.fn>
    single: ReturnType<typeof vi.fn>
    maybeSingle: ReturnType<typeof vi.fn>
  }
}

/**
 * Creates a mock for user_profiles table query used by enrichWithAuthorUsernames
 */
function createUserProfilesMock(
  profiles: Array<{ id: string; username: string }> = [
    { id: 'user-123', username: 'testuser' }
  ]
) {
  const mock = createFullChainMock()
  mock.in = vi.fn(() =>
    Promise.resolve({
      data: profiles,
      error: null
    })
  )
  return mock
}

// Sample data
const mockProjectRow = {
  id: 'project-123',
  user_id: 'user-123',
  name: 'Test Project',
  description: 'A test project',
  visibility: 'private' as const,
  is_library: false,
  thumbnail_path: null,
  created_at: '2024-01-01T00:00:00Z',
  updated_at: '2024-06-01T00:00:00Z',
  project_files: [
    {
      id: 'file-1',
      project_id: 'project-123',
      name: 'main.asm',
      content: '; Hello',
      is_main: true,
      order: 0,
      created_at: '2024-01-01T00:00:00Z',
      updated_at: '2024-01-01T00:00:00Z'
    }
  ],
  project_shares: [],
  project_tags: [{ tags: { id: 'tag-1', name: 'test' } }],
  project_dependencies: []
}

const mockFileRow = {
  id: 'file-1',
  project_id: 'project-123',
  name: 'main.asm',
  content: '; Hello',
  is_main: true,
  order: 0,
  created_at: '2024-01-01T00:00:00Z',
  updated_at: '2024-01-01T00:00:00Z'
}

describe('SupabaseProjectsRepository', () => {
  let mockSupabase: { from: ReturnType<typeof vi.fn> }
  let repository: ReturnType<typeof createSupabaseProjectsRepository>

  beforeEach(() => {
    mockSupabase = { from: vi.fn() }
    repository = createSupabaseProjectsRepository(
      mockSupabase as unknown as SupabaseClient<Database>
    )
    vi.clearAllMocks()
  })

  describe('findAll', () => {
    it('should return user projects and shared projects', async () => {
      // First call: get own projects
      const ownMock = createFullChainMock()
      ownMock.order = vi.fn(() =>
        Promise.resolve({ data: [mockProjectRow], error: null })
      )

      // Second call: get shared project IDs
      const sharedIdsMock = createFullChainMock()
      sharedIdsMock.eq = vi.fn(() =>
        Promise.resolve({
          data: [{ project_id: 'shared-project-123' }],
          error: null
        })
      )

      // Third call: get shared projects
      const sharedProjectsMock = createFullChainMock()
      sharedProjectsMock.order = vi.fn(() =>
        Promise.resolve({
          data: [{ ...mockProjectRow, id: 'shared-project-123' }],
          error: null
        })
      )

      mockSupabase.from
        .mockReturnValueOnce(ownMock)
        .mockReturnValueOnce(sharedIdsMock)
        .mockReturnValueOnce(sharedProjectsMock)
        .mockReturnValueOnce(createUserProfilesMock())

      const result = await repository.findAll('user-123')

      expect(result).toHaveLength(2)
      expect(mockSupabase.from).toHaveBeenCalledWith('projects')
      expect(mockSupabase.from).toHaveBeenCalledWith('project_shares')
    })

    it('should return only own projects when no shared projects', async () => {
      const ownMock = createFullChainMock()
      ownMock.order = vi.fn(() =>
        Promise.resolve({ data: [mockProjectRow], error: null })
      )

      const sharedIdsMock = createFullChainMock()
      sharedIdsMock.eq = vi.fn(() => Promise.resolve({ data: [], error: null }))

      mockSupabase.from
        .mockReturnValueOnce(ownMock)
        .mockReturnValueOnce(sharedIdsMock)
        .mockReturnValueOnce(createUserProfilesMock())

      const result = await repository.findAll('user-123')

      expect(result).toHaveLength(1)
    })

    it('should throw on own projects error', async () => {
      const ownMock = createFullChainMock()
      ownMock.order = vi.fn(() =>
        Promise.resolve({ data: null, error: { message: 'Database error' } })
      )

      mockSupabase.from.mockReturnValue(ownMock)

      await expect(repository.findAll('user-123')).rejects.toEqual({
        message: 'Database error'
      })
    })

    it('should throw on shared project IDs error', async () => {
      const ownMock = createFullChainMock()
      ownMock.order = vi.fn(() =>
        Promise.resolve({ data: [mockProjectRow], error: null })
      )

      const sharedIdsMock = createFullChainMock()
      sharedIdsMock.eq = vi.fn(() =>
        Promise.resolve({ data: null, error: { message: 'Shared error' } })
      )

      mockSupabase.from
        .mockReturnValueOnce(ownMock)
        .mockReturnValueOnce(sharedIdsMock)

      await expect(repository.findAll('user-123')).rejects.toEqual({
        message: 'Shared error'
      })
    })

    it('should deduplicate projects owned and shared', async () => {
      const ownMock = createFullChainMock()
      ownMock.order = vi.fn(() =>
        Promise.resolve({ data: [mockProjectRow], error: null })
      )

      const sharedIdsMock = createFullChainMock()
      sharedIdsMock.eq = vi.fn(() =>
        Promise.resolve({
          data: [{ project_id: 'project-123' }], // Same as owned
          error: null
        })
      )

      const sharedProjectsMock = createFullChainMock()
      sharedProjectsMock.order = vi.fn(() =>
        Promise.resolve({ data: [mockProjectRow], error: null })
      )

      mockSupabase.from
        .mockReturnValueOnce(ownMock)
        .mockReturnValueOnce(sharedIdsMock)
        .mockReturnValueOnce(sharedProjectsMock)
        .mockReturnValueOnce(createUserProfilesMock())

      const result = await repository.findAll('user-123')

      expect(result).toHaveLength(1) // Deduplicated
    })
  })

  describe('findById', () => {
    it('should return project by id', async () => {
      const chainMock = createFullChainMock({
        data: mockProjectRow,
        error: null
      })
      mockSupabase.from
        .mockReturnValueOnce(chainMock)
        .mockReturnValueOnce(createUserProfilesMock())

      const result = await repository.findById('project-123')

      expect(mockSupabase.from).toHaveBeenCalledWith('projects')
      expect(result).not.toBeNull()
      expect(result?.id).toBe('project-123')
      expect(result?.name.value).toBe('Test Project')
    })

    it('should return null when not found', async () => {
      const chainMock = createFullChainMock({
        data: null,
        error: { code: 'PGRST116', message: 'Not found' }
      })
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.findById('non-existent')

      expect(result).toBeNull()
    })

    it('should throw on other errors', async () => {
      const chainMock = createFullChainMock({
        data: null,
        error: { code: 'OTHER', message: 'Database error' }
      })
      mockSupabase.from.mockReturnValue(chainMock)

      await expect(repository.findById('project-123')).rejects.toEqual({
        code: 'OTHER',
        message: 'Database error'
      })
    })
  })

  describe('findByShareCode', () => {
    it('should return project by share code', async () => {
      const chainMock = createFullChainMock({
        data: { project: mockProjectRow },
        error: null
      })
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.findByShareCode('share-abc')

      expect(mockSupabase.from).toHaveBeenCalledWith('project_shares')
      expect(result).not.toBeNull()
      expect(result?.id).toBe('project-123')
    })

    it('should return null when not found', async () => {
      const chainMock = createFullChainMock({
        data: null,
        error: { code: 'PGRST116', message: 'Not found' }
      })
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.findByShareCode('non-existent')

      expect(result).toBeNull()
    })

    it('should throw on other errors', async () => {
      const chainMock = createFullChainMock({
        data: null,
        error: { code: 'OTHER', message: 'Database error' }
      })
      mockSupabase.from.mockReturnValue(chainMock)

      await expect(repository.findByShareCode('share-abc')).rejects.toEqual({
        code: 'OTHER',
        message: 'Database error'
      })
    })
  })

  describe('create', () => {
    it('should create a project', async () => {
      // First call: insert project
      const insertMock = createFullChainMock({
        data: { ...mockProjectRow, id: 'new-project-123' },
        error: null
      })
      // Second call: findById
      const findMock = createFullChainMock({
        data: { ...mockProjectRow, id: 'new-project-123' },
        error: null
      })

      mockSupabase.from
        .mockReturnValueOnce(insertMock)
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(createUserProfilesMock())

      const project = {
        id: '',
        userId: 'user-123',
        authorUsername: null,
        name: createProjectName('New Project'),
        description: 'Description',
        thumbnailPath: null,
        visibility: createVisibility('private'),
        isLibrary: false,
        isSticky: false,
        files: [],
        shares: [],
        tags: [],
        dependencies: [],
        userShares: [],
        createdAt: new Date(),
        updatedAt: new Date()
      }

      const result = await repository.create(project)

      expect(mockSupabase.from).toHaveBeenCalledWith('projects')
      expect(result.id).toBe('new-project-123')
    })

    it('should throw on insert error', async () => {
      const chainMock = createFullChainMock({
        data: null,
        error: { message: 'Insert failed' }
      })
      mockSupabase.from.mockReturnValue(chainMock)

      const project = {
        id: '',
        userId: 'user-123',
        authorUsername: null,
        name: createProjectName('New Project'),
        description: null,
        thumbnailPath: null,
        visibility: createVisibility('private'),
        isLibrary: false,
        isSticky: false,
        files: [],
        shares: [],
        tags: [],
        dependencies: [],
        userShares: [],
        createdAt: new Date(),
        updatedAt: new Date()
      }

      await expect(repository.create(project)).rejects.toEqual({
        message: 'Insert failed'
      })
    })

    it('should create a project with files', async () => {
      // First call: insert project
      const insertMock = createFullChainMock({
        data: { ...mockProjectRow, id: 'new-project-123' },
        error: null
      })
      // Second call: insert files
      const fileInsertMock = createFullChainMock({ error: null })
      // Third call: findById
      const findMock = createFullChainMock({
        data: {
          ...mockProjectRow,
          id: 'new-project-123',
          project_files: [mockFileRow]
        },
        error: null
      })
      // Fourth call: enrichWithAuthorUsernames (user_profiles)
      const userProfilesMock = createFullChainMock()
      userProfilesMock.in = vi.fn(() =>
        Promise.resolve({
          data: [{ id: 'user-123', username: 'testuser' }],
          error: null
        })
      )

      mockSupabase.from
        .mockReturnValueOnce(insertMock)
        .mockReturnValueOnce(fileInsertMock)
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(userProfilesMock)

      const project = {
        id: '',
        userId: 'user-123',
        authorUsername: null,
        name: createProjectName('New Project'),
        description: 'Description',
        thumbnailPath: null,
        visibility: createVisibility('private'),
        isLibrary: false,
        isSticky: false,
        files: [
          {
            id: 'file-1',
            projectId: '',
            name: createFileName('main.asm'),
            content: createFileContent('; Hello'),
            isMain: true,
            order: 0,
            createdAt: new Date(),
            updatedAt: new Date()
          }
        ],
        shares: [],
        tags: [],
        dependencies: [],
        userShares: [],
        createdAt: new Date(),
        updatedAt: new Date()
      }

      const result = await repository.create(project)

      expect(mockSupabase.from).toHaveBeenCalledWith('project_files')
      expect(result.id).toBe('new-project-123')
    })

    it('should throw on file insert error', async () => {
      // First call: insert project
      const insertMock = createFullChainMock({
        data: { ...mockProjectRow, id: 'new-project-123' },
        error: null
      })
      // Second call: insert files fails - insert returns directly
      const fileInsertMock = {
        insert: vi.fn(() =>
          Promise.resolve({ error: { message: 'File insert failed' } })
        )
      }

      mockSupabase.from
        .mockReturnValueOnce(insertMock)
        .mockReturnValueOnce(fileInsertMock)

      const project = {
        id: '',
        userId: 'user-123',
        authorUsername: null,
        name: createProjectName('New Project'),
        description: null,
        thumbnailPath: null,
        visibility: createVisibility('private'),
        isLibrary: false,
        isSticky: false,
        files: [
          {
            id: 'file-1',
            projectId: '',
            name: createFileName('main.asm'),
            content: createFileContent('; Hello'),
            isMain: true,
            order: 0,
            createdAt: new Date(),
            updatedAt: new Date()
          }
        ],
        shares: [],
        tags: [],
        dependencies: [],
        userShares: [],
        createdAt: new Date(),
        updatedAt: new Date()
      }

      await expect(repository.create(project)).rejects.toEqual({
        message: 'File insert failed'
      })
    })
  })

  describe('update', () => {
    it('should update a project', async () => {
      // First call: update
      const updateMock = createFullChainMock()
      updateMock.eq = vi.fn(() => Promise.resolve({ error: null }))
      // Second call: findById
      const findMock = createFullChainMock({
        data: { ...mockProjectRow, name: 'Updated Name' },
        error: null
      })
      // Third call: enrichWithAuthorUsernames (user_profiles)
      const userProfilesMock = createFullChainMock()
      userProfilesMock.in = vi.fn(() =>
        Promise.resolve({
          data: [{ id: 'user-123', username: 'testuser' }],
          error: null
        })
      )

      mockSupabase.from
        .mockReturnValueOnce(updateMock)
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(userProfilesMock)

      const result = await repository.update('project-123', {
        name: createProjectName('Updated Name')
      })

      expect(mockSupabase.from).toHaveBeenCalledWith('projects')
      expect(result.name.value).toBe('Updated Name')
    })

    it('should throw on update error', async () => {
      const chainMock = createFullChainMock()
      chainMock.eq = vi.fn(() =>
        Promise.resolve({ error: { message: 'Update failed' } })
      )
      mockSupabase.from.mockReturnValue(chainMock)

      await expect(
        repository.update('project-123', {
          name: createProjectName('Updated Name')
        })
      ).rejects.toEqual({ message: 'Update failed' })
    })

    it('should update visibility', async () => {
      const updateMock = createFullChainMock()
      updateMock.eq = vi.fn(() => Promise.resolve({ error: null }))
      const findMock = createFullChainMock({
        data: { ...mockProjectRow, visibility: 'public' },
        error: null
      })
      // Third call: enrichWithAuthorUsernames (user_profiles)
      const userProfilesMock = createFullChainMock()
      userProfilesMock.in = vi.fn(() =>
        Promise.resolve({
          data: [{ id: 'user-123', username: 'testuser' }],
          error: null
        })
      )

      mockSupabase.from
        .mockReturnValueOnce(updateMock)
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(userProfilesMock)

      const result = await repository.update('project-123', {
        visibility: createVisibility('public')
      })

      expect(result.visibility.value).toBe('public')
    })

    it('should update isLibrary', async () => {
      const updateMock = createFullChainMock()
      updateMock.eq = vi.fn(() => Promise.resolve({ error: null }))
      const findMock = createFullChainMock({
        data: { ...mockProjectRow, is_library: true },
        error: null
      })
      // Third call: enrichWithAuthorUsernames (user_profiles)
      const userProfilesMock = createFullChainMock()
      userProfilesMock.in = vi.fn(() =>
        Promise.resolve({
          data: [{ id: 'user-123', username: 'testuser' }],
          error: null
        })
      )

      mockSupabase.from
        .mockReturnValueOnce(updateMock)
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(userProfilesMock)

      const result = await repository.update('project-123', {
        isLibrary: true
      })

      expect(result.isLibrary).toBe(true)
    })

    it('should update description', async () => {
      const updateMock = createFullChainMock()
      updateMock.eq = vi.fn(() => Promise.resolve({ error: null }))
      const findMock = createFullChainMock({
        data: { ...mockProjectRow, description: 'New description' },
        error: null
      })
      // Third call: enrichWithAuthorUsernames (user_profiles)
      const userProfilesMock = createFullChainMock()
      userProfilesMock.in = vi.fn(() =>
        Promise.resolve({
          data: [{ id: 'user-123', username: 'testuser' }],
          error: null
        })
      )

      mockSupabase.from
        .mockReturnValueOnce(updateMock)
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(userProfilesMock)

      const result = await repository.update('project-123', {
        description: 'New description'
      })

      expect(result.description).toBe('New description')
    })
  })

  describe('delete', () => {
    it('should delete a project without thumbnail', async () => {
      // First call: findById returns project without thumbnail
      const findByIdMock = createFullChainMock()
      findByIdMock.single = vi.fn(() =>
        Promise.resolve({
          data: { ...mockProjectRow, thumbnail_path: null },
          error: null
        })
      )

      // Second call: delete
      const deleteMock = createFullChainMock()
      deleteMock.eq = vi.fn(() => Promise.resolve({ error: null }))

      mockSupabase.from
        .mockReturnValueOnce(findByIdMock)
        .mockReturnValueOnce(deleteMock)

      await repository.delete('project-123')

      expect(mockSupabase.from).toHaveBeenCalledWith('projects')
      expect(deleteMock.delete).toHaveBeenCalled()
    })

    it('should delete a project with thumbnail', async () => {
      // First call: findById returns project with thumbnail
      const findByIdMock = createFullChainMock()
      findByIdMock.single = vi.fn(() =>
        Promise.resolve({
          data: {
            ...mockProjectRow,
            thumbnail_path: 'user-123/project-123.webp'
          },
          error: null
        })
      )

      // Second call: delete project
      const deleteMock = createFullChainMock()
      deleteMock.eq = vi.fn(() => Promise.resolve({ error: null }))

      // Storage mock
      const storageMock = {
        from: vi.fn(() => ({
          remove: vi.fn(() => Promise.resolve({ error: null }))
        }))
      }

      mockSupabase.from
        .mockReturnValueOnce(findByIdMock)
        .mockReturnValueOnce(deleteMock)

      // Add storage to mock
      ;(mockSupabase as unknown as { storage: typeof storageMock }).storage =
        storageMock

      await repository.delete('project-123')

      expect(storageMock.from).toHaveBeenCalledWith('thumbnails')
      expect(deleteMock.delete).toHaveBeenCalled()
    })

    it('should throw on delete error', async () => {
      // First call: findById
      const findByIdMock = createFullChainMock()
      findByIdMock.single = vi.fn(() =>
        Promise.resolve({
          data: { ...mockProjectRow, thumbnail_path: null },
          error: null
        })
      )

      // Second call: delete fails
      const deleteMock = createFullChainMock()
      deleteMock.eq = vi.fn(() =>
        Promise.resolve({ error: { message: 'Delete failed' } })
      )

      mockSupabase.from
        .mockReturnValueOnce(findByIdMock)
        .mockReturnValueOnce(deleteMock)

      await expect(repository.delete('project-123')).rejects.toEqual({
        message: 'Delete failed'
      })
    })
  })

  describe('createFile', () => {
    it('should create a file', async () => {
      const chainMock = createFullChainMock({ data: mockFileRow, error: null })
      mockSupabase.from.mockReturnValue(chainMock)

      const file = {
        id: 'file-1',
        projectId: 'project-123',
        name: createFileName('main.asm'),
        content: createFileContent('; Hello'),
        isMain: true,
        order: 0,
        createdAt: new Date(),
        updatedAt: new Date()
      }

      const result = await repository.createFile('project-123', file)

      expect(mockSupabase.from).toHaveBeenCalledWith('project_files')
      expect(result.id).toBe('file-1')
      expect(result.name.value).toBe('main.asm')
    })

    it('should throw on error', async () => {
      const chainMock = createFullChainMock({
        data: null,
        error: { message: 'Insert failed' }
      })
      mockSupabase.from.mockReturnValue(chainMock)

      const file = {
        id: 'file-1',
        projectId: 'project-123',
        name: createFileName('main.asm'),
        content: createFileContent('; Hello'),
        isMain: true,
        order: 0,
        createdAt: new Date(),
        updatedAt: new Date()
      }

      await expect(repository.createFile('project-123', file)).rejects.toEqual({
        message: 'Insert failed'
      })
    })
  })

  describe('updateFile', () => {
    it('should update a file', async () => {
      const chainMock = createFullChainMock({
        data: { ...mockFileRow, content: '; Updated' },
        error: null
      })
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.updateFile('project-123', 'file-1', {
        content: createFileContent('; Updated')
      })

      expect(mockSupabase.from).toHaveBeenCalledWith('project_files')
      expect(result.content.value).toBe('; Updated')
    })

    it('should unset other main files when setting isMain to true', async () => {
      // First call: unset other main files
      const unsetMock = createFullChainMock()
      unsetMock.neq = vi.fn(() => Promise.resolve({ error: null }))

      // Second call: update file
      const updateMock = createFullChainMock({
        data: { ...mockFileRow, is_main: true },
        error: null
      })

      mockSupabase.from
        .mockReturnValueOnce(unsetMock)
        .mockReturnValueOnce(updateMock)

      const result = await repository.updateFile('project-123', 'file-1', {
        isMain: true
      })

      expect(result.isMain).toBe(true)
      expect(unsetMock.update).toHaveBeenCalledWith({ is_main: false })
    })

    it('should update file name', async () => {
      const chainMock = createFullChainMock({
        data: { ...mockFileRow, name: 'renamed.asm' },
        error: null
      })
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.updateFile('project-123', 'file-1', {
        name: createFileName('renamed.asm')
      })

      expect(result.name.value).toBe('renamed.asm')
    })

    it('should update file order', async () => {
      const chainMock = createFullChainMock({
        data: { ...mockFileRow, order: 5 },
        error: null
      })
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.updateFile('project-123', 'file-1', {
        order: 5
      })

      expect(result.order).toBe(5)
    })

    it('should throw on error', async () => {
      const chainMock = createFullChainMock({
        data: null,
        error: { message: 'Update failed' }
      })
      mockSupabase.from.mockReturnValue(chainMock)

      await expect(
        repository.updateFile('project-123', 'file-1', {
          content: createFileContent('; Updated')
        })
      ).rejects.toEqual({ message: 'Update failed' })
    })
  })

  describe('deleteFile', () => {
    it('should delete a file', async () => {
      const chainMock = createFullChainMock()
      const eqMock = vi.fn(() => Promise.resolve({ error: null }))
      chainMock.eq = vi.fn(() => ({ eq: eqMock }))
      mockSupabase.from.mockReturnValue(chainMock)

      await repository.deleteFile('project-123', 'file-1')

      expect(mockSupabase.from).toHaveBeenCalledWith('project_files')
      expect(chainMock.delete).toHaveBeenCalled()
    })

    it('should throw on error', async () => {
      const chainMock = createFullChainMock()
      const eqMock = vi.fn(() =>
        Promise.resolve({ error: { message: 'Delete failed' } })
      )
      chainMock.eq = vi.fn(() => ({ eq: eqMock }))
      mockSupabase.from.mockReturnValue(chainMock)

      await expect(
        repository.deleteFile('project-123', 'file-1')
      ).rejects.toEqual({ message: 'Delete failed' })
    })
  })

  // Note: Link shares (getShares, createShare) are handled by Netlify Blobs, not the repository

  describe('getDependencies', () => {
    it('should return dependencies', async () => {
      const chainMock = createFullChainMock()
      chainMock.eq = vi.fn(() =>
        Promise.resolve({
          data: [{ dependency_id: 'dep-1' }, { dependency_id: 'dep-2' }],
          error: null
        })
      )
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.getDependencies('project-123')

      expect(mockSupabase.from).toHaveBeenCalledWith('project_dependencies')
      expect(result).toEqual(['dep-1', 'dep-2'])
    })

    it('should return empty array when no data', async () => {
      const chainMock = createFullChainMock()
      chainMock.eq = vi.fn(() => Promise.resolve({ data: null, error: null }))
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.getDependencies('project-123')

      expect(result).toEqual([])
    })
  })

  describe('addDependency', () => {
    it('should add a dependency', async () => {
      const chainMock = createFullChainMock()
      chainMock.insert = vi.fn(() => Promise.resolve({ error: null }))
      mockSupabase.from.mockReturnValue(chainMock)

      await repository.addDependency('project-123', 'dep-1')

      expect(mockSupabase.from).toHaveBeenCalledWith('project_dependencies')
      expect(chainMock.insert).toHaveBeenCalledWith({
        project_id: 'project-123',
        dependency_id: 'dep-1'
      })
    })

    it('should throw on error', async () => {
      const chainMock = createFullChainMock()
      chainMock.insert = vi.fn(() =>
        Promise.resolve({ error: { message: 'Insert failed' } })
      )
      mockSupabase.from.mockReturnValue(chainMock)

      await expect(
        repository.addDependency('project-123', 'dep-1')
      ).rejects.toEqual({ message: 'Insert failed' })
    })
  })

  describe('removeDependency', () => {
    it('should remove a dependency', async () => {
      const chainMock = createFullChainMock()
      const eqMock = vi.fn(() => Promise.resolve({ error: null }))
      chainMock.eq = vi.fn(() => ({ eq: eqMock }))
      mockSupabase.from.mockReturnValue(chainMock)

      await repository.removeDependency('project-123', 'dep-1')

      expect(mockSupabase.from).toHaveBeenCalledWith('project_dependencies')
      expect(chainMock.delete).toHaveBeenCalled()
    })

    it('should throw on error', async () => {
      const chainMock = createFullChainMock()
      const eqMock = vi.fn(() =>
        Promise.resolve({ error: { message: 'Delete failed' } })
      )
      chainMock.eq = vi.fn(() => ({ eq: eqMock }))
      mockSupabase.from.mockReturnValue(chainMock)

      await expect(
        repository.removeDependency('project-123', 'dep-1')
      ).rejects.toEqual({ message: 'Delete failed' })
    })
  })

  describe('getTags', () => {
    it('should return tags', async () => {
      const chainMock = createFullChainMock()
      chainMock.eq = vi.fn(() =>
        Promise.resolve({
          data: [
            { tag_id: 'tag-1', tags: { id: 'tag-1', name: 'test' } },
            { tag_id: 'tag-2', tags: { id: 'tag-2', name: 'demo' } }
          ],
          error: null
        })
      )
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.getTags('project-123')

      expect(mockSupabase.from).toHaveBeenCalledWith('project_tags')
      expect(result).toHaveLength(2)
      expect(result[0].name).toBe('test')
    })

    it('should filter out invalid tags', async () => {
      const chainMock = createFullChainMock()
      chainMock.eq = vi.fn(() =>
        Promise.resolve({
          data: [
            { tag_id: 'tag-1', tags: { id: 'tag-1', name: 'test' } },
            { tag_id: 'tag-2', tags: null }
          ],
          error: null
        })
      )
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.getTags('project-123')

      expect(result).toHaveLength(1)
    })

    it('should return empty array when no data', async () => {
      const chainMock = createFullChainMock()
      chainMock.eq = vi.fn(() => Promise.resolve({ data: null, error: null }))
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.getTags('project-123')

      expect(result).toEqual([])
    })
  })

  describe('addTag', () => {
    it('should add existing tag', async () => {
      // Find existing tag
      const findMock = createFullChainMock({
        data: { id: 'tag-1', name: 'test' },
        error: null
      })
      // Link tag
      const linkMock = createFullChainMock()
      linkMock.insert = vi.fn(() => Promise.resolve({ error: null }))

      mockSupabase.from
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(linkMock)

      const result = await repository.addTag('project-123', 'Test')

      expect(result.name).toBe('test')
    })

    it('should create new tag if not exists', async () => {
      // Find tag - not found (maybeSingle returns null data, no error)
      const findMock = createFullChainMock({
        data: null,
        error: null
      })
      // Create tag
      const createMock = createFullChainMock({
        data: { id: 'tag-new', name: 'newtag' },
        error: null
      })
      // Link tag
      const linkMock = createFullChainMock()
      linkMock.insert = vi.fn(() => Promise.resolve({ error: null }))

      mockSupabase.from
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(createMock)
        .mockReturnValueOnce(linkMock)

      const result = await repository.addTag('project-123', 'NewTag')

      expect(result.name).toBe('newtag')
    })

    it('should ignore duplicate link error', async () => {
      const findMock = createFullChainMock({
        data: { id: 'tag-1', name: 'test' },
        error: null
      })
      const linkMock = createFullChainMock()
      linkMock.insert = vi.fn(() =>
        Promise.resolve({ error: { code: '23505', message: 'Duplicate' } })
      )

      mockSupabase.from
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(linkMock)

      const result = await repository.addTag('project-123', 'test')

      expect(result.name).toBe('test')
    })

    it('should throw on find error', async () => {
      const findMock = createFullChainMock({
        data: null,
        error: { code: 'OTHER', message: 'Database error' }
      })
      mockSupabase.from.mockReturnValue(findMock)

      await expect(repository.addTag('project-123', 'test')).rejects.toEqual({
        code: 'OTHER',
        message: 'Database error'
      })
    })

    it('should throw on link error (non-duplicate)', async () => {
      const findMock = createFullChainMock({
        data: { id: 'tag-1', name: 'test' },
        error: null
      })
      const linkMock = createFullChainMock()
      linkMock.insert = vi.fn(() =>
        Promise.resolve({
          error: { code: 'OTHER', message: 'Link failed' }
        })
      )

      mockSupabase.from
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(linkMock)

      await expect(repository.addTag('project-123', 'test')).rejects.toEqual({
        code: 'OTHER',
        message: 'Link failed'
      })
    })

    it('should throw on create tag error', async () => {
      // Find tag - not found (maybeSingle returns null data, no error)
      const findMock = createFullChainMock({
        data: null,
        error: null
      })
      // Create tag - error
      const createMock = createFullChainMock({
        data: null,
        error: { message: 'Create tag failed' }
      })

      mockSupabase.from
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(createMock)

      await expect(repository.addTag('project-123', 'NewTag')).rejects.toEqual({
        message: 'Create tag failed'
      })
    })
  })

  describe('removeTag', () => {
    it('should remove tag by uuid', async () => {
      const chainMock = createFullChainMock()
      const eqMock = vi.fn(() => Promise.resolve({ error: null }))
      chainMock.eq = vi.fn(() => ({ eq: eqMock }))
      mockSupabase.from.mockReturnValue(chainMock)

      await repository.removeTag(
        'project-123',
        '12345678-1234-1234-1234-123456789012'
      )

      expect(mockSupabase.from).toHaveBeenCalledWith('project_tags')
      expect(chainMock.delete).toHaveBeenCalled()
    })

    it('should remove tag by name', async () => {
      // Find tag by name
      const findMock = createFullChainMock({
        data: { id: 'tag-1' },
        error: null
      })
      // Delete link
      const deleteMock = createFullChainMock()
      const eqMock = vi.fn(() => Promise.resolve({ error: null }))
      deleteMock.eq = vi.fn(() => ({ eq: eqMock }))

      mockSupabase.from
        .mockReturnValueOnce(findMock)
        .mockReturnValueOnce(deleteMock)

      await repository.removeTag('project-123', 'test')

      expect(mockSupabase.from).toHaveBeenCalledWith('tags')
    })

    it('should do nothing if tag name not found', async () => {
      // maybeSingle returns null data, no error for not found
      const findMock = createFullChainMock({
        data: null,
        error: null
      })
      mockSupabase.from.mockReturnValue(findMock)

      await repository.removeTag('project-123', 'nonexistent')

      // Should only have called from('tags') for find, not delete
      expect(mockSupabase.from).toHaveBeenCalledTimes(1)
    })

    it('should throw on delete error', async () => {
      const chainMock = createFullChainMock()
      const eqMock = vi.fn(() =>
        Promise.resolve({ error: { message: 'Delete failed' } })
      )
      chainMock.eq = vi.fn(() => ({ eq: eqMock }))
      mockSupabase.from.mockReturnValue(chainMock)

      await expect(
        repository.removeTag(
          'project-123',
          '12345678-1234-1234-1234-123456789012'
        )
      ).rejects.toEqual({ message: 'Delete failed' })
    })
  })

  describe('getUserShares', () => {
    it('should return user shares', async () => {
      const chainMock = createFullChainMock()
      chainMock.eq = vi.fn(() =>
        Promise.resolve({
          data: [
            {
              project_id: 'project-123',
              user_id: 'user-456',
              created_at: '2024-01-01T00:00:00Z',
              user_profiles: { username: 'shareduser' }
            }
          ],
          error: null
        })
      )
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.getUserShares('project-123')

      expect(result).toHaveLength(1)
      expect(result[0].username).toBe('shareduser')
    })

    it('should use Unknown for missing username', async () => {
      const chainMock = createFullChainMock()
      chainMock.eq = vi.fn(() =>
        Promise.resolve({
          data: [
            {
              project_id: 'project-123',
              user_id: 'user-456',
              created_at: '2024-01-01T00:00:00Z',
              user_profiles: null
            }
          ],
          error: null
        })
      )
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.getUserShares('project-123')

      expect(result[0].username).toBe('Unknown')
    })

    it('should return empty array when no data', async () => {
      const chainMock = createFullChainMock()
      chainMock.eq = vi.fn(() => Promise.resolve({ data: null, error: null }))
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.getUserShares('project-123')

      expect(result).toEqual([])
    })
  })

  describe('findUserByUsername', () => {
    it('should find user by username', async () => {
      const chainMock = createFullChainMock({
        data: { id: 'user-123', username: 'testuser' },
        error: null
      })
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.findUserByUsername('TestUser')

      expect(mockSupabase.from).toHaveBeenCalledWith('user_profiles')
      expect(result?.username).toBe('testuser')
    })

    it('should return null when not found', async () => {
      const chainMock = createFullChainMock({
        data: null,
        error: { code: 'PGRST116', message: 'Not found' }
      })
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.findUserByUsername('nonexistent')

      expect(result).toBeNull()
    })

    it('should return null when data is null', async () => {
      const chainMock = createFullChainMock({ data: null, error: null })
      mockSupabase.from.mockReturnValue(chainMock)

      const result = await repository.findUserByUsername('test')

      expect(result).toBeNull()
    })

    it('should throw on other errors', async () => {
      const chainMock = createFullChainMock({
        data: null,
        error: { code: 'OTHER', message: 'Database error' }
      })
      mockSupabase.from.mockReturnValue(chainMock)

      await expect(repository.findUserByUsername('test')).rejects.toEqual({
        code: 'OTHER',
        message: 'Database error'
      })
    })
  })

  describe('addUserShare', () => {
    it('should add user share', async () => {
      // Get user profile
      const profileMock = createFullChainMock({
        data: { username: 'shareduser' },
        error: null
      })
      // Insert share
      const insertMock = createFullChainMock()
      insertMock.insert = vi.fn(() => Promise.resolve({ error: null }))

      mockSupabase.from
        .mockReturnValueOnce(profileMock)
        .mockReturnValueOnce(insertMock)

      const result = await repository.addUserShare('project-123', 'user-456')

      expect(result.userId).toBe('user-456')
      expect(result.username).toBe('shareduser')
    })

    it('should throw when user not found', async () => {
      const profileMock = createFullChainMock({
        data: null,
        error: { code: 'PGRST116', message: 'Not found' }
      })
      mockSupabase.from.mockReturnValue(profileMock)

      await expect(
        repository.addUserShare('project-123', 'user-456')
      ).rejects.toThrow('User with id user-456 not found')
    })

    it('should ignore duplicate share error', async () => {
      const profileMock = createFullChainMock({
        data: { username: 'shareduser' },
        error: null
      })
      const insertMock = createFullChainMock()
      insertMock.insert = vi.fn(() =>
        Promise.resolve({ error: { code: '23505', message: 'Duplicate' } })
      )

      mockSupabase.from
        .mockReturnValueOnce(profileMock)
        .mockReturnValueOnce(insertMock)

      const result = await repository.addUserShare('project-123', 'user-456')

      expect(result.username).toBe('shareduser')
    })

    it('should throw on insert error', async () => {
      const profileMock = createFullChainMock({
        data: { username: 'shareduser' },
        error: null
      })
      const insertMock = createFullChainMock()
      insertMock.insert = vi.fn(() =>
        Promise.resolve({ error: { code: 'OTHER', message: 'Insert failed' } })
      )

      mockSupabase.from
        .mockReturnValueOnce(profileMock)
        .mockReturnValueOnce(insertMock)

      await expect(
        repository.addUserShare('project-123', 'user-456')
      ).rejects.toEqual({ code: 'OTHER', message: 'Insert failed' })
    })
  })

  describe('removeUserShare', () => {
    it('should remove user share', async () => {
      const chainMock = createFullChainMock()
      const eqMock = vi.fn(() => Promise.resolve({ error: null }))
      chainMock.eq = vi.fn(() => ({ eq: eqMock }))
      mockSupabase.from.mockReturnValue(chainMock)

      await repository.removeUserShare('project-123', 'user-456')

      expect(mockSupabase.from).toHaveBeenCalledWith('project_shares')
      expect(chainMock.delete).toHaveBeenCalled()
    })

    it('should throw on error', async () => {
      const chainMock = createFullChainMock()
      const eqMock = vi.fn(() =>
        Promise.resolve({ error: { message: 'Delete failed' } })
      )
      chainMock.eq = vi.fn(() => ({ eq: eqMock }))
      mockSupabase.from.mockReturnValue(chainMock)

      await expect(
        repository.removeUserShare('project-123', 'user-456')
      ).rejects.toEqual({ message: 'Delete failed' })
    })
  })
})
