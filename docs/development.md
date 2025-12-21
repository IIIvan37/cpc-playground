# Development Guide

## Commands

### Development

```bash
pnpm dev              # Start dev server
pnpm build            # Build for production
pnpm build:prod       # Build with TypeScript check
pnpm preview          # Preview production build
```

### Testing

```bash
pnpm test             # Run tests in watch mode
pnpm test --run       # Run tests once
pnpm test --coverage  # Run with coverage report
```

### Linting

```bash
pnpm lint             # Check linting (Biome)
pnpm lint:fix         # Fix linting issues
```

---

## Supabase CLI

### Authentication

```bash
supabase login        # Login to Supabase
```

### Local Development

```bash
supabase start        # Start local Supabase (Docker)
supabase stop         # Stop local Supabase
supabase status       # Check status
supabase db reset     # Reset database and apply migrations
```

### Migrations

```bash
# Create new migration
supabase migration new add_new_feature

# List migrations
supabase migration list

# Apply to production
supabase db push

# Pull schema from production
supabase db pull
```

### Fix Migration Issues

```bash
# Mark migration as applied
supabase migration repair --status applied <timestamp>

# Mark migration as reverted
supabase migration repair --status reverted <timestamp>
```

### Generate Types

```bash
supabase gen types typescript --linked > src/types/database-generated.ts
```

---

## Project Structure

```
src/
├── domain/                    # Business logic (no deps)
│   ├── entities/
│   ├── value-objects/
│   ├── repositories/
│   ├── services/
│   └── errors/
│
├── use-cases/                 # Application logic
│   ├── projects/
│   ├── files/
│   ├── tags/
│   ├── dependencies/
│   └── shares/
│
├── infrastructure/            # External implementations
│   ├── repositories/
│   └── container.ts
│
├── components/                # React components
├── hooks/                     # React hooks
├── store/                     # Jotai atoms
├── services/                  # External services
├── types/                     # TypeScript types
└── workers/                   # Web workers (RASM)
```

---

## Testing Strategy

### Unit Tests

Test domain logic and use cases with in-memory repositories:

```typescript
import { createInMemoryProjectsRepository } from '@/infrastructure/repositories/__tests__/in-memory-projects.repository'
import { createAuthorizationService } from '@/domain/services'

describe('MyUseCase', () => {
  let repository: IProjectsRepository
  let authService: AuthorizationService
  let useCase: ReturnType<typeof createMyUseCase>

  beforeEach(() => {
    repository = createInMemoryProjectsRepository()
    authService = createAuthorizationService(repository)
    useCase = createMyUseCase(repository, authService)
  })

  it('should do something', async () => {
    // Test without external dependencies
  })
})
```

### Integration Tests

Test with real Supabase (skipped by default):

```bash
# Enable integration tests
INTEGRATION_TESTS=true pnpm test
```

---

## Adding a New Use Case

### 1. Create the use case file

```typescript
// src/use-cases/projects/my-use-case.ts
import type { IProjectsRepository } from '@/domain/repositories/projects.repository.interface'
import type { AuthorizationService } from '@/domain/services'
import { NotFoundError, UnauthorizedError, ValidationError } from '@/domain/errors'

type MyUseCaseInput = {
  projectId: string
  userId: string
  // ...
}

type MyUseCaseOutput = {
  success: boolean
}

export function createMyUseCase(
  projectsRepository: IProjectsRepository,
  authorizationService: AuthorizationService
) {
  return {
    async execute(input: MyUseCaseInput): Promise<MyUseCaseOutput> {
      // 1. Authorization check
      await authorizationService.mustOwnProject(input.projectId, input.userId)
      
      // 2. Business logic
      // ...
      
      return { success: true }
    }
  }
}
```

### 2. Add to container

```typescript
// src/infrastructure/container.ts
export function createContainer(supabase: SupabaseClient) {
  // ...
  return {
    // ...
    myUseCase: createMyUseCase(projectsRepository, authorizationService),
  }
}
```

### 3. Create tests

```typescript
// src/use-cases/projects/__tests__/my-use-case.test.ts
describe('MyUseCase', () => {
  // ...
})
```

### 4. Create hook (if needed)

```typescript
// src/hooks/use-my-feature.ts
export function useMyFeature() {
  const { myUseCase } = useContainer()
  // ...
}
```

---

## Common Patterns

### Error Messages

Use centralized error constants:

```typescript
import { AUTH_ERRORS, PROJECT_ERRORS, FILE_ERRORS } from '@/domain/errors/error-messages'

// In tests
expect(fn).rejects.toThrow(AUTH_ERRORS.PROJECT_NOT_FOUND)
expect(fn).rejects.toThrow(AUTH_ERRORS.UNAUTHORIZED_MODIFY)
expect(fn).rejects.toThrow(PROJECT_ERRORS.NOT_FOUND(projectId))
expect(fn).rejects.toThrow(FILE_ERRORS.NOT_FOUND)
```

### Creating Test Data

```typescript
const project = createProject({
  id: 'test-id',
  userId: 'user-123',
  name: createProjectName('Test Project'),
  visibility: createVisibility('private'),
  isLibrary: false,
  files: [],
  shares: [],
  tags: [],
  dependencies: [],
  createdAt: new Date(),
  updatedAt: new Date()
})
```

---

## Deployment

### Netlify (Automatic)

Push to `main` branch triggers automatic deployment.

### Manual

```bash
# Build
pnpm build:prod

# Deploy dist/ folder to any static host
```

### Environment Variables

Set in Netlify Dashboard:

```
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=xxx
VITE_APP_ENV=production
```
