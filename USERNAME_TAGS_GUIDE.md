# Guide des Usernames et Tags

## Vue d'ensemble

Deux nouvelles fonctionnalités ont été ajoutées au système :

1. **Usernames** : Chaque utilisateur a maintenant un nom d'utilisateur unique
2. **Tags** : Les projets peuvent être organisés avec des tags/étiquettes

## Usernames

### Création automatique
Lorsqu'un utilisateur s'inscrit, un username est automatiquement généré :
- À partir de son email (partie avant le @)
- Ou un username aléatoire `user_XXXXXXXX` si l'email n'est pas disponible

### Contraintes
- **Longueur** : Entre 3 et 30 caractères
- **Format** : Uniquement lettres minuscules, chiffres, tirets et underscores (`a-z0-9_-`)
- **Unicité** : Chaque username doit être unique dans le système

### Utilisation dans le code

```typescript
import { useUserProfile } from '@/hooks'

function ProfileSettings() {
  const { profile, loading, updateUsername } = useUserProfile()
  
  if (loading) return <div>Loading...</div>
  
  return (
    <div>
      <p>Username: {profile?.username}</p>
      <button onClick={() => updateUsername('new-username')}>
        Change Username
      </button>
    </div>
  )
}
```

### API du hook useUserProfile

```typescript
const {
  profile,        // UserProfile | null - Le profil de l'utilisateur
  loading,        // boolean - État de chargement
  error,          // Error | null - Erreur éventuelle
  updateUsername  // (username: string) => Promise<void> - Mettre à jour le username
} = useUserProfile()
```

## Tags

### Fonctionnalités
- Les tags sont **partagés globalement** : tous les utilisateurs peuvent utiliser les mêmes tags
- Les tags sont **normalisés automatiquement** : convertis en minuscules avec tirets
- Un projet peut avoir **plusieurs tags**
- Les tags sont créés automatiquement s'ils n'existent pas

### Contraintes
- **Longueur** : Entre 2 et 30 caractères
- **Format** : Uniquement lettres minuscules, chiffres et tirets (`a-z0-9-`)
- **Unicité** : Chaque nom de tag doit être unique

### Utilisation dans le code

#### Récupérer tous les tags

```typescript
import { useAtomValue, useSetAtom } from 'jotai'
import { tagsAtom, fetchTagsAtom } from '@/store/projects-v2'

function TagList() {
  const tags = useAtomValue(tagsAtom)
  const fetchTags = useSetAtom(fetchTagsAtom)
  
  useEffect(() => {
    fetchTags()
  }, [fetchTags])
  
  return (
    <ul>
      {tags.map(tag => (
        <li key={tag.id}>{tag.name}</li>
      ))}
    </ul>
  )
}
```

#### Ajouter un tag à un projet

```typescript
import { useSetAtom } from 'jotai'
import { addTagToProjectAtom } from '@/store/projects-v2'

function AddTagButton({ projectId }) {
  const addTag = useSetAtom(addTagToProjectAtom)
  const [tagName, setTagName] = useState('')
  
  const handleAdd = async () => {
    try {
      await addTag({ projectId, tagName })
      setTagName('')
    } catch (error) {
      console.error('Failed to add tag:', error)
    }
  }
  
  return (
    <div>
      <input 
        value={tagName}
        onChange={(e) => setTagName(e.target.value)}
        placeholder="Enter tag name"
      />
      <button onClick={handleAdd}>Add Tag</button>
    </div>
  )
}
```

#### Retirer un tag d'un projet

```typescript
import { useSetAtom } from 'jotai'
import { removeTagFromProjectAtom } from '@/store/projects-v2'

function ProjectTags({ project }) {
  const removeTag = useSetAtom(removeTagFromProjectAtom)
  
  const handleRemove = async (tagId: string) => {
    try {
      await removeTag({ projectId: project.id, tagId })
    } catch (error) {
      console.error('Failed to remove tag:', error)
    }
  }
  
  return (
    <div>
      {project.tags?.map(tag => (
        <span key={tag.id}>
          {tag.name}
          <button onClick={() => handleRemove(tag.id)}>×</button>
        </span>
      ))}
    </div>
  )
}
```

## Migration de la base de données

### 1. Sauvegarder les données existantes (si nécessaire)

Si vous avez déjà des projets en production, sauvegardez d'abord vos données :

