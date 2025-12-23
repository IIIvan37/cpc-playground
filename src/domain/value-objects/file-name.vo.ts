import { ValidationError } from '../errors/domain.error'
import { FILE_NAME_ERRORS } from '../errors/error-messages'

/**
 * Value Object for file name
 * Factory-based approach for TypeScript
 */

const FILE_NAME_BRAND = Symbol('FileName')

export type FileName = Readonly<{
  value: string
  extension: string | null
  _brand: typeof FILE_NAME_BRAND
}>

export const FILE_NAME_MAX_LENGTH = 255
const INVALID_CHARS = /[<>:"|?*]/

function extractExtension(filename: string): string | null {
  const lastDot = filename.lastIndexOf('.')
  if (lastDot === -1 || lastDot === 0) {
    return null
  }
  return filename.slice(lastDot + 1).toLowerCase()
}

export function createFileName(name: string): FileName {
  const trimmed = name.trim()

  if (trimmed.length === 0) {
    throw new ValidationError(FILE_NAME_ERRORS.EMPTY)
  }

  if (trimmed.length > FILE_NAME_MAX_LENGTH) {
    throw new ValidationError(FILE_NAME_ERRORS.TOO_LONG(FILE_NAME_MAX_LENGTH))
  }

  if (INVALID_CHARS.test(trimmed)) {
    throw new ValidationError(FILE_NAME_ERRORS.INVALID_CHARS)
  }

  const extension = extractExtension(trimmed)

  return Object.freeze({
    value: trimmed,
    extension,
    _brand: FILE_NAME_BRAND
  })
}

export function isFileName(value: unknown): value is FileName {
  return (
    typeof value === 'object' &&
    value !== null &&
    '_brand' in value &&
    value._brand === FILE_NAME_BRAND
  )
}

export function hasExtension(fileName: FileName, ext: string): boolean {
  return fileName.extension?.toLowerCase() === ext.toLowerCase()
}

export function isAssemblyFile(fileName: FileName): boolean {
  return hasExtension(fileName, 'asm') || hasExtension(fileName, 's')
}

export function getBaseName(fileName: FileName): string {
  if (fileName.extension === null) {
    return fileName.value
  }
  return fileName.value.slice(0, -(fileName.extension.length + 1))
}
