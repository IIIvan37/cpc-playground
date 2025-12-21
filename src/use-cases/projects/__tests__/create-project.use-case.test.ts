import { describe, expect, it } from 'vitest'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createCreateProjectUseCase } from '../create-project.use-case'

describe('CreateProjectUseCase', () => {
  it('should create a project with valid input', async () => {
    const repository = createInMemoryProjectsRepository()
    const useCase = createCreateProjectUseCase(repository)

    const result = await useCase.execute({
      userId: 'user-1',
      name: 'My Project'
    })

    expect(result.project.name.value).toBe('My Project')
    expect(result.project.userId).toBe('user-1')

    // Verify project was actually saved
    const savedProject = await repository.findById(result.project.id)
    expect(savedProject).not.toBeNull()
    expect(savedProject?.name.value).toBe('My Project')
  })

  it('should create a project with files', async () => {
    const repository = createInMemoryProjectsRepository()
    const useCase = createCreateProjectUseCase(repository)

    const result = await useCase.execute({
      userId: 'user-1',
      name: 'My Project',
      files: [{ name: 'main.asm', content: 'LD A, 10', isMain: true }]
    })

    expect(result.project.files.length).toBe(1)
    expect(result.project.files[0].name.value).toBe('main.asm')
    expect(result.project.files[0].isMain).toBe(true)
  })

  it('should throw ValidationError for invalid project name', async () => {
    const repository = createInMemoryProjectsRepository()
    const useCase = createCreateProjectUseCase(repository)

    await expect(
      useCase.execute({
        userId: 'user-1',
        name: 'ab' // Too short
      })
    ).rejects.toThrow('at least 3 characters')
  })

  it('should set default visibility to private', async () => {
    const repository = createInMemoryProjectsRepository()
    const useCase = createCreateProjectUseCase(repository)

    const result = await useCase.execute({
      userId: 'user-1',
      name: 'My Project'
    })

    expect(result.project.visibility.value).toBe('private')
  })

  it('should create a library project with isLibrary flag', async () => {
    const repository = createInMemoryProjectsRepository()
    const useCase = createCreateProjectUseCase(repository)

    const result = await useCase.execute({
      userId: 'user-1',
      name: 'My Library',
      isLibrary: true
    })

    expect(result.project.isLibrary).toBe(true)
  })

  it('should NOT set isMain on files for library projects', async () => {
    const repository = createInMemoryProjectsRepository()
    const useCase = createCreateProjectUseCase(repository)

    const result = await useCase.execute({
      userId: 'user-1',
      name: 'My Library',
      isLibrary: true,
      files: [{ name: 'lib.asm', content: 'helper code', isMain: true }]
    })

    // Even though isMain: true was passed, library projects should not have main files
    expect(result.project.files[0].isMain).toBe(false)
  })

  it('should set first file as main for non-library projects by default', async () => {
    const repository = createInMemoryProjectsRepository()
    const useCase = createCreateProjectUseCase(repository)

    const result = await useCase.execute({
      userId: 'user-1',
      name: 'My Project',
      isLibrary: false,
      files: [
        { name: 'main.asm', content: 'code' },
        { name: 'utils.asm', content: 'utils' }
      ]
    })

    expect(result.project.files[0].isMain).toBe(true)
    expect(result.project.files[1].isMain).toBe(false)
  })
})
