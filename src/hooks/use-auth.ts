import type { User } from '@supabase/supabase-js'
import { useAtom } from 'jotai'
import { atomWithStorage } from 'jotai/utils'
import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'

// Auth state atom
export const userAtom = atomWithStorage<User | null>('supabase-user', null)

export function useAuth() {
  const [user, setUser] = useAtom(userAtom)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Get initial session
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null)
      setLoading(false)
    })

    // Listen for auth changes
    const {
      data: { subscription }
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null)
    })

    return () => subscription.unsubscribe()
  }, [setUser])

  const signIn = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    })
    return { data, error }
  }

  const signUp = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signUp({
      email,
      password
    })
    return { data, error }
  }

  const signOut = async () => {
    try {
      const { error } = await supabase.auth.signOut({ scope: 'local' })
      // Ignore 403 errors as the session is already invalid
      if (error && !error.message.includes('403')) {
        return { error }
      }
      return { error: null }
    } catch (e) {
      // Ignore network errors, session will be cleared locally anyway
      console.warn('SignOut error (ignored):', e)
      return { error: null }
    }
  }

  const signInWithGithub = async () => {
    const { data, error } = await supabase.auth.signInWithOAuth({
      provider: 'github',
      options: {
        redirectTo: window.location.origin
      }
    })
    return { data, error }
  }

  return {
    user,
    loading,
    signIn,
    signUp,
    signOut,
    signInWithGithub
  }
}
