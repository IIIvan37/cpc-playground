import { useSetAtom } from 'jotai'
import { useCallback, useEffect, useState } from 'react'
import { Select, SelectItem } from '@/components/ui/select'
import { codeAtom } from '@/store'
import { currentFileIdAtom, currentProjectIdAtom } from '@/store/projects'

interface Example {
  name: string
  file: string
}

export function ExamplesMenu() {
  const [examples, setExamples] = useState<Example[]>([])
  const [selectedValue, setSelectedValue] = useState('')
  const setCode = useSetAtom(codeAtom)
  const setCurrentFileId = useSetAtom(currentFileIdAtom)
  const setCurrentProjectId = useSetAtom(currentProjectIdAtom)

  useEffect(() => {
    fetch('/examples/index.json')
      .then((res) => res.json())
      .then(setExamples)
      .catch(console.error)
  }, [])

  const handleValueChange = useCallback(
    async (value: string) => {
      const example = examples.find((e) => e.file === value)
      if (!example) return

      try {
        const response = await fetch(`/examples/${example.file}`)
        const code = await response.text()
        setCode(code)
        setCurrentProjectId(null) // Désélectionner le projet
        setCurrentFileId(null) // Désélectionner le fichier
        setSelectedValue(value)
      } catch (error) {
        console.error('Failed to load example:', error)
      }
    },
    [examples, setCode, setCurrentProjectId, setCurrentFileId]
  )

  if (examples.length === 0) {
    return null
  }

  return (
    <Select
      value={selectedValue}
      onValueChange={handleValueChange}
      placeholder='Examples'
    >
      {examples.map((example) => (
        <SelectItem key={example.file} value={example.file}>
          {example.name}
        </SelectItem>
      ))}
    </Select>
  )
}
