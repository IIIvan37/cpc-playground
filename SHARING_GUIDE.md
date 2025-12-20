# Guide de partage de projets

## Vue d'ensemble

Le système de projets supporte maintenant trois niveaux de visibilité :

- **Private** (Privé) : Seul le propriétaire peut voir et modifier le projet
- **Public** : Tout le monde peut voir le projet (lecture seule pour les autres)
- **Shared** (Partagé) : Seuls les utilisateurs spécifiquement invités peuvent voir le projet (lecture seule)

## Niveaux de visibilité

### Private (par défaut)
- Le projet n'est visible que par son propriétaire
- Personne d'autre ne peut le voir dans sa liste de projets
- Idéal pour les projets en développement ou personnels

### Public
- Le projet est visible par tous les utilisateurs authentifiés
- Les autres utilisateurs peuvent voir les fichiers et le code
- Seul le propriétaire peut modifier le projet
- Idéal pour partager des exemples, des tutoriels ou des démonstrations

### Shared
- Le projet est visible uniquement par les utilisateurs spécifiquement invités
- Le propriétaire peut ajouter/retirer des utilisateurs via leur email
- Les utilisateurs partagés ont accès en lecture seule
- Idéal pour la collaboration en équipe restreinte

## Migration de la base de données

Pour ajouter le support du partage à votre instance Supabase existante, vous devez :

1. **Supprimer l'ancienne migration** (si elle a déjà été exécutée) :
   ```sql
   -- Dans le SQL Editor de Supabase
   DROP TABLE IF EXISTS project_files CASCADE;
   DROP TABLE IF EXISTS projects CASCADE;
   ```

2. **Exécuter la nouvelle migration** :
   - Ouvrez le SQL Editor dans votre dashboard Supabase
   - Copiez le contenu de `supabase/migrations/001_initial_schema.sql`
   - Exécutez la requête

3. **Vérifier les tables créées** :
   ```sql
   SELECT table_name 
   FROM information_schema.tables 
   WHERE table_schema = 'public' 
   AND table_name IN ('projects', 'project_files', 'project_shares');
   ```

## Utilisation dans le code

### Changer la visibilité d'un projet

```typescript
import { useSetAtom } from 'jotai'
import { updateProjectVisibilityAtom } from '@/store/projects-v2'

function ProjectSettings({ projectId }) {
  const updateVisibility = useSetAtom(updateProjectVisibilityAtom)
  
  const handleChangeVisibility = async (visibility: 'private' | 'public' | 'shared') => {
    try {
      await updateVisibility({ projectId, visibility })
      console.log('Visibility updated!')
    } catch (error) {
      console.error('Failed to update visibility:', error)
    }
  }
  
  return (
    <select onChange={(e) => handleChangeVisibility(e.target.value)}>
      <option value="private">Private</option>
      <option value="public">Public</option>
      <option value="shared">Shared</option>
    </select>
  )
}
```

### Partager un projet avec un utilisateur

```typescript
import { useSetAtom } from 'jotai'
import { shareProjectAtom } from '@/store/projects-v2'

function ShareProjectDialog({ projectId }) {
  const shareProject = useSetAtom(shareProjectAtom)
  const [email, setEmail] = useState('')
  
  const handleShare = async () => {
    try {
      await shareProject({ projectId, userEmail: email })
      console.log('Project shared!')
    } catch (error) {
      console.error('Failed to share project:', error)
    }
  }
  
  return (
    <div>
      <input 
        type="email" 
        value={email} 
        onChange={(e) => setEmail(e.target.value)}
        placeholder="user@example.com"
      />
      <button onClick={handleShare}>Share</button>
    </div>
  )
}
```

### Retirer l'accès d'un utilisateur

```typescript
import { useSetAtom } from 'jotai'
import { unshareProjectAtom } from '@/store/projects-v2'

function SharedUsersList({ project }) {
  const unshareProject = useSetAtom(unshareProjectAtom)
  
  const handleUnshare = async (shareId: string) => {
    try {
      await unshareProject({ projectId: project.id, shareId })
      console.log('Access removed!')
    } catch (error) {
      console.error('Failed to remove access:', error)
    }
  }
  
  return (
    <ul>
      {project.shares?.map((share) => (
        <li key={share.id}>
          User ID: {share.userId}
          <button onClick={() => handleUnshare(share.id)}>Remove</button>
        </li>
      ))}
    </ul>
  )
}
```

## Permissions

### Lecture (SELECT)
- **Private** : Seul le propriétaire
- **Public** : Tous les utilisateurs authentifiés
- **Shared** : Le propriétaire + utilisateurs invités

### Écriture (INSERT/UPDATE/DELETE)
- **Tous les niveaux** : Seul le propriétaire peut modifier les projets et fichiers

### Partage (project_shares)
- **Tous les niveaux** : Seul le propriétaire peut ajouter/retirer des partages

## Prochaines étapes pour l'UI

Pour compléter cette fonctionnalité, vous pourriez ajouter :

1. **Un sélecteur de visibilité** dans les paramètres du projet
2. **Une modale de partage** pour inviter des utilisateurs par email
3. **Une liste des utilisateurs partagés** avec bouton de révocation
4. **Un badge de visibilité** dans la liste des projets (🔒 Private, 🌍 Public, 👥 Shared)
5. **Une section "Projets partagés avec moi"** séparée des projets personnels
6. **Des notifications** quand un projet est partagé avec vous

## Limitations actuelles

- Les utilisateurs partagés ont uniquement accès en lecture
- Pour identifier un utilisateur, il faut connaître son email
- Pas de système de notification intégré pour les invitations
- Les projets publics sont visibles par tous les utilisateurs authentifiés (pas de liste publique globale)

## Sécurité

Les Row Level Security (RLS) policies garantissent que :
- Un utilisateur ne peut pas lire les projets privés d'autrui
- Un utilisateur ne peut pas modifier un projet dont il n'est pas propriétaire
- Un utilisateur ne peut pas partager un projet dont il n'est pas propriétaire
- Les partages ne peuvent être créés que par les propriétaires de projets
