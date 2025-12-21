# Architecture Refactoring - Clean Architecture

## Objectif

Transformer le code POC en une architecture maintenable et testable suivant les principes de **Clean Architecture** (Uncle Bob) / **Hexagonal Architecture** (Ports & Adapters).

## Principes

1. **Independence of Frameworks** : Le domain ne dépend d'aucun framework (React, Supabase, Jotai)
2. **Testability** : Logique métier 100% testable sans mock d'infrastructure
3. **Separation of Concerns** : Domain, Use Cases, Infrastructure, Presentation
4. **Dependency Rule** : Les dépendances pointent vers l'intérieur (Domain au centre)
5. **TypeScript Idiomatic** : Privilégier les **factory functions** plutôt que les classes
6. **Testing Best Practices** : Minimiser les mocks, utiliser des **in-memory repositories**

## Architecture en couches

```
┌─────────────────────────────────────────────────┐
│   domain/                 # 🎯 CORE - Aucune dépendance externe
│   ├── entities/          # Entités métier (factory functions)
│   │   ├── project.entity.ts
│   │   ├── project-file.entity.ts
│   │   └── project-share.entity.ts
│   │
│   ├── value-objects/     # Value Objects immuables (factory functions)
│   │   ├── project-name.vo.ts
│   │   ├── visibility.vo.ts
│   │   ├── file-name.vo.ts
│   │   ├── file-content.vo.ts
│   │   └── share-code.vo.ts
│   │
│   ├── repositories/      # Interfaces (Ports)
│   │   ├── projects.repository.interface.ts
│   │   └── files.repository.interface.ts
│   │
│   └── errors/            # Erreurs métier
│       └── domain.error.ts
│
├── use-cases/             # 📋 Application Business Rules (factory functions)
│   └── projects/
│       ├── create-project.use-case.ts
│       ├── update-project.use-case.ts
│       ├── delete-project.use-case.ts
│       ├── get-projects.use-case.ts
│       ├── get-project.use-case.ts
│       └── __tests__/
│           ├── create-project.use-case.test.ts
│           ├── update-project.use-case.test.ts
│           ├── delete-project.use-case.test.ts
│           ├── get-projects.use-case.test.ts
│           └── get-project.use-case.test.ts
│
├── infrastructure/        # 🔌 Adapters (factory functions)
│   └── repositories/
│       ├── supabase-projects.repository.ts
│       └── __tests__/
│           └── in-memory-projects.repository.ts  # Pour les tests
│
└── presentation/         # 🎨 UI Layer
    ├── components/      # Composants React
    ├── hooks/          # Hooks React (appellent use-cases)
    └── store/          # État global (Jotai)
```

## Pattern TypeScript : Factory Functions

### ⚠️ RÈGLE : PAS DE CLASSES dans domain/use-cases/infrastructure

TypeScript n'est pas Java. Nous privilégions les **factory functions** qui retournent des objets littéraux.

**❌ Mauvais (OOP / Java-style) :**
```typescript
// ❌ NE PAS FAIRE
export class CreateProjectUseCase {
  constructor(private readonly repository: IProjectsRepository) {}
  
  async execute(input: CreateProjectInput): Promise<CreateProjectOutput> {
    // ...
  }
}

export function createCreateProjectUseCase(repo: IProjectsRepository) {
  return new CreateProjectUseCase(repo)
}
```

**✅ Bon (Functional / TypeScript-idiomatic) :**
```typescript
// ✅ FAIRE
export type CreateProjectUseCase = {
  execute(input: CreateProjectInput): Promise<CreateProjectOutput>
}

export function createCreateProjectUseCase(
  projectsRepository: IProjectsRepository
): CreateProjectUseCase {
  return {
    async execute(input: CreateProjectInput) {
      // Les dépendances sont capturées par closure
      const project = await projectsRepository.create(/* ... */)
      return { project }
    }
  }
}
```

