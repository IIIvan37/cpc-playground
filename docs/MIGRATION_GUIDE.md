# Migration Guide - From projects-v2 to Clean Architecture

## Vue d'ensemble

Ce guide explique comment migrer du store `projects-v2.ts` vers la nouvelle architecture Clean Architecture avec `projects.ts`.

## Différences principales

### Ancien (`projects-v2.ts`)
- ❌ Appels Supabase directs dans les atoms
- ❌ Types locaux (pas de domain)
- ❌ Logique métier mélangée avec l'infrastructure
- ❌ Difficile à tester

### Nouveau (`projects.ts`)
- ✅ Utilise des use-cases (Clean Architecture)
- ✅ Types du domain layer
- ✅ Séparation claire des responsabilités
- ✅ Facilement testable

## Table de correspondance

### Atoms d'état (inchangés)

| Ancien | Nouveau | Note |
|--------|---------|------|
| `projectsAtom` | `projectsAtom` | Même nom mais type `Project` du domain |
| `currentProjectIdAtom` | `currentProjectIdAtom` | Inchangé |
| `currentFileIdAtom` | `currentFileIdAtom` | Inchangé |

### Atoms dérivés (inchangés)

| Ancien | Nouveau | Note |
|--------|---------|------|
| `currentProjectAtom` | `currentProjectAtom` | Même logique |
| `currentFileAtom` | `currentFileAtom` | Même logique |
| `mainFileAtom` | `mainFileAtom` | Même logique |

### Actions (signature simplifiée)

| Ancien | Nouveau | Changements |
|--------|---------|-------------|
| `fetchProjectsAtom` | `fetchProjectsAtom` | Prend `userId` en paramètre |
| `createProjectAtom` | `createProjectAtom` | Paramètres simplifiés |
| `updateProjectAtom` | `updateProjectAtom` | Paramètres simplifiés |
| `deleteProjectAtom` | `deleteProjectAtom` | Paramètres simplifiés |
| - | `fetchProjectAtom` | Nouveau : récupère un projet par ID |
| - | `setCurrentProjectAtom` | Nouveau : helper pour changer de projet |
| - | `setCurrentFileAtom` | Nouveau : helper pour changer de fichier |

### Actions non migrées (TODO)

Ces actions de l'ancien store n'ont pas encore été migrées :

- `shareProjectAtom` / `unshareProjectAtom` - Partage (nécessite recherche utilisateur)

## Migration étape par étape

### 1. Importer depuis le nouveau store

```typescript
// ❌ Avant
import {
  projectsAtom,
  currentProjectAtom,
  fetchProjectsAtom,
  createProjectAtom
} from '@/store/projects-v2'

// ✅ Après
import {
  projectsAtom,
  currentProjectAtom,
  fetchProjectsAtom,
  createProjectAtom
} from '@/store/projects'
```

### 2. Adapter les appels aux actions

#### Fetch Projects

```typescript
// ❌ Avant
const fetchProjects = useSetAtom(fetchProjectsAtom)
await fetchProjects() // Récupère automatiquement le userId

// ✅ Après
const fetchProjects = useSetAtom(fetchProjectsAtom)
const { user } = useAuth()
await fetchProjects(user.id) // Doit passer le userId explicitement
```

#### Create Project

```typescript
// ❌ Avant
const createProject = useSetAtom(createProjectAtom)
await createProject({
  name: 'My Project',
  description: 'Description',
  visibility: 'private',
  isLibrary: false,
  tags: ['tag1'],
  // ... beaucoup d'options
})

// ✅ Après
const createProject = useSetAtom(createProjectAtom)
const { user } = useAuth()
await createProject({
  userId: user.id,
  name: 'My Project',
  visibility: 'private',
  files: [
    { name: 'main.asm', content: '', isMain: true }
  ]
})
```

#### Update Project

```typescript
// ❌ Avant
const updateProject = useSetAtom(updateProjectAtom)
await updateProject({
  id: project.id,
  name: 'New Name',
  description: 'New Description'
})

// ✅ Après
const updateProject = useSetAtom(updateProjectAtom)
const { user } = useAuth()
await updateProject({
  projectId: project.id,
  userId: user.id,
  name: 'New Name',
  description: 'New Description'
})
```

#### Delete Project

```typescript
// ❌ Avant
const deleteProject = useSetAtom(deleteProjectAtom)
await deleteProject(project.id)

// ✅ Après
const deleteProject = useSetAtom(deleteProjectAtom)
const { user } = useAuth()
await deleteProject({
  projectId: project.id,
  userId: user.id
})
```

