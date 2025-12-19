import { beforeEach, describe, expect, it, vi } from 'vitest'
import handler, {
  EXPIRY_DAYS,
  generateId,
  type ShareData
} from '../../netlify/functions/share'

// Mock @netlify/blobs
const mockStore = {
  get: vi.fn(),
  setJSON: vi.fn(),
  delete: vi.fn()
}

vi.mock('@netlify/blobs', () => ({
  getStore: vi.fn(() => mockStore)
}))

// Mock context
const mockContext = {} as any

function createRequest(method: string, url: string, body?: object): Request {
  const init: RequestInit = { method }
  if (body) {
    init.body = JSON.stringify(body)
    init.headers = { 'Content-Type': 'application/json' }
  }
  return new Request(url, init)
}

describe('share function', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    mockStore.get.mockResolvedValue(null)
    mockStore.setJSON.mockResolvedValue(undefined)
    mockStore.delete.mockResolvedValue(undefined)
  })

  describe('generateId', () => {
    it('should generate an 8 character ID', () => {
      const id = generateId()
      expect(id).toHaveLength(8)
    })

    it('should only contain valid characters', () => {
      const validChars =
        'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789'
      for (let i = 0; i < 100; i++) {
        const id = generateId()
        for (const char of id) {
          expect(validChars).toContain(char)
        }
      }
    })

    it('should not contain ambiguous characters (0, O, 1, l, I)', () => {
      const ambiguousChars = '01lIO'
      for (let i = 0; i < 100; i++) {
        const id = generateId()
        for (const char of id) {
          expect(ambiguousChars).not.toContain(char)
        }
      }
    })
  })

  describe('OPTIONS request (CORS preflight)', () => {
    it('should return 204 with CORS headers', async () => {
      const request = createRequest('OPTIONS', 'https://example.com/api/share')
      const response = await handler(request, mockContext)

      expect(response.status).toBe(204)
      expect(response.headers.get('Access-Control-Allow-Origin')).toBe('*')
      expect(response.headers.get('Access-Control-Allow-Methods')).toBe(
        'GET, POST, OPTIONS'
      )
    })
  })

  describe('POST request - Create share', () => {
    it('should create a share and return ID', async () => {
      const code = 'ld a, 1\nret'
      const request = createRequest('POST', 'https://example.com/api/share', {
        code
      })

      const response = await handler(request, mockContext)
      const body = await response.json()

      expect(response.status).toBe(201)
      expect(body.id).toBeDefined()
      expect(body.id).toHaveLength(8)
      expect(mockStore.setJSON).toHaveBeenCalledTimes(1)
    })

    it('should store code with expiry metadata', async () => {
      const code = 'org #4000'
      const now = Date.now()
      vi.setSystemTime(now)

      const request = createRequest('POST', 'https://example.com/api/share', {
        code
      })
      await handler(request, mockContext)

      expect(mockStore.setJSON).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({
          code,
          createdAt: now,
          expiresAt: now + EXPIRY_DAYS * 24 * 60 * 60 * 1000
        })
      )

      vi.useRealTimers()
    })

    it('should return 400 if code is missing', async () => {
      const request = createRequest('POST', 'https://example.com/api/share', {})

      const response = await handler(request, mockContext)
      const body = await response.json()

      expect(response.status).toBe(400)
      expect(body.error).toBe('Missing code')
    })

    it('should return 400 if code is not a string', async () => {
      const request = createRequest('POST', 'https://example.com/api/share', {
        code: 123
      })

      const response = await handler(request, mockContext)
      const body = await response.json()

      expect(response.status).toBe(400)
      expect(body.error).toBe('Missing code')
    })

    it('should include CORS headers in response', async () => {
      const request = createRequest('POST', 'https://example.com/api/share', {
        code: 'test'
      })

      const response = await handler(request, mockContext)

      expect(response.headers.get('Access-Control-Allow-Origin')).toBe('*')
    })
  })

  describe('GET request - Retrieve share', () => {
    it('should retrieve shared code by ID', async () => {
      const shareData: ShareData = {
        code: 'ld a, 42',
        createdAt: Date.now(),
        expiresAt: Date.now() + 1000000
      }
      mockStore.get.mockResolvedValue(shareData)

      const request = createRequest(
        'GET',
        'https://example.com/api/share?id=abc123xy'
      )
      const response = await handler(request, mockContext)
      const body = await response.json()

      expect(response.status).toBe(200)
      expect(body.code).toBe('ld a, 42')
    })

    it('should return 400 if id parameter is missing', async () => {
      const request = createRequest('GET', 'https://example.com/api/share')

      const response = await handler(request, mockContext)
      const body = await response.json()

      expect(response.status).toBe(400)
      expect(body.error).toBe('Missing id parameter')
    })

    it('should return 404 if share not found', async () => {
      mockStore.get.mockResolvedValue(null)

      const request = createRequest(
        'GET',
        'https://example.com/api/share?id=notfound'
      )
      const response = await handler(request, mockContext)
      const body = await response.json()

      expect(response.status).toBe(404)
      expect(body.error).toBe('Share not found')
    })

    it('should return 410 if share is expired', async () => {
      const shareData: ShareData = {
        code: 'expired code',
        createdAt: Date.now() - 1000000,
        expiresAt: Date.now() - 1000 // expired
      }
      mockStore.get.mockResolvedValue(shareData)

      const request = createRequest(
        'GET',
        'https://example.com/api/share?id=expiredid'
      )
      const response = await handler(request, mockContext)
      const body = await response.json()

      expect(response.status).toBe(410)
      expect(body.error).toBe('Share expired')
      expect(mockStore.delete).toHaveBeenCalledWith('expiredid')
    })

    it('should include CORS headers in response', async () => {
      mockStore.get.mockResolvedValue(null)

      const request = createRequest(
        'GET',
        'https://example.com/api/share?id=test'
      )
      const response = await handler(request, mockContext)

      expect(response.headers.get('Access-Control-Allow-Origin')).toBe('*')
    })
  })

  describe('Invalid methods', () => {
    it('should return 405 for PUT request', async () => {
      const request = createRequest('PUT', 'https://example.com/api/share')

      const response = await handler(request, mockContext)
      const body = await response.json()

      expect(response.status).toBe(405)
      expect(body.error).toBe('Method not allowed')
    })

    it('should return 405 for DELETE request', async () => {
      const request = createRequest('DELETE', 'https://example.com/api/share')

      const response = await handler(request, mockContext)
      const body = await response.json()

      expect(response.status).toBe(405)
      expect(body.error).toBe('Method not allowed')
    })
  })
})