### Avantages des Factory Functions

1. **Plus idiomatique TypeScript** : Pas de `this`, pas de `constructor`, pas de `class`
2. **Closures naturelles** : Les dépendances sont capturées automatiquement
3. **Composition facile** : Retourne des objets littéraux
4. **Testabilité** : Injection de dépendances simple
5. **Bundle size** : Code plus léger (pas de classes)

### Application du pattern

#### Value Objects (Factory Functions)
```typescript
// domain/value-objects/project-name.vo.ts
const ProjectNameBrand = Symbol('ProjectName')

export type ProjectName = {
  readonly value: string
  readonly [ProjectNameBrand]: true
}

export function createProjectName(name: string): ProjectName {
  const trimmed = name.trim()
  
  if (trimmed.length < 3) {
    throw new ValidationError('Project name must be at least 3 characters')
  }
  
  if (trimmed.length > 100) {
    throw new ValidationError('Project name must be at most 100 characters')
  }
  
  return Object.freeze({
    value: trimmed,
    [ProjectNameBrand]: true as const
  })
}
```

#### Entities (Factory Functions)
```typescript
// domain/entities/project.entity.ts
export type Project = {
  readonly id: string
  readonly userId: string
  readonly name: ProjectName
  readonly visibility: Visibility
  readonly files: readonly ProjectFile[]
  readonly createdAt: Date
  readonly updatedAt: Date
}

export function createProject(params: {
  id: string
  userId: string
  name: ProjectName
  visibility: Visibility
  files?: ProjectFile[]
  createdAt?: Date
  updatedAt?: Date
}): Project {
  return Object.freeze({
    id: params.id,
    userId: params.userId,
    name: params.name,
    visibility: params.visibility,
    files: Object.freeze(params.files ?? []),
    createdAt: params.createdAt ?? new Date(),
    updatedAt: params.updatedAt ?? new Date()
  })
}
```

#### Use Cases (Factory Functions)
```typescript
// use-cases/projects/create-project.use-case.ts
export type CreateProjectInput = {
  userId: string
  name: string
  visibility?: 'public' | 'private'
  files?: Array<{ name: string; content: string; isMain: boolean }>
}

export type CreateProjectOutput = {
  project: Project
}

export type CreateProjectUseCase = {
  execute(input: CreateProjectInput): Promise<CreateProjectOutput>
}

export function createCreateProjectUseCase(
  projectsRepository: IProjectsRepository
): CreateProjectUseCase {
  return {
    async execute(input: CreateProjectInput): Promise<CreateProjectOutput> {
      // Validation via value objects
      const name = createProjectName(input.name)
      const visibility = input.visibility === 'public' 
        ? Visibility.PUBLIC 
        : Visibility.PRIVATE
      
      // Business logic
      const project = createProject({
        id: crypto.randomUUID(),
        userId: input.userId,
        name,
        visibility,
        files: input.files?.map(/* ... */) ?? []
      })
      
      // Persistence
      const savedProject = await projectsRepository.create(project)
      
      return { project: savedProject }
    }
  }
}
```

#### Repositories (Factory Functions)
```typescript
// infrastructure/repositories/supabase-projects.repository.ts
export function createSupabaseProjectsRepository(): IProjectsRepository {
  return {
    async findAll(userId: string): Promise<Project[]> {
      const { data, error } = await supabase
        .from('projects')
        .select('*')
        .eq('user_id', userId)
      
      if (error) throw error
      return data.map(mapToProject)
    },
    
    async create(project: Project): Promise<Project> {
      const { data, error } = await supabase
        .from('projects')
        .insert(mapToDatabase(project))
        .select()
        .single()
      
      if (error) throw error
      return mapToProject(data)
    },
    
    // ... autres méthodes
  }
}
```

## Testing Best Practices

### ⚠️ RÈGLE : Minimiser les mocks

