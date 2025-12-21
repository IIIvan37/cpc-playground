import { describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { NotFoundError, UnauthorizedError } from '@/domain/errors/domain.error'
import { createAuthorizationService } from '@/domain/services'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createDeleteProjectUseCase } from '../delete-project.use-case'

function createTestDependencies() {
  const repository = createInMemoryProjectsRepository()
  const authorizationService = createAuthorizationService(repository)
  return { repository, authorizationService }
}

describe('DeleteProjectUseCase', () => {
  it('should delete project when user is owner', async () => {
    const { repository, authorizationService } = createTestDependencies()

    const project = createProject({
      id: '123',
      userId: 'user-1',
      name: createProjectName('My Project'),
      visibility: Visibility.PRIVATE
    })

    await repository.create(project)

    const useCase = createDeleteProjectUseCase(repository, authorizationService)

    const result = await useCase.execute({
      projectId: '123',
      userId: 'user-1'
    })

    expect(result.success).toBe(true)

    // Verify project was actually deleted
    const deletedProject = await repository.findById('123')
    expect(deletedProject).toBeNull()
  })

  it('should throw NotFoundError when project does not exist', async () => {
    const { repository, authorizationService } = createTestDependencies()
    const useCase = createDeleteProjectUseCase(repository, authorizationService)

    await expect(
      useCase.execute({
        projectId: '123',
        userId: 'user-1'
      })
    ).rejects.toThrow(NotFoundError)
  })

  it('should throw UnauthorizedError when user is not owner', async () => {
    const { repository, authorizationService } = createTestDependencies()

    const project = createProject({
      id: '123',
      userId: 'user-1',
      name: createProjectName('My Project'),
      visibility: Visibility.PRIVATE
    })

    await repository.create(project)

    const useCase = createDeleteProjectUseCase(repository, authorizationService)

    await expect(
      useCase.execute({
        projectId: '123',
        userId: 'user-2' // Different user
      })
    ).rejects.toThrow(UnauthorizedError)

    // Verify project was NOT deleted
    const stillExistingProject = await repository.findById('123')
    expect(stillExistingProject).not.toBeNull()
  })
})
