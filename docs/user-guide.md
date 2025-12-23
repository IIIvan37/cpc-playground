# CPC Playground - User Guide

Welcome to **CPC Playground**, a web-based development environment for Amstrad CPC with integrated assembler and emulator.

## Core Features (All Users)

### Code Editor
- Write Z80 assembly code with syntax highlighting
- Error markers after compilation
- Switch between views: editor only, emulator only, or split

### RASM Assembler
- Assemble your code with [RASM](http://rasm.music.world)
- Output to SNA (snapshot) or DSK (disk)
- Detailed error messages with line numbers

### CPCEC Emulator
- Run your programs instantly in [CPCEC](http://cngsoft.no-ip.org/cpcec.htm)
- **CPC Plus** support (hardware sprites, extended palette, DMA)
- Click on the emulator to enable keyboard input

### Explore Public Projects
- Browse projects shared by the community
- Search by name, author, tag, or description
- View reusable "Library" projects

---

## Guest Mode (Not Authenticated)

Without an account, you can:
- Write and assemble code
- Run in the emulator
- View public projects
- Code saved in browser (localStorage)

Limitations:
- No cloud sync
- No multi-file projects
- No sharing
- No libraries

---

## Authenticated User

Create an account to unlock all features!

### Multi-file Projects
Organize your code across multiple files:
```
My Project/
├── main.asm      (main file)
├── routines.asm
├── sprites.asm
└── data.asm
```
- Use `INCLUDE "file.asm"` to import other files
- Automatic cloud save

### Visibility Levels

- **Private**: Only you can see and modify
- **Public**: Everyone can see, only you can modify
- **Shared**: You and invited users can see, only you can modify

### Libraries
- Mark a project as "Library" to create reusable code
- Other users can add it as a dependency
- Dependency files are accessible via `INCLUDE`

### Sharing
- **With specific users**: Add them by username
- **Public**: Everyone can view your project
- Shared users have read-only access

### Tags
Organize your projects with tags:
- `demo`, `game`, `library`, `sprites`, `cpc-plus`
- Easy search in the explorer

### User Profile
- Customizable username
- Email or GitHub authentication

---

*CPC Playground - Develop for Amstrad CPC directly in your browser!*
