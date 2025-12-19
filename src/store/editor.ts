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

// Console output
export interface ConsoleMessage {
  id: string
  type: 'info' | 'error' | 'success' | 'warning'
  text: string
  timestamp: Date
}
export const consoleMessagesAtom = atom<ConsoleMessage[]>([])

let messageCounter = 0

// Actions
export const addConsoleMessageAtom = atom(
  null,
  (get, set, message: Omit<ConsoleMessage, 'timestamp' | 'id'>) => {
    const messages = get(consoleMessagesAtom)
    messageCounter += 1
    set(consoleMessagesAtom, [
      ...messages,
      { ...message, id: `msg-${messageCounter}`, timestamp: new Date() }
    ])
  }
)

export const clearConsoleAtom = atom(null, (_get, set) => {
  set(consoleMessagesAtom, [])
})
