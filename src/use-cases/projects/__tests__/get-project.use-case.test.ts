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
      getUserShares: vi.fn(),
      findUserByUsername: vi.fn(),
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
    it('should return project when found', async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(testProject)

      const result = await useCase.execute({ projectId: 'project-123' })

      expect(result.project).toBe(testProject)
      expect(mockRepository.findById).toHaveBeenCalledWith('project-123')
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

    it('should check authorization when userId is provided', async () => {
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

    it('should not check authorization when userId is not provided', async () => {
      vi.mocked(mockRepository.findById).mockResolvedValue(testProject)

      await useCase.execute({ projectId: 'project-123' })

      expect(mockAuthService.canReadProject).not.toHaveBeenCalled()
    })
  })
})
