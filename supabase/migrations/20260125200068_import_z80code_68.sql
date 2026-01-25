-- Migration: Import z80code projects batch 68
-- Projects 135 to 136
-- Generated: 2026-01-25T21:43:30.203300

-- Project 135: overflow_sans_overflow by Ast
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'overflow_sans_overflow',
    'Imported from z80Code. Author: Ast.',
    'public',
    false,
    false,
    '2019-09-08T21:09:02.802000'::timestamptz,
    '2021-06-18T13:54:21.985000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';
; Overflow du reg 1 sans overflow
; -----> AsT/iMPACT # Mickey (My cat)
;
; Probleme des vecteurs systeme en SNA (DSK requis)


 org #A000

 ld a,2
 call #bc0e ; Mode Ecran 2
 di
 ld hl,#c9fb ; on remplace les interruptions
 ld (#38),hl ; par un ei/ret
;
 call aff ; affiche message
; 
 ei
;
main
 ld b,#f5 ; Attente vbl
vbl  in a,(c)
 rra
 jr nc,vbl
;
 ld bc,#bc07 ; kill vbl
 out (c),c
 inc b
 out (c),b
 ld b,0 ; on attend 32 lignes pour commencer la rupture
 djnz $
 djnz $
;
 ld de,#0400
 call setreg
;
 ei
 halt
;
 call raster
;
 ld de,#0404-1
 call setreg
 ld de,#0700
 call setreg
;
 jp main
;
; Affichage du message à dupliquer
;
aff ld hl,#0101 
 call #bb75 ; locate 1,1
;
 ld hl,txt
looptxt ld a,(hl)
 or a ; si on trouve le char 0
 ret z ; alors c''est la fin des haricots
 
 call #bb5a ; affiche le char via les vecteurs système
 
 inc hl ; prochain char
 jr looptxt ; et on recommence
;
txt defm " Emulation Overflow Reg 1 sans Overflow "
 defm "by AsT/iMPACT 28/03/19 helped by Mickey",0
;
; In -> D=reg E=Value
;
setreg  ld b,#bc 
 out (c),d
 inc b
 out (c),e
 ret
;
; C=Debut de palette
; E=Nbre de bloc de lignes 
;
raster
 di
 defs 24+64,0
 ld bc,#7F40 
 defw #71ed ; out (c),0 -> Select encre 0
 ld e,#20
looprast 
 out (c),c
 inc c
 defs 7*64,0 ; Attente 8 rasterlines
 defs 64-9,0
 dec e
 jp nz,looprast
 ei
 ret


',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 136: cls_fast by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'cls_fast',
    'Imported from z80Code. Author: fma. Fast cls implementation using SP',
    'public',
    false,
    false,
    '2021-12-23T10:38:42.442000'::timestamptz,
    '2021-12-23T16:10:48.326000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Fast implemention of CLS (use SP)

BUILDSNA
BANKSET 0
RUN start

ORG #4000

start

        ; Inhibit RST 38 interrupt vector
        DI
        LD   HL,#C9FB
        LD   (#38),HL
        EI

        LD  SP,#8000

        ; Fill screen with pattern
        LD   HL,#C000
        LD   D,H
        LD   E,L
        INC  DE
        LD   BC,#4000-1
        LD   (HL),#FF
        LDIR
        
        ; Set border color
        LD   BC,#0202
        CALL #BC38
        
        ; Fast cls
        CALL clsFast
        JR   $

                
clsFast
        DI

        LD   HL,#C000-#30+#4000     ; start image address
        LD   C,8                    ; nb raster lines per bloc
        LD   DE,#00                 ; filling pattern
.loopBlocs
        PUSH HL
        LD   (.restoreSP+1),SP      ; save current SP so it can be restored later
        LD   SP,HL                  ; load screen address in SP

        LD   B,25                   ; nb blocs of raster lines
.loopLines
REPEAT 80/2                         ; write 80 bytes (1 line)
        PUSH DE
REND
        DJNZ .loopLines

.restoreSP
        LD   SP,#0000               ; restore SP

        ; Compute previous line
        POP  HL
        LD   A,H
        ADD  -8
        LD   H,A

        DEC  C
        JR   NZ,.loopBlocs

        EI
        RET
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
