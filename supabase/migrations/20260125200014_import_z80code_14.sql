-- Migration: Import z80code projects batch 14
-- Projects 27 to 28
-- Generated: 2026-01-25T21:43:30.184705

-- Project 27: z80tests.o by Madram
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'z80tests.o',
    'Imported from z80Code. Author: Madram. z80tests.o from orgams',
    'public',
    false,
    false,
    '2020-04-24T11:53:14.891000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Z80tests.o / Madram
; http://memoryfull.net/post.php?id=58&page=1#744

;            _  _                _  _   _
; -=- () |/ /- / '' /. /| /|/ /) /- / ''_/ '' -=-  20/20

; Verify assumptions on Z80 behavior.
; Any failed test will trigger a breakpoint.

; MadraM / Overlanders! 

; v1: April 2020  Covid Edition.

      ORG &8000

          call ld_a_ir
          call f_untouched
          call bit_
          call rotate
          call rld_
          call djnz_
          call in_
          call out_
          call ldir_

; ---- Manual test -------------------
          call timing

; ---- Warning, long tests ahead -----
          call memory_block
          ret

; ------------------------------------

      MACRO SET_F
          call _set_f
      ENDM

      MACRO CHECK_F
          call _check_f
      ENDM


_set_f
; In: A=value
          push hl
          ld (reg_f),a  ; For comparison
          ld l,a
          ld h,a
          push hl
          pop af
          pop hl
          ret

_check_f
          push af:push hl
          push af
          pop hl
          ld a,(reg_f)
          cp l
          call nz,&BE00
          pop hl:pop af
          ret


; --------------------------------
f_untouched
; Check F isn''t modified (even bits 3 & 5)
; --------------------------------

          xor a
fu_lp
          push af

          SET_F()
          CHECK_F()     ; sanity
          CHECK_F()     ; very sanity

          ld a,c:CHECK_F()
          ld a,12:CHECK_F()
          ld b,(hl):CHECK_F()
          ld l,(ix-&80):CHECK_F()
          ld hl,trash:CHECK_F()
          ld (hl),1:CHECK_F()
          ld iy,trash:CHECK_F()
          ld (iy),a:CHECK_F()
          ld a,(&FFFF):CHECK_F()
          ld a,(bc):CHECK_F()
          ld de,trash:CHECK_F()
          ld (de),a:CHECK_F()
          ld r,a:CHECK_F()
          ld i,a:CHECK_F()
          ld bc,(&CAFE):CHECK_F()
          ld ix,(&BABE):CHECK_F()
          inc hl:CHECK_F()
          dec bc:CHECK_F()
          ld a,&BF:in a,(&AA):CHECK_F()
          ld b,&BC:out (c),d:CHECK_F()
          djnz $+2:CHECK_F()
          set 4,l:CHECK_F()
          res 7,a:CHECK_F()

          pop af
          inc a
          jp nz,fu_lp
          ret

; ------------------------------------
bit_
; Check F isn''t affected (including Z)
; I wasn''t sure anymore.
; ------------------------------------

          ld e,0
bit_lp
; E= initial F 

; ---- bit b,r -----
; Set F each time for test purpose.
          push de:pop af:bit 0,e:ld b,1:call bitcom
          push de:pop af:bit 1,e:ld b,2:call bitcom
          push de:pop af:bit 2,e:ld b,4:call bitcom
          push de:pop af:bit 3,e:ld b,8:call bitcom
          push de:pop af:bit 4,e:ld b,16:call bitcom
          push de:pop af:bit 5,e:ld b,32:call bitcom
          push de:pop af:bit 6,e:ld b,64:call bitcom
          push de:pop af:bit 7,e:ld b,128:call bitcom

