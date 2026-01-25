-- Migration: Import z80code projects batch 64
-- Projects 127 to 128
-- Generated: 2026-01-25T21:43:30.201977

-- Project 127: program373 by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program373',
    'Imported from z80Code. Author: siko.',
    'public',
    false,
    false,
    '2023-04-15T16:07:59.662000'::timestamptz,
    '2023-04-15T16:23:22.705000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'module Circle

R1	equ #20
R2	equ #2a
R6	equ #20
R7	equ #22
        
start	di
	call initCrtc
loop        
    
    ld b,0
    ld c,10    
    ld a,250
firstloop
    push af    
    
    call random
	and 3
	ld hl, colors
	or l
	ld l, a
	ld a, (hl)
	ld (plot.color + 1), a
	
    ld h,120
    ld l,120
    
    push bc   
    call circle

    pop bc
    pop af
    
    inc c
    dec a
    jr nz, firstloop
    
    jr loop
   
    



circle
	ld a, c	
	srl a	; a = int(x/2)
	ld d, a	; d <= z
.loop
	; while x >= y
	ld a, c
	cp b
	ret c

	; xc + x, yc + y
	ld a, h		;a <= xc
	add c		;a <= xc + x 
	ld (plot.x + 1), a	
	ld a, l		;a <= yc
	add b		;a <= yc + y
	ld (plot.y + 1), a
	call plot

	; xc + x, yc - y
	;ld a, h
	;add c
	;ld (plot.x + 1), a
	ld a, l
	sub b
	ld (plot.y + 1), a
	call plot

	; xc - x, yc - y
	ld a, h
	sub c
	ld (plot.x + 1), a
	;ld a, l
	;sub b
	;ld (plot.y + 1), a
	call plot

	; xc - x, yc + y
	;ld a, h
	;sub c
	;ld (plot.x + 1), a
	ld a, l
	add b
	ld (plot.y + 1), a
	call plot

	; xc + y, yc + x
	ld a, h
	add b
	ld (plot.x + 1), a
	ld a, l
	add c
	ld (plot.y + 1), a
	call plot

	; xc + y, yc - x
	;ld a, h
	;add b
	;ld (plot.x + 1), a
	ld a, l
	sub c
	ld (plot.y + 1), a
	call plot

	; xc - y, yc - x
	ld a, h
	sub b
	ld (plot.x + 1), a
	;ld a, l
	;sub c
	;ld (plot.y + 1), a
	call plot

	; xc - y, yc + x
	;ld a, h
	;sub b
	;ld (plot.x + 1), a
	ld a, l
	add c
	ld (plot.y + 1), a
	call plot

	inc b	; y += 1
	ld a, d	
	sub b	
	ld d, a	; z -= y
	jr nc, .loop	
	; z < 0
	ld a, d
	add c
	ld d, a
	dec c	; x = x - 1
	jr .loop


plot:
	exx
	ld h, hi(scr_adr)
.y:	ld l, 0
	ld e, (hl)
	inc h
	ld d, (hl)
	ex hl, de
	
.x:	ld e, 0
	ld a, e
	srl e : srl e
	ld d, 0
	add hl, de
	
	ld c, %10001000		;Bitmask for MODE 1
	and 3		; a = X MOD 4
	jr z , .nshift		;-> = 0, no shift
.shift 	srl c		;move bitmask to pixel
	dec a		;loop counter
	jr nz, .shift		;-position

.nshift:	
.color	ld a, #ff
	xor (hl)
	and c
	xor (hl)
	ld (hl), a
	exx
	
	ret

initCrtc

	ld hl, CrtcValues
.loop:
	ld	b,#bd
	outi
	ld	b,#be
	outi
	ld	a,(hl)
	and	a
	jr	nz, .loop
	ret

;-----> Generate a random number
; output a=answer 0<=a<=255
; all registers are preserved except: af
random:
        push    hl
        push    de
        ld      hl,(randData)
        ld      a,r
        ld      d,a
        ld      e,(hl)
        add     hl,de
        add     a,l
        xor     h
        ld      (randData),hl
        pop     de
        pop     hl
        ret

randData	dw 0

align 4
colors:	db #00, #f0, #0f, #ff

CrtcValues
	db 1, R1,2,R2,6,R6,7,R7,12,#30,13,0,0

