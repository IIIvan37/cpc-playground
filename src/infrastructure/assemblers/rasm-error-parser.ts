/**
 * RASM Error Parser
 * Implementation of AssemblerErrorParser for RASM assembler
 * https://github.com/EdouardBERGE/rasm
 */

import type {
  AssemblerErrorParser,
  ParsedAssemblerError
} from '@/domain/services/assembler-error-parser.interface'

/**
 * RASM adds offset lines for directives we prepend:
 * - SNA: BUILDSNA + BANKSET = 2 lines
 * - DSK: blank line + __cpc_playground_start equ = 2 lines (source starts at line 3)
 */
const DEFAULT_LINE_OFFSET = 2

export type RasmErrorParserConfig = {
  /** Number of lines RASM adds before user code (default: 2) */
  lineOffset?: number
}

/**
 * Create a RASM error parser
 */
export function createRasmErrorParser(
  config: RasmErrorParserConfig = {}
): AssemblerErrorParser {
  const lineOffset = config.lineOffset ?? DEFAULT_LINE_OFFSET

  // Match patterns like [/input.asm:23] or [input.asm:23]
  const ERROR_PATTERN = /\[\/?\w+\.asm:(\d+)\]/

  function extractRawLineNumber(text: string): number | undefined {
    const match = text.match(ERROR_PATTERN)
    if (match) {
      return Number.parseInt(match[1], 10)
    }
    return undefined
  }

  function extractLineNumber(text: string): number | undefined {
    const rawLine = extractRawLineNumber(text)
    if (rawLine !== undefined) {
      // Subtract the offset from RASM directives and ensure at least line 1
      return Math.max(1, rawLine - lineOffset)
    }
    return undefined
  }

  function parseError(text: string): ParsedAssemblerError {
    const rawLine = extractRawLineNumber(text)
    const line =
      rawLine !== undefined ? Math.max(1, rawLine - lineOffset) : undefined

    return {
      text,
      line,
      rawLine
    }
  }

  function hasError(text: string): boolean {
    return ERROR_PATTERN.test(text)
  }

  return {
    extractLineNumber,
    extractRawLineNumber,
    parseError,
    hasError
  }
}

/**
 * Default RASM parser instance with standard configuration
 */
export const rasmErrorParser = createRasmErrorParser()
