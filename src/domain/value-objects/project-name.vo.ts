import { ValidationError } from '../errors/domain.error'

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

const MIN_LENGTH = 3
const MAX_LENGTH = 100
const VALID_PATTERN = /^[a-zA-Z0-9\s\-_]+$/

export function createProjectName(name: string): ProjectName {
  const trimmed = name.trim()

  if (trimmed.length === 0) {
    throw new ValidationError('Project name cannot be empty')
  }

  if (trimmed.length < MIN_LENGTH) {
    throw new ValidationError(
      `Project name must be at least ${MIN_LENGTH} characters long`
    )
  }

  if (trimmed.length > MAX_LENGTH) {
    throw new ValidationError(
      `Project name must be less than ${MAX_LENGTH} characters long`
    )
  }

  if (!VALID_PATTERN.test(trimmed)) {
    throw new ValidationError(
      'Project name can only contain letters, numbers, spaces, hyphens, and underscores'
    )
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
