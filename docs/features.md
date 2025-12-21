# Features

## Projects

### Multi-file Projects

Projects can contain multiple `.asm` files:

```
My Project/
├── main.asm      ⭐ (main file - compiled first)
├── routines.asm
├── sprites.asm
└── data.asm
```

- One file is marked as **main** - this is the entry point for compilation
- Files auto-save to Supabase (1s debounce)
- Use `INCLUDE` directives to include other files

### Visibility Levels

| Level | Who can see | Who can modify |
|-------|-------------|----------------|
| **Private** | Owner only | Owner only |
| **Public** | Everyone | Owner only |
| **Shared** | Owner + invited users | Owner only |

### Libraries

Projects can be marked as **libraries** (`is_library = true`):
- Designed to be included in other projects
- Can be added as dependencies
- Typically contain reusable routines, macros, or data

---

## Includes

Use `INCLUDE` to import other files from your project:

```asm
; main.asm
    org #4000
    
    INCLUDE "routines.asm"
    INCLUDE "data.asm"

start:
    call clear_screen
    ld hl, message
    call print_string
    ret
```

```asm
; routines.asm
clear_screen:
    ld hl, #c000
    ld de, #c001
    ld bc, #3fff
    ld (hl), 0
    ldir
    ret
```

**Rules:**
- File name must match exactly
- Includes can be nested (file A includes B, B includes C)
- Avoid circular includes

---

## Dependencies

Projects can depend on other projects (libraries):

```
My Game
├── main.asm
└── Dependencies:
    ├── Math Library (routines: multiply, divide)
    └── Print Library (routines: print_string, print_number)
```

### How it works

1. Mark a project as **library**
2. Make it **public** (so others can use it)
3. In another project, add it as a dependency
4. All files from dependencies are available via `INCLUDE`

### Recursive Dependencies

If Project A depends on B, and B depends on C, then A has access to files from both B and C.

---

## Sharing

### Share with specific users

1. Set visibility to **Shared**
2. Add users by their email or username
3. Shared users get **read-only** access

### Public projects

1. Set visibility to **Public**
2. Anyone can view the project
3. Only owner can modify

---

## Tags

Organize projects with tags:

- Tags are **global** - shared across all users
- Automatically normalized to lowercase with hyphens
- Length: 2-30 characters
- Format: `a-z`, `0-9`, `-` only

Examples: `cpc-464`, `demo`, `game`, `library`, `sprites`

---

## Usernames

Each user has a unique username:

- **Auto-generated** from email on signup
- Length: 3-30 characters
- Format: `a-z`, `0-9`, `_`, `-` only
- Can be changed in profile settings

---

## Authentication

### Supported Methods

- **Email/Password** - Sign up with email confirmation
- **GitHub OAuth** - One-click login (production only)

### Guest Mode

Users can use the playground without signing in:
- Code saved in localStorage
- No cloud sync
- No project management features
