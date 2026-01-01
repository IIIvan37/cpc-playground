import type { Store } from '@netlify/blobs'
import { getStore } from '@netlify/blobs'
import type { Context } from '@netlify/functions'
import { nanoid } from 'nanoid'

export const STORE_NAME = 'shared-code'
export const RATE_LIMIT_STORE = 'rate-limits'
export const EXPIRY_MINUTES = 5 // Shares expire after 5 minutes
export const SHARE_ID_LENGTH = 8

// Rate limiting configuration
export const RATE_LIMITS = {
  POST: { requests: 10, windowMs: 60 * 60 * 1000 }, // 10 POST per hour
  GET: { requests: 100, windowMs: 60 * 60 * 1000 } // 100 GET per hour
}

// Get CORS headers for public API
function getCorsHeaders(): Record<string, string> {
  return {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
  }
}

export interface ShareData {
  code: string
  createdAt: number
  expiresAt: number
}

// Rate limiting data structure
interface RateLimitData {
  count: number
  resetAt: number
}

// Check rate limit for a request
async function checkRateLimit(
  request: Request,
  method: 'GET' | 'POST',
  rateLimitStore: Store
): Promise<{ allowed: boolean; remaining: number; resetAt: number }> {
  // Get client IP from request headers
  const ip =
    request.headers.get('x-forwarded-for')?.split(',')[0] ||
    request.headers.get('x-real-ip') ||
    'unknown'

  const limit = RATE_LIMITS[method]
  const key = `${ip}:${method}`
  const now = Date.now()

  // Get current rate limit data
  const data = (await rateLimitStore.get(key, {
    type: 'json'
  })) as RateLimitData | null

  // If no data or expired, reset
  if (!data || data.resetAt < now) {
    const newData: RateLimitData = {
      count: 1,
      resetAt: now + limit.windowMs
    }
    await rateLimitStore.setJSON(key, newData, {
      metadata: { ttl: Math.floor(limit.windowMs / 1000) }
    })
    return {
      allowed: true,
      remaining: limit.requests - 1,
      resetAt: newData.resetAt
    }
  }

  // Check if limit exceeded
  if (data.count >= limit.requests) {
    return {
      allowed: false,
      remaining: 0,
      resetAt: data.resetAt
    }
  }

  // Increment count
  data.count++
  await rateLimitStore.setJSON(key, data, {
    metadata: { ttl: Math.floor((data.resetAt - now) / 1000) }
  })

  return {
    allowed: true,
    remaining: limit.requests - data.count,
    resetAt: data.resetAt
  }
}

// Helper to create JSON responses
function jsonResponse(body: Record<string, unknown>, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...getCorsHeaders() }
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
async function handlePost(
  request: Request,
  store: Store,
  rateLimitStore: Store
): Promise<Response> {
  // Check rate limit
  const rateLimit = await checkRateLimit(request, 'POST', rateLimitStore)

  if (!rateLimit.allowed) {
    const retryAfter = Math.ceil((rateLimit.resetAt - Date.now()) / 1000)
    return new Response(
      JSON.stringify({
        error: 'Too many requests',
        retryAfter
      }),
      {
        status: 429,
        headers: {
          'Content-Type': 'application/json',
          'Retry-After': String(retryAfter),
          'X-RateLimit-Limit': String(RATE_LIMITS.POST.requests),
          'X-RateLimit-Remaining': '0',
          'X-RateLimit-Reset': String(Math.floor(rateLimit.resetAt / 1000)),
          ...getCorsHeaders()
        }
      }
    )
  }

  try {
    const body = await request.json()
    const { code } = body

    if (!code || typeof code !== 'string') {
      return jsonResponse({ error: 'Missing code' }, 400)
    }

    const id = await generateUniqueId(store)
    const data: ShareData = {
      code,
      createdAt: Date.now(),
      expiresAt: Date.now() + EXPIRY_MINUTES * 60 * 1000
    }

    await store.setJSON(id, data)

    // Add rate limit headers to successful response
    return new Response(JSON.stringify({ id }), {
      status: 201,
      headers: {
        'Content-Type': 'application/json',
        'X-RateLimit-Limit': String(RATE_LIMITS.POST.requests),
        'X-RateLimit-Remaining': String(rateLimit.remaining),
        'X-RateLimit-Reset': String(Math.floor(rateLimit.resetAt / 1000)),
        ...getCorsHeaders()
      }
    })
  } catch (error) {
    console.error('Error creating share:', error)
    return jsonResponse(
      { error: 'Failed to create share', details: String(error) },
      500
    )
  }
}

// GET handler - Retrieve a share
async function handleGet(
  request: Request,
  store: Store,
  rateLimitStore: Store
): Promise<Response> {
  const url = new URL(request.url)
  const id = url.searchParams.get('id')

  if (!id) {
    return jsonResponse({ error: 'Missing id parameter' }, 400)
  }

  // Check rate limit
  const rateLimit = await checkRateLimit(request, 'GET', rateLimitStore)

  if (!rateLimit.allowed) {
    const retryAfter = Math.ceil((rateLimit.resetAt - Date.now()) / 1000)
    return new Response(
      JSON.stringify({
        error: 'Too many requests',
        retryAfter
      }),
      {
        status: 429,
        headers: {
          'Content-Type': 'application/json',
          'Retry-After': String(retryAfter),
          'X-RateLimit-Limit': String(RATE_LIMITS.GET.requests),
          'X-RateLimit-Remaining': '0',
          'X-RateLimit-Reset': String(Math.floor(rateLimit.resetAt / 1000)),
          ...getCorsHeaders()
        }
      }
    )
  }

  try {
    const data = (await store.get(id, { type: 'json' })) as ShareData | null

    if (!data) {
      return jsonResponse({ error: 'Share not found' }, 404)
    }

    if (data.expiresAt && Date.now() > data.expiresAt) {
      await store.delete(id)
      return jsonResponse({ error: 'Share expired' }, 410)
    }

    // Add rate limit headers to successful response
    return new Response(JSON.stringify({ code: data.code }), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'X-RateLimit-Limit': String(RATE_LIMITS.GET.requests),
        'X-RateLimit-Remaining': String(rateLimit.remaining),
        'X-RateLimit-Reset': String(Math.floor(rateLimit.resetAt / 1000)),
        ...getCorsHeaders()
      }
    })
  } catch (error) {
    console.error('Error retrieving share:', error)
    return jsonResponse(
      { error: 'Failed to retrieve share', details: String(error) },
      500
    )
  }
}

async function handler(request: Request, _context: Context) {
  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: getCorsHeaders() })
  }

  const store = getStore({ name: STORE_NAME, consistency: 'strong' })
  const rateLimitStore = getStore({
    name: RATE_LIMIT_STORE,
    consistency: 'strong'
  })

  if (request.method === 'POST') {
    return handlePost(request, store, rateLimitStore)
  }

  if (request.method === 'GET') {
    return handleGet(request, store, rateLimitStore)
  }

  return jsonResponse({ error: 'Method not allowed' }, 405)
}

export default handler