**Principe** : Ne mocker que ce qui est **vraiment externe** (base de données, API HTTP, système de fichiers).

### Hiérarchie de préférence pour les tests

1. **Pas de mock du tout** (Domain layer - entités, value objects)
2. **In-memory implementations** (Use cases - in-memory repository)
3. **Mocks minimaux** (Infrastructure - mock Supabase client)

### Tests de Domain (Pas de mock)

Les tests du domain layer sont **purs** - aucun mock nécessaire.

```typescript
// domain/value-objects/__tests__/project-name.vo.test.ts
import { describe, expect, it } from 'vitest'
import { createProjectName } from '../project-name.vo'
import { ValidationError } from '@/domain/errors/domain.error'

describe('ProjectName', () => {
  it('should create valid project name', () => {
    const name = createProjectName('Valid Name')
    expect(name.value).toBe('Valid Name')
  })

  it('should reject name too short', () => {
    expect(() => createProjectName('ab')).toThrow(ValidationError)
  })
})
```

### Tests de Use Cases (In-Memory Repository)

**❌ Mauvais : Utiliser des mocks Vitest**
```typescript
// ❌ NE PAS FAIRE
const mockRepository: IProjectsRepository = {
  findAll: vi.fn().mockResolvedValue([]),
  findById: vi.fn().mockResolvedValue(null),
  create: vi.fn(),
  update: vi.fn(),
  delete: vi.fn(),
  // ... 10 autres méthodes à mocker
}
```

**✅ Bon : Utiliser un In-Memory Repository**
```typescript
// ✅ FAIRE
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'

describe('DeleteProjectUseCase', () => {
  it('should delete project when user is owner', async () => {
    // Arrange
    const repository = createInMemoryProjectsRepository()
    
    const project = createProject({
      id: '123',
      userId: 'user-1',
      name: createProjectName('My Project'),
      visibility: Visibility.PRIVATE
    })
    
    await repository.create(project)
    
    const useCase = createDeleteProjectUseCase(repository)
    
    // Act
    const result = await useCase.execute({
      projectId: '123',
      userId: 'user-1'
    })
    
    // Assert
    expect(result.success).toBe(true)
    
    // Vérification réelle que le projet a été supprimé
    const deletedProject = await repository.findById('123')
    expect(deletedProject).toBeNull()
  })
})
```

### In-Memory Repository Pattern

Créer un repository en mémoire **réutilisable** pour tous les tests :

```typescript
// infrastructure/repositories/__tests__/in-memory-projects.repository.ts
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { Project } from '@/domain/entities/project.entity'

/**
 * In-memory implementation of IProjectsRepository for testing.
 * Provides realistic repository behavior without external dependencies.
 */
export function createInMemoryProjectsRepository(): IProjectsRepository {
  const projects = new Map<string, Project>()
  const shareCodeIndex = new Map<string, string>()

  return {
    async findAll(userId: string): Promise<Project[]> {
      return Array.from(projects.values()).filter(
        (project) => project.userId === userId
      )
    },

    async findById(id: string): Promise<Project | null> {
      return projects.get(id) ?? null
    },

    async create(project: Project): Promise<Project> {
      projects.set(project.id, project)
      return project
    },

    async update(project: Project): Promise<Project> {
      if (!projects.has(project.id)) {
        throw new Error(`Project with id ${project.id} not found`)
      }
      projects.set(project.id, project)
      return project
    },

    async delete(id: string): Promise<void> {
      projects.delete(id)
    },

    // ... autres méthodes
  }
}
```

### Avantages de l'In-Memory Repository

1. **Plus proche du réel** : Teste vraiment la logique de persistance
2. **Tests robustes** : Vérifie que les données sont réellement sauvegardées/supprimées
3. **Réutilisable** : Même repository pour tous les tests
4. **Pas de setup/teardown** : Chaque test a son propre repository indépendant
5. **Tests expressifs** : On teste le comportement, pas l'implémentation
6. **Maintenance** : Un seul endroit à mettre à jour si l'interface change

