import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { createUpdateProjectUseCase } from '../update-project.use-case'

describe('UpdateProjectUseCase', () => {
  let mockRepository: IProjectsRepository
  let mockAuthService: AuthorizationService
  let useCase: ReturnType<typeof createUpdateProjectUseCase>

  const testProject = createProject({
    id: 'project-123',
    userId: 'user-123',
    name: createProjectName('Original Name'),
    description: 'Original description',
    visibility: createVisibility('private'),
    isLibrary: false
  })

  beforeEach(() => {
    mockRepository = {
      findById: vi.fn(),
      findByShareCode: vi.fn(),
      findAll: vi.fn(),
      findVisible: vi.fn(),
      create: vi.fn(),
      update: vi.fn().mockImplementation((_id, project) => project),
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
      removeUserShare: vi.fn(),
      getAllTags: vi.fn()
    }
    mockAuthService = {
      canReadProject: vi.fn(),
      mustOwnProject: vi.fn().mockResolvedValue(testProject),
      canAccessAsDependency: vi.fn()
    }
    useCase = createUpdateProjectUseCase(mockRepository, mockAuthService)
  })

  describe('execute', () => {
    it('should verify ownership before updating', async () => {
      await useCase.execute({
        projectId: 'project-123',
        userId: 'user-123',
        updates: { name: 'New Name' }
      })

      expect(mockAuthService.mustOwnProject).toHaveBeenCalledWith(
        'project-123',
        'user-123'
      )
    })

    it('should update project name', async () => {
      const result = await useCase.execute({
        projectId: 'project-123',
        userId: 'user-123',
        updates: { name: 'New Name' }
      })

      expect(result.project.name.value).toBe('New Name')
      expect(mockRepository.update).toHaveBeenCalled()
    })

    it('should update project description', async () => {
      const result = await useCase.execute({
        projectId: 'project-123',
        userId: 'user-123',
        updates: { description: 'New description' }
      })

      expect(result.project.description).toBe('New description')
    })

    it('should update project description to null', async () => {
      const result = await useCase.execute({
        projectId: 'project-123',
        userId: 'user-123',
        updates: { description: null }
      })

      expect(result.project.description).toBeNull()
    })

    it('should update project visibility', async () => {
      const result = await useCase.execute({
        projectId: 'project-123',
        userId: 'user-123',
        updates: { visibility: 'public' }
      })

      expect(result.project.visibility.value).toBe('public')
    })

    it('should update project isLibrary', async () => {
      const result = await useCase.execute({
        projectId: 'project-123',
        userId: 'user-123',
        updates: { isLibrary: true }
      })

      expect(result.project.isLibrary).toBe(true)
    })

    it('should update multiple fields at once', async () => {
      const result = await useCase.execute({
        projectId: 'project-123',
        userId: 'user-123',
        updates: {
          name: 'New Name',
          description: 'New desc',
          visibility: 'public',
          isLibrary: true
        }
      })

      expect(result.project.name.value).toBe('New Name')
      expect(result.project.description).toBe('New desc')
      expect(result.project.visibility.value).toBe('public')
      expect(result.project.isLibrary).toBe(true)
    })

    it('should not modify fields that are not in updates', async () => {
      const result = await useCase.execute({
        projectId: 'project-123',
        userId: 'user-123',
        updates: { name: 'New Name' }
      })

      expect(result.project.description).toBe('Original description')
      expect(result.project.visibility.value).toBe('private')
      expect(result.project.isLibrary).toBe(false)
    })

    it('should persist updates to repository', async () => {
      await useCase.execute({
        projectId: 'project-123',
        userId: 'user-123',
        updates: { name: 'New Name' }
      })

      expect(mockRepository.update).toHaveBeenCalledWith(
        'project-123',
        expect.objectContaining({
          name: expect.objectContaining({ value: 'New Name' })
        })
      )
    })
  })
})
