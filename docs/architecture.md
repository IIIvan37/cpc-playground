# Architecture

## Overview

This project follows **Clean Architecture** principles with TypeScript-idiomatic **factory functions**.

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION                             │
│  components/ • hooks/ • store/                                  │
├─────────────────────────────────────────────────────────────────┤
│                        USE CASES                                │
│  use-cases/projects/ • use-cases/files/ • use-cases/tags/       │
├─────────────────────────────────────────────────────────────────┤
│                         DOMAIN                                  │
│  entities/ • value-objects/ • repositories/ • services/         │
├─────────────────────────────────────────────────────────────────┤
│                      INFRASTRUCTURE                             │
│  repositories/supabase • container.ts                           │
└─────────────────────────────────────────────────────────────────┘
```

## Core Principles

1. **Dependency Rule**: Dependencies point inward (Domain has no external dependencies)
2. **Factory Functions**: No classes, use factory functions returning object literals
3. **Ports & Adapters**: Repository interfaces in domain, implementations in infrastructure
4. **Domain Services**: Complex authorization logic centralized in services

## Directory Structure

```
src/
├── domain/                    # 🎯 Business logic (no external deps)
│   ├── entities/              # Project, ProjectFile, ProjectShare
│   ├── value-objects/         # ProjectName, Visibility, FileName, FileContent
│   ├── repositories/          # Interface definitions (ports)
│   ├── services/              # AuthorizationService
│   └── errors/                # NotFoundError, UnauthorizedError, ValidationError
│
├── use-cases/                 # 📋 Application business rules
│   ├── projects/              # CRUD, get-with-dependencies
│   ├── files/                 # Create, update, delete files
│   ├── tags/                  # Add, remove tags
│   ├── dependencies/          # Add, remove dependencies
│   └── shares/                # Add, remove user shares
│
├── infrastructure/            # 🔌 Technical implementations
│   ├── repositories/          # Supabase implementation
│   └── container.ts           # Dependency injection
│
└── presentation/              # 🎨 UI Layer
    ├── components/            # React components
    ├── hooks/                 # React hooks (call use-cases)
    └── store/                 # Jotai atoms
```

## Factory Functions Pattern

### Why Factory Functions?

```typescript
// ❌ Class-based (Java style)
class CreateProjectUseCase {
  constructor(private repo: IProjectsRepository) {}
  execute(input: Input) { /* ... */ }
}

// ✅ Factory function (TypeScript idiomatic)
export function createCreateProjectUseCase(
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
) {
  return {
    async execute(input: CreateProjectInput) {
      // Dependencies captured by closure
      const project = createProject({ /* ... */ })
      return projectsRepository.create(project)
    }
  }
}
```

**Benefits:**
- No `this`, no `constructor`, no `class`
- Dependencies captured by closures
- Smaller bundle size
- Easy composition and testing

## Domain Model

### Entities

```typescript
// Project entity
type Project = {
  id: string
  userId: string
  name: ProjectName          // Value object
  description: string | null
  visibility: Visibility     // Value object
  isLibrary: boolean
  files: ProjectFile[]
  shares: ProjectShare[]
  tags: Tag[]
  dependencies: string[]
  createdAt: Date
  updatedAt: Date
}
```

### Value Objects

Value objects are immutable and validate their input:

```typescript
// Creates a validated ProjectName
const name = createProjectName('My Project')  // OK
const name = createProjectName('ab')          // Throws ValidationError
```

### Authorization Service

Centralized authorization logic:

```typescript
type AuthorizationService = {
  // Check read access (owner, public, library, or shared)
  canReadProject(projectId: string, userId: string): Promise<boolean>
  
  // Verify ownership for write operations (throws if not owner)
  mustOwnProject(projectId: string, userId: string): Promise<Project>
  
  // Check if project can be used as dependency
  canAccessAsDependency(projectId: string, userId: string): Promise<boolean>
}
```

## Use Cases

Each use case follows the same pattern:

```typescript
// Input type
type CreateProjectInput = {
  userId: string
  name: string
  visibility?: 'private' | 'public' | 'shared'
  isLibrary?: boolean
}

// Output type
type CreateProjectOutput = {
  project: Project
}

// Factory function
export function createCreateProjectUseCase(
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
) {
  return {
    async execute(input: CreateProjectInput): Promise<CreateProjectOutput> {
      // 1. Validate input (value objects)
      const name = createProjectName(input.name)
      const visibility = createVisibility(input.visibility ?? 'private')
      
      // 2. Create entity
      const project = createProject({
        id: crypto.randomUUID(),
        userId: input.userId,
        name,
        visibility,
        // ...
      })
      
      // 3. Persist via repository
      const created = await projectsRepository.create(project)
      
      return { project: created }
    }
  }
}
```

## Container (Dependency Injection)

```typescript
// infrastructure/container.ts
import { createSupabaseProjectsRepository } from './repositories/supabase-projects.repository'
import { createAuthorizationService } from '@/domain/services'
import { createCreateProjectUseCase } from '@/use-cases/projects/create-project.use-case'

export function createContainer(supabase: SupabaseClient) {
  const projectsRepository = createSupabaseProjectsRepository(supabase)
  const authorizationService = createAuthorizationService(projectsRepository)
  
  return {
    createProjectUseCase: createCreateProjectUseCase(projectsRepository, authorizationService),
    // ... other use cases
  }
}
```

## Testing

### Unit Tests with In-Memory Repository

```typescript
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createMockAuthorizationService } from '@/domain/services/__tests__/mock-authorization.service'

describe('CreateProjectUseCase', () => {
  let repository: IProjectsRepository
  let authService: AuthorizationService
  let useCase: ReturnType<typeof createCreateProjectUseCase>

  beforeEach(() => {
    repository = createInMemoryProjectsRepository()
    authService = createMockAuthorizationService(repository)
    useCase = createCreateProjectUseCase(repository, authService)
  })

  it('should create a project', async () => {
    const result = await useCase.execute({
      userId: 'user-123',
      name: 'Test Project'
    })
    
    expect(result.project.name.value).toBe('Test Project')
  })
})
```

## Error Handling

```typescript
import { NotFoundError, UnauthorizedError, ValidationError } from '@/domain/errors'

// In use case
if (!project) {
  throw new NotFoundError('Project not found')
}

if (project.userId !== userId) {
  throw new UnauthorizedError('You do not have permission to modify this project')
}

// Validation errors thrown by value objects
const name = createProjectName('')  // Throws ValidationError
```