### Tests de l'Infrastructure (Mock Supabase)

Seule la couche infrastructure devrait mocker les dépendances externes :

```typescript
// infrastructure/repositories/__tests__/supabase-projects.repository.test.ts
import { describe, expect, it, vi } from 'vitest'
import { createSupabaseProjectsRepository } from '../supabase-projects.repository'

vi.mock('@/infrastructure/config/supabase.client', () => ({
  supabase: {
    from: vi.fn(() => ({
      select: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      single: vi.fn().mockResolvedValue({ 
        data: { id: '1', name: 'Test' }, 
        error: null 
      })
    }))
  }
}))

describe('SupabaseProjectsRepository', () => {
  it('should map database row to domain entity', async () => {
    const repository = createSupabaseProjectsRepository()
    const project = await repository.findById('1')
    
    expect(project).toBeDefined()
    expect(project?.name.value).toBe('Test')
  })
})
```

### Règles de Mock

1. **Domain layer** : ❌ Aucun mock (tests purs)
2. **Use cases layer** : ✅ In-memory repositories (pas de mocks Vitest)
3. **Infrastructure layer** : ✅ Mock des clients externes (Supabase, fetch)
4. **Presentation layer** : ✅ Mock des use-cases et hooks
├── services/               # Couche logique métier (AUCUNE dépendance Supabase)
│   ├── auth.service.ts    # TODO - Refactor pour utiliser repository
│   ├── projects.service.ts # TODO - Orchestration, validation, logique métier
│   ├── files.service.ts   # TODO - Logique métier fichiers
│   ├── tags.service.ts    # TODO - Logique métier tags
│   └── __tests__/         # Tests unitaires avec mock repositories
│       └── projects.service.test.ts # Tests de la logique pure
│
├── store/                  # État global (Jotai atoms)
│   ├── editor.ts          # État éditeur (code, erreurs, etc.)
│   ├── emulator.ts        # État émulateur
│   └── projects-v2.ts     # TODO - À migrer vers services
│
├── hooks/                  # Hooks React personnalisés
│   ├── auth/              # TODO - Hooks d'authentification
│   ├── projects/          # TODO - Hooks projets
│   └── emulator/          # TODO - Hooks émulateur
│
└── components/             # Composants React
    ├── auth/              # Composants authentification
    │   └── auth-modal/
    │       ├── auth-modal.tsx           # Logique (hooks, état)
    │       ├── auth-modal.spec.tsx      # Tests logique
    │       ├── auth-modal.view.tsx      # Présentation pure
    │       ├── auth-modal.view.spec.tsx # Tests présentation
    │       └── auth-modal.module.css    # Styles
    ├── project/           # Composants projets
    ├── editor/            # Éditeur de code
    └── ui/                # Composants UI réutilisables
