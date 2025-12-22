/**
 * Programs Store - Clean Architecture version
 * Uses use-cases with localStorage repository
 */

import { atom } from 'jotai'
import type { Program } from '@/domain/entities/program.entity'
import { programsContainer } from '@/infrastructure/programs-container'

// ============================================================================
// State Atoms
// ============================================================================

export const savedProgramsAtom = atom<Program[]>([])
export const currentProgramIdAtom = atom<string | null>(null)

// ============================================================================
// Derived Atoms
// ============================================================================

export const currentProgramAtom = atom((get) => {
  const programs = get(savedProgramsAtom)
  const currentId = get(currentProgramIdAtom)
  return programs.find((p) => p.id === currentId) ?? null
})

// ============================================================================
// Action Atoms
// ============================================================================

/**
 * Load all programs from storage
 */
export const fetchProgramsAtom = atom(null, async (_get, set) => {
  try {
    const { programs } = await programsContainer.getPrograms.execute()
    set(savedProgramsAtom, [...programs])
  } catch (error) {
    console.error('Failed to fetch programs:', error)
    throw error
  }
})

/**
 * Save a program (create or update)
 */
export const saveProgramAtom = atom(
  null,
  async (get, set, { name, code }: { name: string; code: string }) => {
    try {
      const currentId = get(currentProgramIdAtom)

      const { program } = await programsContainer.saveProgram.execute({
        id: currentId ?? undefined,
        name,
        code
      })

      // Update local state
      set(savedProgramsAtom, (prev) => {
        const index = prev.findIndex((p) => p.id === program.id)
        if (index >= 0) {
          const updated = [...prev]
          updated[index] = program
          return updated
        }
        return [...prev, program]
      })

      // Set current ID if new program
      if (!currentId) {
        set(currentProgramIdAtom, program.id)
      }

      return program
    } catch (error) {
      console.error('Failed to save program:', error)
      throw error
    }
  }
)

/**
 * Load a program by ID
 */
export const loadProgramAtom = atom(null, async (_get, set, id: string) => {
  try {
    const { program } = await programsContainer.loadProgram.execute({ id })
    set(currentProgramIdAtom, id)
    return program
  } catch (error) {
    console.error('Failed to load program:', error)
    throw error
  }
})

/**
 * Delete a program
 */
export const deleteProgramAtom = atom(null, async (get, set, id: string) => {
  try {
    await programsContainer.deleteProgram.execute({ id })

    // Update local state
    set(savedProgramsAtom, (prev) => prev.filter((p) => p.id !== id))

    // Clear current ID if deleted
    if (get(currentProgramIdAtom) === id) {
      set(currentProgramIdAtom, null)
    }
  } catch (error) {
    console.error('Failed to delete program:', error)
    throw error
  }
})

/**
 * Create a new (empty) program
 */
export const newProgramAtom = atom(null, (_get, set) => {
  set(currentProgramIdAtom, null)
})

// ============================================================================
// Legacy compatibility - re-export for old consumers
// ============================================================================

/**
 * @deprecated Use Program entity directly
 */
export interface SavedProgram {
  id: string
  name: string
  code: string
  createdAt: string
  updatedAt: string
}

/**
 * Convert Program entity to legacy SavedProgram format
 */
export function toLegacySavedProgram(program: Program): SavedProgram {
  return {
    id: program.id,
    name: program.name.value,
    code: program.code,
    createdAt: program.createdAt.toISOString(),
    updatedAt: program.updatedAt.toISOString()
  }
}

/**
 * @deprecated Use savedProgramsAtom with Program entity
 */
export const legacySavedProgramsAtom = atom((get) => {
  const programs = get(savedProgramsAtom)
  return programs.map(toLegacySavedProgram)
})
