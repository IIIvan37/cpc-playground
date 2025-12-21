import { ValidationError } from '../errors/domain.error'

/**
 * Value Object representing file content
 */
export type FileContent = {
  readonly value: string
  readonly _brand: 'FileContent'
}

/**
 * Factory function to create FileContent
 */
export function createFileContent(content: string): FileContent {
  // Business rule: content size limit (1MB)
  const MAX_SIZE = 1024 * 1024
  const byteSize = new Blob([content]).size

  if (byteSize > MAX_SIZE) {
    throw new ValidationError(
      `File content too large: ${byteSize} bytes (max: ${MAX_SIZE})`
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
