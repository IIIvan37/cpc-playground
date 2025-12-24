# Migration Jotai → React Query

## Objectif

Établir **React Query comme unique source de vérité** pour les données serveur, en gardant Jotai uniquement pour l'état UI (sélections, navigation, préférences locales).

## Principe

| Type de donnée | Outil | Raison |
|----------------|-------|--------|
| **Server state** (données DB/API) | React Query | Cache, invalidation, refetch automatique |
| **UI state** (sélection, navigation) | Jotai | État local, synchrone, pas de persistance serveur |
| **Persistance locale** | Jotai + localStorage | Préférences utilisateur |

---

## État actuel des stores

### 📁 `store/projects.ts`

| Atom | Type | Action |
|------|------|--------|
| `projectsAtom` | Server state | ❌ **SUPPRIMER** → `useQuery(['projects', userId])` |
| `currentProjectIdAtom` | UI state | ✅ GARDER |
| `currentFileIdAtom` | UI state | ✅ GARDER |
| `viewOnlyProjectAtom` | Server state | ❌ **SUPPRIMER** → `useQuery(['project', projectId])` |
| `isReadOnlyModeAtom` | UI state | ✅ GARDER |
| `currentProjectAtom` (derived) | Server state | ❌ **SUPPRIMER** → hook React Query |
| `activeProjectAtom` (derived) | Server state | ❌ **SUPPRIMER** → hook React Query |
| `currentFileAtom` (derived) | Server state | ❌ **SUPPRIMER** → hook React Query |
| `mainFileAtom` (derived) | Server state | ❌ **SUPPRIMER** → hook React Query |
| `dependencyFilesAtom` | Server state | ❌ **SUPPRIMER** → `useQuery(['dependencies', projectId])` |

### 📁 `store/programs.ts`

| Atom | Type | Action |
|------|------|--------|
| `savedProgramsAtom` | Server state (localStorage) | ⚠️ **MIGRER** → `useQuery(['programs'])` |
| `currentProgramIdAtom` | UI state | ✅ GARDER |
| `currentProgramAtom` (derived) | Server state | ❌ **SUPPRIMER** → hook React Query |
| `fetchProgramsAtom` (action) | - | ❌ **SUPPRIMER** → mutation |
| `saveProgramAtom` (action) | - | ❌ **SUPPRIMER** → mutation |
| `deleteProgramAtom` (action) | - | ❌ **SUPPRIMER** → mutation |

### 📁 `store/emulator.ts`

| Atom | Type | Action |
|------|------|--------|
| `emulatorReadyAtom` | UI state | ✅ GARDER |
| `emulatorRunningAtom` | UI state | ✅ GARDER |
| `emulatorInstanceAtom` | UI state | ✅ GARDER |
| `viewModeAtom` | UI state | ✅ GARDER |

### 📁 `store/editor.ts`

| Atom | Type | Action |
|------|------|--------|
| `codeAtom` | UI state (buffer) | ✅ GARDER |
| `selectedAssemblerAtom` | UI state | ✅ GARDER |
| `currentFileNameAtom` (derived) | Derived from server | ⚠️ **REFACTORER** → dériver du hook React Query |
| `isMarkdownFileAtom` (derived) | Derived | ⚠️ **REFACTORER** |

### 📁 `hooks/auth/use-auth.ts`

| Atom | Type | Action |
|------|------|--------|
| `userAtom` | Server state | ❌ **SUPPRIMER** → `useQuery(['auth', 'currentUser'])` uniquement |

---

## Plan de migration

### Phase 1 : Créer les hooks React Query ✅ (Partiellement fait)

- [x] `useGetProject` - récupère un projet par ID
- [x] `useUpdateProject` - mutation pour update
- [x] `useDeleteProject` - mutation pour delete
- [ ] `useUserProjects` - liste des projets de l'utilisateur
- [ ] `useCurrentProject` - projet courant basé sur `currentProjectIdAtom`
- [ ] `useCurrentFile` - fichier courant
- [ ] `usePrograms` - programmes localStorage
- [ ] `useCurrentProgram` - programme courant

### Phase 2 : Migrer `store/projects.ts`

#### 2.1 Supprimer `projectsAtom`

**Avant :**
```typescript
const projects = useAtomValue(projectsAtom)
```

**Après :**
```typescript
const { data: projects } = useUserProjects(userId)
```

**Fichiers impactés :**
- [ ] `src/components/project/project-selector/project-selector.tsx`
- [ ] `src/components/project/file-browser/file-browser.tsx`
- [ ] `src/components/project/project-settings-modal/project-settings-modal.tsx`
- [ ] `src/hooks/projects/use-projects.ts`
- [ ] `src/hooks/projects/use-dependencies.ts`

#### 2.2 Supprimer `currentProjectAtom` et `activeProjectAtom`

**Avant :**
```typescript
const currentProject = useAtomValue(currentProjectAtom)
const activeProject = useAtomValue(activeProjectAtom)
```

**Après :**
```typescript
const { project, isLoading } = useCurrentProject()
const { activeProject, isReadOnly } = useActiveProject()
```

