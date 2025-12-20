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
      try {
        setLoading(true)
        const { data, error } = await supabase
          .from('user_profiles')
          .select('*')
          .eq('id', user.id)
          .single()

        if (error) throw error

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

    try {
      const { error } = await supabase
        .from('user_profiles')
        .update({ username: newUsername })
        .eq('id', user.id)

      if (error) throw error

      setProfile((prev) => (prev ? { ...prev, username: newUsername } : null))
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
