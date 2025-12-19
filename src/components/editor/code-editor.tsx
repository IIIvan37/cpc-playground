import { useAtom } from 'jotai'
import { useCallback } from 'react'
import { codeAtom } from '@/store'
import styles from './code-editor.module.css'

export function CodeEditor() {
  const [code, setCode] = useAtom(codeAtom)

  const handleChange = useCallback(
    (e: React.ChangeEvent<HTMLTextAreaElement>) => {
      setCode(e.target.value)
    },
    [setCode]
  )

  const handleKeyDown = useCallback(
    (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
      if (e.key === 'Tab') {
        e.preventDefault()
        const target = e.target as HTMLTextAreaElement
        const start = target.selectionStart
        const end = target.selectionEnd
        const newValue = `${code.substring(0, start)}    ${code.substring(end)}`
        setCode(newValue)
        requestAnimationFrame(() => {
          target.selectionStart = target.selectionEnd = start + 4
        })
      }
    },
    [code, setCode]
  )

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <span className={styles.title}>Z80 Assembly</span>
        <span className={styles.hint}>RASM Syntax</span>
      </div>
      <textarea
        className={styles.editor}
        value={code}
        onChange={handleChange}
        onKeyDown={handleKeyDown}
        spellCheck={false}
        autoComplete='off'
        autoCorrect='off'
        autoCapitalize='off'
      />
    </div>
  )
}
