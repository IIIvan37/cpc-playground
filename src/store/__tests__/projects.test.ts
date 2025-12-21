/**
 * Tests for projects store using Clean Architecture
 */

import { createStore } from 'jotai'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import { FILE_ERRORS, PROJECT_ERRORS } from '@/domain/errors/error-messages'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'

// Mock the container
vi.mock('@/infrastructure/container', () => ({
  container: {
    getProjects: { execute: vi.fn() },
    getProject: { execute: vi.fn() },
    getProjectWithDependencies: { execute: vi.fn() },
    createProject: { execute: vi.fn() },
    updateProject: { execute: vi.fn() },
    deleteProject: { execute: vi.fn() },
    createFile: { execute: vi.fn() },
    updateFile: { execute: vi.fn() },
    deleteFile: { execute: vi.fn() },
    addTag: { execute: vi.fn() },
    removeTag: { execute: vi.fn() },
    addDependency: { execute: vi.fn() },
    removeDependency: { execute: vi.fn() },
    addUserShare: { execute: vi.fn() },
    removeUserShare: { execute: vi.fn() }
  }
}))

import { container } from '@/infrastructure/container'
import {
  addDependencyToProjectAtom,
  addTagToProjectAtom,
  addUserShareToProjectAtom,
  createFileAtom,
  createProjectAtom,
  currentFileAtom,
  currentFileIdAtom,
  currentProjectAtom,
  currentProjectIdAtom,
  deleteFileAtom,
  deleteProjectAtom,
  dependencyFilesAtom,
  fetchDependencyFilesAtom,
  fetchProjectAtom,
  fetchProjectsAtom,
  fetchProjectWithDependenciesAtom,
  mainFileAtom,
  projectsAtom,
  removeDependencyFromProjectAtom,
  removeTagFromProjectAtom,
  removeUserShareFromProjectAtom,
  setCurrentFileAtom,
  setCurrentProjectAtom,
  setMainFileAtom,
  updateFileAtom,
  updateProjectAtom
} from '../projects'

const mockContainer = container as any

// Helper to create test projects
function createTestProject(
  overrides: Partial<{
    id: string
    userId: string
    name: string
    files: any[]
    tags: string[]
    dependencies: string[]
    isLibrary: boolean
    userShares: any[]
  }> = {}
) {
  const mainFile = createProjectFile({
    id: overrides.files?.[0]?.id || 'file-1',
    projectId: overrides.id || 'proj-1',
    name: createFileName(overrides.files?.[0]?.name || 'main.asm'),
    content: createFileContent(overrides.files?.[0]?.content || ''),
    isMain: overrides.files?.[0]?.isMain ?? true
  })

  return createProject({
    id: overrides.id || 'proj-1',
    userId: overrides.userId || 'user-1',
    name: createProjectName(overrides.name || 'Test Project'),
    visibility: Visibility.PRIVATE,
    files: overrides.files || [mainFile],
    tags: overrides.tags || [],
    dependencies: overrides.dependencies || [],
    isLibrary: overrides.isLibrary || false,
    userShares: overrides.userShares || []
  })
}

