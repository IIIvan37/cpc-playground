import { atom } from 'jotai'
import type { AssemblerType } from '@/domain/services/assembler.interface'
import { getAssemblerRegistry } from '@/infrastructure/assemblers'
import { activeProjectAtom, currentFileIdAtom } from './projects'

// Current file name (derived from active project and file id)
export const currentFileNameAtom = atom((get) => {
  const project = get(activeProjectAtom)
  const currentFileId = get(currentFileIdAtom)
  if (!project || !currentFileId) return null
  const file = project.files.find((f) => f.id === currentFileId)
  return file?.name.value ?? null
})

// Check if current file is a markdown file
export const isMarkdownFileAtom = atom((get) => {
  const fileName = get(currentFileNameAtom)
  if (!fileName) return false
  return fileName.toLowerCase().endsWith('.md')
})

// Editor content
export const codeAtom = atom(`; CPC Playground - Z80 Assembly
; Write your code here and press "Assemble & Run"

org #4000

start:
    ld a, 1
    call #bc0e      ; SCR SET MODE
    
    ld hl, message
    call print_string
    
    ret

print_string:
    ld a, (hl)
    or a
    ret z
    call #bb5a      ; TXT OUTPUT
    inc hl
    jr print_string

message:
    db "Hello from CPC Playground!", 0
`)

// Selected assembler
export const selectedAssemblerAtom = atom<AssemblerType>('rasm')

// Output format: SNA (snapshot) or DSK (disk)
export type OutputFormat = 'sna' | 'dsk'
export const outputFormatAtom = atom<OutputFormat>('sna')

// Compilation state
export type CompilationStatus = 'idle' | 'compiling' | 'success' | 'error'
export const compilationStatusAtom = atom<CompilationStatus>('idle')
export const compilationErrorAtom = atom<string | null>(null)
export const compilationOutputAtom = atom<Uint8Array | null>(null)

// Go to line in editor (triggered from console errors)
export const goToLineAtom = atom<number | null>(null)

// Error lines to highlight in editor
export const errorLinesAtom = atom<number[]>([])

// Console output
export interface ConsoleMessage {
  id: string
  type: 'info' | 'error' | 'success' | 'warning'
  text: string
  timestamp: Date
  line?: number // Optional line number extracted from error
}
export const consoleMessagesAtom = atom<ConsoleMessage[]>([])

let messageCounter = 0

// Actions
export const addConsoleMessageAtom = atom(
  null,
  (get, set, message: Omit<ConsoleMessage, 'timestamp' | 'id' | 'line'>) => {
    const messages = get(consoleMessagesAtom)
    messageCounter += 1

    // Get the error parser for the selected assembler
    const assemblerType = get(selectedAssemblerAtom)
    const registry = getAssemblerRegistry()
    const assembler = registry.get(assemblerType) ?? registry.getDefault()
    const line = assembler.config.errorParser.extractLineNumber(message.text)

    // If we extracted a line number, it's an error line - add to highlights
    // (RASM outputs errors to stdout, so we can't rely on message type)
    if (line !== undefined) {
      const currentErrors = get(errorLinesAtom)
      if (!currentErrors.includes(line)) {
        set(errorLinesAtom, [...currentErrors, line])
      }
    }

    set(consoleMessagesAtom, [
      ...messages,
      { ...message, id: `msg-${messageCounter}`, timestamp: new Date(), line }
    ])
  }
)

export const clearConsoleAtom = atom(null, (_get, set) => {
  set(consoleMessagesAtom, [])
  set(errorLinesAtom, []) // Clear error highlights too
})

// Clear only error lines (called when starting new compilation)
export const clearErrorLinesAtom = atom(null, (_get, set) => {
  set(errorLinesAtom, [])
})
