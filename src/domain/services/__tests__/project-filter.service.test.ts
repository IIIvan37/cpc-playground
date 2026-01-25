import { describe, expect, it } from 'vitest'
import type { Project } from '@/domain/entities/project.entity'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { createVisibility } from '@/domain/value-objects/visibility.vo'
import {
  filterProjects,
  type SearchableProject,
  sortProjects
} from '../project-filter.service'

describe('filterProjects', () => {
  const createMockProject = (overrides: Partial<Project> = {}): Project => ({
    id: '1',
    userId: 'user-1',
    authorUsername: 'testuser',
    name: createProjectName('Test Project'),
    description: 'A test description',
    thumbnailPath: null,
    visibility: createVisibility('public'),
    isLibrary: false,
    isSticky: false,
    files: [],
    tags: ['asm', 'demo'],
    dependencies: [],
    shares: [],
    userShares: [],
    createdAt: new Date(),
    updatedAt: new Date(),
    ...overrides
  })

  const createSearchableProject = (
    project: Project,
    authorName = 'testuser'
  ): SearchableProject => ({
    project,
    authorName
  })

  it('returns all projects when query is empty', () => {
    const projects = [
      createSearchableProject(createMockProject({ id: '1' })),
      createSearchableProject(createMockProject({ id: '2' }))
    ]

    const result = filterProjects(projects, { query: '' })

    expect(result).toHaveLength(2)
  })

  it('returns all projects when query is whitespace only', () => {
    const projects = [createSearchableProject(createMockProject())]

    const result = filterProjects(projects, { query: '   ' })

    expect(result).toHaveLength(1)
  })

  it('filters by project name', () => {
    const projects = [
      createSearchableProject(
        createMockProject({ id: '1', name: createProjectName('My Game') })
      ),
      createSearchableProject(
        createMockProject({ id: '2', name: createProjectName('Demo App') })
      )
    ]

    const result = filterProjects(projects, { query: 'game' })

    expect(result).toHaveLength(1)
    expect(result[0].project.id).toBe('1')
  })

  it('filters by author name', () => {
    const projects = [
      createSearchableProject(createMockProject({ id: '1' }), 'alice'),
      createSearchableProject(createMockProject({ id: '2' }), 'bob')
    ]

    const result = filterProjects(projects, { query: 'alice' })

    expect(result).toHaveLength(1)
    expect(result[0].authorName).toBe('alice')
  })

  it('filters by tags', () => {
    const projects = [
      createSearchableProject(
        createMockProject({ id: '1', tags: ['retro', 'cpc'] })
      ),
      createSearchableProject(
        createMockProject({ id: '2', tags: ['modern', 'web'] })
      )
    ]

    const result = filterProjects(projects, { query: 'retro' })

    expect(result).toHaveLength(1)
    expect(result[0].project.tags).toContain('retro')
  })

  it('filters by description', () => {
    const projects = [
      createSearchableProject(
        createMockProject({ id: '1', description: 'A scrolling demo' })
      ),
      createSearchableProject(
        createMockProject({ id: '2', description: 'A raster effect' })
      )
    ]

    const result = filterProjects(projects, { query: 'scrolling' })

    expect(result).toHaveLength(1)
    expect(result[0].project.description).toContain('scrolling')
  })

  it('is case insensitive', () => {
    const projects = [
      createSearchableProject(
        createMockProject({ name: createProjectName('MyProject') })
      )
    ]

    expect(filterProjects(projects, { query: 'myproject' })).toHaveLength(1)
    expect(filterProjects(projects, { query: 'MYPROJECT' })).toHaveLength(1)
    expect(filterProjects(projects, { query: 'MyProject' })).toHaveLength(1)
  })

  it('matches partial strings', () => {
    const projects = [
      createSearchableProject(
        createMockProject({ name: createProjectName('Awesome Demo') })
      )
    ]

    const result = filterProjects(projects, { query: 'esome' })

    expect(result).toHaveLength(1)
  })

  it('handles projects with null description', () => {
    const projects = [
      createSearchableProject(
        createMockProject({ id: '1', description: null })
      ),
      createSearchableProject(
        createMockProject({ id: '2', description: 'Has description' })
      )
    ]

    const result = filterProjects(projects, { query: 'description' })

    expect(result).toHaveLength(1)
    expect(result[0].project.id).toBe('2')
  })

  it('matches across multiple fields', () => {
    const project = createSearchableProject(
      createMockProject({
        name: createProjectName('CoolProject'),
        description: 'Amazing demo',
        tags: ['retro']
      }),
      'alice'
    )

    expect(filterProjects([project], { query: 'cool' })).toHaveLength(1)
    expect(filterProjects([project], { query: 'alice' })).toHaveLength(1)
    expect(filterProjects([project], { query: 'amazing' })).toHaveLength(1)
    expect(filterProjects([project], { query: 'retro' })).toHaveLength(1)
  })

  it('returns empty array when no matches', () => {
    const projects = [
      createSearchableProject(
        createMockProject({ name: createProjectName('Demo') })
      )
    ]

    const result = filterProjects(projects, { query: 'nonexistent' })

    expect(result).toHaveLength(0)
  })

  it('filters by librariesOnly when true', () => {
    const projects = [
      createSearchableProject(
        createMockProject({
          id: '1',
          name: createProjectName('My Library'),
          isLibrary: true
        })
      ),
      createSearchableProject(
        createMockProject({
          id: '2',
          name: createProjectName('My Project'),
          isLibrary: false
        })
      )
    ]

    const result = filterProjects(projects, { query: '', librariesOnly: true })

    expect(result).toHaveLength(1)
    expect(result[0].project.id).toBe('1')
  })

  it('combines librariesOnly filter with search query', () => {
    const projects = [
      createSearchableProject(
        createMockProject({
          id: '1',
          name: createProjectName('Utils Library'),
          isLibrary: true
        })
      ),
      createSearchableProject(
        createMockProject({
          id: '2',
          name: createProjectName('Utils App'),
          isLibrary: false
        })
      ),
      createSearchableProject(
        createMockProject({
          id: '3',
          name: createProjectName('Game Library'),
          isLibrary: true
        })
      )
    ]

    const result = filterProjects(projects, {
      query: 'utils',
      librariesOnly: true
    })

    expect(result).toHaveLength(1)
    expect(result[0].project.id).toBe('1')
  })
})