describe('Projects Store', () => {
  let store: ReturnType<typeof createStore>

  beforeEach(() => {
    store = createStore()
    vi.clearAllMocks()
  })

  describe('State atoms', () => {
    it('should have empty initial state', () => {
      expect(store.get(projectsAtom)).toEqual([])
      expect(store.get(currentProjectIdAtom)).toBeNull()
    })

    it('should update projects state', () => {
      const project = createProject({
        id: '1',
        userId: 'user-1',
        name: createProjectName('Test'),
        visibility: Visibility.PRIVATE
      })

      store.set(projectsAtom, [project])

      expect(store.get(projectsAtom)).toHaveLength(1)
      expect(store.get(projectsAtom)[0].name.value).toBe('Test')
    })
  })

  describe('Derived atoms', () => {
    it('should compute current project', () => {
      const project = createProject({
        id: '1',
        userId: 'user-1',
        name: createProjectName('Test'),
        visibility: Visibility.PRIVATE
      })

      store.set(projectsAtom, [project])
      store.set(currentProjectIdAtom, '1')

      const current = store.get(currentProjectAtom)
      expect(current).toBeDefined()
      expect(current?.id).toBe('1')
    })

    it('should return null when no current project', () => {
      const current = store.get(currentProjectAtom)
      expect(current).toBeNull()
    })

    it('should compute main file', () => {
      const file = createProjectFile({
        id: 'file-1',
        projectId: '1',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true
      })

      const project = createProject({
        id: '1',
        userId: 'user-1',
        name: createProjectName('Test'),
        visibility: Visibility.PRIVATE,
        files: [file]
      })

      store.set(projectsAtom, [project])
      store.set(currentProjectIdAtom, '1')

      const mainFile = store.get(mainFileAtom)
      expect(mainFile).toBeDefined()
      expect(mainFile?.isMain).toBe(true)
      expect(mainFile?.name.value).toBe('main.asm')
    })
  })

  describe('Actions', () => {
    it('should set current project and main file', () => {
      const mainFile = createProjectFile({
        id: 'file-1',
        projectId: '1',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true
      })

      const project = createProject({
        id: '1',
        userId: 'user-1',
        name: createProjectName('Test'),
        visibility: Visibility.PRIVATE,
        files: [mainFile]
      })

      store.set(projectsAtom, [project])
      store.set(setCurrentProjectAtom, '1')

      expect(store.get(currentProjectIdAtom)).toBe('1')
      expect(store.get(currentProjectAtom)?.id).toBe('1')
      // Should automatically set main file
      const currentFile = store.get(currentFileAtom)
      expect(currentFile?.id).toBe('file-1')
    })

    it('should clear current project', () => {
      store.set(currentProjectIdAtom, '1')
      store.set(setCurrentProjectAtom, null)

      expect(store.get(currentProjectIdAtom)).toBeNull()
    })

    it('should set current file', () => {
      store.set(setCurrentFileAtom, 'file-123')
      expect(store.get(currentFileIdAtom)).toBe('file-123')
    })

    it('should set current project without main file', () => {
      const file = createProjectFile({
        id: 'file-1',
        projectId: '1',
        name: createFileName('utils.asm'),
        content: createFileContent(''),
        isMain: false
      })

      const project = createProject({
        id: '1',
        userId: 'user-1',
        name: createProjectName('Test'),
        visibility: Visibility.PRIVATE,
        files: [file]
      })

      store.set(projectsAtom, [project])
      store.set(setCurrentProjectAtom, '1')

      expect(store.get(currentProjectIdAtom)).toBe('1')
      expect(store.get(currentFileIdAtom)).toBeNull()
    })
  })

  describe('fetchProjectsAtom', () => {
    it('should fetch and set projects', async () => {
      const project = createTestProject()
      mockContainer.getProjects.execute.mockResolvedValue({
        projects: [project]
      })

      await store.set(fetchProjectsAtom, 'user-1')

      expect(store.get(projectsAtom)).toHaveLength(1)
      expect(mockContainer.getProjects.execute).toHaveBeenCalledWith({
        userId: 'user-1'
      })
    })

    it('should throw and log error on failure', async () => {
      const error = new Error('Network error')
      mockContainer.getProjects.execute.mockRejectedValue(error)
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})

      await expect(store.set(fetchProjectsAtom, 'user-1')).rejects.toThrow(
        'Network error'
      )
      expect(consoleSpy).toHaveBeenCalledWith(
        'Failed to fetch projects:',
        error
      )

      consoleSpy.mockRestore()
    })
  })

  describe('fetchProjectAtom', () => {
    it('should fetch and add project to list', async () => {
      const project = createTestProject({ id: 'new-proj' })
      mockContainer.getProject.execute.mockResolvedValue({ project })

      const result = await store.set(fetchProjectAtom, {
        projectId: 'new-proj',
        userId: 'user-1'
      })

      expect(result).toEqual(project)
      expect(store.get(projectsAtom)).toHaveLength(1)
    })

    it('should update existing project in list', async () => {
      const existingProject = createTestProject({
        id: 'proj-1',
        name: 'Old Name'
      })
      store.set(projectsAtom, [existingProject])

      const updatedProject = createTestProject({
        id: 'proj-1',
        name: 'New Name'
      })
      mockContainer.getProject.execute.mockResolvedValue({
        project: updatedProject
      })

      await store.set(fetchProjectAtom, {
        projectId: 'proj-1',
        userId: 'user-1'
      })

      const projects = store.get(projectsAtom)
      expect(projects).toHaveLength(1)
      expect(projects[0].name.value).toBe('New Name')
    })

    it('should throw error when project not found', async () => {
      mockContainer.getProject.execute.mockResolvedValue({ project: null })
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})

      await expect(
        store.set(fetchProjectAtom, { projectId: 'invalid', userId: 'user-1' })
      ).rejects.toThrow(PROJECT_ERRORS.NOT_FOUND('invalid'))

      consoleSpy.mockRestore()
    })
  })

  describe('fetchProjectWithDependenciesAtom', () => {
    it('should fetch and return dependency files', async () => {
      const files = [
        { id: 'f1', name: 'lib.asm', content: '', projectId: 'dep-1' }
      ]
      mockContainer.getProjectWithDependencies.execute.mockResolvedValue({
        files
      })

      const result = await store.set(fetchProjectWithDependenciesAtom, {
        projectId: 'proj-1',
        userId: 'user-1'
      })

      expect(result).toEqual(files)
    })

    it('should throw error on failure', async () => {
      const error = new Error('Failed to load')
      mockContainer.getProjectWithDependencies.execute.mockRejectedValue(error)
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})

      await expect(
        store.set(fetchProjectWithDependenciesAtom, {
          projectId: 'proj-1',
          userId: 'user-1'
        })
      ).rejects.toThrow('Failed to load')

      consoleSpy.mockRestore()
    })
  })

  describe('createProjectAtom', () => {
    it('should create project and set as current', async () => {
      const mainFile = createProjectFile({
        id: 'file-1',
        projectId: 'new-proj',
        name: createFileName('main.asm'),
        content: createFileContent(''),
        isMain: true
      })
      const project = createProject({
        id: 'new-proj',
        userId: 'user-1',
        name: createProjectName('New Project'),
        visibility: Visibility.PRIVATE,
        files: [mainFile]
      })
      mockContainer.createProject.execute.mockResolvedValue({ project })

      const result = await store.set(createProjectAtom, {
        userId: 'user-1',
        name: 'New Project'
      })

      expect(result).toEqual(project)
      expect(store.get(projectsAtom)).toHaveLength(1)
      expect(store.get(currentProjectIdAtom)).toBe('new-proj')
      expect(store.get(currentFileIdAtom)).toBe('file-1')
    })

    it('should create project without main file', async () => {
      const project = createProject({
        id: 'new-proj',
        userId: 'user-1',
        name: createProjectName('New Project'),
        visibility: Visibility.PRIVATE,
        files: []
      })
      mockContainer.createProject.execute.mockResolvedValue({ project })

      await store.set(createProjectAtom, {
        userId: 'user-1',
        name: 'New Project'
      })

      expect(store.get(currentFileIdAtom)).toBeNull()
    })

    it('should throw error on failure', async () => {
      const error = new Error('Create failed')
      mockContainer.createProject.execute.mockRejectedValue(error)
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})

      await expect(
        store.set(createProjectAtom, { userId: 'user-1', name: 'Test' })
      ).rejects.toThrow('Create failed')

      consoleSpy.mockRestore()
    })
  })

  describe('updateProjectAtom', () => {
    it('should update project in list', async () => {
      const project = createTestProject({ id: 'proj-1', name: 'Old' })
      store.set(projectsAtom, [project])

      const updatedProject = createTestProject({
        id: 'proj-1',
        name: 'Updated'
      })
      mockContainer.updateProject.execute.mockResolvedValue({
        project: updatedProject
      })

      const result = await store.set(updateProjectAtom, {
        projectId: 'proj-1',
        userId: 'user-1',
        name: 'Updated'
      })

      expect(result.name.value).toBe('Updated')
      expect(store.get(projectsAtom)[0].name.value).toBe('Updated')
    })

    it('should throw error on failure', async () => {
      const error = new Error('Update failed')
      mockContainer.updateProject.execute.mockRejectedValue(error)
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})

      await expect(
        store.set(updateProjectAtom, {
          projectId: 'p1',
          userId: 'u1',
          name: 'X'
        })
      ).rejects.toThrow('Update failed')

      consoleSpy.mockRestore()
    })
  })

  describe('deleteProjectAtom', () => {
    it('should remove project from list', async () => {
      const project = createTestProject({ id: 'proj-1' })
      store.set(projectsAtom, [project])
      mockContainer.deleteProject.execute.mockResolvedValue({})

      await store.set(deleteProjectAtom, {
        projectId: 'proj-1',
        userId: 'user-1'
      })

      expect(store.get(projectsAtom)).toHaveLength(0)
    })

    it('should clear current project if deleted', async () => {
      const project = createTestProject({ id: 'proj-1' })
      store.set(projectsAtom, [project])
      store.set(currentProjectIdAtom, 'proj-1')
      store.set(currentFileIdAtom, 'file-1')
      mockContainer.deleteProject.execute.mockResolvedValue({})

      await store.set(deleteProjectAtom, {
        projectId: 'proj-1',
        userId: 'user-1'
      })

      expect(store.get(currentProjectIdAtom)).toBeNull()
      expect(store.get(currentFileIdAtom)).toBeNull()
    })

    it('should not clear current project if different project deleted', async () => {
      const project1 = createTestProject({ id: 'proj-1' })
      const project2 = createTestProject({ id: 'proj-2' })
      store.set(projectsAtom, [project1, project2])
      store.set(currentProjectIdAtom, 'proj-2')
      mockContainer.deleteProject.execute.mockResolvedValue({})

      await store.set(deleteProjectAtom, {
        projectId: 'proj-1',
        userId: 'user-1'
      })

      expect(store.get(currentProjectIdAtom)).toBe('proj-2')
    })

    it('should throw error on failure', async () => {
      const error = new Error('Delete failed')
      mockContainer.deleteProject.execute.mockRejectedValue(error)
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})

      await expect(
        store.set(deleteProjectAtom, { projectId: 'p1', userId: 'u1' })
      ).rejects.toThrow('Delete failed')

      consoleSpy.mockRestore()
    })
  })

  describe('File operations', () => {
    describe('createFileAtom', () => {
      it('should create file and add to project', async () => {
        const project = createTestProject({ id: 'proj-1' })
        store.set(projectsAtom, [project])
        store.set(currentFileIdAtom, 'existing-file')

        const newFile = createProjectFile({
          id: 'new-file',
          projectId: 'proj-1',
          name: createFileName('utils.asm'),
          content: createFileContent(''),
          isMain: false
        })
        mockContainer.createFile.execute.mockResolvedValue({ file: newFile })

        const result = await store.set(createFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          name: 'utils.asm'
        })

        expect(result.id).toBe('new-file')
        const updatedProject = store.get(projectsAtom)[0]
        expect(updatedProject.files).toHaveLength(2)
      })

      it('should set new file as current if main', async () => {
        const project = createTestProject({ id: 'proj-1' })
        store.set(projectsAtom, [project])

        const newFile = createProjectFile({
          id: 'new-main',
          projectId: 'proj-1',
          name: createFileName('new-main.asm'),
          content: createFileContent(''),
          isMain: true
        })
        mockContainer.createFile.execute.mockResolvedValue({ file: newFile })

        await store.set(createFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          name: 'new-main.asm',
          isMain: true
        })

        expect(store.get(currentFileIdAtom)).toBe('new-main')
      })

      it('should set new file as current if no current file', async () => {
        const project = createTestProject({ id: 'proj-1' })
        store.set(projectsAtom, [project])
        store.set(currentFileIdAtom, null)

        const newFile = createProjectFile({
          id: 'new-file',
          projectId: 'proj-1',
          name: createFileName('utils.asm'),
          content: createFileContent(''),
          isMain: false
        })
        mockContainer.createFile.execute.mockResolvedValue({ file: newFile })

        await store.set(createFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          name: 'utils.asm'
        })

        expect(store.get(currentFileIdAtom)).toBe('new-file')
      })

      it('should throw error on failure', async () => {
        const error = new Error('Create file failed')
        mockContainer.createFile.execute.mockRejectedValue(error)
        const consoleSpy = vi
          .spyOn(console, 'error')
          .mockImplementation(() => {})

        await expect(
          store.set(createFileAtom, {
            projectId: 'p1',
            userId: 'u1',
            name: 'f.asm'
          })
        ).rejects.toThrow('Create file failed')

        consoleSpy.mockRestore()
      })

      it('should not modify other projects when creating file', async () => {
        const project1 = createTestProject({ id: 'proj-1' })
        const project2 = createTestProject({ id: 'proj-2', name: 'Other' })
        store.set(projectsAtom, [project1, project2])

        const newFile = createProjectFile({
          id: 'new-file',
          projectId: 'proj-1',
          name: createFileName('utils.asm'),
          content: createFileContent(''),
          isMain: false
        })
        mockContainer.createFile.execute.mockResolvedValue({ file: newFile })

        await store.set(createFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          name: 'utils.asm'
        })

        // proj-2 should be unchanged
        const projects = store.get(projectsAtom)
        expect(projects[1].files).toHaveLength(1)
      })
    })

    describe('updateFileAtom', () => {
      it('should update file in project', async () => {
        const project = createTestProject({ id: 'proj-1' })
        store.set(projectsAtom, [project])

        const updatedFile = createProjectFile({
          id: 'file-1',
          projectId: 'proj-1',
          name: createFileName('renamed.asm'),
          content: createFileContent('new content'),
          isMain: true
        })
        mockContainer.updateFile.execute.mockResolvedValue({
          file: updatedFile
        })

        const result = await store.set(updateFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'file-1',
          name: 'renamed.asm'
        })

        expect(result.name.value).toBe('renamed.asm')
        expect(store.get(projectsAtom)[0].files[0].name.value).toBe(
          'renamed.asm'
        )
      })

      it('should throw error on failure', async () => {
        const error = new Error('Update file failed')
        mockContainer.updateFile.execute.mockRejectedValue(error)
        const consoleSpy = vi
          .spyOn(console, 'error')
          .mockImplementation(() => {})

        await expect(
          store.set(updateFileAtom, {
            projectId: 'p1',
            userId: 'u1',
            fileId: 'f1'
          })
        ).rejects.toThrow('Update file failed')

        consoleSpy.mockRestore()
      })

      it('should not modify other projects when updating file', async () => {
        const project1 = createTestProject({ id: 'proj-1' })
        const project2 = createTestProject({ id: 'proj-2', name: 'Other' })
        store.set(projectsAtom, [project1, project2])

        const updatedFile = createProjectFile({
          id: 'file-1',
          projectId: 'proj-1',
          name: createFileName('renamed.asm'),
          content: createFileContent('updated'),
          isMain: true
        })
        mockContainer.updateFile.execute.mockResolvedValue({
          file: updatedFile
        })

        await store.set(updateFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'file-1',
          content: 'updated'
        })

        // proj-2 should be unchanged
        const projects = store.get(projectsAtom)
        expect(projects[1].name.value).toBe('Other')
      })
    })

    describe('deleteFileAtom', () => {
      it('should remove file from project', async () => {
        const file1 = createProjectFile({
          id: 'file-1',
          projectId: 'proj-1',
          name: createFileName('main.asm'),
          content: createFileContent(''),
          isMain: true
        })
        const file2 = createProjectFile({
          id: 'file-2',
          projectId: 'proj-1',
          name: createFileName('utils.asm'),
          content: createFileContent(''),
          isMain: false
        })
        const project = createProject({
          id: 'proj-1',
          userId: 'user-1',
          name: createProjectName('Test'),
          visibility: Visibility.PRIVATE,
          files: [file1, file2]
        })
        store.set(projectsAtom, [project])
        store.set(currentFileIdAtom, 'other-file')
        mockContainer.deleteFile.execute.mockResolvedValue({})

        await store.set(deleteFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'file-2'
        })

        expect(store.get(projectsAtom)[0].files).toHaveLength(1)
        expect(store.get(projectsAtom)[0].files[0].id).toBe('file-1')
      })

      it('should set main file as current when deleted file was current', async () => {
        const file1 = createProjectFile({
          id: 'file-1',
          projectId: 'proj-1',
          name: createFileName('main.asm'),
          content: createFileContent(''),
          isMain: true
        })
        const file2 = createProjectFile({
          id: 'file-2',
          projectId: 'proj-1',
          name: createFileName('utils.asm'),
          content: createFileContent(''),
          isMain: false
        })
        const project = createProject({
          id: 'proj-1',
          userId: 'user-1',
          name: createProjectName('Test'),
          visibility: Visibility.PRIVATE,
          files: [file1, file2]
        })
        store.set(projectsAtom, [project])
        store.set(currentFileIdAtom, 'file-2')
        mockContainer.deleteFile.execute.mockResolvedValue({})

        await store.set(deleteFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'file-2'
        })

        expect(store.get(currentFileIdAtom)).toBe('file-1')
      })

      it('should throw error on failure', async () => {
        const error = new Error('Delete file failed')
        mockContainer.deleteFile.execute.mockRejectedValue(error)
        const consoleSpy = vi
          .spyOn(console, 'error')
          .mockImplementation(() => {})

        await expect(
          store.set(deleteFileAtom, {
            projectId: 'p1',
            userId: 'u1',
            fileId: 'f1'
          })
        ).rejects.toThrow('Delete file failed')

        consoleSpy.mockRestore()
      })

      it('should not modify other projects when deleting file', async () => {
        const file1 = createProjectFile({
          id: 'file-1',
          projectId: 'proj-1',
          name: createFileName('main.asm'),
          content: createFileContent(''),
          isMain: true
        })
        const file2 = createProjectFile({
          id: 'file-2',
          projectId: 'proj-1',
          name: createFileName('utils.asm'),
          content: createFileContent(''),
          isMain: false
        })
        const project1 = createProject({
          id: 'proj-1',
          userId: 'user-1',
          name: createProjectName('Project 1'),
          visibility: Visibility.PRIVATE,
          files: [file1, file2]
        })
        const project2 = createTestProject({ id: 'proj-2', name: 'Other' })
        store.set(projectsAtom, [project1, project2])
        store.set(currentFileIdAtom, 'other-file')
        mockContainer.deleteFile.execute.mockResolvedValue({})

        await store.set(deleteFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'file-2'
        })

        // proj-2 should be unchanged
        const projects = store.get(projectsAtom)
        expect(projects[1].files).toHaveLength(1)
      })
    })

    describe('setMainFileAtom', () => {
      it('should set file as main', async () => {
        const file1 = createProjectFile({
          id: 'file-1',
          projectId: 'proj-1',
          name: createFileName('main.asm'),
          content: createFileContent(''),
          isMain: true
        })
        const file2 = createProjectFile({
          id: 'file-2',
          projectId: 'proj-1',
          name: createFileName('utils.asm'),
          content: createFileContent(''),
          isMain: false
        })
        const project = createProject({
          id: 'proj-1',
          userId: 'user-1',
          name: createProjectName('Test'),
          visibility: Visibility.PRIVATE,
          files: [file1, file2]
        })
        store.set(projectsAtom, [project])
        mockContainer.updateFile.execute.mockResolvedValue({})

        await store.set(setMainFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'file-2'
        })

        const files = store.get(projectsAtom)[0].files
        expect(files.find((f) => f.id === 'file-1')?.isMain).toBe(false)
        expect(files.find((f) => f.id === 'file-2')?.isMain).toBe(true)
      })

      it('should throw error for library project', async () => {
        const project = createProject({
          id: 'proj-1',
          userId: 'user-1',
          name: createProjectName('Library'),
          visibility: Visibility.PRIVATE,
          isLibrary: true,
          files: []
        })
        store.set(projectsAtom, [project])

        await expect(
          store.set(setMainFileAtom, {
            projectId: 'proj-1',
            userId: 'user-1',
            fileId: 'file-1'
          })
        ).rejects.toThrow(FILE_ERRORS.LIBRARY_NO_MAIN)
      })

      it('should throw error on failure', async () => {
        const project = createTestProject({ id: 'proj-1' })
        store.set(projectsAtom, [project])
        const error = new Error('Set main failed')
        mockContainer.updateFile.execute.mockRejectedValue(error)
        const consoleSpy = vi
          .spyOn(console, 'error')
          .mockImplementation(() => {})

        await expect(
          store.set(setMainFileAtom, {
            projectId: 'proj-1',
            userId: 'u1',
            fileId: 'f1'
          })
        ).rejects.toThrow('Set main failed')

        consoleSpy.mockRestore()
      })

      it('should not modify other projects when setting main file', async () => {
        const file1 = createProjectFile({
          id: 'file-1',
          projectId: 'proj-1',
          name: createFileName('main.asm'),
          content: createFileContent(''),
          isMain: true
        })
        const file2 = createProjectFile({
          id: 'file-2',
          projectId: 'proj-1',
          name: createFileName('utils.asm'),
          content: createFileContent(''),
          isMain: false
        })
        const project1 = createProject({
          id: 'proj-1',
          userId: 'user-1',
          name: createProjectName('Project 1'),
          visibility: Visibility.PRIVATE,
          files: [file1, file2]
        })
        const project2 = createTestProject({ id: 'proj-2', name: 'Other' })
        store.set(projectsAtom, [project1, project2])
        mockContainer.updateFile.execute.mockResolvedValue({})

        await store.set(setMainFileAtom, {
          projectId: 'proj-1',
          userId: 'user-1',
          fileId: 'file-2'
        })

        // proj-2 should be unchanged
        const projects = store.get(projectsAtom)
        expect(projects[1].name.value).toBe('Other')
      })
    })
  })

  describe('Tags operations', () => {
    describe('addTagToProjectAtom', () => {
      it('should add tag to project', async () => {
        const project = createTestProject({ id: 'proj-1', tags: [] })
        store.set(projectsAtom, [project])
        mockContainer.addTag.execute.mockResolvedValue({
          tag: { name: 'new-tag' }
        })

        const result = await store.set(addTagToProjectAtom, {
          projectId: 'proj-1',
          tagName: 'new-tag'
        })

        expect(result.name).toBe('new-tag')
        expect(store.get(projectsAtom)[0].tags).toContain('new-tag')
      })

      it('should throw error when project not found', async () => {
        store.set(projectsAtom, [])

        await expect(
          store.set(addTagToProjectAtom, {
            projectId: 'invalid',
            tagName: 'tag'
          })
        ).rejects.toThrow(PROJECT_ERRORS.NOT_FOUND('invalid'))
      })
    })

    describe('removeTagFromProjectAtom', () => {
      it('should remove tag from project', async () => {
        const project = createTestProject({
          id: 'proj-1',
          tags: ['tag1', 'tag2']
        })
        store.set(projectsAtom, [project])
        mockContainer.removeTag.execute.mockResolvedValue({})

        await store.set(removeTagFromProjectAtom, {
          projectId: 'proj-1',
          tagName: 'tag1'
        })

        expect(store.get(projectsAtom)[0].tags).toEqual(['tag2'])
      })

      it('should throw error when project not found', async () => {
        store.set(projectsAtom, [])

        await expect(
          store.set(removeTagFromProjectAtom, {
            projectId: 'invalid',
            tagName: 'tag'
          })
        ).rejects.toThrow(PROJECT_ERRORS.NOT_FOUND('invalid'))
      })
    })
  })

  describe('Dependencies operations', () => {
    describe('fetchDependencyFilesAtom', () => {
      it('should return empty when no current project', async () => {
        store.set(currentProjectIdAtom, null)

        const result = await store.set(fetchDependencyFilesAtom)

        expect(result).toEqual([])
        expect(store.get(dependencyFilesAtom)).toEqual([])
      })

      it('should return empty when project has no dependencies', async () => {
        const project = createTestProject({ id: 'proj-1', dependencies: [] })
        store.set(projectsAtom, [project])
        store.set(currentProjectIdAtom, 'proj-1')

        const result = await store.set(fetchDependencyFilesAtom)

        expect(result).toEqual([])
      })

      it('should fetch and group dependency files by project', async () => {
        const project = createTestProject({
          id: 'proj-1',
          dependencies: ['dep-1']
        })
        store.set(projectsAtom, [project])
        store.set(currentProjectIdAtom, 'proj-1')

        mockContainer.getProjectWithDependencies.execute.mockResolvedValue({
          files: [
            {
              id: 'f1',
              name: 'lib.asm',
              content: 'code',
              projectId: 'dep-1',
              projectName: 'Dep Project'
            },
            {
              id: 'f2',
              name: 'lib2.asm',
              content: 'code2',
              projectId: 'dep-1',
              projectName: 'Dep Project'
            },
            {
              id: 'f3',
              name: 'main.asm',
              content: '',
              projectId: 'proj-1',
              projectName: 'Current'
            }
          ]
        })

        const result = await store.set(fetchDependencyFilesAtom)

        expect(result).toHaveLength(1)
        expect(result[0].id).toBe('dep-1')
        expect(result[0].name).toBe('Dep Project')
        expect(result[0].files).toHaveLength(2)
      })

      it('should handle error and return empty', async () => {
        const project = createTestProject({
          id: 'proj-1',
          dependencies: ['dep-1']
        })
        store.set(projectsAtom, [project])
        store.set(currentProjectIdAtom, 'proj-1')
        mockContainer.getProjectWithDependencies.execute.mockRejectedValue(
          new Error('Failed')
        )
        const consoleSpy = vi
          .spyOn(console, 'error')
          .mockImplementation(() => {})

        const result = await store.set(fetchDependencyFilesAtom)

        expect(result).toEqual([])
        expect(store.get(dependencyFilesAtom)).toEqual([])
        consoleSpy.mockRestore()
      })
    })

    describe('addDependencyToProjectAtom', () => {
      it('should add dependency to project', async () => {
        const project = createTestProject({ id: 'proj-1', dependencies: [] })
        store.set(projectsAtom, [project])
        mockContainer.addDependency.execute.mockResolvedValue({})

        await store.set(addDependencyToProjectAtom, {
          projectId: 'proj-1',
          dependencyId: 'dep-1'
        })

        expect(store.get(projectsAtom)[0].dependencies).toContain('dep-1')
      })

      it('should throw error when project not found', async () => {
        store.set(projectsAtom, [])

        await expect(
          store.set(addDependencyToProjectAtom, {
            projectId: 'invalid',
            dependencyId: 'dep-1'
          })
        ).rejects.toThrow(PROJECT_ERRORS.NOT_FOUND('invalid'))
      })
    })

    describe('removeDependencyFromProjectAtom', () => {
      it('should remove dependency from project', async () => {
        const project = createTestProject({
          id: 'proj-1',
          dependencies: ['dep-1', 'dep-2']
        })
        store.set(projectsAtom, [project])
        mockContainer.removeDependency.execute.mockResolvedValue({})

        await store.set(removeDependencyFromProjectAtom, {
          projectId: 'proj-1',
          dependencyId: 'dep-1'
        })

        expect(store.get(projectsAtom)[0].dependencies).toEqual(['dep-2'])
      })

      it('should throw error when project not found', async () => {
        store.set(projectsAtom, [])

        await expect(
          store.set(removeDependencyFromProjectAtom, {
            projectId: 'invalid',
            dependencyId: 'dep-1'
          })
        ).rejects.toThrow(PROJECT_ERRORS.NOT_FOUND('invalid'))
      })
    })
  })

  describe('Shares operations', () => {
    describe('addUserShareToProjectAtom', () => {
      it('should add user share to project', async () => {
        const project = createTestProject({ id: 'proj-1', userShares: [] })
        store.set(projectsAtom, [project])
        const share = { userId: 'shared-user', username: 'john' }
        mockContainer.addUserShare.execute.mockResolvedValue({ share })

        const result = await store.set(addUserShareToProjectAtom, {
          projectId: 'proj-1',
          username: 'john'
        })

        expect(result).toEqual(share)
        expect(store.get(projectsAtom)[0].userShares).toContainEqual(share)
      })

      it('should throw error when project not found', async () => {
        store.set(projectsAtom, [])

        await expect(
          store.set(addUserShareToProjectAtom, {
            projectId: 'invalid',
            username: 'john'
          })
        ).rejects.toThrow(PROJECT_ERRORS.NOT_FOUND('invalid'))
      })
    })

    describe('removeUserShareFromProjectAtom', () => {
      it('should remove user share from project', async () => {
        const shares = [
          { userId: 'user-a', username: 'a' },
          { userId: 'user-b', username: 'b' }
        ]
        const project = createTestProject({ id: 'proj-1', userShares: shares })
        store.set(projectsAtom, [project])
        mockContainer.removeUserShare.execute.mockResolvedValue({})

        await store.set(removeUserShareFromProjectAtom, {
          projectId: 'proj-1',
          targetUserId: 'user-a'
        })

        const remainingShares = store.get(projectsAtom)[0].userShares
        expect(remainingShares).toHaveLength(1)
        expect(remainingShares[0].userId).toBe('user-b')
      })

      it('should throw error when project not found', async () => {
        store.set(projectsAtom, [])

        await expect(
          store.set(removeUserShareFromProjectAtom, {
            projectId: 'invalid',
            targetUserId: 'user-1'
          })
        ).rejects.toThrow(PROJECT_ERRORS.NOT_FOUND('invalid'))
      })
    })
  })
})
