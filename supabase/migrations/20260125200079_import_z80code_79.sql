-- Migration: Import z80code projects batch 79
-- Projects 157 to 158
-- Generated: 2026-01-25T21:43:30.206008

-- Project 157: lz48 by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'lz48',
    'Imported from z80Code. Author: siko. LZ48 Cruncher Example',
    'public',
    false,
    false,
    '2020-09-14T23:00:48.550000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'org #1000
run $


ld hl,crunch_section_start
ld de,#C000
call LZ48_decrunch
jr $


; Labels are correctly set
ld hl,crunch_section_start
ld bc,crunch_section_end-crunch_section_start
ld de,#c000
ldir
jr $



;
; LZ48 decrunch
;

; In	; HL=compressed data address
; 	; DE=output data address
; Out	; HL    last address of compressed data read (you must inc once for LZ48 stream)
;	; DE    last address of decrunched data write +1
;	; BC    always 3
;	; A     always zero
;	; IXL   undetermined
;	; flags (inc a -> 0)
; Modif	; AF, BC, DE, HL, IXL
LZ48_decrunch
	ldi
	ld b,0

nextsequence
	ld a,(hl)
	inc hl
	cp #10
	jr c,lzunpack ; no literal bytes
	ld ixl,a
	and #f0
	rrca
	rrca
	rrca
	rrca

	cp 15 ; more bytes for literal length?
	jr nz,copyliteral
getadditionallength
	ld c,(hl) ; get additional literal length byte
	inc hl
	add a,c ; compute literal length total
	jr nc,lengthNC
	inc b
lengthNC
	inc c
	jr z,getadditionallength ; if last literal length byte was 255, we have more bytes to process
copyliteral
	ld c,a
	ldir
	ld a,ixl
	and #F
lzunpack
	add 3
	cp 18 ; more bytes for match length?
	jr nz,readoffset
getadditionallengthbis
	ld c,(hl) ; get additional match length byte
	inc hl
	add a,c ; compute match length size total
	jr nc,lengthNCbis
	inc b
lengthNCbis
	inc c
	jr z,getadditionallengthbis ; if last match length byte was 255, we have more bytes to process

readoffset
	ld c,a
; read encoded offset
	ld a,(hl)
	inc a
	ret z ; LZ48 end with zero offset
	inc hl
	push hl
; source=dest-copyoffset
	; A != 0 here
	neg
	ld l,a
	ld h,#ff
	add hl,de
copykey
	ldir

	pop hl
	jr nextsequence
    
macro fill_pattern col,lin
  repeat 8,c3   
   repeat {lin},c2
    repeat {col},c1
     if (c1>{col}/{lin}*c2)
      db c3 and %01010101
     else
      db #aa | c3
     endif
    rend
   rend
   ds 2048-{lin}*{col},0
  rend
mend

crunch_section_start
lz48 ; -- this section will be crunched
fill_pattern 80,25
lzclose ; -- end of crunched section

crunch_section_end

; To see where crunched data ends 
ds 255,255

print $
print crunch_section_end - crunch_section_start

',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: rasm
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rasm';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 158: playing-wav2ay with zx music by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'playing-wav2ay with zx music',
    'Imported from z80Code. Author: tronic. wav2ay (Roudoudou)',
    'public',
    false,
    false,
    '2021-01-11T01:37:55.795000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; wav2ay, another test...
; On a small zx tune (mp3 to wav with audacity or pt3 to wav with ayemul)
; Source : https://zxart.ee/eng/authors/n/nq/deltas-shadow---pb-nova-was-summoned-intro-ts/
; player : 5.19 RL.
; ay datas (only values, registers are out) : 557 bytes.
; Funny !
;
; Roudourulez !
		
		BUILDSNA
		BANKSET 0
        
        org #100
		run $
