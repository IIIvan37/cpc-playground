import { ValidationError } from '../errors/domain.error'
import { VISIBILITY_ERRORS } from '../errors/error-messages'

/**
 * Value Object for project visibility
 * Factory-based approach for TypeScript
 */

export type VisibilityValue = 'private' | 'unlisted' | 'public'

export const VISIBILITY_VALUES = Object.freeze([
  'private',
  'unlisted',
  'public'
] as const)

const VISIBILITY_BRAND = Symbol('Visibility')

export type Visibility = Readonly<{
  value: VisibilityValue
  _brand: typeof VISIBILITY_BRAND
}>

export function createVisibility(visibility: string): Visibility {
  if (!VISIBILITY_VALUES.includes(visibility as VisibilityValue)) {
    throw new ValidationError(
      VISIBILITY_ERRORS.INVALID(visibility, VISIBILITY_VALUES)
    )
  }

  return Object.freeze({
    value: visibility as VisibilityValue,
    _brand: VISIBILITY_BRAND
  })
}

// Pre-defined instances for convenience
export const Visibility = {
  PRIVATE: createVisibility('private'),
  UNLISTED: createVisibility('unlisted'),
  PUBLIC: createVisibility('public')
} as const

// Helper functions
export function isVisibility(value: unknown): value is Visibility {
  return (
    typeof value === 'object' &&
    value !== null &&
    '_brand' in value &&
    value._brand === VISIBILITY_BRAND
  )
}

export function isPublic(visibility: Visibility): boolean {
  return visibility.value === 'public'
}

export function isPrivate(visibility: Visibility): boolean {
  return visibility.value === 'private'
}

export function canBeShared(visibility: Visibility): boolean {
  return visibility.value !== 'private'
}