; ---- bit b,(ix+n) -----
          ld ix,source:ld (ix),e

          push de:pop af:bit 0,(ix):ld b,1:call bitcomix
          push de:pop af:bit 1,(ix):ld b,2:call bitcomix
          push de:pop af:bit 2,(ix):ld b,4:call bitcomix
          push de:pop af:bit 3,(ix):ld b,8:call bitcomix
          push de:pop af:bit 4,(ix):ld b,16:call bitcomix
          push de:pop af:bit 5,(ix):ld b,32:call bitcomix
          push de:pop af:bit 6,(ix):ld b,64:call bitcomix
          push de:pop af:bit 7,(ix):ld b,128:call bitcomix

; ---- bit b,(hl) -----
; TODO, that''s even weirder regarding flags 5 & 3.

          inc e
          jp nz,bit_lp
          ret


bitcom
; In: B=msk tested bit.
    ; E=tested byte = F pre-op.
          push af:pop hl ; L: Snapshot F
; Check bit 5, 3 copy of initial value.
          ld a,e:xor l:and &28:call nz,&BE00
bitcom_
; Check bit S unchanged if bit 7 tested, 0 otherwise (and 7)
          ld a,e:and b:xor l:and &80:call nz,&BE00
; Check H is set
          bit 4,l:call z,&BE00
; Check N is reset
          bit 1,l:call nz,&BE00
; Check Carry unchanged
          ld a,e:xor l:and 1:call nz,&BE00
; Check P = Z 
          ld a,l:4 ** rlca:xor l:and &40:call nz,&BE00
          ret

bitcomix
; In: B=msk tested bit.
    ; E=tested byte = F pre-op.
          push af:pop hl ; L: Snapshot F
; Weird result of 5 and 3: TODO

; Other flags: like bit b,r
          call bitcom_  ; !! Use call for neater stack trace
          ret

; ----------------------------------
rotate
; Check some stuff about bit dancing
; ----------------------------------

          ld e,0
rotate_lp
          push de:pop af ; Set F for test purpose
          ld a,e
          rlca
          rla
          rrca
          2 ** rra      ; why not
          ld b,a        ; B:  snapshot A
          push af:pop hl ; L: snapshot F
; One byte versions shouldn''t have touched S, Z
          ld a,l:xor e:and &C0:call nz,&BE00
; 5, 3: copy of obtained value
          ld a,l:xor b:and &28:call nz,&BE00
; H and N should be 0
          ld a,l:and &12:call nz,&BE00
          inc e
          jr nz,rotate_lp
          ret

; ------------------------------------
rld_
; Check some stuff about rld
; ------------------------------------

          ld e,0
rld_lp
          ld a,e
          push de:pop af ; Set F for test purpose
          ld hl,trash
          rld
          push af:pop hl ; L: snapshot F
; Check carry isn''t touched
          ld a,l:xor e:and 1:call nz,&BE00
; Check H and N are reset
          ld a,l:and &12:call nz,&BE00
; TODO: other checks. I''m starting to saturate.

          inc e
          jr nz,rld_lp
          ret

; ------------------------------------
djnz_
; Check F isn''t affected (including Z)
; I wasn''t sure anymore.
; ------------------------------------

          ld e,0
djnz_lp
; E= initial F 
          push de:pop af ; Set F
          ld b,1
          djnz $+2
          push af:pop hl ; L: Snapshot F
          ld a,l:xor e:call nz,&BE00

; -- idem with b <> 1
          push de:pop af ; Set F
          ld b,0
          djnz $+2
          push af:pop hl ; L: Snapshot F
          ld a,l:xor e:and &BF:call nz,&BE00

          inc e
          jr nz,djnz_lp
          ret

; --------------------------------
ld_a_ir
; Check flags for ld a,i or ld a,r
; --------------------------------

; We iterate: for all positions for reset bit in I (resp R)
            ; * for all positions for set bit in initial F. 

          di            ; We check PV=0
          ld bc,&FE01