start
		di
		ld hl,#c9fb
		ld (#38),hl

		ld (pile+1),sp
        
loop
		ld sp,wav2ay
		pop hl
		
        ld b,#f4:out (c),l
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),h
		ld bc,#f680:out (c),c
		out (c),0
		
        ld de,(wav2ay_zxts_fin-wav2ay_zxts_debut)/9

main
		ld b,#f5
sync	in a,(c)
		rra
		jr nc,sync
        
		ei:halt:halt:di

		ld bc,#7f10:out (c),c:ld a,#6c:out (c),a


	  	pop hl
		ld bc,#f408:out (c),c   ; 8
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),l
		ld bc,#f680:out (c),c
		out (c),0

		ld bc,#f4:out (c),0  	; 0
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),h
		ld bc,#f680:out (c),c
		out (c),0

        pop hl
        ld bc,#f401:out (c),c   ; 1
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),l
		ld bc,#f680:out (c),c
		out (c),0

        ld bc,#f409:out (c),c   ; 9
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),h
		ld bc,#f680:out (c),c
		out (c),0

        pop hl
        ld bc,#f402:out (c),c   ; 2
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),l
		ld bc,#f680:out (c),c
		out (c),0

        ld bc,#f403:out (c),c   ; 3
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),h
		ld bc,#f680:out (c),c
		out (c),0

        pop hl
        ld bc,#f40a:out (c),c   ; 10
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),l
		ld bc,#f680:out (c),c
		out (c),0

        ld bc,#f404:out (c),c   ; 4
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),h
		ld bc,#f680:out (c),c
		out (c),0

        pop hl
        ld bc,#f405:out (c),c   ; 5
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),l
		ld bc,#f680:out (c),c
		out (c),0

        dec sp
        
		ld bc,#7f10:out (c),c:ld a,#54:out (c),a        
		
        dec de
		ld a,d
		or e

		ei:halt:halt:di
		jp nz,main
        jp loop

pile	ld sp,0
		ei
		jr $


wav2ay
db #07,#38
wav2ay_zxts_debut

