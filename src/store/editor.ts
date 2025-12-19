import { atom } from 'jotai'

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

// Parse RASM error format: [/input.asm:23] -> extracts line 23
// RASM adds offset lines for directives we prepend:
// - SNA: BUILDSNA + BANKSET = 2 lines
// - DSK: blank line + __cpc_playground_start equ = 2 lines (source starts at line 3)
const RASM_LINE_OFFSET = 2

function extractLineNumber(text: string): number | undefined {
  // Match patterns like [/input.asm:23] or [input.asm:23]
  const match = text.match(/\[\/?\w+\.asm:(\d+)\]/)
  if (match) {
    const rawLine = Number.parseInt(match[1], 10)
    // Subtract the offset from RASM directives we add
    return Math.max(1, rawLine - RASM_LINE_OFFSET)
  }
  return undefined
}

// Actions
export const addConsoleMessageAtom = atom(
  null,
  (get, set, message: Omit<ConsoleMessage, 'timestamp' | 'id' | 'line'>) => {
    const messages = get(consoleMessagesAtom)
    messageCounter += 1
    const line = extractLineNumber(message.text)

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
