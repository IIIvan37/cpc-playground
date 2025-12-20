# Multi-Environment Setup Guide

Ce projet supporte 3 environnements, tous basés sur Supabase Docker en local sauf la production.

## Environnements

| Environnement | Commande | Fichier env | Supabase | Usage |
|--------------|----------|-------------|----------|-------|
| **Local** | `pnpm dev` | `.env.local` | Docker local | Développement |
| **Test** | `pnpm test` | `.env.test` | Docker local | Tests d'intégration |
| **Production** | Netlify | Variables Netlify | Cloud | Production |

## Configuration

### 1. Environnement Local (Développement)

Utilise Supabase en local via Docker.

```bash
# Démarrer Supabase local
supabase start

# Copier le fichier exemple
cp .env.local.example .env.local

# Les valeurs par défaut fonctionnent avec supabase start
# Lancer le dev server
pnpm dev
```

### 2. Environnement Test (Tests d'intégration)

Utilise aussi Supabase Docker. Les tests peuvent reset la DB entre chaque test.

```bash
# S'assurer que Supabase local tourne
supabase start

# Copier le fichier exemple
cp .env.test.example .env.test

# Lancer les tests
pnpm test
```

**Pour les tests d'intégration:**
- Utiliser `supabase db reset` pour repartir d'une base propre
- Ou créer des fixtures/seeds spécifiques aux tests

### 3. Environnement Production

Nécessite un projet Supabase Cloud.

**Setup Supabase Cloud:**
1. Créer un projet sur https://supabase.com/dashboard
2. Lier le projet: `supabase link --project-ref YOUR_PROJECT_REF`
3. Appliquer les migrations: `supabase db push`

**GitHub OAuth pour production:**
1. Créer une OAuth App sur https://github.com/settings/developers
   - Homepage URL: `https://your-domain.netlify.app`
   - Authorization callback URL: `https://YOUR_PROJECT.supabase.co/auth/v1/callback`
2. Configurer dans Supabase Dashboard > Authentication > Providers > GitHub

**Déploiement Netlify:**
Dans Netlify Dashboard > Site settings > Environment variables:
```
VITE_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key
VITE_APP_ENV=production
```

## Structure des fichiers

```
.env.example              # Documentation (committé)
.env.local.example        # Template local (committé)
.env.test.example         # Template test (committé)
.env.production.example   # Template production (committé)

.env.local                # Valeurs local (ignoré)
.env.test                 # Valeurs test (ignoré)
.env.production           # Valeurs production (ignoré - utilisé uniquement pour dev:prod)
```

## Résumé

| | Local | Test | Production |
|---|-------|------|------------|
| **Supabase** | Docker | Docker | Cloud |
| **GitHub OAuth** | Non requis | Non requis | Requis |
| **Où configurer** | `.env.local` | `.env.test` | Netlify Dashboard |
