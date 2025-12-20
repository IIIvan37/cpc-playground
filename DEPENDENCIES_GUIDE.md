# Guide des Dépendances de Projets

## Vue d'ensemble

Le système permet maintenant aux projets de dépendre d'autres projets. Cela permet de :
- Créer des **bibliothèques réutilisables** (projets utilitaires)
- Organiser le code en **modules séparés**
- Partager des **routines communes** entre plusieurs projets

## Concepts

### Projets Bibliothèques
Un projet peut être marqué comme "bibliothèque" (`is_library = true`) pour indiquer qu'il est destiné à être inclus dans d'autres projets plutôt que d'être compilé seul.

**Caractéristiques** :
- Pas forcément de point d'entrée (fichier main)
- Contient des routines, données ou macros réutilisables
- Peut être une dépendance de plusieurs projets

### Dépendances
Un projet peut déclarer d'autres projets comme dépendances. Lors de la compilation, tous les fichiers des dépendances sont automatiquement inclus.

**Résolution récursive** :
Si Projet A dépend de Projet B, et Projet B dépend de Projet C, alors tous les fichiers de A, B et C seront disponibles lors de la compilation de A.

## Structure de base de données

### Champ is_library sur projects
```sql
CREATE TABLE projects (
  ...
  is_library boolean DEFAULT false NOT NULL,
  ...
)
```

### Table project_dependencies
```sql
CREATE TABLE project_dependencies (
  project_id uuid,      -- Le projet qui dépend
  dependency_id uuid,   -- Le projet dépendance
  created_at timestamptz,
  PRIMARY KEY (project_id, dependency_id),
  CONSTRAINT no_self_dependency CHECK (project_id != dependency_id)
)
```

## Utilisation dans le code

### Marquer un projet comme bibliothèque

```typescript
// Lors de la création
const { data } = await supabase
  .from('projects')
  .insert({
    name: 'Math Routines',
    is_library: true,
    visibility: 'public' // Pour que d'autres puissent l'utiliser
  })

// Ou mise à jour
const { data } = await supabase
  .from('projects')
  .update({ is_library: true })
  .eq('id', projectId)
```

### Ajouter une dépendance

```typescript
import { useSetAtom } from 'jotai'
import { addDependencyToProjectAtom } from '@/store/projects-v2'

function AddDependencyButton({ projectId }) {
  const addDependency = useSetAtom(addDependencyToProjectAtom)
  
  const handleAdd = async (dependencyId: string) => {
    try {
      await addDependency({ projectId, dependencyId })
      console.log('Dependency added!')
    } catch (error) {
      console.error('Failed to add dependency:', error)
    }
  }
  
  return <button onClick={() => handleAdd('dep-uuid')}>Add Dependency</button>
}
```

### Retirer une dépendance

```typescript
import { useSetAtom } from 'jotai'
import { removeDependencyFromProjectAtom } from '@/store/projects-v2'

function DependenciesList({ project }) {
  const removeDependency = useSetAtom(removeDependencyFromProjectAtom)
  
  const handleRemove = async (dependencyId: string) => {
    try {
      await removeDependency({ projectId: project.id, dependencyId })
      console.log('Dependency removed!')
    } catch (error) {
      console.error('Failed to remove dependency:', error)
    }
  }
  
  return (
    <ul>
      {project.dependencies?.map((dep) => (
        <li key={dep.id}>
          {dep.name} {dep.isLibrary && '(Library)'}
          <button onClick={() => handleRemove(dep.id)}>Remove</button>
        </li>
      ))}
    </ul>
  )
}
```

### Récupérer tous les fichiers avec dépendances

```typescript
import { useSetAtom } from 'jotai'
import { fetchProjectWithDependenciesAtom } from '@/store/projects-v2'

function CompileButton({ projectId }) {
  const fetchWithDeps = useSetAtom(fetchProjectWithDependenciesAtom)
  
  const handleCompile = async () => {
    // Récupère tous les fichiers du projet + dépendances (récursif)
    const allFiles = await fetchWithDeps(projectId)
    
    console.log(`Found ${allFiles.length} files including dependencies`)
    // ... compiler avec tous les fichiers
  }
  
  return <button onClick={handleCompile}>Compile</button>
}
```

## Compilation automatique

Le système de compilation a été modifié pour inclure automatiquement les dépendances :

```typescript
// Dans toolbar.tsx
const handleCompileAndRun = async () => {
  if (currentProject && currentFile) {
    // Récupère TOUS les fichiers (projet + dépendances)
    const allFiles = await fetchProjectWithDependencies(currentProject.id)
    
    // Filtre le fichier actuel
    const additionalFiles = allFiles
      .filter(f => f.id !== currentFile.id)
      .map(f => ({ name: f.name, content: f.content }))
    
    // Compile avec tous les fichiers
    await compile(code, outputFormat, additionalFiles)
  }
}
```

## Exemples d'utilisation

### Exemple 1 : Bibliothèque de routines mathématiques

**math-lib** (is_library: true)
```asm
; math.asm
multiply16:
    ; Multiplication 16-bit
    ; HL = BC * DE
    ...
    ret

divide16:
    ; Division 16-bit
    ; HL = BC / DE
    ...
    ret
```

