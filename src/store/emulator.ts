import { atom } from 'jotai'

// Emulator state
export const emulatorReadyAtom = atom(false)
export const emulatorRunningAtom = atom(false)
export const emulatorInstanceAtom = atom<typeof globalThis.cpcec | null>(null)

// Reset trigger - incremented when a reset is requested
export const emulatorResetTriggerAtom = atom(0)

// View mode
export type ViewMode = 'split' | 'editor' | 'emulator'
export const viewModeAtom = atom<ViewMode>('split')

// Emulator actions
export const setEmulatorReadyAtom = atom(null, (_get, set, ready: boolean) => {
  set(emulatorReadyAtom, ready)
})

export const setEmulatorRunningAtom = atom(
  null,
  (_get, set, running: boolean) => {
    set(emulatorRunningAtom, running)
  }
)

// Trigger emulator reset
export const triggerEmulatorResetAtom = atom(null, (_get, set) => {
  set(emulatorResetTriggerAtom, (prev) => prev + 1)
})
