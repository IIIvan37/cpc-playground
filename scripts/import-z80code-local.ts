#!/usr/bin/env npx tsx
/**
 * Import z80code projects to LOCAL Supabase
 * Run with: npx tsx scripts/import-z80code-local.ts
 */

import { createClient } from '@supabase/supabase-js'
import * as fs from 'fs'
import * as readline from 'readline'

// Local Supabase configuration
const SUPABASE_URL = 'http://127.0.0.1:54321'
const SUPABASE_SERVICE_KEY =
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU'

const INPUT_FILE = 'z80code.json'

// Create Supabase client with service role key (bypasses RLS)
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
  auth: { persistSession: false }
})

interface Z80Project {
  _id: { $oid: string }
  name: string
  slugname?: string
  code: string
  author?: string
  desc?: string
  cat?: string
  group?: string
  date?: number
  timestamp?: number
  buildOptions?: { assembler?: string }
}

function normalizeTag(cat: string): string | null {
  if (!cat) return null
  let tag = cat.toLowerCase().trim()
  tag = tag.replace(/[^a-z0-9\s-]/g, '')
  tag = tag.replace(/[\s]+/g, '-')
  tag = tag.replace(/-+/g, '-')
  tag = tag.trim().replace(/^-|-$/g, '')
  if (tag.length < 2 || tag.length > 30) return null
  return tag
}

async function ensureZ80CodeUser(): Promise<string> {
  // Check if z80code user exists
  const { data: existingUser } = await supabase
    .from('user_profiles')
    .select('id')
    .eq('username', 'z80code')
    .single()

  if (existingUser) {
    console.log('Using existing z80code user:', existingUser.id)
    return existingUser.id
  }

  // Create auth user first
  const { data: authData, error: authError } =
    await supabase.auth.admin.createUser({
      email: 'z80code@example.com',
      password: 'z80code-import-user-2024',
      email_confirm: true,
      user_metadata: { username: 'z80code' }
    })

  if (authError) {
    throw new Error(`Failed to create auth user: ${authError.message}`)
  }

  const userId = authData.user!.id
  console.log('Created z80code user:', userId)

  // Create user profile
  const { error: profileError } = await supabase.from('user_profiles').insert({
    id: userId,
    username: 'z80code',
    bio: 'Imported projects from z80code.com',
    avatar_url: null
  })

  if (profileError) {
    console.warn('Profile creation warning:', profileError.message)
  }

  return userId
}

async function importProjects() {
  console.log('Starting z80code import to LOCAL Supabase...')
  console.log('Reading:', INPUT_FILE)

  if (!fs.existsSync(INPUT_FILE)) {
    console.error(`File not found: ${INPUT_FILE}`)
    process.exit(1)
  }

  const ownerUserId = await ensureZ80CodeUser()
  console.log('Owner user ID:', ownerUserId)

  const fileStream = fs.createReadStream(INPUT_FILE)
  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity
  })

  let imported = 0
  let skipped = 0
  let errors = 0

  for await (const line of rl) {
    if (!line.trim()) continue

    try {
      const z80: Z80Project = JSON.parse(line)

      // Create project
      const { data: project, error: projectError } = await supabase
        .from('projects')
        .insert({
          user_id: ownerUserId,
          name: z80.name.substring(0, 100),
          description: z80.desc?.substring(0, 500) || null,
          visibility: 'public',
          is_library: false,
          is_sticky: false
        })
        .select('id')
        .single()

      if (projectError) {
        if (projectError.code === '23505') {
          skipped++
          continue
        }
        throw projectError
      }

      // Create main file
      const { error: fileError } = await supabase.from('project_files').insert({
        project_id: project.id,
        name: 'main.asm',
        content: z80.code,
        is_main: true
      })

      if (fileError) {
        console.error(`File error for ${z80.name}:`, fileError.message)
      }

      // Add tag if category exists
      const tag = normalizeTag(z80.cat || '')
      if (tag) {
        await supabase.from('project_tags').insert({
          project_id: project.id,
          tag
        })
      }

      imported++
      if (imported % 20 === 0) {
        console.log(
          `Progress: ${imported} imported, ${skipped} skipped, ${errors} errors`
        )
      }
    } catch (err) {
      errors++
      console.error('Error:', err)
    }
  }

  console.log('\n=== Import Complete ===')
  console.log(`Imported: ${imported}`)
  console.log(`Skipped: ${skipped}`)
  console.log(`Errors: ${errors}`)
}

importProjects().catch(console.error)