ld_a_ir_lp
          ld a,b:ld i,a
          push bc:pop af ; Set F
          ld a,i
          call test_ir_flags

          ld a,b:ld r,a
          push bc:pop af
          ld a,r
          call test_ir_flags

          rlc c
          jr nc,ld_a_ir_lp
          rlc b
          jr c,ld_a_ir_lp

          ei
          ret


test_ir_flags
; In: BC= AF before ld a,i or ld a,r
    ; AF= AF after  ld a,i or ld a,r
          push af:pop hl
; Flag S, 5, 3 set as A
          ld a,h:xor l:and &A8:call nz,fail
; Flag Z consistent
          call test_Z
; Flag H, P/V and N reset (since DI)
          ld a,l:and &16:call nz,fail
; Carry unchanged
          ld a,c:xor l:and 1:call nz,fail
          ret


test_Z
; Check flag Z is coherent with A
;In: HL= Snapshot of AF
          ld a,h
          or a:jr z,test_Z_zero
          bit 6,l:call nz,fail ; Expect Z not set: f.6 == 0
          ret

test_Z_zero
          bit 6,l:call z,fail ; Expect Z set, f.6 == 1
          ret

fail
      BRK
; !! Assertion failed.


; --------------------------
in_
; Test various IN behaviors.
; --------------------------

; Test with 256 read values.
          xor a
in_lp
          push af
          ld bc,&BC0F   ; cursor: each CRTC can read it
          out (c),c
          inc b:out (c),a
          ld e,a        ; Reference
          push de:pop af ; Set F for comparison purpose.
          ld a,&BF
; --- in a,(n) ---
          in a,(&7F)
          push af:pop hl ; snapshot F

; 0/ Show that An is the port read.
; - If port MSB was a copy of n (7F), CRTC wouldn''t have been read.
; - If port MSB was high impedance, well it''s likely &ff on naked CPC,
  ; but we don''t take account for possible coincidence.
  ; TODO: robuster test.
          cp e:call nz,&BE00

; 1/ Show that F is untouched
          ld a,l:cp e:call nz,&BE00

; --- in r,(c) --- 

          push de:pop af ; Set F for comparison purpose.
          ld b,&7F
          in c,(c)
          push af:pop hl ; Snapshot F
; 0/ Show that H, N are 0.
          ld a,l:and &12:call nz,&BE00
; 1/ Show that Carry is untouched.
          ld a,l:xor e:and 1:call nz,&BE00
; 2/ Show that S, Z, 5, 3, P reflects the value read.
          ld a,c:or a:push af:pop bc ; C: reference flags
          ld a,l:xor c:and &EC:call nz,&BE00

; --- ini ---
          ld hl,dest
          ld b,&BF
          ini
          push af:pop hl ; Snapshot F
; 0/ Show that B is decremented *before* the read.
          ld a,(dest):cp e:call nz,&BE00
; 1/ Show that S, Z, 5, 3 are affected as in dec B
  ;  (&BE -> S, NZ, 5, 3) 
          ld a,l:and &E8:cp &A8:call nz,&BE00
; 2/ Show N is a copy of bit 7 read.
          ld a,l:2 ** rrca:xor e:and &80:call nz,&BE00

          pop af
          inc a
          jr nz,in_lp
          ret

; ---------------------------
out_
; Test various OUT behaviors.
; ---------------------------

; Test with 256 writen values.
          xor a
out_lp
          push af
          ld e,a        ; Reference
; --- outi ---
          ld hl,source
          ld (hl),a
          push de:pop af ; Set F for comparison purpose.
          ld b,&BD
          outi
          push af:pop hl ; snapshot F
; 1/ Show that S, Z, 5, 3 are affected as in dec B
  ;  (&BC -> S, NZ, 5, 3) 
          ld a,l:and &E8:cp &A8:call nz,&BE00
; 2/ Show N is a copy of bit 7 written.
          ld a,l:2 ** rrca:xor e:and &80:call nz,&BE00
; 3/ Let n := val + l (where l is the value post outi)
          ld a,e:add source+1 AND &FF
