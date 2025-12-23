import { ValidationError } from '../errors/domain.error'
import { PROGRAM_NAME_ERRORS } from '../errors/error-messages'

/**
 * Value Object for program name
 * Factory-based approach for TypeScript
 */

// Brand type to ensure type safety
const PROGRAM_NAME_BRAND = Symbol('ProgramName')

export type ProgramName = Readonly<{
  value: string
  _brand: typeof PROGRAM_NAME_BRAND
}>

export const PROGRAM_NAME_MIN_LENGTH = 1
export const PROGRAM_NAME_MAX_LENGTH = 100

export function createProgramName(name: string): ProgramName {
  const trimmed = name.trim()

  if (trimmed.length === 0) {
    throw new ValidationError(PROGRAM_NAME_ERRORS.EMPTY)
  }

  if (trimmed.length > PROGRAM_NAME_MAX_LENGTH) {
    throw new ValidationError(
      PROGRAM_NAME_ERRORS.TOO_LONG(PROGRAM_NAME_MAX_LENGTH)
    )
  }

  return Object.freeze({
    value: trimmed,
    _brand: PROGRAM_NAME_BRAND
  })
}

export function isProgramName(value: unknown): value is ProgramName {
  return (
    typeof value === 'object' &&
    value !== null &&
    '_brand' in value &&
    value._brand === PROGRAM_NAME_BRAND
  )
}
