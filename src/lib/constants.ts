// CDN Configuration
export const CPCEC_BASE_URL = import.meta.env.DEV
  ? 'https://cpcec-web.iiivan.org'
  : '/cdn'

// Share Configuration
export const SHARE_EXPIRY_DAYS = 7

// Editor Configuration
export const LINE_HEIGHT = 21
export const EDITOR_PADDING = 16

// Validation Rules
export const USERNAME_MIN_LENGTH = 3
export const USERNAME_MAX_LENGTH = 30
export const PASSWORD_MIN_LENGTH = 6

// Regex Patterns
export const USERNAME_PATTERN = /^[a-z0-9_-]+$/i
