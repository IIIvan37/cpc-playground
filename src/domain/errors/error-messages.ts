/**
 * Centralized error messages for domain layer
 * Export constants to be used in code and tests
 */

// ============================================================================
// File Name Validation
// ============================================================================
export const FILE_NAME_ERRORS = {
  EMPTY: 'File name cannot be empty',
  TOO_LONG: (maxLength: number) =>
    `File name must be less than ${maxLength} characters long`,
  INVALID_CHARS: 'File name cannot contain special characters: < > : " | ? *'
} as const

// ============================================================================
// Project Name Validation
// ============================================================================
export const PROJECT_NAME_ERRORS = {
  EMPTY: 'Project name cannot be empty',
  TOO_SHORT: (minLength: number) =>
    `Project name must be at least ${minLength} characters long`,
  TOO_LONG: (maxLength: number) =>
    `Project name must be less than ${maxLength} characters long`,
  INVALID_CHARS: 'Project name contains invalid characters'
} as const

// ============================================================================
// File Content Validation
// ============================================================================
export const FILE_CONTENT_ERRORS = {
  TOO_LARGE: (byteSize: number, maxSize: number) =>
    `File content too large: ${byteSize} bytes (max: ${maxSize})`
} as const

// ============================================================================
// Visibility Validation
// ============================================================================
export const VISIBILITY_ERRORS = {
  INVALID: (value: string, validValues: readonly string[]) =>
    `Invalid visibility value: ${value}. Must be one of: ${validValues.join(', ')}`
} as const

// ============================================================================
// File Operations
// ============================================================================
export const FILE_ERRORS = {
  NOT_FOUND: 'File not found',
  CANNOT_DELETE_LAST: 'Cannot delete the last file in a project',
  LIBRARY_NO_MAIN: 'Library projects cannot have a main file'
} as const

// ============================================================================
// Share Operations
// ============================================================================
export const SHARE_ERRORS = {
  USERNAME_EMPTY: 'Username cannot be empty',
  USER_NOT_FOUND: (username: string) =>
    `User with username "${username}" not found`,
  CANNOT_SHARE_WITH_SELF: 'Cannot share project with yourself'
} as const

// ============================================================================
// Tag Operations
// ============================================================================
export const TAG_ERRORS = {
  INVALID: (tagName: string) =>
    `Invalid tag name "${tagName}". Tags must be 2-30 characters, lowercase alphanumeric with hyphens only.`
} as const

// ============================================================================
// Dependency Operations
// ============================================================================
export const DEPENDENCY_ERRORS = {
  SELF_DEPENDENCY: 'A project cannot depend on itself',
  NOT_FOUND: (id: string) => `Dependency project with id ${id} not found`,
  NOT_A_LIBRARY: (id: string) =>
    `Project ${id} is not a library and cannot be used as a dependency`
} as const

// ============================================================================
// Project Operations
// ============================================================================
export const PROJECT_ERRORS = {
  NOT_FOUND: (projectId: string) => `Project ${projectId} not found`
} as const

// ============================================================================
// Program Name Validation
// ============================================================================
export const PROGRAM_NAME_ERRORS = {
  EMPTY: 'Program name cannot be empty',
  TOO_LONG: (maxLength: number) =>
    `Program name must be less than ${maxLength} characters long`
} as const

// ============================================================================
// Program Operations
// ============================================================================
export const PROGRAM_ERRORS = {
  NOT_FOUND: 'Program not found'
} as const

// ============================================================================
// Authorization
// ============================================================================
export const AUTH_ERRORS = {
  PROJECT_NOT_FOUND: 'Project not found',
  UNAUTHORIZED_MODIFY: 'You do not have permission to modify this project'
} as const
