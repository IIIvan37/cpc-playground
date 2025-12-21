import {
  NotFoundError,
  UnauthorizedError,
  ValidationError
} from '@/domain/errors'
import type {
  IProjectsRepository,
  Tag
} from '@/domain/repositories/projects.repository.interface'

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
  projectsRepository: IProjectsRepository
): AddTagUseCase {
  return {
    async execute(input: AddTagInput): Promise<AddTagOutput> {
      const { projectId, userId, tagName } = input

      // Validate tag name
      if (!isValidTagName(tagName)) {
        throw new ValidationError(
          `Invalid tag name "${tagName}". Tags must be 2-30 characters, lowercase alphanumeric with hyphens only.`
        )
      }

      // Check project exists
      const project = await projectsRepository.findById(projectId)
      if (!project) {
        throw new NotFoundError(`Project with id ${projectId} not found`)
      }

      // Check user owns the project
      if (project.userId !== userId) {
        throw new UnauthorizedError(
          'You are not authorized to modify this project'
        )
      }

      // Add tag
      const tag = await projectsRepository.addTag(projectId, tagName)

      return { tag }
    }
  }
}
