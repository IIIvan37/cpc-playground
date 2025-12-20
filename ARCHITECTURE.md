# Architecture Refactoring

## Objectif

Transformer le code POC en une architecture maintenable et testable avec une séparation claire des responsabilités.

## Principes

1. **Separation of Concerns** : Séparer la logique métier (services) de la gestion d'état (stores) et de l'UI (components)
2. **Testabilité** : Chaque service doit avoir une suite de tests complète
3. **Type Safety** : Types TypeScript centralisés et générés depuis Supabase
4. **Single Source of Truth** : Éviter la duplication de code et de logique

## Structure

```
src/
├── lib/                    # Configuration et utilitaires globaux
│   ├── supabase.ts        # Client Supabase configuré
│   └── constants.ts       # Constantes globales
│
├── types/                  # Types TypeScript centralisés
│   ├── database.types.ts  # Types générés depuis Supabase (à terme auto-généré)
│   ├── auth.types.ts      # Types pour l'authentification
│   └── project.types.ts   # Types pour les projets/fichiers
│
├── services/               # Couche service (logique métier)
│   ├── auth.service.ts    # ✅ DONE - Gestion authentification
│   ├── projects.service.ts # TODO - CRUD projets
│   ├── files.service.ts   # TODO - CRUD fichiers
│   ├── tags.service.ts    # TODO - Gestion tags
│   └── __tests__/         # Tests unitaires des services
│       └── auth.service.test.ts # ✅ DONE - 16 tests
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

1. **lib/** - Configuration centralisée
   - `supabase.ts` : Client avec auth PKCE, localStorage
   - `constants.ts` : URLs CDN, validations

2. **types/** - Types centralisés
   - `database.types.ts` : Schéma complet (7 tables)
   - `auth.types.ts` : Types auth (credentials, responses)
   - `project.types.ts` : Types projets/fichiers/tags

3. **services/auth.service.ts** - Service authentification
   - 9 méthodes : signIn, signUp, signOut, OAuth, profile CRUD
   - Gestion d'erreurs complète
   - Singleton pattern

4. **services/__tests__/auth.service.test.ts**
   - 16 tests couvrant tous les scénarios
   - Mocks Supabase
   - Tests success/error cases

### 🔄 En cours

1. **store/projects-v2.ts** (1036 lignes)
   - Contient toute la logique Supabase en dur
   - À migrer vers services

### ❌ À faire

1. **services/projects.service.ts**
   ```typescript
   class ProjectsService {
     // CRUD operations
     fetchProjects(): Promise<Project[]>
     getProjectById(id: string): Promise<Project | null>
     createProject(input: CreateProjectInput): Promise<Project>
     updateProject(id: string, input: UpdateProjectInput): Promise<Project>
     deleteProject(id: string): Promise<void>
     
     // Sharing
     shareProject(projectId: string, username: string): Promise<void>
     unshareProject(projectId: string, userId: string): Promise<void>
     updateVisibility(projectId: string, visibility: ProjectVisibility): Promise<void>
     
     // Dependencies
     fetchDependencyFiles(projectId: string): Promise<DependencyWithFiles[]>
     addDependency(projectId: string, dependencyId: string): Promise<void>
     removeDependency(projectId: string, dependencyId: string): Promise<void>
   }
   ```

2. **services/files.service.ts**
   ```typescript
   class FilesService {
     fetchProjectFiles(projectId: string): Promise<ProjectFile[]>
     createFile(input: CreateFileInput): Promise<ProjectFile>
     updateFile(id: string, input: UpdateFileInput): Promise<ProjectFile>
     deleteFile(id: string): Promise<void>
     setMainFile(fileId: string): Promise<void>
   }
   ```

3. **services/tags.service.ts**
   ```typescript
   class TagsService {
     fetchTags(): Promise<Tag[]>
     createTag(name: string): Promise<Tag>
     addTagToProject(projectId: string, tagId: string): Promise<void>
     removeTagFromProject(projectId: string, tagId: string): Promise<void>
   }
   ```

4. **Tests complets pour chaque service**

5. **Refactor stores** - Simplifier pour utiliser services
   ```typescript
   // store/projects.ts (nouveau, simplifié)
   export const projectsAtom = atom<Project[]>([])
   export const currentProjectIdAtom = atom<string | null>(null)
   
   // Actions deviennent des wrappers vers services
   export const fetchProjectsAtom = atom(null, async (get, set) => {
     const projects = await projectsService.fetchProjects()
     set(projectsAtom, projects)
   })
   ```

6. **Hooks par domaine**
   ```typescript
   // hooks/auth/use-auth.ts
   export function useAuth() {
     const [user, setUser] = useState<AuthUser | null>(null)
     // Utilise authService
   }
   
   // hooks/projects/use-projects.ts
   export function useProjects() {
     const [projects] = useAtom(projectsAtom)
     const fetchProjects = useSetAtom(fetchProjectsAtom)
     // ...
   }
   ```

## Pattern à suivre

### 1. Service Layer

Chaque service :
- Est une classe singleton
- Contient toute la logique Supabase pour son domaine
- Retourne des types typés (pas `any`)
- Gère les erreurs de manière cohérente
- N'a pas de dépendance sur React ou Jotai

**Exemple :**
```typescript
class ProjectsService {
  async createProject(input: CreateProjectInput): Promise<Project> {
    try {
      const { data, error } = await supabase
        .from('projects')
        .insert({ ...input })
        .select()
        .single()
      
      if (error) throw error
      return this.mapToProject(data)
    } catch (error) {
      console.error('Error creating project:', error)
      throw error
    }
  }
}