; 3a/ Show C & H set iif n > 255 
          push af
          sbc a:xor l:and &11:call nz,&BE00
          pop af
; 3b/ Show P is the parity of (n and 7) xor b (post outi)
          and 7:xor b:push af:pop bc ; C: snapshot F
          ld a,c:xor l:and 4:call nz,&BE00

          pop af
          inc a
          jr nz,out_lp
          ret

; ----------------------
ldir_
; Show how ldir operates.
; ----------------------

; While BC > 1, ldir opcode is read again.
; That means than if ldir erase itself,
; the CPU just interprets the new opcode.

; Restore is test is called again
          ld hl,&FFFF:ld (fillhere+1),hl
          ld hl,&B0ED:ld (ldirop),hl ; Restore is test is called again

; We will copy tons of &01. 
; That is, until we replace LDIR opcode (ED B0) by 01 B0.
; Hence the rst (C7) won''t be executed. Instead, BC=&c7b0 
          ld hl,fillhere
          ld de,fillhere+1
fillhere  ld bc,&FFFF
ldirop    ldir
          rst 0

; Sanity check
          ld hl,&C7B0:or a:sbc hl,bc:call nz,&BE00
          ret

; --------------------------------
memory_block
; Check flags after LDI/LDIR/LDD/LDDR
; for the 256*256 possible combinations of A & copied byte.
; Takes 20 seconds to complete!
; --------------------------------

          ld bc,0
memory_block_lp
; B will feed A
; C will be the copied byte

; Set F ''randomly''
          add c:sbc b:rrca:ld l,a:push hl:pop af
; Show we are working (and that our value isn''t random at all)
          push bc
          ld a,l
          and &1F:or &40:ld b,&7F
          out (c),0:out (c),a
          pop bc

          ld a,c:ld (source),a
          ld a,b
          ld hl,source
          ld de,trash
          push af       ; snapshot 0
          ldi           ; <---- instruction tested
          pop de        ; e = F before ldi 
          push af:pop hl ; snapshot 1

;3/ P/V set iif BC reached 0
          call test_pv_zero
          inc bc        ; restore value

;1/ S, Z, C are unchanged
          ld a,l:xor e:and &C1:call nz,&BE00
;2/ H and N are reset
          ld a,l:and &12:call nz,&BE00
;4/ Let n be A + copied byte. 
;4a/ 3 if a copy of n.3
          ld a,b:add c:xor l:and 8:call nz,&BE00
;4a/ 5 if a copy of n.1
          ld a,b:add c:4 ** rlca:xor l:and &20:call nz,&BE00

; ------ Now for LDD, result must be exactly the same ------

          push de:pop af ; Same configuration.
          push de

          push hl
          ld hl,source
          ld de,trash
          ldd
          pop de        ;  E = flags after ldi
          push af:pop hl ; L = flags after ldd
          ld a,l:cp e:call nz,&BE00

          inc bc        ; restore value

; ------ For LDIR itoo, expect we necessarily reach BC=0 ------

          pop de
          push de:pop af ; Same configuration.
          push bc
          push de
          push hl
          ld hl,source-1 ; So that last byte is source
          ld de,trash
          ld bc,2
          ldir
          pop de        ;  E = flags after ldd
          push af:pop hl ; L = flags after ldir
          ld a,l:xor e:and &FB:call nz,&BE00
          call test_pv_is_zero ; BC=0 so P/V must be reset.

; ------ For LDDR: same as LDIR ------
          pop de
          pop bc
          push de:pop af ; Same configuratiorn
          push bc
          push hl
          ld hl,source+1 ; So that last byte is source
          ld de,trash+1
          ld bc,2
          lddr
          pop de        ;  E = flags after ldir
          push af:pop hl ; L = flags after lddr
          ld a,l:cp e:call nz,&BE00

          pop bc
          inc bc        ; next combination
          ld a,c:or b
          jp nz,memory_block_lp
          ret