```

## État actuel

### ✅ Complété

1. **Domain Layer** - Architecture fonctionnelle pure
   - ✅ Value Objects avec factory pattern (ProjectName, FileName, FileContent, Visibility, ShareCode)
   - ✅ Entities avec factory pattern (Project, ProjectFile, ProjectShare, ProjectDependency)
   - ✅ Repository Interfaces (IProjectsRepository, IFilesRepository)
   - ✅ Domain Errors (ValidationError, NotFoundError, UnauthorizedError)
   - ✅ **62 tests** passants - 100% couverture

2. **Use Cases Layer** - Factory functions
   - ✅ CreateProjectUseCase (factory function)
   - ✅ UpdateProjectUseCase (factory function)
   - ✅ DeleteProjectUseCase (factory function)
   - ✅ GetProjectsUseCase (factory function)
   - ✅ GetProjectUseCase (factory function)
   - ✅ **9 tests** passants avec in-memory repository

3. **Infrastructure Layer** - Factory functions
   - ✅ SupabaseProjectsRepository (factory function)
   - ✅ In-Memory Projects Repository (pour tests)

4. **Pattern Validation**
   - ✅ Aucune classe dans domain/use-cases/infrastructure
   - ✅ Factory functions partout
   - ✅ In-memory repository pour tests (pas de mocks Vitest)
   - ✅ **139 tests** passants au total

### 🔄 En cours

1. **Dependency Injection Container**
   - À créer : Factory qui wire tous les use-cases avec les bons repositories
   - Pattern : `createContainer() => { createProject, getProjects, ... }`

2. **React Hooks Adapters**
   - À créer : Hooks qui utilisent le container
   - Pattern : `useCreateProject()` qui appelle `container.createProject.execute()`

### ❌ À faire

1. **Migrate Stores** - Simplifier les atoms Jotai pour utiliser les use-cases
2. **Complete Domain** - Ajouter autres entités (Tags, Dependencies, etc.)
3. **More Use Cases** - Share project, Add dependency, etc.
4. **Files Use Cases** - Create/Update/Delete files
5. **Integration Tests** - Tests E2E avec Supabase local## Dependency Injection Pattern

### Container Factory

Le container wire tous les use-cases avec leurs dépendances :

```typescript
// infrastructure/container.ts
import { createSupabaseProjectsRepository } from './repositories/supabase-projects.repository'
import { createCreateProjectUseCase } from '@/use-cases/projects/create-project.use-case'
import { createGetProjectsUseCase } from '@/use-cases/projects/get-projects.use-case'
// ... autres imports

export type Container = {
  // Projects use cases
  createProject: CreateProjectUseCase
  getProjects: GetProjectsUseCase
  getProject: GetProjectUseCase
  updateProject: UpdateProjectUseCase
  deleteProject: DeleteProjectUseCase
}

export function createContainer(): Container {
  // Infrastructure
  const projectsRepository = createSupabaseProjectsRepository()
  
  // Use cases (injection des dépendances)
  return {
    createProject: createCreateProjectUseCase(projectsRepository),
    getProjects: createGetProjectsUseCase(projectsRepository),
    getProject: createGetProjectUseCase(projectsRepository),
    updateProject: createUpdateProjectUseCase(projectsRepository),
    deleteProject: createDeleteProjectUseCase(projectsRepository)
  }
}

// Singleton pour l'application
export const container = createContainer()
```

### React Hook Adapter

Les hooks utilisent le container :

```typescript
// hooks/projects/use-create-project.ts
import { useState } from 'react'
import { container } from '@/infrastructure/container'
import type { CreateProjectInput } from '@/use-cases/projects/create-project.use-case'

