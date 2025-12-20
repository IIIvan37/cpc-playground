# Supabase Setup Guide

This project uses Supabase for authentication and project storage.

## Prerequisites

- A Supabase account (free tier is sufficient)
- Node.js and pnpm installed

## Setup Steps

### 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Click "New project"
3. Choose an organization and name your project (e.g., "cpc-playground")
4. Choose a database password and region
5. Wait for the project to be created (~2 minutes)

### 2. Run Database Migrations

1. In your Supabase project dashboard, go to the **SQL Editor**
2. Click "New query"
3. Copy and paste the contents of `supabase/migrations/001_initial_schema.sql`
4. Click "Run" to execute the migration
5. Verify that the tables were created by checking the **Table Editor**

You should now see two tables:
- `projects`
- `project_files`

### 3. Configure Environment Variables

1. In your Supabase project dashboard, go to **Settings** > **API**
2. Copy your:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon public** key

3. Create a `.env` file in the project root:

```bash
cp .env.example .env
```

4. Edit `.env` and add your credentials:

```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### 4. Configure Authentication

L'authentification doit être configurée dans Supabase pour permettre aux utilisateurs de se connecter.

#### A. Enable Email Authentication (Obligatoire)

1. Dans votre projet Supabase, allez dans le menu de gauche : **Authentication** (icône 🔐)
2. Cliquez sur l'onglet **Providers**
3. Vous verrez une liste de providers. Cherchez **Email**
4. Email devrait déjà être **activé par défaut** (toggle vert)
5. Si ce n'est pas le cas, cliquez sur **Email** puis activez le toggle "Enable Email provider"

**Configuration Email (Development):**
- Pour le développement local, la configuration par défaut suffit
- Supabase enverra des emails de confirmation depuis leur serveur
- Les emails peuvent aller dans les spams - vérifiez votre dossier spam lors des tests
- Pour voir les emails de confirmation pendant le dev, vous pouvez utiliser un service comme [mailtrap.io](https://mailtrap.io)

**Important pour le développement:**
- **Confirm email**: Vous pouvez désactiver cette option pendant le développement
  - Dans Authentication > Settings > **Email Auth**
  - Décochez "Enable email confirmations" pour tester plus facilement
  - ⚠️ Réactivez-la en production !

#### B. Configure Site URL (Important!)

**Où trouver cette option:**

1. **Méthode 1** (recommandée): 
   - Menu de gauche : **Project Settings** (icône ⚙️ tout en bas)
   - Onglet **Authentication**
   - Scrollez jusqu'à la section **"Site URL"**

2. **Méthode 2** (selon version):
   - Menu de gauche : **Authentication** 
   - Onglet **URL Configuration**

**Configuration:**

- **Site URL**: `http://localhost:5173` (pour développement local)
  - C'est l'URL de votre application frontend
  - En production, ce sera votre URL Netlify

