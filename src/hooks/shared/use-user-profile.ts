/**
 * User profile hook
 * Uses Clean Architecture use-cases for profile management
 */

import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useCallback } from 'react'
import { container } from '@/infrastructure/container'
import { useAuth } from '../auth'

export type { UserProfile } from '@/domain/entities/user.entity'

export function useUserProfile() {
  const { user } = useAuth()
  const queryClient = useQueryClient()

  const { getUserProfile, updateUserProfile } = container

  // Use React Query to fetch and cache user profile
  const {
    data: profile,
    isLoading,
    error
  } = useQuery({
    queryKey: ['userProfile', user?.id],
    queryFn: async () => {
      if (!user) return null

      const { profile: fetchedProfile } = await getUserProfile.execute({
        userId: user.id
      })

      if (!fetchedProfile) {
        console.warn(
          'User profile not found. Please sign out and sign in again.'
        )
        return null
      }

      return fetchedProfile
    },
    enabled: !!user, // Only run query if user exists
    staleTime: 1000 * 60 * 5 // 5 minutes
  })

  const updateUsername = useCallback(
    async (newUsername: string) => {
      if (!user) throw new Error('Not authenticated')

      // Use-case handles validation and normalization via Username value object
      const { error: updateError } = await updateUserProfile.execute({
        userId: user.id,
        username: newUsername
      })

      if (updateError) {
        throw updateError
      }

      // Re-fetch profile to get server-side state
      const { profile: updatedProfile } = await getUserProfile.execute({
        userId: user.id
      })
      if (updatedProfile) {
        // Update React Query cache
        queryClient.setQueryData(['userProfile', user.id], updatedProfile)
      }
    },
    [user, updateUserProfile, getUserProfile, queryClient]
  )

  return {
    profile: profile ?? null,
    loading: isLoading,
    error: error as Error | null,
    updateUsername
  }
}
