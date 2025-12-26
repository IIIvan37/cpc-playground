/**
 * Hook for capturing emulator screenshots and saving as project thumbnails
 */

import { useQueryClient } from '@tanstack/react-query'
import { useCallback, useState } from 'react'
import { getEmulatorCanvas } from '@/components/emulator'
import { useAuth, useCurrentProject, useToastActions } from '@/hooks'
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
 */
export function getThumbnailUrl(
  path: string | null | undefined
): string | null {
  if (!path) return null
  const { data } = supabase.storage.from(THUMBNAIL_BUCKET).getPublicUrl(path)
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

      // Update project cache with new thumbnail
      queryClient.setQueryData(['project', project.id], result.project)
      // Invalidate projects lists to reflect thumbnail change in Explore page
      queryClient.invalidateQueries({
        queryKey: ['projects', 'visible'],
        refetchType: 'all'
      })
      queryClient.invalidateQueries({
        queryKey: ['projects', 'user', user.id]
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
