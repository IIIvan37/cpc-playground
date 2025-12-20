# Multi-Environment Setup Guide

Ce projet supporte 3 environnements distincts, chacun avec son propre projet Supabase et sa configuration GitHub OAuth.

## Environnements

| Environnement | Commande | Fichier env | Usage |
|--------------|----------|-------------|-------|
| **Local** | `pnpm dev` | `.env.local` | Développement local avec Supabase local |
| **Test** | `pnpm dev:test` | `.env.test` | Tests et staging |
| **Production** | `pnpm dev:prod` | `.env.production` | Production |

## Configuration

### 1. Environnement Local

Utilise Supabase en local via Docker.

```bash
# Démarrer Supabase local
supabase start

# Copier le fichier exemple
cp .env.local.example .env.local

# Les valeurs par défaut fonctionnent avec supabase start
```

**GitHub OAuth pour local:**
- Créer une OAuth App sur GitHub: https://github.com/settings/developers
- Homepage URL: `http://localhost:5173`
- Authorization callback URL: `http://127.0.0.1:54321/auth/v1/callback`
- Configurer dans Supabase Dashboard local: http://127.0.0.1:54323/project/default/auth/providers

### 2. Environnement Test

Créer un projet Supabase séparé pour les tests.

```bash
# Copier le fichier exemple
cp .env.test.example .env.test

# Remplir avec les vraies valeurs du projet test
```

**Setup Supabase Test:**
1. Créer un nouveau projet sur https://supabase.com/dashboard
2. Copier l'URL et la clé anon dans `.env.test`
3. Appliquer les migrations: `supabase db push --linked`

**GitHub OAuth pour test:**
- Créer une OAuth App dédiée au test
- Homepage URL: `https://test.your-domain.com` (ou Netlify preview URL)
- Authorization callback URL: `https://YOUR_TEST_PROJECT.supabase.co/auth/v1/callback`
- Configurer dans le Dashboard Supabase du projet test

### 3. Environnement Production

```bash
# Copier le fichier exemple
cp .env.production.example .env.production

# Remplir avec les vraies valeurs du projet production
```

**GitHub OAuth pour production:**
- Créer une OAuth App dédiée à la production
- Homepage URL: `https://your-domain.com`
- Authorization callback URL: `https://YOUR_PROD_PROJECT.supabase.co/auth/v1/callback`
- Configurer dans le Dashboard Supabase du projet production

## Déploiement Netlify

### Variables d'environnement

Dans Netlify Dashboard > Site settings > Environment variables:

**Production (main branch):**
```
VITE_SUPABASE_URL=https://YOUR_PROD_PROJECT.supabase.co
VITE_SUPABASE_ANON_KEY=your_prod_anon_key
VITE_APP_ENV=production
```

**Preview/Staging (autres branches):**
Utiliser les "Deploy contexts" pour définir des variables différentes pour les branches de preview.

### Build Commands

- Production: `pnpm build:prod`
- Preview: `pnpm build:test`

## Structure des fichiers

```
.env.example           # Template général (committé)
.env.local.example     # Template local (committé)
.env.test.example      # Template test (committé)
.env.production.example # Template production (committé)

.env.local             # Valeurs local (ignoré par git)
.env.test              # Valeurs test (ignoré par git)
.env.production        # Valeurs production (ignoré par git)
```

## Vérifier l'environnement actif

L'environnement actif est disponible via `import.meta.env.VITE_APP_ENV`:

```typescript
console.log('Current environment:', import.meta.env.VITE_APP_ENV)
// 'local', 'test', ou 'production'
```

## Checklist pour chaque environnement

- [ ] Projet Supabase créé
- [ ] Migrations appliquées
- [ ] GitHub OAuth App créée
- [ ] OAuth configuré dans Supabase
- [ ] Fichier .env rempli
- [ ] Test de connexion GitHub
