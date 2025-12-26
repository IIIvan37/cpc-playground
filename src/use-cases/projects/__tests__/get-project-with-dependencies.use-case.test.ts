import { beforeEach, describe, expect, it, vi } from 'vitest'
import {
  createProject,
  type DependencyInfo
} from '@/domain/entities/project.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
import { createAuthorizationService } from '@/domain/services'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import type { GetProjectUseCase } from '../get-project.use-case'
import { createGetProjectWithDependenciesUseCase } from '../get-project-with-dependencies.use-case'

describe('GetProjectWithDependenciesUseCase', () => {
  let repository: IProjectsRepository
  let authorizationService: AuthorizationService
  let getProject: GetProjectUseCase
  let useCase: ReturnType<typeof createGetProjectWithDependenciesUseCase>
  const userId = 'user-123'
  const mainProjectId = 'main-project'
  const libraryId = 'library-project'

  beforeEach(async () => {
    repository = createInMemoryProjectsRepository()
    authorizationService = createAuthorizationService(repository)
    getProject = {
      execute: vi.fn(async ({ projectId, userId: uid }) => {
        const project = await repository.findById(projectId)
        if (!project) {
          throw new Error(`Project not found: ${projectId}`)
        }
        // Simulate the authorization check from getProject
        if (!uid) {
          if (project.visibility.value !== 'public') {
            throw new Error('Access denied to project')
          }
        } else {
          const canRead = await authorizationService.canReadProject(
            project,
            uid
          )
          if (!canRead) {
            throw new Error('Access denied to project')
          }
        }
        return { project }
      })
    }
    useCase = createGetProjectWithDependenciesUseCase(getProject)
  })

  async function createTestProject(overrides: {
    id: string
    userId?: string
    name?: string
    isLibrary?: boolean
    visibility?: 'private' | 'public' | 'unlisted'
    files?: Array<{ name: string; content: string; isMain?: boolean }>
    dependencies?: DependencyInfo[]
  }) {
    const files =
      overrides.files?.map((f, index) =>
        createProjectFile({
          id: `${overrides.id}-file-${index}`,
          projectId: overrides.id,
          name: createFileName(f.name),
          content: createFileContent(f.content),
          isMain: f.isMain ?? index === 0,
          order: index
        })
      ) ?? []

    const project = createProject({
      id: overrides.id,
      userId: overrides.userId ?? userId,
      name: createProjectName(overrides.name ?? 'Test Project'),
      description: null,
      visibility: createVisibility(overrides.visibility ?? 'private'),
      isLibrary: overrides.isLibrary ?? false,
      files,
      shares: [],
      tags: [],
      dependencies: overrides.dependencies ?? [],
      createdAt: new Date(),
      updatedAt: new Date()
    })

    await repository.create(project)
    return project
  }

  it('should return files from project without dependencies', async () => {
    await createTestProject({
      id: mainProjectId,
      files: [
        { name: 'main.asm', content: 'LD A, 10', isMain: true },
        { name: 'utils.asm', content: '; utils' }
      ]
    })

    const result = await useCase.execute({
      projectId: mainProjectId,
      userId
    })

    expect(result.files).toHaveLength(2)
    expect(result.files.map((f) => f.name)).toContain('main.asm')
    expect(result.files.map((f) => f.name)).toContain('utils.asm')
  })

  it('should return files from project and its dependencies', async () => {
    // Create library project
    await createTestProject({
      id: libraryId,
      isLibrary: true,
      visibility: 'public',
      files: [{ name: 'lib.asm', content: '; library code' }]
    })

    // Create main project with dependency
    await createTestProject({
      id: mainProjectId,
      files: [{ name: 'main.asm', content: 'INCLUDE "lib.asm"' }],
      dependencies: [{ id: libraryId, name: 'Library' }]
    })

    const result = await useCase.execute({
      projectId: mainProjectId,
      userId
    })

    expect(result.files).toHaveLength(2)
    expect(result.files.map((f) => f.name)).toContain('main.asm')
    expect(result.files.map((f) => f.name)).toContain('lib.asm')
  })

  it('should include project context in returned files', async () => {
    await createTestProject({
      id: mainProjectId,
      name: 'My Project',
      files: [{ name: 'main.asm', content: 'code' }]
    })

    const result = await useCase.execute({
      projectId: mainProjectId,
      userId
    })

    const file = result.files[0]
    expect(file.projectId).toBe(mainProjectId)
    expect(file.projectName).toBe('My Project')
    expect(file.name).toBe('main.asm')
    expect(file.content).toBe('code')
    expect(file.isMain).toBe(true)
    expect(file.order).toBe(0)
  })

  it('should handle nested dependencies', async () => {
    const nestedLibId = 'nested-lib'

    // Create nested library (dependency of dependency)
    await createTestProject({
      id: nestedLibId,
      isLibrary: true,
      visibility: 'public',
      files: [{ name: 'nested.asm', content: '; nested' }]
    })

    // Create library that depends on nested library
    await createTestProject({
      id: libraryId,
      isLibrary: true,
      visibility: 'public',
      files: [{ name: 'lib.asm', content: '; lib' }],
      dependencies: [{ id: nestedLibId, name: 'Nested Library' }]
    })

    // Create main project
    await createTestProject({
      id: mainProjectId,
      files: [{ name: 'main.asm', content: '; main' }],
      dependencies: [{ id: libraryId, name: 'Library' }]
    })

    const result = await useCase.execute({
      projectId: mainProjectId,
      userId
    })

    expect(result.files).toHaveLength(3)
    expect(result.files.map((f) => f.name)).toContain('main.asm')
    expect(result.files.map((f) => f.name)).toContain('lib.asm')
    expect(result.files.map((f) => f.name)).toContain('nested.asm')
  })

  it('should prevent circular dependencies', async () => {
    const lib1Id = 'lib-1'
    const lib2Id = 'lib-2'

    // Create two libraries that depend on each other
    await createTestProject({
      id: lib1Id,
      isLibrary: true,
      visibility: 'public',
      files: [{ name: 'lib1.asm', content: '; lib1' }],
      dependencies: [{ id: lib2Id, name: 'Library 2' }]
    })

    await createTestProject({
      id: lib2Id,
      isLibrary: true,
      visibility: 'public',
      files: [{ name: 'lib2.asm', content: '; lib2' }],
      dependencies: [{ id: lib1Id, name: 'Library 1' }]
    })

    // Main project depends on lib1
    await createTestProject({
      id: mainProjectId,
      files: [{ name: 'main.asm', content: '; main' }],
      dependencies: [{ id: lib1Id, name: 'Library 1' }]
    })

    // Should not infinite loop
    const result = await useCase.execute({
      projectId: mainProjectId,
      userId
    })

    // Should get all unique files
    expect(result.files).toHaveLength(3)
    expect(result.files.map((f) => f.name)).toContain('main.asm')
    expect(result.files.map((f) => f.name)).toContain('lib1.asm')
    expect(result.files.map((f) => f.name)).toContain('lib2.asm')
  })

  it('should throw error when project not found', async () => {
    await expect(
      useCase.execute({
        projectId: 'non-existent',
        userId
      })
    ).rejects.toThrow('Project not found')
  })

  it('should throw error when user cannot access project', async () => {
    // Create private project owned by another user
    await createTestProject({
      id: mainProjectId,
      userId: 'other-user',
      visibility: 'private'
    })

    await expect(
      useCase.execute({
        projectId: mainProjectId,
        userId
      })
    ).rejects.toThrow('Access denied')
  })

  it('should allow access to public projects', async () => {
    await createTestProject({
      id: mainProjectId,
      userId: 'other-user',
      visibility: 'public',
      files: [{ name: 'public.asm', content: '; public' }]
    })

    const result = await useCase.execute({
      projectId: mainProjectId,
      userId
    })

    expect(result.files).toHaveLength(1)
    expect(result.files[0].name).toBe('public.asm')
  })

  it('should allow access to library projects', async () => {
    await createTestProject({
      id: mainProjectId,
      userId: 'other-user',
      visibility: 'private',
      isLibrary: true,
      files: [{ name: 'lib.asm', content: '; lib' }]
    })

    const result = await useCase.execute({
      projectId: mainProjectId,
      userId
    })

    expect(result.files).toHaveLength(1)
    expect(result.files[0].name).toBe('lib.asm')
  })

  it('should throw error when dependency is not accessible', async () => {
    // Create private library owned by another user (not accessible)
    await createTestProject({
      id: libraryId,
      userId: 'other-user',
      visibility: 'private',
      isLibrary: false, // Not a library, so not accessible
      files: [{ name: 'private.asm', content: '; private' }]
    })

    // Main project has dependency on inaccessible project
    await createTestProject({
      id: mainProjectId,
      files: [{ name: 'main.asm', content: '; main' }],
      dependencies: [{ id: libraryId, name: 'Private Library' }]
    })

    await expect(
      useCase.execute({
        projectId: mainProjectId,
        userId
      })
    ).rejects.toThrow('Access denied')
  })

  it('should return empty files array for project without files', async () => {
    await createTestProject({
      id: mainProjectId,
      files: []
    })

    const result = await useCase.execute({
      projectId: mainProjectId,
      userId
    })

    expect(result.files).toHaveLength(0)
  })

  it('should preserve file order', async () => {
    await createTestProject({
      id: mainProjectId,
      files: [
        { name: 'a.asm', content: 'a' },
        { name: 'b.asm', content: 'b' },
        { name: 'c.asm', content: 'c' }
      ]
    })

    const result = await useCase.execute({
      projectId: mainProjectId,
      userId
    })

    expect(result.files.map((f) => f.order)).toEqual([0, 1, 2])
  })

  it('should allow unauthenticated users to access public projects with public dependencies', async () => {
    // Create a public library dependency
    await createTestProject({
      id: libraryId,
      userId: 'other-user',
      name: 'Public Library',
      visibility: 'public',
      isLibrary: true,
      files: [{ name: 'utils.asm', content: '; utility functions' }]
    })

    // Create a public main project with dependency on the public library
    await createTestProject({
      id: mainProjectId,
      userId: 'another-user',
      name: 'Public Project',
      visibility: 'public',
      files: [{ name: 'main.asm', content: 'INCLUDE "utils.asm"' }],
      dependencies: [{ id: libraryId, name: 'Public Library' }]
    })

    // Execute as unauthenticated user (userId = undefined)
    const result = await useCase.execute({
      projectId: mainProjectId,
      userId: undefined
    })

    expect(result.files).toHaveLength(2)
    expect(result.files.map((f) => f.name)).toContain('main.asm')
    expect(result.files.map((f) => f.name)).toContain('utils.asm')

    // Verify project context is included
    const mainFile = result.files.find((f) => f.name === 'main.asm')
    const utilsFile = result.files.find((f) => f.name === 'utils.asm')

    expect(mainFile?.projectId).toBe(mainProjectId)
    expect(mainFile?.projectName).toBe('Public Project')
    expect(utilsFile?.projectId).toBe(libraryId)
    expect(utilsFile?.projectName).toBe('Public Library')
  })
})
