# Feature: Supabase Auth & Multi-file Projects

This branch implements authentication and multi-file project support using Supabase.

## ✨ New Features

### 1. User Authentication
- **Email/Password** authentication
- **GitHub OAuth** login (optional)
- Session persistence
- User profile display in header

### 2. Multi-file Projects
- Create and manage multiple projects
- Each project can contain multiple `.asm` files
- Designate a "main" file to compile
- File browser sidebar with project/file tree
- Auto-save file contents (1s debounce)

### 3. Cloud Storage
- All projects stored in Supabase PostgreSQL
- Row-level security (users can only access their own data)
- Real-time synchronization
- Automatic timestamps

## 📦 What's Been Added

### New Dependencies
- `@supabase/supabase-js` - Supabase SDK

### New Files
```
src/
  lib/
    supabase.ts                        # Supabase client configuration
  types/
    database.ts                        # TypeScript types for database schema
  hooks/
    use-auth.ts                        # Authentication hook
    use-auto-save-file.ts              # Auto-save file content hook
  components/
    auth/
      auth-modal.tsx                   # Sign in/Sign up modal
      auth-modal.module.css
      index.ts
    layout/
      project-browser.tsx              # Project & file browser sidebar
      project-browser.module.css
  store/
    projects-v2.ts                     # New project store with Supabase integration

supabase/
  migrations/
    001_initial_schema.sql             # Database schema and RLS policies

.env.example                           # Environment variables template
SUPABASE_SETUP.md                      # Detailed setup instructions
FEATURE_NOTES.md                       # This file
```

### Modified Files
- `src/components/layout/app-header.tsx` - Added auth button
- `src/components/layout/main-layout.tsx` - Added project browser sidebar
- `src/components/layout/main-layout.module.css` - Updated layout for sidebar
- `src/hooks/index.ts` - Exported new hooks
- `.gitignore` - Added `.env` files

## 🚀 Setup Instructions

See [SUPABASE_SETUP.md](./SUPABASE_SETUP.md) for detailed setup instructions.

**Quick start:**
1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Run the SQL migration in Supabase SQL Editor
3. Copy `.env.example` to `.env` and add your Supabase credentials
4. Start the dev server: `pnpm dev`

## 🎯 How It Works

### Project Structure
```
Project
├── name
├── description (optional)
└── files[]
    ├── File 1 (main.asm) ⭐ main file
    ├── File 2 (sprites.asm)
    └── File 3 (utils.asm)
```

### User Flow

1. **Unsigned users**: Can still use the playground with localStorage (old behavior)
2. **Signed in users**:
   - See their projects in the sidebar
   - Create new projects with multiple files
   - Files auto-save to Supabase
   - Projects persist across devices

### Auto-save
Files are automatically saved to Supabase 1 second after the user stops typing.

### Main File
- Each project must have one "main" file (indicated with ⭐)
- The main file is the entry point for compilation
- Users can change which file is the main file

## 🔒 Security

### Row Level Security (RLS)
All database tables use RLS policies:
- Users can only see their own projects
- Users can only modify their own files
- Authentication required for all operations

### API Keys
- Only the "anon" public key is exposed to the client
- RLS policies enforce access control
- User JWT tokens validate all requests

## 🔄 Migration Path

The old localStorage-based projects (`src/store/programs.ts`) are still in place.

**Future work** could include:
- Migrating localStorage projects to Supabase for signed-in users
- Option to import/export projects
- Sharing projects with other users

## 🐛 Known Issues

- Some a11y linting warnings (acceptable for now)
- Need to handle offline mode gracefully
- Could add loading states during Supabase operations

## 📝 Next Steps

Potential enhancements:
- [ ] Project sharing (public URLs)
- [ ] Project templates
- [ ] File upload/download
- [ ] Collaboration features
- [ ] Project search/filtering
- [ ] File tree view with folders
- [ ] Diff view for file changes
- [ ] Version history

## 🧪 Testing

To test this feature:
1. Click "Sign In" and create an account
2. Create a new project
3. Add multiple files to the project
4. Mark different files as "main"
5. Edit files and see auto-save working
6. Sign out and back in - projects should persist
7. Test GitHub OAuth (if configured)
