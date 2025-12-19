import { atom } from 'jotai'

export interface SavedProgram {
  id: string
  name: string
  code: string
  createdAt: string
  updatedAt: string
}

const STORAGE_KEY = 'cpc-playground-programs'

// Load programs from localStorage
function loadPrograms(): SavedProgram[] {
  try {
    const stored = localStorage.getItem(STORAGE_KEY)
    return stored ? JSON.parse(stored) : []
  } catch {
    return []
  }
}

// Save programs to localStorage
function savePrograms(programs: SavedProgram[]) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(programs))
}

// Atom with localStorage persistence
export const savedProgramsAtom = atom<SavedProgram[]>(loadPrograms())

// Current program ID being edited
export const currentProgramIdAtom = atom<string | null>(null)

// Actions
export const saveProgramAtom = atom(
  null,
  (get, set, { name, code }: { name: string; code: string }) => {
    const programs = get(savedProgramsAtom)
    const currentId = get(currentProgramIdAtom)
    const now = new Date().toISOString()

    if (currentId) {
      // Update existing
      const updated = programs.map((p) =>
        p.id === currentId ? { ...p, name, code, updatedAt: now } : p
      )
      set(savedProgramsAtom, updated)
      savePrograms(updated)
    } else {
      // Create new
      const newProgram: SavedProgram = {
        id: crypto.randomUUID(),
        name,
        code,
        createdAt: now,
        updatedAt: now
      }
      const updated = [...programs, newProgram]
      set(savedProgramsAtom, updated)
      set(currentProgramIdAtom, newProgram.id)
      savePrograms(updated)
    }
  }
)

export const loadProgramAtom = atom(null, (get, set, id: string) => {
  const programs = get(savedProgramsAtom)
  const program = programs.find((p) => p.id === id)
  if (program) {
    set(currentProgramIdAtom, id)
    return program
  }
  return null
})

export const deleteProgramAtom = atom(null, (get, set, id: string) => {
  const programs = get(savedProgramsAtom)
  const currentId = get(currentProgramIdAtom)
  const updated = programs.filter((p) => p.id !== id)
  set(savedProgramsAtom, updated)
  savePrograms(updated)

  if (currentId === id) {
    set(currentProgramIdAtom, null)
  }
})

export const newProgramAtom = atom(null, (_get, set) => {
  set(currentProgramIdAtom, null)
})