export function useCreateProject() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const create = async (input: CreateProjectInput) => {
    setLoading(true)
    setError(null)
    
    try {
      const result = await container.createProject.execute(input)
      return result
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unknown error'
      setError(message)
      throw err
    } finally {
      setLoading(false)
    }
  }

  return { create, loading, error }
}
```

## Conventions de Code

### ⚠️ RÈGLES STRICTES

1. **PAS DE CLASSES** dans domain/use-cases/infrastructure
   - ❌ `class ProjectName { ... }`
   - ✅ `function createProjectName(name: string): ProjectName { ... }`

2. **Factory Functions partout**
   - Retourner des objets littéraux
   - Utiliser les closures pour capturer les dépendances
   - `Object.freeze()` pour l'immutabilité

3. **Minimiser les mocks dans les tests**
   - Domain : ❌ Aucun mock
   - Use Cases : ✅ In-memory repository (pas de `vi.fn()`)
   - Infrastructure : ✅ Mock Supabase uniquement

4. **In-Memory Repository requis**
   - Créer un in-memory repository pour chaque interface
   - Placer dans `infrastructure/repositories/__tests__/`
   - Réutiliser dans tous les tests de use-cases

### Naming
- Use Cases : `create-project.use-case.ts`
- Entities : `project.entity.ts`
- Value Objects : `project-name.vo.ts`
- Repositories : `projects.repository.interface.ts` (interface), `supabase-projects.repository.ts` (impl)
- Tests : `*.test.ts` (unit), `*.spec.tsx` (components)
- Factory functions : `createProjectName`, `createProject`, `createCreateProjectUseCase`

### Imports
```typescript
// Ordre des imports
import { external } from 'package'           // 1. External
import { internal } from '@/path'           // 2. Internal
import type { Type } from '@/types/...'     // 3. Types
import styles from './file.module.css'      // 4. Styles
```

### Error Handling
```typescript
try {
  const result = await useCase.execute(input)
  return result
} catch (error) {
  console.error('Context:', error)
  throw error // Laisser le caller gérer
}
```

## Pattern Composants

### Structure par composant

Chaque composant suit le pattern **Smart/Dumb** avec séparation présentation/logique :

```
components/
└── feature-name/
    └── component-name/
        ├── component-name.tsx           # Controller (logique)
        ├── component-name.spec.tsx      # Tests du controller
        ├── component-name.view.tsx      # View (présentation pure)
        ├── component-name.view.spec.tsx # Tests de la view
        └── component-name.module.css    # Styles
```

### Controller (*.tsx)

Le fichier principal contient la logique :
- Gestion d'état (useState, useAtom)
- Appels aux hooks personnalisés
- Gestion des événements
- Aucun JSX de présentation (délégué à `.view.tsx`)

**Exemple :**
```typescript
// auth-modal.tsx
import { useState } from 'react'
import { useAuth } from '@/hooks/auth'
import { AuthModalView } from './auth-modal.view'

export interface AuthModalProps {
  onClose: () => void
}

export function AuthModal({ onClose }: AuthModalProps) {
  const [mode, setMode] = useState<'signin' | 'signup'>('signin')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const { signIn, signUp, loading } = useAuth()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    
    const result = mode === 'signin' 
      ? await signIn(email, password)
      : await signUp(email, password)
    
    if (result.error) {
      setError(result.error.message)
    } else {
      onClose()
    }
  }

  const handleToggleMode = () => {
    setMode(mode === 'signin' ? 'signup' : 'signin')
    setError(null)
  }

  return (
    <AuthModalView
      mode={mode}
      email={email}
      password={password}
      error={error}
      loading={loading}
      onEmailChange={setEmail}
      onPasswordChange={setPassword}
      onSubmit={handleSubmit}
      onToggleMode={handleToggleMode}
      onClose={onClose}
    />
  )
}
```

### View (*.view.tsx)

Le fichier view contient uniquement la présentation :
- JSX pur
- Props typées (toutes les données viennent du controller)
- Aucune logique (pas de useState, useEffect, etc.)
- Facile à tester avec Storybook

**Exemple :**
```typescript
// auth-modal.view.tsx
import { Modal } from '@/components/ui/modal'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import styles from './auth-modal.module.css'

export interface AuthModalViewProps {
  mode: 'signin' | 'signup'
  email: string
  password: string
  error: string | null
  loading: boolean
  onEmailChange: (value: string) => void
  onPasswordChange: (value: string) => void
  onSubmit: (e: React.FormEvent) => void
  onToggleMode: () => void
  onClose: () => void
}

