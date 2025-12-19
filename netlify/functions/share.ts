import { getStore } from '@netlify/blobs'
import type { Context } from '@netlify/functions'

export const STORE_NAME = 'shared-code'
export const EXPIRY_DAYS = 7

// Generate a random ID (exported for testing)
export function generateId(): string {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789'
  let id = ''
  for (let i = 0; i < 8; i++) {
    id += chars.charAt(Math.floor(Math.random() * chars.length))
  }
  return id
}

// CORS headers
export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type'
}

export interface ShareData {
  code: string
  createdAt: number
  expiresAt: number
}

export default async (request: Request, _context: Context) => {
  const store = getStore(STORE_NAME)

  // Handle preflight
  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: corsHeaders })
  }

  // POST - Create a new share
  if (request.method === 'POST') {
    try {
      const body = await request.json()
      const { code } = body

      if (!code || typeof code !== 'string') {
        return new Response(JSON.stringify({ error: 'Missing code' }), {
          status: 400,
          headers: { 'Content-Type': 'application/json', ...corsHeaders }
        })
      }

      // Generate unique ID
      let id = generateId()
      let attempts = 0
      while (attempts < 10) {
        const existing = await store.get(id)
        if (!existing) break
        id = generateId()
        attempts++
      }

      // Store with metadata
      const data: ShareData = {
        code,
        createdAt: Date.now(),
        expiresAt: Date.now() + EXPIRY_DAYS * 24 * 60 * 60 * 1000
      }

      await store.setJSON(id, data)

      return new Response(JSON.stringify({ id }), {
        status: 201,
        headers: { 'Content-Type': 'application/json', ...corsHeaders }
      })
    } catch (error) {
      console.error('Error creating share:', error)
      return new Response(JSON.stringify({ error: 'Failed to create share' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json', ...corsHeaders }
      })
    }
  }

  // GET - Retrieve a share
  if (request.method === 'GET') {
    const url = new URL(request.url)
    const id = url.searchParams.get('id')

    if (!id) {
      return new Response(JSON.stringify({ error: 'Missing id parameter' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json', ...corsHeaders }
      })
    }

    try {
      const data = (await store.get(id, { type: 'json' })) as ShareData | null

      if (!data) {
        return new Response(JSON.stringify({ error: 'Share not found' }), {
          status: 404,
          headers: { 'Content-Type': 'application/json', ...corsHeaders }
        })
      }

      // Check expiry
      if (data.expiresAt && Date.now() > data.expiresAt) {
        await store.delete(id)
        return new Response(JSON.stringify({ error: 'Share expired' }), {
          status: 410,
          headers: { 'Content-Type': 'application/json', ...corsHeaders }
        })
      }

      return new Response(JSON.stringify({ code: data.code }), {
        status: 200,
        headers: { 'Content-Type': 'application/json', ...corsHeaders }
      })
    } catch (error) {
      console.error('Error retrieving share:', error)
      return new Response(
        JSON.stringify({ error: 'Failed to retrieve share' }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json', ...corsHeaders }
        }
      )
    }
  }

  return new Response(JSON.stringify({ error: 'Method not allowed' }), {
    status: 405,
    headers: { 'Content-Type': 'application/json', ...corsHeaders }
  })
}