### 3. Adapter les types

```typescript
// ❌ Avant (types locaux)
import type { Project, ProjectFile } from '@/store/projects-v2'

// ✅ Après (types du domain)
import type { Project } from '@/domain/entities/project.entity'
import type { ProjectFile } from '@/domain/entities/project-file.entity'
```

### 4. Accéder aux valeurs des Value Objects

Les nouveaux types utilisent des Value Objects pour garantir la validation :

```typescript
// ❌ Avant
const project = get(currentProjectAtom)
console.log(project.name) // string direct

// ✅ Après
const project = get(currentProjectAtom)
console.log(project.name.value) // Accès via .value

// Pareil pour les fichiers
const file = get(currentFileAtom)
console.log(file.name.value)
console.log(file.content.value)
```

#### Value Objects dans le JSX

**⚠️ Piège courant** : Oublier `.value` dans les templates JSX

```tsx
// ❌ INCORRECT - Affiche [object Object]
<span>{currentFile?.name}</span>

// ✅ CORRECT - Affiche le nom du fichier
<span>{currentFile?.name.value}</span>
```

**Exemples concrets dans les composants :**

```tsx
// Dans code-editor.tsx
// ❌ Avant
<span className={styles.title}>{currentFile?.name ?? 'Scratch'}</span>

// ✅ Après
<span className={styles.title}>
  {currentFile?.name.value ?? 'Scratch'}
</span>

// Dans project-browser.tsx
// ❌ Avant
<div className={styles.projectName}>{project.name}</div>

// ✅ Après  
<div className={styles.projectName}>{project.name.value}</div>

// Dans toolbar.tsx (compilation)
// ❌ Avant
const files = project.files.map(f => ({
  name: f.name,
  content: f.content
}))

// ✅ Après
const files = project.files.map(f => ({
  name: f.name.value,
  content: f.content.value
}))
```

#### Liste des Value Objects

| Propriété | Type | Accès |
|-----------|------|-------|
| `project.name` | `ProjectName` | `project.name.value` |
| `project.visibility` | `Visibility` | `project.visibility.value` |
| `file.name` | `FileName` | `file.name.value` |
| `file.content` | `FileContent` | `file.content.value` |

**Note** : Les propriétés suivantes restent des primitives :
- `project.id` (string)
- `project.userId` (string)
- `project.description` (string | null)
- `project.isLibrary` (boolean)
- `project.dependencies` (string[])
- `project.tags` (string[])
- `file.id` (string)
- `file.isMain` (boolean)
- `file.order` (number)


## Exemple complet de migration

### Avant

```typescript
import { useAtom, useSetAtom } from 'jotai'
import {
  projectsAtom,
  currentProjectAtom,
  fetchProjectsAtom,
  createProjectAtom,
  deleteProjectAtom
} from '@/store/projects-v2'

function ProjectList() {
  const [projects] = useAtom(projectsAtom)
  const fetchProjects = useSetAtom(fetchProjectsAtom)
  const createProject = useSetAtom(createProjectAtom)
  const deleteProject = useSetAtom(deleteProjectAtom)

  useEffect(() => {
    fetchProjects()
  }, [])

  const handleCreate = async () => {
    await createProject({
      name: 'New Project',
      visibility: 'private'
    })
  }

  const handleDelete = async (id: string) => {
    await deleteProject(id)
  }

  return (
    <div>
      {projects.map(p => (
        <div key={p.id}>
          <span>{p.name}</span>
          <button onClick={() => handleDelete(p.id)}>Delete</button>
        </div>
      ))}
    </div>
  )
}
```

### Après

```typescript
import { useAtom, useSetAtom } from 'jotai'
import {
  projectsAtom,
  currentProjectAtom,
  fetchProjectsAtom,
  createProjectAtom,
  deleteProjectAtom
} from '@/store/projects'
import { useAuth } from '@/hooks'

function ProjectList() {
  const [projects] = useAtom(projectsAtom)
  const { user } = useAuth()
  const fetchProjects = useSetAtom(fetchProjectsAtom)
  const createProject = useSetAtom(createProjectAtom)
  const deleteProject = useSetAtom(deleteProjectAtom)

  useEffect(() => {
    if (user) {
      fetchProjects(user.id)
    }
  }, [user])

  const handleCreate = async () => {
    if (!user) return
    
    await createProject({
      userId: user.id,
      name: 'New Project',
      visibility: 'private'
    })
  }

  const handleDelete = async (projectId: string) => {
    if (!user) return
    
    await deleteProject({
      projectId,
      userId: user.id
    })
  }

  return (
    <div>
      {projects.map(p => (
        <div key={p.id}>
          <span>{p.name.value}</span>
          <button onClick={() => handleDelete(p.id)}>Delete</button>
        </div>
      ))}
    </div>
  )
}
```

