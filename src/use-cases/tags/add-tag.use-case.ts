import { ValidationError } from '@/domain/errors'
import { TAG_ERRORS } from '@/domain/errors/error-messages'
import type {
  IProjectsRepository,
  Tag
} from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'

// ============================================================================
// Types
// ============================================================================

export type AddTagInput = {
  projectId: string
  userId: string
  tagName: string
}

export type AddTagOutput = {
  tag: Tag
}

export type AddTagUseCase = {
  execute(input: AddTagInput): Promise<AddTagOutput>
}

// ============================================================================
// Validation
// ============================================================================

function isValidTagName(tagName: string): boolean {
  const normalized = tagName.toLowerCase().trim()
  // Match the DB constraint: 2-30 chars, lowercase alphanumeric with hyphens
  return /^[a-z0-9-]{2,30}$/.test(normalized)
}

// ============================================================================
// Use Case Factory
// ============================================================================

export function createAddTagUseCase(
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
): AddTagUseCase {
  return {
    async execute(input: AddTagInput): Promise<AddTagOutput> {
      const { projectId, userId, tagName } = input

      // Validate tag name
      if (!isValidTagName(tagName)) {
        throw new ValidationError(TAG_ERRORS.INVALID(tagName))
      }

      // Check user owns the project
      await authorizationService.mustOwnProject(projectId, userId)

      // Add tag
      const tag = await projectsRepository.addTag(projectId, tagName)

      return { tag }
    }
  }
}
