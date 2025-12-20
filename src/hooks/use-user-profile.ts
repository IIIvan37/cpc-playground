// TODO: Remove @ts-nocheck - Migrate to Clean Architecture use-cases instead of direct Supabase calls
// This file will be replaced by use-cases/users/* once user management is migrated
// @ts-nocheck
import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import { useAuth } from './use-auth'

export interface UserProfile {
  id: string
  username: string
  createdAt: string
  updatedAt: string
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
          .single()

        if (error) throw error
        if (!data) throw new Error('Profile not found')

        setProfile({
          id: data.id,
          username: data.username,
          createdAt: data.created_at,
          updatedAt: data.updated_at
        })
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
      const { error } = await supabase
        .from('user_profiles')
        .update({
          username: normalizedUsername,
          updated_at: new Date().toISOString()
        } as const)
        .eq('id', user.id)
        .select()

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