db 12,77,1,10,74,0,9,18,0
db 12,196,1,9,24,0,8,70,0
db 10,37,0,9,74,0,8,197,0
db 11,74,0,7,37,0,6,62,0
db 9,50,0,9,74,0,6,37,0
db 9,98,0,9,73,0,5,247,0
db 9,73,0,8,61,0,5,37,0
db 8,124,0,8,74,0,5,37,0
db 7,74,0,5,24,0,3,12,0
db 7,73,0,5,12,0,3,37,0
db 8,74,0,5,37,0,3,31,0
db 8,73,0,7,49,0,5,64,3
db 10,55,1,9,73,0,8,103,1
db 12,193,1,10,37,0,8,18,0
db 12,66,2,9,74,0,7,37,0
db 10,73,0,8,193,1,8,37,0
db 9,36,0,8,25,3,7,19,0
db 9,73,0,9,170,2,7,245,1
db 8,50,0,7,73,0,5,64,3
db 7,98,0,6,54,3,5,245,1
db 8,62,0,7,74,0,6,34,2
db 9,125,0,7,74,0,6,25,2
db 7,74,0,6,86,2,5,245,1
db 8,37,0,7,126,2,5,143,1
db 10,49,0,9,226,0,6,25,0
db 10,24,0,8,12,0,7,49,0
db 10,49,0,10,24,0,9,19,1
db 10,49,0,9,46,1,9,25,0
db 10,24,0,7,13,0,5,59,0
db 9,49,0,8,24,0,6,162,1
db 7,160,1,5,73,0,5,64,3
db 7,138,1,5,202,0,5,10,1
db 6,127,1,4,74,0,3,227,0
db 7,145,1,5,73,0,5,200,0
db 6,184,1,5,20,1,3,36,0
db 8,181,1,7,238,2,5,206,0
db 10,87,1,9,74,0,7,108,0
db 12,196,1,10,70,0,8,35,0
db 12,56,2,11,74,0,7,37,0
db 10,74,0,8,37,0,7,108,2
db 10,81,2,9,74,0,8,131,1
db 9,74,0,8,86,2,7,125,1
db 12,72,1,10,73,0,7,37,0
db 12,190,1,10,70,0,8,35,0
db 11,73,0,8,196,0,7,116,0
db 11,73,0,8,29,2,8,37,0
db 10,73,0,8,52,2,7,37,0
db 10,73,0,8,108,2,7,37,0
db 7,74,0,6,20,0,5,49,0
db 9,92,2,7,33,1,6,70,0
db 9,92,2,8,74,0,6,32,1
db 9,120,2,7,74,0,7,43,1
db 9,86,2,7,46,1,6,49,0
db 9,34,2,7,77,1,7,74,0
db 10,57,1,10,73,0,8,103,1
db 12,196,1,9,69,0,8,35,0
db 12,61,2,9,73,0,7,37,0
db 9,73,0,8,190,1,8,37,0
db 10,74,0,9,7,3,8,37,0
db 10,74,0,8,64,3,8,152,1
db 8,74,0,6,37,0,5,49,0
db 9,29,2,8,74,0,6,37,0
db 9,73,0,8,25,2,6,101,1
db 9,43,2,7,74,0,7,245,1
db 8,76,2,7,119,1,6,37,0
db 9,120,2,8,136,1,7,73,0
db 12,70,1,11,73,0,6,37,0
db 12,190,1,10,37,0,8,18,0
db 11,74,0,8,37,0,8,197,0
db 11,74,0,9,120,2,8,37,0
db 9,36,0,8,66,2,7,18,0
db 10,74,0,8,34,2,7,64,1
db 10,52,0,8,26,0,6,213,0
db 13,250,0,10,26,0,7,13,0
db 10,52,0,8,8,1,7,74,0
db 10,52,0,9,26,0,7,43,1
db 9,26,0,6,13,0,3,43,0
db 9,52,0,9,157,1,7,26,0
db 9,73,0,9,155,1,5,101,1
db 8,157,1,8,37,0,5,171,0
db 8,162,1,5,75,0,5,20,1
db 8,160,1,7,74,0,5,24,1
db 7,160,1,6,37,0,5,37,0
db 8,74,0,8,138,1,5,215,0
db 12,83,1,10,74,0,7,37,0
db 12,208,1,10,70,0,7,35,0
db 12,81,2,10,74,0,8,37,0
db 11,74,0,8,238,1,7,250,0
db 10,74,0,8,231,1,7,3,1
db 10,73,0,8,218,1,7,255,0
db 8,132,2,6,32,1,5,62,0
db 11,81,2,8,29,1,6,153,0
db 11,86,2,9,35,1,5,147,0
db 10,114,2,9,38,1,7,83,0
db 10,92,2,9,40,1,6,74,0
db 10,34,2,9,51,1,6,146,0
db 12,70,1,10,73,0,7,37,0
db 11,199,1,10,70,0,8,35,0
db 11,74,0,8,76,2,7,37,0
db 11,74,0,8,37,0,5,17,2
db 10,74,0,5,37,0,5,17,2
db 10,74,0,7,37,0,4,204,0
db 5,73,0,3,37,0,0,0,0
db 5,73,0,3,37,0,0,0,0
db 5,73,0,3,37,0,0,0,0
db 5,73,0,3,37,0,0,0,0
db 5,74,0,3,37,0,0,0,0
db 6,64,3,5,245,1,3,74,0
db 11,73,0,10,87,1,8,37,0
db 12,193,1,10,36,0,8,18,0
db 12,56,2,11,73,0,7,37,0
db 11,73,0,8,37,0,7,97,2
db 10,81,2,9,37,0,8,131,1
db 10,74,0,9,81,2,7,127,1
db 6,73,0,5,61,2,4,37,0
db 7,70,0,6,184,1,5,245,1
db 6,245,1,5,250,0,5,73,0
db 7,43,2,6,74,0,4,99,1
db 7,34,2,6,74,0,4,64,1
db 8,64,3,6,74,0,4,37,0
db 10,226,0,9,55,0,8,55,0
db 9,27,0,8,14,0,7,228,0
db 10,8,1,10,55,0,8,27,0
db 10,55,0,10,50,1,8,27,0
db 8,27,0,6,37,0,5,14,0
db 8,55,0,7,43,1,7,28,0
db 7,36,1,6,74,0,5,179,0
db 7,38,1,7,37,0,5,180,0
db 8,73,0,7,39,1,5,37,0
db 8,74,0,7,43,1,5,176,0
db 7,37,0,6,36,1,5,75,0
db 7,74,0,7,43,1,5,245,1
db 10,73,0,10,87,1,7,108,0
db 12,193,1,10,69,0,8,35,0
db 13,52,2,10,73,0,7,37,0
db 10,73,0,8,37,0,8,17,2
db 9,73,0,8,71,2,7,90,1
db 9,73,0,8,114,2,7,90,1
db 12,70,1,10,74,0,8,37,0
db 12,193,1,10,70,0,8,35,0
db 10,74,0,8,37,0,8,196,0
db 10,74,0,8,37,0,7,114,2
db 10,74,0,9,92,2,7,37,0
db 10,74,0,8,103,2,7,37,0
db 6,76,0,5,55,0,5,16,0
db 9,71,2,7,70,0,6,52,0
db 8,56,2,7,74,0,6,54,1
db 9,56,2,7,74,0,6,67,1
db 9,66,2,7,74,0,6,43,1
db 9,132,2,7,34,1,6,74,0
db 11,73,0,10,57,1,8,37,0
db 12,193,1,10,70,0,8,35,0
db 12,61,2,10,74,0,7,37,0
db 10,73,0,8,202,1,8,37,0
db 9,73,0,8,64,3,8,150,1
db 9,74,0,8,155,1,8,64,3
db 9,73,0,5,12,0,3,19,0
db 9,34,2,9,74,0,7,35,0
db 9,74,0,8,21,2,7,37,0
db 8,38,2,7,74,0,7,37,0
db 8,71,2,7,74,0,7,245,1
db 9,114,2,8,131,1,6,74,0
db 12,72,1,11,73,0,8,37,0
db 12,193,1,10,36,0,8,19,0
db 11,73,0,8,197,0,7,116,0
db 10,73,0,9,120,2,7,37,0
db 9,37,0,8,71,2,7,19,0
db 9,73,0,8,38,2,7,37,0
db 10,62,0,9,31,0,8,207,0
db 13,250,0,10,31,0,8,16,0
db 10,62,0,9,13,1,8,31,0
db 10,62,0,8,31,0,7,43,1
db 9,31,0,7,16,0,5,97,2
db 9,62,0,7,31,0,6,64,3
db 7,64,3,6,205,0,5,224,1
db 6,250,0,5,77,1,5,198,0
db 8,73,0,6,64,3,5,245,1
db 7,74,0,6,64,3,5,113,1
db 7,36,0,5,224,1,5,210,0
db 7,67,1,7,247,0,5,208,1
db 12,73,1,8,66,0,8,33,0
db 12,193,1,10,62,0,8,31,0
db 11,65,0,8,33,0,8,197,0
db 10,65,0,8,29,2,8,33,0
db 9,65,0,7,33,0,7,249,1
db 9,66,0,8,17,2,7,6,1
db 7,62,0,5,1,2,3,235,0
db 7,13,2,7,4,1,5,31,0
db 7,9,2,7,62,0,7,5,1
db 7,17,2,7,62,0,5,21,1
db 8,34,2,6,10,1,5,30,0
db 7,5,2,6,61,0,5,21,1
;
;db 0,0,0,0,0,0,0,0,0
;
wav2ay_zxts_fin
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: wav2ay-roudoudou
  SELECT id INTO tag_uuid FROM tags WHERE name = 'wav2ay-roudoudou';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
