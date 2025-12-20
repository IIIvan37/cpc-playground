import { ValidationError } from '../errors/domain.error'

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

const MAX_LENGTH = 255
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
    throw new ValidationError('File name cannot be empty')
  }

  if (trimmed.length > MAX_LENGTH) {
    throw new ValidationError(
      `File name must be less than ${MAX_LENGTH} characters long`
    )
  }

  if (INVALID_CHARS.test(trimmed)) {
    throw new ValidationError(
      'File name cannot contain special characters: < > : " | ? *'
    )
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
