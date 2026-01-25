-- Migration: Import z80code projects batch 90
-- Projects 179 to 180
-- Generated: 2026-01-25T21:43:30.208918

-- Project 179: wav2ay-1chan by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'wav2ay-1chan',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2021-01-09T18:02:49.653000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'N_CHAN:				equ 1
;BUILDSNA
;BANK 1
                    org #4000
                    run #4000
start
                    di
                    ld hl, #c9fb
                    ld (#38), hl
                    ei
                    
                    ld c, 7
                    ld a, 8 + 16 + 32
                    call write_to_psg
main_loop:
                    ld b, #f5 
.vs:                in a, (c)
                    rra
                    jr nc, .vs

.ptr:               ld hl, table
                    ld a, (hl)
                    inc a
                    jr nz, .ok
                    ld hl, table
.ok
					inc hl
repeat 3 * N_CHAN
                    ld c, (hl)
                    inc hl
                    ld a, (hl)
                    inc hl
                    call write_to_psg
rend
   
.end                ld (.ptr + 1), hl 
					halt : halt
                    jp main_loop


;; entry conditions:
;; C = register number
;; A = register data
;; exit conditions:
;; b,C,F corrupt
;; assumptions:
;; PPI port A and PPI port C are setup in output mode.
write_to_psg
ld b,#f4            ; setup PSG register number on PPI port A
out (c),c           ;

ld bc,#f6c0         ; Tell PSG to select register from data on PPI port A
out (c),c           ;

ld bc,#f600         ; Put PSG into inactive state.
out (c),c           ;

ld b,#f4            ; setup register data on PPI port A
out (c),a           ;

ld bc,#f680         ; Tell PSG to write data on PPI port A into selected register
out (c),c           ;

ld bc,#f600         ; Put PSG into inactive state
out (c),c           ;
ret


table

; idx,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value
db 0, 8, 8, 0, 76, 1, 3
db 1, 8, 0, 0, 0, 1, 0
db 2, 8, 0, 0, 0, 1, 0
db 3, 8, 7, 0, 22, 1, 1
db 4, 8, 9, 0, 62, 1, 1
db 5, 8, 9, 0, 57, 1, 1
db 6, 8, 8, 0, 27, 1, 1
db 7, 8, 8, 0, 25, 1, 1
db 8, 8, 7, 0, 155, 1, 0
db 9, 8, 9, 0, 248, 1, 0
db 10, 8, 8, 0, 233, 1, 0
db 11, 8, 8, 0, 25, 1, 1
db 12, 8, 9, 0, 215, 1, 0
db 13, 8, 9, 0, 208, 1, 0
db 14, 8, 8, 0, 231, 1, 0
db 15, 8, 9, 0, 251, 1, 0
db 16, 8, 10, 0, 234, 1, 0
db 17, 8, 7, 0, 118, 1, 0
db 18, 8, 8, 0, 214, 1, 0
db 19, 8, 8, 0, 214, 1, 0
db 20, 8, 9, 0, 241, 1, 0
db 21, 8, 9, 0, 160, 1, 0
db 22, 8, 9, 0, 162, 1, 0
db 23, 8, 8, 0, 212, 1, 0
db 24, 8, 8, 0, 144, 1, 0
db 25, 8, 9, 0, 142, 1, 0
db 26, 8, 8, 0, 158, 1, 0
db 27, 8, 7, 0, 141, 1, 0
db 28, 8, 10, 0, 154, 1, 0
db 29, 8, 8, 0, 142, 1, 0
db 30, 8, 9, 0, 141, 1, 0
db 31, 8, 8, 0, 138, 1, 0
db 32, 8, 9, 0, 157, 1, 0
db 33, 8, 8, 0, 119, 1, 0
db 34, 8, 8, 0, 120, 1, 0
db 35, 8, 8, 0, 141, 1, 0
db 36, 8, 8, 0, 107, 1, 0
db 37, 8, 8, 0, 107, 1, 0
db 38, 8, 7, 0, 120, 1, 0
db 39, 8, 7, 0, 120, 1, 0
db 40, 8, 7, 0, 107, 1, 0
db 41, 8, 7, 0, 106, 1, 0
db 42, 8, 5, 0, 139, 1, 0
db 43, 8, 4, 0, 138, 1, 0
db 44, 8, 5, 0, 157, 1, 0
db 45, 8, 4, 0, 120, 1, 0
db 46, 8, 4, 0, 59, 1, 0
db 47, 8, 3, 0, 143, 1, 0
db 48, 8, 3, 0, 111, 1, 0
db 49, 8, 5, 0, 106, 1, 0
db 50, 8, 3, 0, 121, 1, 0
db 51, 8, 3, 0, 118, 1, 0
db 52, 8, 3, 0, 104, 1, 0
db 53, 8, 3, 0, 106, 1, 0
db 54, 8, 2, 0, 107, 1, 0
db 55, 8, 1, 0, 138, 1, 0
db 56, 8, 1, 0, 157, 1, 0
db 57, 8, 1, 0, 119, 1, 0
db 58, 8, 1, 0, 120, 1, 0
db 59, 8, 0, 0, 0, 1, 0
db 60, 8, 0, 0, 0, 1, 0
db 61, 8, 1, 0, 107, 1, 0
db 62, 8, 0, 0, 0, 1, 0
db 63, 8, 0, 0, 0, 1, 0
db 64, 8, 0, 0, 0, 1, 0
db 65, 8, 0, 0, 0, 1, 0
db 66, 8, 0, 0, 0, 1, 0
db 67, 8, 0, 0, 0, 1, 0
db 68, 8, 0, 0, 0, 1, 0
db 69, 8, 0, 0, 0, 1, 0
db 70, 8, 0, 0, 0, 1, 0
db 71, 8, 0, 0, 0, 1, 0
db 72, 8, 0, 0, 0, 1, 0
db 73, 8, 0, 0, 0, 1, 0
db 74, 8, 0, 0, 0, 1, 0
db 255

end',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 180: wav2ay1 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'wav2ay1',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2021-01-09T17:25:26.553000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'N_CHAN:				equ 3
                    org #4000
                    run #4000
start
                    di
                    ld hl, #c9fb
                    ld (#38), hl
                    ei
                    
                    ld c, 7
                    ld a, 8 + 16 + 32
                    call write_to_psg
main_loop:
                    ld b, #f5 
.vs:                in a, (c)
                    rra
                    jr nc, .vs

.ptr:               ld hl, table
                    ld a, (hl)
                    inc a
                    jr nz, .ok
                    ld hl, table
.ok
					inc hl
repeat 3 * N_CHAN
                    ld c, (hl)
                    inc hl
                    ld a, (hl)
                    inc hl
                    call write_to_psg
rend
   
.end                ld (.ptr + 1), hl 
					halt : halt
                    jp main_loop


;; entry conditions:
;; C = register number
;; A = register data
;; exit conditions:
;; b,C,F corrupt
;; assumptions:
;; PPI port A and PPI port C are setup in output mode.
write_to_psg
ld b,#f4            ; setup PSG register number on PPI port A
out (c),c           ;

ld bc,#f6c0         ; Tell PSG to select register from data on PPI port A
out (c),c           ;

ld bc,#f600         ; Put PSG into inactive state.
out (c),c           ;

ld b,#f4            ; setup register data on PPI port A
out (c),a           ;

ld bc,#f680         ; Tell PSG to write data on PPI port A into selected register
out (c),c           ;

ld bc,#f600         ; Put PSG into inactive state
out (c),c           ;
ret


table

; idx,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value
db 0,8,10,0,196,1,1,9,9,2,59,3,1,10,7,4,205,5,0
db 1,8,11,0,98,1,1,9,4,2,250,3,0,10,3,4,205,5,0
db 2,8,14,0,28,1,1,9,13,2,139,3,0,10,10,4,131,5,0
db 3,8,15,0,111,1,0,9,13,2,227,3,0,10,10,4,108,5,0
db 4,8,14,0,50,1,0,9,14,2,101,3,0,10,13,4,51,5,0
db 5,8,13,0,68,1,0,9,13,2,106,3,0,10,12,4,46,5,0
db 6,8,15,0,40,1,0,9,14,2,66,3,0,10,13,4,100,5,0
db 7,8,12,0,102,1,0,9,12,2,40,3,0,10,10,4,68,5,0
db 8,8,13,0,41,1,0,9,12,2,104,3,0,10,10,4,51,5,0
db 9,8,14,0,41,1,0,9,11,2,103,3,0,10,10,4,51,5,0
db 10,8,12,0,41,1,0,9,10,2,52,3,0,10,10,4,104,5,0
db 11,8,12,0,36,1,0,9,9,2,47,3,0,10,9,4,37,5,0
db 12,8,11,0,38,1,0,9,11,2,43,3,0,10,11,4,112,5,0
db 13,8,13,0,35,1,0,9,10,2,107,3,0,10,10,4,53,5,0
db 14,8,12,0,34,1,0,9,11,2,104,3,0,10,10,4,52,5,0
db 15,8,12,0,35,1,0,9,11,2,106,3,0,10,9,4,37,5,0
db 16,8,12,0,35,1,0,9,11,2,107,3,0,10,9,4,37,5,0
db 17,8,12,0,35,1,0,9,11,2,106,3,0,10,9,4,36,5,0
db 18,8,12,0,37,1,0,9,10,2,109,3,0,10,8,4,54,5,0
db 19,8,12,0,38,1,0,9,11,2,112,3,0,10,7,4,29,5,0
db 20,8,12,0,38,1,0,9,12,2,113,3,0,10,9,4,38,5,0
db 21,8,12,0,38,1,0,9,11,2,111,3,0,10,8,4,56,5,0
db 22,8,12,0,36,1,0,9,11,2,109,3,0,10,8,4,27,5,0
db 23,8,12,0,36,1,0,9,11,2,109,3,0,10,8,4,27,5,0
db 24,8,12,0,37,1,0,9,12,2,111,3,0,10,10,4,38,5,0
db 25,8,12,0,114,1,0,9,12,2,39,3,0,10,8,4,108,5,0
db 26,8,12,0,38,1,0,9,11,2,116,3,0,10,6,4,103,5,0
db 27,8,12,0,38,1,0,9,11,2,116,3,0,10,5,4,29,5,0
db 28,8,12,0,40,1,0,9,11,2,120,3,0,10,10,4,38,5,0
db 29,8,13,0,41,1,0,9,12,2,124,3,0,10,7,4,31,5,0
db 30,8,12,0,43,1,0,9,11,2,41,3,0,10,11,4,129,5,0
db 31,8,12,0,44,1,0,9,10,2,131,3,0,10,9,4,41,5,0
db 32,8,12,0,44,1,0,9,10,2,135,3,0,10,9,4,33,5,0
db 33,8,12,0,45,1,0,9,9,2,137,3,0,10,8,4,34,5,0
db 34,8,12,0,45,1,0,9,9,2,137,3,0,10,8,4,34,5,0
db 35,8,11,0,46,1,0,9,10,2,139,3,0,10,9,4,34,5,0
db 36,8,10,0,48,1,0,9,9,2,46,3,0,10,8,4,34,5,0
db 37,8,10,0,36,1,0,9,9,2,49,3,0,10,7,4,148,5,0
db 38,8,9,0,49,1,0,9,9,2,37,3,0,10,6,4,147,5,0
db 39,8,10,0,36,1,0,9,8,2,48,3,0,10,7,4,49,5,0
db 40,8,8,0,49,1,0,9,8,2,35,3,0,10,7,4,150,5,0
db 41,8,9,0,37,1,0,9,7,2,50,3,0,10,5,4,30,5,0
db 42,8,9,0,37,1,0,9,7,2,50,3,0,10,5,4,30,5,0
db 43,8,9,0,38,1,0,9,7,2,51,3,0,10,6,4,153,5,0
db 44,8,9,0,38,1,0,9,7,2,52,3,0,10,5,4,156,5,0
db 45,8,7,0,39,1,0,9,7,2,39,3,0,10,3,4,160,5,0
db 46,8,8,0,40,1,0,9,5,2,161,3,0,10,3,4,18,5,0
db 47,8,7,0,40,1,0,9,5,2,41,3,0,10,3,4,54,5,0
db 48,8,7,0,41,1,0,9,3,2,164,3,0,10,1,4,18,5,0
db 49,8,6,0,41,1,0,9,2,2,167,3,0,10,1,4,18,5,0
db 50,8,4,0,42,1,0,9,2,2,169,3,0,10,2,4,42,5,0
db 51,8,0,0,0,1,0,9,0,2,0,3,0,10,0,4,0,5,0
db 52,8,0,0,0,1,0,9,0,2,0,3,0,10,0,4,0,5,0
db 53,8,0,0,0,1,0,9,0,2,0,3,0,10,0,4,0,5,0
db 255

end',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