test_pv_zero
; Cechk P/V is set iif BC is not zero.
; In:  BC (0 or not)
    ;   L = F snapshot
          ld a,c:or b:jr z,test_pv_is_zero
          bit 2,l:call z,&BE00 ; Must be set
          ret
test_pv_is_zero
          bit 2,l:call nz,&BE00 ; Must be reset
          ret


;--------------------------------------
timing

; Manually check timing of instructions
; If an instructions takes 1 us, it must be followed by call rast1
                         ; 2 us, ...                    call rast2 ...
; When all is good, there is a stable split raster shown for some frames

; NB: there is also a programmatic way to
    ; measure the timing of an instruction
    ; or a whole routine.
;--------------------------------------

          di
          ld a,&C9:ld (0),a ; For RST test

          ld bc,255     ; enough repetitions to see it''s stable
timing_lp
          push bc
          call rast14   ; Compensate for loop

; Exemple: NOP takes 1 NOP 
          nop:call rast1

          ld a,i:call rast3 ; Yes! That takes 3 NOPs
          ld i,a:call rast3
          ld a,r:call rast3
          ld r,a:call rast3
          ld a,(0):call rast4
          ld a,(ix+&7F):call rast5
          ld b,(ix-&80):call rast5
          ld ix,(&FFFF):call rast6

          add ix,ix:call rast4
          adc hl,sp:call rast4

          ld hl,0:call rast3 ; Needed for ld sp,hl
          add hl,sp:call rast3 ; Needed for ld sp,hl 
          ld sp,hl:call rast2
          exx:exx:call rast2

          ex (sp),hl:call rast6
          ex (sp),hl:call rast6 ; Restore

          ex (sp),ix:call rast7 ; Longuest instruction
          ex (sp),ix:call rast7 ; Restore

          bit 7,d:call rast2
          bit 7,(hl):call rast3
          bit 7,(ix+3):call rast6

          ld hl,trash:call rast3 ; Needed for next instructions
          rlc (hl):call rast4
          set 0,(hl):call rast4
          rrd:call rast5

          ld ix,trash:call rast4 ; Needed for next instructions
          rlc (ix+0):call rast7 ; Also quite long
      BYTE &DD,&CB,0,&01:call rast7 ; rlc (ix+0),c  doesn''t take longer
          set 7,(ix+0):call rast7
      BYTE &DD,&CB,0,&F8:call rast7 ; set 7,(ix+0),b

          add (hl):call rast2
          add (ix+3):call rast5
          ld hl,trash:call rast3 ; Needed for next instruction
          inc (hl):call rast3
          ld ix,trash:call rast4 ; Needed for next instruction
          inc (ix):call rast6

          di:call rast1
          neg:call rast2
          im 1:call rast2

          scf:call rast1
          scf:call nc,0:call rast4
          scf:call _ret_c:call rast10
          rst 0:call rast7
          scf:ret nc:call rast3
          call _reti:call rast9
          call _retn:call rast9

          ld a,&BC:out (&FF),a:call rast5
          ld a,&BF:in a,(&FF):call rast5
          ld hl,trash:call rast3 ; needed for next instructions
          ld b,&BF:ini:call rast7
          ld b,&BF:ind:call rast7
;--                    
          pop bc
          dec bc
          ld a,b:or c
          jp nz,timing_lp
          ei
          ret

;---------

_ret_c    ret c
_reti     reti
_retn     retn

rast1     nop
rast2     nop
rast3     nop
rast4     nop
rast5     nop
rast6     nop
rast7     nop
rast8     nop
rast9     nop
rast10
          4 ** nop
rast14
; Routine must takes 50 Nops (including CALL+RET)
          ld bc,&7F5D:out (c),0
          out (c),c
          ld b,5:djnz $:3 ** nop
          ld bc,&7F44:out (c),c
          ret


;=============================

