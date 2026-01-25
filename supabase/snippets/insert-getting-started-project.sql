-- Insert the "Getting Started" example project
-- Run this script after deploying the migration
-- Replace <YOUR_USER_ID> with the actual user ID who will own this project

-- First, generate a UUID for the project
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  owner_user_id uuid := 'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid;
BEGIN
  -- Insert the project
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky)
  VALUES (
    project_uuid,
    owner_user_id,
    'Getting Started',
    'A simple Hello World example to get you started with Z80 assembly on Amstrad CPC. This project demonstrates basic assembly concepts including memory organization, BIOS calls, and string output.',
    'public',
    false,
    true
  );

  -- Insert main.asm file
  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Hello World for Amstrad CPC
; Displays a message on screen
;
; To run: Click "Assemble & Run" and the message will appear in the emulator
;
; TIP: Select "DSK" output format, then INJECT the disk
; In BASIC, type: memory &3fff:load"program.bin",&4000:call &4000

    org #4000           ; Start address in memory

start:
    ld a, 1             ; Set screen mode 1 (40 columns)
    call #bc0e          ; SCR SET MODE
    
    ld hl, message      ; Point to our message
    call print_string   ; Print it
    ret                 ; Return to BASIC

; Print a null-terminated string
; Input: HL = pointer to string
print_string:
    ld a, (hl)          ; Get character
    or a                ; Is it zero (end of string)?
    ret z               ; Yes, we are done
    call #bb5a          ; TXT OUTPUT - print character to screen
    inc hl              ; Move to next character
    jr print_string     ; Loop

message:
    db "Hello from CPC Playground!", 13, 10
    db "Welcome to Z80 assembly!", 0
',
    true,
    0
  );

  -- Insert getting-started.md file
  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'getting-started.md',
    '# Welcome to CPC Playground! 🎮

**CPC Playground** is an online IDE for developing Z80 assembly programs for the Amstrad CPC, with a built-in emulator.

---

## For Everyone (No Account Required)

### 🔍 Explore Projects
Browse public projects created by the community in the **Explore** page. You can:
- View source code and documentation
- Run any project in the emulator
- Learn from other developers'' code

### ▶️ Try the Emulator
Click **"Assemble & Run"** on any project to:
1. Compile the Z80 assembly code
2. Load it into the CPC emulator
3. See it run instantly!

### 📤 Share Code
Use the **Share** feature to create a shareable link of any code snippet - no account needed!

---

## For Authenticated Users

Create an account to unlock the full experience:

### 📁 Create Projects
- Create unlimited projects with multiple files
- Organize code with `.asm` files and `.md` documentation
- Set projects as **public** or **private**

### 📚 Create Libraries
Build reusable code libraries that other users can import into their projects.

### 🔗 Add Dependencies
Import libraries into your projects to reuse common routines (sprites, sound, math...).

### 💾 Auto-Save
Your code is automatically saved as you type - never lose your work!

### 🖼️ Thumbnails
Projects automatically get a thumbnail from the emulator screen.

### 🤝 Share with Collaborators
Invite other users to view or edit your private projects.

---

## Output Formats

| Format | Description |
|--------|-------------|
| **SNA** | Snapshot - instantly runs your program |
| **DSK** | Disk image - load via BASIC commands |
| **BIN** | Raw binary file |

---

## Keyboard Shortcuts

- `Ctrl+Enter` - Assemble & Run
- `Ctrl+S` - Force save (auto-save is enabled)

---

## Getting Help

- Check out other projects in **Explore** for examples
- Look for **Libraries** tagged with what you need
- Visit the [CPC Wiki](https://www.cpcwiki.eu/) for Z80 and CPC documentation

Happy coding! 🚀
',
    false,
    1
  );

  -- Add some tags
  INSERT INTO tags (name) VALUES ('tutorial'), ('beginner'), ('hello-world')
  ON CONFLICT (name) DO NOTHING;

  -- Link tags to project
  INSERT INTO project_tags (project_id, tag_id)
  SELECT project_uuid, id FROM tags WHERE name IN ('tutorial', 'beginner', 'hello-world');

  RAISE NOTICE 'Created Getting Started project with ID: %', project_uuid;
END $$;
