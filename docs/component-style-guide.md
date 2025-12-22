# Component Style Guide

## Folder Structure

Each component must have its own folder with the following structure:

```
/component-name
├── component-name.tsx           # Container (logic + state)
├── component-name.test.tsx      # Container tests
├── component-name.view.tsx      # View (pure UI)
├── component-name.view.test.tsx # View tests
├── component-name.module.css    # Styles
└── index.ts                     # Barrel export
```

### Nested Components

A component folder can contain child components. Each child must follow the same pattern:

```
/parent-component
├── parent-component.tsx
├── parent-component.view.tsx
├── parent-component.module.css
├── index.ts
└── /child-component
    ├── child-component.tsx
    ├── child-component.view.tsx
    ├── child-component.module.css
    └── index.ts
```

## Container/View Pattern

### Container (`name.tsx`)

- Handles **business logic** and **state management**
- Uses hooks (useState, useEffect, useAtom, etc.)
- Fetches data and handles side effects
- Passes data and handlers to the View via props
- **No JSX** beyond rendering the View component

```tsx
export function UserProfile() {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(false)

  const handleSave = async () => {
    // business logic
  }

  return (
    <UserProfileView
      user={user}
      loading={loading}
      onSave={handleSave}
    />
  )
}
```

### View (`name.view.tsx`)

- **Pure presentational component**
- Receives all data and handlers via props
- Contains **only rendering logic**
- No hooks (except useRef for DOM refs if needed)
- No business logic

```tsx
export function UserProfileView({
  user,
  loading,
  onSave
}: UserProfileViewProps) {
  return (
    <div className={styles.container}>
      {loading ? <Spinner /> : <Profile user={user} />}
      <Button onClick={onSave}>Save</Button>
    </div>
  )
}
```

## Props Guidelines

### Use `type` instead of `interface`

```tsx
// ✅ Good
export type UserProfileViewProps = Readonly<{
  username: string
  onSave: () => void
}>

// ❌ Bad
export interface UserProfileViewProps {
  username: string
  onSave: () => void
}
```

### All props must be `readonly`

Use `Readonly<>` wrapper or individual `readonly` modifiers:

```tsx
// ✅ Option 1: Readonly wrapper (preferred for simple types)
export type ButtonProps = Readonly<{
  label: string
  onClick: () => void
}>

// ✅ Option 2: Individual readonly (for complex nested types)
export type ListProps = {
  readonly items: readonly Item[]
  readonly onSelect: (id: string) => void
}
```

### Interface Segregation Principle (ISP)

Keep props minimal and focused. Split large prop interfaces into smaller, cohesive ones.

```tsx
// ❌ Bad: Too many unrelated props
type UserFormProps = Readonly<{
  username: string
  email: string
  avatar: string
  onUsernameChange: (v: string) => void
  onEmailChange: (v: string) => void
  onAvatarChange: (v: string) => void
  onSubmit: () => void
  onCancel: () => void
  isLoading: boolean
  error: string | null
  validationErrors: Record<string, string>
}>

// ✅ Good: Segregated props
type UserFormFieldsProps = Readonly<{
  username: string
  email: string
  avatar: string
  onUsernameChange: (v: string) => void
  onEmailChange: (v: string) => void
  onAvatarChange: (v: string) => void
}>

type FormActionsProps = Readonly<{
  onSubmit: () => void
  onCancel: () => void
  isLoading: boolean
}>

type FormErrorProps = Readonly<{
  error: string | null
  validationErrors: Record<string, string>
}>
```

### Strategies to reduce props

1. **Group related props** into sub-components
2. **Use composition** instead of configuration
3. **Create specialized components** instead of generic ones with many options
4. **Extract child components** when a section has its own cohesive props

## Barrel Exports

Each component folder must have an `index.ts` that exports:

```tsx
// index.ts
export { ComponentName } from './component-name'
export type { ComponentNameViewProps } from './component-name.view'
```

## File Naming

- Use **kebab-case** for file names: `user-profile.tsx`
- Use **PascalCase** for component names: `UserProfile`
- Use **PascalCase** for type names: `UserProfileViewProps`

## Testing

### Container tests (`name.test.tsx`)

- Test business logic and state management
- Mock external dependencies
- Test handler behaviors

### View tests (`name.view.test.tsx`)

- Test rendering with different props
- Test user interactions (clicks, inputs)
- Test conditional rendering
- Use snapshot testing sparingly

## Example: Complete Component

```
/user-profile
├── user-profile.tsx
├── user-profile.test.tsx
├── user-profile.view.tsx
├── user-profile.view.test.tsx
├── user-profile.module.css
└── index.ts
```

### user-profile.tsx
```tsx
import { useState } from 'react'
import { useUserData } from '@/hooks/use-user-data'
import { UserProfileView } from './user-profile.view'

export function UserProfile() {
  const { user, updateUser } = useUserData()
  const [editing, setEditing] = useState(false)

  const handleSave = async (data: UserData) => {
    await updateUser(data)
    setEditing(false)
  }

  return (
    <UserProfileView
      user={user}
      editing={editing}
      onEdit={() => setEditing(true)}
      onSave={handleSave}
      onCancel={() => setEditing(false)}
    />
  )
}
```

### user-profile.view.tsx
```tsx
import styles from './user-profile.module.css'

export type UserProfileViewProps = Readonly<{
  user: User | null
  editing: boolean
  onEdit: () => void
  onSave: (data: UserData) => void
  onCancel: () => void
}>

export function UserProfileView({
  user,
  editing,
  onEdit,
  onSave,
  onCancel
}: UserProfileViewProps) {
  if (!user) return null

  return (
    <div className={styles.container}>
      {editing ? (
        <EditForm user={user} onSave={onSave} onCancel={onCancel} />
      ) : (
        <DisplayProfile user={user} onEdit={onEdit} />
      )}
    </div>
  )
}
```

### index.ts
```tsx
export { UserProfile } from './user-profile'
export type { UserProfileViewProps } from './user-profile.view'
```