reg_f BYTE 
source BYTE 
dest  BYTE 
trash WORD 
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: doc
  SELECT id INTO tag_uuid FROM tags WHERE name = 'doc';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 28: spirale-3 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'spirale-3',
    'Imported from z80Code. Author: gurneyh. Variante du programme spirale',
    'public',
    false,
    false,
    '2021-06-05T11:57:01.579000'::timestamptz,
    '2021-06-18T13:49:25.762000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Variante du programme de Demoniak
; - 256 (x3)dots au lieu de 32 (x3)
; - On évite les calculs en précalculant les adresses écran en Y
; - on utilise la pile pour effacer les dots
; - la boucle d''effacement est déroulée
; - utilisation d''un double buffer



; ---------------------------------------------------------------------------
; WAIT_VBL
 macro WAIT_VBL
                ld b, #f5
@wait
                in a, (c)
                rra
                jr nc, @wait
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

; ------------------------------------------------------------------------------
; RAM Banking
; -Address-     0      1      2      3      4      5      6      7
; 0000-3FFF   RAM_0  RAM_0  RAM_4  RAM_0  RAM_0  RAM_0  RAM_0  RAM_0
; 4000-7FFF   RAM_1  RAM_1  RAM_5  RAM_3  RAM_4  RAM_5  RAM_6  RAM_7
; 8000-BFFF   RAM_2  RAM_2  RAM_6  RAM_2  RAM_2  RAM_2  RAM_2  RAM_2
; C000-FFFF   RAM_3  RAM_7  RAM_7  RAM_7  RAM_3  RAM_3  RAM_3  RAM_3
RAM_P0          equ #0000
RAM_P1          equ #4000
RAM_P2          equ #8000
RAM_P3          equ #c000

; ------------------------------------------------------------------------------
; ROM
UPPER_OFF       equ %00001000
UPPER_ON        equ %00000000
LOWER_OFF       equ %00000100
LOWER_ON        equ %00000000
ROM_OFF         equ UPPER_OFF | LOWER_OFF

; ------------------------------------------------------------------------------
; Raster 52 divider
CLEAR_RASTER_DIV    equ %00010000

; ------------------------------------------------------------------------------
; Palette sorted by Hardware Colour Numbers
HW_PALETTE:
.WHITE          equ INKR | #00
.SEA_GREEN      equ INKR | #02
.PASTEL_YELLOW  equ INKR | #03
.BLUE           equ INKR | #04
.PURPLE         equ INKR | #05
.CYAN           equ INKR | #06
.PINK           equ INKR | #07
.BRIGHT_YELLOW  equ INKR | #0A
.BRIGHT_WHITE   equ INKR | #0B
.BRIGHT_RED     equ INKR | #0C
.BRIGHT_MAGENTA equ INKR | #0D
.ORANGE         equ INKR | #0E
.PASTEL_MAGENTA equ INKR | #0F
.BRIGHT_GRREN   equ INKR | #12
.BRIGHT_CYAN    equ INKR | #13
.BLACK          equ INKR | #14
.BRIGHT_BLUE    equ INKR | #15
.GREEN          equ INKR | #16
.SKY_BLUE       equ INKR | #17
.MAGENTA        equ INKR | #18
.PASTEL_GREEN   equ INKR | #19
.LIME           equ INKR | #1a
.PASTEL_CYAN    equ INKR | #1b
.RED            equ INKR | #1c
.MAUVE          equ INKR | #1d
.YELLOW         equ INKR | #1e
.PASTEL_BLUE    equ INKR | #1f

