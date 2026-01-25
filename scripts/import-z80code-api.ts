#!/usr/bin/env npx tsx
/**
 * Import z80code projects via Supabase API
 * Run with: npx tsx scripts/import-z80code-api.ts
 *
 * Requires SUPABASE_SERVICE_ROLE_KEY env variable
 */

import { createClient } from '@supabase/supabase-js'
import * as fs from 'fs'
import * as readline from 'readline'

// Configuration
const SUPABASE_URL =
  process.env.SUPABASE_URL || 'https://aameevxocpvxpifmrwia.supabase.co'
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!SUPABASE_SERVICE_KEY) {
  console.error(
    'Error: SUPABASE_SERVICE_ROLE_KEY environment variable is required'
  )
  console.error(
    'Get it from Supabase Dashboard > Settings > API > service_role key'
  )
  process.exit(1)
}

const OWNER_USER_ID = 'bd6a166d-e0bf-4374-94c3-5222e517d75c'
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

function timestampToDate(ts: number | undefined): string {
  if (!ts) return new Date().toISOString()
  try {
    return new Date(ts).toISOString()
  } catch {
    return new Date().toISOString()
  }
}

async function ensureTagExists(tagName: string): Promise<string | null> {
  // Check if tag exists
  const { data: existing } = await supabase
    .from('tags')
    .select('id')
    .eq('name', tagName)
    .single()

  if (existing) return existing.id

  // Create tag
  const { data: created, error } = await supabase
    .from('tags')
    .insert({ name: tagName })
    .select('id')
    .single()

  if (error) {
    console.error(
      `  Warning: Could not create tag "${tagName}":`,
      error.message
    )
    return null
  }
  return created?.id || null
}

async function importProject(
  project: Z80Project,
  index: number,
  total: number
): Promise<boolean> {
  const name = project.slugname || project.name || 'Untitled'
  const author = project.author || 'Unknown'
  const code = project.code || ''

  // Build description
  const descParts = [`Imported from z80Code. Author: ${author}.`]
  if (project.desc) descParts.push(project.desc)
  const description = descParts.join(' ')

  const createdAt = timestampToDate(project.date)
  const updatedAt = timestampToDate(project.timestamp || project.date)

  console.log(`[${index + 1}/${total}] Importing: ${name} by ${author}`)

  try {
    // 1. Create project
    const { data: projectData, error: projectError } = await supabase
      .from('projects')
      .insert({
        user_id: OWNER_USER_ID,
        name,
        description,
        visibility: 'public',
        is_library: false,
        is_sticky: false,
        created_at: createdAt,
        updated_at: updatedAt
      })
      .select('id')
      .single()

    if (projectError) {
      console.error(`  Error creating project: ${projectError.message}`)
      return false
    }

    const projectId = projectData.id

    // 2. Create main file
    const { error: fileError } = await supabase.from('project_files').insert({
      project_id: projectId,
      name: 'main.asm',
      content: code,
      is_main: true,
      order: 0,
      created_at: createdAt,
      updated_at: updatedAt
    })

    if (fileError) {
      console.error(`  Error creating file: ${fileError.message}`)
      // Rollback project
      await supabase.from('projects').delete().eq('id', projectId)
      return false
    }

    // 3. Add tags
    const tagNames = ['z80code']
    const catTag = normalizeTag(project.cat || '')
    if (catTag && catTag !== 'z80code') tagNames.push(catTag)

    for (const tagName of tagNames) {
      const tagId = await ensureTagExists(tagName)
      if (tagId) {
        await supabase
          .from('project_tags')
          .insert({ project_id: projectId, tag_id: tagId })
          .select()
      }
    }

    console.log(`  ✓ Created project ${projectId}`)
    return true
  } catch (err) {
    console.error(`  Exception: ${err}`)
    return false
  }
}

async function main() {
  console.log('Starting z80code import via API...')
  console.log(`Reading from ${INPUT_FILE}`)

  // Check if z80code tag exists, create if not
  await ensureTagExists('z80code')

  const fileStream = fs.createReadStream(INPUT_FILE)
  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity
  })

  const projects: Z80Project[] = []

  for await (const line of rl) {
    if (!line.trim()) continue
    try {
      const obj = JSON.parse(line) as Z80Project

      // Filter: only public group
      if (obj.group !== 'public') continue

      // Filter: exclude sjasmplus
      if (obj.buildOptions?.assembler === 'sjasmplus') continue

      // Filter: has code
      if (!obj.code?.trim()) continue

      projects.push(obj)
    } catch {
      // Skip invalid JSON
    }
  }

  console.log(`Found ${projects.length} projects to import`)

  let success = 0
  let failed = 0

  for (let i = 0; i < projects.length; i++) {
    const result = await importProject(projects[i], i, projects.length)
    if (result) {
      success++
    } else {
      failed++
    }

    // Small delay to avoid rate limiting
    await new Promise((resolve) => setTimeout(resolve, 100))
  }

  console.log('\n=== Import Complete ===')
  console.log(`Success: ${success}`)
  console.log(`Failed: ${failed}`)
  console.log(`Total: ${projects.length}`)
}

main().catch(console.error)
