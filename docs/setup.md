# Setup Guide

## Prerequisites

- Node.js 18+
- pnpm
- Docker (for local Supabase)
- Supabase CLI

## Installation

```bash
# Clone the repository
git clone https://github.com/IIIvan37/cpc-playground.git
cd cpc-playground

# Install dependencies
pnpm install

# Install Supabase CLI (macOS)
brew install supabase/tap/supabase
```

## Local Development

### 1. Start Supabase

```bash
# Start local Supabase (Docker required)
supabase start

# This will output local credentials:
# API URL: http://127.0.0.1:54321
# anon key: eyJhbGciOiJIUzI1NiIsInR...
```

### 2. Configure Environment

```bash
# Copy example env file
cp .env.local.example .env.local
```

The default values work with `supabase start`:

```env
VITE_SUPABASE_URL=http://127.0.0.1:54321
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
VITE_APP_ENV=local
```

### 3. Start Development Server

```bash
pnpm dev
```

Open http://localhost:5173

## Environments

| Environment | Command | Supabase | Usage |
|-------------|---------|----------|-------|
| **Local** | `pnpm dev` | Docker | Development |
| **Test** | `pnpm test` | Docker | Unit/Integration tests |
| **Production** | Netlify | Cloud | Live site |

### Environment Files

```
.env.local.example    # Template (committed)
.env.test.example     # Template (committed)
.env.local            # Local values (gitignored)
.env.test             # Test values (gitignored)
```

## Supabase Cloud (Production)

### 1. Create Project

1. Go to [supabase.com](https://supabase.com) and create a project
2. Wait for project to be ready (~2 minutes)
3. Note your Project URL and anon key from Settings > API

### 2. Link Project

```bash
supabase link --project-ref YOUR_PROJECT_REF
```

### 3. Apply Migrations

```bash
supabase db push
```

### 4. Configure GitHub OAuth (Optional)

1. Create OAuth App at https://github.com/settings/developers
   - Homepage URL: `https://your-domain.netlify.app`
   - Callback URL: `https://YOUR_PROJECT.supabase.co/auth/v1/callback`
2. In Supabase Dashboard > Authentication > Providers > GitHub
3. Add Client ID and Client Secret

### 5. Configure Netlify

In Netlify Dashboard > Site settings > Environment variables:

```
VITE_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key
VITE_APP_ENV=production
```

## Database Schema

The database is defined in a single migration file:

```
supabase/migrations/20241220000000_initial_schema.sql
```

### Tables

| Table | Description |
|-------|-------------|
| `user_profiles` | User profiles with unique usernames |
| `projects` | User projects |
| `project_files` | Files within projects |
| `project_shares` | Project sharing with users |
| `project_tags` | Tags associated with projects |
| `project_dependencies` | Project dependency relationships |
| `tags` | Global tags |

### Row Level Security

RLS is enabled on all tables. Basic protection at DB level:
- Users can only modify their own projects
- Public/library projects are readable by everyone
- Complex authorization logic is handled in application code

## Troubleshooting

### Reset Local Database

```bash
supabase db reset
```

### Check Supabase Status

```bash
supabase status
```

### View Logs

```bash
supabase logs
```

### Stop Supabase

```bash
supabase stop
```
