import { beforeEach, describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { ValidationError } from '@/domain/errors'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
import { createMockAuthorizationService } from '@/domain/services/__tests__/mock-authorization.service'
import { AUTH_ERROR_MESSAGES } from '@/domain/services/authorization.service'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createAddDependencyUseCase } from '../add-dependency.use-case'

describe('AddDependencyUseCase', () => {
  let repository: IProjectsRepository
  let authorizationService: AuthorizationService
  let useCase: ReturnType<typeof createAddDependencyUseCase>
  const userId = 'user-123'
  const projectId = 'project-456'
  const libraryId = 'library-789'

  beforeEach(async () => {
    repository = createInMemoryProjectsRepository()
    authorizationService = createMockAuthorizationService(repository)
    useCase = createAddDependencyUseCase(repository, authorizationService)

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

  it('should add a library as dependency', async () => {
    const result = await useCase.execute({
      projectId,
      userId,
      dependencyId: libraryId
    })

    expect(result.success).toBe(true)

    // Verify dependency was added
    const deps = await repository.getDependencies(projectId)
    expect(deps).toContain(libraryId)
  })

  it('should throw ProjectNotFoundError for non-existent project', async () => {
    await expect(
      useCase.execute({
        projectId: 'non-existent',
        userId,
        dependencyId: libraryId
      })
    ).rejects.toThrow(AUTH_ERROR_MESSAGES.PROJECT_NOT_FOUND)
  })

  it('should throw UnauthorizedError when user does not own the project', async () => {
    await expect(
      useCase.execute({
        projectId,
        userId: 'other-user',
        dependencyId: libraryId
      })
    ).rejects.toThrow(AUTH_ERROR_MESSAGES.UNAUTHORIZED_MODIFY)
  })

  it('should throw ValidationError when trying to depend on itself', async () => {
    // Make the project a library first so the library check passes
    await repository.update(projectId, { isLibrary: true })

    await expect(
      useCase.execute({
        projectId,
        userId,
        dependencyId: projectId
      })
    ).rejects.toThrow(ValidationError)
  })

  it('should throw NotFoundError for non-existent dependency', async () => {
    await expect(
      useCase.execute({
        projectId,
        userId,
        dependencyId: 'non-existent-lib'
      })
    ).rejects.toThrow('Dependency project with id non-existent-lib not found')
  })

  it('should throw ValidationError when dependency is not a library', async () => {
    // Create another non-library project
    const nonLibrary = createProject({
      id: 'non-library-project',
      userId: 'other-user',
      name: createProjectName('Not A Library'),
      description: null,
      visibility: createVisibility('public'),
      isLibrary: false,
      files: [],
      shares: [],
      tags: [],
      dependencies: [],
      createdAt: new Date(),
      updatedAt: new Date()
    })
    await repository.create(nonLibrary)

    await expect(
      useCase.execute({
        projectId,
        userId,
        dependencyId: 'non-library-project'
      })
    ).rejects.toThrow(ValidationError)
  })

  it('should allow multiple dependencies', async () => {
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

    // Add first dependency
    await useCase.execute({
      projectId,
      userId,
      dependencyId: libraryId
    })

    // Add second dependency
    await useCase.execute({
      projectId,
      userId,
      dependencyId: 'library-2'
    })

    const deps = await repository.getDependencies(projectId)
    expect(deps.length).toBe(2)
    expect(deps).toContain(libraryId)
    expect(deps).toContain('library-2')
  })

  it('should not add duplicate dependencies', async () => {
    // Add dependency
    await useCase.execute({
      projectId,
      userId,
      dependencyId: libraryId
    })

    // Add same dependency again
    await useCase.execute({
      projectId,
      userId,
      dependencyId: libraryId
    })

    // Should still have only one dependency
    const deps = await repository.getDependencies(projectId)
    expect(deps.length).toBe(1)
  })
})
