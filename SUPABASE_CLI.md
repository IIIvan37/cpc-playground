# Supabase CLI Guide

Ce document explique comment utiliser Supabase CLI pour gérer les migrations et les types.

## Installation

```bash
brew install supabase/tap/supabase
```

## Authentification

```bash
supabase login
```

## Lier le projet

Le projet est déjà lié, mais si vous devez le refaire :

```bash
supabase link --project-ref aameevxocpvxpifmrwia
```

## Créer une nouvelle migration

```bash
supabase migration new nom_de_la_migration
```

Cela créera un fichier dans `supabase/migrations/` avec un timestamp.

## Appliquer les migrations

Pour appliquer toutes les migrations en attente sur la base de données distante :

```bash
supabase db push
```

## Lister les migrations

```bash
supabase migration list
```

Affiche toutes les migrations locales et distantes avec leur statut.

## Récupérer le schéma distant

Pour récupérer le schéma actuel de la base de données distante :

```bash
supabase db pull
```

Cela créera une nouvelle migration avec les changements détectés.

## Générer les types TypeScript

Après chaque changement de schéma, générez les types TypeScript :

```bash
supabase gen types typescript --linked > src/types/database-generated.ts
```

Ces types sont ensuite utilisés dans `src/types/database.ts` pour créer les interfaces de l'application.

## Réparer l'historique des migrations

Si vous rencontrez des problèmes avec l'historique des migrations :

```bash
# Marquer une migration comme appliquée
supabase migration repair --status applied <timestamp>

# Marquer une migration comme non appliquée
supabase migration repair --status reverted <timestamp>
```

## Workflow recommandé

1. **Développement local**
   ```bash
   # Créer une nouvelle migration
   supabase migration new add_new_feature
   
   # Éditer le fichier SQL dans supabase/migrations/
   # Appliquer en local si vous utilisez supabase start
   supabase db reset
   ```

2. **Test et validation**
   ```bash
   # Générer les types pour vérifier la cohérence
   supabase gen types typescript --linked > src/types/database-generated.ts
   
   # Tester l'application
   ```

3. **Déploiement**
   ```bash
   # Appliquer sur la base distante
   supabase db push
   
   # Commit les fichiers
   git add supabase/migrations/ src/types/database-generated.ts
   git commit -m "feat: add new feature migration"
   ```

## Structure de la base de données

### Tables principales

- **user_profiles** : Profils utilisateurs étendant auth.users
- **tags** : Tags globaux partagés pour les projets
- **projects** : Projets avec visibilité et dépendances
- **project_files** : Fichiers d'assembleur dans les projets
- **project_shares** : Partage de projets avec des utilisateurs spécifiques
- **project_tags** : Relation many-to-many entre projets et tags
- **project_dependencies** : Dépendances entre projets (pour les librairies)

### Politiques RLS

Toutes les tables ont des politiques Row Level Security (RLS) activées pour garantir :
- Les utilisateurs ne peuvent modifier que leurs propres données
- Les projets publics sont lisibles par tous
- Les projets partagés sont lisibles par les utilisateurs autorisés
- Les dépendances ne peuvent pointer que vers des projets accessibles

## Troubleshooting

### Erreur "migration history does not match"

Si l'historique des migrations ne correspond pas :

```bash
supabase migration repair --status applied <timestamp>
```

### Erreur "relation already exists"

Cela signifie que la table existe déjà. Marquez la migration comme appliquée :

```bash
supabase migration repair --status applied <timestamp>
```

### Régénérer tous les types

```bash
supabase gen types typescript --linked > src/types/database-generated.ts
```
