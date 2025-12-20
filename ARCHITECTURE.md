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
- Tests : `*.test.ts`
- Types : `*.types.ts`
- Hooks : `use-*.ts`
- Composants : PascalCase

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
