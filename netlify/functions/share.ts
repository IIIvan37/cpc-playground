import type { Store } from '@netlify/blobs'
import { getStore } from '@netlify/blobs'
import type { Context } from '@netlify/functions'
import { nanoid } from 'nanoid'

export const STORE_NAME = 'shared-code'
export const EXPIRY_DAYS = 7
export const SHARE_ID_LENGTH = 8

// Allowed origins for CORS
const ALLOWED_ORIGINS = [
  'https://cpc-playground.iiivan.org',
  'https://pixsaur.iiivan.org',
  'http://localhost:5173',
  'http://localhost:5174',
  'http://localhost:5175',
  'http://localhost:4173'
]

// Get CORS headers based on request origin
function getCorsHeaders(request: Request): Record<string, string> {
  const origin = request.headers.get('origin') || ''
  const allowedOrigin = ALLOWED_ORIGINS.includes(origin)
    ? origin
    : ALLOWED_ORIGINS[0]

  return {
    'Access-Control-Allow-Origin': allowedOrigin,
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Credentials': 'true'
  }
}

export interface ShareData {
  code: string
  createdAt: number
  expiresAt: number
}

// Helper to create JSON responses
function jsonResponse(
  body: Record<string, unknown>,
  status: number,
  request: Request
): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...getCorsHeaders(request) }
  })
}

// Generate a unique ID that doesn't exist in the store
async function generateUniqueId(store: Store): Promise<string> {
  let id = nanoid(SHARE_ID_LENGTH)
  let attempts = 0
  while (attempts < 10) {
    const existing = await store.get(id)
    if (!existing) break
    id = nanoid(SHARE_ID_LENGTH)
    attempts++
  }
  return id
}

// POST handler - Create a new share
async function handlePost(request: Request, store: Store): Promise<Response> {
  try {
    const body = await request.json()
    const { code } = body

    if (!code || typeof code !== 'string') {
      return jsonResponse({ error: 'Missing code' }, 400, request)
    }

    const id = await generateUniqueId(store)
    const data: ShareData = {
      code,
      createdAt: Date.now(),
      expiresAt: Date.now() + EXPIRY_DAYS * 24 * 60 * 60 * 1000
    }

    await store.setJSON(id, data)
    return jsonResponse({ id }, 201, request)
  } catch (error) {
    console.error('Error creating share:', error)
    return jsonResponse(
      { error: 'Failed to create share', details: String(error) },
      500,
      request
    )
  }
}

// GET handler - Retrieve a share
async function handleGet(request: Request, store: Store): Promise<Response> {
  const url = new URL(request.url)
  const id = url.searchParams.get('id')

  if (!id) {
    return jsonResponse({ error: 'Missing id parameter' }, 400, request)
  }

  try {
    const data = (await store.get(id, { type: 'json' })) as ShareData | null

    if (!data) {
      return jsonResponse({ error: 'Share not found' }, 404, request)
    }

    if (data.expiresAt && Date.now() > data.expiresAt) {
      await store.delete(id)
      return jsonResponse({ error: 'Share expired' }, 410, request)
    }

    return jsonResponse({ code: data.code }, 200, request)
  } catch (error) {
    console.error('Error retrieving share:', error)
    return jsonResponse(
      { error: 'Failed to retrieve share', details: String(error) },
      500,
      request
    )
  }
}

async function handler(request: Request, _context: Context) {
  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: getCorsHeaders(request) })
  }

  const store = getStore({ name: STORE_NAME, consistency: 'strong' })

  if (request.method === 'POST') {
    return handlePost(request, store)
  }

  if (request.method === 'GET') {
    return handleGet(request, store)
  }

  return jsonResponse({ error: 'Method not allowed' }, 405, request)
}

export default handler
