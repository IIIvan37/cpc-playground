-- Migration: Import z80code projects batch 50
-- Projects 99 to 100
-- Generated: 2026-01-25T21:43:30.199354

-- Project 99: screen32k by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'screen32k',
    'Imported from z80Code. Author: siko. Example of 32K mode',
    'public',
    false,
    false,
    '2021-10-24T14:02:28.829000'::timestamptz,
    '2021-10-24T14:33:26.480000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; 32K Mode
; Screen Width = 80 pixels
; 2nd screen starts at #c000+32 
; It could start at #c000-48, but need a bit more code :)

macro setCrtcReg reg, val
               ld bc, #bc00 + {reg} 
               out (c), c 
               inc b 
               ld c, {val}
               out (c), c
endm

main:
                di
                ld sp,#4000           
                ld hl, #c9fb
                ld (#38), hl
                ei

                setCrtcReg 6, 33
                setCrtcReg 7, 34
                setCrtcReg 12, #20 | (3<<2)
                setCrtcReg 13, #00
               
               
               
               
                jr $
                

; Donnees directement ecrite en memoire video

; Pattern 1
org #8000
 repeat 8,c3   
  repeat 25,c2
   repeat 80,c1
    if (c1>3.2*c2)
     db c3 
    else
     db #ff 
    endif
   rend
  rend
  ds 48,0  
 rend


; Pattern 2
org #c000+32
 repeat 8,c3   
  repeat 25,c2
   repeat 80,c1
    if (c1>3.2*c2)
     db c3 ^255 
    else
     db #55
    endif
   rend
  rend
if (c3<8)
ds 48,0  
endif 
 rend


',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: crtc
  SELECT id INTO tag_uuid FROM tags WHERE name = 'crtc';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 100: fade-out-2 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fade-out-2',
    'Imported from z80Code. Author: gurneyh. Transition avec motif "plasma"',
    'public',
    false,
    false,
    '2019-11-20T18:33:35.351000'::timestamptz,
    '2021-06-18T13:51:14.316000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; ==============================================================================
; CRTC
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc



; ------------------------------------------------------------------------------
;  I/O port address
CRTC_SELECT         equ #BC00
CRTC_WRITE          equ #BD00
CRTC_STATUS         equ #BE00
CRTC_READ           equ #BF00


macro WRITE_CRTC reg, val
                ld bc, CRTC_SELECT + {reg}
                ld a, {val}
                out (c), c
                inc b
                out (c), a
 endm

; ==============================================================================
; Gate Array
; ==============================================================================
; http://www.cpcwiki.eu/index.php/Gate_Array
; http://quasar.cpcscene.net/doku.php?id=assem:gate_array


; ------------------------------------------------------------------------------
;  I/O port address
GATE_ARRAY:     equ #7f00

; ------------------------------------------------------------------------------
; Registers
PENR:           equ %00000000
INKR:           equ %01000000
RMR:            equ %10000000

; ROM
UPPER_OFF       equ %00001000
UPPER_ON        equ %00000000
LOWER_OFF       equ %00000100
LOWER_ON        equ %00000000
ROM_OFF         equ UPPER_OFF | LOWER_OFF

macro SET_MODE mode 
                LD bc, GATE_ARRAY | RMR | ROM_OFF | {mode}
                out (c), c
endm
 
                di 
                ld hl, #c9fb
                ld (#38), hl
                ei

                SET_MODE 0
                WRITE_CRTC 1, 32
                WRITE_CRTC 2, 42
                WRITE_CRTC 6, 22

; ==============================================================================
; PPI
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc


macro WAIT_VBL
                ld b, hi(PPI_B)
@wait
                in a, (c)
                rra
                jr nc, @wait
endm


; ------------------------------------------------------------------------------
;  I/O port address
PPI_A               equ #f400
PPI_B               equ #f500
PPI_C               equ #f600
PPI_CONTROL         equ #f700



main_loop:
                WAIT_VBL

                SET_BORDER Color.fm_6
                ld b, 192                       
                ld ixh, 3       ; 256 * 3 + 192
                ld iy, .next 
                ld de, #c000

                exx
                ld hl, table
                exx
.loop:        
                exx
                ld a, (hl)
                inc (hl)
                inc hl
                cp 16
                exx
                jr nc, .next_chr
                
                ld h, hi(patterns)
                add a, a 
                ld l, a
                ld a, (hl)
                inc l
                ld h, (hl)
                ld l, a 
               
                jp (hl)
.next:          
                add hl, de  
                ld a, (hl)
                and c
                
                ld (hl), a 

                ld a, h 
                add a, 8 
                ld h, a 
                
                ld a, (hl)
                and c
                
                ld (hl), a
             
.next_chr:     
                inc e : inc de 
                djnz .loop
                dec ixh

                jp nz, .loop

                jr main_loop

align 256
patterns:
dw pattern_0
dw pattern_1
dw pattern_2
dw pattern_3
dw pattern_4
dw pattern_5
dw pattern_6
dw pattern_7
dw pattern_8
dw pattern_9
dw pattern_10
dw pattern_11
dw pattern_12
dw pattern_13
dw pattern_14
dw pattern_15


pattern_0:
ld hl, 0x0
ld c, 170
jp (iy)

pattern_1:
ld hl, 0x2001
ld c, 170
jp (iy)

pattern_2:
ld hl, 0x1
ld c, 170
jp (iy)

pattern_3:
ld hl, 0x2000
ld c, 170
jp (iy)

pattern_4:
ld hl, 0x1000
ld c, 85
jp (iy)

pattern_5:
ld hl, 0x3001
ld c, 85
jp (iy)

pattern_6:
ld hl, 0x1001
ld c, 85
jp (iy)

pattern_7:
ld hl, 0x3000
ld c, 85
jp (iy)

pattern_8:
ld hl, 0x0
ld c, 85
jp (iy)

pattern_9:
ld hl, 0x2001
ld c, 85
jp (iy)

pattern_10:
ld hl, 0x1
ld c, 85
jp (iy)

pattern_11:
ld hl, 0x2000
ld c, 85
jp (iy)

pattern_12:
ld hl, 0x1000
ld c, 170
jp (iy)

pattern_13:
ld hl, 0x3001
ld c, 170
jp (iy)

pattern_14:
ld hl, 0x1001
ld c, 170
jp (iy)

pattern_15:
ld hl, 0x3000
ld c, 170
jp (iy)



table:
db 187, 187, 187, 187, 187, 188, 190, 193, 196, 198, 199, 199, 196, 194, 192, 190, 189, 189, 190, 191, 194, 197, 202, 208, 215, 223, 231, 237, 241, 243, 243, 242
db 186, 186, 186, 186, 186, 187, 188, 191, 194, 196, 197, 196, 194, 191, 189, 187, 186, 186, 187, 188, 191, 195, 199, 205, 213, 221, 229, 236, 240, 242, 242, 241
db 185, 185, 184, 184, 184, 185, 187, 189, 191, 194, 194, 193, 191, 188, 185, 184, 183, 183, 183, 185, 188, 192, 197, 203, 211, 219, 227, 234, 238, 241, 241, 240
db 184, 184, 183, 183, 183, 184, 185, 187, 189, 191, 192, 190, 188, 185, 182, 180, 179, 179, 180, 182, 185, 189, 194, 201, 208, 217, 225, 232, 237, 239, 240, 239
db 183, 183, 182, 182, 182, 182, 183, 185, 187, 189, 189, 187, 185, 182, 179, 177, 176, 176, 177, 179, 182, 186, 192, 198, 206, 215, 224, 231, 235, 238, 239, 238
db 183, 182, 181, 181, 181, 181, 182, 183, 185, 187, 187, 185, 182, 178, 175, 173, 172, 172, 173, 176, 179, 183, 189, 196, 204, 213, 222, 229, 234, 237, 238, 237
db 182, 181, 181, 180, 179, 179, 180, 181, 183, 184, 184, 182, 179, 175, 172, 169, 168, 168, 170, 172, 176, 181, 187, 194, 202, 211, 220, 228, 233, 236, 237, 236
db 182, 181, 180, 179, 178, 178, 179, 180, 182, 182, 182, 180, 176, 172, 168, 166, 164, 165, 166, 169, 173, 178, 184, 192, 200, 210, 219, 226, 232, 235, 236, 235
db 181, 180, 179, 178, 178, 177, 178, 179, 180, 181, 180, 177, 173, 169, 165, 162, 160, 161, 163, 166, 171, 176, 182, 190, 199, 208, 218, 225, 231, 234, 235, 234
db 181, 180, 179, 178, 177, 177, 177, 178, 179, 179, 178, 175, 171, 166, 162, 158, 156, 157, 160, 164, 168, 174, 181, 189, 198, 207, 216, 224, 230, 233, 234, 234
db 181, 180, 178, 177, 177, 176, 176, 177, 178, 178, 177, 174, 170, 164, 159, 155, 152, 154, 157, 162, 167, 173, 180, 188, 197, 206, 216, 223, 229, 232, 233, 233
db 181, 179, 178, 177, 176, 176, 176, 177, 178, 178, 177, 173, 169, 163, 158, 153, 148, 152, 156, 161, 166, 172, 179, 187, 196, 205, 215, 222, 228, 231, 232, 232
db 181, 180, 178, 177, 176, 176, 176, 177, 177, 178, 176, 173, 169, 163, 158, 154, 152, 153, 156, 161, 166, 172, 179, 187, 195, 205, 214, 221, 227, 230, 231, 231
db 181, 180, 179, 177, 177, 176, 176, 177, 177, 178, 177, 174, 169, 165, 160, 157, 155, 156, 158, 162, 167, 172, 179, 186, 195, 204, 213, 220, 225, 229, 230, 230
db 181, 180, 179, 178, 177, 176, 176, 177, 178, 178, 177, 174, 170, 166, 162, 159, 158, 158, 160, 164, 168, 173, 179, 186, 194, 203, 212, 219, 224, 227, 228, 228
db 182, 180, 179, 178, 177, 177, 177, 177, 178, 178, 177, 175, 171, 168, 164, 162, 161, 161, 163, 165, 169, 174, 180, 186, 194, 202, 210, 217, 222, 225, 226, 226
db 182, 181, 180, 179, 178, 177, 177, 178, 178, 179, 178, 176, 173, 169, 166, 164, 163, 163, 165, 167, 170, 175, 180, 186, 193, 201, 208, 215, 219, 222, 223, 223
db 183, 182, 181, 180, 179, 178, 178, 178, 179, 179, 178, 176, 174, 171, 168, 166, 166, 166, 167, 169, 172, 175, 180, 186, 192, 199, 206, 212, 216, 219, 220, 220
db 183, 182, 181, 180, 179, 179, 179, 179, 180, 180, 179, 177, 175, 172, 170, 169, 168, 168, 169, 171, 173, 176, 181, 186, 192, 198, 204, 210, 213, 216, 217, 217
db 184, 183, 182, 181, 181, 180, 180, 180, 181, 181, 180, 179, 177, 174, 172, 171, 170, 170, 171, 173, 175, 178, 182, 186, 192, 198, 203, 208, 212, 214, 215, 215
db 185, 184, 183, 182, 182, 181, 181, 182, 182, 183, 182, 181, 179, 177, 175, 174, 173, 173, 174, 175, 177, 180, 184, 188, 193, 198, 204, 209, 212, 214, 215, 215
db 186, 185, 184, 184, 183, 183, 183, 184, 184, 185, 185, 184, 182, 180, 178, 177, 176, 176, 177, 178, 180, 183, 186, 190, 195, 201, 206, 210, 213, 215, 216, 216

macro fill_pattern col,lin
  repeat 8,c3   
   repeat {lin},c2
    repeat {col},c1
     if (c1>{col}/{lin}*c2)
      db #82  + #41
     else
      db #02 + #01
     endif
    rend
   rend
   ds 2048-{lin}*{col},0
  rend
mend


; Donnees directement ecrite en memoire video
 org #c000
 fill_pattern 64,22
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: transition
  SELECT id INTO tag_uuid FROM tags WHERE name = 'transition';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
