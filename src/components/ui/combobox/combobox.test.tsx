import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { describe, expect, it, vi } from 'vitest'
import Combobox from './combobox'
import styles from './combobox.module.css'

const mockOptions = [
  { value: 'apple', label: 'Apple' },
  { value: 'banana', label: 'Banana' },
  { value: 'cherry', label: 'Cherry' },
  { value: 'date', label: 'Date' }
] as const

describe('Combobox', () => {
  it('renders with basic props', () => {
    const onValueChange = vi.fn()
    render(
      <Combobox
        options={mockOptions}
        value=''
        onValueChange={onValueChange}
        placeholder='Select fruit'
      />
    )

    const input = screen.getByPlaceholderText('Select fruit')
    expect(input).toBeInTheDocument()
    expect(input).toHaveValue('')
  })

  it('renders with label', () => {
    const onValueChange = vi.fn()
    render(
      <Combobox
        label='Fruit'
        options={mockOptions}
        value=''
        onValueChange={onValueChange}
      />
    )

    expect(screen.getByLabelText('Fruit')).toBeInTheDocument()
  })

  it('renders with error', () => {
    const onValueChange = vi.fn()
    render(
      <Combobox
        label='Fruit'
        error='This field is required'
        options={mockOptions}
        value=''
        onValueChange={onValueChange}
      />
    )

    expect(screen.getByText('This field is required')).toBeInTheDocument()
  })

  it('displays initial value', () => {
    const onValueChange = vi.fn()
    render(
      <Combobox
        options={mockOptions}
        value='apple'
        onValueChange={onValueChange}
      />
    )

    const input = screen.getByDisplayValue('apple')
    expect(input).toBeInTheDocument()
  })

  it('opens dropdown on input focus', async () => {
    const user = userEvent.setup()
    const onValueChange = vi.fn()
    render(
      <Combobox options={mockOptions} value='' onValueChange={onValueChange} />
    )

    const input = screen.getByRole('textbox')
    await user.click(input)

    await waitFor(() => {
      expect(screen.getByText('Apple')).toBeInTheDocument()
      expect(screen.getByText('Banana')).toBeInTheDocument()
    })
  })

  it('selects option on click', async () => {
    const user = userEvent.setup()
    const onValueChange = vi.fn()
    const onSelect = vi.fn()
    render(
      <Combobox
        options={mockOptions}
        value=''
        onValueChange={onValueChange}
        onSelect={onSelect}
      />
    )

    const input = screen.getByRole('textbox')
    await user.click(input)

    const appleOption = await screen.findByText('Apple')
    await user.click(appleOption)

    expect(onValueChange).toHaveBeenCalledWith('apple')
    expect(onSelect).toHaveBeenCalledWith(mockOptions[0])
  })

  it('calls onInputChange when typing', async () => {
    const user = userEvent.setup()
    const onValueChange = vi.fn()
    const onInputChange = vi.fn()
    render(
      <Combobox
        options={mockOptions}
        value=''
        onValueChange={onValueChange}
        onInputChange={onInputChange}
      />
    )

    const input = screen.getByRole('textbox')
    await user.type(input, 'a')

    expect(onValueChange).toHaveBeenCalledWith('a')
    expect(onInputChange).toHaveBeenCalledWith('a')
  })

  it('closes dropdown on escape key', async () => {
    const user = userEvent.setup()
    const onValueChange = vi.fn()
    render(
      <Combobox options={mockOptions} value='' onValueChange={onValueChange} />
    )

    const input = screen.getByRole('textbox')
    await user.click(input)

    await waitFor(() => {
      expect(screen.getByText('Apple')).toBeInTheDocument()
    })

    await user.keyboard('{Escape}')

    await waitFor(() => {
      expect(screen.queryByText('Apple')).not.toBeInTheDocument()
    })
  })

  it('navigates options with arrow keys and selects with enter', async () => {
    const user = userEvent.setup()
    const onValueChange = vi.fn()
    const onSelect = vi.fn()
    render(
      <Combobox
        options={mockOptions}
        value=''
        onValueChange={onValueChange}
        onSelect={onSelect}
      />
    )

    const input = screen.getByRole('textbox')
    await user.click(input)

    await waitFor(() => {
      expect(screen.getByText('Apple')).toBeInTheDocument()
    })

    // Navigate down to second option (Banana)
    await user.keyboard('{ArrowDown}')

    // Select with Enter
    await user.keyboard('{Enter}')

    expect(onValueChange).toHaveBeenCalledWith('banana')
    expect(onSelect).toHaveBeenCalledWith(mockOptions[1])
  })

  it('opens dropdown with arrow keys when closed', async () => {
    const user = userEvent.setup()
    const onValueChange = vi.fn()
    render(
      <Combobox options={mockOptions} value='' onValueChange={onValueChange} />
    )

    const input = screen.getByRole('textbox')
    input.focus() // Ensure input has focus
    await user.keyboard('{ArrowDown}')

    await waitFor(() => {
      expect(screen.getByText('Apple')).toBeInTheDocument()
    })
  })

  it('shows loading state', async () => {
    const user = userEvent.setup()
    const onValueChange = vi.fn()
    render(
      <Combobox
        options={mockOptions}
        value=''
        onValueChange={onValueChange}
        loading={true}
      />
    )

    const input = screen.getByRole('textbox')
    await user.click(input)

    await waitFor(() => {
      expect(screen.getByText('Loading...')).toBeInTheDocument()
    })
  })

  it('closes dropdown when clicking outside', async () => {
    const user = userEvent.setup()
    const onValueChange = vi.fn()
    render(
      <div>
        <Combobox
          options={mockOptions}
          value=''
          onValueChange={onValueChange}
        />
        <div data-testid='outside'>Outside</div>
      </div>
    )

    const input = screen.getByRole('textbox')
    await user.click(input)

    await waitFor(() => {
      expect(screen.getByText('Apple')).toBeInTheDocument()
    })

    const outside = screen.getByTestId('outside')
    await user.click(outside)

    await waitFor(() => {
      expect(screen.queryByText('Apple')).not.toBeInTheDocument()
    })
  })

  it('highlights option on mouse enter', async () => {
    const user = userEvent.setup()
    const onValueChange = vi.fn()
    render(
      <Combobox options={mockOptions} value='' onValueChange={onValueChange} />
    )

    const input = screen.getByRole('textbox')
    await user.click(input)

    const bananaOption = await screen.findByText('Banana')
    await user.hover(bananaOption)

    // The highlighted class should be applied
    expect(bananaOption).toHaveClass(styles.highlighted)
  })

  it('passes through additional input props', () => {
    const onValueChange = vi.fn()
    render(
      <Combobox
        options={mockOptions}
        value=''
        onValueChange={onValueChange}
        disabled
        maxLength={10}
      />
    )

    const input = screen.getByRole('textbox')
    expect(input).toBeDisabled()
    expect(input).toHaveAttribute('maxLength', '10')
  })
})
