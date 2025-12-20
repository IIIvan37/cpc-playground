import { Slot } from '@radix-ui/react-slot'
import clsx from 'clsx'
import type { ButtonHTMLAttributes, ReactNode } from 'react'
import styles from './button.module.css'

type Variant = 'primary' | 'secondary' | 'icon' | 'outline' | 'ghost'

type Props = {
  children: ReactNode
  asChild?: boolean
  variant?: Variant
  size?: 'sm' | 'md'
  fullWidth?: boolean
  className?: string
} & ButtonHTMLAttributes<HTMLButtonElement>

export default function Button({
  children,
  asChild = false,
  variant = 'primary',
  size = 'md',
  fullWidth = false,
  className = '',
  disabled,
  ...props
}: Props) {
  const Comp = asChild ? Slot : 'button'

  return (
    <Comp
      className={clsx(
        styles.button,
        styles[variant],
        size === 'sm' && styles.small,
        fullWidth && styles.fullWidth,
        disabled && styles.disabled,
        className
      )}
      disabled={disabled}
      {...props}
    >
      {children}
    </Comp>
  )
}
