import {
  type InputHTMLAttributes,
  type KeyboardEvent,
  useEffect,
  useRef,
  useState
} from 'react'
import styles from './combobox.module.css'

export type ComboboxOption = Readonly<{
  value: string
  label: string
}>

type ComboboxProps = Readonly<{
  label?: string
  error?: string
  options: readonly ComboboxOption[]
  loading?: boolean
  value: string
  onValueChange: (value: string) => void
  onInputChange?: (value: string) => void
  onSelect?: (option: ComboboxOption) => void
  placeholder?: string
  emptyMessage?: string
}> &
  Omit<InputHTMLAttributes<HTMLInputElement>, 'value' | 'onChange' | 'onSelect'>

export default function Combobox({
  label,
  error,
  options,
  loading = false,
  value,
  onValueChange,
  onInputChange,
  onSelect,
  placeholder,
  emptyMessage = 'No results found',
  className,
  id,
  ...props
}: ComboboxProps) {
  const [isOpen, setIsOpen] = useState(false)
  const [highlightedIndex, setHighlightedIndex] = useState(0)
  const inputRef = useRef<HTMLInputElement>(null)
  const dropdownRef = useRef<HTMLDivElement>(null)

  const inputId = id || label?.toLowerCase().replaceAll(' ', '-')

  // Close dropdown when clicking outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(event.target as Node) &&
        inputRef.current &&
        !inputRef.current.contains(event.target as Node)
      ) {
        setIsOpen(false)
      }
    }

    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside)
      return () => {
        document.removeEventListener('mousedown', handleClickOutside)
      }
    }
  }, [isOpen])

  const handleInputChange = (newValue: string) => {
    onValueChange(newValue)
    onInputChange?.(newValue)
    setIsOpen(true)
  }

  const handleSelectOption = (option: ComboboxOption) => {
    onValueChange(option.value)
    onSelect?.(option)
    setIsOpen(false)
    inputRef.current?.blur()
  }

  const handleKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
    if (!isOpen) {
      if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
        e.preventDefault()
        setIsOpen(true)
      }
      return
    }

    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault()
        setHighlightedIndex((prev) =>
          prev < options.length - 1 ? prev + 1 : prev
        )
        break
      case 'ArrowUp':
        e.preventDefault()
        setHighlightedIndex((prev) => (prev > 0 ? prev - 1 : prev))
        break
      case 'Enter':
        e.preventDefault()
        if (options[highlightedIndex]) {
          handleSelectOption(options[highlightedIndex])
        }
        break
      case 'Escape':
        e.preventDefault()
        setIsOpen(false)
        inputRef.current?.blur()
        break
    }
  }

  const inputElement = (
    <div className={styles.inputWrapper}>
      <input
        ref={inputRef}
        id={inputId}
        type='text'
        className={`${styles.input} ${error ? styles.inputError : ''} ${
          className || ''
        }`}
        value={value}
        onChange={(e) => handleInputChange(e.target.value)}
        onFocus={() => setIsOpen(true)}
        onKeyDown={handleKeyDown}
        placeholder={placeholder}
        autoComplete='off'
        {...props}
      />
      {isOpen && (options.length > 0 || loading) && (
        <div ref={dropdownRef} className={styles.dropdown}>
          {loading ? (
            <div className={styles.loading}>Loading...</div>
          ) : options.length === 0 ? (
            <div className={styles.empty}>{emptyMessage}</div>
          ) : (
            options.map((option, index) => (
              <div
                key={option.value}
                className={`${styles.option} ${
                  index === highlightedIndex ? styles.highlighted : ''
                }`}
                onClick={() => handleSelectOption(option)}
                onMouseEnter={() => setHighlightedIndex(index)}
              >
                {option.label}
              </div>
            ))
          )}
        </div>
      )}
    </div>
  )

  if (label) {
    return (
      <div className={styles.combobox}>
        <div className={styles.inputGroup}>
          <label htmlFor={inputId} className={styles.label}>
            {label}
          </label>
          {inputElement}
          {error && <span className={styles.error}>{error}</span>}
        </div>
      </div>
    )
  }

  return <div className={styles.combobox}>{inputElement}</div>
}
