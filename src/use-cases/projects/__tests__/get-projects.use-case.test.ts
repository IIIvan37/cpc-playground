import { describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createGetProjectsUseCase } from '../get-projects.use-case'

describe('GetProjectsUseCase', () => {
  it('should return all projects for a user', async () => {
    const repository = createInMemoryProjectsRepository()

    const project1 = createProject({
      id: '1',
      userId: 'user-1',
      name: createProjectName('Project 1'),
      visibility: Visibility.PRIVATE
    })

    const project2 = createProject({
      id: '2',
      userId: 'user-1',
      name: createProjectName('Project 2'),
      visibility: Visibility.PUBLIC
    })

    await repository.create(project1)
    await repository.create(project2)

    const useCase = createGetProjectsUseCase(repository)

    const result = await useCase.execute({ userId: 'user-1' })

    expect(result.projects).toHaveLength(2)
    expect(result.projects[0].name.value).toBe('Project 1')
    expect(result.projects[1].name.value).toBe('Project 2')
  })

  it('should return empty array when no projects exist', async () => {
    const repository = createInMemoryProjectsRepository()
    const useCase = createGetProjectsUseCase(repository)

    const result = await useCase.execute({ userId: 'user-1' })

    expect(result.projects).toHaveLength(0)
  })
})
