import { ValidationError } from '../errors/domain.error'
import { FILE_CONTENT_ERRORS } from '../errors/error-messages'

/**
 * Value Object representing file content
 */
export type FileContent = {
  readonly value: string
  readonly _brand: 'FileContent'
}

// Business rule: content size limit (1MB)
export const FILE_CONTENT_MAX_SIZE = 1024 * 1024

/**
 * Factory function to create FileContent
 */
export function createFileContent(content: string): FileContent {
  const byteSize = new Blob([content]).size

  if (byteSize > FILE_CONTENT_MAX_SIZE) {
    throw new ValidationError(
      FILE_CONTENT_ERRORS.TOO_LARGE(byteSize, FILE_CONTENT_MAX_SIZE)
    )
  }

  return {
    value: content,
    _brand: 'FileContent'
  }
}

/**
 * Create empty file content
 */
export function emptyFileContent(): FileContent {
  return createFileContent('')
}

/**
 * Type guard
 */
export function isFileContent(value: unknown): value is FileContent {
  return (
    typeof value === 'object' &&
    value !== null &&
    '_brand' in value &&
    (value as any)._brand === 'FileContent'
  )
}

/**
 * Business logic: Check if content is empty
 */
export function isEmpty(content: FileContent): boolean {
  return content.value.trim().length === 0
}

/**
 * Business logic: Get content length in bytes
 */
export function getByteSize(content: FileContent): number {
  return new Blob([content.value]).size
}
