/**
 * Domain-specific error types for Clean Architecture
 *
 * ⚠️ IMPORTANT: Always import errors from '@/domain/errors' in use-cases.
 * NEVER declare error classes locally in use-case files.
 *
 * Pattern to follow in every use-case:
 *
 * ```typescript
 * // ✅ CORRECT: Import from domain errors
 * import { NotFoundError, UnauthorizedError, ValidationError } from '@/domain/errors'
 *
 * // ❌ WRONG: Do NOT declare errors locally
 * // class ProjectNotFoundError extends Error { ... }
 * // class InvalidTagNameError extends Error { ... }
 * ```
 *
 * @example Use-case template
 * ```typescript
 * import { NotFoundError, UnauthorizedError, ValidationError } from '@/domain/errors'
 * import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
 *
 * export function createMyUseCase(repository: IProjectsRepository) {
 *   return {
 *     async execute(input: MyInput): Promise<MyOutput> {
 *       // 1. Validation
 *       if (!isValid(input.value)) {
 *         throw new ValidationError(`Invalid value: ${input.value}`)
 *       }
 *
 *       // 2. Check resource exists
 *       const resource = await repository.findById(input.id)
 *       if (!resource) {
 *         throw new NotFoundError(`Resource with id ${input.id} not found`)
 *       }
 *
 *       // 3. Check authorization
 *       if (resource.userId !== input.userId) {
 *         throw new UnauthorizedError('You are not authorized to modify this resource')
 *       }
 *
 *       // 4. Business logic...
 *     }
 *   }
 * }
 * ```
 *
 * @module domain/errors
 */

/**
 * Error thrown when input validation fails.
 *
 * Use for:
 * - Invalid input formats (e.g., tag names, file names)
 * - Business rule violations (e.g., self-dependency, non-library dependency)
 * - Constraint violations
 *
 * @example
 * ```typescript
 * throw new ValidationError('Tag must be 2-30 characters')
 * throw new ValidationError('A project cannot depend on itself')
 * ```
 */
export class ValidationError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'ValidationError'
  }
}

/**
 * Error thrown when a requested resource does not exist.
 *
 * Use for:
 * - Project not found
 * - File not found
 * - User not found
 * - Dependency not found
 *
 * @example
 * ```typescript
 * throw new NotFoundError(`Project with id ${projectId} not found`)
 * throw new NotFoundError(`File with id ${fileId} not found`)
 * ```
 */
export class NotFoundError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'NotFoundError'
  }
}

/**
 * Error thrown when a user lacks permission to perform an action.
 *
 * Use for:
 * - User does not own the resource
 * - User not in shared list
 * - Insufficient permissions
 *
 * @example
 * ```typescript
 * throw new UnauthorizedError('You are not authorized to modify this project')
 * throw new UnauthorizedError('You do not have access to this file')
 * ```
 */
export class UnauthorizedError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'UnauthorizedError'
  }
}