describe('sortProjects', () => {
  const createMockProject = (overrides: Partial<Project> = {}): Project => ({
    id: '1',
    userId: 'user-1',
    authorUsername: 'testuser',
    name: createProjectName('Test Project'),
    description: 'A test description',
    thumbnailPath: null,
    visibility: createVisibility('public'),
    isLibrary: false,
    isSticky: false,
    files: [],
    tags: [],
    dependencies: [],
    shares: [],
    userShares: [],
    createdAt: new Date(),
    updatedAt: new Date(),
    ...overrides
  })

  const createSearchableProject = (
    project: Project,
    authorName = 'testuser'
  ): SearchableProject => ({
    project,
    authorName
  })

  it('sorts sticky projects first', () => {
    const projects = [
      createSearchableProject(
        createMockProject({
          id: '1',
          isSticky: false,
          createdAt: new Date('2025-01-01')
        })
      ),
      createSearchableProject(
        createMockProject({
          id: '2',
          isSticky: true,
          createdAt: new Date('2024-01-01')
        })
      ),
      createSearchableProject(
        createMockProject({
          id: '3',
          isSticky: false,
          createdAt: new Date('2025-06-01')
        })
      )
    ]

    const result = sortProjects(projects)

    expect(result[0].project.id).toBe('2') // Sticky first
    expect(result[1].project.id).toBe('3') // Then newest
    expect(result[2].project.id).toBe('1') // Then older
  })

  it('sorts by creation date when no sticky projects', () => {
    const projects = [
      createSearchableProject(
        createMockProject({
          id: '1',
          createdAt: new Date('2025-01-01')
        })
      ),
      createSearchableProject(
        createMockProject({
          id: '2',
          createdAt: new Date('2025-06-01')
        })
      ),
      createSearchableProject(
        createMockProject({
          id: '3',
          createdAt: new Date('2024-01-01')
        })
      )
    ]

    const result = sortProjects(projects)

    expect(result[0].project.id).toBe('2') // Newest
    expect(result[1].project.id).toBe('1')
    expect(result[2].project.id).toBe('3') // Oldest
  })

  it('sorts multiple sticky projects by creation date', () => {
    const projects = [
      createSearchableProject(
        createMockProject({
          id: '1',
          isSticky: true,
          createdAt: new Date('2024-01-01')
        })
      ),
      createSearchableProject(
        createMockProject({
          id: '2',
          isSticky: true,
          createdAt: new Date('2025-01-01')
        })
      ),
      createSearchableProject(
        createMockProject({
          id: '3',
          isSticky: false,
          createdAt: new Date('2025-06-01')
        })
      )
    ]

    const result = sortProjects(projects)

    expect(result[0].project.id).toBe('2') // Sticky + newest
    expect(result[1].project.id).toBe('1') // Sticky + older
    expect(result[2].project.id).toBe('3') // Not sticky
  })

  it('does not mutate the original array', () => {
    const projects = [
      createSearchableProject(
        createMockProject({
          id: '1',
          createdAt: new Date('2025-01-01')
        })
      ),
      createSearchableProject(
        createMockProject({
          id: '2',
          createdAt: new Date('2024-01-01')
        })
      )
    ]

    const originalFirst = projects[0].project.id

    sortProjects(projects)

    expect(projects[0].project.id).toBe(originalFirst)
  })
})
