# Architecture Refactoring - Clean Architecture

## Objectif

Transformer le code POC en une architecture maintenable et testable suivant les principes de **Clean Architecture** (Uncle Bob) / **Hexagonal Architecture** (Ports & Adapters).

## Principes

1. **Independence of Frameworks** : Le domain ne dépend d'aucun framework (React, Supabase, Jotai)
2. **Testability** : Logique métier 100% testable sans mock d'infrastructure
3. **Separation of Concerns** : Domain, Use Cases, Infrastructure, Presentation
4. **Dependency Rule** : Les dépendances pointent vers l'intérieur (Domain au centre)

## Architecture en couches

```
┌─────────────────────────────────────────────────┐
│   domain/                 # 🎯 CORE - Aucune dépendance externe
│   ├── entities/          # Entités métier (Project, File, User)
│   │   ├── project.entity.ts
│   │   ├── file.entity.ts
│   │   └── user.entity.ts
│   │
│   ├── value-objects/     # Value Objects immuables
│   │   ├── project-name.vo.ts
│   │   ├── visibility.vo.ts
│   │   └── file-content.vo.ts
│   │
│   ├── repositories/      # Interfaces (Ports)
│   │   ├── project.repository.interface.ts
│   │   ├── file.repository.interface.ts
│   │   ├── auth.repository.interface.ts
│   │   └── tag.repository.interface.ts
│   │
│   ├── services/          # Services de domaine (logique métier pure)
│   │   └── project-validation.service.ts
│   │
│   └── errors/            # Erreurs métier
│       ├── domain.error.ts
│       ├── validation.error.ts
│       └── not-found.error.ts
│
├── use-cases/             # 📋 Application Business Rules
│   ├── projects/
│   │   ├── create-project.use-case.ts
│   │   ├── update-project.use-case.ts
│   │   ├── delete-project.use-case.ts
│   │   ├── fetch-projects.use-case.ts
│   │   ├── share-project.use-case.ts
│   │   └── __tests__/
│   │       ├── create-project.use-case.test.ts
│   │       └── update-project.use-case.test.ts
│   │
│   ├── files/
│   │   ├── create-file.use-case.ts
│   │   ├── update-file.use-case.ts
│   │   └── __tests__/
│   │
│   └── auth/
│       ├── sign-in.use-case.ts
│       ├── sign-up.use-case.ts
│       └── __tests__/
│
├── infrastructure/        # 🔌 Adapters (implémentations techniques)
│   ├── repositories/     # Implémentation des interfaces du domain
│   │   ├── supabase-project.repository.ts
│   │   ├── supabase-file.repository.ts
│   │   ├── supabase-auth.repository.ts
│   │   └── __tests__/   # Tests d'intégration ou avec mock Supabase
│   │
│   ├── auth/            # Adaptateur auth
│   │   └── supabase-auth.adapter.ts
│   │
│   └── config/          # Configuration Supabase
│       └── supabase.client.ts
│
├── presentation/         # 🎨 UI Layer
│   ├── components/      # Composants React
│   ├── hooks/          # Hooks React (appellent use-cases)
│   │   ├── use-create-project.ts
│   │   └── use-projects-list.ts
│   ├── store/          # État global (Jotai)
│   └── pages/
│
└── shared/              # Code partagé (types, utils)
    ├── types/
    └── utils/
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
   export function  : Repository + Service

### Architecture en couches

```
UI (Components)
    ↓ utilise
Hooks (useProjects)
    ↓ utilise
Services (projectsService) ← Logique métier PURE
    ↓ utilise
Repositories (projectsRepository) ← Accès données (Supabase)
    ↓ utilise
Supabase Client
```

### 1. Repository Layer (Accès données)

Chaque repository :
- Est une classe singleton
- Contient UNIQUEMENT les calls Supabase (pas de logique métier)
- Retourne des types typés
- Gère les erreurs de base (throw)
- Mapping DB ↔ Domain types

**Exemple :**
```typescript
// repositories/projects.repository.ts
class ProjectsRepository {
  async findAll(userId: string): Promise<Project[]> {
    const { data, error } = await supabase
      .from('projects')
      .select('*')
      .eq('user_id', userId)
    
    if (error) throw error
    return data.map(this.mapToProject)
  }
  
