import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'
import Flex from './flex'

describe('Flex', () => {
  describe('rendering', () => {
    it('renders children', () => {
      render(
        <Flex>
          <span>Child 1</span>
          <span>Child 2</span>
        </Flex>
      )
      expect(screen.getByText('Child 1')).toBeInTheDocument()
      expect(screen.getByText('Child 2')).toBeInTheDocument()
    })

    it('renders a div element', () => {
      render(<Flex>Content</Flex>)
      expect(screen.getByText('Content').tagName).toBe('DIV')
    })
  })

  describe('default styles', () => {
    it('applies display flex', () => {
      render(<Flex>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({ display: 'flex' })
    })

    it('applies row direction by default', () => {
      render(<Flex>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({ flexDirection: 'row' })
    })

    it('applies center alignment by default', () => {
      render(<Flex>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({ alignItems: 'center' })
    })

    it('applies flex-start justify by default', () => {
      render(<Flex>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        justifyContent: 'flex-start'
      })
    })

    it('applies nowrap by default', () => {
      render(<Flex>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({ flexWrap: 'nowrap' })
    })
  })

  describe('direction prop', () => {
    it('applies column direction', () => {
      render(<Flex direction='column'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        flexDirection: 'column'
      })
    })

    it('applies row-reverse direction', () => {
      render(<Flex direction='row-reverse'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        flexDirection: 'row-reverse'
      })
    })

    it('applies column-reverse direction', () => {
      render(<Flex direction='column-reverse'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        flexDirection: 'column-reverse'
      })
    })
  })

  describe('align prop', () => {
    it('applies flex-start alignment', () => {
      render(<Flex align='flex-start'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        alignItems: 'flex-start'
      })
    })

    it('applies flex-end alignment', () => {
      render(<Flex align='flex-end'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        alignItems: 'flex-end'
      })
    })

    it('applies stretch alignment', () => {
      render(<Flex align='stretch'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        alignItems: 'stretch'
      })
    })

    it('applies baseline alignment', () => {
      render(<Flex align='baseline'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        alignItems: 'baseline'
      })
    })
  })

  describe('justify prop', () => {
    it('applies flex-end justification', () => {
      render(<Flex justify='flex-end'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        justifyContent: 'flex-end'
      })
    })

    it('applies center justification', () => {
      render(<Flex justify='center'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        justifyContent: 'center'
      })
    })

    it('applies space-between justification', () => {
      render(<Flex justify='space-between'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        justifyContent: 'space-between'
      })
    })

    it('applies space-around justification', () => {
      render(<Flex justify='space-around'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        justifyContent: 'space-around'
      })
    })

    it('applies space-evenly justification', () => {
      render(<Flex justify='space-evenly'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        justifyContent: 'space-evenly'
      })
    })
  })

  describe('wrap prop', () => {
    it('applies wrap', () => {
      render(<Flex wrap='wrap'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({ flexWrap: 'wrap' })
    })

    it('applies wrap-reverse', () => {
      render(<Flex wrap='wrap-reverse'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({
        flexWrap: 'wrap-reverse'
      })
    })
  })

  describe('gap prop', () => {
    it('applies custom gap', () => {
      render(<Flex gap='20px'>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({ gap: '20px' })
    })

    it('applies numeric gap', () => {
      render(<Flex gap={16}>Content</Flex>)
      expect(screen.getByText('Content')).toHaveStyle({ gap: '16px' })
    })
  })

  describe('style prop', () => {
    it('merges custom styles with flex defaults', () => {
      render(<Flex style={{ padding: '10px' }}>Content</Flex>)
      const element = screen.getByText('Content')
      expect(element).toHaveStyle({ display: 'flex', padding: '10px' })
    })

    it('merges custom margin', () => {
      render(<Flex style={{ margin: '20px' }}>Content</Flex>)
      const element = screen.getByText('Content')
      expect(element).toHaveStyle({ margin: '20px' })
    })
  })
})