## Alternative : Utiliser les hooks React

Au lieu d'utiliser directement les atoms, vous pouvez utiliser les hooks React qui encapsulent la logique :

```typescript
import { useCreateProject, useGetProjects, useDeleteProject } from '@/hooks'
import { useAuth } from '@/hooks'

function ProjectList() {
  const { user } = useAuth()
  const { getProjects, loading: loadingProjects } = useGetProjects()
  const { create, loading: creating } = useCreateProject()
  const { deleteProject, loading: deleting } = useDeleteProject()
  
  const [projects, setProjects] = useState([])

  useEffect(() => {
    if (user) {
      loadProjects()
    }
  }, [user])

  const loadProjects = async () => {
    const result = await getProjects(user.id)
    setProjects(result.projects)
  }

  const handleCreate = async () => {
    await create({
      userId: user.id,
      name: 'New Project',
      visibility: 'private'
    })
    await loadProjects() // Refresh
  }

  const handleDelete = async (projectId: string) => {
    await deleteProject(projectId, user.id)
    await loadProjects() // Refresh
  }

  if (loadingProjects) return <div>Loading...</div>

  return (
    <div>
      <button onClick={handleCreate} disabled={creating}>
        Create Project
      </button>
      {projects.map(p => (
        <div key={p.id}>
          <span>{p.name.value}</span>
          <button 
            onClick={() => handleDelete(p.id)}
            disabled={deleting}
          >
            Delete
          </button>
        </div>
      ))}
    </div>
  )
}
```

## Checklist de migration

- [x] Remplacer l'import de `projects-v2` par `projects`
- [x] Ajouter `useAuth()` pour récupérer le `userId`
- [x] Passer `userId` aux actions qui en ont besoin
- [x] Adapter les signatures des fonctions (objets au lieu de paramètres positionnels)
- [x] Accéder aux valeurs via `.value` pour les Value Objects
- [x] Tester que tout fonctionne
- [x] Supprimer `projects-v2.ts` (1053 lignes supprimées !)
- [ ] (Optionnel) Migrer vers les hooks React pour plus de simplicité

## Composants migrés ✅

Tous les composants ont été migrés vers Clean Architecture :

- [x] `src/components/layout/project-browser.tsx`
- [x] `src/components/layout/toolbar.tsx`
- [x] `src/components/editor/code-editor.tsx`
- [x] `src/components/examples/examples-menu.tsx`
- [x] `src/components/layout/program-manager.tsx`
- [x] `src/components/project/project-settings-modal.tsx`
- [x] `src/hooks/use-auto-save-file.ts`

## ⚠️ Fonctionnalités temporairement désactivées

Certaines fonctionnalités ont été **commentées** en attendant l'implémentation des use-cases correspondants :

### Gestion des partages (Shares)

**Fichier** : `src/components/project/project-settings-modal.tsx`

**Code commenté** :
- État `shareUsername` (ligne ~50)
- Handlers `handleAddShare` et `handleRemoveShare` (lignes ~137-198)
- UI de gestion des partages dans le modal (lignes ~302-340)

**Comment réactiver** :
1. Créer les use-cases :
   - `src/use-cases/shares/add-share.use-case.ts`
   - `src/use-cases/shares/remove-share.use-case.ts`
2. Les ajouter au container DI
3. Créer les atoms dans le store
4. Décommenter le code dans project-settings-modal.tsx

### Recherche du code commenté

Pour trouver tout le code commenté lié à la migration :

```bash
# Rechercher les TODOs de réactivation
grep -rn "TODO.*Re-enable\|Temporarily disabled" src/

# Résultats actuels :
# src/components/project/project-settings-modal.tsx:50 - shareUsername state
# src/components/project/project-settings-modal.tsx:137 - share handlers
# src/components/project/project-settings-modal.tsx:302 - share UI
```

## Prochaines étapes

1. ~~Créer les use-cases pour les fichiers~~ ✅
2. ~~Migrer tous les composants~~ ✅
3. ~~Supprimer `projects-v2.ts`~~ ✅ 
4. ~~Créer les use-cases pour tags/dependencies~~ ✅
5. Créer les use-cases pour shares
6. Réactiver les fonctionnalités commentées (shares UI)
7. Célébrer ! 🎉