; ------------------------------------------------------------------------------
; Palette sorted by Firmware Colour Numbers
FW_PALETTE:
.BLACK           equ INKR |  #00
.BLUE            equ INKR |  #01
.BRIGHT_BLUE     equ INKR |  #02
.RED             equ INKR |  #03
.MAGENTA         equ INKR |  #04
.MAUVE           equ INKR |  #05
.BRIGHT_RED      equ INKR |  #06
.PURPLE          equ INKR |  #07
.BRIGHT_MAGENTA  equ INKR |  #08
.GREEN           equ INKR |  #09
.CYAN            equ INKR |  #0a
.SKY_BLUE        equ INKR |  #0b 
.YELLOW          equ INKR |  #0c 
.WHITE           equ INKR |  #0d
.PASTEL_BLUE     equ INKR |  #0e 
.ORANGE          equ INKR |  #0f
.PINK            equ INKR |  #10
.PASTEL_MAGENTA  equ INKR |  #11
.BRIGHT_GREEN    equ INKR |  #12
.SEA_GREEN       equ INKR |  #13
.BRIGHT_CYAN     equ INKR |  #14
.LIME            equ INKR |  #15
.PASTEL_GREEN    equ INKR |  #16
.PASTEL_CYAN     equ INKR |  #17
.BRIGHT_YELLOW   equ INKR |  #18
.PASTEL_YELLOW   equ INKR |  #19
.BRIGHT_WHITE    equ INKR |  #20

; -------------------------------------------------------------------------------------------
;
Color:
.fm_0:          equ #54
.fm_1:          equ #44
.fm_2:          equ #55
.fm_3:          equ #5C
.fm_4:          equ #58
.fm_5:          equ #5d
.fm_6:          equ #4C
.fm_7:          equ #45
.fm_8:          equ #4d
.fm_9:          equ #56
.fm_10:         equ #46         
.fm_11:         equ #57
.fm_12:         equ #5e
.fm_13:         equ #40
.fm_14:         equ #5f
.fm_15:         equ #4e
.fm_16:         equ #47
.fm_17:         equ #4f
.fm_18:         equ #52
.fm_19:         equ #42
.fm_20:         equ #53
.fm_21:         equ #5A
.fm_22:         equ #59
.fm_23:         equ #5b
.fm_24:         equ #4a
.fm_25:         equ #43
.fm_26:         equ #4B

macro SET_COLOR pen, ink
                ld bc, GATE_ARRAY | PENR | {pen}
                out (c), c
                ld c, {ink}
                out (c), c
endm


macro SET_BORDER ink 
                SET_COLOR #10, {ink}
endm

nbpt    	equ 256
decalpt 	equ 5
offsetx 	equ 15

start
	di
	SET_BORDER Color.fm_0
	SET_COLOR 0, Color.fm_0
	SET_COLOR 1, Color.fm_26
	SET_COLOR 2, Color.fm_14
	
main_loop:
	WAIT_VBL (void)
.bufadr	ld hl, buf1
	ld de, buf2
	ld (.bufadr + 1), de
	ld (.bufadr + 4), hl
.switch1	ld hl, #c030
.switch2	ld de, #c310
	ld (.switch1 + 1), de
	ld (.switch2 + 1), hl
	ex hl, de
	ld b, #7f
	out (c), h
	ld bc, #bc0c
	out (c), c
	inc b
	out (c), l
	dec b
	inc c
	xor a
	out (c), c
	inc b
	out (c), a

	call restore
	call render
	
	jp main_loop


render
	ld hl, .decal + 1
	inc (hl)
        	
        	
.angle	ld a, 0
        	add a, 1
        	ld (.angle + 1), a
        	ld c, a
        	ld b, nbpt	; 256 truncated to 0


	ld hl, (main_loop.bufadr + 1)
	ld de, nbpt * 2
	add hl, de
	
	ld (.save_stack + 1), sp
	ld sp, hl
.loop
        	ld h, hi(costab)
        	ld l, c
        	ld a, (hl)                  ; a = cos(angle)
        	add a, offsetx
        	ex af,af''
        	
