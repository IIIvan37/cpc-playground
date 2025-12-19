import { atom } from 'jotai'

// Emulator state
export const emulatorReadyAtom = atom(false)
export const emulatorRunningAtom = atom(false)
export const emulatorInstanceAtom = atom<typeof globalThis.cpcec | null>(null)

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
