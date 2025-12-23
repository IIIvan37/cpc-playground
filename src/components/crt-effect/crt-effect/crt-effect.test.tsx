import { render } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import { CrtEffect } from './crt-effect'
import styles from './crt-effect.module.css'

describe('CrtEffect', () => {
  it('renders container', () => {
    const { container } = render(<CrtEffect />)
    expect(container.querySelector(`.${styles.container}`)).toBeInTheDocument()
  })

  it('renders scanlines overlay', () => {
    const { container } = render(<CrtEffect />)
    expect(container.querySelector(`.${styles.scanlines}`)).toBeInTheDocument()
  })

  it('renders both container and scanlines as divs', () => {
    const { container } = render(<CrtEffect />)
    const containerEl = container.querySelector(`.${styles.container}`)
    const scanlinesEl = container.querySelector(`.${styles.scanlines}`)

    expect(containerEl?.tagName).toBe('DIV')
    expect(scanlinesEl?.tagName).toBe('DIV')
  })

  it('scanlines is child of container', () => {
    const { container } = render(<CrtEffect />)
    const containerEl = container.querySelector(`.${styles.container}`)
    const scanlinesEl = containerEl?.querySelector(`.${styles.scanlines}`)

    expect(scanlinesEl).toBeInTheDocument()
  })
})
