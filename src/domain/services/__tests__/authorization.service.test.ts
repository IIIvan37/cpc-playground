import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import {
  AUTH_ERROR_MESSAGES,
  createAuthorizationService
} from '../authorization.service'

describe('AuthorizationService', () => {
  let mockRepository: IProjectsRepository
  let service: ReturnType<typeof createAuthorizationService>

  const createTestProject = (overrides?: {
    userId?: string
    visibility?: 'private' | 'unlisted' | 'public'
    isLibrary?: boolean
  }) =>
    createProject({
      id: 'project-123',
      userId: overrides?.userId ?? 'owner-123',
      name: createProjectName('Test Project'),
      visibility: createVisibility(overrides?.visibility ?? 'private'),
      isLibrary: overrides?.isLibrary ?? false
    })

  beforeEach(() => {
    mockRepository = {
      findById: vi.fn(),
      findByShareCode: vi.fn(),
      findAll: vi.fn(),
      create: vi.fn(),
      update: vi.fn(),
      delete: vi.fn(),
      createFile: vi.fn(),
      updateFile: vi.fn(),
      deleteFile: vi.fn(),
      getShares: vi.fn(),
      createShare: vi.fn(),
      getTags: vi.fn(),
      addTag: vi.fn(),
      removeTag: vi.fn(),
      getDependencies: vi.fn(),
      addDependency: vi.fn(),
      removeDependency: vi.fn(),
      getUserShares: vi.fn().mockResolvedValue([]),
      findUserByUsername: vi.fn(),
      addUserShare: vi.fn(),
      removeUserShare: vi.fn()
    }
    service = createAuthorizationService(mockRepository)
  })

  describe('canReadProject', () => {
    it('should return false if project not found', async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(null)

      const result = await service.canReadProject('project-123', 'user-123')

      expect(result).toBe(false)
    })

    it('should return true for owner', async () => {
      const project = createTestProject({ userId: 'owner-123' })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)

      const result = await service.canReadProject('project-123', 'owner-123')

      expect(result).toBe(true)
    })

    it('should return true for public project', async () => {
      const project = createTestProject({
        userId: 'owner-123',
        visibility: 'public'
      })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)

      const result = await service.canReadProject('project-123', 'other-user')

      expect(result).toBe(true)
    })

    it('should return true for library project', async () => {
      const project = createTestProject({
        userId: 'owner-123',
        visibility: 'private',
        isLibrary: true
      })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)

      const result = await service.canReadProject('project-123', 'other-user')

      expect(result).toBe(true)
    })

    it('should return true for shared project', async () => {
      const project = createTestProject({
        userId: 'owner-123',
        visibility: 'private'
      })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)
      vi.mocked(mockRepository.getUserShares).mockResolvedValue([
        {
          projectId: 'project-123',
          userId: 'shared-user',
          username: 'shareduser',
          createdAt: new Date()
        }
      ])

      const result = await service.canReadProject('project-123', 'shared-user')

      expect(result).toBe(true)
    })

    it('should return false for private project without share', async () => {
      const project = createTestProject({
        userId: 'owner-123',
        visibility: 'private'
      })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)
      vi.mocked(mockRepository.getUserShares).mockResolvedValue([])

      const result = await service.canReadProject('project-123', 'other-user')

      expect(result).toBe(false)
    })

    it('should return false for unlisted project without share', async () => {
      const project = createTestProject({
        userId: 'owner-123',
        visibility: 'unlisted'
      })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)
      vi.mocked(mockRepository.getUserShares).mockResolvedValue([])

      const result = await service.canReadProject('project-123', 'other-user')

      expect(result).toBe(false)
    })
  })

  describe('mustOwnProject', () => {
    it('should throw NotFoundError if project not found', async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(null)

      await expect(
        service.mustOwnProject('project-123', 'user-123')
      ).rejects.toThrow(NotFoundError)

      await expect(
        service.mustOwnProject('project-123', 'user-123')
      ).rejects.toThrow(AUTH_ERROR_MESSAGES.PROJECT_NOT_FOUND)
    })

    it('should throw UnauthorizedError if user is not owner', async () => {
      const project = createTestProject({ userId: 'owner-123' })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)

      await expect(
        service.mustOwnProject('project-123', 'other-user')
      ).rejects.toThrow(UnauthorizedError)

      await expect(
        service.mustOwnProject('project-123', 'other-user')
      ).rejects.toThrow(AUTH_ERROR_MESSAGES.UNAUTHORIZED_MODIFY)
    })

    it('should return project if user is owner', async () => {
      const project = createTestProject({ userId: 'owner-123' })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)

      const result = await service.mustOwnProject('project-123', 'owner-123')

      expect(result).toBe(project)
    })
  })

  describe('canAccessAsDependency', () => {
    it('should return false if project not found', async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(null)

      const result = await service.canAccessAsDependency(
        'project-123',
        'user-123'
      )

      expect(result).toBe(false)
    })

    it('should return true for owner', async () => {
      const project = createTestProject({ userId: 'owner-123' })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)

      const result = await service.canAccessAsDependency(
        'project-123',
        'owner-123'
      )

      expect(result).toBe(true)
    })

    it('should return true for public project', async () => {
      const project = createTestProject({
        userId: 'owner-123',
        visibility: 'public'
      })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)

      const result = await service.canAccessAsDependency(
        'project-123',
        'other-user'
      )

      expect(result).toBe(true)
    })

    it('should return true for library project', async () => {
      const project = createTestProject({
        userId: 'owner-123',
        visibility: 'private',
        isLibrary: true
      })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)

      const result = await service.canAccessAsDependency(
        'project-123',
        'other-user'
      )

      expect(result).toBe(true)
    })

    it('should return false for private non-library project', async () => {
      const project = createTestProject({
        userId: 'owner-123',
        visibility: 'private',
        isLibrary: false
      })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)

      const result = await service.canAccessAsDependency(
        'project-123',
        'other-user'
      )

      expect(result).toBe(false)
    })

    it('should return false for unlisted non-library project', async () => {
      const project = createTestProject({
        userId: 'owner-123',
        visibility: 'unlisted',
        isLibrary: false
      })
      vi.mocked(mockRepository.findById).mockResolvedValue(project)

      const result = await service.canAccessAsDependency(
        'project-123',
        'other-user'
      )

      expect(result).toBe(false)
    })
  })
})
