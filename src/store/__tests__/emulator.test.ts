import { createStore } from 'jotai'
import { beforeEach, describe, expect, it } from 'vitest'
import {
  emulatorInstanceAtom,
  emulatorReadyAtom,
  emulatorResetTriggerAtom,
  emulatorRunningAtom,
  setEmulatorReadyAtom,
  setEmulatorRunningAtom,
  triggerEmulatorResetAtom,
  viewModeAtom
} from '../emulator'

describe('Emulator Store', () => {
  let store: ReturnType<typeof createStore>

  beforeEach(() => {
    store = createStore()
  })

  describe('emulatorReadyAtom', () => {
    it('should default to false', () => {
      expect(store.get(emulatorReadyAtom)).toBe(false)
    })

    it('should allow direct setting to true', () => {
      store.set(emulatorReadyAtom, true)
      expect(store.get(emulatorReadyAtom)).toBe(true)
    })

    it('should allow setting back to false', () => {
      store.set(emulatorReadyAtom, true)
      store.set(emulatorReadyAtom, false)
      expect(store.get(emulatorReadyAtom)).toBe(false)
    })
  })

  describe('emulatorRunningAtom', () => {
    it('should default to false', () => {
      expect(store.get(emulatorRunningAtom)).toBe(false)
    })

    it('should allow direct setting to true', () => {
      store.set(emulatorRunningAtom, true)
      expect(store.get(emulatorRunningAtom)).toBe(true)
    })

    it('should allow toggling state', () => {
      store.set(emulatorRunningAtom, true)
      store.set(emulatorRunningAtom, false)
      store.set(emulatorRunningAtom, true)
      expect(store.get(emulatorRunningAtom)).toBe(true)
    })
  })

  describe('emulatorInstanceAtom', () => {
    it('should default to null', () => {
      expect(store.get(emulatorInstanceAtom)).toBeNull()
    })

    it('should allow setting emulator instance', () => {
      const mockInstance = {
        name: 'cpcec'
      } as unknown as typeof globalThis.cpcec
      store.set(emulatorInstanceAtom, mockInstance)
      expect(store.get(emulatorInstanceAtom)).toBe(mockInstance)
    })

    it('should allow clearing instance', () => {
      const mockInstance = {
        name: 'cpcec'
      } as unknown as typeof globalThis.cpcec
      store.set(emulatorInstanceAtom, mockInstance)
      store.set(emulatorInstanceAtom, null)
      expect(store.get(emulatorInstanceAtom)).toBeNull()
    })
  })

  describe('viewModeAtom', () => {
    it('should default to split mode', () => {
      expect(store.get(viewModeAtom)).toBe('split')
    })

    it('should allow setting to editor mode', () => {
      store.set(viewModeAtom, 'editor')
      expect(store.get(viewModeAtom)).toBe('editor')
    })

    it('should allow setting to emulator mode', () => {
      store.set(viewModeAtom, 'emulator')
      expect(store.get(viewModeAtom)).toBe('emulator')
    })

    it('should allow setting to markdown mode', () => {
      store.set(viewModeAtom, 'markdown')
      expect(store.get(viewModeAtom)).toBe('markdown')
    })

    it('should allow switching between all modes', () => {
      store.set(viewModeAtom, 'editor')
      expect(store.get(viewModeAtom)).toBe('editor')

      store.set(viewModeAtom, 'emulator')
      expect(store.get(viewModeAtom)).toBe('emulator')

      store.set(viewModeAtom, 'markdown')
      expect(store.get(viewModeAtom)).toBe('markdown')

      store.set(viewModeAtom, 'split')
      expect(store.get(viewModeAtom)).toBe('split')
    })
  })

  describe('setEmulatorReadyAtom', () => {
    it('should set emulatorReady to true', () => {
      store.set(setEmulatorReadyAtom, true)
      expect(store.get(emulatorReadyAtom)).toBe(true)
    })

    it('should set emulatorReady to false', () => {
      store.set(emulatorReadyAtom, true)
      store.set(setEmulatorReadyAtom, false)
      expect(store.get(emulatorReadyAtom)).toBe(false)
    })
  })

  describe('setEmulatorRunningAtom', () => {
    it('should set emulatorRunning to true', () => {
      store.set(setEmulatorRunningAtom, true)
      expect(store.get(emulatorRunningAtom)).toBe(true)
    })

    it('should set emulatorRunning to false', () => {
      store.set(emulatorRunningAtom, true)
      store.set(setEmulatorRunningAtom, false)
      expect(store.get(emulatorRunningAtom)).toBe(false)
    })
  })

  describe('emulatorResetTriggerAtom', () => {
    it('should default to 0', () => {
      expect(store.get(emulatorResetTriggerAtom)).toBe(0)
    })

    it('should allow direct incrementing', () => {
      store.set(emulatorResetTriggerAtom, 1)
      expect(store.get(emulatorResetTriggerAtom)).toBe(1)
    })
  })

  describe('triggerEmulatorResetAtom', () => {
    it('should increment the reset trigger', () => {
      expect(store.get(emulatorResetTriggerAtom)).toBe(0)
      store.set(triggerEmulatorResetAtom)
      expect(store.get(emulatorResetTriggerAtom)).toBe(1)
    })

    it('should increment multiple times', () => {
      store.set(triggerEmulatorResetAtom)
      store.set(triggerEmulatorResetAtom)
      store.set(triggerEmulatorResetAtom)
      expect(store.get(emulatorResetTriggerAtom)).toBe(3)
    })
  })
})
