-- Migration: Import z80code projects batch 89
-- Projects 177 to 178
-- Generated: 2026-01-25T21:43:30.208817

-- Project 177: ticker by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'ticker',
    'Imported from z80Code. Author: siko. TICKER directive',
    'public',
    false,
    false,
    '2020-03-31T01:04:41.365000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ' ; TICKER example
 ; Demonstrates how to use TICKER directive

 ; disable Int #38
 di
 ld hl,#C9FB
 ld (#38),hl
 ei

 ; border only
 ld bc,#bc01
 out (c),c
 inc b
 dec c
 out (c),c

mainloop:

 ld b,#F5
.waitvbl in a,(c)
 rra
 jr nc,.waitvbl

 halt 
 di
 ds 28

 ld bc,#7f10
 out (c),c
 
 repeat 240,cnt0
 cnt = 19+18*sin(cnt0*180/240)

TICKER START, cntline
 ; 1st color
 ld a,cnt
 and 31
 or 64
 
 out (c),a
 ; Variable tempo (sinus)
 ds cnt+1
 ; 2nd color
 ld a,cnt0
 and 31
 or 64
 out (c),a
TICKER STOP, cntline

 ; Compensate, so every line duration is exactly 64 us
 ds 64-cntline
 print cnt0, cnt, cntline
 rend

 ; back to black
 ld bc,#7f10
 out (c),c
 ld a,#54
 out (c),a

 ei

 jp mainloop
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: rasm-examples
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rasm-examples';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 178: if_then_else_end by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'if_then_else_end',
    'Imported from z80Code. Author: tronic. funny trick',
    'public',
    false,
    false,
    '2020-01-30T11:13:31.238000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; if, then, else, end funny trick
; a = any value1 to be compared (cp) with another one (value2).
; if a(value1)=(value2) then a=#AA (can be changed) else a=#BB (can be changed)
; found here : http://www.maxcoderz.org/forum/viewtopic.php?f=5&t=2579


org #1000
run $

; ----------------- else case

		ld a,8				; a=8 (8<>9, else, a=#bb)
_if1	cp 9				; if a=9
		jr nz,_else1		; classical jump...
_then1
		ld a,#AA:db #c2		; then a=#aa + #c2 opcode = jp nz,xxxx, the _else/ld a,#bb become "ghosted"
_else1
		ld a,#BB			; else a=#bb
_end1	nop:nop:nop:nop


; ----------------- then case

		ld a,9				; a=9 (9=9, then, a=#aa)
_if2	cp 9				; if a=9
		jr nz,_else2		; classical jump...
_then2
		ld a,#AA:db #c2		; then a=#aa + #c2 opcode = jp nz,xxxx, the _else/ld a,#bb become "ghosted"
_else2
		ld a,#BB			; else a=#bb
_end2	nop:nop:nop:nop',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: z80-tricks
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80-tricks';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