**mon-jeu** (dépend de math-lib)
```asm
; main.asm
    INCLUDE "math.asm"
    
start:
    ld bc, 100
    ld de, 25
    call multiply16
    ; HL contient maintenant 2500
    ret
```

### Exemple 2 : Bibliothèque graphique + Jeu

**sprite-lib** (is_library: true)
- sprite-draw.asm
- sprite-collision.asm
- sprite-animation.asm

**physics-lib** (is_library: true, dépend de sprite-lib)
- physics-gravity.asm
- physics-bounce.asm

**platformer-game** (dépend de physics-lib)
- main.asm
- level-data.asm
- player.asm

Lors de la compilation de **platformer-game**, TOUS les fichiers de physics-lib et sprite-lib seront automatiquement inclus.

## Permissions et visibilité

### Règles d'accès
Pour ajouter un projet comme dépendance, l'utilisateur doit avoir accès au projet :
- Projets **publics** : Accessibles à tous comme dépendances
- Projets **privés** : Seulement si on en est le propriétaire
- Projets **partagés** : Si on a un accès partagé

### RLS Policies
```sql
-- Les utilisateurs peuvent voir les dépendances des projets auxquels ils ont accès
create policy "Anyone can view dependencies of visible projects"
  on project_dependencies for select
  using (
    exists (
      select 1 from projects
      where projects.id = project_dependencies.project_id
      and (
        projects.user_id = auth.uid()
        or projects.visibility = 'public'
        or projects.visibility = 'shared' with access
      )
    )
  );
```

## API du store

### Nouveaux atoms et actions

```typescript
// Ajouter une dépendance à un projet
addDependencyToProjectAtom: SetAtom<
  { projectId: string; dependencyId: string },
  Promise<void>
>

// Retirer une dépendance
removeDependencyFromProjectAtom: SetAtom<
  { projectId: string; dependencyId: string },
  Promise<void>
>

// Récupérer tous les fichiers (avec dépendances récursives)
fetchProjectWithDependenciesAtom: SetAtom<
  string, // projectId
  Promise<ProjectFile[]>
>
```

### Types

```typescript
interface ProjectDependency {
  id: string
  name: string
  isLibrary: boolean
}

interface Project {
  // ... autres champs
  isLibrary: boolean
  dependencies?: ProjectDependency[]
}
```

## Prochaines étapes UI

### Fonctionnalités à implémenter

1. **Badge "Library"** sur les projets bibliothèques
2. **Sélecteur de dépendances** avec recherche/filtrage
3. **Graphe de dépendances** pour visualiser les relations
4. **Détection de cycles** pour éviter les dépendances circulaires
5. **Marketplace** de bibliothèques publiques populaires
6. **Versionning** des dépendances (future enhancement)
7. **Import/Export** de collections de bibliothèques

### UI suggérée pour gérer les dépendances

```tsx
function ProjectDependencies({ project }) {
  return (
    <div>
      <h3>Dependencies</h3>
      
      {/* Liste des dépendances actuelles */}
      <ul>
        {project.dependencies?.map(dep => (
          <li key={dep.id}>
            📚 {dep.name}
            {dep.isLibrary && <span className="badge">Library</span>}
            <button onClick={() => removeDep(dep.id)}>Remove</button>
          </li>
        ))}
      </ul>
      
      {/* Ajouter une nouvelle dépendance */}
      <button onClick={() => setShowAddDialog(true)}>
        + Add Dependency
      </button>
      
      {/* Dialog de sélection */}
      {showAddDialog && (
        <DependencyPicker
          onSelect={(depId) => addDep(depId)}
          filter="library" // Montrer uniquement les bibliothèques
        />
      )}
    </div>
  )
}
```

## Limitations et considérations

### Dépendances circulaires
Le système détecte et empêche les auto-références directes (`A -> A`), mais ne détecte pas encore les cycles indirects (`A -> B -> C -> A`). À implémenter côté client.

### Performance
La résolution récursive des dépendances peut être coûteuse pour des graphes profonds. Considérer :
- Mise en cache des résultats
- Limitation de la profondeur de résolution
- Indicateur de progression pour la compilation

### Namespaces
Tous les fichiers sont inclus dans le même namespace RASM. Pour éviter les conflits :
- Utiliser des préfixes sur les labels (`lib_multiply16` au lieu de `multiply16`)
- Documenter les exports publics de chaque bibliothèque
- Considérer un système de préfixe automatique (future enhancement)

## Cas d'usage avancés

### Bibliothèque multi-niveaux
```
base-lib (routines de base)
  └─ graphics-lib (dépend de base-lib)
      └─ game-engine (dépend de graphics-lib)
          └─ mon-jeu (dépend de game-engine)
```

### Bibliothèques spécialisées
- **cpc-lib** : Routines système CPC
- **vdu-lib** : Gestion firmware VDU
- **music-lib** : Player de musique
- **compression-lib** : Compression/décompression
- **fixed-point-lib** : Arithmétique virgule fixe

Ces bibliothèques peuvent être rendues publiques pour être utilisées par la communauté !
