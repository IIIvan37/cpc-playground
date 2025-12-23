import type { ReactNode } from 'react'
import styles from './badge.module.css'

export type BadgeVariant =
  | 'public'
  | 'shared'
  | 'owner'
  | 'library'
  | 'readOnly'
  | 'info'
  | 'success'
  | 'warning'
  | 'error'

type BadgeProps = Readonly<{
  variant: BadgeVariant
  children: ReactNode
  className?: string
}>

export function Badge({ variant, children, className }: BadgeProps) {
  const classNames = [styles.badge, styles[variant], className]
    .filter(Boolean)
    .join(' ')

  return <span className={classNames}>{children}</span>
}

export default Badge
