import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { NotFoundError } from '@/domain/errors/domain.error'
import { PROJECT_ERRORS } from '@/domain/errors/error-messages'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { createGetProjectUseCase } from '../get-project.use-case'

describe('GetProjectUseCase', () => {
  let mockRepository: IProjectsRepository
  let mockAuthService: AuthorizationService
  let useCase: ReturnType<typeof createGetProjectUseCase>

  const testProject = createProject({
    id: 'project-123',
    userId: 'user-123',
    name: createProjectName('Test Project'),
    visibility: createVisibility('private')
  })

  const publicProject = createProject({
    id: 'public-project-123',
    userId: 'user-123',
    name: createProjectName('Public Project'),
    visibility: createVisibility('public')
  })

  beforeEach(() => {
    mockRepository = {
      findById: vi.fn(),
      findByShareCode: vi.fn(),
      findAll: vi.fn(),
      findVisible: vi.fn(),
      create: vi.fn(),
      update: vi.fn(),
      delete: vi.fn(),
      createFile: vi.fn(),
      updateFile: vi.fn(),
      deleteFile: vi.fn(),
      getTags: vi.fn(),
      addTag: vi.fn(),
      removeTag: vi.fn(),
      getDependencies: vi.fn(),
      addDependency: vi.fn(),
      removeDependency: vi.fn(),
      getUserShares: vi.fn(),
      findUserByUsername: vi.fn(),
      searchUsers: vi.fn(),
      addUserShare: vi.fn(),
      removeUserShare: vi.fn()
    }
    mockAuthService = {
      canReadProject: vi.fn(),
      mustOwnProject: vi.fn(),
      canAccessAsDependency: vi.fn()
    }
    useCase = createGetProjectUseCase(mockRepository, mockAuthService)
  })

  describe('execute', () => {
    it('should return public project when found without userId', async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(publicProject)

      const result = await useCase.execute({ projectId: 'public-project-123' })

      expect(result.project).toBe(publicProject)
      expect(mockRepository.findById).toHaveBeenCalledWith('public-project-123')
      expect(mockAuthService.canReadProject).not.toHaveBeenCalled()
    })

    it('should throw NotFoundError for private project without userId', async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(testProject)

      await expect(
        useCase.execute({ projectId: 'project-123' })
      ).rejects.toThrow(NotFoundError)
    })

    it('should throw NotFoundError when project not found', async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(null)

      await expect(
        useCase.execute({ projectId: 'non-existent' })
      ).rejects.toThrow(NotFoundError)

      await expect(
        useCase.execute({ projectId: 'non-existent' })
      ).rejects.toThrow(PROJECT_ERRORS.NOT_FOUND('non-existent'))
    })

    it('should return project when userId is provided and can read', async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(testProject)
      vi.mocked(mockAuthService.canReadProject).mockResolvedValue(true)

      const result = await useCase.execute({
        projectId: 'project-123',
        userId: 'user-123'
      })

      expect(mockAuthService.canReadProject).toHaveBeenCalledWith(
        'project-123',
        'user-123'
      )
      expect(result.project).toBe(testProject)
    })

    it('should throw NotFoundError when user cannot read project', async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(testProject)
      vi.mocked(mockAuthService.canReadProject).mockResolvedValue(false)

      await expect(
        useCase.execute({
          projectId: 'project-123',
          userId: 'unauthorized-user'
        })
      ).rejects.toThrow(NotFoundError)

      await expect(
        useCase.execute({
          projectId: 'project-123',
          userId: 'unauthorized-user'
        })
      ).rejects.toThrow(PROJECT_ERRORS.NOT_FOUND('project-123'))
    })
  })
})
