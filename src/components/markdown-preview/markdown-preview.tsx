import { FileTextIcon } from '@radix-ui/react-icons'
import { useAtomValue } from 'jotai'
import { lazy, memo, Suspense } from 'react'
import remarkGfm from 'remark-gfm'
import { codeAtom } from '@/store'
import styles from './markdown-preview.module.css'

// Lazy load react-markdown
const Markdown = lazy(() => import('react-markdown'))

type MarkdownPreviewViewProps = Readonly<{
  content: string
}>

// Memoize the Markdown rendering
const MemoizedMarkdown = memo(function MemoizedMarkdown({
  content
}: {
  content: string
}) {
  return (
    <Suspense fallback={<pre className={styles.loading}>{content}</pre>}>
      <Markdown remarkPlugins={[remarkGfm]}>{content}</Markdown>
    </Suspense>
  )
})

function MarkdownPreviewView({ content }: MarkdownPreviewViewProps) {
  if (!content.trim()) {
    return (
      <div className={styles.empty}>
        <FileTextIcon className={styles.emptyIcon} />
        <p className={styles.emptyText}>
          Start writing markdown to see the preview
        </p>
      </div>
    )
  }

  return (
    <div className={styles.container}>
      <div className={styles.content}>
        <MemoizedMarkdown content={content} />
      </div>
    </div>
  )
}

/**
 * Container component that reads code from store
 */
export function MarkdownPreview() {
  const code = useAtomValue(codeAtom)
  return <MarkdownPreviewView content={code} />
}

// Export View component for testing
export { MarkdownPreviewView }
