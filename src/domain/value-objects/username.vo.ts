import { ValidationError } from '../errors/domain.error'

/**
 * Value Object for username
 * - 3-30 characters
 * - lowercase letters, numbers, underscores, hyphens only
 * - automatically normalized to lowercase
 */

const USERNAME_BRAND = Symbol('Username')

export type Username = Readonly<{
  value: string
  _brand: typeof USERNAME_BRAND
}>

export const USERNAME_MIN_LENGTH = 3
export const USERNAME_MAX_LENGTH = 30
const VALID_PATTERN = /^[a-z0-9_-]+$/

export const USERNAME_ERRORS = {
  EMPTY: 'Username cannot be empty',
  TOO_SHORT: `Username must be at least ${USERNAME_MIN_LENGTH} characters`,
  TOO_LONG: `Username cannot exceed ${USERNAME_MAX_LENGTH} characters`,
  INVALID_CHARS:
    'Username can only contain lowercase letters, numbers, underscores and hyphens'
} as const

export function createUsername(username: string): Username {
  const normalized = username.toLowerCase().trim()

  if (normalized.length === 0) {
    throw new ValidationError(USERNAME_ERRORS.EMPTY)
  }

  if (normalized.length < USERNAME_MIN_LENGTH) {
    throw new ValidationError(USERNAME_ERRORS.TOO_SHORT)
  }

  if (normalized.length > USERNAME_MAX_LENGTH) {
    throw new ValidationError(USERNAME_ERRORS.TOO_LONG)
  }

  if (!VALID_PATTERN.test(normalized)) {
    throw new ValidationError(USERNAME_ERRORS.INVALID_CHARS)
  }

  return Object.freeze({
    value: normalized,
    _brand: USERNAME_BRAND
  })
}

export function isUsername(value: unknown): value is Username {
  return (
    typeof value === 'object' &&
    value !== null &&
    '_brand' in value &&
    (value as { _brand: symbol })._brand === USERNAME_BRAND
  )
}
