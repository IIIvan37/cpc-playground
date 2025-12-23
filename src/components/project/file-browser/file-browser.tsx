import { FileIcon, StarFilledIcon } from '@radix-ui/react-icons'
import { useAtomValue, useSetAtom } from 'jotai'
import { useState } from 'react'
import { activeProjectAtom, codeAtom } from '@/store'
import styles from './file-browser.module.css'

/**
 * File browser component for displaying and navigating project files
 * Works for both owned projects and view-only projects
 */
export function FileBrowser() {
  const project = useAtomValue(activeProjectAtom)
  const setCode = useSetAtom(codeAtom)
  const [selectedFileId, setSelectedFileId] = useState<string | null>(null)

  if (!project) {
    return null
  }

  const handleSelectFile = (file: {
    id: string
    content: { value: string }
  }) => {
    setSelectedFileId(file.id)
    setCode(file.content.value)
  }

  // Auto-select main file on first render
  if (selectedFileId === null && project.files.length > 0) {
    const mainFile = project.files.find((f) => f.isMain) || project.files[0]
    setSelectedFileId(mainFile.id)
  }

  return (
    <div className={styles.container}>
      <div className={styles.header}>
        <div className={styles.projectName}>{project.name.value}</div>
        <div className={styles.badges}>
          {project.visibility.value === 'public' && (
            <span className={`${styles.badge} ${styles.badgePublic}`}>
              Public
            </span>
          )}
          {project.isLibrary && (
            <span className={`${styles.badge} ${styles.badgeLibrary}`}>
              Lib
            </span>
          )}
        </div>
      </div>

      <div className={styles.fileList}>
        {project.files.map((file) => (
          <button
            key={file.id}
            type='button'
            className={`${styles.fileItem} ${
              selectedFileId === file.id ? styles.active : ''
            }`}
            onClick={() => handleSelectFile(file)}
          >
            <FileIcon className={styles.fileIcon} />
            <span className={styles.fileName}>{file.name.value}</span>
            {file.isMain && <StarFilledIcon className={styles.mainIcon} />}
          </button>
        ))}
      </div>

      {project.tags && project.tags.length > 0 && (
        <div className={styles.tags}>
          {project.tags.map((tag) => (
            <span key={tag} className={styles.tag}>
              {tag}
            </span>
          ))}
        </div>
      )}
    </div>
  )
}
