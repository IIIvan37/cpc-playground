import type { InputHTMLAttributes } from 'react'
import styles from './checkbox.module.css'

type CheckboxProps = Readonly<{
  label?: string
}> &
  Omit<InputHTMLAttributes<HTMLInputElement>, 'type'>

export default function Checkbox({
  label,
  className,
  ...props
}: CheckboxProps) {
  if (label) {
    return (
      <label className={`${styles.checkboxLabel} ${className || ''}`}>
        <input type='checkbox' className={styles.checkbox} {...props} />
        {label}
      </label>
    )
  }

  return <input type='checkbox' className={styles.checkbox} {...props} />
}