**Fichiers impactés :**
- [ ] `src/components/project/file-browser/file-browser.tsx`
- [ ] `src/components/editor/code-editor/code-editor.tsx`
- [ ] `src/components/console/console.tsx`
- [ ] `src/store/editor.ts`

#### 2.3 Supprimer `viewOnlyProjectAtom`

**Avant :**
```typescript
setViewOnlyProject(project)
const viewOnlyProject = useAtomValue(viewOnlyProjectAtom)
```

**Après :**
```typescript
// Le projet est dans le cache React Query avec sa clé
const { data: project } = useQuery(['project', projectId])
// isReadOnly déterminé par comparaison userId
```

#### 2.4 Supprimer `dependencyFilesAtom`

**Avant :**
```typescript
const dependencyFiles = useAtomValue(dependencyFilesAtom)
setDependencyFiles(files)
```

**Après :**
```typescript
const { data: dependencyFiles } = useQuery({
  queryKey: ['dependencies', projectId],
  queryFn: () => fetchDependencyFiles(projectId)
})
```

### Phase 3 : Migrer `hooks/auth/use-auth.ts`

**Avant :**
```typescript
const [user, setUser] = useAtom(userAtom)
// + sync manuel avec React Query
```

**Après :**
```typescript
const { data: user } = useQuery({
  queryKey: ['auth', 'currentUser'],
  queryFn: getCurrentUser,
  staleTime: Infinity
})
// Plus besoin de userAtom ni de sync
```

### Phase 4 : Migrer `store/programs.ts`

**Avant :**
```typescript
const programs = useAtomValue(savedProgramsAtom)
set(savedProgramsAtom, programs)
```

**Après :**
```typescript
const { data: programs } = useQuery({
  queryKey: ['programs'],
  queryFn: () => programsContainer.getPrograms.execute()
})
```

### Phase 5 : Refactorer `store/editor.ts`

Les atoms dérivés (`currentFileNameAtom`, `isMarkdownFileAtom`) dépendent de `activeProjectAtom`.

**Solution :** Créer des hooks qui dérivent directement des données React Query.

```typescript
function useCurrentFileName() {
  const { activeProject } = useActiveProject()
  const currentFileId = useAtomValue(currentFileIdAtom)
  
  if (!activeProject || !currentFileId) return null
  const file = activeProject.files.find(f => f.id === currentFileId)
  return file?.name.value ?? null
}
```

---

## Nouvelle architecture proposée

### Hooks React Query (server state)

```
src/hooks/
├── auth/
│   └── use-auth.ts           # useQuery(['auth', 'currentUser'])
├── projects/
│   ├── use-user-projects.ts  # useQuery(['projects', userId])
│   ├── use-project.ts        # useQuery(['project', projectId])
│   ├── use-current-project.ts # Combine projectId atom + React Query
│   ├── use-active-project.ts  # Combine isReadOnly + project
│   └── use-dependencies.ts   # useQuery(['dependencies', projectId])
└── programs/
    └── use-programs.ts       # useQuery(['programs'])
```

### Atoms Jotai (UI state uniquement)

```
src/store/
├── projects.ts
│   ├── currentProjectIdAtom   # string | null
│   ├── currentFileIdAtom      # string | null
│   └── isReadOnlyModeAtom     # boolean
├── emulator.ts                # Inchangé (tout est UI state)
└── editor.ts
    ├── codeAtom               # Buffer d'édition
    └── selectedAssemblerAtom  # Préférence utilisateur
```

---

## Journal de migration

### 2024-12-24

- [x] Optimisation JOINs Supabase dans `findById`, `findAll`, `findVisible`
- [x] `ProjectSettingsModal` lit depuis React Query au lieu de Jotai
- [x] Fix `useDeleteProject` : `removeQueries` au lieu de `invalidateQueries`
- [x] Création du document de migration
- [x] Création de `useUserProjects` hook (remplace `projectsAtom`)
- [x] Création de `useCurrentProject` hook (remplace `currentProjectAtom`)
- [x] Création de `useActiveProject` hook (remplace `activeProjectAtom`)
- [x] Création de `useCurrentFile` hook (remplace `currentFileAtom`)
- [x] Création de `useMainFile` hook (remplace `mainFileAtom`)
- [x] Création de `useAvailableDependencies` hook
- [x] Migration de `ProjectSettingsModal` vers les nouveaux hooks

### À faire

- [ ] Migrer `ProjectSelector` vers `useUserProjects`
- [ ] Migrer `FileBrowser` vers `useActiveProject`
- [ ] Migrer `useFetchDependencyFiles` vers `useUserProjects`
- [ ] Migrer `use-files.ts` vers nouveaux hooks
- [ ] Phase 3 : Simplifier `use-auth.ts`
- [ ] Phase 4 : Migrer programs
- [ ] Phase 5 : Refactorer editor.ts
- [ ] Supprimer atoms obsolètes (`projectsAtom`, `currentProjectAtom`, etc.)
- [ ] Tests de non-régression

---

## Checklist de validation

Pour chaque composant migré :

- [ ] Pas de double source de vérité
- [ ] Loading states gérés
- [ ] Error states gérés  
- [ ] Invalidation correcte après mutations
- [ ] Pas de requêtes en doublon (vérifier Network tab)
- [ ] Tests passent