- **Redirect URLs** (section en dessous): Ajoutez ces URLs autorisées
  - `http://localhost:5173/**`
  - `http://localhost:5173` (sans le /**)
  
**Pour la production** (plus tard):
- Ajoutez aussi `https://votre-domaine.netlify.app/**`

**Note:** Si vous ne trouvez toujours pas cette section, ce n'est pas bloquant pour le développement local avec email/password uniquement. C'est surtout nécessaire pour OAuth (GitHub).

#### C. Enable GitHub OAuth (Optionnel mais recommandé)

GitHub OAuth permet aux utilisateurs de se connecter avec leur compte GitHub.

⚠️ **ATTENTION : Type d'application**
- Vous devez créer une **OAuth App** (pas une GitHub App)
- Dans GitHub Developer Settings, il y a deux sections :
  - **OAuth Apps** ✅ ← Utilisez celle-ci
  - **GitHub Apps** ❌ ← Ne pas utiliser (plus complexe, demande des webhooks)

**Étape 1: Créer une OAuth App sur GitHub**

1. Allez sur GitHub.com et connectez-vous
2. Cliquez sur votre avatar en haut à droite > **Settings**
3. Dans le menu de gauche, tout en bas : **Developer settings**
4. Dans le menu de gauche : cliquez sur **OAuth Apps** (pas "GitHub Apps"!)
5. Cliquez sur **New OAuth App** (ou "Register a new application")
6. Remplissez le formulaire :
   - **Application name**: `CPC Playground Dev` (ou le nom de votre choix)
   - **Homepage URL**: `http://localhost:5173`
   - **Application description**: (optionnel) "Z80 Assembly IDE for Amstrad CPC"
   - **Authorization callback URL**: `https://VOTRE-PROJECT-ID.supabase.co/auth/v1/callback`
     - ⚠️ Remplacez `VOTRE-PROJECT-ID` par l'ID réel de votre projet Supabase
     - Vous le trouvez dans l'URL de votre dashboard: `https://supabase.com/dashboard/project/VOTRE-PROJECT-ID`
     - Exemple: `https://abcdefghijklmno.supabase.co/auth/v1/callback`
   - **Webhook URL**: ⚠️ **LAISSEZ VIDE** - ce champ n'est pas nécessaire pour OAuth
     - Ce champ peut apparaître selon la version de GitHub
     - Pour une OAuth App simple, on n'a pas besoin de webhook
     - Seul le "Authorization callback URL" est requis
7. Cliquez sur **Register application**

**Étape 2: Récupérer les credentials GitHub**

1. Après création, vous voyez la page de votre OAuth App
2. Copiez le **Client ID** (visible directement)
3. Cliquez sur **Generate a new client secret**
4. Copiez le **Client Secret** (⚠️ notez-le bien, il ne sera affiché qu'une fois !)

**Étape 3: Configurer GitHub dans Supabase**

1. Retournez dans votre projet Supabase
2. Allez dans **Authentication** > **Providers**
3. Cherchez **GitHub** dans la liste et cliquez dessus
4. Activez le toggle **"Enable GitHub provider"**
5. Collez votre **Client ID** GitHub
6. Collez votre **Client Secret** GitHub
7. Cliquez sur **Save**

**Test rapide:**
- Lancez `pnpm dev`
- Cliquez sur "Sign In"
- Vous devriez voir un bouton "Continue with GitHub"
- Cliquez dessus pour tester l'OAuth

#### D. Troubleshooting Auth

**Problème: "Invalid login credentials"**
- Vérifiez que l'email et le mot de passe sont corrects
- Le mot de passe doit faire au moins 6 caractères

**Problème: "Email not confirmed"**
- Vérifiez votre dossier spam
- Ou désactivez temporairement la confirmation d'email (voir section A)

**Problème: GitHub OAuth ne redirige pas**
- Vérifiez que l'URL de callback dans GitHub OAuth App est correcte
- Vérifiez que le Site URL est configuré dans Supabase
- Vérifiez que les Redirect URLs incluent votre domaine local

**Problème: "Missing Supabase environment variables"**
- Vérifiez que le fichier `.env` existe à la racine du projet
- Vérifiez que les variables `VITE_SUPABASE_URL` et `VITE_SUPABASE_ANON_KEY` sont bien définies
- Redémarrez le serveur de dev après avoir créé/modifié le `.env`

### 5. Test the Setup

1. Start the development server:

```bash
pnpm dev
```

2. Open http://localhost:5173
3. Click "Sign In" and try creating an account
4. After signing in, you should be able to:
   - Create new projects
   - Add files to projects
   - Save and load your work

## Database Schema

### `projects` Table
- `id` (uuid, primary key)
- `user_id` (uuid, foreign key to auth.users)
- `name` (text)
- `description` (text, nullable)
- `created_at` (timestamptz)
- `updated_at` (timestamptz)

### `project_files` Table
- `id` (uuid, primary key)
- `project_id` (uuid, foreign key to projects)
- `name` (text)
- `content` (text)
- `is_main` (boolean) - Indicates which file is the main entry point
- `order` (integer) - Display order in the file list
- `created_at` (timestamptz)
- `updated_at` (timestamptz)

## Row Level Security (RLS)

The database uses Row Level Security to ensure users can only access their own projects:

- Users can only view, create, update, and delete their own projects
- Users can only manage files within their own projects
- Authentication is required for all operations

## Troubleshooting

### "Missing Supabase environment variables" Error

Make sure you've created a `.env` file with the correct variables. Restart the dev server after creating the file.

### Authentication Not Working

1. Check that email authentication is enabled in Supabase
2. Verify your API keys are correct
3. Check the browser console for errors

### Projects Not Saving

1. Verify the database migrations ran successfully
2. Check RLS policies are enabled
3. Look for errors in the browser console
4. Check the Supabase logs in the dashboard

## Production Deployment

When deploying to production (e.g., Netlify):

1. Add the environment variables in your hosting platform:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`

2. Update the OAuth redirect URLs to include your production domain

3. Configure email settings in Supabase for production use
