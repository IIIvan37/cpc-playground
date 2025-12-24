/**
 * User profile hook
 * Uses Clean Architecture use-cases for profile management
 */
import { useCallback, useEffect, useState } from 'react'
import type { UserProfile } from '@/domain/entities/user.entity'
import { container } from '@/infrastructure/container'
import { useAuth } from '../auth'

export type { UserProfile } from '@/domain/entities/user.entity'

export function useUserProfile() {
  const { user } = useAuth()
  const [profile, setProfile] = useState<UserProfile | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  const { getUserProfile, updateUserProfile } = container

  useEffect(() => {
    if (!user) {
      setProfile(null)
      setLoading(false)
      return
    }

    async function fetchProfile() {
      if (!user) return
      try {
        setLoading(true)
        const { profile: fetchedProfile } = await getUserProfile.execute({
          userId: user.id
        })

        if (!fetchedProfile) {
          console.warn(
            'User profile not found. Please sign out and sign in again.'
          )
          setProfile(null)
          return
        }

        setProfile(fetchedProfile)
      } catch (err) {
        setError(
          err instanceof Error ? err : new Error('Failed to fetch profile')
        )
      } finally {
        setLoading(false)
      }
    }

    fetchProfile()
  }, [user, getUserProfile])

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
        setProfile(updatedProfile)
      }
    },
    [user, updateUserProfile, getUserProfile]
  )

  return {
    profile,
    loading,
    error,
    updateUsername
  }
}
