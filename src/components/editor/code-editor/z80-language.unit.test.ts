import { describe, expect, it } from 'vitest'

// Utilitaire minimal pour simuler un StringStream
class FakeStream {
  private str: string
  private pos = 0
  constructor(str: string) {
    this.str = str
  }
  match(pattern: RegExp | string) {
    const input = this.str.slice(this.pos)
    if (typeof pattern === 'string') {
      if (input.startsWith(pattern)) {
        this.pos += pattern.length
        return true
      }
      return false
    }
    const m = pattern.exec(input)
    if (m?.index === 0) {
      this.pos += m[0].length
      return true
    }
    return false
  }
  next() {
    return this.str[this.pos++] || undefined
  }
  peek() {
    return this.str[this.pos] || undefined
  }
  eol() {
    return this.pos >= this.str.length
  }
  eatSpace() {
    const m = /^\s+/.exec(this.str.slice(this.pos))
    if (m) {
      this.pos += m[0].length
      return true
    }
    return false
  }
  sol() {
    return this.pos === 0
  }
  skipToEnd() {
    this.pos = this.str.length
  }
  current() {
    return this.str.slice(0, this.pos)
  }
}

// Importe la fonction à tester
import { z80Mode } from './z80-language'

describe('z80Mode.token', () => {
  const mode = z80Mode()
  function tokenType(line: string) {
    const stream = new FakeStream(line)
    const state = mode.startState()
    // @ts-expect-error FakeStream n'est pas typé comme StringStream
    return mode.token(stream, state)
  }

  it('reconnaît une instruction Z80 comme keyword', () => {
    expect(tokenType('ld')).toBe('keyword')
    expect(tokenType('ADD')).toBe('keyword')
  })

  it('reconnaît un registre comme variableName', () => {
    expect(tokenType('hl')).toBe('variableName')
    expect(tokenType("AF' ")).toBe('variableName')
  })

  it('reconnaît un commentaire', () => {
    expect(tokenType('; comment')).toBe('comment')
    expect(tokenType('// comment')).toBe('comment')
  })

  it('reconnaît un nombre hexadécimal', () => {
    expect(tokenType('#FF')).toBe('number')
    expect(tokenType('$1A')).toBe('number')
    expect(tokenType('0x2B')).toBe('number')
    expect(tokenType('&3C')).toBe('number')
    expect(tokenType('1Ah')).toBe('number')
  })

  it('reconnaît un label', () => {
    expect(tokenType('start:')).toBe('labelName')
    expect(tokenType('@local')).toBe('labelName')
    expect(tokenType('.label')).toBe('labelName')
  })

  it('reconnaît une chaîne de caractères', () => {
    expect(tokenType('"abc"')).toBe('string')
    expect(tokenType("'abc'")).toBe('string')
  })

  it('reconnaît une ponctuation', () => {
    expect(tokenType(',')).toBe('punctuation')
    expect(tokenType(':')).toBe('punctuation')
  })

  it('reconnaît un opérateur', () => {
    expect(tokenType('+')).toBe('operator')
    expect(tokenType('-')).toBe('operator')
    expect(tokenType('|')).toBe('operator')
  })
})
