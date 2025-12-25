/**
 * Tests for projects store (state and derived atoms only)
 * Action logic has been moved to hooks - see src/hooks/__tests__/
 */

import { createStore } from 'jotai'
import { beforeEach, describe, expect, it } from 'vitest'
import { createProject } from '@/domain/entities/project.entity'
import { createProjectFile } from '@/domain/entities/project-file.entity'
import { createFileContent } from '@/domain/value-objects/file-content.vo'
import { createFileName } from '@/domain/value-objects/file-name.vo'
import { createProjectName } from '@/domain/value-objects/project-name.vo'
import { Visibility } from '@/domain/value-objects/visibility.vo'
import {
  activeProjectAtom,
  currentFileAtom,
  currentFileIdAtom,
  currentProjectAtom,
  currentProjectIdAtom,
  dependencyFilesAtom,
  isDependencyFileAtom,
  isReadOnlyModeAtom,
  mainFileAtom,
  projectsAtom,
  viewOnlyProjectAtom
} from '../projects'

describe('Projects Store', () => {
  let store: ReturnType<typeof createStore>

  beforeEach(() => {
    store = createStore()
  })

  describe('State atoms', () => {
    it('should have empty initial state for projectsAtom', () => {
      expect(store.get(projectsAtom)).toEqual([])
    })

    it('should have null initial state for currentProjectIdAtom', () => {
      expect(store.get(currentProjectIdAtom)).toBeNull()
    })

    it('should have null initial state for currentFileIdAtom', () => {
      expect(store.get(currentFileIdAtom)).toBeNull()
    })

    it('should have null initial state for viewOnlyProjectAtom', () => {
      expect(store.get(viewOnlyProjectAtom)).toBeNull()
    })

    it('should have false initial state for isReadOnlyModeAtom', () => {
      expect(store.get(isReadOnlyModeAtom)).toBe(false)
    })

    it('should have empty initial state for dependencyFilesAtom', () => {
      expect(store.get(dependencyFilesAtom)).toEqual([])
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
    describe('currentProjectAtom', () => {
      it('should compute current project from projects list', () => {
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

      it('should return null when no current project id', () => {
        const project = createProject({
          id: '1',
          userId: 'user-1',
          name: createProjectName('Test'),
          visibility: Visibility.PRIVATE
        })

        store.set(projectsAtom, [project])

        const current = store.get(currentProjectAtom)
        expect(current).toBeNull()
      })

      it('should return null when project not found', () => {
        store.set(currentProjectIdAtom, 'non-existent')

        const current = store.get(currentProjectAtom)
        expect(current).toBeNull()
      })
    })

    describe('activeProjectAtom', () => {
      it('should return current project in normal mode', () => {
        const project = createProject({
          id: '1',
          userId: 'user-1',
          name: createProjectName('Test'),
          visibility: Visibility.PRIVATE
        })

        store.set(projectsAtom, [project])
        store.set(currentProjectIdAtom, '1')
        store.set(isReadOnlyModeAtom, false)

        const active = store.get(activeProjectAtom)
        expect(active?.id).toBe('1')
      })

      it('should return viewOnly project in read-only mode', () => {
        const ownedProject = createProject({
          id: '1',
          userId: 'user-1',
          name: createProjectName('Owned'),
          visibility: Visibility.PRIVATE
        })

        const viewOnlyProject = createProject({
          id: '2',
          userId: 'user-2',
          name: createProjectName('ViewOnly'),
          visibility: Visibility.PUBLIC
        })

        store.set(projectsAtom, [ownedProject])
        store.set(currentProjectIdAtom, '1')
        store.set(viewOnlyProjectAtom, viewOnlyProject)
        store.set(isReadOnlyModeAtom, true)

        const active = store.get(activeProjectAtom)
        expect(active?.id).toBe('2')
        expect(active?.name.value).toBe('ViewOnly')
      })
    })

    describe('currentFileAtom', () => {
      it('should compute current file from active project', () => {
        const file = createProjectFile({
          id: 'file-1',
          projectId: '1',
          name: createFileName('main.asm'),
          content: createFileContent('ORG &8000'),
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
        store.set(currentFileIdAtom, 'file-1')

        const currentFile = store.get(currentFileAtom)
        expect(currentFile).toBeDefined()
        expect(currentFile?.id).toBe('file-1')
        expect(currentFile?.name.value).toBe('main.asm')
      })

      it('should return null when no current file id', () => {
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

        const currentFile = store.get(currentFileAtom)
        expect(currentFile).toBeNull()
      })
    })

    describe('mainFileAtom', () => {
      it('should compute main file from active project', () => {
        const mainFile = createProjectFile({
          id: 'file-1',
          projectId: '1',
          name: createFileName('main.asm'),
          content: createFileContent(''),
          isMain: true
        })

        const otherFile = createProjectFile({
          id: 'file-2',
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
          files: [mainFile, otherFile]
        })

        store.set(projectsAtom, [project])
        store.set(currentProjectIdAtom, '1')

        const main = store.get(mainFileAtom)
        expect(main).toBeDefined()
        expect(main?.isMain).toBe(true)
        expect(main?.name.value).toBe('main.asm')
      })

      it('should return null when no main file', () => {
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
        store.set(currentProjectIdAtom, '1')

        const main = store.get(mainFileAtom)
        expect(main).toBeNull()
      })
    })

    describe('isDependencyFileAtom', () => {
      it('should return false when no current file id', () => {
        expect(store.get(isDependencyFileAtom)).toBe(false)
      })

      it('should return false when current file is not a dependency file', () => {
        store.set(currentFileIdAtom, 'file-1')
        store.set(dependencyFilesAtom, [
          {
            id: 'dep-project-1',
            name: 'Dependency Project',
            files: [
              {
                id: 'dep-file-1',
                name: 'dep.asm',
                content: 'ORG &8000',
                projectId: 'dep-project-1'
              }
            ]
          }
        ])

        expect(store.get(isDependencyFileAtom)).toBe(false)
      })

      it('should return true when current file is a dependency file', () => {
        store.set(currentFileIdAtom, 'dep-file-1')
        store.set(dependencyFilesAtom, [
          {
            id: 'dep-project-1',
            name: 'Dependency Project',
            files: [
              {
                id: 'dep-file-1',
                name: 'dep.asm',
                content: 'ORG &8000',
                projectId: 'dep-project-1'
              }
            ]
          }
        ])

        expect(store.get(isDependencyFileAtom)).toBe(true)
      })

      it('should return true when current file is in nested dependency project', () => {
        store.set(currentFileIdAtom, 'dep-file-2')
        store.set(dependencyFilesAtom, [
          {
            id: 'dep-project-1',
            name: 'First Dependency',
            files: [
              {
                id: 'dep-file-1',
                name: 'dep1.asm',
                content: 'ORG &8000',
                projectId: 'dep-project-1'
              }
            ]
          },
          {
            id: 'dep-project-2',
            name: 'Second Dependency',
            files: [
              {
                id: 'dep-file-2',
                name: 'dep2.asm',
                content: 'ORG &9000',
                projectId: 'dep-project-2'
              }
            ]
          }
        ])

        expect(store.get(isDependencyFileAtom)).toBe(true)
      })
    })
  })
})
