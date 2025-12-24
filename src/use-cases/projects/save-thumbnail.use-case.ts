import type { Project } from '@/domain/entities/project.entity'
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'

/**
 * Use Case: Save a project thumbnail
 *
 * Uploads a thumbnail image to storage and updates the project's thumbnail path.
 */

export type SaveThumbnailInput = {
  projectId: string
  userId: string
  imageBlob: Blob
}

export type SaveThumbnailOutput = {
  project: Project
  thumbnailUrl: string
}

export type IThumbnailStorage = {
  upload(
    path: string,
    blob: Blob,
    options?: { upsert?: boolean; contentType?: string }
  ): Promise<{ path: string } | { error: Error }>
  getPublicUrl(path: string): string
}

export type SaveThumbnailUseCase = {
  execute(input: SaveThumbnailInput): Promise<SaveThumbnailOutput>
}

/**
 * Factory function that creates SaveThumbnailUseCase
 */
export function createSaveThumbnailUseCase(
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService,
  thumbnailStorage: IThumbnailStorage
): SaveThumbnailUseCase {
  return {
    async execute(input: SaveThumbnailInput): Promise<SaveThumbnailOutput> {
      const { projectId, userId, imageBlob } = input

      // Verify user owns the project
      await authorizationService.mustOwnProject(projectId, userId)

      // Build storage path: userId/projectId.webp
      const storagePath = `${userId}/${projectId}.webp`

      // Upload to storage
      const uploadResult = await thumbnailStorage.upload(
        storagePath,
        imageBlob,
        {
          upsert: true,
          contentType: 'image/webp'
        }
      )

      if ('error' in uploadResult) {
        throw uploadResult.error
      }

      // Update project with thumbnail path
      const updatedProject = await projectsRepository.update(projectId, {
        thumbnailPath: storagePath
      })

      // Get public URL
      const thumbnailUrl = thumbnailStorage.getPublicUrl(storagePath)

      return {
        project: updatedProject,
        thumbnailUrl
      }
    }
  }
}
