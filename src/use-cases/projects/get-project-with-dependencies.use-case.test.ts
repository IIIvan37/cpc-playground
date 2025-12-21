import { beforeEach, describe, expect, it } from 'vitest'
import { createProject } from '../../domain/entities/project.entity'
import { createProjectFile } from '../../domain/entities/project-file.entity'
import { createFileContent } from '../../domain/value-objects/file-content.vo'
import { createFileName } from '../../domain/value-objects/file-name.vo'
import { createProjectName } from '../../domain/value-objects/project-name.vo'
import { createVisibility } from '../../domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '../../infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createGetProjectWithDependenciesUseCase } from './get-project-with-dependencies.use-case'

describe('Get Project With Dependencies Use Case', () => {
  let repository: ReturnType<typeof createInMemoryProjectsRepository>
  let useCase: ReturnType<typeof createGetProjectWithDependenciesUseCase>

  beforeEach(() => {
    repository = createInMemoryProjectsRepository()
    useCase = createGetProjectWithDependenciesUseCase(repository)
  })

  it('should get project files without dependencies', async () => {
    // Arrange
    const project = createProject({
      id: 'project-1',
      userId: 'user-1',
      name: createProjectName('My Project'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-1',
          name: createFileName('main.asm'),
          content: createFileContent('org 100h'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: [],
      tags: [],
      shares: []
    })
    await repository.create(project)

    // Act
    const { files } = await useCase.execute({
      projectId: 'project-1',
      userId: 'user-1'
    })

    // Assert
    expect(files).toHaveLength(1)
    expect(files[0]).toMatchObject({
      id: 'file-1',
      projectId: 'project-1',
      projectName: 'My Project',
      name: 'main.asm',
      content: 'org 100h',
      isMain: true,
      order: 0
    })
  })

  it('should get project files with one dependency', async () => {
    // Arrange
    // Dependency project
    const dependency = createProject({
      id: 'lib-1',
      userId: 'user-1',
      name: createProjectName('Library'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-lib',
          name: createFileName('lib.asm'),
          content: createFileContent('lib code'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: [],
      tags: [],
      shares: []
    })
    await repository.create(dependency)

    // Main project with dependency
    const project = createProject({
      id: 'project-1',
      userId: 'user-1',
      name: createProjectName('My Project'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-1',
          name: createFileName('main.asm'),
          content: createFileContent('org 100h'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: ['lib-1'],
      tags: [],
      shares: []
    })
    await repository.create(project)

    // Act
    const { files } = await useCase.execute({
      projectId: 'project-1',
      userId: 'user-1'
    })

    // Assert
    expect(files).toHaveLength(2)
    expect(files[0]).toMatchObject({
      projectName: 'My Project',
      name: 'main.asm'
    })
    expect(files[1]).toMatchObject({
      projectName: 'Library',
      name: 'lib.asm'
    })
  })

  it('should handle nested dependencies', async () => {
    // Arrange
    // Level 3: deepest dependency
    const deepLib = createProject({
      id: 'lib-3',
      userId: 'user-1',
      name: createProjectName('Deep Library'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-3',
          name: createFileName('deep.asm'),
          content: createFileContent('deep code'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: [],
      tags: [],
      shares: []
    })
    await repository.create(deepLib)

    // Level 2: mid dependency
    const midLib = createProject({
      id: 'lib-2',
      userId: 'user-1',
      name: createProjectName('Mid Library'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-2',
          name: createFileName('mid.asm'),
          content: createFileContent('mid code'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: ['lib-3'],
      tags: [],
      shares: []
    })
    await repository.create(midLib)

    // Level 1: main project
    const project = createProject({
      id: 'project-1',
      userId: 'user-1',
      name: createProjectName('My Project'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-1',
          name: createFileName('main.asm'),
          content: createFileContent('org 100h'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: ['lib-2'],
      tags: [],
      shares: []
    })
    await repository.create(project)

    // Act
    const { files } = await useCase.execute({
      projectId: 'project-1',
      userId: 'user-1'
    })

    // Assert
    expect(files).toHaveLength(3)
    expect(files[0].projectName).toBe('My Project')
    expect(files[1].projectName).toBe('Mid Library')
    expect(files[2].projectName).toBe('Deep Library')
  })

  it('should prevent circular dependencies', async () => {
    // Arrange
    // Create projects with circular dependency
    const project1 = createProject({
      id: 'project-1',
      userId: 'user-1',
      name: createProjectName('Project 1'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-1',
          name: createFileName('file1.asm'),
          content: createFileContent('code 1'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: ['project-2'],
      tags: [],
      shares: []
    })

    const project2 = createProject({
      id: 'project-2',
      userId: 'user-1',
      name: createProjectName('Project 2'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-2',
          name: createFileName('file2.asm'),
          content: createFileContent('code 2'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: ['project-1'], // Circular reference
      tags: [],
      shares: []
    })

    await repository.create(project1)
    await repository.create(project2)

    // Act
    const { files } = await useCase.execute({
      projectId: 'project-1',
      userId: 'user-1'
    })

    // Assert
    // Should not infinite loop and should return files from both projects only once
    expect(files).toHaveLength(2)
    expect(files.map((f) => f.projectName)).toContain('Project 1')
    expect(files.map((f) => f.projectName)).toContain('Project 2')
  })

  it('should throw error if project not found', async () => {
    // Act & Assert
    await expect(
      useCase.execute({
        projectId: 'nonexistent',
        userId: 'user-1'
      })
    ).rejects.toThrow('Project not found: nonexistent')
  })

  it('should throw error if user has no access to private project', async () => {
    // Arrange
    const project = createProject({
      id: 'project-1',
      userId: 'owner',
      name: createProjectName('Private Project'),
      visibility: createVisibility('private'),
      files: [
        createProjectFile({
          id: 'file-1',
          name: createFileName('main.asm'),
          content: createFileContent('org 100h'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: [],
      tags: [],
      shares: []
    })
    await repository.create(project)

    // Act & Assert
    await expect(
      useCase.execute({
        projectId: 'project-1',
        userId: 'other-user'
      })
    ).rejects.toThrow('Access denied to project')
  })

  it('should throw error if user has no access to private dependency', async () => {
    // Arrange
    // Private dependency
    const dependency = createProject({
      id: 'lib-1',
      userId: 'owner',
      name: createProjectName('Private Library'),
      visibility: createVisibility('private'),
      files: [
        createProjectFile({
          id: 'file-lib',
          name: createFileName('lib.asm'),
          content: createFileContent('lib code'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: [],
      tags: [],
      shares: []
    })
    await repository.create(dependency)

    // Public project with private dependency
    const project = createProject({
      id: 'project-1',
      userId: 'user-1',
      name: createProjectName('My Project'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-1',
          name: createFileName('main.asm'),
          content: createFileContent('org 100h'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: ['lib-1'],
      tags: [],
      shares: []
    })
    await repository.create(project)

    // Act & Assert
    await expect(
      useCase.execute({
        projectId: 'project-1',
        userId: 'user-1'
      })
    ).rejects.toThrow('Access denied to project')
  })

  it('should allow access to public dependencies', async () => {
    // Arrange
    // Public dependency owned by someone else
    const dependency = createProject({
      id: 'lib-1',
      userId: 'owner',
      name: createProjectName('Public Library'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-lib',
          name: createFileName('lib.asm'),
          content: createFileContent('lib code'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: [],
      tags: [],
      shares: []
    })
    await repository.create(dependency)

    // User's project with public dependency
    const project = createProject({
      id: 'project-1',
      userId: 'user-1',
      name: createProjectName('My Project'),
      visibility: createVisibility('public'),
      files: [
        createProjectFile({
          id: 'file-1',
          name: createFileName('main.asm'),
          content: createFileContent('org 100h'),
          isMain: true,
          order: 0
        })
      ],
      dependencies: ['lib-1'],
      tags: [],
      shares: []
    })
    await repository.create(project)

    // Act
    const { files } = await useCase.execute({
      projectId: 'project-1',
      userId: 'user-1'
    })

    // Assert
    expect(files).toHaveLength(2)
    expect(files[0].projectName).toBe('My Project')
    expect(files[1].projectName).toBe('Public Library')
  })
})
