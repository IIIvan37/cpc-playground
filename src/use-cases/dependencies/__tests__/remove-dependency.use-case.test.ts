import { beforeEach, describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
import { createMockAuthorizationService } from '@/domain/services/__tests__/mock-authorization.service'
import { AUTH_ERROR_MESSAGES } from '@/domain/services/authorization.service'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createAddDependencyUseCase } from '../add-dependency.use-case'
import { createRemoveDependencyUseCase } from '../remove-dependency.use-case'

describe('RemoveDependencyUseCase', () => {
  let repository: IProjectsRepository
  let authorizationService: AuthorizationService
  let addDependencyUseCase: ReturnType<typeof createAddDependencyUseCase>
  let removeDependencyUseCase: ReturnType<typeof createRemoveDependencyUseCase>
  const userId = 'user-123'
  const projectId = 'project-456'
  const libraryId = 'library-789'

  beforeEach(async () => {
    repository = createInMemoryProjectsRepository()
    authorizationService = createMockAuthorizationService(repository)
    addDependencyUseCase = createAddDependencyUseCase(
      repository,
      authorizationService
    )
    removeDependencyUseCase = createRemoveDependencyUseCase(
      repository,
      authorizationService
    )

    // Create a test project
    const project = createProject({
      id: projectId,
      userId,
      name: createProjectName('Test Project'),
      description: null,
      visibility: createVisibility('private'),
      isLibrary: false,
      files: [],
      shares: [],
      tags: [],
      dependencies: [],
      createdAt: new Date(),
      updatedAt: new Date()
    })
    await repository.create(project)

    // Create a library project
    const library = createProject({
      id: libraryId,
      userId: 'other-user',
      name: createProjectName('Test Library'),
      description: 'A shared library',
      visibility: createVisibility('public'),
      isLibrary: true,
      files: [],
      shares: [],
      tags: [],
      dependencies: [],
      createdAt: new Date(),
      updatedAt: new Date()
    })
    await repository.create(library)
  })

  it('should remove a dependency from a project', async () => {
    // Add a dependency first
    await addDependencyUseCase.execute({
      projectId,
      userId,
      dependencyId: libraryId
    })

    // Verify dependency exists
    let deps = await repository.getDependencies(projectId)
    expect(deps.length).toBe(1)

    // Remove the dependency
    const result = await removeDependencyUseCase.execute({
      projectId,
      userId,
      dependencyId: libraryId
    })

    expect(result.success).toBe(true)

    // Verify dependency is removed
    deps = await repository.getDependencies(projectId)
    expect(deps.length).toBe(0)
  })

  it('should only remove the specified dependency', async () => {
    // Create another library
    const library2 = createProject({
      id: 'library-2',
      userId: 'other-user',
      name: createProjectName('Another Library'),
      description: null,
      visibility: createVisibility('public'),
      isLibrary: true,
      files: [],
      shares: [],
      tags: [],
      dependencies: [],
      createdAt: new Date(),
      updatedAt: new Date()
    })
    await repository.create(library2)

    // Add dependencies
    await addDependencyUseCase.execute({
      projectId,
      userId,
      dependencyId: libraryId
    })
    await addDependencyUseCase.execute({
      projectId,
      userId,
      dependencyId: 'library-2'
    })

    // Verify 2 dependencies exist
    let deps = await repository.getDependencies(projectId)
    expect(deps.length).toBe(2)

    // Remove one dependency
    await removeDependencyUseCase.execute({
      projectId,
      userId,
      dependencyId: libraryId
    })

    // Verify only 1 dependency remains
    deps = await repository.getDependencies(projectId)
    expect(deps.length).toBe(1)
    expect(deps).not.toContain(libraryId)
    expect(deps).toContain('library-2')
  })

  it('should throw ProjectNotFoundError for non-existent project', async () => {
    await expect(
      removeDependencyUseCase.execute({
        projectId: 'non-existent',
        userId,
        dependencyId: libraryId
      })
    ).rejects.toThrow(AUTH_ERROR_MESSAGES.PROJECT_NOT_FOUND)
  })

  it('should throw UnauthorizedError when user does not own the project', async () => {
    await addDependencyUseCase.execute({
      projectId,
      userId,
      dependencyId: libraryId
    })

    await expect(
      removeDependencyUseCase.execute({
        projectId,
        userId: 'other-user',
        dependencyId: libraryId
      })
    ).rejects.toThrow(AUTH_ERROR_MESSAGES.UNAUTHORIZED_MODIFY)
  })

  it('should succeed even if dependency does not exist', async () => {
    // This should not throw - removing a non-existent dependency is a no-op
    const result = await removeDependencyUseCase.execute({
      projectId,
      userId,
      dependencyId: 'non-existent-dep'
    })

    expect(result.success).toBe(true)
  })
})
