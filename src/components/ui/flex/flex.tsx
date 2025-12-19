import type { CSSProperties, ReactNode } from 'react'
import { memo } from 'react'

const Flex = ({
  children,
  direction = 'row',
  gap = 'var(--spacing-sm)',
  align = 'center',
  justify = 'flex-start',
  wrap = 'nowrap',
  style
}: {
  readonly children: ReactNode
  readonly direction?: 'row' | 'row-reverse' | 'column' | 'column-reverse'
  readonly gap?: CSSProperties['gap']
  readonly align?: 'flex-start' | 'flex-end' | 'center' | 'stretch' | 'baseline'
  readonly justify?:
    | 'flex-start'
    | 'flex-end'
    | 'center'
    | 'space-between'
    | 'space-around'
    | 'space-evenly'
  readonly wrap?: 'nowrap' | 'wrap' | 'wrap-reverse'
  readonly style?: CSSProperties
}) => {
  return (
    <div
      style={{
        display: 'flex',
        flexDirection: direction,
        gap,
        alignItems: align,
        justifyContent: justify,
        flexWrap: wrap,
        ...style
      }}
    >
      {children}
    </div>
  )
}

Flex.displayName = 'Flex'

export default memo(Flex)
