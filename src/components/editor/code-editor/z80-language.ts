import {
  LanguageSupport,
  StreamLanguage,
  type StringStream
} from '@codemirror/language'
import { tags as t } from '@lezer/highlight'

// Z80 instructions grouped by type
const LOAD_INSTRUCTIONS = /^(ld|ldd|lddr|ldi|ldir|push|pop|ex|exx)$/i
const ARITHMETIC_INSTRUCTIONS =
  /^(add|adc|sub|sbc|and|or|xor|cp|inc|dec|daa|cpl|neg|ccf|scf)$/i
const ROTATE_SHIFT_INSTRUCTIONS =
  /^(rlca|rrca|rla|rra|rlc|rrc|rl|rr|sla|sra|srl|sll|rld|rrd)$/i
const BIT_INSTRUCTIONS = /^(bit|set|res)$/i
const JUMP_INSTRUCTIONS = /^(jp|jr|call|ret|reti|retn|rst|djnz)$/i
const IO_INSTRUCTIONS = /^(in|out|ini|inir|ind|indr|outi|otir|outd|otdr)$/i
const BLOCK_INSTRUCTIONS = /^(cpd|cpdr|cpi|cpir)$/i
const MISC_INSTRUCTIONS = /^(nop|halt|di|ei|im)$/i

// RASM directives - split for readability
const RASM_DATA_DIRECTIVES =
  /^(org|equ|db|defb|dm|defm|dw|defw|ds|defs|align|incbin|include|read)$/i
const RASM_OUTPUT_DIRECTIVES =
  /^(save|write|assert|print|fail|stop|buildsna|buildcpr|run)$/i
const RASM_CONTROL_DIRECTIVES =
  /^(repeat|rend|until|while|wend|if|ifdef|ifndef|else|elseif|endif)$/i
const RASM_MACRO_DIRECTIVES =
  /^(macro|mend|endm|struct|endstruct|ends|let|switch|case|default|endswitch|break)$/i
const RASM_OTHER_DIRECTIVES =
  /^(bank|bankset|list|nolist|protect|unprotect|memspace|charset|nocode|code)$/i
const RASM_RELOCATE_DIRECTIVES =
  /^(relocate_start|relocate_end|relocate_table|lz4|lz48|lz49|lzclose)$/i
const RASM_CPC_DIRECTIVES = /^(lbldef|setcpc|setcrtc|setamsdos)$/i

