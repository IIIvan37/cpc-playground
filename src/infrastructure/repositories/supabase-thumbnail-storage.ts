import type { SupabaseClient } from '@supabase/supabase-js'
import type { IThumbnailStorage } from '@/use-cases/projects/save-thumbnail.use-case'

const THUMBNAIL_BUCKET = 'thumbnails'

/**
 * Supabase implementation of IThumbnailStorage
 */
export function createSupabaseThumbnailStorage(
  supabase: SupabaseClient
): IThumbnailStorage {
  return {
    async upload(
      path: string,
      blob: Blob,
      options?: { upsert?: boolean; contentType?: string }
    ): Promise<{ path: string } | { error: Error }> {
      const { error } = await supabase.storage
        .from(THUMBNAIL_BUCKET)
        .upload(path, blob, {
          upsert: options?.upsert ?? false,
          contentType: options?.contentType
        })

      if (error) {
        return { error: new Error(error.message) }
      }

      return { path }
    },

    getPublicUrl(path: string): string {
      const { data } = supabase.storage
        .from(THUMBNAIL_BUCKET)
        .getPublicUrl(path)

      return data.publicUrl
    }
  }
}