export const projectsService = new ProjectsService()
```

### 2. Tests

Chaque service doit avoir :
- Un fichier de test `*.test.ts` dans `__tests__/`
- Des mocks pour Supabase
- Tests pour success cases
- Tests pour error cases
- Coverage > 80%

**Exemple :**
```typescript
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { ProjectsService } from '../projects.service'

vi.mock('@/lib/supabase', () => ({
  supabase: {
    from: vi.fn(() => ({
      insert: vi.fn(),
      select: vi.fn(),
      single: vi.fn()
    }))
  }
}))

describe('ProjectsService', () => {
  let service: ProjectsService
  
  beforeEach(() => {
    service = new ProjectsService()
    vi.clearAllMocks()
  })
  
  describe('createProject', () => {
    it('should create project successfully', async () => {
      // ...
    })
  })
})
```

### 3. Store Atoms

Les stores deviennent minimalistes :
- État simple (pas de logique)
- Actions = wrappers vers services
- Pas de calls Supabase directs

```typescript
// ❌ Avant (dans l'atom)
export const createProjectAtom = atom(null, async (get, set, input) => {
  const { data, error } = await supabase.from('projects').insert(...)
  if (error) throw error
  set(projectsAtom, [...get(projectsAtom), data])
})

// ✅ Après (utilise le service)
export const createProjectAtom = atom(null, async (get, set, input) => {
  const project = await projectsService.createProject(input)
  set(projectsAtom, [...get(projectsAtom), project])
})
```

### 4. Hooks

Encapsuler la logique complexe dans des hooks :

```typescript
export function useProjectCreate() {
  const createProject = useSetAtom(createProjectAtom)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  
  const handleCreate = async (input: CreateProjectInput) => {
    setLoading(true)
    setError(null)
    try {
      await createProject(input)
    } catch (e) {
      setError(e.message)
    } finally {
      setLoading(false)
    }
  }
  
  return { handleCreate, loading, error }
}
```

## Plan d'exécution

### Phase 1 : Services (actuel)
1. ✅ auth.service.ts + tests
2. ⏳ projects.service.ts + tests
3. ⏳ files.service.ts + tests
4. ⏳ tags.service.ts + tests

### Phase 2 : Migration stores
1. Créer nouveaux stores simplifiés
2. Migrer progressivement les atoms
3. Supprimer anciens stores

### Phase 3 : Hooks
1. Créer hooks par domaine (auth/, projects/, emulator/)
2. Migrer components vers nouveaux hooks

### Phase 4 : Cleanup
1. Supprimer code legacy
2. Documenter APIs
3. Vérifier coverage tests > 80%

## Conventions

### Naming
- Services : `*.service.ts` (singleton lowercase)
- Tests : `*.test.ts` (services), `*.spec.tsx` (components)
- Types : `*.types.ts`
- Hooks : `use-*.ts`
- Composants : PascalCase + dossier par composant

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
  const result = await service.method()
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