// Registers
const REGISTERS_8BIT = /^(a|b|c|d|e|h|l|i|r|ixh|ixl|iyh|iyl)$/i
const REGISTERS_16BIT = /^(af|bc|de|hl|sp|pc|ix|iy|af')$/i

// Conditions
const CONDITIONS = /^(nz|z|nc|c|po|pe|p|m)$/i

interface Z80State {
  inString: string | null
}

function isRasmDirective(word: string): boolean {
  return (
    RASM_DATA_DIRECTIVES.test(word) ||
    RASM_OUTPUT_DIRECTIVES.test(word) ||
    RASM_CONTROL_DIRECTIVES.test(word) ||
    RASM_MACRO_DIRECTIVES.test(word) ||
    RASM_OTHER_DIRECTIVES.test(word) ||
    RASM_RELOCATE_DIRECTIVES.test(word) ||
    RASM_CPC_DIRECTIVES.test(word) ||
    word === '='
  )
}

function isZ80Instruction(word: string): boolean {
  return (
    LOAD_INSTRUCTIONS.test(word) ||
    ARITHMETIC_INSTRUCTIONS.test(word) ||
    ROTATE_SHIFT_INSTRUCTIONS.test(word) ||
    BIT_INSTRUCTIONS.test(word) ||
    JUMP_INSTRUCTIONS.test(word) ||
    IO_INSTRUCTIONS.test(word) ||
    BLOCK_INSTRUCTIONS.test(word) ||
    MISC_INSTRUCTIONS.test(word)
  )
}

function tokenizeString(stream: StringStream, state: Z80State): void {
  const quote = state.inString
  while (!stream.eol() && quote) {
    const ch = stream.next()
    if (ch === quote) {
      state.inString = null
      break
    }
    if (ch === '\\') stream.next()
  }
}

function tokenizeNumber(stream: StringStream): string | null {
  // Hexadecimal numbers: #FF, $FF, 0xFF, &FF, FFh
  if (
    stream.match(/^#[0-9a-f]+/i) ||
    stream.match(/^\$[0-9a-f]+/i) ||
    stream.match(/^0x[0-9a-f]+/i) ||
    stream.match(/^&[0-9a-f]+/i) ||
    stream.match(/^\d[a-f]*h/i)
  ) {
    return 'number'
  }

  // Binary numbers: %10101010, 0b10101010, 10101010b
  if (
    stream.match(/^%[01]+/) ||
    stream.match(/^0b[01]+/i) ||
    stream.match(/^[01]+b/i)
  ) {
    return 'number'
  }

  // Decimal numbers
  if (stream.match(/^\d+/)) {
    return 'number'
  }

  return null
}

function tokenizeWord(stream: StringStream): string | null {
  if (stream.match(/^[\w']+/)) {
    const word = stream.current()

    if (isRasmDirective(word)) return 'keyword'
    if (isZ80Instruction(word)) return 'keyword'
    if (REGISTERS_8BIT.test(word) || REGISTERS_16BIT.test(word))
      return 'variableName'
    if (CONDITIONS.test(word)) return 'atom'

    return 'name'
  }
  return null
}

function handleComment(stream: StringStream): string | null {
  if (stream.match(';') || stream.match('//')) {
    stream.skipToEnd()
    return 'comment'
  }
  if (stream.match('/*')) {
    while (!stream.eol()) {
      if (stream.match('*/')) break
      stream.next()
    }
    return 'comment'
  }
  return null
}

function handleString(stream: StringStream, state: Z80State): string | null {
  const quote = stream.peek()
  if (quote === '"' || quote === "'") {
    stream.next()
    state.inString = quote
    tokenizeString(stream, state)
    return 'string'
  }
  return null
}

function handleLabel(stream: StringStream): string | null {
  if (stream.match(/^\.?@?\w+:/)) return 'labelName'
  if (stream.match(/^@\w+/)) return 'labelName'
  if (stream.sol() && stream.match(/^\.\w+/)) return 'labelName'
  return null
}

function handleOperator(stream: StringStream): string | null {
  if (stream.match(/^[+\-*/%&|^~<>!=]+/)) return 'operator'
  return null
}

function handleBracket(stream: StringStream): string | null {
  if (stream.match(/^[()[\]]/)) return 'bracket'
  return null
}

function handlePunctuation(stream: StringStream): string | null {
  if (stream.match(/^[,:]/)) return 'punctuation'
  return null
}

export function z80Mode() {
  return {
    name: 'z80',
    startState(): Z80State {
      return { inString: null }
    },
    token(stream: StringStream, state: Z80State): string | null {
      if (state.inString) {
        tokenizeString(stream, state)
        return 'string'
      }
      if (stream.eatSpace()) return null

      // Comments
      const commentToken = handleComment(stream)
      if (commentToken) return commentToken

      // Strings
      const stringToken = handleString(stream, state)
      if (stringToken) return stringToken

      // Numbers
      const numberToken = tokenizeNumber(stream)
      if (numberToken) return numberToken

      // Labels
      const labelToken = handleLabel(stream)
      if (labelToken) return labelToken

      // Operators
      const operatorToken = handleOperator(stream)
      if (operatorToken) return operatorToken

      // Brackets
      const bracketToken = handleBracket(stream)
      if (bracketToken) return bracketToken

      // Words (instructions, directives, registers, labels)
      const wordToken = tokenizeWord(stream)
      if (wordToken) return wordToken

      // Punctuation
      const punctuationToken = handlePunctuation(stream)
      if (punctuationToken) return punctuationToken

      // Skip unknown characters
      stream.next()
      return null
    }
  }
}

// Create the language
const z80Language = StreamLanguage.define(z80Mode())

// Highlighting style tags mapping
export const z80Highlighting = {
  keyword: t.keyword,
  variableName: t.variableName,
  atom: t.atom,
  number: t.number,
  string: t.string,
  comment: t.comment,
  labelName: t.labelName,
  operator: t.operator,
  bracket: t.bracket,
  punctuation: t.punctuation,
  name: t.name
}

/**
 * Z80 Assembly language support for CodeMirror
 * Includes syntax highlighting for:
 * - Z80 instructions (LD, PUSH, CALL, JP, etc.)
 * - RASM directives (ORG, DB, MACRO, IF, etc.)
 * - Registers (A, B, C, HL, IX, etc.)
 * - Numbers (hex, binary, decimal)
 * - Labels and comments
 */
export function z80() {
  return new LanguageSupport(z80Language)
}