.decal	ld a, 0
        	add b
        	add l
            	ld l, a
        	ld  a, (hl)
        
	ld h, hi(scr_adr)
	ld l, a
	ld d, (hl)
	inc h
	ld e, (hl)
       
        	ex  af,af''
        	ld l, a
        	ld h, 0
        	add hl,de
	push hl
        	ld de,#0ff0                ; octets à écrire
        	ld (hl),d
        	set 3, h                   ; #c8
        	ld (hl), e
        	set 4,h                    ; #d8
        	ld  (hl),d
	res 3,h                    ; #d0
        	ld  (hl),e

        	ld a, decalpt
        	add c
        	ld c, a
        	djnz .loop
			
.save_stack	ld sp, 0 
	ret


restore
	ld hl, (main_loop.bufadr + 1)
	ld (.save_stack + 1), sp
	ld sp, hl

	xor a
repeat nbpt
	pop hl
	xor     a
	ld      (hl),a
	set     3,h                     ; #c8
	ld      (hl),a
	set     4,h                     ; #d8
	ld      (hl),a
	res     3,h                     ; #d0
	ld      (hl),a
rend

.save_stack	ld sp, 0 
	ret

        	align	256

costab:
      
        db      #31, #31, #31, #31, #31, #31, #31, #31
        db      #31, #31, #31, #31, #31, #30, #30, #30
        db      #30, #30, #2f, #2f, #2f, #2e, #2e, #2e
        db      #2d, #2d, #2d, #2c, #2c, #2c, #2b, #2b
        db      #2a, #2a, #2a, #29, #29, #28, #28, #27
        db      #26, #26, #25, #25, #25, #24, #23, #23
        db      #22, #22, #21, #21, #20, #1f, #1f, #1e
        db      #1e, #1d, #1c, #1c, #1b, #1b, #1a, #19
        db      #18, #18, #18, #17, #16, #15, #15, #15
        db      #14, #13, #12, #12, #12, #11, #10, #10
        db      #0f, #0f, #0e, #0e, #0d, #0c, #0c, #0b
        db      #0b, #0a, #0a, #09, #09, #08, #08, #07
        db      #07, #07, #06, #06, #05, #05, #05, #04
        db      #04, #04, #03, #03, #03, #02, #02, #02
        db      #01, #01, #01, #01, #01, #00, #00, #00
        db      #00, #00, #00, #00, #00, #00, #00, #00
        db      #00, #00, #00, #00, #00, #00, #00, #00
        db      #00, #00, #00, #00, #00, #01, #01, #01
        db      #01, #01, #02, #02, #02, #03, #03, #03
        db      #04, #04, #04, #05, #05, #05, #06, #06
        db      #07, #07, #07, #08, #08, #09, #09, #0a
        db      #0b, #0b, #0c, #0c, #0c, #0d, #0e, #0e
        db      #0f, #0f, #10, #10, #11, #12, #12, #13
        db      #13, #14, #15, #15, #16, #16, #17, #18
        db      #19, #19, #19, #1a, #1b, #1c, #1c, #1c
        db      #1d, #1e, #1f, #1f, #1f, #20, #21, #21
        db      #22, #22, #23, #23, #24, #25, #25, #26
        db      #26, #27, #27, #28, #28, #29, #29, #2a
        db      #2a, #2a, #2b, #2b, #2c, #2c, #2c, #2d
        db      #2d, #2d, #2e, #2e, #2e, #2f, #2f, #2f
        db      #30, #30, #30, #30, #30, #31, #31, #31
        db      #31, #31, #31, #31, #31, #31, #31, #31


scr_adr
repeat 50, yy
y = (yy - 1) * 4
	db hi(#4000 + (y & 7) * #800 + (y >> 3) * 80)
rend

align 256
repeat 50, yy
y = (yy - 1) * 4
	db lo(#4000 + (y & 7) * #800 + (y >> 3) * 80)
rend

align 2
buf1
repeat nbpt
dw #4000
rend
buf1_end

buf2
repeat nbpt
dw #4000
rend
buf2_end

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
