import { DomainError } from './domain.error'

/**
 * Error thrown when validation fails in value objects or entities
 */
export class ValidationError extends DomainError {
  constructor(message: string) {
    super(message)
    this.name = 'ValidationError'
    Object.setPrototypeOf(this, ValidationError.prototype)
  }
}
