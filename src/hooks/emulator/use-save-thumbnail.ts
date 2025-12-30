/**
 * Hook for capturing emulator screenshots and saving as project thumbnails
 */

import { useQueryClient } from '@tanstack/react-query'
import { useCallback, useState } from 'react'
import { getEmulatorCanvas } from '@/components/emulator'
import { useAuth, useCurrentProject, useToastActions } from '@/hooks'
import { invalidateProjectCaches } from '@/hooks/projects/invalidate-project-caches'
import { container } from '@/infrastructure/container'
import { createLogger } from '@/lib/logger'
import { supabase } from '@/lib/supabase'

const logger = createLogger('useSaveThumbnail')

const THUMBNAIL_BUCKET = 'thumbnails'
const THUMBNAIL_MAX_WIDTH = 384 // Half of 768
const THUMBNAIL_MAX_HEIGHT = 272 // Half of 544

/**
 * Capture the emulator canvas and resize it for thumbnail
 */
function captureAndResizeCanvas(): Promise<Blob | null> {
  return new Promise((resolve) => {
    const canvas = getEmulatorCanvas()
    if (!canvas) {
      resolve(null)
      return
    }

    // Create a smaller canvas for the thumbnail
    const thumbnailCanvas = document.createElement('canvas')
    thumbnailCanvas.width = THUMBNAIL_MAX_WIDTH
    thumbnailCanvas.height = THUMBNAIL_MAX_HEIGHT

    const ctx = thumbnailCanvas.getContext('2d')
    if (!ctx) {
      resolve(null)
      return
    }

    // Draw the emulator canvas scaled down
    ctx.drawImage(
      canvas,
      0,
      0,
      canvas.width,
      canvas.height,
      0,
      0,
      THUMBNAIL_MAX_WIDTH,
      THUMBNAIL_MAX_HEIGHT
    )

    // Convert to WebP for better compression (fallback to PNG)
    thumbnailCanvas.toBlob(
      (blob) => resolve(blob),
      'image/webp',
      0.8 // Quality
    )
  })
}

/**
 * Get the public URL for a thumbnail path
 * @param path - The storage path of the thumbnail
 * @param updatedAt - Optional date for cache-busting (prevents browser cache issues when thumbnail is updated)
 */
export function getThumbnailUrl(
  path: string | null | undefined,
  updatedAt?: Date
): string | null {
  if (!path) return null
  const { data } = supabase.storage.from(THUMBNAIL_BUCKET).getPublicUrl(path)
  // Add cache-buster if updatedAt is provided
  if (updatedAt) {
    return `${data.publicUrl}?t=${updatedAt.getTime()}`
  }
  return data.publicUrl
}

/**
 * Hook to capture and save emulator screenshot as project thumbnail
 */
export function useSaveThumbnail() {
  const { user } = useAuth()
  const { project } = useCurrentProject()
  const toast = useToastActions()
  const queryClient = useQueryClient()
  const [loading, setLoading] = useState(false)

  const saveThumbnail = useCallback(async () => {
    if (!user || !project) {
      toast.error('No project selected')
      return { success: false }
    }

    setLoading(true)

    try {
      // Capture the canvas
      const blob = await captureAndResizeCanvas()
      if (!blob) {
        toast.error('Failed to capture screenshot')
        return { success: false }
      }

      // Use the use case to save thumbnail
      const result = await container.saveThumbnail.execute({
        projectId: project.id,
        userId: user.id,
        imageBlob: blob
      })

      // Invalidate project caches to reflect thumbnail change
      invalidateProjectCaches(queryClient, {
        projectId: project.id,
        userId: user.id,
        project: result.project
      })

      toast.success('Thumbnail saved!')
      return { success: true, thumbnailUrl: result.thumbnailUrl }
    } catch (error) {
      logger.error('Save thumbnail error:', error)
      toast.error('Failed to save thumbnail')
      return { success: false }
    } finally {
      setLoading(false)
    }
  }, [user, project, toast, queryClient])

  return { saveThumbnail, loading }
}