align 256
scr_adr
repeat 256, yy
_y = (yy - 1)
	db lo(#c000 + (_y & 7) * #800 + (_y >> 3) * R1 * 2)
rend

repeat 256, yy
_y = (yy - 1)
	db hi(#c000 + (_y & 7) * #800 + (_y >> 3) * R1 * 2)
rend

module off
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

-- Project 128: playerlightweight by Targhan
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'playerlightweight',
    'Imported from z80Code. Author: Targhan.',
    'public',
    false,
    false,
    '2019-10-25T15:54:07.349000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';       Arkos Tracker 2 Lightweight player (format V1 (used by AT2 since alpha4)).

;       ** This player has been superseded by the AKM format, more compact but also more powerful. Please use it instead. **

;       This compiles with RASM. Check the compatibility page on the Arkos Tracker 2 website, it contains a source converter to any Z80 assembler!

;   	This is a generic player, but much simpler and using only the most used features, so that the music and players are both
;   	lightweight. The player supports sound effects.

;       Though the player is optimized in speed, it is much slower than the generic one or the AKY player.
;       With effects used at the same time, it may reach 35 scanlines on a CPC, plus some few more if you are using sound effects.

;       The player uses the stack for optimizations. Make sure the interruptions are disabled before it is called.
;       The stack pointer is saved at the beginning and restored at the end.

;       Target harware:
;       ---------------
;       This code can target Amstrad CPC, MSX, Spectrum and Pentagon. By default, it targets Amstrad CPC.
;       Simply use one of the follow line (BEFORE this player):
;       PLY_LW_HARDWARE_CPC = 1
;       PLY_LW_HARDWARE_MSX = 1
;       PLY_LW_HARDWARE_SPECTRUM = 1
;       PLY_LW_HARDWARE_PENTAGON = 1
;       Note that the PRESENCE of this variable is tested, NOT its value.
;
;       Some severe optimizations of CPU/memory can be performed:
;       ---------------------------------------------------------
;       - Use the Player Configuration of Arkos Tracker 2 to generate a configuration file to be included at the beginning of this player.
;         It will disable useless features according to your songs! Check the manual for more details, or more simply the testers.
;
;       Sound effects:
;       --------------
;       Sound effects are disabled by default. Declare PLY_LW_MANAGE_SOUND_EFFECTS to enable it:
;       PLY_LW_MANAGE_SOUND_EFFECTS = 1
;       Check the sound effect tester to see how it enables it.
;       Note that the PRESENCE of this variable is tested, NOT its value.
;
;       ROM
;       ----------------------
;       No ROM player is available for this player. I suggest you try the AKM player, which is more powerful and more compact (albeit a bit slower).
;
;       -------------------------------------------------------

PLY_LW_Start:

        ;Checks the hardware. Only one must be selected.
PLY_LW_HardwareCounter = 0
        IFDEF PLY_LW_HARDWARE_CPC
                PLY_LW_HardwareCounter = PLY_LW_HardwareCounter + 1
        ENDIF
        IFDEF PLY_LW_HARDWARE_MSX
                PLY_LW_HardwareCounter = PLY_LW_HardwareCounter + 1
                PLY_LW_HARDWARE_SPECTRUM_OR_MSX = 1
        ENDIF
        IFDEF PLY_LW_HARDWARE_SPECTRUM
                PLY_LW_HardwareCounter = PLY_LW_HardwareCounter + 1
                PLY_LW_HARDWARE_SPECTRUM_OR_PENTAGON = 1
                PLY_LW_HARDWARE_SPECTRUM_OR_MSX = 1
        ENDIF
        IFDEF PLY_LW_HARDWARE_PENTAGON
                PLY_LW_HardwareCounter = PLY_LW_HardwareCounter + 1
                PLY_LW_HARDWARE_SPECTRUM_OR_PENTAGON = 1
        ENDIF
        IF PLY_LW_HARDWARECounter > 1
                FAIL ''Only one hardware must be selected!''
        ENDIF
        ;By default, selects the Amstrad CPC.
        IF PLY_LW_HARDWARECounter == 0
                PLY_LW_HARDWARE_CPC = 1
        ENDIF

PLY_LW_USE_HOOKS: equ 1                                 ;Use hooks for external calls? 0 if the Init/Play methods are directly called, will save a few bytes.
PLY_LW_STOP_SOUNDS: equ 1                               ;1 to have the "stop sounds" code. Set it to 0 if you never plan on stopping your music.

        ;Is there a loaded Player Configuration source? If no, use a default configuration.
        IFNDEF PLY_CFG_ConfigurationIsPresent
                PLY_CFG_UseTranspositions = 1
                PLY_CFG_UseSpeedTracks = 1
                PLY_CFG_UseEffects = 1
                PLY_CFG_UseHardwareSounds = 1
                PLY_CFG_NoSoftNoHard_Noise = 1
                PLY_CFG_SoftOnly_Noise = 1
                PLY_CFG_SoftOnly_SoftwareArpeggio = 1
                PLY_CFG_SoftOnly_SoftwarePitch = 1
                PLY_CFG_SoftToHard_SoftwarePitch = 1
                PLY_CFG_SoftToHard_SoftwareArpeggio = 1
                PLY_CFG_SoftAndHard_SoftwarePitch = 1
                PLY_CFG_SoftAndHard_SoftwareArpeggio = 1
                PLY_CFG_UseEffect_ArpeggioTable = 1
                PLY_CFG_UseEffect_PitchTable = 1
                PLY_CFG_UseEffect_PitchUp = 1
                PLY_CFG_UseEffect_PitchDown = 1
                PLY_CFG_UseEffect_SetVolume = 1
                PLY_CFG_UseEffect_Reset = 1
        ENDIF
        
        ;Agglomerates some flags, because they are treated the same way by this player.
        ;--------------------------------------------------
        ;Creates a flag for pitch in instrument, and also pitch in hardware.
        IFDEF PLY_CFG_SoftOnly_SoftwarePitch
                PLY_LW_PitchInInstrument = 1
        ENDIF
        IFDEF PLY_CFG_SoftToHard_SoftwarePitch
                PLY_LW_PitchInInstrument = 1
                PLY_LW_PitchInHardwareInstrument = 1
        ENDIF
        IFDEF PLY_CFG_SoftAndHard_SoftwarePitch
                PLY_LW_PitchInInstrument = 1
                PLY_LW_PitchInHardwareInstrument = 1
        ENDIF
        ;A flag for Arpeggios in Instrument, both in software and hardware.
        IFDEF PLY_CFG_SoftOnly_SoftwareArpeggio
                PLY_LW_ArpeggioInSoftwareOrHardwareInstrument = 1
        ENDIF
        IFDEF PLY_CFG_SoftToHard_SoftwareArpeggio
                PLY_LW_ArpeggioInSoftwareOrHardwareInstrument = 1
                PLY_LW_ArpeggioInHardwareInstrument = 1
        ENDIF
        IFDEF PLY_CFG_SoftAndHard_SoftwareArpeggio
                PLY_LW_ArpeggioInSoftwareOrHardwareInstrument = 1
                PLY_LW_ArpeggioInHardwareInstrument = 1
        ENDIF        
        
        ;A flag if noise is used (noise in hardware not tested, not present in this format).
        IFDEF PLY_CFG_NoSoftNoHard_Noise
                PLY_LW_USE_Noise = 1
        ENDIF
        IFDEF PLY_CFG_SoftOnly_Noise
                PLY_LW_USE_Noise = 1
        ENDIF
        ;The noise is managed? Then the noise register access must be compiled.
        IFDEF PLY_LW_USE_Noise
                PLY_LW_USE_NoiseRegister = 1
        ENDIF
        
        ;Mixing Pitch up/down effects.
        IFDEF PLY_CFG_UseEffect_PitchUp
                PLY_LW_USE_EffectPitchUpDown = 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_PitchDown
                PLY_LW_USE_EffectPitchUpDown = 1
        ENDIF
        ;Volume and Pitch up/down dual effects (if one exists, the other one too).
        IFDEF PLY_CFG_UseEffect_SetVolume
                PLY_LW_USE_Volume_And_PitchUpDown_Effects = 1
                PLY_LW_USE_EffectPitchUpDown = 1
        ENDIF
        IFDEF PLY_LW_USE_EffectPitchUpDown
                PLY_LW_USE_Volume_And_PitchUpDown_Effects = 1
                PLY_CFG_UseEffect_SetVolume = 1
        ENDIF
        ;Volume and Arpeggio Table dual effect (if one exists, the other one too).
        IFDEF PLY_CFG_UseEffect_SetVolume
                PLY_LW_USE_Volume_And_ArpeggioTable_Effects = 1
                PLY_CFG_UseEffect_ArpeggioTable = 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_ArpeggioTable
                PLY_LW_USE_Volume_And_ArpeggioTable_Effects = 1
                PLY_CFG_UseEffect_SetVolume = 1
        ENDIF
        ;Reset and Arpeggio Table dual effect (if one exists, the other one too).
        IFDEF PLY_CFG_UseEffect_Reset
                PLY_LW_USE_Reset_And_ArpeggioTable_Effects = 1
                PLY_CFG_UseEffect_ArpeggioTable = 1
        ENDIF
        IFDEF PLY_CFG_UseEffect_ArpeggioTable
                PLY_LW_USE_Reset_And_ArpeggioTable_Effects = 1
                PLY_CFG_UseEffect_Reset = 1
        ENDIF
        
        
        ;Disark macro: Word region Start.
        disarkCounter = 0
        IFNDEF dkws
        MACRO dkws
PLY_LW_DisarkWordRegionStart_{disarkCounter}
        ENDM
        ENDIF
        ;Disark macro: Word region End.
        IFNDEF dkwe
        MACRO dkwe
PLY_LW_DisarkWordRegionEnd_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF
        
        ;Disark macro: Pointer region Start.
        disarkCounter = 0
        IFNDEF dkps
        MACRO dkps
PLY_LW_DisarkPointerRegionStart_{disarkCounter}
        ENDM
        ENDIF
        ;Disark macro: Pointer region End.
        IFNDEF dkpe
        MACRO dkpe
PLY_LW_DisarkPointerRegionEnd_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF
        
        ;Disark macro: Byte region Start.
        disarkCounter = 0
        IFNDEF dkbs
        MACRO dkbs
PLY_LW_DisarkByteRegionStart_{disarkCounter}
        ENDM
        ENDIF
        ;Disark macro: Byte region End.
        IFNDEF dkbe
        MACRO dkbe
PLY_LW_DisarkByteRegionEnd_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF

        ;Disark macro: Force "No Reference Area" for 3 bytes (ld hl,xxxx).
        IFNDEF dknr3
        MACRO dknr3
PLY_LW_DisarkForceNonReferenceDuring3_{disarkCounter}:
        disarkCounter = disarkCounter + 1
        ENDM
        ENDIF
        
        
        
        ;Hooks for external calls. Can be removed if not needed.
        if PLY_LW_USE_HOOKS
		assert PLY_LW_Start == $		;Makes sure no extra byte were inserted before the hooks.
                jp PLY_LW_Init          ;Player + 0.
                jp PLY_LW_Play          ;Player + 3.
                if PLY_LW_STOP_SOUNDS
                jp PLY_LW_Stop          ;Player + 6.
                endif
        endif
        
        ;Includes the sound effects player, if wanted. Important to do it as soon as possible, so that
        ;its code can react to the Player Configuration and possibly alter it.
        IFDEF PLY_LW_MANAGE_SOUND_EFFECTS
		include "PlayerLightWeight_SoundEffects.asm"
        ENDIF
        ;[[INSERT_SOUND_EFFECT_SOURCE]]                 ;A tag for test units. Don''t touch or you''re dead.


;Initializes the song. MUST be called before actually playing the song.
;IN:    HL = Address of the song.
;       A = Index of the subsong to play (>=0).
PLY_LW_InitDisarkGenerateExternalLabel:
PLY_LW_Init:
        ;Reads the Song data.
        ;Skips the tag and format number.
dknr3:  ld de,5
        add hl,de

        ;Reads the pointers to the various index tables.
        ld de,PLY_LW_PtInstruments + 1
        ldi
        ldi
                        IFDEF PLY_CFG_UseEffects                           ;CONFIG SPECIFIC
                                IFDEF PLY_CFG_UseEffect_ArpeggioTable      ;CONFIG SPECIFIC
        ld de,PLY_LW_PtArpeggios + 1
        ldi
        ldi
                                ELSE
                                inc hl
                                inc hl
                                ENDIF ;PLY_CFG_UseEffect_ArpeggioTable
                                IFDEF PLY_CFG_UseEffect_PitchTable         ;CONFIG SPECIFIC
        ld de,PLY_LW_PtPitches + 1
        ldi
        ldi
                                ELSE
                                inc hl
                                inc hl
                                ENDIF ;PLY_CFG_UseEffect_PitchTable
                        ELSE
dknr3:  ld de,4
        add hl,de
                        ENDIF ;PLY_CFG_UseEffects

        ;Finds the address of the Subsong.
        ;HL points on the table, adds A * 2.
        ;Possible optimization: possible to set the Subsong directly.
        ld e,a
        ld d,0
        add hl,de
        add hl,de
        ld e,(hl)
        inc hl
        ld d,(hl)
        
        ;Reads the header of the Subsong.
        ld a,(de)       ;Gets the speed.
        inc de
        ld (PLY_LW_Linker + 1),de
        ld (PLY_LW_Speed + 1),a
        ;Forces a new line.
        dec a
        ld (PLY_LW_TickCounter + 1),a

        ;Can be removed if there is no need to reset the song.
        xor a
        ld (PLY_LW_PatternRemainingHeight + 1),a

        ;A big LDIR to erase all the data blocks. Optimization: can be removed if there is no need to reset the song.
        ld hl,PLY_LW_Track1_Data
        ld de,PLY_LW_Track1_Data + 1
dknr3:  ld bc,PLY_LW_Track3_Data_End - PLY_LW_Track3_Data - 1
        ld (hl),0
        ldir

        ;Reads the first instrument, the empty one, and set-ups the pointers to the instrument to read.
        ;Optimization: needed if the song doesn''t start with an instrument on all the channels. Else, it can be removed.
        ld hl,(PLY_LW_PtInstruments + 1)
        ld e,(hl)
        inc hl
        ld d,(hl)
        inc de          ;Skips the header.
        ld (PLY_LW_Track1_PtInstrument),de
        ld (PLY_LW_Track2_PtInstrument),de
        ld (PLY_LW_Track3_PtInstrument),de
        ret


;Cuts the channels, stopping all sounds.
        if PLY_LW_STOP_SOUNDS
PLY_LW_StopDisarkGenerateExternalLabel:
PLY_LW_Stop:
        ld (PLY_LW_SaveSP + 1),sp

        xor a
        ld (PLY_LW_Track1_Volume),a
        ld (PLY_LW_Track2_Volume),a
        ld (PLY_LW_Track3_Volume),a
        IFDEF PLY_LW_HARDWARE_MSX
                ld a,%10111111          ;Bit 7/6 must be 10 on MSX!
        ELSE
                ld a,%00111111          ;On CPC, bit 6 must be 0! Other platforms don''t care.
        ENDIF
        ld (PLY_LW_MixerRegister),a
        jp PLY_LW_SendPsg
        endif ;PLY_LW_STOP_SOUNDS

;Plays one frame of the song. It MUST have been initialized before.
;The stack is saved and restored, but is diverted, so watch out for the interruptions.
PLY_LW_PlayDisarkGenerateExternalLabel:
PLY_LW_Play:
        ld (PLY_LW_SaveSP + 1),sp

        ;Reads a new line?
PLY_LW_TickCounter: ld a,0
        inc a
PLY_LW_Speed: cp 1                       ;Speed (>0).
        jp nz,PLY_LW_TickCounterManaged

        ;A new line must be read. But have we reached the end of the Pattern?
PLY_LW_PatternRemainingHeight: ld a,0              ;Height. If 0, end of the pattern.
        sub 1
        jr c,PLY_LW_Linker
        ;Pattern not ended. No need to read the Linker.
        ld (PLY_LW_PatternRemainingHeight + 1),a
        jr PLY_LW_ReadLine

        ;New pattern. Reads the Linker.
dknr3:
PLY_LW_Linker: ld hl,0
PLY_LW_LinkerPostPt:
        ;Resets the possible empty cell counter of each Track.
        xor a
        ld (PLY_LW_Track1_WaitEmptyCell),a
        ld (PLY_LW_Track2_WaitEmptyCell),a
        ld (PLY_LW_Track3_WaitEmptyCell),a

        ;Reads the state byte of the pattern.
        ld a,(hl)
        inc hl
        rra
        jr c,PLY_LW_LinkerNotEndOfSongOk
        ;End of song.
        ld a,(hl)               ;Reads where to loop in the Linker.
        inc hl
        ld h,(hl)
        ld l,a
        jr PLY_LW_LinkerPostPt

PLY_LW_LinkerNotEndOfSongOk:
        rra
        ld b,a
                        IFDEF PLY_CFG_UseSpeedTracks            ;CONFIG SPECIFIC        
        ;New speed?
        jr nc,PLY_LW_LinkerAfterSpeed
        ld a,(hl)
        inc hl
        ld (PLY_LW_Speed + 1),a
PLY_LW_LinkerAfterSpeed:
                        ENDIF ;PLY_CFG_UseSpeedTracks

        ;New height?
        rr b
        jr nc,PLY_LW_LinkerUsePreviousHeight
        ld a,(hl)
        inc hl
        ld (PLY_LW_LinkerPreviousRemainingHeight + 1),a
        jr PLY_LW_LinkerSetRemainingHeight
        ;The same height is used. It was stored before.
PLY_LW_LinkerUsePreviousHeight:
PLY_LW_LinkerPreviousRemainingHeight: ld a,0
PLY_LW_LinkerSetRemainingHeight:
        ld (PLY_LW_PatternRemainingHeight + 1),a

        ;New transpositions?
        rr b
                        IFDEF PLY_CFG_UseTranspositions         ;CONFIG SPECIFIC
        jr nc,PLY_LW_LinkerAfterNewTranspositions
        ;New transpositions.
        ld de,PLY_LW_Track1_Transposition
        ldi
        ld de,PLY_LW_Track2_Transposition
        ldi
        ld de,PLY_LW_Track3_Transposition
        ldi
PLY_LW_LinkerAfterNewTranspositions:
                        ENDIF ;PLY_CFG_UseTranspositions

        ;Reads the 3 track pointers.
        ld de,PLY_LW_Track1_PtTrack
        ldi
        ldi
        ld de,PLY_LW_Track2_PtTrack
        ldi
        ldi
        ld de,PLY_LW_Track3_PtTrack
        ldi
        ldi
        ld (PLY_LW_Linker + 1),hl

;Reads the Tracks.
;---------------------------------
PLY_LW_ReadLine:
dknr3:
PLY_LW_PtInstruments:   ld de,0
        exx
        ld ix,PLY_LW_Track1_Data
        call PLY_LW_ReadTrack
        ld ix,PLY_LW_Track2_Data
        call PLY_LW_ReadTrack
        ld ix,PLY_LW_Track3_Data
        call PLY_LW_ReadTrack

        xor a
PLY_LW_TickCounterManaged:
        ld (PLY_LW_TickCounter + 1),a



;Plays the sound stream.
;---------------------------------
                ld de,PLY_LW_PeriodTable
        exx

        ld c,%11100000          ;Register 7, shifted of 2 to the left. Bits 2 and 5 will be possibly changed by each iteration.

        ld ix,PLY_LW_Track1_Data
                        IFDEF PLY_CFG_UseEffects        ;CONFIG SPECIFIC
        call PLY_LW_ManageEffects
                        ENDIF ;PLY_CFG_UseEffects
        ld iy,PLY_LW_Track1_Registers
        call PLY_LW_PlaySoundStream

        srl c                   ;Not RR, because we have to make sure the b6 is 0, else no more keyboard (on CPC)!
                                ;Also, on MSX? bit 6 must be 0.
        ld ix,PLY_LW_Track2_Data
                        IFDEF PLY_CFG_UseEffects        ;CONFIG SPECIFIC
        call PLY_LW_ManageEffects
                        ENDIF ;PLY_CFG_UseEffects
        ld iy,PLY_LW_Track2_Registers
        call PLY_LW_PlaySoundStream

        IFDEF PLY_LW_HARDWARE_MSX
                scf             ;On MSX, bit 7 must be 1.
                rr c
        ELSE
                rr c            ;On other platforms, we don''t care about b7.
        ENDIF
        ld ix,PLY_LW_Track3_Data
                        IFDEF PLY_CFG_UseEffects        ;CONFIG SPECIFIC
        call PLY_LW_ManageEffects
                        ENDIF ;PLY_CFG_UseEffects
        ld iy,PLY_LW_Track3_Registers
        call PLY_LW_PlaySoundStream

        ld a,c

;Plays the sound effects, if desired.
;-------------------------------------------
        IFDEF PLY_LW_MANAGE_SOUND_EFFECTS
                        call PLY_LW_PlaySoundEffectsStream
        ELSE
                        ld (PLY_LW_MixerRegister),a
        ENDIF ;PLY_LW_MANAGE_SOUND_EFFECTS



;Sends the values to the PSG.
;---------------------------------
PLY_LW_SendPsg:
        ld sp,PLY_LW_Registers_RetTable

        IFDEF PLY_LW_HARDWARE_CPC
dknr3:  ld bc,#f680
        ld a,#c0
dknr3:  ld de,#f4f6
        out (c),a	;#f6c0          ;Madram''s trick requires to start with this. out (c),b works, but will activate K7''s relay! Not clean.
        ENDIF

        IFDEF PLY_LW_HARDWARE_SPECTRUM_OR_PENTAGON
dknr3:  ld de,#bfff
dknr3:  ld bc,#fffd
        ENDIF

PLY_LW_SendPsgRegister:
        pop hl          ;H = value, L = register.
PLY_LW_SendPsgRegisterAfterPop:

        IFDEF PLY_LW_HARDWARE_CPC
        ld b,d
        out (c),l       ;#f400 + register.
        ld b,e
        out (c),0       ;#f600
        ld b,d
        out (c),h       ;#f400 + value.
        ld b,e
        out (c),c       ;#f680
        out (c),a       ;#f6c0
        ENDIF

        IFDEF PLY_LW_HARDWARE_SPECTRUM_OR_PENTAGON
        out (c),l       ;#fffd + register.
        ld b,d
        out (c),h       ;#bffd + value
        ld b,e
        ENDIF

        IFDEF PLY_LW_HARDWARE_MSX
        ld a,l          ;Register.
        out (#a0),a
        ld a,h          ;Value.
        out (#a1),a
        ENDIF

        ret

                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
PLY_LW_SendPsgRegisterR13:

        ;Should the R13 be played? Yes only if different. No "force retrig" is managed by this player.
PLY_LW_SetReg13: ld a,0
PLY_LW_SetReg13Old: cp 0
        jr z,PLY_LW_SendPsgRegisterEnd
        ;Different. R13 must be played. Updates the old R13 value.
        ld (PLY_LW_SetReg13Old + 1),a

        ld h,a
        ld l,13
        IFDEF PLY_LW_HARDWARE_CPC
                ld a,#c0
        ENDIF
        ret                     ;Sends the 13th registers.
                        ENDIF ;PLY_CFG_UseHardwareSounds

PLY_LW_SendPsgRegisterEnd:

dknr3:
PLY_LW_SaveSP: ld sp,0
        ret










;Reads a Track.
;IN:    IX = Data block of the Track.
;       DE''= Instrument table. Do not modify!
PLY_LW_ReadTrack:
        ;Are there any empty lines to wait?
        ld a,(ix + PLY_LW_Data_OffsetWaitEmptyCell)
        sub 1
        jr c,PLY_LW_RT_NoEmptyCell
        ;Wait!
        ld (ix + PLY_LW_Data_OffsetWaitEmptyCell),a
        ret

PLY_LW_RT_NoEmptyCell:
        ;Reads the Track pointer.
        ld l,(ix + PLY_LW_Data_OffsetPtTrack + 0)
        ld h,(ix + PLY_LW_Data_OffsetPtTrack + 1)
        ld a,(hl)
        inc hl
        ld b,a
        and %111111     ;Keeps only the note.
        sub 60
        jr c,PLY_LW_RT_NoteMaybeEffect
                        IFDEF PLY_CFG_UseEffects        ;CONFIG SPECIFIC
        jr z,PLY_LW_RT_ReadEffect       ;No note, but effect.
                        ENDIF ;PLY_CFG_UseEffects
        dec a
        jr z,PLY_LW_RT_WaitLong
        dec a
        jr z,PLY_LW_RT_WaitShort
        ;63: Escape code for a note, because octave <2 or >5.
        ;Reads the note.
        ld a,(hl)
        inc hl
        ;The rest is exactly as the "note maybe effect", as B contains the flag to know about the possible
        ;New Instrument and/or Effect?.
        jr PLY_LW_RT_NMB_AfterOctaveCompensation

PLY_LW_RT_NoteMaybeEffect:
        ;A is the note from octave 2, and 60 to compensate the sub above.
        ;Then adds the transposition.
        add a,12 * 2 + 60
PLY_LW_RT_NMB_AfterOctaveCompensation:
                        IFDEF PLY_CFG_UseTranspositions         ;CONFIG SPECIFIC
        add a,(ix + PLY_LW_Data_OffsetTransposition)
                        ENDIF ;PLY_CFG_UseTranspositions
        ld (ix + PLY_LW_Data_OffsetBaseNote),a

        ;New Instrument?
        rl b
        jr c,PLY_LW_RT_NME_NewInstrument
        ;Same Instrument. Retrieves the address previously stored.
        ld a,(ix + PLY_LW_Data_OffsetPtBaseInstrument + 0)
        ld (ix + PLY_LW_Data_OffsetPtInstrument + 0),a
        ld a,(ix + PLY_LW_Data_OffsetPtBaseInstrument + 1)
        ld (ix + PLY_LW_Data_OffsetPtInstrument + 1),a
        jr PLY_LW_RT_NME_AfterInstrument

PLY_LW_RT_NME_NewInstrument:
        ;New Instrument, reads it.
        ld a,(hl)
        inc hl
        exx
                ;Gets the address of the Instrument.
                ld l,a  ;No need to *2, it is already encoded like that.
                ld h,0
                add hl,de       ;Adds to the Instrument Table.
                ld c,(hl)
                inc hl
                ld b,(hl)
                ;Reads the header of the Instrument.
                ld a,(bc)       ;Speed.
                ld (ix + PLY_LW_Data_OffsetInstrumentSpeed),a
                inc bc
                ;Stores the pointer on the data of the Instrument.
                ld (ix + PLY_LW_Data_OffsetPtInstrument + 0),c
                ld (ix + PLY_LW_Data_OffsetPtInstrument + 1),b
                ld (ix + PLY_LW_Data_OffsetPtBaseInstrument + 0),c              ;Useful to store the base Instrument address to retrieve it when
                ld (ix + PLY_LW_Data_OffsetPtBaseInstrument + 1),b              ;there is a new instrument, without providing its number (optimization).
        exx
PLY_LW_RT_NME_AfterInstrument:
        ;Resets the step on the Instrument.
        ld (ix + PLY_LW_Data_OffsetInstrumentCurrentStep),0

        ;Resets the Track pitch.
                        IFDEF PLY_CFG_UseEffects        ;CONFIG SPECIFIC
        xor a
                                        IFDEF PLY_LW_USE_EffectPitchUpDown              ;CONFIG SPECIFIC
        ld (ix + PLY_LW_Data_OffsetIsPitchUpDownUsed),a
        ld (ix + PLY_LW_Data_OffsetTrackPitchInteger + 0),a
        ld (ix + PLY_LW_Data_OffsetTrackPitchInteger + 1),a
                                        ENDIF ;PLY_LW_USE_EffectPitchUpDown
        ;ld (ix + PLY_LW_Data_OffsetTrackPitchDecimal),a                ;Shouldn''t be needed, the difference shouldn''t be noticeable.
        ;Resets the offset on Arpeggio and Pitch tables.
                                        IFDEF PLY_CFG_UseEffect_ArpeggioTable           ;CONFIG SPECIFIC
        ld (ix + PLY_LW_Data_OffsetPtArpeggioOffset),a
                                        ENDIF ;PLY_CFG_UseEffect_ArpeggioTable
                                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
        ld (ix + PLY_LW_Data_OffsetPtPitchOffset),a
                                        ENDIF ;PLY_CFG_UseEffect_PitchTable

                        ENDIF ;PLY_CFG_UseEffects

        ;Any effect? If no, stop.
        rl b
        jr nc,PLY_LW_RT_CellRead
        ;Effect present.
        ;jr PLY_LW_RT_ReadEffect

                        IFDEF PLY_CFG_UseEffects        ;CONFIG SPECIFIC
PLY_LW_RT_ReadEffect:
        ;Reads effect number and possible data.
        ld a,(hl)
        inc hl
        ld b,a
        exx
                rra
                rra
                rra
                rra
                and %1110
                ld iy,PLY_LW_EffectTable
                ld c,a
                ld b,0
                add iy,bc
        exx
        jp (iy)
                        ENDIF ;PLY_CFG_UseEffects

PLY_LW_RT_WaitLong:
        ;A 8-bit byte is encoded just after.
        ld a,(hl)
        inc hl
        ld (ix + PLY_LW_Data_OffsetWaitEmptyCell),a
        jr PLY_LW_RT_CellRead
PLY_LW_RT_WaitShort:
        ;Only a 2-bit value is encoded.
        ld a,b
        rla                     ;Transfers the bit 7/6 to 1/0.
        rla
        rla
        and %11
        ;inc a
        ld (ix + PLY_LW_Data_OffsetWaitEmptyCell),a
        ;jr PLY_LW_RT_CellRead
;Jumped to after the Cell has been read.
;IN:    HL = new value of the Track pointer. Must point after the read Cell.
PLY_LW_RT_CellRead:
        ld (ix + PLY_LW_Data_OffsetPtTrack + 0),l
        ld (ix + PLY_LW_Data_OffsetPtTrack + 1),h
        ret


;Manages the effects, if any. For the activated effects, modifies the internal data for the Track which data block is given.
;IN:    IX = data block of the Track.
;OUT:   IX, IY = unmodified.
;       C must NOT be modified!
;       DE'' must NOT be modified!
                        IFDEF PLY_CFG_UseEffects                ;CONFIG SPECIFIC
PLY_LW_ManageEffects:
                        IFDEF PLY_LW_USE_EffectPitchUpDown      ;CONFIG SPECIFIC
        ;Pitch up/down used?
        ld a,(ix + PLY_LW_Data_OffsetIsPitchUpDownUsed)
        or a
        jr z,PLY_LW_ME_PitchUpDownFinished

        ;Adds the LSB of integer part and decimal part, using one 16 bits operation.
        ld l,(ix + PLY_LW_Data_OffsetTrackPitchDecimal)
        ld h,(ix + PLY_LW_Data_OffsetTrackPitchInteger + 0)

        ld e,(ix + PLY_LW_Data_OffsetTrackPitchSpeed + 0)
        ld d,(ix + PLY_LW_Data_OffsetTrackPitchSpeed + 1)

        ld a,(ix + PLY_LW_Data_OffsetTrackPitchInteger + 1)

        ;Negative pitch?
        bit 7,d
        jr nz,PLY_LW_ME_PitchUpDown_NegativeSpeed

PLY_LW_ME_PitchUpDown_PositiveSpeed:
        ;Positive speed. Adds it to the LSB of the integer part, and decimal part.
        add hl,de

        ;Carry? Transmits it to the MSB of the integer part.
        adc 0
        jr PLY_LW_ME_PitchUpDown_Save
PLY_LW_ME_PitchUpDown_NegativeSpeed:
        ;Negative speed. Resets the sign bit. The encoded pitch IS positive.
        ;Subtracts it to the LSB of the integer part, and decimal part.
        res 7,d

        or a
        sbc hl,de

        ;Carry? Transmits it to the MSB of the integer part.
        sbc 0

PLY_LW_ME_PitchUpDown_Save:
        ld (ix + PLY_LW_Data_OffsetTrackPitchInteger + 1),a

        ld (ix + PLY_LW_Data_OffsetTrackPitchDecimal),l
        ld (ix + PLY_LW_Data_OffsetTrackPitchInteger + 0),h

PLY_LW_ME_PitchUpDownFinished:
                        ENDIF   ;PLY_LW_USE_EffectPitchUpDown


        ;Manages the Arpeggio Table effect, if any.
                        IFDEF PLY_CFG_UseEffect_ArpeggioTable           ;CONFIG SPECIFIC
        ld a,(ix + PLY_LW_Data_OffsetIsArpeggioTableUsed)
        or a
        jr z,PLY_LW_ME_ArpeggioTableFinished
        ;Reads the Arpeggio Table. Adds the Arpeggio base address to an offset.
        ld e,(ix + PLY_LW_Data_OffsetPtArpeggioTable + 0)
        ld d,(ix + PLY_LW_Data_OffsetPtArpeggioTable + 1)
        ld l,(ix + PLY_LW_Data_OffsetPtArpeggioOffset)
PLY_LW_ME_ArpeggioTableReadAgain: ld h,0
        add hl,de
        ld a,(hl)
        ;End of the Arpeggio?
        sra a
        jr nc,PLY_LW_ME_ArpeggioTableEndNotReached
        ;End of the Arpeggio. The loop offset is now in A.
        ld l,a  ;And read the next value!
        ld (ix + PLY_LW_Data_OffsetPtArpeggioOffset),a
        jr PLY_LW_ME_ArpeggioTableReadAgain

PLY_LW_ME_ArpeggioTableEndNotReached:
        ;Not the end. A = arpeggio note.
        ld (ix + PLY_LW_Data_OffsetCurrentArpeggioValue),a
        ;Increases the offset for next time.
        inc (ix + PLY_LW_Data_OffsetPtArpeggioOffset)
PLY_LW_ME_ArpeggioTableFinished:
                        ENDIF ;PLY_CFG_UseEffect_ArpeggioTable


        ;Manages the Pitch Table effect, if any.
                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
        ld a,(ix + PLY_LW_Data_OffsetIsPitchTableUsed)
        or a
        ret z
        ;Reads the Pitch Table. Adds the Pitch base address to an offset.
        ld e,(ix + PLY_LW_Data_OffsetPtPitchTable + 0)
        ld d,(ix + PLY_LW_Data_OffsetPtPitchTable + 1)
        ld l,(ix + PLY_LW_Data_OffsetPtPitchOffset)
PLY_LW_ME_PitchTableReadAgain: ld h,0
        add hl,de
        ld a,(hl)
        ;End of the Pitch?
        sra a
        jr nc,PLY_LW_ME_PitchTableEndNotReached
        ;End of the Pitch. The loop offset is now in A.
        ld l,a  ;And read the next value!
        ld (ix + PLY_LW_Data_OffsetPtPitchOffset),a
        jr PLY_LW_ME_PitchTableReadAgain

PLY_LW_ME_PitchTableEndNotReached:
        ;Not the end. A = pitch note. It is converted to 16 bits.
        ld h,0
        or a
        jp p,PLY_LW_ME_PitchTableEndNotReached_Positive
        dec h
PLY_LW_ME_PitchTableEndNotReached_Positive:
        ld (ix + PLY_LW_Data_OffsetCurrentPitchTableValue + 0),a
        ld (ix + PLY_LW_Data_OffsetCurrentPitchTableValue + 1),h
        ;Increases the offset for next time.
        inc (ix + PLY_LW_Data_OffsetPtPitchOffset)
                        ENDIF ;PLY_CFG_UseEffect_PitchTable
        ret

                        ENDIF ;PLY_CFG_UseEffects







;---------------------------------------------------------------------
;Sound stream.
;---------------------------------------------------------------------

;Plays the sound stream, filling the PSG registers table (but not playing it).
;The Instrument pointer must be updated as it evolves inside the Instrument.
;IN:    IX = Data block of the Track.
;       IY = Points at the beginning of the register structure related to the channel.
;       C = R7. Only bit 2 (sound) must be *set* to cut the sound if needed, and bit 5 (noise) must be *reset* if there is noise.
;       DE'' = Period table. Must not be modified.
PLY_LW_PlaySoundStream:
        ;Gets the pointer on the Instrument, from its base address and the offset.
        ld l,(ix + PLY_LW_Data_OffsetPtInstrument + 0)
        ld h,(ix + PLY_LW_Data_OffsetPtInstrument + 1)

        ;Reads the first byte of the cell of the Instrument. What type?
PLY_LW_PSS_ReadFirstByte:
        ld a,(hl)
        ld b,a
        inc hl
        rra
        jr c,PLY_LW_PSS_SoftOrSoftAndHard

        ;NoSoftNoHard or SoftwareToHardware
        rra
                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
        jr c,PLY_LW_PSS_SoftwareToHardware
                        ENDIF ;PLY_CFG_UseHardwareSounds

        ;No software no hardware, or end of sound (loop)!
        ;End of sound?
        rra
        jr nc,PLY_LW_PSS_NSNH_NotEndOfSound
        ;The sound loops/ends. Where?
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        ;As a sound always has at least one cell, we should safely be able to read its bytes without storing the instrument pointer.
        ;However, we do it anyway to remove the overhead of the Speed management: if looping, the same last line will be read,
        ;if several channels do so, it will be costly. So...
        ld (ix + PLY_LW_Data_OffsetPtInstrument + 0),l
        ld (ix + PLY_LW_Data_OffsetPtInstrument + 1),h
        jr PLY_LW_PSS_ReadFirstByte

PLY_LW_PSS_NSNH_NotEndOfSound:
        ;No software, no hardware.
        ;-------------------------
        ;Stops the sound.
        set 2,c

        ;Volume. A now contains the volume on b0-3.
        call PLY_LW_PSS_Shared_AdjustVolume
        ld (iy + PLY_LW_Registers_OffsetVolume),a

        ;Read noise?
        rl b
                        IFDEF PLY_CFG_NoSoftNoHard_Noise        ;CONFIG SPECIFIC
        call c,PLY_LW_PSS_ReadNoise
                        ENDIF ;PLY_CFG_NoSoftNoHard_Noise
        jr PLY_LW_PSS_Shared_StoreInstrumentPointer

        ;Software sound, or Software and Hardware?
PLY_LW_PSS_SoftOrSoftAndHard:
        rra
                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
        jr c,PLY_LW_PSS_SoftAndHard
                        ENDIF ;PLY_CFG_UseHardwareSounds

        ;Software sound.
        ;-----------------
        ;A is the volume. Already shifted twice, so it can be used directly.
        call PLY_LW_PSS_Shared_AdjustVolume
        ld (iy + PLY_LW_Registers_OffsetVolume),a

        ;Arp and/or noise?
        ld d,0          ;Default arpeggio.
        rl b
        jr nc,PLY_LW_PSS_S_AfterArpAndOrNoise
        ld a,(hl)
        inc hl
        ;Noise?
        sra a
        ;A is now the signed Arpeggio. It must be kept.
        ld d,a
        ;Now takes care of the noise, if there is a Carry.
                        IFDEF PLY_LW_USE_Noise          ;CONFIG SPECIFIC
        call c,PLY_LW_PSS_ReadNoise
                        ENDIF ;PLY_LW_USE_Noise
PLY_LW_PSS_S_AfterArpAndOrNoise:

        ld a,d          ;Gets the instrument arpeggio, if any.
        call PLY_LW_CalculatePeriodForBaseNote

        ;Read pitch?
        rl b
                        IFDEF PLY_CFG_SoftOnly_SoftwarePitch    ;CONFIG SPECIFIC
        call c,PLY_LW_ReadPitchAndAddToPeriod
                        ENDIF ;PLY_CFG_SoftOnly_SoftwarePitch

        ;Stores the new period of this channel.
        exx
                ld (iy + PLY_LW_Registers_OffsetSoftwarePeriodLSB),l
                ld (iy + PLY_LW_Registers_OffsetSoftwarePeriodMSB),h
        exx

        ;The code below is mutualized!
        ;Stores the new instrument pointer, if Speed allows it.
        ;--------------------------------------------------
PLY_LW_PSS_Shared_StoreInstrumentPointer:
        ;Checks the Instrument speed, and only stores the Instrument new pointer if the speed is reached.
        ld a,(ix + PLY_LW_Data_OffsetInstrumentCurrentStep)
        cp (ix + PLY_LW_Data_OffsetInstrumentSpeed)
        jr z,PLY_LW_PSS_S_SpeedReached
        ;Increases the current step.
        inc (ix + PLY_LW_Data_OffsetInstrumentCurrentStep)
        ret
PLY_LW_PSS_S_SpeedReached:
        ;Stores the Instrument new pointer, resets the speed counter.
        ld (ix + PLY_LW_Data_OffsetPtInstrument + 0),l
        ld (ix + PLY_LW_Data_OffsetPtInstrument + 1),h
        ld (ix + PLY_LW_Data_OffsetInstrumentCurrentStep),0
        ret


                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC

        ;Software and Hardware.
        ;----------------------------
PLY_LW_PSS_SoftAndHard:
        ;Reads the envelope bit, the possible pitch, and sets the software period accordingly.
        call PLY_LW_PSS_Shared_ReadEnvBitPitchArp_SoftPeriod_HardVol_HardEnv
        ;Reads the hardware period.
        ld a,(hl)
        ld (PLY_LW_Reg11),a
        inc hl
        ld a,(hl)
        ld (PLY_LW_Reg12),a
        inc hl

        jr PLY_LW_PSS_Shared_StoreInstrumentPointer


        ;Software to Hardware.
        ;-------------------------
PLY_LW_PSS_SoftwareToHardware:
        call PLY_LW_PSS_Shared_ReadEnvBitPitchArp_SoftPeriod_HardVol_HardEnv

        ;Now we can calculate the hardware period thanks to the ratio.
        ld a,b
        rra
        rra
        and %11100
        ld (PLY_LW_PSS_STH_Jump + 1),a
        exx
PLY_LW_PSS_STH_Jump: jr $ + 2           ;Automodified by the line above to jump to the right place.
                srl h
                rr l
                srl h
                rr l
                srl h
                rr l
                srl h
                rr l
                srl h
                rr l
                srl h
                rr l
                srl h
                rr l
                jr nc,PLY_LW_PSS_STH_RatioEnd
                inc hl
PLY_LW_PSS_STH_RatioEnd:
                ld a,l
                ld (PLY_LW_Reg11),a
                ld a,h
                ld (PLY_LW_Reg12),a
        exx

        jr PLY_LW_PSS_Shared_StoreInstrumentPointer

;A shared code for hardware sound.
;Reads the envelope bit in bit 1, arpeggio in bit 7 pitch in bit 2 from A. If pitch present, adds it to BC''.
;Converts the note to period, adds the instrument pitch, sets the software period of the channel.
;Also sets the hardware volume, and sets the hardware curve.
PLY_LW_PSS_Shared_ReadEnvBitPitchArp_SoftPeriod_HardVol_HardEnv:
        ;Envelope bit? R13 = 8 + 2 * (envelope bit?). Allows to have hardware envelope to 8 or 0xa.
        ;Shifted by 2 to the right, bit 1 is now envelope bit, which is perfect for us.
        and %10
        add a,8
        ld (PLY_LW_SetReg13 + 1),a

        ;Volume to 16 to trigger the hardware envelope.
        ld (iy + PLY_LW_Registers_OffsetVolume),16

        ;Arpeggio?
        xor a                   ;Default arpeggio.
                        IFDEF PLY_LW_ArpeggioInHardwareInstrument  ;CONFIG SPECIFIC
        bit 7,b                 ;Not shifted yet.
        jr z,PLY_LW_PSS_Shared_REnvBAP_AfterArpeggio
        ;Reads the Arpeggio.
        ld a,(hl)
        inc hl
PLY_LW_PSS_Shared_REnvBAP_AfterArpeggio:
                        ENDIF ;PLY_LW_ArpeggioInHardwareInstrument
        ;Calculates the software period.
        call PLY_LW_CalculatePeriodForBaseNote

        ;Pitch?
                        IFDEF PLY_LW_PitchInHardwareInstrument  ;CONFIG SPECIFIC
        bit 2,b         ;Not shifted yet.
        call nz,PLY_LW_ReadPitchAndAddToPeriod
                        ENDIF ;PLY_LW_PitchInHardwareInstrument

        ;Stores the new period of this channel.
        exx
                ld (iy + PLY_LW_Registers_OffsetSoftwarePeriodLSB),l
                ld (iy + PLY_LW_Registers_OffsetSoftwarePeriodMSB),h
        exx
        ret

                        ENDIF ;PLY_CFG_UseHardwareSounds
                
;Decreases the given volume (encoded in possibly more then 4 bits). If <0, forced to 0.
;IN:    A = volume, not ANDed.
;OUT:   A = new volume.
PLY_LW_PSS_Shared_AdjustVolume:
        and %1111
        sub (ix + PLY_LW_Data_OffsetTrackInvertedVolume)
        ret nc
        xor a
        ret

;Reads and stores the noise pointed by HL, opens the noise channel.
;IN:    HL = instrument data where the noise is.
;OUT:   HL = HL++.
;MOD:   A.
                IFDEF PLY_LW_USE_Noise          ;CONFIG SPECIFIC
PLY_LW_PSS_ReadNoise:
        ld a,(hl)
        inc hl
        ld (PLY_LW_NoiseRegister),a
        res 5,c                 ;Opens the noise channel.
        ret
                ENDIF ;PLY_LW_USE_Noise

;Calculates the period according to the base note and put it in BC''. Used by both software and hardware codes.
;IN:    DE'' = period table.
;       A = instrument arpeggio (0 if not used).
;OUT:   HL'' = period.
;MOD:   A
PLY_LW_CalculatePeriodForBaseNote:
        ;Gets the period from the current note.
        exx
                ld h,0
                add a,(ix + PLY_LW_Data_OffsetBaseNote)                         ;Adds the instrument Arp to the base note (including the transposition).
                                IFDEF PLY_CFG_UseEffect_ArpeggioTable           ;CONFIG SPECIFIC
                add (ix + PLY_LW_Data_OffsetCurrentArpeggioValue)               ;Adds the Arpeggio Table effect.
                                ENDIF ;PLY_CFG_UseEffect_ArpeggioTable
                ld l,a
                sla l                   ;Note encoded on 7 bits, so should be fine.
                add hl,de
                ld a,(hl)
                inc hl
                ld h,(hl)
                ld l,a                  ;HL'' = period.

                ;Adds the Pitch Table value, if used.
                                IFDEF PLY_CFG_UseEffect_PitchTable        ;CONFIG SPECIFIC
                ld a,(ix + PLY_LW_Data_OffsetIsPitchTableUsed)
                or a
                jr z,PLY_LW_CalculatePeriodForBaseNote_NoPitchTable
                ld c,(ix + PLY_LW_Data_OffsetCurrentPitchTableValue + 0)
                ld b,(ix + PLY_LW_Data_OffsetCurrentPitchTableValue + 1)
                add hl,bc
PLY_LW_CalculatePeriodForBaseNote_NoPitchTable:
                                ENDIF ;PLY_CFG_UseEffect_PitchTable
                ;Adds the Track Pitch.
                                IFDEF PLY_LW_USE_EffectPitchUpDown
                ld c,(ix + PLY_LW_Data_OffsetTrackPitchInteger + 0)
                ld b,(ix + PLY_LW_Data_OffsetTrackPitchInteger + 1)
                add hl,bc
                                ENDIF ;PLY_LW_USE_EffectPitchUpDown
        exx
        ret

                        IFDEF PLY_LW_PitchInInstrument  ;CONFIG SPECIFIC
;Reads the pitch in the Instruments (16 bits) and adds it to HL'', which should contain the software period.
;IN:    HL = points on the pitch value.
;OUT:   HL = points after the pitch.
;MOD:   A, BC'', HL'' updated.
PLY_LW_ReadPitchAndAddToPeriod:
        ;Reads 2 * 8 bits for the pitch. Slow...
        ld a,(hl)
        inc hl
        exx
                ld c,a                  ;Adds the read pitch to the note period.
        exx
        ld a,(hl)
        inc hl
        exx
                ld b,a
                add hl,bc
        exx
        ret
                        ENDIF ;PLY_LW_PitchInInstrument













;---------------------------------------------------------------------
;Effect management.
;---------------------------------------------------------------------

                        IFDEF PLY_CFG_UseEffects        ;CONFIG SPECIFIC

;IN:    HL = points after the first byte.
;               B = data of the first byte on bits 0-4 (will probably needed to be ANDed, as bits 5-7 are undetermined).
;               DE''= Instrument Table (not useful here). Do not modify!
;               IX = data block of the Track.
;OUT:   HL = points after the data of the effect (maybe nothing to do).
;               Each effect must jump to PLY_LW_RT_CellRead.

;Clears all the effects (volume, pitch table, arpeggio table).
                        IFDEF PLY_CFG_UseEffect_Reset           ;CONFIG SPECIFIC.
PLY_LW_EffectReset:
        ;Inverted volume.
        call PLY_LW_ReadInvertedVolumeFromB

        xor a
        ;The inverted volume is managed above, so don''t change it.
                                IFDEF PLY_LW_USE_EffectPitchUpDown              ;CONFIG SPECIFIC
        ld (ix + PLY_LW_Data_OffsetIsPitchUpDownUsed),a
                                ENDIF ;PLY_LW_USE_EffectPitchUpDown
                                IFDEF PLY_CFG_UseEffect_ArpeggioTable           ;CONFIG SPECIFIC
        ld (ix + PLY_LW_Data_OffsetIsArpeggioTableUsed),a
        ld (ix + PLY_LW_Data_OffsetCurrentArpeggioValue),a      ;Contrary to the Pitch, the value must be reset.
                                ENDIF ;PLY_CFG_UseEffect_ArpeggioTable
                                IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
        ld (ix + PLY_LW_Data_OffsetIsPitchTableUsed),a
                                ENDIF ;PLY_CFG_UseEffect_PitchTable
        jp PLY_LW_RT_CellRead
                        ENDIF ;PLY_CFG_UseEffect_Reset

;Changes the volume. Possibly changes the Track pitch.
                        IFDEF PLY_LW_USE_Volume_And_PitchUpDown_Effects           ;CONFIG SPECIFIC.
PLY_LW_EffectVolumeAndPitchUpDown:
        ;Stores the new inverted volume.
        call PLY_LW_ReadInvertedVolumeFromB

        ;Pitch? Warning, the code below is shared with the PitchUp/Down effect.
        bit 4,b
        jp z,PLY_LW_RT_CellRead
        ;Pitch present. Reads and stores its 16 bits value (integer/decimal).
PLY_LW_EffectPitchUpDown_Activated:
        ;Code shared with the effect above.
        ;Activates the effect.
        ld (ix + PLY_LW_Data_OffsetIsPitchUpDownUsed),255
        ld a,(hl)
        inc hl
        ld (ix + PLY_LW_Data_OffsetTrackPitchSpeed + 0),a
        ld a,(hl)
        inc hl
        ld (ix + PLY_LW_Data_OffsetTrackPitchSpeed + 1),a

        jp PLY_LW_RT_CellRead
                        ENDIF ;PLY_LW_USE_Volume_And_PitchUpDown_Effects


;Effect table. Each entry jumps to an effect management code.
;Put after the code above so that the JR are within bound.
PLY_LW_EffectTable:
                        IFDEF PLY_LW_EffectReset        ;CONFIG SPECIFIC
        jr PLY_LW_EffectReset                                   ;000
                        ELSE
                        jr $
                        ENDIF
                        
                        IFDEF PLY_CFG_UseEffect_ArpeggioTable           ;CONFIG SPECIFIC
        jr PLY_LW_EffectArpeggioTable                           ;001
                        ELSE
                        jr $
                        ENDIF
                
                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
        jr PLY_LW_EffectPitchTable                              ;010
                        ELSE
                        jr $
                        ENDIF
                        
                        IFDEF PLY_LW_USE_EffectPitchUpDown              ;CONFIG SPECIFIC
        jr PLY_LW_EffectPitchUpDown                             ;011
                        ELSE
                        jr $
                        ENDIF
                        
                        IFDEF PLY_LW_USE_Volume_And_PitchUpDown_Effects         ;CONFIG SPECIFIC
        jr PLY_LW_EffectVolumeAndPitchUpDown                    ;100
                        ELSE
                        jr $
                        ENDIF
                        
                        IFDEF PLY_LW_USE_Volume_And_ArpeggioTable_Effects       ;CONFIG SPECIFIC
        jr PLY_LW_EffectVolumeArpeggioTable                     ;101
                        ELSE
                        jr $
                        ENDIF
                        
                        IFDEF PLY_LW_USE_Reset_And_ArpeggioTable_Effects        ;CONFIG SPECIFIC
        jr PLY_LW_EffectResetArpeggioTable                      ;110
                        ELSE
                        jr $
                        ENDIF
        
        ;111 Unused.



;Pitch up/down effect, activation or stop.
                        IFDEF PLY_LW_USE_EffectPitchUpDown              ;CONFIG SPECIFIC
PLY_LW_EffectPitchUpDown:
        rr b    ;Pitch present or pitch stop?
        jr c,PLY_LW_EffectPitchUpDown_Activated
        ;Pitch stop.
        ld (ix + PLY_LW_Data_OffsetIsPitchUpDownUsed),0
        jp PLY_LW_RT_CellRead
                        ENDIF ;PLY_LW_USE_EffectPitchUpDown

;Arpeggio table effect, activation or stop.
                        IFDEF PLY_CFG_UseEffect_ArpeggioTable           ;CONFIG SPECIFIC
PLY_LW_EffectArpeggioTable:
        ld a,b
        and %11111
PLY_LW_EffectArpeggioTable_AfterMask:
        ld (ix + PLY_LW_Data_OffsetIsArpeggioTableUsed),a       ;Sets to 0 if the Arpeggio is stopped, or any other value if it starts.
        jr z,PLY_LW_EffectArpeggioTable_Stop

        ;Gets the Arpeggio address.
        add a,a
        exx
                ld l,a
                ld h,0
dknr3:
PLY_LW_PtArpeggios: ld bc,0
                add hl,bc
                ld a,(hl)
                inc hl
                ld (ix + PLY_LW_Data_OffsetPtArpeggioTable + 0),a
                ld a,(hl)
                ld (ix + PLY_LW_Data_OffsetPtArpeggioTable + 1),a
        exx

        ;Resets the offset of the Arpeggio, to force a restart.
        xor a
        ld (ix + PLY_LW_Data_OffsetPtArpeggioOffset),a
        jp PLY_LW_RT_CellRead
PLY_LW_EffectArpeggioTable_Stop:
        ;Contrary to the Pitch, the Arpeggio must also be set to 0 when stopped.
        ld (ix + PLY_LW_Data_OffsetCurrentArpeggioValue),a
        jp PLY_LW_RT_CellRead
                        ENDIF ;PLY_CFG_UseEffect_ArpeggioTable

;Pitch table effect, activation or stop.
;This is exactly the same code as for the Arpeggio, but I can''t find a way to share it...
                        IFDEF PLY_CFG_UseEffect_PitchTable              ;CONFIG SPECIFIC
PLY_LW_EffectPitchTable:
        ld a,b
        and %11111
PLY_LW_EffectPitchTable_AfterMask:
        ld (ix + PLY_LW_Data_OffsetIsPitchTableUsed),a  ;Sets to 0 if the Pitch is stopped, or any other value if it starts.
        jp z,PLY_LW_RT_CellRead

        ;Gets the Pitch address.
        add a,a
        exx
                ld l,a
                ld h,0
dknr3:
PLY_LW_PtPitches: ld bc,0
                add hl,bc
                ld a,(hl)
                inc hl
                ld (ix + PLY_LW_Data_OffsetPtPitchTable + 0),a
                ld a,(hl)
                inc hl
                ld (ix + PLY_LW_Data_OffsetPtPitchTable + 1),a
        exx

        ;Resets the offset of the Pitch, to force a restart.
        xor a
        ld (ix + PLY_LW_Data_OffsetPtPitchOffset),a

        jp PLY_LW_RT_CellRead
                        ENDIF ;PLY_CFG_UseEffect_PitchTable



;Volume, and Arpeggio Table, activation or stop.
                        IFDEF PLY_LW_USE_Volume_And_ArpeggioTable_Effects       ;CONFIG SPECIFIC
PLY_LW_EffectVolumeArpeggioTable:
        ;Stores the new inverted volume.
        call PLY_LW_ReadInvertedVolumeFromB

        ;Manages the Arpeggio, encoded just after.
        ld a,(hl)
        inc hl
        or a            ;Required, else a volume of 0 will disturb the flag test after the jump!
        jr PLY_LW_EffectArpeggioTable_AfterMask
                        ENDIF ;PLY_LW_USE_Volume_And_ArpeggioTable_Effects

;Reset, and Arpeggio Table (activation only).
                        IFDEF PLY_LW_USE_Reset_And_ArpeggioTable_Effects        ;CONFIG SPECIFIC
PLY_LW_EffectResetArpeggioTable:
        ;Resets effects and read volume.
        ;A bit of loss of CPU because we''re going to set the Arpeggio just after, AND the effect pointer is stored!
        ;Oh well, less memory taken this way.
        call PLY_LW_EffectReset

        ;Reads the Arpeggio.
        ld a,(hl)
        inc hl
        or a            ;Required, else a volume of 0 will disturb the flag test after the jump!
        jp PLY_LW_EffectArpeggioTable_AfterMask         ;No need to use the mask, the value is clean.
                        ENDIF ;PLY_LW_USE_Reset_And_ArpeggioTable_Effects


;Reads the inverted volume from B, stored it after masking the bits in A.
PLY_LW_ReadInvertedVolumeFromB:
        ld a,b
        and %1111
        ld (ix + PLY_LW_Data_OffsetTrackInvertedVolume),a
        ret

                        ENDIF ;PLY_CFG_UseEffects








;---------------------------------------------------------------------
;Data blocks for the three channels. Make sure NOTHING is added between, as the init clears everything!
;---------------------------------------------------------------------

;Data block for channel 1.
PLY_LW_Track1_Data:
dkbs:
PLY_LW_Track1_WaitEmptyCell: db 0                       ;How many empty cells have to be waited. 0 = none.
                        IFDEF PLY_CFG_UseTranspositions         ;CONFIG SPECIFIC
PLY_LW_Track1_Transposition: db 0
                        ENDIF ;PLY_CFG_UseTranspositions
PLY_LW_Track1_BaseNote: db 0                            ;Base note, such as the note played. The transposition IS included.
PLY_LW_Track1_InstrumentCurrentStep: db 0               ;The current step on the Instrument (>=0, till it reaches the Speed).
PLY_LW_Track1_InstrumentSpeed: db 0                     ;The Instrument speed (>=0).
PLY_LW_Track1_TrackInvertedVolume: db 0
dkbe:
dkws:
PLY_LW_Track1_PtTrack: dw 0                             ;Points on the next Cell of the Track to read. Evolves.
PLY_LW_Track1_PtInstrument: dw 0                        ;Points on the Instrument, evolves.
PLY_LW_Track1_PtBaseInstrument: dw 0                    ;Points on the base of the Instrument, does not evolve.
dkwe:
                        IFDEF PLY_CFG_UseEffects        ;CONFIG SPECIFIC
dkbs:
PLY_LW_Track1_IsPitchUpDownUsed: db 0                   ;>0 if a Pitch Up/Down is currently in use.
PLY_LW_Track1_TrackPitchDecimal: db 0                   ;The decimal part of the Track pitch. Evolves as the pitch goes up/down.
dkbe:
dkws:
PLY_LW_Track1_TrackPitchSpeed: dw 0                     ;The integer and decimal part of the Track pitch speed. Is added to the Track Pitch every frame.
PLY_LW_Track1_TrackPitchInteger: dw 0                   ;The integer part of the Track pitch. Evolves as the pitch goes up/down.
dkwe:
dkbs:
PLY_LW_Track1_IsArpeggioTableUsed: db 0                 ;>0 if an Arpeggio Table is currently in use.
PLY_LW_Track1_PtArpeggioOffset: db 0                    ;Increases over the Arpeggio.
PLY_LW_Track1_CurrentArpeggioValue: db 0                ;Value from the Arpeggio to add to the base note. Read even if the Arpeggio effect is deactivated.
dkbe:
dkws:
PLY_LW_Track1_PtArpeggioTable: dw 0                     ;Point on the base of the Arpeggio table, does not evolve.
dkwe:
dkbs:
PLY_LW_Track1_IsPitchTableUsed: db 0                    ;>0 if a Pitch Table is currently in use.
PLY_LW_Track1_PtPitchOffset: db 0                       ;Increases over the Pitch.
dkbe:
dkws:
PLY_LW_Track1_CurrentPitchTableValue: dw 0              ;16 bit value from the Pitch to add to the base note. Not read if the Pitch effect is deactivated.
PLY_LW_Track1_PtPitchTable: dw 0                        ;Points on the base of the Pitch table, does not evolve.
dkwe:
                        ENDIF ;PLY_CFG_UseEffects
PLY_LW_Track1_Data_End:

PLY_LW_Track1_Data_Size: equ PLY_LW_Track1_Data_End - PLY_LW_Track1_Data

PLY_LW_Data_OffsetWaitEmptyCell:                equ PLY_LW_Track1_WaitEmptyCell - PLY_LW_Track1_Data
                        IFDEF PLY_CFG_UseTranspositions         ;CONFIG SPECIFIC
PLY_LW_Data_OffsetTransposition:                equ PLY_LW_Track1_Transposition - PLY_LW_Track1_Data
                        ENDIF ;PLY_CFG_UseTranspositions

PLY_LW_Data_OffsetPtTrack:                      equ PLY_LW_Track1_PtTrack - PLY_LW_Track1_Data
PLY_LW_Data_OffsetBaseNote:                     equ PLY_LW_Track1_BaseNote - PLY_LW_Track1_Data
PLY_LW_Data_OffsetPtInstrument:                 equ PLY_LW_Track1_PtInstrument - PLY_LW_Track1_Data
PLY_LW_Data_OffsetPtBaseInstrument:             equ PLY_LW_Track1_PtBaseInstrument - PLY_LW_Track1_Data
PLY_LW_Data_OffsetInstrumentCurrentStep:        equ PLY_LW_Track1_InstrumentCurrentStep - PLY_LW_Track1_Data
PLY_LW_Data_OffsetInstrumentSpeed:              equ PLY_LW_Track1_InstrumentSpeed - PLY_LW_Track1_Data
PLY_LW_Data_OffsetTrackInvertedVolume:          equ PLY_LW_Track1_TrackInvertedVolume - PLY_LW_Track1_Data
                        IFDEF PLY_CFG_UseEffects        ;CONFIG SPECIFIC
                                IFDEF PLY_LW_USE_EffectPitchUpDown      ;CONFIG SPECIFIC
PLY_LW_Data_OffsetIsPitchUpDownUsed:            equ PLY_LW_Track1_IsPitchUpDownUsed - PLY_LW_Track1_Data
PLY_LW_Data_OffsetTrackPitchInteger:            equ PLY_LW_Track1_TrackPitchInteger - PLY_LW_Track1_Data
PLY_LW_Data_OffsetTrackPitchDecimal:            equ PLY_LW_Track1_TrackPitchDecimal - PLY_LW_Track1_Data
PLY_LW_Data_OffsetTrackPitchSpeed:              equ PLY_LW_Track1_TrackPitchSpeed - PLY_LW_Track1_Data
                                ENDIF ;PLY_LW_USE_EffectPitchUpDown
                                IFDEF PLY_CFG_UseEffect_ArpeggioTable ;CONFIG SPECIFIC
PLY_LW_Data_OffsetIsArpeggioTableUsed:          equ PLY_LW_Track1_IsArpeggioTableUsed - PLY_LW_Track1_Data
PLY_LW_Data_OffsetPtArpeggioTable:              equ PLY_LW_Track1_PtArpeggioTable - PLY_LW_Track1_Data
PLY_LW_Data_OffsetPtArpeggioOffset:             equ PLY_LW_Track1_PtArpeggioOffset - PLY_LW_Track1_Data
PLY_LW_Data_OffsetCurrentArpeggioValue:         equ PLY_LW_Track1_CurrentArpeggioValue - PLY_LW_Track1_Data
                                ENDIF ;PLY_CFG_UseEffect_ArpeggioTable
                                IFDEF PLY_CFG_UseEffect_PitchTable        ;CONFIG SPECIFIC
PLY_LW_Data_OffsetIsPitchTableUsed:             equ PLY_LW_Track1_IsPitchTableUsed - PLY_LW_Track1_Data
PLY_LW_Data_OffsetPtPitchTable:                 equ PLY_LW_Track1_PtPitchTable - PLY_LW_Track1_Data
PLY_LW_Data_OffsetCurrentPitchTableValue:       equ PLY_LW_Track1_CurrentPitchTableValue - PLY_LW_Track1_Data
PLY_LW_Data_OffsetPtPitchOffset:                equ PLY_LW_Track1_PtPitchOffset - PLY_LW_Track1_Data
                                ENDIF ;PLY_CFG_UseEffect_PitchTable
                        ENDIF ;PLY_CFG_UseEffects

;Data block for channel 2.
PLY_LW_Track2_Data:
dkbs:
        ds PLY_LW_Track1_Data_Size, 0
dkbe:
PLY_LW_Track2_Data_End:
PLY_LW_Track2_WaitEmptyCell: equ PLY_LW_Track2_Data + PLY_LW_Data_OffsetWaitEmptyCell
                        IFDEF PLY_CFG_UseTranspositions         ;CONFIG SPECIFIC
PLY_LW_Track2_Transposition: equ PLY_LW_Track2_Data + PLY_LW_Data_OffsetTransposition
                        ENDIF ;PLY_CFG_UseTranspositions

PLY_LW_Track2_PtTrack: equ PLY_LW_Track2_Data + PLY_LW_Data_OffsetPtTrack
PLY_LW_Track2_PtInstrument: equ PLY_LW_Track2_Data + PLY_LW_Data_OffsetPtInstrument

;Data block for channel 3.
PLY_LW_Track3_Data:
dkbs:
        ds PLY_LW_Track1_Data_Size, 0
dkbe:
PLY_LW_Track3_Data_End:
PLY_LW_Track3_WaitEmptyCell: equ PLY_LW_Track3_Data + PLY_LW_Data_OffsetWaitEmptyCell
                        IFDEF PLY_CFG_UseTranspositions         ;CONFIG SPECIFIC
PLY_LW_Track3_Transposition: equ PLY_LW_Track3_Data + PLY_LW_Data_OffsetTransposition
                        ENDIF ;PLY_CFG_UseTranspositions
PLY_LW_Track3_PtTrack: equ PLY_LW_Track3_Data + PLY_LW_Data_OffsetPtTrack
PLY_LW_Track3_PtInstrument: equ PLY_LW_Track3_Data + PLY_LW_Data_OffsetPtInstrument

        ;Makes sure the structure all have the same size!
        ASSERT (PLY_LW_Track1_Data_End - PLY_LW_Track1_Data) == (PLY_LW_Track2_Data_End - PLY_LW_Track2_Data)
        ASSERT (PLY_LW_Track1_Data_End - PLY_LW_Track1_Data) == (PLY_LW_Track3_Data_End - PLY_LW_Track3_Data)
        ;No holes between the blocks, the init makes a LDIR to clear everything!
        ASSERT PLY_LW_Track1_Data_End == PLY_LW_Track2_Data
        ASSERT PLY_LW_Track2_Data_End == PLY_LW_Track3_Data



;---------------------------------------------------------------------
;Register block for all the channels. They are "polluted" with pointers to code because all this
;is actually a RET table!
;---------------------------------------------------------------------
;DB register, DB value then DW code to jump to once the value is read.
PLY_LW_Registers_RetTable:
PLY_LW_Track1_Registers:
dkbs:   db 8
PLY_LW_Track1_Volume: db 0
dkbe:
dkps:   dw PLY_LW_SendPsgRegister
dkpe:

dkbs:   db 0
PLY_LW_Track1_SoftwarePeriodLSB: db 0
dkbe:
dkps:   dw PLY_LW_SendPsgRegister
dkpe:

dkbs:  db 1
PLY_LW_Track1_SoftwarePeriodMSB: db 0
dkbe:
dkps:   dw PLY_LW_SendPsgRegister
dkpe:

PLY_LW_Track2_Registers:
dkbs:   db 9
PLY_LW_Track2_Volume: db 0
dkbe:
dkps:   dw PLY_LW_SendPsgRegister
dkpe:

dkbs:   db 2
PLY_LW_Track2_SoftwarePeriodLSB: db 0
dkbe:
dkps:   dw PLY_LW_SendPsgRegister
dkpe:

dkbs:   db 3
PLY_LW_Track2_SoftwarePeriodMSB: db 0
dkbe:
dkps:   dw PLY_LW_SendPsgRegister
dkpe:


PLY_LW_Track3_Registers:
dkbs:   db 10
PLY_LW_Track3_Volume: db 0
dkbe:
dkps:   dw PLY_LW_SendPsgRegister
dkpe:

dkbs:   db 4
PLY_LW_Track3_SoftwarePeriodLSB: db 0
dkbe:
dkps:   dw PLY_LW_SendPsgRegister
dkpe:

dkbs:   db 5
PLY_LW_Track3_SoftwarePeriodMSB: db 0
dkbe:
dkps:   dw PLY_LW_SendPsgRegister
dkpe:

;Generic registers.
                        IFDEF PLY_LW_USE_NoiseRegister          ;CONFIG SPECIFIC
dkbs:   db 6
PLY_LW_NoiseRegister: db 0
dkbe:
dkps:   dw PLY_LW_SendPsgRegister
dkpe:
                        ENDIF ;PLY_LW_USE_NoiseRegister

dkbs:   db 7
PLY_LW_MixerRegister: db 0
dkbe:
        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
dkps:           dw PLY_LW_SendPsgRegister
dkpe:


dkbs:           db 11
PLY_LW_Reg11:   db 0
dkbe:
dkps:           dw PLY_LW_SendPsgRegister
dkpe:

dkbs:           db 12
PLY_LW_Reg12:   db 0
dkbe:
dkps:
                dw PLY_LW_SendPsgRegisterR13
                ;This one is a trick to send the register after R13 is managed.
                dw PLY_LW_SendPsgRegisterAfterPop

                dw PLY_LW_SendPsgRegisterEnd
dkpe:
        ELSE
dkps:
                dw PLY_LW_SendPsgRegisterEnd
dkpe:
        ENDIF ;PLY_CFG_UseHardwareSounds



PLY_LW_Registers_OffsetVolume: equ PLY_LW_Track1_Volume - PLY_LW_Track1_Registers
PLY_LW_Registers_OffsetSoftwarePeriodLSB: equ PLY_LW_Track1_SoftwarePeriodLSB - PLY_LW_Track1_Registers
PLY_LW_Registers_OffsetSoftwarePeriodMSB: equ PLY_LW_Track1_SoftwarePeriodMSB - PLY_LW_Track1_Registers

;The period table for each note (from 0 to 127 included).
PLY_LW_PeriodTable:
dkws
        IFDEF PLY_LW_HARDWARE_CPC
        ;PSG running to 1000000 Hz.
        dw 3822,3608,3405,3214,3034,2863,2703,2551,2408,2273,2145,2025          ;0
        dw 1911,1804,1703,1607,1517,1432,1351,1276,1204,1136,1073,1012          ;12
        dw 956,902,851,804,758,716,676,638,602,568,536,506                      ;24
        dw 478,451,426,402,379,358,338,319,301,284,268,253                      ;36
        dw 239,225,213,201,190,179,169,159,150,142,134,127                      ;48
        dw 119,113,106,100,95,89,84,80,75,71,67,63                              ;60
        dw 60,56,53,50,47,45,42,40,38,36,34,32                                  ;72
        dw 30,28,27,25,24,22,21,20,19,18,17,16                                  ;84
        dw 15,14,13,13,12,11,11,10,9,9,8,8                                      ;96
        dw 7,7,7,6,6,6,5,5,5,4,4,4                                              ;108
        dw 4,4,3,3,3,3,3,2 ;,2,2,2,2                                            ;120 -> 127
        ENDIF

        IFDEF PLY_LW_HARDWARE_SPECTRUM_OR_MSX
        ;PSG running to 1773400 Hz.
        dw 6778, 6398, 6039, 5700, 5380, 5078, 4793, 4524, 4270, 4030, 3804, 3591	; Octave 0
        dw 3389, 3199, 3019, 2850, 2690, 2539, 2397, 2262, 2135, 2015, 1902, 1795	; Octave 1
        dw 1695, 1599, 1510, 1425, 1345, 1270, 1198, 1131, 1068, 1008, 951, 898	; Octave 2
        dw 847, 800, 755, 712, 673, 635, 599, 566, 534, 504, 476, 449	; Octave 3
        dw 424, 400, 377, 356, 336, 317, 300, 283, 267, 252, 238, 224	; Octave 4
        dw 212, 200, 189, 178, 168, 159, 150, 141, 133, 126, 119, 112	; Octave 5
        dw 106, 100, 94, 89, 84, 79, 75, 71, 67, 63, 59, 56	; Octave 6
        dw 53, 50, 47, 45, 42, 40, 37, 35, 33, 31, 30, 28	; Octave 7
        dw 26, 25, 24, 22, 21, 20, 19, 18, 17, 16, 15, 14	; Octave 8
        dw 13, 12, 12, 11, 11, 10, 9, 9, 8, 8, 7, 7	; Octave 9
        dw 7, 6, 6, 6, 5, 5, 5, 4	; Octave 10
        ENDIF

        IFDEF PLY_LW_HARDWARE_PENTAGON
        ;PSG running to 1750000 Hz.
        dw 6689, 6314, 5959, 5625, 5309, 5011, 4730, 4464, 4214, 3977, 3754, 3543	; Octave 0
        dw 3344, 3157, 2980, 2812, 2655, 2506, 2365, 2232, 2107, 1989, 1877, 1772	; Octave 1
        dw 1672, 1578, 1490, 1406, 1327, 1253, 1182, 1116, 1053, 994, 939, 886	; Octave 2
        dw 836, 789, 745, 703, 664, 626, 591, 558, 527, 497, 469, 443	; Octave 3
        dw 418, 395, 372, 352, 332, 313, 296, 279, 263, 249, 235, 221	; Octave 4
        dw 209, 197, 186, 176, 166, 157, 148, 140, 132, 124, 117, 111	; Octave 5
        dw 105, 99, 93, 88, 83, 78, 74, 70, 66, 62, 59, 55	; Octave 6
        dw 52, 49, 47, 44, 41, 39, 37, 35, 33, 31, 29, 28	; Octave 7
        dw 26, 25, 23, 22, 21, 20, 18, 17, 16, 16, 15, 14	; Octave 8
        dw 13, 12, 12, 11, 10, 10, 9, 9, 8, 8, 7, 7	; Octave 9
        dw 7, 6, 6, 5, 5, 5, 5, 4	; Octave 10
        ENDIF
dkwe
PLY_LW_End:



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
