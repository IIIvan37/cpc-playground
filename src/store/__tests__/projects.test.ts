/**
 * Tests for projects store using Clean Architecture
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
  currentFileAtom,
  currentProjectAtom,
  currentProjectIdAtom,
  mainFileAtom,
  projectsAtom,
  setCurrentProjectAtom
} from '../projects'

describe('Projects Store', () => {
  let store: ReturnType<typeof createStore>

  beforeEach(() => {
    store = createStore()
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
  })
})
