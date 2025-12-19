import { useSetAtom } from 'jotai'
import { useCallback, useEffect, useState } from 'react'
import { codeAtom } from '@/store'
import styles from './examples-menu.module.css'

interface Example {
  name: string
  file: string
}

export function ExamplesMenu() {
  const [examples, setExamples] = useState<Example[]>([])
  const [isOpen, setIsOpen] = useState(false)
  const setCode = useSetAtom(codeAtom)

  useEffect(() => {
    fetch('/examples/index.json')
      .then((res) => res.json())
      .then(setExamples)
      .catch(console.error)
  }, [])

  const loadExample = useCallback(
    async (example: Example) => {
      try {
        const response = await fetch(`/examples/${example.file}`)
        const code = await response.text()
        setCode(code)
        setIsOpen(false)
      } catch (error) {
        console.error('Failed to load example:', error)
      }
    },
    [setCode]
  )

  if (examples.length === 0) {
    return null
  }

  return (
    <div className={styles.container}>
      <button
        type='button'
        className={styles.trigger}
        onClick={() => setIsOpen(!isOpen)}
      >
        📁 Examples
      </button>
      {isOpen && (
        <div className={styles.dropdown}>
          {examples.map((example) => (
            <button
              key={example.file}
              type='button'
              className={styles.item}
              onClick={() => loadExample(example)}
            >
              {example.name}
            </button>
          ))}
        </div>
      )}
    </div>
  )
}
