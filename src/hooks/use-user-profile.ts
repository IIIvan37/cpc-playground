/**
 * User profile hook
 * Fetches and updates user profile from Supabase
 *
 * Note: This could be migrated to Clean Architecture with:
 * - UserProfile entity in domain/entities
 * - IUserProfilesRepository in domain/repositories
 * - GetUserProfile and UpdateUsername use-cases
 */
import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import type { Database } from '@/types/database.types'
import { useAuth } from './use-auth'

type UserProfileRow = Database['public']['Tables']['user_profiles']['Row']
type UserProfileUpdate = Database['public']['Tables']['user_profiles']['Update']

export interface UserProfile {
  id: string
  username: string
  createdAt: string
  updatedAt: string
}

function mapToUserProfile(row: UserProfileRow): UserProfile {
  return {
    id: row.id,
    username: row.username,
    createdAt: row.created_at,
    updatedAt: row.updated_at
  }
}

export function useUserProfile() {
  const { user } = useAuth()
  const [profile, setProfile] = useState<UserProfile | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

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
        const { data, error } = await supabase
          .from('user_profiles')
          .select('*')
          .eq('id', user.id)
          .maybeSingle()

        if (error) throw error

        // Profile doesn't exist - user might be orphaned after db reset
        if (!data) {
          console.warn(
            'User profile not found. Please sign out and sign in again.'
          )
          setProfile(null)
          return
        }

        setProfile(mapToUserProfile(data))
      } catch (err) {
        setError(
          err instanceof Error ? err : new Error('Failed to fetch profile')
        )
      } finally {
        setLoading(false)
      }
    }

    fetchProfile()
  }, [user])

  const updateUsername = async (newUsername: string) => {
    if (!user) throw new Error('Not authenticated')

    // Normalize username to lowercase
    const normalizedUsername = newUsername.toLowerCase().trim()

    // Validate username format (3-30 chars, lowercase letters, numbers, underscores, hyphens)
    if (normalizedUsername.length < 3 || normalizedUsername.length > 30) {
      throw new Error('Username must be between 3 and 30 characters')
    }
    if (!/^[a-z0-9_-]+$/.test(normalizedUsername)) {
      throw new Error(
        'Username can only contain letters, numbers, underscores and hyphens'
      )
    }

    try {
      const updateData: UserProfileUpdate = {
        username: normalizedUsername,
        updated_at: new Date().toISOString()
      }
      const { error } = await supabase
        .from('user_profiles')
        .update(updateData)
        .eq('id', user.id)

      if (error) {
        console.error('Supabase error:', error)
        throw new Error(error.message || 'Failed to update username')
      }

      setProfile((prev) =>
        prev ? { ...prev, username: normalizedUsername } : null
      )
    } catch (err) {
      throw err instanceof Error ? err : new Error('Failed to update username')
    }
  }

  return {
    profile,
    loading,
    error,
    updateUsername
  }
}
