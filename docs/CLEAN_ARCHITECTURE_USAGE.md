# Clean Architecture - Guide d'utilisation

## Vue d'ensemble

Cette application utilise **Clean Architecture** avec des **factory functions** TypeScript pour garantir :
- ✅ Testabilité maximale
- ✅ Indépendance des frameworks
- ✅ Séparation claire des responsabilités
- ✅ Code maintenable et évolutif

## Structure

```
src/
├── domain/              # 🎯 Business logic (0 dépendances)
│   ├── entities/        # Entités métier
│   ├── value-objects/   # Objets valeur immuables
│   ├── repositories/    # Interfaces (ports)
│   └── errors/          # Erreurs métier
│
├── use-cases/           # 📋 Application business rules
│   └── projects/        # Use-cases projets
│
├── infrastructure/      # 🔌 Implementations techniques
│   ├── repositories/    # Implémentations Supabase
│   └── container.ts     # Dependency injection
│
└── hooks/               # 🎨 React hooks (présentation)
    └── use-projects.ts  # Hooks pour use-cases
```

## Comment utiliser dans les composants React

### 1. Import des hooks

```typescript
import { useCreateProject, useGetProjects } from '@/hooks'
```

### 2. Utilisation dans un composant

```typescript
function CreateProjectForm() {
  const { create, loading, error } = useCreateProject()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    
    try {
      const result = await create({
        userId: 'user-123',
        name: 'My New Project',
        visibility: 'private'
      })
      
      console.log('Project created:', result.project)
    } catch (err) {
      console.error('Failed to create project:', err)
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      {error && <div className="error">{error}</div>}
      <button type="submit" disabled={loading}>
        {loading ? 'Creating...' : 'Create Project'}
      </button>
    </form>
  )
}
```

### 3. Récupérer des projets

```typescript
function ProjectsList() {
  const { getProjects, loading, error } = useGetProjects()
  const [projects, setProjects] = useState([])

  useEffect(() => {
    const loadProjects = async () => {
      const result = await getProjects('user-123')
      setProjects(result.projects)
    }
    loadProjects()
  }, [])

  if (loading) return <div>Loading...</div>
  if (error) return <div>Error: {error}</div>

  return (
    <ul>
      {projects.map(project => (
        <li key={project.id}>{project.name.value}</li>
      ))}
    </ul>
  )
}
```

## Hooks disponibles

### Projets

- `useCreateProject()` - Créer un nouveau projet
- `useUpdateProject()` - Modifier un projet existant
- `useDeleteProject()` - Supprimer un projet
- `useGetProjects()` - Récupérer tous les projets d'un utilisateur
- `useGetProject()` - Récupérer un projet spécifique

Tous les hooks retournent :
```typescript
{
  [method]: (...args) => Promise<Result>
  loading: boolean
  error: string | null
}
```

## Ajouter un nouveau use-case

### 1. Créer le use-case dans `src/use-cases/projects/`

```typescript
// my-use-case.use-case.ts
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'

export type MyUseCaseInput = {
  // Input parameters
}

export type MyUseCaseOutput = {
  // Output data
}

export type MyUseCase = {
  execute(input: MyUseCaseInput): Promise<MyUseCaseOutput>
}

export function createMyUseCase(
  projectsRepository: IProjectsRepository
): MyUseCase {
  return {
    async execute(input: MyUseCaseInput): Promise<MyUseCaseOutput> {
      // Business logic here
      // Use repository to access data
      const result = await projectsRepository.someMethod()
      return { result }
    }
  }
}
```

### 2. Ajouter au container dans `src/infrastructure/container.ts`

```typescript
import { createMyUseCase } from '@/use-cases/projects/my-use-case.use-case'

export type Container = {
  // ... existing
  myUseCase: MyUseCase
}

export function createContainer(): Container {
  const projectsRepository = createSupabaseProjectsRepository()

  return {
    // ... existing
    myUseCase: createMyUseCase(projectsRepository)
  }
}
```

### 3. Créer un hook dans `src/hooks/use-projects.ts`

```typescript
export function useMyUseCase() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const execute = async (input: MyUseCaseInput) => {
    setLoading(true)
    setError(null)

    try {
      const result = await container.myUseCase.execute(input)
      return result
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unknown error'
      setError(message)
      throw err
    } finally {
      setLoading(false)
    }
  }

  return { execute, loading, error }
}
```

### 4. Créer des tests avec in-memory repository

```typescript
// __tests__/my-use-case.test.ts
import { describe, expect, it } from 'vitest'
import { createMyUseCase } from '../my-use-case.use-case'
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'

describe('MyUseCase', () => {
  it('should execute successfully', async () => {
    const repository = createInMemoryProjectsRepository()
    const useCase = createMyUseCase(repository)

    const result = await useCase.execute({ /* input */ })

    expect(result).toBeDefined()
    // More assertions
  })
})
```

## Règles importantes

### ⚠️ PAS DE CLASSES

```typescript
// ❌ NE PAS FAIRE
class MyUseCase {
  constructor(private repo: IRepo) {}
  execute() { }
}

// ✅ FAIRE
export function createMyUseCase(repo: IRepo): MyUseCase {
  return {
    execute() { }
  }
}
```

### ⚠️ MINIMISER LES MOCKS

```typescript
// ❌ NE PAS FAIRE (mock avec vi.fn())
const mockRepo = {
  findAll: vi.fn().mockResolvedValue([])
}

// ✅ FAIRE (in-memory repository)
const repository = createInMemoryProjectsRepository()
```

### ⚠️ TESTER LE COMPORTEMENT RÉEL

```typescript
// ✅ Créer des données dans le repository
await repository.create(project)

// ✅ Vérifier que les données sont sauvegardées
const saved = await repository.findById(project.id)
expect(saved).toBeDefined()
```

## Tests

```bash
# Lancer tous les tests
pnpm test

# Tests en mode watch
pnpm test -- --watch

# Tests d'un fichier spécifique
pnpm test -- src/use-cases/projects/__tests__/create-project.use-case.test.ts
```

## Plus d'informations

Voir [ARCHITECTURE.md](../ARCHITECTURE.md) pour la documentation complète.