export function AuthModalView({
  mode,
  email,
  password,
  error,
  loading,
  onEmailChange,
  onPasswordChange,
  onSubmit,
  onToggleMode,
  onClose
}: AuthModalViewProps) {
  return (
    <Modal
      open={true}
      onClose={onClose}
      title={mode === 'signin' ? 'Sign In' : 'Sign Up'}
    >
      <form onSubmit={onSubmit} className={styles.form}>
        {error && <div className={styles.error}>{error}</div>}
        
        <Input
          label='Email'
          type='email'
          value={email}
          onChange={(e) => onEmailChange(e.target.value)}
          disabled={loading}
        />
        
        <Input
          label='Password'
          type='password'
          value={password}
          onChange={(e) => onPasswordChange(e.target.value)}
          disabled={loading}
        />
        
        <Button type='submit' disabled={loading}>
          {loading ? 'Loading...' : mode === 'signin' ? 'Sign In' : 'Sign Up'}
        </Button>
        
        <button
          type='button'
          onClick={onToggleMode}
          className={styles.toggle}
        >
          {mode === 'signin' ? 'Create account' : 'Already have an account?'}
        </button>
      </form>
    </Modal>
  )
}
```

### Tests Controller (*.spec.tsx)

Teste la logique :
- Gestion d'état
- Appels aux services/hooks
- Gestion d'erreurs
- Mock des dépendances

**Exemple :**
```typescript
// auth-modal.spec.tsx
import { describe, it, expect, vi } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import { AuthModal } from './auth-modal'

vi.mock('@/hooks/auth', () => ({
  useAuth: () => ({
    signIn: vi.fn().mockResolvedValue({ error: null }),
    signUp: vi.fn().mockResolvedValue({ error: null }),
    loading: false
  })
}))

describe('AuthModal', () => {
  it('should switch between signin and signup modes', () => {
    render(<AuthModal onClose={() => {}} />)
    
    expect(screen.getByText('Sign In')).toBeInTheDocument()
    fireEvent.click(screen.getByText('Create account'))
    expect(screen.getByText('Sign Up')).toBeInTheDocument()
  })
  
  it('should display error message on failed signin', async () => {
    // Test error handling
  })
})
```

### Tests View (*.view.spec.tsx)

Teste la présentation :
- Rendu des props
- Interactions utilisateur (clics, changements)
- Accessibilité
- Snapshots

**Exemple :**
```typescript
// auth-modal.view.spec.tsx
import { describe, it, expect, vi } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import { AuthModalView } from './auth-modal.view'

describe('AuthModalView', () => {
  const defaultProps = {
    mode: 'signin' as const,
    email: '',
    password: '',
    error: null,
    loading: false,
    onEmailChange: vi.fn(),
    onPasswordChange: vi.fn(),
    onSubmit: vi.fn(),
    onToggleMode: vi.fn(),
    onClose: vi.fn()
  }
  
  it('should render signin form', () => {
    render(<AuthModalView {...defaultProps} />)
    expect(screen.getByText('Sign In')).toBeInTheDocument()
  })
  
  it('should call onEmailChange when email input changes', () => {
    render(<AuthModalView {...defaultProps} />)
    const input = screen.getByLabelText('Email')
    fireEvent.change(input, { target: { value: 'test@example.com' } })
    expect(defaultProps.onEmailChange).toHaveBeenCalledWith('test@example.com')
  })
  
  it('should display error message', () => {
    render(<AuthModalView {...defaultProps} error='Invalid credentials' />)
    expect(screen.getByText('Invalid credentials')).toBeInTheDocument()
  })
})
```

### Avantages du pattern

1. **Testabilité** : View pure = tests simples sans mocks
2. **Réutilisabilité** : View peut être réutilisée avec différentes logiques
3. **Storybook** : View peut être documentée facilement
4. **Séparation claire** : Logique vs présentation
5. **Maintenance** : Modifications UI n'affectent pas la logique

## Commandes

```bash
# Tests
pnpm test                           # Tous les tests
pnpm test src/services              # Tests services uniquement
pnpm test --watch                   # Mode watch

# Linter
pnpm biome check .                  # Check
pnpm biome check . --write          # Fix auto

# TypeScript
pnpm typecheck                      # Vérification types
```

## Ressources

- [Jotai Docs](https://jotai.org/)
- [Vitest Docs](https://vitest.dev/)
- [Supabase JS Docs](https://supabase.com/docs/reference/javascript)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
