import { ValidationError } from '../errors/domain.error'
import { PROJECT_NAME_ERRORS } from '../errors/error-messages'

/**
 * Value Object for project name
 * Factory-based approach for TypeScript
 */

// Brand type to ensure type safety
const PROJECT_NAME_BRAND = Symbol('ProjectName')

export type ProjectName = Readonly<{
  value: string
  _brand: typeof PROJECT_NAME_BRAND
}>

export const PROJECT_NAME_MIN_LENGTH = 3
export const PROJECT_NAME_MAX_LENGTH = 100
// Allow letters (including accented), numbers, spaces, and common punctuation
const VALID_PATTERN = /^[\p{L}\p{N}\s\-_'".,()+&#!/]+$/u

export function createProjectName(name: string): ProjectName {
  const trimmed = name.trim()

  if (trimmed.length === 0) {
    throw new ValidationError(PROJECT_NAME_ERRORS.EMPTY)
  }

  if (trimmed.length < PROJECT_NAME_MIN_LENGTH) {
    throw new ValidationError(
      PROJECT_NAME_ERRORS.TOO_SHORT(PROJECT_NAME_MIN_LENGTH)
    )
  }

  if (trimmed.length > PROJECT_NAME_MAX_LENGTH) {
    throw new ValidationError(
      PROJECT_NAME_ERRORS.TOO_LONG(PROJECT_NAME_MAX_LENGTH)
    )
  }

  if (!VALID_PATTERN.test(trimmed)) {
    throw new ValidationError(PROJECT_NAME_ERRORS.INVALID_CHARS)
  }

  return Object.freeze({
    value: trimmed,
    _brand: PROJECT_NAME_BRAND
  })
}

export function isProjectName(value: unknown): value is ProjectName {
  return (
    typeof value === 'object' &&
    value !== null &&
    '_brand' in value &&
    value._brand === PROJECT_NAME_BRAND
  )
}