```sql
-- Sauvegarder les projets
CREATE TABLE projects_backup AS SELECT * FROM projects;
-- Sauvegarder les fichiers
CREATE TABLE project_files_backup AS SELECT * FROM project_files;
```

### 2. Supprimer les anciennes tables

```sql
DROP TABLE IF EXISTS project_shares CASCADE;
DROP TABLE IF EXISTS project_files CASCADE;
DROP TABLE IF EXISTS projects CASCADE;
DROP TYPE IF EXISTS project_visibility CASCADE;
```

### 3. Exécuter la nouvelle migration

Copiez et exécutez le contenu complet de `supabase/migrations/001_initial_schema.sql` dans le SQL Editor de Supabase.

### 4. Restaurer les données (si nécessaire)

```sql
-- Restaurer les projets (ajuster les colonnes selon vos besoins)
INSERT INTO projects (id, user_id, name, description, visibility, created_at, updated_at)
SELECT id, user_id, name, description, 'private', created_at, updated_at
FROM projects_backup;

-- Restaurer les fichiers
INSERT INTO project_files 
SELECT * FROM project_files_backup;
```

### 5. Créer des profils pour les utilisateurs existants

```sql
-- Créer des profils pour tous les utilisateurs existants
INSERT INTO user_profiles (id, username)
SELECT 
  id,
  COALESCE(
    regexp_replace(split_part(email, '@', 1), '[^a-z0-9_-]', '', 'gi'),
    'user_' || substring(id::text, 1, 8)
  )
FROM auth.users
WHERE id NOT IN (SELECT id FROM user_profiles);
```

## Structure de données

### Table user_profiles

```sql
CREATE TABLE user_profiles (
  id uuid PRIMARY KEY,              -- Référence à auth.users
  username text UNIQUE NOT NULL,    -- Username unique
  created_at timestamptz,
  updated_at timestamptz
)
```

### Table tags

```sql
CREATE TABLE tags (
  id uuid PRIMARY KEY,
  name text UNIQUE NOT NULL,        -- Nom du tag (normalisé)
  created_at timestamptz
)
```

### Table project_tags

```sql
CREATE TABLE project_tags (
  project_id uuid,                  -- Référence à projects
  tag_id uuid,                      -- Référence à tags
  created_at timestamptz,
  PRIMARY KEY (project_id, tag_id)
)
```

## API du store

### Tags Atoms

```typescript
// Atom contenant tous les tags
tagsAtom: Atom<Tag[]>

// Récupérer tous les tags depuis la base de données
fetchTagsAtom: SetAtom<void, Promise<Tag[]>>

// Créer ou récupérer un tag existant (normalisé automatiquement)
getOrCreateTagAtom: SetAtom<string, Promise<Tag>>

// Ajouter un tag à un projet
addTagToProjectAtom: SetAtom<{ projectId: string; tagName: string }, Promise<void>>

// Retirer un tag d'un projet
removeTagFromProjectAtom: SetAtom<{ projectId: string; tagId: string }, Promise<void>>
```

## Prochaines étapes pour l'UI

### Pour les Usernames
1. Ajouter une section "Profil" dans les paramètres
2. Permettre la modification du username
3. Afficher le username dans l'en-tête à côté de l'email
4. Afficher le username du propriétaire sur les projets publics/partagés

### Pour les Tags
1. Ajouter un sélecteur de tags lors de la création/modification de projet
2. Afficher les tags sur chaque projet dans la liste
3. Ajouter un filtre par tags dans la liste des projets
4. Créer une page de navigation par tags
5. Afficher un nuage de tags (tag cloud) avec les tags populaires
6. Auto-complétion des tags existants lors de la saisie

## Exemples d'utilisation

### Tags suggérés
- `tutorial` - Projets tutoriels
- `game` - Jeux
- `demo` - Démonstrations
- `graphics` - Graphismes/sprites
- `sound` - Musique/effets sonores
- `utility` - Outils/utilitaires
- `3d` - Effets 3D
- `raster` - Effets raster
- `sprite` - Manipulation de sprites

### Cas d'usage
- **Organiser ses projets** : Tagger ses projets par type/catégorie
- **Découvrir du contenu** : Naviguer dans les projets publics par tags
- **Filtrer rapidement** : Trouver tous ses projets "game" ou "tutorial"
- **Partager des collections** : Créer une collection de projets avec un tag commun
