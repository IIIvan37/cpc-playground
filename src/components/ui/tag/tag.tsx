import type { ReactNode } from 'react'
import styles from './tag.module.css'

type TagProps = Readonly<{
  children: ReactNode
}>

export function Tag({ children }: TagProps) {
  return <span className={styles.tag}>{children}</span>
}

type TagsListProps = Readonly<{
  tags: readonly string[]
}>

export function TagsList({ tags }: TagsListProps) {
  if (tags.length === 0) return null

  return (
    <div className={styles.tagsList}>
      {tags.map((tag) => (
        <Tag key={tag}>{tag}</Tag>
      ))}
    </div>
  )
}
