/**
 * Assembler Error Parser Interface
 * Defines contract for parsing assembler output to extract error information
 * Each assembler implementation (RASM, PASMO, SJASM, etc.) provides its own parser
 */

export type ParsedAssemblerError = {
  /** Original error text */
  text: string
  /** Extracted line number (adjusted for any offset), if found */
  line: number | undefined
  /** Raw line number from assembler output, before offset adjustment */
  rawLine: number | undefined
}

export type AssemblerErrorParser = {
  /**
   * Extract line number from error message (with offset adjustment)
   */
  extractLineNumber(text: string): number | undefined

  /**
   * Extract raw line number without offset adjustment
   */
  extractRawLineNumber(text: string): number | undefined

  /**
   * Parse error text and return structured error info
   */
  parseError(text: string): ParsedAssemblerError

  /**
   * Check if text contains an error pattern
   */
  hasError(text: string): boolean
}