  async create(input: ProjectDbInput): Promise<Project> {
    const { data, error } = await supabase
    3. Tests

#### Tests de Repositories
- Mockent Supabase (couche infrastructure)
- Testent le mapping et les queries
- Ou tests d'intégration avec vraie DB

```typescript
// repositories/__tests__/projects.repository.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { projectsRepository } from '../projects.repository'

vi.mock('@/lib/supabase', () => ({
  supabase: {
    from: vi.fn(() => ({
      select: vi.fn().mockReturnThis(),
      insert: vi.fn().mockResolvedValue({ data: mockData, error: null })
    }))
  }
}))

describe('ProjectsRepository', () => {
  it('should call supabase with correct query', async () => {
    // Test infrastructure
  })
})
```

#### Tests de Services
- **Mockent les repositories** (pas Supabase !)
- Testent la logique métier pure
- Validation, transformation, orchestration

```typescript
// services/__tests__/projects.service.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { ProjectsService } from '../projects.service'

// Mock du repository (pas Supabase)
const mockRepository = {
  findAll: vi.fn(),
  create: vi.fn(),
  update: vi.fn()
}

describe('ProjectsService', () => {
  let service: ProjectsService
  
  beforeEach(() => {
    service = new ProjectsService(mockRepository)
    vi.clearAllMocks()
  })
  
  describe('createProject', () => {
    it('should validate project name length', async () => {
      // Test logique métier
      await expect(
        service.createProject({ name: 'ab' })
      ).rejects.toThrow('at least 3 characters')
      
      expect(mockRepository.create).not.toHaveBeenCalled()
    })
    
    it('should generate slug from name', async () => {
      mockRepository.create.mockResolvedValue({ id: '1', name: 'Test' })
      
      await service.createProject({ name: 'My Project' })
      
      expect(mockRepository.create).toHaveBeenCalledWith(
        expect.objectContaining({ slug: 'my-project' })
      )ut.name || input.name.length < 3) {
      throw new Error('Project name must be at least 3 characters')
    }
    
    // Transformation métier
    const projectData = {
      ...input,
      name: input.name.trim(),
      slug: this.generateSlug(input.name)
    }
    
    // Délégation au repository
    return await this.repo.create(projectData)
  }
  
  private generateSlug(name: string): string {
    // Logique métier pure
    return name.toLowerCase().replace(/\s+/g, '-')   .single()
      
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
   Tests Strategy

### Tests de Domain (Entities + Value Objects)
- Tests unitaires purs
- Aucun mock nécessaire
- Tests de la logique métier

```typescript
// domain/value-objects/__tests__/project-name.vo.test.ts
import { describe, it, expect } from 'vitest'
import { ProjectName } from '../project-name.vo'
import { ValidationError } from '@/domain/errors/validation.error'

describe('ProjectName', () => {
  it('should create valid project name', () => {
    const name = ProjectName.create('Valid Name')
    expect(name.value).toBe('Valid Name')
  })

  it('should trim whitespace', () => {
    const name = ProjectName.create('  Name  ')
    expect(name.value).toBe('Name')
  })

  it('should reject name too short', () => {
    expect(() => ProjectName.create('ab')).toThrow(ValidationError)
    expect(() => ProjectName.create('ab')).toThrow('at least 3 characters')
  })

  it('should reject name too long', () => {
    const longName = 'a'.repeat(101)
    expect(() => ProjectName.create(longName)).toThrow(ValidationError)
  })
})
```

### Tests de Use Cases
- Mockent les interfaces de repositories
- Testent l'orchestration
- 100% isolés de l'infrastructure

```typescript
// use-cases/projects/__tests__/create-project.use-case.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { CreateProjectUseCase } from '../create-project.use-case'
import type { IProjectRepository } from '@/domain/repositories/project.repository.interface'
import type { IAuthRepository } from '@/domain/repositories/auth.repository.interface'
import { Project } from '@/domain/entities/project.entity'

describe('CreateProjectUseCase', () => {
  let useCase:Domain Layer (Foundation)
1. ✅ Créer structure de dossiers
2. ⏳ Définir entités (Project, File, User)
3. ⏳ Créer value objects (ProjectName, Visibility, FileContent)
4. ⏳ Définir interfaces de repositories (ports)
5. ⏳ Créer erreurs métier custom
6. ⏳ Tests unitaires du domain (100% coverage)

### Phase 2 : Infrastructure Layer
1. ⏳ Créer repositories Supabase (implémentent interfaces)
2. ⏳ Créer mappers (DB ↔ Domain)
3. ⏳ Tests d'infrastructure (mock Supabase ou intégration)

### Phase 3 : Use Cases Layer
1. ⏳ Create/Update/Delete project use-cases
2. ⏳ Share/Unshare project use-cases
3. ⏳ Files use-cases
4. ⏳ Auth use-cases
5. ⏳ Tests unitaires use-cases (mock repositories)

###Avantages de Clean Architecture

### 1. Testabilité maximale
- Domain : 100% testable sans aucun mock
- Use Cases : Testables avec mocks d'interfaces
- Infrastructure : Testable séparément

### 2. Indépendance des frameworks
- Domain ne connaît pas React, Supabase, Jotai
- Changement de BDD ? Seule l'infrastructure change
- Changement de UI ? Seule la presentation change

### 3. Règle de dépendance respectée
```
Domain (aucune dépendance)
   ↑
Use Cases (dépend du domain)
   ↑
Infrastructure (implémente les interfaces du domain)
   ↑
Presentation (utilise use-cases)
```

### 4. Logique métier centrale et protégée
- Validation dans value objects
- Règles métier dans entités
- Orchestration dans use-cases
- Infrastructure isolée     name: 'Test Project',
        userId: 'user-123'
      })
    )
    expect(project).toBeInstanceOf(Project)
  })

  it('should validate project name via value object', async () => {
    mockAuthRepo.getCurrentUserId.mockResolvedValue('user-123')

    // Act & Assert
    await expect(
      useCase.execute({ name: 'ab', visibility: 'private' })
    ).rejects.toThrow('at least 3 characters')

    expect(mockProjectRepo.save).not.toHaveBeenCalled()
  })

  it('should use default visibility if not provided', async () => {
    mockAuthRepo.getCurrentUserId.mockResolvedValue('user-123')
    mockProjectRepo.save.mockImplementation(async (project) => project)

    const project = await useCase.execute({ name: 'Test' })

    expect(project.visibility).toBe('private')
  })
})
```

### Tests de Repositories (Infrastructure)
- Mockent Supabase (ou tests d'intégration)
- Testent le mapping DB ↔ Domain
- Testent les queries SQL

```typescript
// infrastructure/repositories/__tests__/supabase-project.repository.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { SupabaseProjectRepository } from '../supabase-project.repository'
import { Project } from '@/domain/entities/project.entity'

vi.mock('@/infrastructure/config/supabase.client', () => ({
  supabase: {
    from: vi.fn(() => ({
      select: vi.fn().mockReturnThis(),
      insert: vi.fn().mockReturnThis(),
      single: vi.fn()
    }))
  }
}))

describe('SupabaseProjectRepository', () => {
  let repository: SupabaseProjectRepository

  beforeEach(() => {
    repository = new SupabaseProjectRepository()
    vi.clearAllMocks()
  })

  it('should map database row to domain entity', async () => {
    const mockData = {
      id: 'project-1',
      user_id: 'user-123',
      name: 'Test',
      visibility: 'private',
      // ...
    }

    // Setup mock
    const mockQuery = {
      select: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      single: vi.fn().mockResolvedValue({ data: mockData, error: null })
    }
    
    supabase.from.mockReturnValue(mockQuery)

    // Act
    const project = await repository.findById('project-1')

    // Assert
    expect(project).toBeInstanceOf(Project)
    expect(project?.name).toBe('Test')
  })
})
```  service = new ProjectsService()
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
