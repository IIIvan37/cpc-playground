-- Migration: Import z80code projects batch 47
-- Projects 93 to 94
-- Generated: 2026-01-25T21:43:30.196819

-- Project 93: rubidouille-20 by rubi
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'rubidouille-20',
    'Imported from z80Code. Author: rubi. scroll en vague',
    'public',
    false,
    false,
    '2019-12-08T10:45:56.618000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'T_CARAC EQU #7000
T_TABLE EQU #7800

ORG #9000
_START:
;
; PRENDRE LES FONTES DES CARACTERES
;
        JP QON  ; SCROLLING ACTIVE
        JP QOFF ; SCROLLING DESACTIVE
QON:    XOR A
        CALL #BBA5
        CALL #B906
        PUSH AF
        LD DE,T_CARAC
        LD BC,8*256
        LDIR
        POP AF
        CALL #B90C
;
NB      EQU 55
LI      EQU 110
;
; CALCUL D''UNE VAGUE
;
        LD HL, #C000+12
        LD B,LI
BO1:    CALL RBC26
        DJNZ BO1
        CALL VAGUE
        LD HL,(NB-1)*2+T_TABLE
        LD A, (HL)
        INC HL
        LD H, (HL)
        LD L,A
        LD (OFSET) ,HL
        LD HL,NOM       ; LE MESSAGE AU DEBUT SVP
        LD (OFNOM),HL
;
; ON RECCONFIGURE LES INTERUPTIONS DU CPC
;
D_INT:  DI
        LD HL, (#39)
        INC HL
        LD (QINT) ,HL
        LD (HL),#C3
        LD DE, INT_
        INC HL
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        LD (D_INT3+1) ,HL
        LD DE,#33
        ADD HL,DE
        LD (D_INT2+1),HL
        RET
;
;
VAGUE:  LD B,8
        LD IX,T_TABLE
VAGUE1: PUSH HL
        LD C,NB
VAGUE2: LD (IX+0),L
        LD (IX+1),H
        INC IX
        INC IX
        INC HL
        CALL VAGUE3
        DEC C
        JR NZ,VAGUE2
        POP HL
        CALL RBC26
        DJNZ VAGUE1
        RET
VAGUE3: BIT 3,L
        JP Z,RBC26
        JP #BC29
;
;
INT_:    PUSH AF
        PUSH BC
        PUSH HL
        PUSH DE
        LD BC,#7F8D
        OUT (C),C
        CALL INTA
        POP DE
        POP HL
        POP BC
        POP AF
        EX AF,AF''
D_INT2: JP C,0
D_INT3: JP 0
;
INTA:   LD B,#F5
        IN A, (C)
        RRA
        JR C,INTE0
KL:     LD A, 7
        INC A
        LD (KL+1),A
        CP 1
        JR Z,INTE1
        CP 2
        JR Z,INTE1
        CP 3
        JR Z,INTE1
       CP 4
        JR Z,INTE2
        RET
;
INTE0:  XOR A
        LD (KL+1) ,A
        LD HL,T_TABLE
        JR SPRG1
INTE1:  LD HL, (THL)
SPRG1:   LD B,2
SPRG1_1: LD C,NB-1
         LD E, (HL)
         INC HL
         LD D, (HL)
         INC HL
SPRG1_2: PUSH HL
         LD A, (HL)
         INC HL
         LD H, (HL)
         LD L,A
         LD A, (HL)
         LD (DE), A
         EX DE ,HL
         POP HL
         INC HL
         INC HL
         DEC C
         JR NZ,SPRG1_2
         DJNZ SPRG1_1
         LD (THL) ,HL
         RET
;
INTE2:
SPRG2:   ; ENVOIE DU CARACTERE
         LD HL, (OFNOM)
         LD A, (HL)
         OR A
         JR NZ,SPRG2_1
         LD HL ,NOM
         LD A, (HL)
SPRG2_1: LD C, A  
         LD A, (FLAG)
         XOR #FF 
         LD (FLAG), A
         CALL NZ, SPRG2_4
        LD DE, (FLAG1)
        LD HL, (OFSET)
        LD B, 8
SPRG2_2: LD A, (DE)
        LD C, A
        LD A, (FLAG)
        OR A
        LD A, #0F
        JP Z, SPRG2_3
        LD A, #F0
SPRG2_3: AND C  
        LD (HL), A
        INC DE
        CALL RBC26
        DJNZ SPRG2_2
        RET
SPRG2_4: INC HL
        LD (OFNOM), HL
        LD L, C
        LD H, 0
        ADD HL, HL
        ADD HL, HL
        ADD HL, HL
        LD DE, T_CARAC
        ADD HL, DE
        LD (FLAG1), HL
        RET
QOFF:    DI
         LD HL, (QINT)
         LD (HL), #08
         INC HL
         LD (HL), #38
         INC HL
         LD (HL),#33
         RET
;
RBC26:
         LD A,H
         ADD #08
         LD H,A
         AND #38
         RET NZ
         PUSH DE
         LD DE, #C050
         ADD HL, DE
         POP DE
         RET
;
;
FLAG:   DB 0
FLAG1   DW 0
OFSET   DW 0
OFNOM   DW 0
THL     DW 0
QINT    DW 0
;
NOM     DM "BONJOUR A TOI" 
        DM ", LISEZ 100% "
        DS 12, 32        
        DB 0, 255
_END:
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: rubidouille
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rubidouille';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 94: edge-grinder by Axelay/STE/T&J
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'edge-grinder',
    'Imported from z80Code. Author: Axelay/STE/T&J. Edge Grinder',
    'public',
    false,
    false,
    '2021-07-15T20:56:56.915000'::timestamptz,
    '2021-07-15T21:05:51.372000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Edge Grinder (Axelay/STE/TREVOR "SMILA" STOREY/T&J)

;Hi
;A few weeks backs back you mentioned about adding source examples to RASMLIVE, I don''t know what''s
;suitable or interesting, but for some time I have been wondering about somewhere else for the commented
;source to the original Edge Grinder to go (not the super version), and I''m not interested in maintaining
;any kind of site myself to put it on.  So I was wondering if that was the sort of thing you might be
;interested in adding?  I guess with the site being named after RASM it might not be useful since the 
;source code is written in Maxam?  It''s in the form of a zip file with a large number of asm files, 
;some source dsk''s and a text file explaining how it goes together if you want to build it.
;Regards
;Paul

; Bankset0 = code + player/music
; bank4 = strobe sprite block
; bank5 = compiled sprite block
; bank6 = sprite block
; bank7 = map block
; https://cpcrulez.fr/GamesTest/edge_grinder.htm
; SourcePack : https://cpcrulez.fr/download.php?a=VIeloZnWaLPi0diuhsXpm8q-iLfU09fDj7ba3pPClb8=


bankset 0
org #d0
run start

SpritesYX equ #40
SpritesYXMv equ #50
KeyInY equ #50+12
SpriteData equ #60
StarsLow equ #90
StarsHigh equ #a4

;ProcessMapPointer equ #40bf
;Copy_Buffer equ #4000
;Fill_Buffer equ #4037
;Map equ #40db
;MapPointer equ #40d9
;PrintCredits equ #498c ;fc8c
;wave_data equ #63bd
;ZoomScrollMsg equ #5140

SpriteAddrHigh equ #3e00+48
SpriteAddrLow equ #3f00+48
SpriteBufHigh equ #7400
SpriteBufLow equ #7c00

; sprite id table, starting at #d0
; for each of 16 sprite id''s, define base frame, animation type and data
SpriteLookup
    defb 19,192,1 ; sprite 1
    defb 24,64,6 ; sprite 2
    defb 30,64,4 ; sprite 3
    defb 34,128,1 ; sprite 4
    defb 40,64,6 ; sprite 5
    defb 46,64,6 ; sprite 6
    defb 52,64,6 ; sprite 7
    defb 58,64,7 ; sprite 8
    defb 65,64,6 ; sprite 9
    defb 71,64,6 ; sprite 10
    defb 77,64,8 ; sprite 11
    defb 85,64,8 ; sprite 12
    defb 93,64,8 ; sprite 13
    defb 101,64,6 ; sprite 14
    defb 107,64,6 ; sprite 15
    defb 113,64,6 ; sprite 16

; key reading buffer at #100
KBmatrixbuf
defs 10

; old test code, unused!
MoveDown
    ld hl,#5000
    ld de,#100
    ld bc,EndEG-#100
    ldir
    jp start

base_addr ; current screen base address
dw #c000

paint_addr ; current screen background column
dw #c04d

scroll_step ; pointer for stage of tile writer
db 0

scroll ; tells interrupt to advance a frame
db 0

; variables used for display of title screens two ''zoom scrolls''
ZSCharPtr
    defw ZoomScrollMsg-1
ZSCharCol
    defb 7
HighZoomScrlOffset
    defw 0
LowZoomScrlOffset
    defw 0

; screen address reset position in sprite co-ordinates
ResetYX
defb 232,16+48
; each bit of these bytes indicate when a sprite has overlapped the reset point
ResetHigh
defb 0
ResetLow
defb 0

; score display for screen writing
ScoreASC
defb 0,0,0,0,0,0
; copy of ScoreH/M/L do not want score altering through partial update
ScoreDisplay
defs 3

; 3 bytes in range 0-99 for score
ScoreH
defb 0
ScoreM
defb 0
ScoreL
defb 0
; each game frame, this is added to ScoreM/L
ScoreFrame
defb 0
defb 0

Lives
defb 3
Shield ; represents both invulnerable and end game states
defb 0
ExplosionSet ; used to trigger player explosion
defb 0

ReturnToMenu
defb 0

WaveDelay ; wait to create next sprite
defb 1
WavePointer ; pointer to next sprites data
defw wave_data

; following variables used in display message for game won
EndCharPtr
defb 0
MegaPtr
defw HeroText
MegaByte
defb 0
HeroPtr
defw HeroText+47
HeroByte
defb 0
CompleteWait
defb 0

ScorePtr ; used to regulate score display update
defb 0

CurrentBank ; used to store current memory bank state for when altered under interrupt
defb #c0

GrindState ; set when player ''grinds'' the background
defb 0

LivesUpdPtr ; used to regulate update of lives and high score display
defb 0
; next two used to regulate the 5000 point bonus awarded at game won
MegaBonus
defb 0
BonusWait
defb 0

; end of replace section

; high score display for screen writing
HiScoreASC
defb 0,1,2,3,4,5

; 3 bytes in range 0-99 for high score
HiScoreH
defb 1
HiScoreM
defb 23
HiScoreL
defb 45

start:

    di ; want to set up the screen split under interupts
    ld sp,#38 ; put stack pointer out of the way

    ld bc,#7F8c
    out (c),c ; set mode 0

    ld a,15 ; set up the 16 inks
    ld hl,Mode0Pal
    call SetColours

    ;ld de,#29c3 ; initialise the main sound track
    ld de,main_sound_track
    call Ply_INIT

;; standard screen is 39 chars tall and vsync at 30
;; with 25 chars displayed

;; we want to change this to 26 chars displayed with vsync at 32

;; set new vsync we want
ld bc,#bc07
out (c),c
ld bc,#bd00+32
out (c),c

;; wait for 2 vsyncs to allow it to stabalise and so that we can sync with that
ld e,2
wait_two_vsyncs:
ld b,#f5
wait_vsync_end:
in a,(c)
rra
jr c,wait_vsync_end
wait_vsync_start:
in a,(c)
rra
jr nc,wait_vsync_start
dec e
jp nz,wait_two_vsyncs

;; synchronised with start of vsync and we are synchronised with CRTC too, and we have the 
;; same number of lines to next screen as we want

;; set initial interrupt routine 
ld hl,int_rout1title
ld (int_rout_ptr+1),hl

;; set interrupt
ld a,#c3
ld hl,int_start
ld (#0038),a
ld (#0039),hl
;; enable
ei

; now begin using interupt 5 as frame start
call wait_int

; setup for title screen
next_int_title_setup
; set border colour black
ld bc,#7f10
out (c),c
ld bc,#7f54
out (c),c
; reset r3 to default for title screen, could have been #85 or #86 during last game frame
ld hl,#0386
ld b,#bc
out (c),h
inc b
out (c),l

; write the credits to the centre part of the title screen, uses bank #4000
    call PrintCredits

; clear both ''high'' and ''low'' screens Title screen uses them for the zoom scrolls
    ld a,#c0
    call ClearScr
    ld a,#80
    call ClearScr

; title screen loop
next_int_title
    call wait_int ; wait for int5

; check if fire pressed on joystick
    ld a,(KBmatrixbuf+9)
    bit 4,a
    jr nz,Exit_Title
; check if space pressed
    ld a,(KBmatrixbuf+5)
    bit 7,a
    jr nz,Exit_Title

; after two screens have been cleared above, title screen should ''just appear'', so have
; only set colours after waiting for new frame  Only required once, but have included
; in main loop as it saves an extra wait_int and there is no harm in repeating
    ld hl,TitlePal
    ld (TitlePalPointer),hl
    ld hl,RasterPal
    ld (TitleRasterPtr),hl
; draw a ''pixel'' column for each zoomed scroll
    call WriteZSColumn
; randomise seed by incrementing at 50hz on title screen
    ld hl,SSRandSeed+1
    inc (hl)
; repeat title loop until fire or space pressed
    jr next_int_title

Exit_Title
; write blank pal to the title screen area while the two game screens are cleared
    ld hl,BlankPal
    ld (TitlePalPointer),hl
    ld (TitleRasterPtr),hl
; clear the two game screens
    ld a,#c0
    call ClearScr
    ld a,#80
    call ClearScr
; clear both ''high'' and ''low'' sprite background buffers Title screen uses same
; area for title text
    xor a
    ld hl,SpriteBufHigh
    ld (hl),a
    ld de,SpriteBufHigh+1
    ld bc,#3ff
    ldir
    ld hl,SpriteBufHigh
    ld de,SpriteBufLow
    ld bc,#400
    ldir
; copy the sprite data reset values
    ld hl,SpritesYXReset
    ld de,SpritesYX
    ld bc,32+48+40
    ldir
; fill the sprite address tables with a dummy value
; first action of each game frame is to clear the sprite data, so
; addresses need to be valid
    ld hl,#cf00 ; dummy address
    ld (SpriteAddrHigh),hl
    ld hl,SpriteAddrHigh
    ld de,SpriteAddrHigh+2
    ld bc,174
    ldir
    ld hl,SpriteAddrHigh
    ld de,SpriteAddrLow
    ld bc,176
    ldir
; swap in level data bank
    ld a,#c7
    ld (CurrentBank),a
    ld b,#7f
    out (c),a
; write start of map to map pointer
    ld hl,Map+40
    ld (MapPointer),hl
;clear the column buffer for writing to right side of screen
    ld hl,#4f60
    ld de,#4f61
    ld (hl),0
    ld bc,159
    ldir
; swap back to main memory
    ld a,#c0
    ld (CurrentBank),a
    ld b,#7f
    out (c),a

; copy the defaults to the game variables
    ld hl,SetupVariables
    ld de,base_addr ; first variable to be set
    ld bc,EndEG-SetupVariables
    ldir

; set up some variables in the interrupt code (see EG_interrupts2asm)
    ld hl,#2000
    ld (base_main),hl
    ld a,#85
    ld (reg3),a
    ld hl,#c04f
    ld (clr_addr),hl
    xor a
    ld (col_inc),a

; game setup is complete, exit title screen interrupts
; wait for int 5
    call wait_int
; and int 6
    halt
; next int would int_rout1title, replace with in game int_rout1
    ld hl,int_rout1
    ld (int_rout_ptr+1),hl
; screen is now arranged with in game screen split code
; begin main game loop
next_int
; wait for next int 5
    call wait_int

; first check game exit conditions
ld a,(ReturnToMenu)
or a ; a non zero value indicates game loop is done
jr z,ContinueGameLoop
; exiting main game loop needs to happen after int 6 as well
halt
; set interrupts to those used for title screen
ld hl,int_rout1title
ld (int_rout_ptr+1),hl
; and return to title set up Colours for title screen will still be blank
; until entry to main loop, so at the next interrupt the title screen will be blanked
jp next_int_title_setup

ContinueGameLoop
; this must be called before int6
    call do_scroll ; move screen left 1 pixel, change screen pointers

; restore the backgrounds saved for sprites from last frame, or fill dummy
; addresses if first game frame
    call RestoreSpriteBG ; 119 scan lines

    call ClearStars

; first up bank in the map data
    ld a,#c7
    ld (CurrentBank),a
    ld b,#7f
    out (c),a

; check to see if the tile column has changed
    call ProcessMapPointer
; for every byte in the buffer, move the right pixel to the left of the byte
; and put a new pixel in the right side according to the map data
    call Fill_Buffer ; 49 scan lines

; copy the buffer to the screen to the current screen right side
    ld hl,(paint_addr)
    call Copy_Buffer ; 11 scan lines

; swap back to main memory
    ld a,#c0
    ld (CurrentBank),a
    ld b,#7f
    out (c),a

    call MoveSprites
; animate sprites is only required every other frame
    ld a,(base_addr+1)
    bit 6,a
    call z,AnimateSprites ; is opposite to UpdateLivesHS to level out CPU use

; Player bullet moves at 12 pixels per frame at 50Hz in C64 version  Therefore at
; 25Hz in CPC version, bullet must move 24 pixels, or 12 bytes  Doing this  in one
; setp creates issue in that player shot moves too far in one frame and hit box
; requires to long a tail, so it becomes possible for bullet to pass through
; background objects or occasionally hit enemies behind other enemies
; To prevent this, the player bullet is moved 12 pixels, or 6 bytes, and collsion
; detection performed on it, TWICE per frame  The following 3 calls perform these
; ''secondary'' move # collision checks

call BulletCollision ; check player shot against sprites
call InterimBulletCollision ; check player shot against background
call InterimBulletMove ; move player shot a second time
call BulletCollision ; check player shot against sprites a second time
call PlayerCollision ; check player against sprites

; check to see if enemy sprites should be converted to explosion for player
ld a,(ExplosionSet)
or a
call nz,SetExplosion
; check to see if new enemy sprite should be created
call ProcessWave
; check all sprites against current screen address reset position
call CheckScreenReset

; generate address list for all sprites
call CalcSprites ; 28 scan lines
; use address list to check player and shot against background
call CheckBackgrounds2

; sum the score for this frame as result of collisions
call UpdateScoreText
; update the lives and high score part of the score panel, only every other frame
ld a,(base_addr+1)
bit 6,a
call nz,UpdateLivesHS ; opposite to animate, up to 4 scan lines

; save the background behind sprites
call SaveSpriteBG ; 130 scan lines
; and then display the sprites
call PrintSprites ; 184 scan lines
; show the stars where nothing would obscure them
call PrintStars
; check for one of two game ending states (no lives or won)
call CheckGameState

; return to beginning of game loop
jp next_int

; wait until int_flag is zeroed by interrupt 5
wait_int
ld a,1
ld (int_flag),a
wait_int_lp
int_flag equ $ + 1
ld a,0
or a
jr nz,wait_int_lp
ret

do_scroll
; move screen base address along
ld hl,(base_addr)
bit 6,h
set 6,h
jr z,no_base_adj
inc hl
res 6,h
res 3,h
no_base_adj
ld (base_addr),hl
; and find column to write new background to
ld de,#4d
add hl,de
res 3,h
ld (paint_addr),hl
; indicate to interrupt routine that it can display the next frame
ld a,1
ld (scroll),a		; Non-zero
ret

; delay for hl/8 scan lines
delay
    dec hl
    nop
    ld a,h
    or l
    jr nz,delay
    ret

CheckGameState
    ld hl,ReturnToMenu ; preload hl with pointer to marker for indicating game loop exit
; if escape not pressed, check if game ended
    ld a,(KBmatrixbuf+8)
    bit 2,a
    jr z,CheckGSGameEnd
; escape pressed, begin pause by first waiting for esc to cease being pressed
PauseWaitReleaseEsc1
    call wait_int
    ld a,(KBmatrixbuf+8)
    bit 2,a
    jr nz,PauseWaitReleaseEsc1
; escape now unpressed, wait for escape to be pressed again to either restart
; play or abort the game
PauseWaitPress
    call wait_int
    ld a,(KBmatrixbuf+8)
    bit 2,a
    jr z,PauseWaitPress
; escape now pressed, last phase of pause or quit
    ld c,51 ; game will quit if escape held for 1 second, if released before will continue
PauseWaitReleaseEsc2
    call wait_int
    dec c ; while escape held, decrement quit counter
    jr z,ExitGame ; if reached 0, have held escape for 1 second, so abort
    ld a,(KBmatrixbuf+8)
    bit 2,a
    jr nz,PauseWaitReleaseEsc2
; if escape released within 1 second, return to game loop where paused from
    ret
ExitGame
    inc (hl) ; set game loop exit marker to non zero, and return to main loop
    ret
; escape not pressed, check state of shield bit 7, will indicate game over or won
CheckGSGameEnd
    ld de,Shield
    ld a,(de)
    bit 7,a
    ret z ; if bit 7 not set, there is no game state exception to process
    cp a,#80 ; if only bit 7 set, game has been won, check progress
    jr z,GameCompleteWait
; if shield > #80, game is over, decrease delay timer (lower 7 bits)
    dec a
    cp a,#80 ; if lower 7 bits are zero
    jr z,ExitGame ; time to exit game loop
    ld (de),a ; otherwise continue delay
    ret ; and continue game loop for another frame
GameCompleteWait
; game is complete, first stage is to wait for the enemy sprite disguised as the player
; to leave the screen
    ld a,(SpritesYX+1)
    rla
    ret nc ; sprite 1 x co-ord still not offscreen, so return to main loop
; the second phase is to wait a couple of extra frames so that both the
; high and low screen addresses for sprite 1 get set to dummies
GameCompletePlyrClear
    ld a,0 ; was set non zero in EG_WaveList2asm
    or a
    jr z,GCPCPauseDone ; when zero, enter end game sequence loop below
; otherwise, return to main loop for another frame
    dec a
    ld (GameCompletePlyrClear+1),a
    ret
; the third phase is to set up the end sequence
GCPCPauseDone
    call wait_int
; show the last drawn screen frame
    call do_scroll
; set the music to the ''win'' music
    ld a,2
    ld (ChangeMusic),a
; some frames the clear column will interfere with left side of visible screen
; when scrolling stops, so move the clr_addr back one byte
    ld hl,(clr_addr)
    ld de,#7ff
    add hl,de
    res 3,h
    ld (clr_addr),hl
; if R3 was changed last do_scroll, also move back one byte base_addr, as
; this stage of end sequence writes to the visible screen
    ld hl,(base_addr)
    bit 6,h
    jr nz,BuildWinMsgLoop
    ld de,#7ff
    add hl,de
    res 3,h
    ld (base_addr),hl
; writing to the visible screen, build ''mega hero'' message, printing one
; character from each word per frame
BuildWinMsgLoop
    call wait_int ; wait for int 5
    call Complete_WriteChar ; write a character from each word
; bonus points for lives remaining are added at this point, the points
; per life are staggered out
; check to see if time to add life bonus
    ld a,(BonusWait)
    or a
    jr z,NoEndBonusLeft ; if bonuswait is zero, have finished giving bonus points
    dec a
    jr nz,NotTimeForEndBonus
    ld a,50 ; if time to give bonus, add 5000 to score
    ld (ScoreFrame),a
    ld a,(MegaBonus) ; check to see if any more bonus points to give
    dec a
    ld (MegaBonus),a
    jr z,NotTimeForEndBonus ; no more to add, so zero the timer
    ld a,50 ; more points to give, so reset timer
NotTimeForEndBonus
    ld (BonusWait),a
NoEndBonusLeft
    call UpdateScoreText ; add score frame to score
    call UpdateLivesHS ; update high score # lives
    ld a,(CompleteWait) ; completewait will be set non zero when message displayed fully
    or a
    jr z,BuildWinMsgLoop ; continue to build ''mega hero'' message
; finished printing ''Mega Hero'', copy visible screen to hidden one
    ld hl,#c000
    ld de,#8000
    ld a,(base_addr+1)
    bit 6,a
    jr z,EndScrnCopyHigh ; copy high to low
; else copy low screen high
    ex de,hl
EndScrnCopyHigh
    ld bc,#4000
    ldir
; now the fourth and final stage of the end sequence
; wait for space or fire from player while setting off explosions
CompleteWaitFireLp
    call wait_int
; want to display some sprites, but need to screen flip without scrolling
; so a little hack job here to do that to base_addr # base_main
    call dont_scroll
; check fire
    ld a,(KBmatrixbuf+9)
    bit 4,a
    jr nz,CWFWaitOver ; exit end sequence
; check space
    ld a,(KBmatrixbuf+5)
    bit 7,a
    jr nz,CWFWaitOver ; exit end sequence
; other execute routines to display and animate explosions only
    call RestoreSpriteBG ; 119 scan lines
    ld a,(base_addr+1)
    bit 6,a
    call z,AnimateSprites ; every other frame
; create a new explosion
    call EndSeqExplosion
; perform required calls from main loop to display the explosion sprites
    call CheckScreenReset
    call CalcSprites ; 28 scan lines
    call SaveSpriteBG ; 130 scan lines
    call PrintSprites ; 184 scan lines
; repeat until player exits with space or fire
    jr CompleteWaitFireLp
CWFWaitOver ; when space or fire pressed
    ld a,1 ; set music back to main theme
    ld (ChangeMusic),a
    ld hl,ReturnToMenu ; and return to main game loop with exit indicated
    jp ExitGame

; perform screen flipping for the end sequence
dont_scroll
    ld a,(base_main+1)
    xor #10
    ld (base_main+1),a
    ld a,(base_addr+1)
    xor #40
    ld (base_addr+1),a
    ret

GenerateRandom
; random number generator - taken from wiki programming section
; only used in this game for random explosion placement in game won sequence
SSRandSeed
; randomise
    ld bc,0
    ld a,b
    ld h,c
    ld l,253
    or a
    sbc hl,bc
    sbc a,0
    sbc hl,bc
    ld b,0
    sbc a,b
    ld c,a
    sbc hl,bc
    jr nc,SSRand
    inc hl
SSRand
    ld (SSRandSeed+1),hl
    ret

Mode0Pal ; in game palette
    defb #54,#5d,#57,#53,#5e,#59,#4b,#5f
    defb #58,#47,#4c,#56,#44,#43,#5c,#54
TitlePal ; title screen palette
    defb #56,#45,#58,#53,#57,#55,#44,#59
    defb #52,#56,#43,#4a,#4e,#5c,#4b,#54
BlankPal ; palette for showing blank screen
    defb #54,#54,#54,#54,#54,#54,#54,#54
    defb #54,#54,#54,#54,#54,#54,#54,#54
; extend raster text for when title screen is setting up
    defb #54,#54,#54,#54,#54,#54,#54,#54
    defb #54,#54,#54,#54,#54,#54,#54,#54
    defb #54,#54,#54,#54,#54,#54,#54,#54
    defb #54,#54,#54,#54,#54,#54,#54,#54
RasterPal ; list of colours for the rolling colours on title screen text
    defb #5c,#54,#58,#54,#4c,#5c,#45,#5c
    defb #4e,#58,#47,#58,#4a,#4c,#43,#4c
    defb #4b,#4e,#43,#4c,#4a,#4c,#47,#58
    defb #4e,#58,#45,#5c,#4c,#5c,#58,#54
; repeat first two lines
    defb #5c,#54,#58,#54,#4c,#5c,#45,#5c
    defb #4e,#58,#47,#58,#4a,#4c,#43,#4c

; these additional variables dont require resetting

; indicator to interrupt to change music
ChangeMusic
    defb 0

; palette pointers for raster coloured font on title screen
TitlePalPointer
    defw BlankPal
TitleRasterPtr
    defw BlankPal
TitleRasterOS
    defb 0

; End sequuence explosion variables
EndExpPtr
    defb 0
EndExpDelay
    defb 0

; temp save current stack pointer
SaveSP
    defw 0

; player sprite frame ptr = 0-6
PlayerFrame
    defb 0

; these tables are copied to #40 as the default starting values
SpritesYXReset
    defb 0,128
    defb 0,128
    defb 0,128
    defb 0,128
    defb 0,128
    defb 0,128
    defb 102,29
    defb 0,192
;SpritesYXMv
    defb 0,0
    defb 0,0
    defb 0,0
    defb 0,0
    defb 0,0
    defb 0,0
    defb 0,0
    defb 0,0
;SpriteData
    defs 48
;    defb rocker,timer,move1,move2,basespr,animtype,animdata,hits
;    defb 64+1,64+1,0,0,101,64,6,2 ; sprite 14
;    defb 64+1,64+1,0,0,107,64,6,2 ; sprite 15
;    defb 64+0,64+0,0,0,113,64,6,2 ; sprite 16
;    defb 64+1,64+1,0,0,52,64,6,2 ; sprite 7
;    defb 64+0,64+0,0,0,85,64,8,3 ; sprite 12
;    defb 64+1,64+1,0,0,93,64,8,3 ; sprite 13
;StarsLow
    defw #10f*2+#8000-400
    defw #1a3*2+#8000-400
    defw #24d*2+#8000-400
    defw #2d9*2+#8000-400
    defw #375*2+#8000-400
    defw #144*2+#8000-400
    defw #1ee*2+#8000-400
    defw #2a1*2+#8000-400
    defw #336*2+#8000-400
    defw #3dc*2+#8000-400
;StarsHigh
    defw #10f*2+#c000-400
    defw #1a3*2+#c000-400
    defw #24d*2+#c000-400
    defw #2d9*2+#c000-400
    defw #375*2+#c000-400
    defw #144*2+#c000-400
    defw #1ee*2+#c000-400
    defw #2a1*2+#c000-400
    defw #336*2+#c000-400
    defw #3dc*2+#c000-400

;    defb 0,0,0,0,19,192,1,0 ; sprite 1
;    defb 0,0,0,0,24,64,6,0 ; sprite 2
;    defb 0,0,0,0,30,64,4,0 ; sprite 3
;    defb 0,0,0,0,34,128,1,0 ; sprite 4
;    defb 0,0,0,0,40,64,6,0 ; sprite 5
;    defb 0,0,0,0,46,64,6,0 ; sprite 6
;    defb 0,0,0,0,52,64,6,0 ; sprite 7
;    defb 0,0,0,0,58,64,7,0 ; sprite 8
;    defb 0,0,0,0,65,64,6,0 ; sprite 9
;    defb 0,0,0,0,71,64,6,0 ; sprite 10
;    defb 0,0,0,0,77,64,8,0 ; sprite 11
;    defb 0,0,0,0,85,64,8,0 ; sprite 12
;    defb 0,0,0,0,93,64,8,0 ; sprite 13
;    defb 0,0,0,0,101,64,6,0 ; sprite 14
;    defb 0,0,0,0,107,64,6,0 ; sprite 15
;    defb 0,0,0,0,113,64,6,0 ; sprite 16

;read "EG_Sprites10asm"
CalcSprites
; calculate screen addresses for sprites
; addresses are calculated for every second address
    ld a,(base_addr+1) ; determine list to write to from current base_addr high byte
    bit 6,a
    jr z,CalcSprLow
    ld hl,SpriteAddrHigh+170 ; 7 sprites x 11 addresses + 1 bullet x 8 addresses = 85x2 or 170 bytes
    jr CalcSprSkipLow
CalcSprLow
    ld hl,SpriteAddrLow+170
    nop
    nop
CalcSprSkipLow
    ld (SaveSP),sp
    ld sp,hl
    ld hl,SpritesYX+15
    exx
    ld h,#42 ; high byte of address table in h''
    exx
    ld b,8 ; sprite total
; for first sprite, only 8 rows as is player shot sprite
    ld a,(hl)
    sub a,16 ; the left of the screen is x co-ord 16, simplifies collision detection and enemy positioning
    jr nc,CalcSprBNotLeft
    xor a ; if sprite falls over left screen edge, align adresses to edge
CalcSprBNotLeft
    cp a,73 ; screen is 78 bytes byte
    jr c,CalcSprBNotRight
    ld a,72 ; ensure sprites that fall over right edge have addresses that are 6 bytes short of right edge
CalcSprBNotRight
; the reason for ensuring that the addresses are positioned such that they do not cross a screen edge is that
; the bullet sprite does not save background in the centre, it simply blanks it, and if the addresses weren''t
; adjusted then clearing it would result in potential corruption of background on the opposite side of screen
; when it leaves the screen, or would require specific screen clearing routine to handle edges
; That''s only relevent to the right edge of course, the left edge is just ''planning ahead''
    dec l
    ex af,af''
    ld a,(hl) ; get sprite y value
    add a,14+1 ; start from bottom of y for bullet, y co-ord must be even
    dec l ; move to next sprite x co-ord
    exx
    ld l,a ; hl'' now points to lowest base address in table for bullet sprite
    ex af,af'' ; get sprite x co-ord back
    ld bc,(base_addr)
    add a,c
    ld c,a
    jr nc,CaSprDontIncDPBul
    inc b
CaSprDontIncDPBul
; bc'' now contains combination of scroll offset + x co-ord to add to base addresses in table
    jr CalcSprPBulEntry ; bullet sprite is shorter, so skip 3 addresses in unrolled loop below
; rest of 7 sprites do full loop
CalcSprLoop
    ld a,(hl) ; grab x co-ord
    sub a,16 ; left screen edge is x co-ord 16
    jr nc,CalcSprNotLeft
    xor a ; ensure sprite addresses dont cross left edge
CalcSprNotLeft
    cp a,73
    jr c,CalcSprNotRight
    ld a,72 ; ensure sprite addresses dont cross right edge
CalcSprNotRight
    dec l ; point to sprite y co-ord
    ex af,af''
    ld a,(hl)
    add a,20+1 ; start from bottom of sprite, y co-ord must be even
    dec l ; point hl to next sprite x co-ord
    exx
    ld l,a ; hl'' now points to lowest base address in table for full sized sprite
    ex af,af''
    ld bc,(base_addr)
    add a,c
    ld c,a
    jr nc,CaSprDontIncD
    inc b
CaSprDontIncD
; bc'' now contains combination of scroll offset + x co-ord to add to base addresses in table
    ld d,(hl) ; load high byte of base address from table into d''
    dec l ; point to low byte of base address
    ld a,(hl) ; load low byte of base address from table into a
    add a,c ; add low byte of offset in bc'' to a
    ld e,a ; and store result in e''
    ld a,b ; get high byte of offset
    adc a,d ; and add d'' and carry from previous add
    ld d,a ; de'' now contains screen address for top of the two scan lines each address is used for
    set 3,d ; want screen address to start from bottom scan line in the event of screen address reset, this will have
            ; occured already, but does not cause a problem as base address starts from top line where reset is less complicated
    push de ; place address into address list pointed to by sp
    dec l ; point to high byte of next base address
; repeat above process another 10 times
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    set 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    set 3,d
    push de
    dec l
CalcSprPBulEntry
; bullet is only 8 addresses, so skips to here
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    set 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    set 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    set 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    set 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    set 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    set 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    set 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    set 3,d
    push de

    exx
    dec b ; repeate for all 8 sprites
    jp nz,CalcSprLoop
;
    ld sp,(SaveSP) ; restore sp and finish
    ret

SaveSpriteBG
    ld a,(base_addr+1) ; determine list to read from current base_addr high byte
    bit 6,a
    jr z,SaveSprBGLow
    ld hl,SpriteAddrHigh ; hl points to high screen sprite addresses
    ld a,(ResetHigh) ; get byte indicating which sprites require slower ''safe'' background save for high screen
    exx
    ld de,SpriteBufHigh ; de'' points to high screen sprite background save buffer
    jr SaveSprBGSkipLow
SaveSprBGLow
    ld hl,SpriteAddrLow ; hl points to low screen sprite addresses
    ld a,(ResetLow) ; get byte indicating which sprites require slower ''safe'' background save for low screen
    exx
    ld de,SpriteBufLow ; de'' points to lowscreen sprite background save buffer
    nop
    nop
SaveSprBGSkipLow
    exx
    ld e,a ; e now has byte indicating which sprites require ''safe'' background save
    ld c,7 ; 7 sprites at full size
SaveSprLpO
    srl e ; put ''safe'' marker bit for current sprite into carry
    jp nc,SaveSprFastSave ; if bit is 0, save background using fast method
    ld b,10 ; 105 line pairs, only save top line of last address, C64 sprites are an irritating 21 lines high
SaveSprLoop
; this saves the background for the sprite a slow or ''safe'' way, which means the sprite was determined to
; have crossed a screen edge, where the addresses no longer reflect the co-ordinates, or have overlapped with
; the screen address reset point  Only one ''safe'' routine, so every shift right is allowing for reset
    ld a,(hl) ; get low byte of address into a
    inc l
    ex af,af''
    ld a,(hl) ; get high byte of address into a''
    inc l
    exx
    ld h,a
    ex af,af''
    ld l,a ; hl'' now contains screen address
;
    ld a,(hl)
    ld (de),a ; copy byte at address to buffer
    inc e ; move to next byte in buffer
    res 3,h ; point screen address to byte above
    ldi ; copy byte and move both buffer and screen address along
    set 3,h ; set screen address to point to lower line again
; sprites are 6 bytes wide, so repeat another 5 times
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    set 3,h
;
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    set 3,h
;
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    set 3,h
;
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    set 3,h
;
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    exx
    djnz SaveSprLoop ; repeat for all 10 line pairs of sprite
; repeat above process one last time for last address line, except only
; copy the top line as sprites are 21 lines high
    ld a,(hl)
    inc l
    ex af,af''
    ld a,(hl)
    inc l
    exx
    ld h,a
    ex af,af''
    ld l,a
;
    res 3,h
    ldi
;
    res 3,h
    ldi
;
    res 3,h
    ldi
;
    res 3,h
    ldi
;
    res 3,h
    ldi
;
    res 3,h
    ldi
;
    inc e ; buffer per sprite is 126 bytes, moving along by two bytes makes 128 bytes,
    inc de ; and buffer is page aligned so can use 8 bit increment on all but this last one
    exx
SaveSprReturn
    dec c ; repeat for all 7 full sized sprites
    jr nz,SaveSprLpO
; now save bullet background
; middle two lines are not save as bullet sprite does not go through background, but can ''clip'' it
; so only top and bottom 3 line pairs are saved
; bullet background is always saved with the slower ''safe'' method
    ld e,2 ; do two sets of 3 pairs
SaveSprPBLpO
    ld b,3 ; 3 line pairs
SaveSprLoopPB ; below as for full sprites above
    ld a,(hl)
    inc l
    ex af,af''
    ld a,(hl)
    inc l
    exx
    ld h,a
    ex af,af''
    ld l,a
;
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    set 3,h
;
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    set 3,h
;
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    set 3,h
;
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    set 3,h
;
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    set 3,h
;
    ld a,(hl)
    ld (de),a
    inc e
    res 3,h
    ldi
    exx
    djnz SaveSprLoopPB
    inc l ; want to skip the two middle screen addresses
    inc l
    inc l
    inc l
    dec e
    jr nz,SaveSprPBLpO
    ret

;SaveSprSkipSave
;    ld a,22
;    add a,l
;    ld l,a
;    exx
;    ld hl,128
;    add hl,de
;    ex de,hl
;    exx
;    jr SaveSprReturn
SaveSprFastSave
    ld b,10 ; 105 line pairs
    exx
    ld c,#ff ; put a value in c'' to stop b'' from corrupting in loop
    exx
SaveSprFLoop
    ld a,(hl) ; get low byte of address into a
    inc l
    ex af,af''
    ld a,(hl) ; get high byte of address into a''
    inc l
    exx
    ld h,a
    ex af,af''
    ld l,a ; hl'' now contains screen address
;
    ld b,h ; save high byte in b
    res 3,h ; set to top line of line pair
    ldi ; copy the 6 bytes for the top line for this address
    ldi
    ldi
    ldi
    ldi
    ldi
    ld h,b ; retrieve the original high byte
    ld l,a ; and put the original low byte back
    ldi ; copy the 6 bytes for the bottom line for this address
    ldi
    ldi
    ldi
    ldi
    ldi
    exx
    djnz SaveSprFLoop ; repeat for all 10 line pairs
; as with ''safe'' method, now need to do just the top line
; for the last address
    ld a,(hl)
    inc l
    ex af,af''
    ld a,(hl)
    inc l
    exx
    ld h,a
    ex af,af''
    ld l,a ; hl'' has address to copy from
;
    res 3,h ; only want top address
    ldi ; copy last 6 bytes, line 21 of the sprite
    ldi
    ldi
    ldi
    ldi
    ldi
;
    inc e ; move de'', the buffer pointer, along 2 bytes so buffer is 128 bytes
    inc de ; and so the slow routine can use 8 bit incs on e
    exx
    jp SaveSprReturn

RestoreSpriteBG
    exx
    ld (SaveSP),sp
    ld a,(base_addr+1)
    bit 6,a ; load initial register values depending on high byte of base address
    jr z,RestSprBGLow
    ld sp,SpriteAddrHigh ; dont need address list again, so can use stack pointer to read
    ld hl,SpriteBufHigh ; hl'' points to buffer of background to restore
    ld a,(ResetHigh) ; a temporarily holds reset byte
    jr RestSprBGSkipLow
RestSprBGLow
    ld sp,SpriteAddrLow
    ld hl,SpriteBufLow
    ld a,(ResetLow)
    nop
    nop
RestSprBGSkipLow
    exx
    ld b,a ; put reset byte into b
    ld c,7 ; 7 full sized sprites
RestSprLpO
    srl b ; put reset bit into carry
    exx
    jp nc,RestSprFastRest ; if reset bit is 0, restore sprite background the fast way
; must restore sprite background the ''safe'' way
    ld c,70 ; 105 line pairs - 6 ldis per iteration, plus 1 for the loop makes c=7*10
RestSprLoop
    pop de ; get screen address into de''
;
    ld a,(hl)
    ld (de),a ; copy byte from buffer back to screen
    inc l ; move buffer pointer along
    res 3,d ; move screen address pointer up to byte above
    ldi ; copy byte from buffer to screen, and move both pointers right one byte
    set 3,d ; set screen address pointer to lower of the two lines
; repeat for the next 5 byte pairs
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
    set 3,d
;
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
    set 3,d
;
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
    set 3,d
;
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
    set 3,d
;
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
;
    dec c
    jr nz,RestSprLoop ; repeat for all 10 full line pairs
;    ld c,#ff ;    dec c
; get last address line and just copy the top line
    pop de
;
    res 3,d
    ldi
;
    res 3,d
    ldi
;
    res 3,d
    ldi
;
    res 3,d
    ldi
;
    res 3,d
    ldi
;
    res 3,d
    ldi
;
    inc l ; move buffer pointer along 2 bytes so sprite buffer is page aligned
    inc hl ; and only this one 16 bit inc is required
RestSprReturn
    exx
    dec c ; repeat above for all 7 full sized sprites
    jr nz,RestSprLpO
; now restore the smaller player bullet, always performed with ''safe'' method
    exx
    ld b,2 ; 2 lots of 3 line pairs
RestSprLpPBO
    ld c,21 ; each line pair with 6 ldis per iteration 3*7=21
RestSprLoopPB ; below restore as for full sprites above
    pop de
;
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
    set 3,d
;
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
    set 3,d
;
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
    set 3,d
;
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
    set 3,d
;
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
    set 3,d
;
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
    ldi
;
    dec c
    jr nz,RestSprLoopPB ; do the 3 line pairs
    djnz RestSprPBMidLoop ; if b is not zero, jumpt to below routine to blank the two middle line pairs
    exx
    ld sp,(SaveSP)
    ret
RestSprPBMidLoop

    ld c,2 ; two line pairs in middle of bullet sprite to blank
    xor a ; zero a to write to the screen
RestSprLoopPBBlank
    pop de ; get screen address into de''
;
    ld (de),a ; blank the first byte
    res 3,d
    ld (de),a ; blank the byte above
    inc de ; move screen pointer right
    set 3,d ; and set screen pointer to lower of two line pairs
; repeat process for next 10 bytes
    ld (de),a
    res 3,d
    ld (de),a
    inc de
    set 3,d
;
    ld (de),a
    res 3,d
    ld (de),a
    inc de
    set 3,d
;
    ld (de),a
    res 3,d
    ld (de),a
    inc de
    set 3,d
;
    ld (de),a
    res 3,d
    ld (de),a
    inc de
    set 3,d
;
    ld (de),a
    res 3,d
    ld (de),a
;
    dec c
    jr nz,RestSprLoopPBBlank ; repeat for the second pair of lines to be blanked
    jr RestSprLpPBO ; jump back to loop to restore background for lower part of bullet sprite

RestSprFastRest
    ld c,130 ; 105 line pairs, 10 full pairs, 12 ldis per iterations, c=13*10
RestSprFLoop
    pop de ; get screen address into de''
    ld a,e ; save low byte in a
    ld b,d ; save high byte in b''
;
    res 3,d ; set de'' to point to top of the two lines
    ldi ; copy the top 6 bytes
    ldi
    ldi
    ldi
    ldi
    ldi
    ld d,b ; reset de'' to begining of lower line
    ld e,a
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    dec c ; repeat for all 10 lines
    jr nz,RestSprFLoop
;    ld c,#ff
    pop de ; get the last address
;
    res 3,d ; set to top line
    ldi ; copy the last 6 bytes
    ldi
    ldi
    ldi
    ldi
    ldi
;
    inc l ; move pointer to buffer along 2 bytes
    inc hl
    jp RestSprReturn ; return to main background restore loop

PrnSprSkipSprite ; if sprite not on screen, simply move address pointer along and re-enter sprite print loop
    ld a,22
    add a,ixl
    ld ixl,a
    jp PrnSprSkipSpriteReturn

PrintSprites
; map in sprite bank
    ld a,#c6
    ld (CurrentBank),a ; save current memory setting
    ld b,#7f
    out (c),a ; and bank in sprites
    ld a,(base_addr+1) ; retrieve high byte of base_screen
    bit 6,a
    jr z,PrnSprLow ; determine which address list to use
    ld ix,SpriteAddrHigh
    jr PrnSprSkipLow
PrnSprLow
    ld ix,SpriteAddrLow
PrnSprSkipLow
    ld b,6 ; 6 enemy sprites to print
    ld hl,SpriteData+5 ; point to location of first sprite''s animation byte
    ld de,SpritesYX+1 ; point to location of first sprite''s x co-ord
PrnSprLpO
; get sprite frame
    ld a,(hl)
    bit 4,a ; first determine if enemy was just hit and needs to strobe
    jr z,NotStrobeFrame
    exx ; if so, swap out current b
    ld a,#c4 ; and bank in the strobed versions of sprite frames
    ld (CurrentBank),a
    ld b,#7f
    out (c),a
    exx
    ld a,(hl) ; re-fetch the animation byte
NotStrobeFrame
    and #f ; filter out all bits but the last 4, which are the frame offset
    dec l ; point hl to the base frame for the sprite
    add a,(hl) ; add base frame to offset
    ld c,a ; store sprite frame to display in c
    ld a,(de) ; get the sprite x co-ord
; test x co-ord for print sprite
;SwimmerPrintEntry
    sub a,16 ; if sprite crosses left edge
    jp c,PrnSprOnLeftEdge ; jump to routine to handle found in EG_sprites_partialasm
    sub a,73 ; if sprite crosses right edge or is unused
    jp nc,PrnSprOnRightEdge ; jump to routine to handle found in EG_sprites_partialasm
    ld a,c ; retrieve sprite frame to print
; get sprite frame data start address
    exx ; save loop counters and pointers by using alternate registers
    ld l,0 ; zero l, sprites are page aligned with 2 empty bytes following every 126 byte sprite
    srl a ; divide a by 2, equates to a=a*128 for high byte
    jr nc,PrnSprDontIncL
    set 7,l ; if carry, sprite low byte pointer needs to be #80
PrnSprDontIncL
    add a,#40 ; sprites banked into #4000, so add #40 to a
    ld h,a ; and ld into h, hl'' now points to beginning of sprite data
    ld b,10 ; there are 10 full line pairs per sprite
PrnSprLoop
; get screen address into de''
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
; the speed gain from having a fast and ''safe'' way of printing the sprites was fairly small,
; and the sprite data required re-ordering to be faster in such a way that the ''safe'' write
; would be even slower, so for this case, sprites are always printed a ''safe'' way with respect
; to the screen address reset
    ld a,(hl) ; get the first byte, which is the lower left byte of the address line pair
    or a ; check if it''s zero, masking only performed at byte level, or by pixel pairs
    jr z,PrnSprSkip1 ; don''t print the byte to screen if zero
    ld (de),a ; otherwise, print it
PrnSprSkip1
    res 3,d ; move the screen address pointer to the byte above
    inc l ; move the sprite data pointer along
    ld a,(hl) ; get the second data byte, now the top left byte of the address line pair
    or a ; check if it''s zero
    jr z,PrnSprSkip2 ; skip if it is
    ld (de),a ; print if it is not
PrnSprSkip2
    inc de ; move screen address pointer right
    set 3,d ; and move to the second line of the address line pair
    inc l ; move the sprite data pointer along one byte
; repeat for another 10 bytes, so all 12 bytes are printed
    ld a,(hl)
    or a
    jr z,PrnSprSkip3
    ld (de),a
PrnSprSkip3
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip4
    ld (de),a
PrnSprSkip4
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip5
    ld (de),a
PrnSprSkip5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip6
    ld (de),a
PrnSprSkip6
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip7
    ld (de),a
PrnSprSkip7
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip8
    ld (de),a
PrnSprSkip8
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip9
    ld (de),a
PrnSprSkip9
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip10
    ld (de),a
PrnSprSkip10
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip11
    ld (de),a
PrnSprSkip11
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip12
    ld (de),a
PrnSprSkip12
    inc l
; repeat for all 10 address line pairs
    djnz PrnSprLoop
; need to do last line of sprite, just the high line of the last address
; get address into de''
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d ; set the address to high line first
    ld a,(hl) ; get the data byte
    or a ; check if zero
    jr z,PrnSprSkip13 ; skip if it is
    ld (de),a ; otherwise print it
PrnSprSkip13
    inc l ; move sprite data pointer along
    inc de ; move the screen pointer right
; repeat above for 5 more bytes
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip14
    ld (de),a
PrnSprSkip14
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip15
    ld (de),a
PrnSprSkip15
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip16
    ld (de),a
PrnSprSkip16
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip17
    ld (de),a
PrnSprSkip17
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip18
    ld (de),a
PrnSprSkip18
; at this point, partial sprite print routines for left and right screen edge re-enter the main loop
PrnSprPartialReturn
; in case last frame was strobe, set back to normal bank containing normal sprite frame data
    ld a,#c6
    ld (CurrentBank),a
    ld b,#7f
    out (c),a
    exx ; get back the counter and pointer registers
PrnSprSkipSpriteReturn ; if sprite was skipped, jumps to here after moving ix along
    inc e
    inc e ; move de along to next sprite x co-ord
    ld a,9
    add a,l
    ld l,a ; move hl along to next sprite''s animation data
;
    dec b ; repeat for all 6 enemy sprites
    jp nz,PrnSprLpO
; player sprite frames and enemy bullet are compiled sprites, in a different bank
; map in compiled sprite bank
    ld a,#c5
    ld (CurrentBank),a
    ld b,#7f
    out (c),a
; check shield life
    ld a,(Shield) ; check if player has invulnerabilty or game is over/complete
    or a
    jr z,PrnPlayerNormal ; if shield=0 continue as normal
    bit 7,a ; if highest bit is set
    jr nz,PrnPlySkip ; game over or complete, dont print player
    dec a ; otherwise, player died recently and is now invulnerable, so flicker (max of 2 seconds)
    ld (Shield),a ; write back new shield value
    cp a,25 ; if shield has less than a second left, want to flash faster
    jr c,PrnPlayerFastFlash ; so skip one divide by 2
    rra ; if shield more than one second left, flash slower
PrnPlayerFastFlash
    rra
    jr c,PrnPlySkip ; skip player display depending on shield value bits 1 or two to indicate invulnerability
;
PrnPlayerNormal
    ld a,(GrindState) ; check if player is currently grinding against background
    or a
    jr z,PrnPlyNoGrind ; if grind state is 0, not grinding, use normal frames
    dec a ; otherwise player is grinding, a counter is used because top and bottom of player are checked in alternate frames
    ld (GrindState),a ; so grind state persists for 1 frame after grinding is detected
    ld a,#10 ; now load lookup table offset for grinding player sprite frames
PrnPlyNoGrind
    ld e,a ; ld e with 0 or #10
    ld a,(PlayerFrame) ; get player frame 0-6
    ld h,#40 ; get high byte of lookup table into h
    add a,a ; double the players frame value
    add a,e ; and add to e
    ld l,a ; put into l  hl now points to address of compiled sprite to jump to
    ld e,(hl) ; get low byte of sprite frame address
    inc l
    ld d,(hl) ; get high byte of sprite frame address
    ex de,hl ; hl now has start address of compiled sprite routine
    ld iy,PlySprReturn ; put return address in iy
    jp (hl) ; jump to player display routine, see CompiledSpriteBank2asm
PrnPlySkip ; if player was not displayed, move screen address pointer along
    ld de,22
    add ix,de
PlySprReturn ; compiled player sprite routines return to here
    ld a,(SpritesYX+15) ; get x co-ord of player bullet
    sub a,72+16 ; adjust x co-ord so that a becomes 1-5 for partial frames on right screen edge
    jr c,PrnSpPBComplete ; if carried, need to print entire bullet sprite
    cp a,6 ; if player bullet not onscreen
    jr nc,LaserPrnRet ; dont print the bullet
    jr PrnSprPBCSkip ; otherwise continue, and skip the next line
PrnSpPBComplete
    xor a ; the full frame of the player bullet is the first entry in the lookup table
PrnSprPBCSkip
    ld h,#40 ; lookup table for player bullet starts at #4020
    add a,a ; double a to get address of routine for player bullet frame required
    add a,#20
    ld l,a ; hl now points to entry for address to jump to
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl ; hl now holds address to jump to
    ld iy,LaserPrnRet ; load return address into iy
    jp (hl)
LaserPrnRet ; bullet print returns here, or if bullet offscreen, skips to here
; map out compiled sprite bank, set memory to all base ram
    ld a,#c0
    ld (CurrentBank),a
    ld b,#7f
    out (c),a
    ret

; this routine randomly places an explosion on the screen during the end sequence
EndSeqExplosion
; only create a new explosion every 4 game frames
    ld a,(EndExpDelay)
    inc a
    and 3
    ld (EndExpDelay),a
    ret nz ; abort if not time to create a new explosion
; loop through a pointer to a sprite, cycles through 0-5
    ld a,(EndExpPtr)
    inc a
    cp a,6
    jr c,ESENoRstPtr
    xor a
ESENoRstPtr
    ld (EndExpPtr),a ; a now equals 0-5
; sprite coords
    add a,a ; double a
    add a,SpritesYX+1 ; and add Sprite co-ord base +1 so point to sprite x co-ord
    ld l,a
    ld h,0 ; hl now points to x co-ord in SpritesYX
    ld a,(hl)
    rla ; see if sprite co-ord is 128 or high, indication sprite is not in use
    ret nc ; abort if sprite is already on screen
    push hl ; preserve pointer
    call GenerateRandom ; get a random number for x co-ord
    ld a,l ; a has psuedo random number
    pop hl ; retrieve co-ord pointer
    and #7f ; make a 0-127
    cp a,80 ; check if over 79
    jr c,ESENoCorrX
    sub a,64 ; reduce by 64 if over 79
ESENoCorrX
    add a,13 ; and add 13
    ld (hl),a ; sprite x co-ord now 13-92
    dec l ; point to sprite y co-ord
    push hl ; save pointer to y
    call GenerateRandom ; get another random number
    ld a,l ; a has the random number
    pop hl ; get pointer to y back
    cp a,200 ; check if over 199
    jr c,ESENoCorrY
    sub a,128 ; reduce by 128 if over 199
ESENoCorrY
    add a,24 ; a now holds 24-223
    res 0,a ; y co-ord must be even number
    ld (hl),a ; write to sprite y
; no set up the sprite data
    ld a,l
    sub a,SpritesYX ; get a back to sprite index times 2
    add a,a
    add a,a ; now have sprite index times 8, length of SpriteData record
    add a,SpriteData+6 ; add SpriteData base, plus point to animation data record
    ld l,a ; h is identical for SpritesYX and SpriteData, so hl now points to appropriate SprideData entry
    xor a
    ld (hl),a ; animation data for explosion is zero
    dec l
    ld (hl),32 ; set animation type, start frame and transparent
    dec l
    ld (hl),a ; set base sprite frame
    dec l
    ld (hl),a ; timer
    dec l
    ld (hl),a ; rocker
    dec l
    ld (hl),64+2 ; move 2 - stationary
    dec l
    ld (hl),64+2 ; move 1 - stationary
; explosion now created
    ret

;read "EG_Sprites_Partialasm"
; this file contains sprite printing routines for partial sprites that cross the
; left and right edges of the screen

; these wont be commented as they are a straight forward revision of the main sprite
; printing code

; Only thing to note is that screen addresses are always calculated
; for a 6x21 byte block that is entirely on the screen and does not cross an edge, so for
; printing sprites on the left edge, the sprite uses the screen addresses in the address
; list but for printing on the right edge, the addresses will be 6 bytes from the right
; edge, so the routines need to move the address right by 6 minus the number of bytes
; to print 

PrnSprOnLeftEdge
    inc a
    jp z,PrnSprLeft5
    inc a
    jp z,PrnSprLeft4
    inc a
    jp z,PrnSprLeft3
    inc a
    jp z,PrnSprLeft2
    inc a
    jp nz,PrnSprSkipSprite
; assume print one column of sprite on left
    ld a,c
    exx
    ld l,0
    srl a
    jr nc,PrnSprDontIncLL1
    set 7,l
PrnSprDontIncLL1
    add a,#40
    ld h,a
    ld b,10
PrnSprLoopL1
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip11L1
    ld (de),a
PrnSprSkip11L1
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip12L1
    ld (de),a
PrnSprSkip12L1
    inc l
;
    djnz PrnSprLoopL1
;
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    inc l
;
    inc l
;
    inc l
;
    inc l
;
    inc l
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip18L1
    ld (de),a
PrnSprSkip18L1
    jp PrnSprPartialReturn

PrnSprLeft5
    ld a,c
    exx
    ld l,0
    srl a
    jr nc,PrnSprDontIncLL5
    set 7,l
PrnSprDontIncLL5
    add a,#40
    ld h,a
    ld b,10
PrnSprLoopL5
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    inc l
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip3L5
    ld (de),a
PrnSprSkip3L5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip4L5
    ld (de),a
PrnSprSkip4L5
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip5L5
    ld (de),a
PrnSprSkip5L5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip6L5
    ld (de),a
PrnSprSkip6L5
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip7L5
    ld (de),a
PrnSprSkip7L5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip8L5
    ld (de),a
PrnSprSkip8L5
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip9L5
    ld (de),a
PrnSprSkip9L5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip10L5
    ld (de),a
PrnSprSkip10L5
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip11L5
    ld (de),a
PrnSprSkip11L5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip12L5
    ld (de),a
PrnSprSkip12L5
    inc l
;
    djnz PrnSprLoopL5
;
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    inc l
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip14L5
    ld (de),a
PrnSprSkip14L5
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip15L5
    ld (de),a
PrnSprSkip15L5
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip16L5
    ld (de),a
PrnSprSkip16L5
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip17L5
    ld (de),a
PrnSprSkip17L5
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip18L5
    ld (de),a
PrnSprSkip18L5
    jp PrnSprPartialReturn

PrnSprLeft4
    ld a,c
    exx
    ld l,0
    srl a
    jr nc,PrnSprDontIncLL4
    set 7,l
PrnSprDontIncLL4
    add a,#40
    ld h,a
    ld b,10
PrnSprLoopL4
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    inc l
    inc l
;
    inc l
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip5L4
    ld (de),a
PrnSprSkip5L4
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip6L4
    ld (de),a
PrnSprSkip6L4
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip7L4
    ld (de),a
PrnSprSkip7L4
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip8L4
    ld (de),a
PrnSprSkip8L4
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip9L4
    ld (de),a
PrnSprSkip9L4
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip10L4
    ld (de),a
PrnSprSkip10L4
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip11L4
    ld (de),a
PrnSprSkip11L4
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip12L4
    ld (de),a
PrnSprSkip12L4
    inc l
;
    djnz PrnSprLoopL4
;
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    inc l
;
    inc l
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip15L4
    ld (de),a
PrnSprSkip15L4
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip16L4
    ld (de),a
PrnSprSkip16L4
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip17L4
    ld (de),a
PrnSprSkip17L4
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip18L4
    ld (de),a
PrnSprSkip18L4
    jp PrnSprPartialReturn

PrnSprLeft3
    ld a,c
    exx
    ld l,0
    srl a
    jr nc,PrnSprDontIncLL3
    set 7,l
PrnSprDontIncLL3
    add a,#40
    ld h,a
    ld b,10
PrnSprLoopL3
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip7L3
    ld (de),a
PrnSprSkip7L3
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip8L3
    ld (de),a
PrnSprSkip8L3
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip9L3
    ld (de),a
PrnSprSkip9L3
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip10L3
    ld (de),a
PrnSprSkip10L3
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip11L3
    ld (de),a
PrnSprSkip11L3
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip12L3
    ld (de),a
PrnSprSkip12L3
    inc l
;
    djnz PrnSprLoopL3
;
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    inc l
;
    inc l
;
    inc l
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip16L3
    ld (de),a
PrnSprSkip16L3
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip17L3
    ld (de),a
PrnSprSkip17L3
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip18L3
    ld (de),a
PrnSprSkip18L3
    jp PrnSprPartialReturn

PrnSprLeft2
    ld a,c
    exx
    ld l,0
    srl a
    jr nc,PrnSprDontIncLL2
    set 7,l
PrnSprDontIncLL2
    add a,#40
    ld h,a
    ld b,10
PrnSprLoopL2
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip9L2
    ld (de),a
PrnSprSkip9L2
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip10L2
    ld (de),a
PrnSprSkip10L2
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip11L2
    ld (de),a
PrnSprSkip11L2
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip12L2
    ld (de),a
PrnSprSkip12L2
    inc l
;
    djnz PrnSprLoopL2
;
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    inc l
;
    inc l
;
    inc l
;
    inc l
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip17L2
    ld (de),a
PrnSprSkip17L2
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip18L2
    ld (de),a
PrnSprSkip18L2
    jp PrnSprPartialReturn

PrnSprOnRightEdge
    or a
    jp z,PrnSprRight5
    dec a
    jp z,PrnSprRight4
    dec a
    jp z,PrnSprRight3
    dec a
    jp z,PrnSprRight2
    dec a
    jp nz,PrnSprSkipSprite ; if sprite so far right is offscreen or unused, simply skip the sprite
; assume print one column of sprite on right
    ld a,c
    exx
    ld l,0
    srl a
    jr nc,PrnSprDontIncLR1
    set 7,l
PrnSprDontIncLR1
    add a,#40
    ld h,a
    ld b,10
PrnSprLoopR1
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
    set 3,d
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip1R1
    ld (de),a
PrnSprSkip1R1
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip2R1
    ld (de),a
PrnSprSkip2R1
    inc de
    set 3,d
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    djnz PrnSprLoopR1
;
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip13R1
    ld (de),a
PrnSprSkip13R1
    jp PrnSprPartialReturn

PrnSprRight5
    ld a,c
    exx
    ld l,0
    srl a
    jr nc,PrnSprDontIncLR5
    set 7,l
PrnSprDontIncLR5
    add a,#40
    ld h,a
    ld b,10
PrnSprLoopR5
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d
    inc de
    set 3,d
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip1R5
    ld (de),a
PrnSprSkip1R5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip2R5
    ld (de),a
PrnSprSkip2R5
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip3R5
    ld (de),a
PrnSprSkip3R5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip4R5
    ld (de),a
PrnSprSkip4R5
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip5R5
    ld (de),a
PrnSprSkip5R5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip6R5
    ld (de),a
PrnSprSkip6R5
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip7R5
    ld (de),a
PrnSprSkip7R5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip8R5
    ld (de),a
PrnSprSkip8R5
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip9R5
    ld (de),a
PrnSprSkip9R5
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip10R5
    ld (de),a
PrnSprSkip10R5
    inc l
;
    inc l
    inc l
;
    djnz PrnSprLoopR5
;
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip13R5
    ld (de),a
PrnSprSkip13R5
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip14R5
    ld (de),a
PrnSprSkip14R5
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip15R5
    ld (de),a
PrnSprSkip15R5
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip16R5
    ld (de),a
PrnSprSkip16R5
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip17R5
    ld (de),a
PrnSprSkip17R5
    jp PrnSprPartialReturn

PrnSprRight4
    ld a,c
    exx
    ld l,0
    srl a
    jr nc,PrnSprDontIncLR4
    set 7,l
PrnSprDontIncLR4
    add a,#40
    ld h,a
    ld b,10
PrnSprLoopR4
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d
    inc de
    res 3,d
    inc de
    set 3,d
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip1R4
    ld (de),a
PrnSprSkip1R4
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip2R4
    ld (de),a
PrnSprSkip2R4
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip3R4
    ld (de),a
PrnSprSkip3R4
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip4R4
    ld (de),a
PrnSprSkip4R4
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip5R4
    ld (de),a
PrnSprSkip5R4
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip6R4
    ld (de),a
PrnSprSkip6R4
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip7R4
    ld (de),a
PrnSprSkip7R4
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip8R4
    ld (de),a
PrnSprSkip8R4
    inc de
    set 3,d
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    djnz PrnSprLoopR4
;
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d
    inc de
    res 3,d
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip13R4
    ld (de),a
PrnSprSkip13R4
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip14R4
    ld (de),a
PrnSprSkip14R4
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip15R4
    ld (de),a
PrnSprSkip15R4
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip16R4
    ld (de),a
PrnSprSkip16R4
    jp PrnSprPartialReturn

PrnSprRight3
    ld a,c
    exx
    ld l,0
    srl a
    jr nc,PrnSprDontIncLR3
    set 7,l
PrnSprDontIncLR3
    add a,#40
    ld h,a
    ld b,10
PrnSprLoopR3
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
    set 3,d
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip1R3
    ld (de),a
PrnSprSkip1R3
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip2R3
    ld (de),a
PrnSprSkip2R3
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip3R3
    ld (de),a
PrnSprSkip3R3
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip4R3
    ld (de),a
PrnSprSkip4R3
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip5R3
    ld (de),a
PrnSprSkip5R3
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip6R3
    ld (de),a
PrnSprSkip6R3
    inc de
    set 3,d
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    djnz PrnSprLoopR3
;
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip13R3
    ld (de),a
PrnSprSkip13R3
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip14R3
    ld (de),a
PrnSprSkip14R3
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip15R3
    ld (de),a
PrnSprSkip15R3
    jp PrnSprPartialReturn

PrnSprRight2
    ld a,c
    exx
    ld l,0
    srl a
    jr nc,PrnSprDontIncLR2
    set 7,l
PrnSprDontIncLR2
    add a,#40
    ld h,a
    ld b,10
PrnSprLoopR2
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
    set 3,d
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip1R2
    ld (de),a
PrnSprSkip1R2
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip2R2
    ld (de),a
PrnSprSkip2R2
    inc de
    set 3,d
    inc l
;
    ld a,(hl)
    or a
    jr z,PrnSprSkip3R2
    ld (de),a
PrnSprSkip3R2
    res 3,d
    inc l
    ld a,(hl)
    or a
    jr z,PrnSprSkip4R2
    ld (de),a
PrnSprSkip4R2
    inc de
    set 3,d
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    inc l
    inc l
;
    djnz PrnSprLoopR2
;
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl
;
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
    res 3,d
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip13R2
    ld (de),a
PrnSprSkip13R2
    inc l
    inc de
;
    res 3,d
    ld a,(hl)
    or a
    jr z,PrnSprSkip14R2
    ld (de),a
PrnSprSkip14R2
    jp PrnSprPartialReturn

;read "EG_Display3asm"
InitDisplay
; ***** this routine no longer used, left here for reference *****
; score update moved to interupt and updates much more often, so initialisation no longer required
; lives display is updated ''fast enough'' with normal display update, so ultimately this is not really required

; routine to reset score and lives display at beginning of game
; first display full lives
    ld b,3 ; lives at start of game
    ld de,#40c2 ; screen address for left most life marker
InitLiLp
    ld hl,#43a0 ; location of life marker graphic
    call PrintLife
    res 5,d ; move to first scan line of char line
    ld a,4 ; life marker is 4 bytes wide
    add a,e
    ld e,a ; add 4 to de, d will never change
    djnz InitLiLp
; now show zero score
    ld b,6 ; score is 6 digits
    ld de,#485e ; screen address of score
InitScLp
    xor a ; ld a with digit to print
    call PrintScoreChar
    res 5,d ; reset d to 2nd scan line of character
    set 3,d
    inc e
    inc e ; and move e along by 2 bytes
    djnz InitScLp
    ret

; when LivesUpdPtr = 0 in routine UpdateLivesHS below, check score # high score and copy if need be
ULHSCheckScore
; score is stored in 3 bytes, valid values are 0-99 in each byte
    ld de,ScoreH ; point de to high byte of score
    ld hl,HiScoreH ; point hl to high byte of high score
    ld a,(de)
    cp a,(hl) ; compare the two high bytes
    ret c ; done if score byte less than high score byte
    jr nz,ULHSCopyHighScore ; hi byte of score is higher than hiscore, so copy
; is equal, so check middle byte
    inc e
    inc l
    ld a,(de)
    cp a,(hl)
    ret c ; high bytes equal, middle byte of score still less, so abort
    jr nz,ULHSCopyHighScore ; mid byte of score is higher than hiscore, so copy
; is equal, so check low byte
    inc e
    inc l
    ex de,hl ; score low byte must be higher, not equal or higher as previous two tests
    ld a,(de)
    cp a,(hl)
    ret nc ; high score stands, abort
ULHSCopyHighScore
; new high score, copy the 3 byte score to high score
    ld hl,ScoreH
    ld de,HiScoreH
    ldi
    ldi
    ldi
; format the first byte to text that can be displayed
    ld hl,HiScoreASC ; start of high score display buffer
    ld a,(HiScoreH) ; get first (high) byte
    jp FindNumber8bit ; convert and end

ULHSFormatScore
; format the last two bytes of high score begun previously
    ld hl,HiScoreASC+2 ; location in high score display buffer to start with
    ld de,HiScoreM ; point to middle byte
    ld a,(de) ; and retrieve
    inc e ; point to low byte of high score
    call FindNumber8bit ; convert middle byte of high score - written to hl
    inc l ; move hl along one
    ld a,(de) ; get low byte
    jp FindNumber8bit ; convert and end

UpdateLivesHS
    ld a,(LivesUpdPtr)
    inc a
    and 7
    ld (LivesUpdPtr),a
    jr z,ULHSCheckScore
    rlca ; double a so can be used as screen address pointer
    sub a,8
    jr z,ULHSFormatScore ; if a=0 complete formatting high score
    jr c,ULHSPrintLife ; if a<0 print one of the 3 life markers
; at this point, a = 2,4,6, so update 2 chars of high score
    ld c,a ; save a in c
    ld h,1
    add a,HiScoreASC-#102
    ld l,a ; hl now points to one of 3 digit pairs from high score at HiScoreASC
    ld a,c ; get a back from c to determine screen address
    ld d,#48 ; high byte of high score screen address
    rlca
    add a,#82
    ld e,a ; de now contains target screen address
    ld a,(hl) ; get digit 0-9 to print (not actually ASCII, despite the label)
    push hl ; save character code ptr
    call PrintScoreChar ; and print the first character
    res 5,d ; ended at 5 of the character line
    set 3,d ; so get back to the 2nd line for the next character
    inc e
    inc e ; and move 2 bytes along
    pop hl ; get back the ptr to the character code
    inc l
    ld a,(hl) ; and get the second digit
    jp PrintScoreChar ; print second digit and quit
ULHSPrintLife
    add a,8 ; make a positive again, will be 2,4 or 6
    ld c,a ; save in c
    rlca ; double again, life marker is 4 bytes wide
    add a,#c2-4 ; add screen address offset (low byte)
    ld e,a
    ld d,#40 ; de now points to screen address to be written
    ld hl,#43a0 ; Life marker data
    ld a,(Lives) ; get current lives
    add a,a ; double so can compare to value saved in c
    cp a,c
    jr nc,PrintLife ; if less lives than current marker position would indicate
    ld l,#c0 ; change hl to point to blank space rather than life marker
PrintLife
; de points to screen address, hl to source
; uses a simple unrolled copy  Probably overkill but was easiest to just expand on the text writer
; used for the scores, and memory is not an issue
; 1
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    set 3,d
; 2
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    set 4,d
; 3
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
; 4
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    set 5,d
; 5
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    set 3,d
; 6
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    res 4,d
; 7
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d
; 8
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    ret

FindNumber8bit
; take the a register holding 0-99 and write the 10''s and units to buffer at hl
    ld c,10
    ld b,0
FiNu8bitLoop
    inc b
    sub a,c
    jr nc,FiNu8bitLoop
    dec b
    add a,c
    ld (hl),b
    inc l
    ld (hl),a
    ret

UpdateScoreText
; first, take the total of the score addition for this frame and add it to score
    ld hl,ScoreFrame+1 ; point hl to low byte of score accrued this frame
    ld de,ScoreL ; point de to low byte of score
    ld c,100 ; value a score byte must remain under
    ld a,(de)
    add a,(hl) ; add score low byte to frame low byte
    ld (hl),0 ; clear the frame low byte
    dec l ; and point to the msb frame score byte (equivalent to the score mid byte)
    ld b,(hl) ; get the msb value into b
    ld (hl),0 ; and clear the msb frame score
    cp a,c ; check if the low byte has exceeded 99
    jr c,ScoreFrameNoOverflow
    sub a,c ; reduce the low byte by 100
    inc b ; and increment the frame msb
ScoreFrameNoOverflow
    ld (de),a ; write the new score low byte
    dec e
    ld a,(de) ; get the old score mid byte
    add a,b ; and add the frame msb
    cp a,c ; check if that has exceeded it''s maximum of 99
    jr c,ScoreFrameDone
    sub a,c ; if so, subtract 100 from mid byte of score
    ld (de),a ; and write back to score
    dec e ; point to high score byte
    ld a,(de) ; get high byte in a
    inc a ; can only increase by one
ScoreFrameDone
    ld (de),a ; write new mid/high byte back to score
; display of score itself is handled under interrupt, see EG_Interrupts2asm
    ret

;; update the text of the score over 8 frames
;    ld a,(scroll_step)
;    and a,7
;;
;    jr z,UpdScTxtStep0
;    dec a
;    jr z,UpdScTxtStep1
;; last 6 steps are to print the 6 characters 1 each frame     
;; find loc and put in de
;    ld d,#48
;    ld c,a
;    rlca
;    add a,#5e-2
;    ld e,a
;; get char code
;    ld a,c
;    ld h,1
;    add a,#29-1 ; ptr is 1-6 so sub 1 from start
;    ld l,a
;    ld a,(hl)
;; point to char data with hl

PrintScoreChar
; de points to screen address, a holds code 0-9
; translate code in a to pointer to char data in hl
    ld h,#43
    rlca
    rlca
    rlca
    rlca
    ld l,a    ;7
; now print the char
; characters are all 6 lines high, printed on pixel lines 2-7 of a character line
; line 2
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    set 4,d   ;13
; line 4
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d   ;13
; line 3
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    set 5,d   ;13
; line 7
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a
    inc l
    set 3,d
    res 4,d   ;15
; line 6
    ld a,(hl)
    ld (de),a
    inc l
    inc e
    ld a,(hl)
    ld (de),a
    inc l
    res 3,d   ;13
; line 5
    ld a,(hl)
    ld (de),a
    inc l
    dec e
    ld a,(hl)
    ld (de),a ;10
    ret       ;84+8=92

Complete_WriteChar
; character writer for end sequence, writes ''mega hero'' on screen at completion
    ld a,(EndCharPtr) ; is a ptr=0-223, each word is a 7 by 32 block of characters, 1 char printed each frame
    ld c,a ; save pointer in c
    and 3 ; every 4 chars printed, move to the next byte
    jr nz,Complete_SameBytes
    ld hl,(MegaPtr)
    ld a,(hl)
    inc hl ; the word mega starts from top, works right and down
    ld (MegaPtr),hl
    ld (MegaByte),a
    ld hl,(HeroPtr)
    ld a,(hl)
    dec hl ; the word hero starts from bottom, works left and up
    ld (HeroPtr),hl
    ld (HeroByte),a
Complete_SameBytes
    ld a,(MegaByte)
    rlca
    jr c,PrnMegaPixel ; if the odd bit (using 7-0) is high, then print a char block ''pixel''
    rlca
    ld (MegaByte),a ; save current byte for mega
    jr nc,NoMegaChar ; if the even bit is low, there is nothing printed at this character, leave background
    ld ix,PrintShadowChar ; otherwise, the char needs to be blanked to produce a shadow
    jr SkipPrnMegaPixel
PrnMegaPixel
    rlca ; move bits along, discarding the shadow information
    ld (MegaByte),a ; and store current byte
    ld ix,PrintCompleteChar ; char to be printed is a ''pixel'' of the word mega
SkipPrnMegaPixel
; must print a char for mega word, either shadow or pixel as held in ix
    ld iy,NoMegaChar ; store return address for this part of the routine in iy
    ld a,c ; retreive pointer and convert to a screen address
    and 31
    rlca ; chars are 2 bytes wide, so double the x co-ord
    ld b,a ; converted pointer to x char offset, save in b for now
    ld a,c ; retrieve pointer
    rlca
    rlca
    rlca ; divide by 32
    and 7 ; discard x component
    ld hl,0
    ld de,80
MegaCharPtnLp ; a lazy multiplication, but most it will be is 6
    or a
    jr z,DoneMCharPostn
    add hl,de
    dec a
    jr MegaCharPtnLp
DoneMCharPostn ; hl now holds screen address y offset for current pointer
    ld e,b
    add hl,de ; add x component determined previously
    ld de,80*3+8 ; add additional offset so text is centred on the screen
    add hl,de
    ld de,(base_addr) ; get current screen working address
    ld a,#40
    xor d ; base_addr is the ''hidden'' screen, so invert because
    ld d,a ; need to write to visible screen in this case
    add hl,de
    res 3,h ; correct for screen address reset, finally have screen address to write char to
    jp (ix) ; print a pixel or shadow char
NoMegaChar
; repeat the above process for the hero word, only difference being that the
; word is printed backwards
    ld a,(HeroByte)
    rrca ; shadow bit
    jr c,PrnHeroShadow
    rrca ; pixel bit
    ld (HeroByte),a
    jr nc,NoHeroChar
    ld ix,PrintCompleteChar
    jr SkipPrnHeroShadow
PrnHeroShadow
    rrca
    ld (HeroByte),a
    ld ix,PrintShadowChar
SkipPrnHeroShadow
; must print a char for hero word
    ld iy,NoHeroChar ; store return address for this part of the routine in iy
    ld a,c
    neg
    add a,223
    ld c,a
    and 31
    rlca
    ld b,a
    ld a,c
    rlca
    rlca
    rlca
    and 7
    ld hl,0
    ld de,80
HeroCharPtnLp
    or a
    jr z,DoneHCharPostn
    add hl,de
    dec a
    jr HeroCharPtnLp
DoneHCharPostn
    ld e,b
    add hl,de ; xy offset for from pointer now in hl
    ld de,80*11+8
    add hl,de ; plus offset to centre the word on screen
    ld de,(base_addr)
    ld a,#40
    xor d ; want visible screen
    ld d,a
    add hl,de
    res 3,h ; correct for screen address reset, finally have screen address to write char to
    jp (ix) ; print a pixel or shadow char
NoHeroChar
    ld a,(EndCharPtr) ; retrieve the ptr (=0-223 words are 32*7)
    inc a ; move pointer along
    ld (EndCharPtr),a ; and save new pointer
    cp a,224 ; if havent finished the text yet
    ret nz ; return
    ld hl,CompleteWait
    inc (hl) ; otherwise, set marker to move to next stage of end sequence
    ret    


PrintCompleteChar
; print a character sized ''pixel'' for the word ''mega'' or ''hero''
    push hl
    ld (hl),12
    set 3,h
    ld (hl),72
    set 4,h
    ld (hl),29
    res 3,h
    ld (hl),29
    set 5,h
    ld (hl),12
    set 3,h
    ld (hl),106
    res 4,h
    ld (hl),29
    res 3,h
    ld (hl),29
    pop hl
    inc hl
    res 3,h
    ld (hl),29
    set 3,h
    ld (hl),192
    set 4,h
    ld (hl),106
    res 3,h
    ld (hl),106
    set 5,h
    ld (hl),72
    set 3,h
    ld (hl),192
    res 4,h
    ld (hl),106
    res 3,h
    ld (hl),106
    jp (iy) ; return to calling routine at point defined in iy

PrintShadowChar
; print a character sized shadow for the word ''mega'' or ''hero''
    push hl
    ld (hl),0
    set 3,h
    ld (hl),0
    set 4,h
    ld (hl),0
    res 3,h
    ld (hl),0
    set 5,h
    ld (hl),0
    set 3,h
    ld (hl),0
    res 4,h
    ld (hl),0
    res 3,h
    ld (hl),0
    pop hl
    inc hl
    res 3,h
    ld (hl),0
    set 3,h
    ld (hl),0
    set 4,h
    ld (hl),0
    res 3,h
    ld (hl),0
    set 5,h
    ld (hl),0
    set 3,h
    ld (hl),0
    res 4,h
    ld (hl),0
    res 3,h
    ld (hl),0
    jp (iy) ; return to calling routine at point defined in iy

ClearScr
; A holds #c0 or #40
; clears #4000 bytes starting from base address high byte held in a
    ld h,a
    ld l,0
    ld b,128
    xor a
CSOuterLp
    ld c,128
CSInnerLp
    ld (hl),a
    inc hl
    dec c
    jr nz,CSInnerLp
    dec b
    jr nz,CSOuterLp
    ret

SetColours
; HL points to list, A holds 15 or 3
; sets inks 0-3 or 0-15, working down to 0, so list in HL is in reverse order
    ld b,#7f        ;2
    ld c,(hl)       ;2
    out (c),a       ;4
    out (c),c       ;4
    inc hl          ;2
    or a            ;1
    ret z           ;3
    dec a           ;1
    jr SetColours   ;3


;read "EG_Stars3asm"
ClearStars
; select table of star addresses for high or low screen depending on current
; working screen and point to with hl
    ld a,(base_addr+1)
    bit 6,a
    jr z,StarClearLow
    ld hl,StarsHigh
    jr StarClearSkipLow
StarClearLow
    ld hl,StarsLow
StarClearSkipLow
    ld bc,#a0a ; c = star byte
; there are 10 stars, 5 are displayed dark green, 5 light green
; every 2 frames they are swapped between dark/light green in time with
; h-sync change, which will reduce visible impact of R3 effect on monitors
; that do not shift the screen precisely half a character
    ld a,(scroll_step)
    dec a ; the scroll step is incremented after use in the interupt
    bit 1,a ; so a dec is required to synchronise with R3 change
    jr z,StarClearLp
    ld a,42 ; the byte for light green star is #a, dark green is #20
    xor c
    ld c,a
;
StarClearLp
; get address of star into de
    ld e,(hl)
    inc l
    ld d,(hl)
    inc l ; and point to next star address
    ld a,(de)
    cp a,c ; if it does not contain a star byte
    jr nz,DontClearStar ; then leave it be
    xor a
    ld (de),a ; otherwise clear it
DontClearStar
    ld a,6
    cp a,b ; if not halfway through the stars
    jr nz,StarClrDontInvert ; continue with loop
    ld a,42 ; otherwise invert the star byte in c
    xor c
    ld c,a
StarClrDontInvert
    djnz StarClearLp
    ret

PrintStars
; select table of star addresses for high or low screen depending on current
; working screen and point to with hl
    ld a,(base_addr+1)
    bit 6,a
    jr z,StarPrnLow
    ld hl,StarsHigh
    jr StarPrnSkipLow
StarPrnLow
    ld hl,StarsLow
StarPrnSkipLow
    ld bc,#a0a ; c = star byte
; there are 10 stars, 5 are displayed dark green, 5 light green
; every 2 frames they are swapped between dark/light green in time with
; h-sync change, which will reduce visible impact of R3 effect on monitors
; that do not shift the screen precisely half a character
    ld a,(scroll_step)
    dec a ; the scroll step is incremented after use in the interupt
    bit 1,a ; so a dec is required to synchronise with R3 change
    jr nz,StarPrnLp
    ld a,42 ; the byte for light green star is #a, dark green is #20
    xor c
    ld c,a
;
StarPrnLp
; get address of star into de
    ld e,(hl)
    inc l
    ld d,(hl)
    dec l
; increment the address to move star against the scroll, star will appear static
    inc de
    res 3,d ; ensure star remains on same scan line if crossed address reset point
; write address back to table pointed to by hl
    ld (hl),e
    inc l
    ld (hl),d
    inc l ; and point to next star address
    ld a,(de) ; check byte at current star address
    or a ; if byte is not blank
    jr nz,DontPrnStar ; dont print a star
    ld a,c ; otherwise, put current star byte at address
    ld (de),a
DontPrnStar
    ld a,6
    cp a,b ; if not halfway through the stars
    jr nz,StarPrnDontInvert ; continue with loop
    ld a,42 ; otherwise invert the star byte in c
    xor c
    ld c,a
StarPrnDontInvert
    djnz StarPrnLp
    ret


;read "EG_Interrupts2asm"
; It may be easier to follow the screen splits here by running the game in an
; emulator that allows the highlighting of interrupts, such as WinApe

;;---------
; interrupt entry point
int_start:
push bc
push hl
push af
int_rout_ptr:
jp int_rout1 ; modified to jump to appropriate interrupt

;; interrupt routines for in game split
;;---------
;; first interrupt after vsync
int_rout1:

;; set vsync position to turn it off
ld bc,#bc07
out (c),c
ld bc,#bdff
out (c),c

;; screen address for main part of screen
;; will not trigger until screen restarts

base_main equ $ + 1
ld hl,#2000
ld bc,#bc0c
out (c),c
inc b
out (c),h
dec b:inc c
out (c),c
inc b
out (c),l

;; set height of main part of screen
;; since we are already past the end of the previous screen
;; this will take no effect
ld bc,#bc06
out (c),c
ld bc,#bd00+20
out (c),c
; set next interrupt
ld hl,int_rout2
jp int_end

;;---------
int_rout2:
;; music player handling
push de
exx
ex af,af''
push af
push bc
push de
push hl
push ix
push iy
    ld a,(ChangeMusic)
    or a
    jr z,IR2_JustPlay
    dec a
    jr z,IR2_StartMain
; start end game music
    call Ply_STOP
    ld de,#26d7
    jr IR2_Common
IR2_StartMain
; start in game music
    call Ply_STOP
    ;ld de,#29c3
    ld de,main_sound_track
IR2_Common
    call Ply_INIT
    xor a
    ld (ChangeMusic),a
IR2_JustPlay
    call Ply_PLAY
pop iy
pop ix
pop hl
pop de
pop bc
pop af
ex af,af''
exx
pop de
; set next interrupt
ld hl,int_rout3
jp int_end

;;---------
int_rout3:
;; past start of first screen, set height
ld bc,#bc04
out (c),c
ld bc,#bd00+21
out (c),c
; set next interrupt
ld hl,int_rout4
jp int_end

;;---------
int_rout4:

;; screen address for panel part of screen
;; will not trigger until screen restarts

ld bc,#bc0c
out (c),c
ld bc,#bd00+#10
out (c),c
ld bc,#bc0d
out (c),c
ld bc,#bd00
out (c),c

; set next interrupt
ld hl,int_rout5
jp int_end

;;---------
int_rout5:

;; 2 lines before end of screen, waste some time by reading the key board
push de
call readmatrix
; wait a little longer
ld b,28
int_delay3:
djnz int_delay3
; past playfield screen end, set register 3 for panel
ld hl,#0386
ld b,#bc
out (c),h
inc b
out (c),l

; set colour 13 # 14 for panel
ld bc,#7f0d
out (c),c
ld a,#57
out (c),a
inc c
out (c),c
ld a,#5d
out (c),a

; frame rate is 25hz, so fill some time by clearing the left side of screen in two halves
col_inc equ $ + 1
ld a,0
or a
jr z,col_first
; clear second half
col_next equ $ + 1
ld hl,#c04f
ld b,#0a
call clear_col2
ld b,128+22-64 ;-64 for score display below
jr col_done
; clear first half
col_first
clr_addr equ $ + 1
ld hl,#c04f
ld b,#0a
call clear_col2
ld (col_next),hl
ld a,1
ld (col_inc),a ; set next interrupt to do second half of screen
ld b,128+19-64 ;-64 for score display below
col_done
; delay a bit more, delay set varied by which of two clears above executed
int_delay:
djnz int_delay

; write score to screen, two characters per interrupt
    ld bc,#7fc0         ;3
    out (c),c           ;4
;
    ld a,(ScorePtr)     ;4
    inc a
    and 3             ;2
    ld (ScorePtr),a     ;4
    jr z,IntFormatScore ;2/3
IntPrintScore
; steps 1-3 are to print the 6 characters, 2 each interupt
; find loc and put in de
    ld d,#48            ;2
    rlca                ;1
    ld c,a              ;1
    rlca                ;1
    add a,#5e-4         ;2
    ld e,a              ;1
; get char code
    ld a,c              ;1
    ld h,1              ;2
    add a,#29-2 ; ptr is 2-6 so sub 2 from start ; 2
    ld l,a              ;1
    ld a,(hl)           ;2
    push hl             ;4
    call PrintScoreChar ;92
    res 5,d             ;2
    set 3,d             ;2
    inc e               ;1
    inc e               ;1
    pop hl              ;3
    inc l               ;1
    ld a,(hl)           ;2
    call PrintScoreChar ;92
    jr SkipFmtScore  ;3 total of 219
IntFormatScore
    call CopyScore      ; 225
SkipFmtScore
;
    ld a,(CurrentBank)  ;4
    ld b,#7f            ;2
    out (c),a           ;4

pop de
; now past the beginning of the second screen, the score panel

;; set display height of screen
ld bc,#bc06
out (c),c
ld bc,#bd00+4
out (c),c

;; set height of screen
ld bc,#bc04
out (c),c
ld bc,#bd00+17-1
out (c),c

;; set vsync position
ld bc,#bc07
out (c),c
ld bc,#bd00+10
out (c),c

;; mark new game frame
xor a
ld (int_flag),a
; set next interrupt
ld hl,int_rout6
jp int_end

;;---------
int_rout6:

push de
;; 2 lines before end of screen
; if scroll not zerod in main loop, not ready to display new screen yet, so skip to end
ld hl,scroll
ld a,(hl)
or a
jp z,no_scroll_wait
ld (hl),0         ;4
; work out which of the 4 steps to execute
ld hl,scroll_step ;3
ld a,(hl)         ;2
inc (hl)          ;2
ld hl,(base_main)	; Base always changes ;4
ld de,(clr_addr)                              ;5
and 3             ;3 - 23 to here
jr z,step1        ;2/3
cp 2              ;2
jr z,step3        ;2/3
jr nc,step4       ;2/3
; must be step 2
step2			; Base to #8000, reg 3 to #86
res 4,h            ;2
ld (base_main),hl  ;4
ld a,#86           ;2
ld (reg3),a        ;4
set 6,d            ;2 - set clear address to #c000
ld (clr_addr),de   ;5
xor a              ;1
ld (col_inc),a     ;4 - set column clearing to first half
inc de ;+2 to match step 4
jr MoveResetPoint ;no_scroll       ;3 - 58 for step 2

step3
set 4,h            ; set base to #c000
ld (base_main),hl
ld hl,#51 - #4000 ; set clear address to right side of #8000 screen
add hl,de
res 3,h
ld (clr_addr),hl
xor a
ld (col_inc),a ; set column clearing to first half
inc de
inc de ; +4 to match step 4
jr no_scroll ; as step 1 but extra 4 so 56 nops

step1			;  set base to #c000
set 4,h             ;2
ld (base_main),hl   ;4
ld hl,#800 - #4f - #4000 ;3 - set clear address to left side of #8000 screen
add hl,de                ;3
res 3,h             ;2
ld (clr_addr),hl    ;4
xor a               ;1
ld (col_inc),a      ;4 - set column clearing to first half
inc de
dec de
inc de
dec de ;+8 to match step 4
jr no_scroll        ;3 - 52 for step 1

step4			; Base to #8000 again, increment, reg 3 to #85
res 4,h             ;2
inc hl              ;2
res 2,h             ;2
ld (base_main),hl   ;4
ld a,#85            ;2
ld (reg3),a         ;4
set 6,d             ;2 - set clear address to #c000
ld (clr_addr),de    ;5
xor a               ;1
ld (col_inc),a      ;4 - 60 to here

MoveResetPoint
; keep track of Screen Address Reset point
ld hl,ResetYX+1
dec (hl)
ld a,(hl)
cp a,16
jr nc,no_scroll
ld (hl),79+16
dec l
ld a,(hl)
sub a,8
ld (hl),a
cp a,32
jr nc,no_scroll
ld (hl),232
inc l
ld (hl),47+16

no_scroll
; Best place to do reg 3 change is just after the displayed screen
ld b,14 ; Wait for screen to finish
djnz $
; set reg 3 for playfield
reg3 equ $ + 1
ld de,#0385
ld b,#bc
out (c),d
inc b
out (c),e

pop de

; set colour 13 # 14 for playfield
ld bc,#7f0d
out (c),c
ld a,#46
out (c),a
inc c
out (c),c
ld a,#4e
out (c),a
; back to first interrupt
ld hl,int_rout1
jp int_end
; if not scrolling this screen refresh, wait about 60 nops and go to no scroll
no_scroll_wait
ld b,13
djnz $
nop
jr no_scroll

;;-------------------
; all interrupts exit through this routine
int_end:
ld (int_rout_ptr+1),hl
pop af
pop hl
pop bc
ei
ret

; clear a column of bytes, b holds number of character rows to clear
; hl points to top line of character to start clearing from
clear_col2
xor a
ld de,80 - #2000
clr_lp2
ld (hl),a:set 3,h
ld (hl),a:set 4,h
ld (hl),a:res 3,h
ld (hl),a:set 5,h
ld (hl),a:set 3,h
ld (hl),a:res 4,h
ld (hl),a:res 3,h
ld (hl),a
add hl,de:res 3,h
djnz clr_lp2
ret

; a version of FindNumber8bit (see EG_Display3asm) designed to be used in interrupt
; no matter the number, it is close to the same execution time, 46 or 47 nops
FindNumber2digit
    ld bc,#f6 ; b = 0, c = -10
    add a,c
    jr nc,FiNuEndLoop ; 0
    inc b
    add a,c
    jr nc,FiNuEndLoop ; 1
    inc b
    add a,c
    jr nc,FiNuEndLoop ; 2
    inc b
    add a,c
    jr nc,FiNuEndLoop ; 3
    inc b
    add a,c
    jr nc,FiNuEndLoop ; 4
    inc b
    add a,c
    jr nc,FiNuEndLoop ; 5
    inc b
    add a,c
    jr nc,FiNuEndLoop ; 6
    inc b
    add a,c
    jr nc,FiNuEndLoop ; 7
    inc b
    add a,c
    jr nc,FiNuEndLoop ; 8
    inc b
    ld c,a
; 40 nops for 9
    defs 6
    ret
FiNuEndLoop
    sub a,c
    ld c,a
    ld a,b
    neg
    add a,8
    ret z ; 46 nops for 8
FiNuDelay
    dec a
    jr nz,FiNuDelay ; 47 nops for 0-7
    ret


CopyScore
; copy score for display
    ld hl,ScoreH          ;3
    ld de,ScoreDisplay    ;3
    ldi                   ;5
    ldi                   ;5
    ldi                   ;5

; find characters
    ld de,ScoreDisplay    ; 3
    ld hl,ScoreASC        ; 3
    ld a,(de)             ; 2
    inc e                 ; 1
    call FindNumber2digit ; 8+47
    ld (hl),b             ; 2
    inc l                 ; 1
    ld (hl),c             ; 2
    inc l                 ; 1
    ld a,(de)             ; 2
    inc e                 ; 1
    call FindNumber2digit ; 8+47
    ld (hl),b             ; 2
    inc l                 ; 1
    ld (hl),c             ; 2
    inc l                 ; 1
    ld a,(de)             ; 2
    call FindNumber2digit ; 8+47
    ld (hl),b             ; 2
    inc l                 ; 1
    ld (hl),c             ; 2
    ret
; 31+165+21 = 217 or 3 scan lines or so

;;--------- title screen interrupts -------------------------------------------
int_rout1title:
;; set vsync position to turn it off
ld bc,#bc07
out (c),c
ld bc,#bdff
out (c),c

;; screen address for top scrolling message screen
;; will not trigger until screen restarts
ld hl,(HighZoomScrlOffset)
set 4,h
set 5,h

ld bc,#bc0c
out (c),c
inc b
out (c),h
dec b
inc c
out (c),c
inc b
out (c),l

;; set height of top scrolling message part of screen
;; since we are already past the end of the previous screen
;; this will take no effect
ld bc,#bc06
out (c),c
ld bc,#bd00+7
out (c),c
; set colours for title screen
    ld a,15        ;2
    ld hl,(TitlePalPointer) ;4
    call SetColours ; 369 with call
; set next interrupt
ld hl,int_rout2title
jp int_end

;;---------
int_rout2title:
; music player handling
push de
exx
ex af,af''
push af
push bc
push de
push hl
push ix
push iy
; check if music needs to change
    ld a,(ChangeMusic)
    or a
    jr z,IR2T_JustPlay ; continue current music
    dec a
    jr z,IR2T_StartMain
; start end game music
    call Ply_STOP
    ld de,#26d7
    jr IR2T_Common
IR2T_StartMain
    call Ply_STOP
    ;ld de,#29c3
    ld de,main_sound_track
IR2T_Common
    call Ply_INIT
    xor a
    ld (ChangeMusic),a
IR2T_JustPlay
    call Ply_PLAY
pop iy
pop ix
pop hl
pop de
pop bc
pop af
ex af,af''
exx
pop de
; set next interrupt
ld hl,int_rout3title
jp int_end

;;---------
int_rout3title:

;; past start of first screen, set height
ld bc,#bc04
out (c),c
ld bc,#bd00+7-1
out (c),c

; set address for next screen, wont trigger until next screen starts
ld bc,#bc0c
out (c),c
ld bc,#bd00+#12
out (c),c

ld bc,#bc0d
out (c),c
ld bc,#bd00+#e8
out (c),c
; want to wait until after next screen starts, and display colours for top
; raster colour cycled font
ld b,34+64+79 ; wait until  at top line of character line with font
int_delay2title:
djnz int_delay2title
; work out where in the colour cycle list to get colours from
ld a,(TitleRasterOS)
inc a
ld (TitleRasterOS),a
and #1e
ld c,a
ld b,0
ld hl,(TitleRasterPtr)
add hl,bc
call TitleRaster ; set the colours for the next 9 scan lines

; past start of second screen
;; set display height of screen
ld bc,#bc06
out (c),c
ld bc,#bd00+7
out (c),c

;; set height of screen
ld bc,#bc04
out (c),c
ld bc,#bd00+7-1
out (c),c

; set next interrupt
ld hl,int_rout4title
jp int_end

;;---------
int_rout4title:
;; screen address for bottom scrolling message screen
;; will not trigger until next screen starts
ld hl,(LowZoomScrlOffset)
set 5,h

ld bc,#bc0c
out (c),c
inc b
out (c),h
dec b
inc c
out (c),c
inc b
out (c),l

; near end of current screen, perform raster oolour cycling for bottom
; line of text in credits section

; wait until at top of text
ld b,5
int_delay3title:
djnz int_delay3title
; work out where in the colour cycle list to get colours from
ld a,(TitleRasterOS)
and #1e
neg
add a,30
ld c,a
ld b,0
ld hl,(TitleRasterPtr)
add hl,bc
call TitleRaster ; set the colours for the next 9 scan lines
; wait another scan line
ld b,16
int_delay3title2:
djnz int_delay3title2

; now past the beginning of the next screen
;; set display height of screen
ld bc,#bc06
out (c),c
ld bc,#bd00+7
out (c),c

;; set height of screen
ld bc,#bc04
out (c),c
ld bc,#bd00+8-1
out (c),c
; set next interrupt
ld hl,int_rout5title
jp int_end

;;---------
int_rout5title:
; set address for next screen (score panel), wont trigger until next screen starts
ld bc,#bc0c
out (c),c
ld bc,#bd00+#18
out (c),c
ld bc,#bc0d
out (c),c
ld bc,#bd00
out (c),c

; need to fill some time, read keys
push de
call readmatrix ; 292+5
pop de

; wait for current screen to end
;; 128 cycles
ld b,152
int_delaytitle:
djnz int_delaytitle

; set colours for score panel
    ld a,15        ;2
    ld hl,Mode0Pal ;3
    call SetColours ; 369 with call

; wait until fourth screen starts
ld b,128-89
int_delaybtitle:
djnz int_delaybtitle

; fourth and final screen has started, set up height
;; set display height of screen
ld bc,#bc06
out (c),c
ld bc,#bd00+4
out (c),c

;; set height of screen
ld bc,#bc04
out (c),c
ld bc,#bd00+17-1
out (c),c

;; set vsync position
ld bc,#bc07
out (c),c
ld bc,#bd00+10
out (c),c

;; mark new frame
xor a
ld (int_flag),a

; set next interrupt
ld hl,int_rout6title
jp int_end

;;---------
int_rout6title:
; back to first interrupt
ld hl,int_rout1title
jp int_end

TitleRaster
; hl points to list of colours
    push de
    ld bc,#7f0d ; changing colour 13 # 14, starting with 13
    ld a,9 ; change the two colours over 9 scan lines
TitleRasterLp
    ld d,(hl)
    inc hl
    ld e,(hl)
    inc hl
    out (c),c
    out (c),e
    inc c
    out (c),c
    out (c),d
    dec c
    ld e,8 ; pad out loop to be 64 nops, or 1 scan line, long
TitleRastDelay
    dec e
    jr nz,TitleRastDelay
    nop
    dec a
    jr nz,TitleRasterLp
    pop de
    ret


;read "EG_Collision5asm"
CheckBackgrounds2
; check if centre (horizontal length) of player bullet is over any background
    ld a,(base_addr+1)
    bit 6,a
    jr z,ChkBG2Low
    ld hl,SpriteAddrHigh+154+6
    jr ChkBG2SkipLow
ChkBG2Low
    ld hl,SpriteAddrLow+154+6
    nop
    nop
ChkBG2SkipLow
; have got hl pointing to the screen address list for the middle of the bullet
; read the addresses and check the contents of the bytes at ends # centre of
; the sprite
    ld e,(hl)  ;5
    inc l
    ld d,(hl)  ;5
    inc l
    ex de,hl
    res 3,h      ;2
    ld a,(hl)    ;2
    inc hl       ;2
    res 3,h      ;2
    inc hl       ;2
    res 3,h      ;2
    or (hl)    ;2
    inc hl       ;2
    res 3,h      ;2
    or (hl)    ;2
    inc hl       ;2
    res 3,h      ;2
    inc hl       ;2
    res 3,h      ;2
    or (hl)    ;2
    ex de,hl
; ; read second address from centre of sprite and repeat process
    ld e,(hl)
    inc l
    ld d,(hl)
    ex de,hl
    or (hl)
    res 3,h      ;2
    or (hl)    ;2
    inc hl       ;2
    res 3,h      ;2
    inc hl       ;2
    res 3,h      ;2
    or (hl)    ;2
    inc hl       ;2
    res 3,h      ;2
    or (hl)    ;2
    inc hl       ;2
    res 3,h      ;2
    inc hl       ;2
    res 3,h      ;2
    or (hl)    ;2
    jr z,CheckBG2Player ; bullet still in play, check player
; if contents not zero, at least one byte hit, must now set bullet co-ords off screen
; along with resetting the screen address list due to the background collision
    ld bc,(base_addr)
    ld hl,#640
    add hl,bc
    set 3,h
    ex de,hl
; de now loaded with base dummy address
; set hl to beginning of address list for the bullet
    ld a,-9
    add a,l
    ld l,a
    ld b,8 ; for each of the 8 addresses, load the offscreen dummy address
ChkBG2ClrLp
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    djnz ChkBG2ClrLp
; now reset co-ords
    ld hl,SpritesYX+15
    ld (hl),192
    dec l
    ld (hl),0
CheckBG2Player
; two checks to do, centre for player kill, and edge for grinding bonus
; player kill collision check
; set the high or low screen address pointer according to frame in use
    ld a,(base_addr+1)
    bit 6,a
    jr z,PlyCollLow
    ld ix,SpriteAddrHigh+132+6 ; top of centre for kill check
    ld de,SpriteAddrHigh+132 ; sprite top for top grind check
    jr PlyColSkipLow
PlyCollLow
    ld ix,SpriteAddrLow+132+6 ; top of centre for kill check
    ld de,SpriteAddrLow+132+20 ; sprite bottom for bottom grind check
PlyColSkipLow
    ld a,(Shield)
    rlca
    ret c ; if game over or game complete (bit 7 of shield high), abort all checks
    or a
    jr nz,PlyColGrind ; if shield otherwise non-zero, skip kill check
    ld c,0 ; square in centre of player sprite is checked at all 4 corners
    ld l,(ix+0)
    ld h,(ix+1)
    res 3,h
    inc hl
    res 3,h
    inc hl
    res 3,h
    ld a,(hl)
    inc hl
    res 3,h
    or (hl)
    jr z,PlyColNoColHigh
    inc c
PlyColNoColHigh
    ld l,(ix+6)
    ld h,(ix+7)
    res 3,h
    inc hl
    res 3,h
    inc hl
    res 3,h
    ld a,(hl)
    inc hl
    res 3,h
    or (hl)
    jr z,PlyColNoColLow
    inc c
PlyColNoColLow
    ld a,2
    cp a,c ; if both top # bottom of sentre square has a collision
    jr z,PlayColFatal ; consider player to have had fatal collision
PlyColGrind
; now do player grinding check
; depending on frame, this will either be top or bottom of sprite edge,
; but not both in one game frame
    ex de,hl
    ld e,(hl)
    inc l
    ld d,(hl)
    ex de,hl
    res 3,h
    ld a,(hl)
    inc hl
    res 3,h
    inc hl
    res 3,h
    ld a,(hl)
    inc hl
    res 3,h
    or (hl)
    inc hl
    res 3,h
    inc hl
    res 3,h
    ld a,(hl)
    ret z
; player is grinding, add score
    ld a,(ScoreFrame+1)
    add a,25
    ld (ScoreFrame+1),a
    ld a,2 ; grind state means animation for grinding continues every frame even though
    ld (GrindState),a ; top and bottom of sprite are checked on alternate frames
    ret

PlayColFatal ; also used by player sprite collision
    ld hl,Lives
    ld c,50 ; 2 seconds for shield after life loss
    dec (hl)
    ld a,(hl)
    or a
    jr nz,ContinuePlay ; if lives still above zero
    ld c,128+100 ; else trigger game over and 4 second wait instead
ContinuePlay
    inc l
    ld (hl),c
    inc l
    inc (hl) ; next frame, convert enemy sprites to explosion (trigger by non zero value)
; this is delayed so screen addresses dont need rewriting for all 6 sprites in this frame
    ret

CheckScreenReset
; check the player sprite and 6 enemy sprites against the x,y location of the screen
; address reset position  Set a bit in c if necessary so that ''safe'' save and restore
; background routines are used  The bullet is always handled ''safely'' simply because
; it is a different size and the saving would be in my view too minimal to warrant
; the additional code (in a larger game, at least)
    exx
    ld a,(base_addr+1)
    bit 6,a
    jr z,ChkSRLow
    ld hl,ResetHigh
    jr ChkSRSkipLow
ChkSRLow
    ld hl,ResetLow
    nop
    nop
ChkSRSkipLow
    exx
    ld c,0
    ld hl,ResetYX
    ld a,(hl)
    sub a,20
    ld d,a
    inc l
    ld a,(hl)
; dont check if YX reset point on screen edge, cant be crossed by any sprite
    cp a,16 ; screen left edge is x co-ord 16
    jr z,CSRAllClear
    sub a,6 ; subtract sprite width off location for check
    ld e,a
;ColSwimYXInsert
    ld hl,SpritesYX+13
;ColSwimbInsert
    ld b,7
ChkSRloop
    sla c ; shift current collsion bits along
    ld a,(hl) ; get sprite x co-ord
    dec l
; if sprite is partially or fully offscreen, default to safe method
; this is because the screen co-ords dont match the addresses generated in this
; case (see CalcSprites for reason why)
    cp a,16
    jr c,CSRSafe
    cp a,73+16
    jr nc,CSRSafe
; sprite not on screen edge or offscreen, so check if sprite overlaps screen address
; reset location
    sub a,e
    jr c,CSNoColl
    cp a,6
    jr nc,CSNoColl
    ld a,(hl)
    sub a,d
    jr c,CSNoColl
    cp a,28
    jr nc,CSNoColl
; if reached here, collision with reset point occured, so mark sprite as requiring
; the ''safe'' version of background save # restore
CSRSafe
    set 0,c

CSNoColl
    dec l
    djnz ChkSRloop
CSRAllClear
    ld a,c
    exx
    ld (hl),a ; write collision byte for current frame
    exx
    ret

BulletCollision
; check player bullet against enemy sprites
; start with checking player bullet
    ld hl,SpritesYX+15
    ld a,(hl)
; dont check if shot off screen
    bit 7,a
    ret nz ; abort if bullet off screen
; get bullet co-ordinates and adjust according to dimensions of enemy sprites
    sub a,5 ; if enemy sprite x co-ord is less than 6 lower than bullet, there is a hit
    ld e,a ; put adjusted x co-ord into e
    dec l
    ld a,(hl) ; get bullet y co-ord
    sub a,20 ; as for x, if sprite y co-ord is less than 21 lower than bullet, it hits
    ld d,a ; put adjusted y co-ord into d
    dec l
    dec l ; pass over player xy co-ords
    dec l
    ld b,6 ; check 6 enemy sprites xy co-ords, pointed to by hl
ColShotSloop
    ld a,(hl) ; get sprite x pos into a
    dec l ; point hl to sprite y
    sub a,e ; sub adjusted bullet x pos
    jr c,CSSNoColl ; if still carry, sprite x too far left for hit
    cp a,11 ; compare with 11 - bullet width + the 5 subtracted from it previously
    jr nc,CSSNoColl ; if sprite x still higher, is too far right for hit
    ld a,(hl) ; get sprite y
    sub a,d ; sub adjusted bullet y pos
    jr c,CSSNoColl ; if still carry, sprite y too far above for hit
    cp a,36 ; compare with 36 - bullet height + the 20 subtracted from it previously
    jr c,ShotHit ; if sprite y lower than 36, bullet has hit, handle
; not hit otherwise
CSSNoColl
    dec l ; move to next sprite x co-ord
    djnz ColShotSloop ; and check next sprite
    ret

PlayerCollision
; check player against sprites
    ld a,(Shield)
    or a
    ret nz ; if player has non zero shield value, abort check
; get player co-ordinates and adjust according to dimensions of enemy sprites
; process is same as for bullet above, except as noted below
    ld hl,SpritesYX+13
    ld a,(hl)
    sub a,4 ; player has a byte width of overlap with sprites in x that is safe
    ld e,a
    dec l
    ld a,(hl)
    sub a,16 ; player has a 4 bytes height of overlap with sprites in y that is safe
    ld d,a
    dec l ; hl now points to 6th enemy sprite
    ld b,6
ColPlyCloop
; following process identical to bullet check, except for overlap
    ld a,(hl)
    dec l
    sub a,e
    jr c,CPCNoColl
    cp a,9 ; 9 is sprite width -1 for over lap, plus the 4 subracted above, giving
    jr nc,CPCNoColl ; overlap for both sides
    ld a,(hl)
    sub a,d
    jr c,CPCNoColl
    cp a,33 ; 33 is sprite height -4 for over lap, plus the 16 subracted above, giving
    jr c,PlyCollision ; overlap for both above and below the player
; player OK if here
CPCNoColl
    dec l ; move to next sprite x co-ord
    djnz ColPlyCloop ; and check next sprite
    ret

ShotHit
; if bullet has hit sprite, find entry in SpriteData table from value in b
    ld a,b
; swap to alternate registers in case hit was with explosion and collsion checks
; need to continue
    exx
    rlca ; x2
    rlca ; x4
    rlca ; SpriteData is 8 bytes long
    add a,#60+5-8 ; and starts at #60, while b=1-6 so -8 is applied, +5 is animation entry
    ld l,a
    ld h,0 ; hl points to SpriteData for sprite hit, animation entry
    ld a,(hl)
    exx ; swap to primary registers in case collison checks need to continue
    bit 5,a ; indicates if sprite is explosion
    jr nz,CSSNoColl ; if bit set, have hit an explosion, check rest of sprites
; if here, must remove shot and deal with impact on enemy
    exx ; return to SpriteData table
    inc l
    inc l ; got to entry at +7, this holds enemy sprite shield value
    ld a,(hl)
    dec a
    jr z,ShotHDestroy ; if no hits left, turn enemy into explosion
; not destroyed yet, so reduce hits, remove shot and add chipping score
    ld (hl),a ; store new shield value
    dec l
    dec l ; back to animation byte at +5 in SpriteData
    set 4,(hl) ; tells sprite print routine to use strobe frame for this sprite
    exx ; done with SpriteData table
    ld a,40 ; add chipping score
    ld hl,ScoreFrame+1
    jr ShotRemove ; skip to removing the bullet
ShotHDestroy
; enemy becomes explosion
    dec l ; go to +6 in SpriteData, which is sprite animation data
    xor a
    ld (hl),a ; clear the animation data
    dec l
    ld (hl),32 ; set animation type to 0 (explosion), offset to 0, bit 5 on to indicate explosion
    dec l
    ld (hl),a ; explosion starts at frame 0 in sprite table
    dec l
    ld (hl),a ; set animation timer to 0
    dec l
    ld (hl),a ; set rocker to 0
    dec l
    ld (hl),64+2 ; set move 2 to stationary
    dec l
    ld (hl),64+2 ; set move 1 to stationary
    exx
    ld a,4 ; add destruction score - 400
    ld hl,ScoreFrame
ShotRemove
    ld (hl),a ; put destruction or chipping score in hl
    ld hl,SpritesYX+14 ; point to bullet y co-ord
    ld (hl),0 ; set y to 0
    inc l ; point to bullet x co-ord
    ld (hl),192 ; set to 192
    ret

PlyCollision
; if palyer has hit sprite, find entry in SpriteData table from value in b
    ld a,b
; swap to alternate registers in case hit was with explosion and collsion checks
; need to continue
    exx
    rlca ; x2
    rlca ; x4
    rlca ; SpriteData is 8 bytes long
    add a,#60+5-8 ; and starts at #60, while b=1-6 so -8 is applied, +5 is animation entry
    ld l,a
    ld h,0 ; hl points to SpriteData for sprite hit, animation entry
    ld a,(hl)
    exx ; swap to primary registers in case collison checks need to continue
    bit 5,a ; indicates if sprite is explosion
    jr nz,CPCNoColl ; if bit set, have hit an explosion, check rest of sprites
    jp PlayColFatal ; player hit sprite, reduce lives and trigger explosion

InterimBulletCollision
; do interim background collision check
; in this case, screen address for bullet has not yet been calculated
; so first, must determine screen address for interim background collision check
    ld hl,SpritesYX+15
    ld a,(hl)
; dont check if shot off screen
    bit 7,a
    ret nz ; abort if bullet off screen
    sub a,16-5 ;; -5: want leading edge of bullet sprite in this case
    jr nc,IBCCalcSprBNotLeft
    xor a ; should occur, but make sure bullet is not past left edge
IBCCalcSprBNotLeft
    cp a,73+5
    jr c,IBCCalcSprBNotRight
    ld a,72+5 ; ensure screen address is no further right than right most screen edge
IBCCalcSprBNotRight
    dec l
    ex af,af''
    ld a,(hl)
    add a,6+1 ; point in the middle of bullet sprite (horizontally)
    ld h,#42
    ld l,a ; point hl to address look up table for screen addresses
    ex af,af''
    ld bc,(base_addr) ; get scroll offset and add sprite offset
    add a,c
    ld c,a
    jr nc,IBCCaSprDontIncDPBul
    inc b
IBCCaSprDontIncDPBul
; get address from table location pointed to by hl into de and apply offset in bc
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a ; base address read from table and scroll # sprite offset now applied
; now check background  For the interim check, only checking one byte of leading edge
; as the bullet is not actually printed here, and the background is ''thick'' enough that
; this one test ensures the bullet will not pass through anything
    ld a,(de)
    or a
    ret z ; if byte clear, bullet can continue
    ld hl,SpritesYX+14 ; otherwise, set it off screen
    ld (hl),0
    inc l
    ld (hl),192
    ret

; when the player explodes the 6 enemy sprites are set up as explosions
; by doing this before screen addresses are calculated the addresses are determined
; as normal in CalcSprites, reducing the additional code executed to when the player
; loses a life
SetExplosion
    xor a
    ld (ExplosionSet),a ; clear the explosion trigger
    ld hl,SpritesYX+13 ; get the players current xy co-ords for start position
    ld d,(hl)
    dec l
    ld e,(hl)
    dec l ; hl now points to x co-ord of 6th sprite
    ld b,6
SetExCoordLp ; make all 6 sprites share player current co-ords
    ld (hl),d
    dec l
    ld (hl),e
    dec l
    djnz SetExCoordLp
    ld hl,ExplosionList ; hl = move list so explosions move in different directions
    ld de,SpriteData ; de = beginning of move and animation data table
    xor a
    ld bc,#6ff
SetExSDLp
    ldi ; write move 1
    ldi ; write move 2
    ld (de),a ; write rocker
    inc e
    ld (de),a ; write timer
    inc e
    ld (de),a ; write base sprite frame
    inc e
    ex de,hl
    ld (hl),32 ; write animation type/current frame offset
    ex de,hl
    inc e
    ld (de),a ; unused in explosion
    inc e
    ld (de),a ; no hits
    inc e
    djnz SetExSDLp
    ret

; list of directions for the 6 sprites used when player ''explodes''
ExplosionList
    defb 64+0,64+0
    defb 32+0,32+0
    defb 32+3,32+3
    defb 96+4,96+4
    defb 128+2,128+2
    defb 128+1,128+1


;read "EG_Animateasm"
; animate sprites called every other frame from main loop
AnimateSprites
; increment player frame, and restrict to 0-6
    ld hl,PlayerFrame
    ld a,(hl)
    inc a
    cp a,7
    jr c,ResetPlayerFrame
    xor a
ResetPlayerFrame
    ld (hl),a
; animate enemy sprites
    ld hl,SpriteData+5
    ld de,SpritesYX+1
    ld b,6 ; 6 enemy sprites to animate
AnmEnemyLp
    ld a,(de)
    rla ; if x coord 128 or higher, sprite off screen, so
    jr c,AnmEnemyReturn ; skip this sprite
    ld a,(hl) ; get animation byte/offset byte from SpriteData
    ld c,a ; save byte for retrieval later
    rlca
    rlca
    and 3 ; mask out current frame, and continue based on animation type
    jr z,AEExplosion
    dec a
    jr z,AECycle
    dec a
    jr z,AEYoYo6
; if not those 3, must be YoYo5 (5 frame up then down animation cycle)
    ld a,c ; get byte from table back
    and 15 ; get current frame
    inc l
    add a,(hl) ; add current direction (+1 or -1)
    jr z,AEYoYo5Invert ; if new frame is 0
    cp a,4
    jr nz,AEYoYo5NoInvert ; or new frame is 4
AEYoYo5Invert ; then dont invert the animation direction byte
    ld c,a ; save new frame pointer
    ld a,#fe
    xor (hl) ; swap -1 to +1 or vice versa
    ld (hl),a
    ld a,c ; retrieve frame pointer
AEYoYo5NoInvert
    dec l
    or 128+64 ; put the animation type back in the byte
    ld (hl),a ; and write back to table
AnmEnemyReturn ; common reentry point for other animation types
; move de and hl to point to next SpriteYX/SpriteData entry
    inc e
    inc e
    ld a,8
    add a,l
    ld l,a
    djnz AnmEnemyLp
    ret
AECycle ; cycle frame up to specified maximum # reset
    ld a,c ; get byte from table back
    and 15 ; get current frame
    inc a ; increment the current frame
    inc l
    ld c,(hl) ; get maximum frame into c
    dec l
    cp a,c
    jr c,AECycleNoReset ; if current frame exceeds maximum
    xor a ; reset current frame to 0
AECycleNoReset
    or 64 ; put the animation type back in the byte
    ld (hl),a ; and write back to table
    jr AnmEnemyReturn
AEYoYo6 ; 6 frame up then down animation cycle
    ld a,c ; get byte from table back
    and 15 ; get current frame
    inc l
    add a,(hl) ; add current direction (+1 or -1)
    jr z,AEYoYo6Invert ; if new frame is 0
    cp a,5
    jr nz,AEYoYo6NoInvert ; or new frame is 5
AEYoYo6Invert ; then dont invert the animation direction byte
    ld c,a ; save new frame pointer
    ld a,#fe
    xor (hl) ; swap -1 to +1 or vice versa
    ld (hl),a
    ld a,c ; retrieve new frame pointer
AEYoYo6NoInvert
    dec l
    or 128 ; put the animation type back in the byte
    ld (hl),a ; and write back to table
    jr AnmEnemyReturn
AEExplosion ; explosions are a special animation type
    ld a,c ; get byte from table back
    and 15 ; get current frame
    inc a ; increment the current frame
    cp a,10 ; check to see if exceeded last frame
    jr nc,AEExpComplete ; if so, remove sprite
    set 5,a ; animation type is 0, but bit 5 represents ''transparent'' to collision code
    ld (hl),a ; and write back to table
    jr AnmEnemyReturn
AEExpComplete ; to remove the sprite, the coordinates just need to be set offscreen
    ex de,hl
    ld (hl),128 ; x= 128
    dec l
    ld (hl),0 ; y = 0
    inc l
    ex de,hl
    jr AnmEnemyReturn


;read "EG_Zoomasm"
; WriteZSColumn called once per frame from the menu, and prints one character column for
; the two zoomed scrollers

WriteZSColumn
    ld hl,(ZSCharPtr) ; pointer to msg text starting at label ZoomScrollMsg
    ld a,(ZSCharCol) ; 0-7, column number of pixels to print this frame
    inc a
    and 7
    ld (ZSCharCol),a
    jr nz,WrZSNoNewChar ; if back to column zero, start a new character
    inc hl
    bit 7,(hl)
    jr z,NoMsgReset
    ld hl,ZoomScrollMsg ; if bit 7 of new character is high, restart msg
NoMsgReset
    ld (ZSCharPtr),hl
WrZSNoNewChar
    ld c,a
    ld a,(hl)
    sub a,65
    jr nc,NotSpace
    ld a,31 ; for space, point to last character in ZSfont, which is blank
NotSpace
    rlca
    rlca
    rlca ; mulitply character no by 8
    add a,c ; and add current column
    ld l,a
    ld h,#44 ; font occupies #4400 in base ram
    ld a,(hl) ; a contains bit list for this column of char
    ld c,a ; preserve char column for second print
; now get # set new column offset for top scroll which is going backwards
    ld hl,(HighZoomScrlOffset) ; #c000
    dec hl
    bit 2,h ; this offset is the crtc offset, so should be 0-#3ff
    jr z,DontResetHighZSAddr
    ld h,#3 ; if it became #ffff, set to #3ff
DontResetHighZSAddr
    ld (HighZoomScrlOffset),hl
    add hl,hl
    set 7,h ; high scroller is at #c000
    set 6,h
    ld iy,HighColumnReturn
    ld b,7
HighColZSLp
    rra ; scroll text is upside down, rla used for bottom scroller
    jr c,DrawZSChar
    jr DrawZSBlank
HighColumnReturn
    djnz HighColZSLp
; now do low Zoom Scroller
    ld a,c ; recover column byte from c and repeat for low scroller
    ld hl,(LowZoomScrlOffset) ; #8000
    inc hl
    res 2,h ; limit range to 0-#3ff
    ld (LowZoomScrlOffset),hl
    add hl,hl
    ld de,#804e ; scroll is going left, so print on right side
    add hl,de
    res 3,h ; ensure start screen address range is #8000-#87fe
    ld iy,LowColumnReturn
    ld b,7
LowColZSLp
    rla
    jr c,DrawZSChar
    jr DrawZSBlank
LowColumnReturn
    djnz LowColZSLp
    ret

DrawZSChar ; draw visible character
ld de,80 - #2000
ld (hl),3:inc l:ld (hl),22:set 3,h
ld (hl),12:dec l:ld (hl),6:set 4,h
ld (hl),22:inc l:ld (hl),44:res 3,h
ld (hl),44:dec l:ld (hl),22:set 5,h
ld (hl),3:inc l:ld (hl),6:set 3,h
ld (hl),12:dec l:ld (hl),44:res 4,h
ld (hl),22:inc l:ld (hl),44:res 3,h
ld (hl),44:dec l:ld (hl),22
add hl,de:res 3,h
jp (iy)

DrawZSBlank ; clear current character
ex af,af''
xor a
ld de,80 - #2000
ld (hl),a:inc l:ld (hl),a:set 3,h
ld (hl),a:dec l:ld (hl),a:set 4,h
ld (hl),a:inc l:ld (hl),a:res 3,h
ld (hl),a:dec l:ld (hl),a:set 5,h
ld (hl),a:inc l:ld (hl),a:set 3,h
ld (hl),a:dec l:ld (hl),a:res 4,h
ld (hl),a:inc l:ld (hl),a:res 3,h
ld (hl),a:dec l:ld (hl),a
add hl,de:res 3,h
ex af,af''
jp (iy)


;read "EG_Move3asm"
MoveSprites
    call ReadJoystick
    ld de,SpritesYXMv+#f
    ld hl,SpritesYX+#f
; player bullet move
    bit 7,(hl) ; check if bullet on screen
    jr z,MSMoveBullet
; if bullet off screen, check fire pressed
    ld a,(de)
    bit 4,a
    jr z,MSFireNotPressed
; if fire pressed, check game state
; ordinarily firing would be handled seperately to movement, but for this
; simple example there is only one player bullet allowed, so have checked it here
    ld a,(Shield)
    rla
    jr c,MSFireNotPressed ; no firing when game over
; now OK to create bullet
    ld a,(SpritesYX+12)
    add a,2
    ld (SpritesYX+14),a
    ld a,(SpritesYX+13)
    jr MSSkipBulletRemove
MSMoveBullet
    ld a,(hl)
    add a,6
    cp a,78+16 ; check if bullet moved off screen
    jr c,MSSkipBulletRemove
    dec l
    ld (hl),0
    inc l
    ld a,192
MSSkipBulletRemove
    ld (hl),a
MSFireNotPressed
; point de and hl to player co-ords # move
    dec e
    dec e
    dec l
    dec l
; now do player move
    ld a,(Shield)
    bit 7,a
    jr z,MSDoPlayer ; game not over or complete
    dec e
    dec e
    dec l
    dec l
    jr MSEnemySprites
MSDoPlayer
    ld a,(de)
    add a,(hl)
; keep player x co-ord in range
    cp a,16
    jr c,MSCancelXMv
    cp a,72+16
    jr nc,MSCancelXMv
    ld (hl),a
MSCancelXMv
    dec l
    dec e
    ld a,(de)
    add a,(hl)
; keep player y co-ord in range
    cp a,32
    jr c,MSCancelYMv
    cp a,174
    jr nc,MSCancelYMv
    ld (hl),a
MSCancelYMv
    dec l
    dec e
; finally move enemy sprites
MSEnemySprites
    ld de,SpriteData+48-5 ; point to sprite 6 timer reset value
    ld b,6
MvEnemySprLp
    bit 7,(hl) ; check if sprite on screen
    jr nz,MvEnemyBSkipThisSprite
    set 4,l ; go to SpriteYXMv where move timer is stored
    ld c,(hl)
    inc c
    inc c ; twice, because 25hz rather than 50
    ld a,(de)
    cp a,c
;    jr nz,DontResetMoveTimer
    jr nc,DontResetMoveTimer
    ld c,0
DontResetMoveTimer
    ld (hl),c
    res 4,l ; set hl back to YX co-ords of sprite, c contains timer
    dec e ; point de to sprite rocker value
    ld a,(de)
    dec e ; point de to move 2
    cp a,c
; if the counter is above the rocker, process move 2, else use move 1
;
    jr c,MvEnemyMove2
    dec e ; point to move 1
    ld a,(de) ; get move 1 byte
    jr SkipEnemyMv2
MvEnemyMove2
    ld a,(de) ; get move 2 byte
    dec e ; move de along to move 1
SkipEnemyMv2
    ld c,a ; put move byte in c
; move is stored in byte y,x with 5 bits for y and 3 for x
; do x move first, range of move is 2,1,0,-1,-2
    and #7
    sub a,2
    add a,(hl) ; add current sprite x co-ord
    ld (hl),a ; and save back
    dec l ; move to y co-ord
; check sprite has not moved out of bounds
    cp a,16-5
    jr c,MvRemoveSprite
    cp a,78+16+8
    jr nc,MvRemoveSprite
; now do y move, range of move is 8,4,0,-4,-8
    ld a,c
    and #f8
    rrca
    rrca
    rrca
    sub a,8
    add a,(hl) ; add current sprite x co-ord
    ld (hl),a ; and save back
; check sprite has not moved out of bounds
    cp a,2 ;12
    jr c,MvRemoveSprite
    cp a,192
    jr nc,MvRemoveSprite
MvEnemySprRet
    dec l
    ld a,-5 ; point de to next sprites timer reset value
    add a,e
    ld e,a
    djnz MvEnemySprLp
    ret

; to skip sprite, just move pointers along
MvEnemyBSkipThisSprite
    dec e
    dec e
    dec e
    dec l
    jr MvEnemySprRet

; simply set sprite offscreen to mark as free and prevent
; unneccesary processing
MvRemoveSprite
    ld (hl),0
    inc l
    ld (hl),128
    dec l
    jr MvEnemySprRet

; secondary bullet move for frame, player bullet is moved twice per frame
; because high speed would otherwise result in requirement for a long hit box tail,
; where unpredictable sprite id order could see bullet hit sprites behind other
; sprites when close together
InterimBulletMove
    ld hl,SpritesYX+#f
; player bullet move
    bit 7,(hl)
    ret nz ; for interim move, dont need to check fire pressed, quit if bullet off screen
    ld a,(hl)
    add a,6
    cp a,78+16
    jr c,IBMSkipBulletRemove
    dec l
    ld (hl),0
    inc l
    ld a,192
IBMSkipBulletRemove
    ld (hl),a
    ret

ReadJoystick
; keys are scanned under interrupt, check key table for input from
; joystick first, or qaop if not, or cursor keys if not those
; check joystick as first preference
    ld a,(KBmatrixbuf+9)
    and 31             ;2
    jr nz,InputReceived  ;2/3
    ld e,a               ;1
; keyboard control
    ld a,(KBmatrixbuf+8) ;4
    bit 3,a              ;2
    jr z,RdJoyNotQ       ;2/3
    set 0,e              ;2
RdJoyNotQ
    bit 5,a              ;2
    jr z,RdJoyNotA       ;2/3
    set 1,e              ;2
RdJoyNotA
    ld hl,KBmatrixbuf+4  ;3
    bit 2,(hl)           ;3
    jr z,RdJoyNotO       ;2/3
    set 2,e              ;2
RdJoyNotO
    dec l         ;1
    ld a,8        ;2
    and (hl)    ;2
    or e        ;1 ; want end product in a
    jr nz,RdJoyCheckSpace ;2/3
; end keyboard read, check cursor if none of qaop pressed
UseCursor ;
    ld hl,KBmatrixbuf+1 ;3
    bit 0,(hl)          ;2
    jr z,RdJoyNotCurL   ;2/3
    set 2,e             ;2
RdJoyNotCurL
;    dec hl
    dec l               ;1
    bit 2,(hl)          ;2
    jr z,RdJoyNotCurD   ;2/3
    set 1,e             ;2
RdJoyNotCurD
    bit 1,(hl)          ;2
    jr z,RdJoyNotCurR   ;2/3
    set 3,e             ;2
RdJoyNotCurR
    ld a,1        ;2
    and (hl)    ;2
    or e        ;1 ; want end product in a
; end cursor read
RdJoyCheckSpace
    ld hl,KBmatrixbuf+5  ;3
    bit 7,(hl)           ;3
    jr z,InputReceived   ;2/3
    set 4,a              ;2
InputReceived ; at this point, have got what input there is, if any
; translate input to player sprite movement
    ld hl,KeyInY ; point to player y move
    ld c,0
    ld (hl),c ; zero input
    bit 0,a
    jr z,RdJySkipYUp
PlayerMoveUpStep
    ld (hl),252
    jr RdJySkipYDn
RdJySkipYUp
    bit 1,a
    jr z,RdJySkipYDn
PlayerMoveDownStep
    ld (hl),4
RdJySkipYDn
    inc l ; point to player x move
    ld (hl),c
    bit 2,a
    jr z,RdJySkipXLe
    ld (hl),255
    jr RdJySkipXRi
RdJySkipXLe
    bit 3,a
    jr z,RdJySkipXRi
    ld (hl),1
RdJySkipXRi
    inc l ; point to player fire pointer
; need to prevent auto fire
    and 16
    jr z,RdJyWriteFire ; if fire not held, write no firing, clear last fire
    cp a,(hl) ; if fire held, check if pressed last frame
    jr nz,RdJyWriteFire ; if not, write fire and block autofire for next frame
; holding fire, dont clear auto fire block until released, dont allow fire
    xor a
    jr RdJyWriteFire+1
RdJyWriteFire
    ld (hl),a ; write last fire value
    inc l
    ld (hl),a ; write firing indicator used in MoveSprites
    ret


readmatrix
; scan keys, called under interrupt  KBmatrixbuf assumed page aligned
    ld hl,KBmatrixbuf
    ld de,#f0a
    ld bc,#f40e
    out (c),c
    ld b,#f6
    in a,(c)
    and #30
    ld c,a
    or #c0
    out (c),a
    out (c),c
    inc b
    ld a,#92
    out (c),a
    push bc
    set 6,c
scankey
    ld b,#f6
    out (c),c
    ld b,#f4
    in a,(c)
    cpl
    ld (hl),a
    inc l
    inc c
    ld a,c
    and d
    cp a,e
    jr nz,scankey
    pop bc
    ld a,#82
    out (c),a
    dec b
    out (c),c
    ret ; 64 - 2 + 10 * 23 = 292


;read "ArkosTrackerPlayer_CPC_MSXasm"
;	Arkos Tracker Player V101 - CPC # MSX version
;	21/09/09

;	Code By Targhan/Arkos
;	PSG registers sendings based on Madram/Overlander''s optimisation trick
;	Restoring interruption status snippet by Grim/Arkos

;	V101 additions
;	---------------
;	- Small (but not useless !) optimisations by Grim/Arkos at the PLY_Track1_WaitCounter / PLY_Track2_WaitCounter / PLY_Track3_WaitCounter labels
;	- Optimisation of the R13 management by Grim/Arkos



;	This player can adapt to the following machines =
;	Amstrad CPC and MSX
;	Output codes are specific, as well as the frequency tables

;	This player modifies all these registers = HL, DE, BC, AF, HL'', DE'', BC'', AF'', IX, IY
;	The Stack is used in conventionnal manners (Call, Ret, Push, Pop) so integration with any of your code should be seamless
;	The player does NOT modifies the Interruption state, unless you use the PLY_SystemFriendly flag, which will cut the
;	interruptions at the beginning, and will restore them ONLY IF NEEDED


;	Basically, there are three kind of players


;	ASM
;	---
;	Used in your Asm productions You call the Player by yourself, you don''t care if all the registers are modified

;	Set PLY_SystemFriendly and PLY_UseFirmwareInterruptions to 0

;	In Assembler =
;	ld de,MusicAddress
;	call Player / PLY_Init		to initialise the player with your song
;	then
;	call Player + 3 / PLY_Play	whenever you want to play/continue the song
;	call Player + 6 / PLY_Stop	to stop the song


;	BASIC
;	-----
;	Used in Basic (on CPC), or under the helm of any OS Interruptions will be cut by the player, but restored ONLY IF NECESSARY
;	Also, some registers are saved (AF'', BC'', IX and IY), as they are used by the CPC Firmware
;	If you need to add/remove more registers, take care to do it at PLY_Play, but also at PLY_Stop
;	Registers are restored at PLY_PSGREG13_RecoverSystemRegisters

;	Set PLY_SystemFriendly to 1 and PLY_UseFirmwareInterruptions to 0

;	The Calls in Assembler are the same as above

;	In Basic =
;	call Player, MusicAddress	to initialise the player with your song
;	then
;	call Player + 3			whenever you want to play/continue the song
;	call Player + 6			to stop the song


;	INTERRUPTIONS
;	-------------
;	CPC Only ! Uses the Firmware Interruptions to put the Player on interruption Very useful in Basic

;	Set PLY_SystemFriendly and PLY_UseFirmwareInterruptions to 1

;	In Assembler =
;	ld de,MusicAddress
;	call Player / PLY_InterruptionOn		to play the song from start
;	call Player + 3 / PLY_InterruptionOff		to stop the song
;	call Player + 6 / PLY_InterruptionContinue	to continue the song once it''s been stopped

;	In Basic=
;	call Player, MusicAddress	to play the song from start
;	call Player + 3			to stop the song
;	call Player + 6			to continue the song once it''s been stopped



;	FADES IN/OUT
;	------------
;	The player allows the volume to be modified It provides the interface, but you''ll have to set the volume by yourself
;	Set PLY_UseFades to 1
;	In Assembler =
;	ld e,Volume (0=full volume, 16 or more=no volume)
;	call PLY_SetFadeValue

;	In Basic =
;	call Player + 9 (or + 18, see just below), Volume (0=full volume, 16 or more=no volume)
;	WARNING ! You must call Player + 18 if PLY_UseBasicSoundEffectInterface is set to 1



;	SOUND EFFECTS
;	-------------
;	The player manages Sound Effects They must be defined in another song, generated as a "SFX Music" in the Arkos Tracker
;	Set the PLY_UseSoundEffects to 1 If you want to use sound effects in Basic, set PLY_UseBasicSoundEffectInterface to 1

;	In Assembler =
;	ld de,SFXMusicAddress
;	call PLY_SFX_Init		to initialise the SFX Song

;	Then initialise and play the "music" song normally

;	To play a sound effect =
;	A = No Channel (0,1,2)
;	L = SFX Number (>0)
;	H = Volume (0F)
;	E = Note (0143)
;	D = Speed (0 = As original, 1255 = new Speed (1 is the fastest))
;	BC = Inverted Pitch (-#FFFF -> FFFF) 0 is no pitch The higher the pitch, the lower the sound
;	call PLY_SFX_Play
;	To stop a sound effect =
;	ld e,No Channel (0,1,2)
;	call PLY_SFX_Stop
;	To stop the sound effects on all the channels =
;	call PLY_SFX_StopAll

;	In Basic =
;	call Player + 9, SFXMusicAddress	to initialise the SFX Song
;	To play a sound effect =
;	call Player + 12, No Channel, SFX Number, Volume, Note, Speed, Inverted Pitch No parameter should be ommited !
;	To stop a sound effect =
;	call Player + 15, No Channel (0,1,2)


;	For more information, check the manual

;	Any question, complaint, a need to reward ? Write to contact@julien-nevocom


PLY_UseCPCMachine equ 1		;Indicates what frequency table and output code to use 1 to use it
PLY_UseMSXMachine equ 0


PLY_UseSoundEffects equ 0	;Set to 1 if you want to use Sound Effects in your player Both CPU and memory consuming
PLY_UseFades equ 0		;Set to 1 to allow fades in/out A little CPU and memory consuming
				;PLY_SetFadeValue becomes available


PLY_SystemFriendly equ 0	;Set to 1 if you want to save the Registers used by AMSDOS (AF'', BC'', IX, IY)
				;(which allows you to call this player in BASIC)
				;As this option is system-friendly, it cuts the interruption, and restore them ONLY IF NECESSARY
PLY_UseFirmwareInterruptions equ 0 ;Set to 1 to use a Player under interruption Only works on CPC, as it uses the CPC Firmware
				;WARNING, PLY_SystemFriendly must be set to 1 if you use the Player under interruption !
				;SECOND WARNING, make sure the player is above #3fff, else it won''t be played (system limitation)

PLY_UseBasicSoundEffectInterface equ 0	;Set to 1 if you want a little interface to be added if you are a BASIC programmer who wants
					;to use sound effects Of course, you must also set PLY_UseSoundEffects to 1







PLY_RetrigValue	equ #fe		;Value used to trigger the Retrig of Register 13 #FE corresponds to CP xx Do not change it !






Player

	if PLY_UseFirmwareInterruptions

;******* Interruption Player ********

;You can remove these JPs if using the sub-routines directly
	jp PLY_InterruptionOn			;Call Player = Start Music
	jp PLY_InterruptionOff			;Call Player + 3 = Stop Music
	jp PLY_InterruptionContinue		;Call Player + 6 = Continue (after stopping)

	if PLY_UseBasicSoundEffectInterface
	jp PLY_SFX_Init				;Call Player + 9 to initialise the sound effect music
	jp PLY_BasicSoundEffectInterface_PlaySound ;Call Player + 12 to add sound effect in BASIC
	jp PLY_SFX_Stop				;Call Player + 15 to stop a sound effect
	endif

	if PLY_UseFades
	jp PLY_SetFadeValue			;Call Player + 9 or + 18 to set Fades values
	endif



PLY_InterruptionOn call PLY_Init
	ld hl,PLY_Interruption_Convert
PLY_ReplayFrequency ld de,0
	ld a,d
	ld (PLY_Interruption_Cpt + 1),a
	add hl,de
	ld a,(hl)	;Chope nbinter wait
	ld (PLY_Interruption_Value + 1),a

PLY_InterruptionContinue
	ld hl,PLY_Interruption_ControlBloc
	ld bc,%10000001*256+0
	ld de,PLY_Interruption_Play
	jp #bce0
PLY_InterruptionOff ld hl,PLY_Interruption_ControlBloc
	call #bce6
	jp PLY_Stop

PLY_Interruption_ControlBloc defs 10,0	;Buffer used by the OS

;Code run by the OS on each interruption
PLY_Interruption_Play di

PLY_Interruption_Cpt ld a,0		;Run the player only if it has to, according to the music frequency
PLY_Interruption_Value cp 5
	jr z,PLY_Interruption_NoWait
	inc a
	ld (PLY_Interruption_Cpt + 1),a
	ret

PLY_Interruption_NoWait xor a
	ld (PLY_Interruption_Cpt + 1),a
	jp PLY_Play

;Table to convert PLY_ReplayFrequency into a Frequency value for the AMSDOS
PLY_Interruption_Convert defb 17, 11, 5, 2, 1, 0


	






	else




;***** Normal Player *****
;To be called when you want

;You can remove these following JPs if using the sub-routines directly
	jp PLY_Init						;Call Player = Initialise song (DE = Song address)
	jp PLY_Play						;Call Player + 3 = Play song
	jp PLY_Stop						;Call Player + 6 = Stop song
	endif

	if PLY_UseBasicSoundEffectInterface
	jp PLY_SFX_Init						;Call Player + 9 to initialise the sound effect music
	jp PLY_BasicSoundEffectInterface_PlaySound		;Call Player + 12 to add sound effect in BASIC
	jp PLY_SFX_Stop						;Call Player + 15 to stop a sound effect
	endif

	if PLY_UseFades
	jp PLY_SetFadeValue					;Call Player + 9 or + 18 to set Fades values
	endif



PLY_Digidrum db 0						;Read here to know if a Digidrum has been played (0=no)


PLY_Play

	if PLY_SystemFriendly
	call PLY_DisableInterruptions
	ex af,af''
	exx
	push af
	push bc
	push ix
	push iy
	endif



	xor a				
	ld (PLY_Digidrum),a		;Reset the Digidrum flag


;Manage Speed If Speed counter is over, we have to read the Pattern further
PLY_SpeedCpt ld a,1
	dec a
	jp nz,PLY_SpeedEnd

	;Moving forward in the Pattern Test if it is not over
PLY_HeightCpt ld a,1
	dec a
	jr nz,PLY_HeightEnd

;Pattern Over We have to read the Linker




	;Get the Transpositions, if they have changed, or detect the Song Ending !
PLY_Linker_PT ld hl,0
	ld a,(hl)
	inc hl
	rra
	jr nc,PLY_SongNotOver
	;Song over ! We read the address of the Loop point
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld a,(hl)			;We know the Song won''t restart now, so we can skip the first bit
	inc hl
	rra
PLY_SongNotOver
	rra
	jr nc,PLY_NoNewTransposition1
	ld de,PLY_Transposition1 + 1
	ldi
PLY_NoNewTransposition1
	rra
	jr nc,PLY_NoNewTransposition2
	ld de,PLY_Transposition2 + 1
	ldi
PLY_NoNewTransposition2
	rra
	jr nc,PLY_NoNewTransposition3
	ld de,PLY_Transposition3 + 1
	ldi
PLY_NoNewTransposition3

	;Get the Tracks addresses
	ld de,PLY_Track1_PT + 1
	ldi
	ldi
	ld de,PLY_Track2_PT + 1
	ldi
	ldi
	ld de,PLY_Track3_PT + 1
	ldi
	ldi

	;Get the Special Track address, if it has changed
	rra
	jr nc,PLY_NoNewHeight
	ld de,PLY_Height + 1
	ldi
PLY_NoNewHeight

	rra
	jr nc,PLY_NoNewSpecialTrack
PLY_NewSpecialTrack
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld (PLY_SaveSpecialTrack + 1),de

PLY_NoNewSpecialTrack
	ld (PLY_Linker_PT + 1),hl
PLY_SaveSpecialTrack ld hl,0
	ld (PLY_SpecialTrack_PT + 1),hl

	;Reset the SpecialTrack/Tracks line counter
	;We can''t rely on the song data, because the Pattern Height is not related to the Tracks Height
	ld a,1
	ld (PLY_SpecialTrack_WaitCounter + 1),a
	ld (PLY_Track1_WaitCounter + 1),a
	ld (PLY_Track2_WaitCounter + 1),a
	ld (PLY_Track3_WaitCounter + 1),a



PLY_Height ld a,1
PLY_HeightEnd
	ld (PLY_HeightCpt + 1),a






;Read the Special Track/Tracks
;------------------------------


;Read the Special Track
PLY_SpecialTrack_WaitCounter ld a,1
	dec a
	jr nz,PLY_SpecialTrack_Wait

PLY_SpecialTrack_PT ld hl,0
	ld a,(hl)
	inc hl
	srl a				;Data (1) or Wait (0) ?
	jr nc,PLY_SpecialTrack_NewWait	;If Wait, A contains the Wait value
	;Data Effect Type ?
	srl a				;Speed (0) or Digidrum (1) ?
	;First, we don''t test the Effect Type, but only the Escape Code (=0)
	jr nz,PLY_SpecialTrack_NoEscapeCode
	ld a,(hl)
	inc hl
	
PLY_SpecialTrack_NoEscapeCode
	;Now, we test the Effect type, since the Carry didn''t change
	jr nc,PLY_SpecialTrack_Speed
	ld (PLY_Digidrum),a
	jr PLY_PT_SpecialTrack_EndData

PLY_SpecialTrack_Speed
	ld (PLY_Speed + 1),a
PLY_PT_SpecialTrack_EndData
	ld a,1
PLY_SpecialTrack_NewWait
	ld (PLY_SpecialTrack_PT + 1),hl
PLY_SpecialTrack_Wait
	ld (PLY_SpecialTrack_WaitCounter + 1),a















;Read the Track 1
;-----------------

;Store the parameters, because the player below is called every frame, but the Read Track isn''t
PLY_Track1_WaitCounter ld a,1
	dec a
	jr nz,PLY_Track1_NewInstrument_SetWait

PLY_Track1_PT ld hl,0
	call PLY_ReadTrack
	ld (PLY_Track1_PT + 1),hl
	jr c,PLY_Track1_NewInstrument_SetWait


	;No Wait command Can be a Note and/or Effects
	ld a,d			;Make a copy of the flags+Volume in A, not to temper with the original

	rra			;Volume ? If bit 4 was 1, then volume exists on b3-b0
	jr nc,PLY_Track1_SameVolume
	and %1111
	ld (PLY_Track1_Volume),a
PLY_Track1_SameVolume



	rl d				;New Pitch ?
	jr nc,PLY_Track1_NoNewPitch
	ld (PLY_Track1_PitchAdd + 1),ix
PLY_Track1_NoNewPitch

	rl d				;Note ? If no Note, we don''t have to test if a new Instrument is here
	jr nc,PLY_Track1_NoNoteGiven
	ld a,e
PLY_Transposition1 add a,0		;Transpose Note according to the Transposition in the Linker
	ld (PLY_Track1_Note),a

	ld hl,0				;Reset the TrackPitch
	ld (PLY_Track1_Pitch + 1),hl

	rl d				;New Instrument ?
	jr c,PLY_Track1_NewInstrument
PLY_Track1_SavePTInstrument ld hl,0	;Same Instrument We recover its address to restart it
	ld a,(PLY_Track1_InstrumentSpeed + 1)		;Reset the Instrument Speed Counter Never seemed useful
	ld (PLY_Track1_InstrumentSpeedCpt + 1),a
	jr PLY_Track1_InstrumentResetPT

PLY_Track1_NewInstrument		;New Instrument We have to get its new address, and Speed
	ld l,b				;H is already set to 0 before
	add hl,hl
PLY_Track1_InstrumentsTablePT ld bc,0
	add hl,bc
	ld a,(hl)			;Get Instrument address
	inc hl
	ld h,(hl)
	ld l,a
	ld a,(hl)			;Get Instrument speed
	inc hl
	ld (PLY_Track1_InstrumentSpeed + 1),a
	ld (PLY_Track1_InstrumentSpeedCpt + 1),a
	ld a,(hl)
	or a				;Get IsRetrig? Code it only if different to 0, else next Instruments are going to overwrite it
	jr z,$+5
	ld (PLY_PSGReg13_Retrig + 1),a

	inc hl

	ld (PLY_Track1_SavePTInstrument + 1),hl		;When using the Instrument again, no need to give the Speed, it is skipped

PLY_Track1_InstrumentResetPT
	ld (PLY_Track1_Instrument + 1),hl





PLY_Track1_NoNoteGiven

	ld a,1
PLY_Track1_NewInstrument_SetWait
	ld (PLY_Track1_WaitCounter + 1),a









;Read the Track 2
;-----------------

;Store the parameters, because the player below is called every frame, but the Read Track isn''t
PLY_Track2_WaitCounter ld a,1
	dec a
	jr nz,PLY_Track2_NewInstrument_SetWait

PLY_Track2_PT ld hl,0
	call PLY_ReadTrack
	ld (PLY_Track2_PT + 1),hl
	jr c,PLY_Track2_NewInstrument_SetWait


	;No Wait command Can be a Note and/or Effects
	ld a,d			;Make a copy of the flags+Volume in A, not to temper with the original

	rra			;Volume ? If bit 4 was 1, then volume exists on b3-b0
	jr nc,PLY_Track2_SameVolume
	and %1111
	ld (PLY_Track2_Volume),a
PLY_Track2_SameVolume



	rl d				;New Pitch ?
	jr nc,PLY_Track2_NoNewPitch
	ld (PLY_Track2_PitchAdd + 1),ix
PLY_Track2_NoNewPitch

	rl d				;Note ? If no Note, we don''t have to test if a new Instrument is here
	jr nc,PLY_Track2_NoNoteGiven
	ld a,e
PLY_Transposition2 add a,0		;Transpose Note according to the Transposition in the Linker
	ld (PLY_Track2_Note),a

	ld hl,0				;Reset the TrackPitch
	ld (PLY_Track2_Pitch + 1),hl

	rl d				;New Instrument ?
	jr c,PLY_Track2_NewInstrument
PLY_Track2_SavePTInstrument ld hl,0	;Same Instrument We recover its address to restart it
	ld a,(PLY_Track2_InstrumentSpeed + 1)		;Reset the Instrument Speed Counter Never seemed useful
	ld (PLY_Track2_InstrumentSpeedCpt + 1),a
	jr PLY_Track2_InstrumentResetPT

PLY_Track2_NewInstrument		;New Instrument We have to get its new address, and Speed
	ld l,b				;H is already set to 0 before
	add hl,hl
PLY_Track2_InstrumentsTablePT ld bc,0
	add hl,bc
	ld a,(hl)			;Get Instrument address
	inc hl
	ld h,(hl)
	ld l,a
	ld a,(hl)			;Get Instrument speed
	inc hl
	ld (PLY_Track2_InstrumentSpeed + 1),a
	ld (PLY_Track2_InstrumentSpeedCpt + 1),a
	ld a,(hl)
	or a				;Get IsRetrig? Code it only if different to 0, else next Instruments are going to overwrite it
	jr z,$+5
	ld (PLY_PSGReg13_Retrig + 1),a
	inc hl


	ld (PLY_Track2_SavePTInstrument + 1),hl		;When using the Instrument again, no need to give the Speed, it is skipped

PLY_Track2_InstrumentResetPT
	ld (PLY_Track2_Instrument + 1),hl





PLY_Track2_NoNoteGiven

	ld a,1
PLY_Track2_NewInstrument_SetWait
	ld (PLY_Track2_WaitCounter + 1),a







;Read the Track 3
;-----------------

;Store the parameters, because the player below is called every frame, but the Read Track isn''t
PLY_Track3_WaitCounter ld a,1
	dec a
	jr nz,PLY_Track3_NewInstrument_SetWait

PLY_Track3_PT ld hl,0
	call PLY_ReadTrack
	ld (PLY_Track3_PT + 1),hl
	jr c,PLY_Track3_NewInstrument_SetWait


	;No Wait command Can be a Note and/or Effects
	ld a,d			;Make a copy of the flags+Volume in A, not to temper with the original

	rra			;Volume ? If bit 4 was 1, then volume exists on b3-b0
	jr nc,PLY_Track3_SameVolume
	and %1111
	ld (PLY_Track3_Volume),a
PLY_Track3_SameVolume



	rl d				;New Pitch ?
	jr nc,PLY_Track3_NoNewPitch
	ld (PLY_Track3_PitchAdd + 1),ix
PLY_Track3_NoNewPitch

	rl d				;Note ? If no Note, we don''t have to test if a new Instrument is here
	jr nc,PLY_Track3_NoNoteGiven
	ld a,e
PLY_Transposition3 add a,0		;Transpose Note according to the Transposition in the Linker
	ld (PLY_Track3_Note),a

	ld hl,0				;Reset the TrackPitch
	ld (PLY_Track3_Pitch + 1),hl

	rl d				;New Instrument ?
	jr c,PLY_Track3_NewInstrument
PLY_Track3_SavePTInstrument ld hl,0	;Same Instrument We recover its address to restart it
	ld a,(PLY_Track3_InstrumentSpeed + 1)		;Reset the Instrument Speed Counter Never seemed useful
	ld (PLY_Track3_InstrumentSpeedCpt + 1),a
	jr PLY_Track3_InstrumentResetPT

PLY_Track3_NewInstrument		;New Instrument We have to get its new address, and Speed
	ld l,b				;H is already set to 0 before
	add hl,hl
PLY_Track3_InstrumentsTablePT ld bc,0
	add hl,bc
	ld a,(hl)			;Get Instrument address
	inc hl
	ld h,(hl)
	ld l,a
	ld a,(hl)			;Get Instrument speed
	inc hl
	ld (PLY_Track3_InstrumentSpeed + 1),a
	ld (PLY_Track3_InstrumentSpeedCpt + 1),a
	ld a,(hl)
	or a				;Get IsRetrig? Code it only if different to 0, else next Instruments are going to overwrite it
	jr z,$+5
	ld (PLY_PSGReg13_Retrig + 1),a
	inc hl


	ld (PLY_Track3_SavePTInstrument + 1),hl		;When using the Instrument again, no need to give the Speed, it is skipped

PLY_Track3_InstrumentResetPT
	ld (PLY_Track3_Instrument + 1),hl





PLY_Track3_NoNoteGiven

	ld a,1
PLY_Track3_NewInstrument_SetWait
	ld (PLY_Track3_WaitCounter + 1),a










PLY_Speed ld a,1
PLY_SpeedEnd
	ld (PLY_SpeedCpt + 1),a










;Play the Sound on Track 3
;-------------------------
;Plays the sound on each frame, but only save the forwarded Instrument pointer when Instrument Speed is reached
;This is needed because TrackPitch is involved in the Software Frequency/Hardware Frequency calculation, and is calculated every frame

	ld iy,PLY_PSGRegistersArray + 4
PLY_Track3_Pitch ld hl,0
PLY_Track3_PitchAdd ld de,0
	add hl,de
	ld (PLY_Track3_Pitch + 1),hl
	sra h				;Shift the Pitch to slow its speed
	rr l
	sra h
	rr l
	ex de,hl
	exx

PLY_Track3_Volume equ $+2
PLY_Track3_Note equ $+1
	ld de,0				;D=Inverted Volume E=Note
PLY_Track3_Instrument ld hl,0
	call PLY_PlaySound

PLY_Track3_InstrumentSpeedCpt ld a,1
	dec a
	jr nz,PLY_Track3_PlayNoForward
	ld (PLY_Track3_Instrument + 1),hl
PLY_Track3_InstrumentSpeed ld a,6
PLY_Track3_PlayNoForward
	ld (PLY_Track3_InstrumentSpeedCpt + 1),a



;***************************************
;Play Sound Effects on Track 3 (only assembled used if PLY_UseSoundEffects is set to one)
;***************************************
	if PLY_UseSoundEffects


PLY_SFX_Track3_Pitch ld de,0
	exx
PLY_SFX_Track3_Volume equ $+2
PLY_SFX_Track3_Note equ $+1
	ld de,0				;D=Inverted Volume E=Note
PLY_SFX_Track3_Instrument ld hl,0	;If 0, no sound effect
	ld a,l
	or h
	jr z,PLY_SFX_Track3_End
	ld a,1
	ld (PLY_PS_EndSound_SFX + 1),a
	call PLY_PlaySound
	xor a
	ld (PLY_PS_EndSound_SFX + 1),a
	ld a,l				;If the new address is 0, the instrument is over Speed is set in the process, we don''t care
	or h
	jr z,PLY_SFX_Track3_Instrument_SetAddress

PLY_SFX_Track3_InstrumentSpeedCpt ld a,1
	dec a
	jr nz,PLY_SFX_Track3_PlayNoForward
PLY_SFX_Track3_Instrument_SetAddress
	ld (PLY_SFX_Track3_Instrument + 1),hl
PLY_SFX_Track3_InstrumentSpeed ld a,6
PLY_SFX_Track3_PlayNoForward
	ld (PLY_SFX_Track3_InstrumentSpeedCpt + 1),a

PLY_SFX_Track3_End

	endif
;******************************************




	ld a,ixl			;Save the Register 7 of the Track 3
	ex af,af''
	



;Play the Sound on Track 2
;-------------------------
	ld iy,PLY_PSGRegistersArray + 2
PLY_Track2_Pitch ld hl,0
PLY_Track2_PitchAdd ld de,0
	add hl,de
	ld (PLY_Track2_Pitch + 1),hl
	sra h				;Shift the Pitch to slow its speed
	rr l
	sra h
	rr l
	ex de,hl
	exx

PLY_Track2_Volume equ $+2
PLY_Track2_Note equ $+1
	ld de,0				;D=Inverted Volume E=Note
PLY_Track2_Instrument ld hl,0
	call PLY_PlaySound

PLY_Track2_InstrumentSpeedCpt ld a,1
	dec a
	jr nz,PLY_Track2_PlayNoForward
	ld (PLY_Track2_Instrument + 1),hl
PLY_Track2_InstrumentSpeed ld a,6
PLY_Track2_PlayNoForward
	ld (PLY_Track2_InstrumentSpeedCpt + 1),a



;***************************************
;Play Sound Effects on Track 2 (only assembled used if PLY_UseSoundEffects is set to one)
;***************************************
	if PLY_UseSoundEffects

PLY_SFX_Track2_Pitch ld de,0
	exx
PLY_SFX_Track2_Volume equ $+2
PLY_SFX_Track2_Note equ $+1
	ld de,0				;D=Inverted Volume E=Note
PLY_SFX_Track2_Instrument ld hl,0	;If 0, no sound effect
	ld a,l
	or h
	jr z,PLY_SFX_Track2_End
	ld a,1
	ld (PLY_PS_EndSound_SFX + 1),a
	call PLY_PlaySound
	xor a
	ld (PLY_PS_EndSound_SFX + 1),a
	ld a,l				;If the new address is 0, the instrument is over Speed is set in the process, we don''t care
	or h
	jr z,PLY_SFX_Track2_Instrument_SetAddress

PLY_SFX_Track2_InstrumentSpeedCpt ld a,1
	dec a
	jr nz,PLY_SFX_Track2_PlayNoForward
PLY_SFX_Track2_Instrument_SetAddress
	ld (PLY_SFX_Track2_Instrument + 1),hl
PLY_SFX_Track2_InstrumentSpeed ld a,6
PLY_SFX_Track2_PlayNoForward
	ld (PLY_SFX_Track2_InstrumentSpeedCpt + 1),a

PLY_SFX_Track2_End
	endif
;******************************************


	ex af,af''
	add a,a			;Mix Reg7 from Track2 with Track3, making room first
	or ixl
	rla
	ex af,af''



;Play the Sound on Track 1
;-------------------------

	ld iy,PLY_PSGRegistersArray
PLY_Track1_Pitch ld hl,0
PLY_Track1_PitchAdd ld de,0
	add hl,de
	ld (PLY_Track1_Pitch + 1),hl
	sra h				;Shift the Pitch to slow its speed
	rr l
	sra h
	rr l
	ex de,hl
	exx

PLY_Track1_Volume equ $+2
PLY_Track1_Note equ $+1
	ld de,0				;D=Inverted Volume E=Note
PLY_Track1_Instrument ld hl,0
	call PLY_PlaySound

PLY_Track1_InstrumentSpeedCpt ld a,1
	dec a
	jr nz,PLY_Track1_PlayNoForward
	ld (PLY_Track1_Instrument + 1),hl
PLY_Track1_InstrumentSpeed ld a,6
PLY_Track1_PlayNoForward
	ld (PLY_Track1_InstrumentSpeedCpt + 1),a




;***************************************
;Play Sound Effects on Track 1 (only assembled used if PLY_UseSoundEffects is set to one)
;***************************************
	if PLY_UseSoundEffects


PLY_SFX_Track1_Pitch ld de,0
	exx
PLY_SFX_Track1_Volume equ $+2
PLY_SFX_Track1_Note equ $+1
	ld de,0				;D=Inverted Volume E=Note
PLY_SFX_Track1_Instrument ld hl,0	;If 0, no sound effect
	ld a,l
	or h
	jr z,PLY_SFX_Track1_End
	ld a,1
	ld (PLY_PS_EndSound_SFX + 1),a
	call PLY_PlaySound
	xor a
	ld (PLY_PS_EndSound_SFX + 1),a
	ld a,l				;If the new address is 0, the instrument is over Speed is set in the process, we don''t care
	or h
	jr z,PLY_SFX_Track1_Instrument_SetAddress

PLY_SFX_Track1_InstrumentSpeedCpt ld a,1
	dec a
	jr nz,PLY_SFX_Track1_PlayNoForward
PLY_SFX_Track1_Instrument_SetAddress
	ld (PLY_SFX_Track1_Instrument + 1),hl
PLY_SFX_Track1_InstrumentSpeed ld a,6
PLY_SFX_Track1_PlayNoForward
	ld (PLY_SFX_Track1_InstrumentSpeedCpt + 1),a

PLY_SFX_Track1_End
	endif
;***********************************







	ex af,af''
	or ixl			;Mix Reg7 from Track3 with Track2+1



;Send the registers to PSG Various codes according to the machine used
PLY_SendRegisters
;A=Register 7




	if PLY_UseMSXMachine

	ld b,a
	ld hl,PLY_PSGRegistersArray

;Register 0
	xor a
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 1
	ld a,1
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 2
	ld a,2
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 3
	ld a,3
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 4
	ld a,4
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 5
	ld a,5
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 6
	ld a,6
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 7
	ld a,7
	out (#a0),a
	ld a,b				;Use the stored Register 7
	out (#a1),a

;Register 8
	ld a,8
	out (#a0),a
	ld a,(hl)

	if PLY_UseFades
PLY_Channel1_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0)
	jr nc,$+3
	xor a
	endif

	out (#a1),a
	inc hl
	inc hl				;Skip unused byte

;Register 9
	ld a,9
	out (#a0),a
	ld a,(hl)

	if PLY_UseFades
PLY_Channel2_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0)
	jr nc,$+3
	xor a
	endif

	out (#a1),a
	inc hl
	inc hl				;Skip unused byte
	
;Register 10
	ld a,10
	out (#a0),a
	ld a,(hl)

	if PLY_UseFades
PLY_Channel3_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0)
	jr nc,$+3
	xor a
	endif

	out (#a1),a
	inc hl

;Register 11
	ld a,11
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 12
	ld a,12
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 13
	if PLY_SystemFriendly
	call PLY_PSGReg13_Code
PLY_PSGREG13_RecoverSystemRegisters
	pop iy
	pop ix
	pop bc
	pop af
	exx
	ex af,af''
	;Restore Interrupt status
PLY_RestoreInterruption nop				;Will be automodified to an DI/EI
	ret

	endif


PLY_PSGReg13_Code
	ld a,13
	out (#a0),a
	ld a,(hl)
PLY_PSGReg13_Retrig cp 255				;If IsRetrig?, force the R13 to be triggered
	ret z

	out (#a1),a
	ld (PLY_PSGReg13_Retrig + 1),a
	ret



	endif
















	if PLY_UseCPCMachine

	ld de,#c080
	ld b,#f6
	out (c),d	;#f6c0
	exx
	ld hl,PLY_PSGRegistersArray
	ld e,#f6
	ld bc,#f401

;Register 0
	defb #ed,#71	;#f400+Register
	ld b,e
	defb #ed,#71	;#f600
	dec b
	outi		;#f400+value
	exx
	out (c),e	;#f680
	out (c),d	;#f6c0
	exx

;Register 1
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 2
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 3
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 4
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 5
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 6
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 7
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	dec b
	out (c),a			;Read A register instead of the list
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 8
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	if PLY_UseFades
	dec b
	ld a,(hl)
PLY_Channel1_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0)
	jr nc,$+6
	defb #ed,#71
	jr $+4
	out (c),a
	inc hl

	else
	
	outi
	endif
	exx
	out (c),e
	out (c),d
	exx
	inc c
	inc hl				;Skip unused byte

;Register 9
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	if PLY_UseFades			;If PLY_UseFades is set to 1, we manage the volume fade
	dec b
	ld a,(hl)
PLY_Channel2_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0)
	jr nc,$+6
	defb #ed,#71
	jr $+4
	out (c),a
	inc hl

	else
	
	outi
	endif
	exx
	out (c),e
	out (c),d
	exx
	inc c
	inc hl				;Skip unused byte

;Register 10
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	if PLY_UseFades
	dec b
	ld a,(hl)
PLY_Channel3_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0)
	jr nc,$+6
	defb #ed,#71
	jr $+4
	out (c),a
	inc hl

	else
	
	outi
	endif
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 11
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 12
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 13
	if PLY_SystemFriendly
	call PLY_PSGReg13_Code

PLY_PSGREG13_RecoverSystemRegisters
	pop iy
	pop ix
	pop bc
	pop af
	exx
	ex af,af''
	;Restore Interrupt status
PLY_RestoreInterruption nop				;Will be automodified to an DI/EI
	ret

	endif


PLY_PSGReg13_Code
	ld a,(hl)
PLY_PSGReg13_Retrig cp 255				;If IsRetrig?, force the R13 to be triggered
	ret z
	ld (PLY_PSGReg13_Retrig + 1),a
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	ret

	endif












;There are two holes in the list, because the Volume registers are set relatively to the Frequency of the same Channel (+7, always)
;Also, the Reg7 is passed as a register, so is not kept in the memory
PLY_PSGRegistersArray
PLY_PSGReg0 db 0
PLY_PSGReg1 db 0
PLY_PSGReg2 db 0
PLY_PSGReg3 db 0
PLY_PSGReg4 db 0
PLY_PSGReg5 db 0
PLY_PSGReg6 db 0
PLY_PSGReg8 db 0		;+7
	    db 0
PLY_PSGReg9 db 0		;+9
	    db 0
PLY_PSGReg10 db 0		;+11
PLY_PSGReg11 db 0
PLY_PSGReg12 db 0
PLY_PSGReg13 db 0
PLY_PSGRegistersArray_End





























;Plays a sound stream
;HL=Pointer on Instrument Data
;IY=Pointer on Register code (volume, frequency)
;E=Note
;D=Inverted Volume
;DE''=TrackPitch

;RET=
;HL=New Instrument pointer
;IXL=Reg7 mask (x00x)

;Also used inside =
;B,C=read byte/second byte
;IXH=Save original Note (only used for Independant mode)


PLY_PlaySound
	ld b,(hl)
	inc hl
	rr b
	jp c,PLY_PS_Hard

;**************
;Software Sound
;**************
	;Second Byte needed ?
	rr b
	jr c,PLY_PS_S_SecondByteNeeded

	;No second byte needed We need to check if Volume is null or not
	ld a,b
	and %1111
	jr nz,PLY_PS_S_SoundOn

	;Null Volume It means no Sound We stop the Sound, the Noise, and it''s over
	ld (iy + 7),a			;We have to make the volume to 0, because if a bass Hard was activated before, we have to stop it
	ld ixl,%1001

	ret

PLY_PS_S_SoundOn
	;Volume is here, no Second Byte needed It means we have a simple Software sound (Sound = On, Noise = Off)
	;We have to test Arpeggio and Pitch, however
	ld ixl,%1000

	sub d						;Code Volume
	jr nc,$+3
	xor a
	ld (iy + 7),a

	rr b						;Needed for the subroutine to get the good flags
	call PLY_PS_CalculateFrequency
	ld (iy + 0),l					;Code Frequency
	ld (iy + 1),h
	exx

	ret
	


PLY_PS_S_SecondByteNeeded
	ld ixl,%1000	;By defaut, No Noise, Sound

	;Second Byte needed
	ld c,(hl)
	inc hl

	;Noise ?
	ld a,c
	and %11111
	jr z,PLY_PS_S_SBN_NoNoise
	ld (PLY_PSGReg6),a
	ld ixl,%0000					;Open Noise Channel
	PLY_PS_S_SBN_NoNoise

	;Here we have either Volume and/or Sound So first we need to read the Volume
	ld a,b
	and %1111
	sub d						;Code Volume
	jr nc,$+3
	xor a
	ld (iy + 7),a

	;Sound ?
	bit 5,c
	jr nz,PLY_PS_S_SBN_Sound
	;No Sound Stop here
	inc ixl						;Set Sound bit to stop the Sound
	ret

PLY_PS_S_SBN_Sound
	;Manual Frequency ?
	rr b						;Needed for the subroutine to get the good flags
	bit 6,c
	call PLY_PS_CalculateFrequency_TestManualFrequency
	ld (iy + 0),l					;Code Frequency
	ld (iy + 1),h
	exx

	ret




;**********
;Hard Sound
;**********
PLY_PS_Hard
	;We don''t set the Volume to 16 now because we may have reached the end of the sound !

	rr b						;Test Retrig here, it is common to every Hard sounds
	jr nc,PLY_PS_Hard_NoRetrig
	ld a,(PLY_Track1_InstrumentSpeedCpt + 1)	;Retrig only if it is the first step in this line of Instrument !
	ld c,a
	ld a,(PLY_Track1_InstrumentSpeed + 1)
	cp c
	jr nz,PLY_PS_Hard_NoRetrig
	ld a,PLY_RetrigValue
	ld (PLY_PSGReg13_Retrig + 1),a
PLY_PS_Hard_NoRetrig

	;Independant/Loop or Software/Hardware Dependent ?
	bit 1,b				;We don''t shift the bits, so that we can use the same code (Frequency calculation) several times
	jp nz,PLY_PS_Hard_LoopOrIndependent

	;Hardware Sound
	ld (iy + 7),16					;Set Volume
	ld ixl,%1000					;Sound is always On here (only Independence mode can switch it off)

	;This code is common to both Software and Hardware Dependent
	ld c,(hl)			;Get Second Byte
	inc hl
	ld a,c				;Get the Hardware Envelope waveform
	and %1111			;We don''t care about the bit 7-4, but we have to clear them, else the waveform might be reset
	ld (PLY_PSGReg13),a

	bit 0,b
	jr z,PLY_PS_HardwareDependent


;******************
;Software Dependent
;******************

	;Calculate the Software frequency
	bit 4-2,b		;Manual Frequency ? -2 Because the byte has been shifted previously
	call PLY_PS_CalculateFrequency_TestManualFrequency
	ld (iy + 0),l		;Code Software Frequency
	ld (iy + 1),h
	exx

	;Shift the Frequency
	ld a,c
	rra
	rra			;Shift=Shift*4 The shift is inverted in memory (7 - Editor Shift)
	and %11100
	ld (PLY_PS_SD_Shift + 1),a
	ld a,b			;Used to get the HardwarePitch flag within the second registers set
	exx

PLY_PS_SD_Shift jr $+2
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
	jr nc,$+3
	inc hl

	;Hardware Pitch ?
	bit 7-2,a
	jr z,PLY_PS_SD_NoHardwarePitch
	exx						;Get Pitch and add it to the just calculated Hardware Frequency
	ld a,(hl)
	inc hl
	exx
	add a,l						;Slow Can be optimised ? Probably never used anyway
	ld l,a
	exx
	ld a,(hl)
	inc hl
	exx
	adc a,h
	ld h,a
PLY_PS_SD_NoHardwarePitch
	ld (PLY_PSGReg11),hl
	exx


	;This code is also used by Hardware Dependent
PLY_PS_SD_Noise
	;Noise ?
	bit 7,c
	ret z
	ld a,(hl)
	inc hl
	ld (PLY_PSGReg6),a
	ld ixl,%0000
	ret




;******************
;Hardware Dependent
;******************
PLY_PS_HardwareDependent
	;Calculate the Hardware frequency
	bit 4-2,b			;Manual Hardware Frequency ? -2 Because the byte has been shifted previously
	call PLY_PS_CalculateFrequency_TestManualFrequency
	ld (PLY_PSGReg11),hl		;Code Hardware Frequency
	exx

	;Shift the Hardware Frequency
	ld a,c
	rra
	rra			;Shift=Shift*4 The shift is inverted in memory (7 - Editor Shift)
	and %11100
	ld (PLY_PS_HD_Shift + 1),a
	ld a,b			;Used to get the Software flag within the second registers set
	exx


PLY_PS_HD_Shift jr $+2
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h

	;Software Pitch ?
	bit 7-2,a
	jr z,PLY_PS_HD_NoSoftwarePitch
	exx						;Get Pitch and add it to the just calculated Software Frequency
	ld a,(hl)
	inc hl
	exx
	add a,l
	ld l,a						;Slow Can be optimised ? Probably never used anyway
	exx
	ld a,(hl)
	inc hl
	exx
	adc a,h
	ld h,a
PLY_PS_HD_NoSoftwarePitch
	ld (iy + 0),l					;Code Frequency
	ld (iy + 1),h
	exx

	;Go to manage Noise, common to Software Dependent
	jr PLY_PS_SD_Noise





PLY_PS_Hard_LoopOrIndependent
	bit 0,b					;We mustn''t shift it to get the result in the Carry, as it would be mess the structure
	jr z,PLY_PS_Independent			;of the flags, making it uncompatible with the common code

	;The sound has ended
	;If Sound Effects activated, we mark the "end of sound" by returning a 0 as an address
	if PLY_UseSoundEffects
PLY_PS_EndSound_SFX ld a,0			;Is the sound played is a SFX (1) or a normal sound (0) ?
	or a
	jr z,PLY_PS_EndSound_NotASFX
	ld hl,0
	ret
PLY_PS_EndSound_NotASFX
	endif

	;The sound has ended Read the new pointer and restart instrument

	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp PLY_PlaySound






;***********
;Independent
;***********
PLY_PS_Independent
	ld (iy + 7),16			;Set Volume

	;Sound ?
	bit 7-2,b			;-2 Because the byte has been shifted previously
	jr nz,PLY_PS_I_SoundOn
	;No Sound ! It means we don''t care about the software frequency (manual frequency, arpeggio, pitch)
	ld ixl,%1001
	jr PLY_PS_I_SkipSoftwareFrequencyCalculation
PLY_PS_I_SoundOn
	ld ixl,%1000			;Sound is on
	ld ixh,e			;Save the original note for the Hardware frequency, because a Software Arpeggio will modify it

	;Calculate the Software frequency
	bit 4-2,b			;Manual Frequency ? -2 Because the byte has been shifted previously
	call PLY_PS_CalculateFrequency_TestManualFrequency
	ld (iy + 0),l			;Code Software Frequency
	ld (iy + 1),h
	exx

	ld e,ixh
PLY_PS_I_SkipSoftwareFrequencyCalculation

	ld b,(hl)			;Get Second Byte
	inc hl
	ld a,b				;Get the Hardware Envelope waveform
	and %1111			;We don''t care about the bit 7-4, but we have to clear them, else the waveform might be reset
	ld (PLY_PSGReg13),a


	;Calculate the Hardware frequency
	rr b				;Must shift it to match the expected data of the subroutine
	rr b
	bit 4-2,b			;Manual Hardware Frequency ? -2 Because the byte has been shifted previously
	call PLY_PS_CalculateFrequency_TestManualFrequency
	ld (PLY_PSGReg11),hl		;Code Hardware Frequency
	exx



	;Noise ? We can''t use the previous common code, because the setting of the Noise is different, since Independent can have no Sound
	bit 7-2,b
	ret z
	ld a,(hl)
	inc hl
	ld (PLY_PSGReg6),a
	ld a,ixl	;Set the Noise bit
	res 3,a
	ld ixl,a
	ret

















;Subroutine that =
;If Manual Frequency? (Flag Z off), read frequency (Word) and adds the TrackPitch (DE'')
;Else, Auto Frequency
;	if Arpeggio? = 1 (bit 3 from B), read it (Byte)
;	if Pitch? = 1 (bit 4 from B), read it (Word)
;	Calculate the frequency according to the Note (E) + Arpeggio + TrackPitch (DE'')

;HL = Pointer on Instrument data
;DE''= TrackPitch

;RET=
;HL = Pointer on Instrument moved forward
;HL''= Frequency
;	RETURN IN AUXILIARY REGISTERS
PLY_PS_CalculateFrequency_TestManualFrequency
	jr z,PLY_PS_CalculateFrequency
	;Manual Frequency We read it, no need to read Pitch and Arpeggio
	;However, we add TrackPitch to the read Frequency, and that''s all
	ld a,(hl)
	inc hl
	exx
	add a,e						;Add TrackPitch LSB
	ld l,a
	exx
	ld a,(hl)
	inc hl
	exx
	adc a,d						;Add TrackPitch HSB
	ld h,a
	ret




PLY_PS_CalculateFrequency
	;Pitch ?
	bit 5-1,b
	jr z,PLY_PS_S_SoundOn_NoPitch
	ld a,(hl)
	inc hl
	exx
	add a,e						;If Pitch found, add it directly to the TrackPitch
	ld e,a
	exx
	ld a,(hl)
	inc hl
	exx
	adc a,d
	ld d,a
	exx
	PLY_PS_S_SoundOn_NoPitch

	;Arpeggio ?
	ld a,e
	bit 4-1,b
	jr z,PLY_PS_S_SoundOn_ArpeggioEnd
	add a,(hl)					;Add Arpeggio to Note
	inc hl
	cp 144
	jr c,$+4
	ld a,143
	PLY_PS_S_SoundOn_ArpeggioEnd

	;Frequency calculation
	exx
	ld l,a
	ld h,0
	add hl,hl
	
	ld bc,PLY_FrequencyTable
	add hl,bc

	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	add hl,de					;Add TrackPitch + InstrumentPitch (if any)

	ret
















;Read one Track
;HL=Track Pointer

;Ret =
;HL=New Track Pointer
;Carry = 1 = Wait A lines Carry=0=Line not empty
;A=Wait (0(=256)-127), if Carry
;D=Parameters + Volume
;E=Note
;B=Instrument 0=RST
;IX=PitchAdd Only used if Pitch? = 1
PLY_ReadTrack
	ld a,(hl)
	inc hl
	srl a			;Full Optimisation ? If yes = Note only, no Pitch, no Volume, Same Instrument
	jr c,PLY_ReadTrack_FullOptimisation
	sub 32			;0-31 = Wait
	jr c,PLY_ReadTrack_Wait
	jr z,PLY_ReadTrack_NoOptimisation_EscapeCode
	dec a			;0 (32-32) = Escape Code for more Notes (parameters will be read)
	
	;Note Parameters are present But the note is only present if Note? flag is 1
	ld e,a			;Save Note

	;Read Parameters
PLY_ReadTrack_ReadParameters
	ld a,(hl)
	ld d,a			;Save Parameters
	inc hl

	rla			;Pitch ?
	jr nc,PLY_ReadTrack_Pitch_End
	ld b,(hl)		;Get PitchAdd
	ld ixl,b
	inc hl
	ld b,(hl)
	ld ixh,b
	inc hl
PLY_ReadTrack_Pitch_End

	rla			;Skip IsNote? flag
	rla			;New Instrument ?
	ret nc
	ld b,(hl)
	inc hl
	or a			;Remove Carry, as the player interpret it as a Wait command
	ret

;Escape code, read the Note and returns to read the Parameters
PLY_ReadTrack_NoOptimisation_EscapeCode
	ld e,(hl)
	inc hl
	jr PLY_ReadTrack_ReadParameters
	




PLY_ReadTrack_FullOptimisation
	;Note only, no Pitch, no Volume, Same Instrument
	ld d,%01000000			;Note only
	sub 1
	ld e,a
	ret nc
	ld e,(hl)			;Escape Code found (0) Read Note
	inc hl
	or a
	ret





PLY_ReadTrack_Wait
	add a,32
	ret







PLY_FrequencyTable
	if PLY_UseCPCMachine
	dw 3822,3608,3405,3214,3034,2863,2703,2551,2408,2273,2145,2025
	dw 1911,1804,1703,1607,1517,1432,1351,1276,1204,1136,1073,1012
	dw 956,902,851,804,758,716,676,638,602,568,536,506
	dw 478,451,426,402,379,358,338,319,301,284,268,253
	dw 239,225,213,201,190,179,169,159,150,142,134,127
	dw 119,113,106,100,95,89,84,80,75,71,67,63
	dw 60,56,53,50,47,45,42,40,38,36,34,32
	dw 30,28,27,25,24,22,21,20,19,18,17,16
	dw 15,14,13,13,12,11,11,10,9,9,8,8
	dw 7,7,7,6,6,6,5,5,5,4,4,4
	dw 4,4,3,3,3,3,3,2,2,2,2,2
	dw 2,2,2,2,1,1,1,1,1,1,1,1
	endif

	if PLY_UseMSXMachine
	dw 4095,4095,4095,4095,4095,4095,4095,4095,4095,4030,3804,3591
	dw 3389,3199,3019,2850,2690,2539,2397,2262,2135,2015,1902,1795
	dw 1695,1599,1510,1425,1345,1270,1198,1131,1068,1008,951,898
	dw 847,800,755,712,673,635,599,566,534,504,476,449
	dw 424,400,377,356,336,317,300,283,267,252,238,224
	dw 212,200,189,178,168,159,150,141,133,126,119,112
	dw 106,100,94,89,84,79,75,71,67,63,59,56
	dw 53,50,47,45,42,40,37,35,33,31,30,28
	dw 26,25,24,22,21,20,19,18,17,16,15,14
	dw 13,12,12,11,11,10,9,9,8,8,7,7
	dw 7,6,6,6,5,5,5,4,4,4,4,4
	dw 3,3,3,3,3,2,2,2,2,2,2,2
	endif



;DE = Music
PLY_Init
	if PLY_UseFirmwareInterruptions
	ld hl,8				;Skip Header, SampleChannel, YM Clock (DB*3) The Replay Frequency is used in Interruption mode
	add hl,de
	ld de,PLY_ReplayFrequency + 1
	ldi
	else
	ld hl,9				;Skip Header, SampleChannel, YM Clock (DB*3), and Replay Frequency
	add hl,de
	endif

	ld de,PLY_Speed + 1
	ldi				;Copy Speed
	ld c,(hl)			;Get Instruments chunk size
	inc hl
	ld b,(hl)
	inc hl
	ld (PLY_Track1_InstrumentsTablePT + 1),hl
	ld (PLY_Track2_InstrumentsTablePT + 1),hl
	ld (PLY_Track3_InstrumentsTablePT + 1),hl

	add hl,bc			;Skip Instruments to go to the Linker address
	;Get the pre-Linker information of the first pattern
	ld de,PLY_Height + 1
	ldi
	ld de,PLY_Transposition1 + 1
	ldi
	ld de,PLY_Transposition2 + 1
	ldi
	ld de,PLY_Transposition3 + 1
	ldi
	ld de,PLY_SaveSpecialTrack + 1
	ldi
	ldi
	ld (PLY_Linker_PT + 1),hl	;Get the Linker address

	ld a,1
	ld (PLY_SpeedCpt + 1),a
	ld (PLY_HeightCpt + 1),a

	ld a,#ff
	ld (PLY_PSGReg13),a
	
	;Set the Instruments pointers to Instrument 0 data (Header has to be skipped)
	ld hl,(PLY_Track1_InstrumentsTablePT + 1)
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	inc hl					;Skip Instrument 0 Header
	inc hl
	ld (PLY_Track1_Instrument + 1),hl
	ld (PLY_Track2_Instrument + 1),hl
	ld (PLY_Track3_Instrument + 1),hl
	ret



;Stop the music, cut the channels
PLY_Stop
	if PLY_SystemFriendly
	call PLY_DisableInterruptions
	ex af,af''
	exx
	push af
	push bc
	push ix
	push iy
	endif

	ld hl,PLY_PSGReg8
	ld bc,#0300
	ld (hl),c
	inc hl
	djnz $-2
	ld a,%00111111
	jp PLY_SendRegisters








	if PLY_UseSoundEffects

;Initialize the Sound Effects
;DE = SFX Music
PLY_SFX_Init
	;Find the Instrument Table
	ld hl,12
	add hl,de
	ld (PLY_SFX_Play_InstrumentTable + 1),hl
	
;Clear the three channels of any sound effect
PLY_SFX_StopAll
	ld hl,0
	ld (PLY_SFX_Track1_Instrument + 1),hl
	ld (PLY_SFX_Track2_Instrument + 1),hl
	ld (PLY_SFX_Track3_Instrument + 1),hl
	ret


PLY_SFX_OffsetPitch equ 0
PLY_SFX_OffsetVolume equ PLY_SFX_Track1_Volume - PLY_SFX_Track1_Pitch
PLY_SFX_OffsetNote equ PLY_SFX_Track1_Note - PLY_SFX_Track1_Pitch
PLY_SFX_OffsetInstrument equ PLY_SFX_Track1_Instrument - PLY_SFX_Track1_Pitch
PLY_SFX_OffsetSpeed equ PLY_SFX_Track1_InstrumentSpeed - PLY_SFX_Track1_Pitch
PLY_SFX_OffsetSpeedCpt equ PLY_SFX_Track1_InstrumentSpeedCpt - PLY_SFX_Track1_Pitch

;Plays a Sound Effects along with the music
;A = No Channel (0,1,2)
;L = SFX Number (>0)
;H = Volume (0F)
;E = Note (0143)
;D = Speed (0 = As original, 1255 = new Speed (1 is fastest))
;BC = Inverted Pitch (-#FFFF -> FFFF) 0 is no pitch The higher the pitch, the lower the sound
PLY_SFX_Play
	ld ix,PLY_SFX_Track1_Pitch
	or a
	jr z,PLY_SFX_Play_Selected
	ld ix,PLY_SFX_Track2_Pitch
	dec a
	jr z,PLY_SFX_Play_Selected
	ld ix,PLY_SFX_Track3_Pitch
	
PLY_SFX_Play_Selected
	ld (ix + PLY_SFX_OffsetPitch + 1),c	;Set Pitch
	ld (ix + PLY_SFX_OffsetPitch + 2),b
	ld a,e					;Set Note
	ld (ix + PLY_SFX_OffsetNote),a
	ld a,15					;Set Volume
	sub h
	ld (ix + PLY_SFX_OffsetVolume),a
	ld h,0					;Set Instrument Address
	add hl,hl
PLY_SFX_Play_InstrumentTable ld bc,0
	add hl,bc
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld a,d					;Read Speed or use the user''s one ?
	or a
	jr nz,PLY_SFX_Play_UserSpeed
	ld a,(hl)				;Get Speed
PLY_SFX_Play_UserSpeed
	ld (ix + PLY_SFX_OffsetSpeed + 1),a
	ld (ix + PLY_SFX_OffsetSpeedCpt + 1),a
	inc hl					;Skip Retrig
	inc hl
	ld (ix + PLY_SFX_OffsetInstrument + 1),l
	ld (ix + PLY_SFX_OffsetInstrument + 2),h

	ret

;Stops a sound effect on the selected channel
;E = No Channel (0,1,2)
;I used the E register instead of A so that Basic users can call this code in a straightforward way (call player+15, value)
PLY_SFX_Stop
	ld a,e
	ld hl,PLY_SFX_Track1_Instrument + 1
	or a
	jr z,PLY_SFX_Stop_ChannelFound
	ld hl,PLY_SFX_Track2_Instrument + 1
	dec a
	jr z,PLY_SFX_Stop_ChannelFound
	ld hl,PLY_SFX_Track3_Instrument + 1
	dec a

PLY_SFX_Stop_ChannelFound
	ld (hl),a
	inc hl
	ld (hl),a
	ret
	


	endif



	if PLY_UseFades
;Sets the Fade value
;E = Fade value (0 = full volume, 16 or more = no volume)
;I used the E register instead of A so that Basic users can call this code in a straightforward way (call player+9/+18, value)
PLY_SetFadeValue
	ld a,e
	ld (PLY_Channel1_FadeValue + 1),a
	ld (PLY_Channel2_FadeValue + 1),a
	ld (PLY_Channel3_FadeValue + 1),a
	ret

	endif




	if PLY_SystemFriendly
;Save Interrupt status and Disable Interruptions
PLY_DisableInterruptions
	ld a,i
	di
	;IFF in P/V flag
	;Prepare opcode for DI
	ld a,#f3
	jp po,PLY_DisableInterruptions_Set_Opcode
	;Opcode for EI
	ld a,#fb
PLY_DisableInterruptions_Set_Opcode
	ld (PLY_RestoreInterruption),a
	ret
	endif


;A little convient interface for BASIC user, to allow them to use Sound Effects in Basic
	if PLY_UseBasicSoundEffectInterface
PLY_BasicSoundEffectInterface_PlaySound
	ld c,(ix+0)	;Get Pitch
	ld b,(ix+1)
	ld d,(ix+2)	;Get Speed
	ld e,(ix+4)	;Get Note
	ld h,(ix+6)	;Get Volume
	ld l,(ix+8)	;Get SFX number
	ld a,(ix+10)	;Get Channel
	jp PLY_SFX_Play
	endif
;*** End of Arkos Tracker Player


;read "EG_WaveList2asm"
ProcessWave
; if game ended or lives out, dont process
    ld a,(Shield)
    cp a,#80
    ret z
; check delay to next enemy, if zero process next entry, else decrement and quit
    ld a,(WaveDelay)
    dec a
    jr z,SpawnNewEnemy
    ld (WaveDelay),a
    ret
SpawnNewEnemy
; map in wave data sprite bank
    ld a,#c5
    ld (CurrentBank),a
    ld b,#7f
    out (c),a
;find a vacant sprite slot, sprites are vacant when X coord is 128 or higher
    ld hl,SpritesYX+11
    ld b,6
SNEFindSlot
    bit 7,(hl)
    jr nz,SNEFoundSlot
    dec l
    dec l
    djnz SNEFindSlot
; no slot free, abort, and retrieve wait to next sprite and insert into wait
    ld hl,(WavePointer)
    ld de,8
    add hl,de
    jr SNEAbortEntry

SNEFoundSlot
; grab wave pointer and get start coords for new enemy to spawn
; data format can be found in EG_Wave_Export2asm
    ld de,(WavePointer)
    ld a,(de)
    cp a,#fe         ; if X coord is #fe, end of game reached
    jr z,SNEEndGame  ; so trigger end sequence
    ld (hl),a ; put X coord in SpriteYX table
    inc de
    dec l
    ld a,(de)
    ld (hl),a ; put Y coord in SpriteYX table
    set 4,l
    inc l
    ld (hl),0 ; clear sprite behaviour timer
    inc de
    ex de,hl ; now put wave source in hl
    ld a,b
    add a,a
    add a,a
    add a,a
    add a,#60-8
    ld e,a ; and SpriteData table entry in de based on entry still held in b
           ; d already contained 0 as de previously held ptr to SpriteYX
    ldi ; copy move 1
    ldi ; copy move 2
    ldi ; copy rocker
    ldi ; copy timer reset point
    ld a,(hl) ; get sprite id ptr
    inc hl
    push hl ; save wave ptr so can get frame # animation data from lookup table SpriteLookup
    ld c,a
    add a,a
    add a,c ; a = a*3
    add a,#d0 ; SpriteLookup starts at #d0
    ld h,d ; set h=0
    ld l,a
    ldi ; copy base sprite frame to SpriteData entry
    ldi ; animation type and start offset
    ldi ; max offset or direction, depending on animation type
    pop hl ; get wave data pointer back
    ldi ; copy enemy shield strength
SNEAbortEntry
    ld a,(hl) ; get wait until next enemy is to be spawned
    or a ; check if not creating two enemies at once
    jr nz,SNEWaitfornextEnemy
; spawn additional enemy in same frame if wait is 0
    inc hl
    ld (WavePointer),hl
    jr SpawnNewEnemy
SNEGameNotQuiteWon ; entry from SNEEndGame below
; if reach end of game after final life lost, put dummy values in wave process
; pointers and wait for game over time out as normal
    ld hl,wave_data-1
SNEWaitfornextEnemy
; write delay and pointer to next enemy
    inc hl
    ld (WavePointer),hl
    ld (WaveDelay),a
SNECommonExit
; map out wave data sprite bank
    ld a,#c0
    ld (CurrentBank),a
    ld b,#7f
    out (c),a
    ret

SNEEndGame
; end of game reached
    ld a,(Lives)
    or a ;   check if lives not 0
    jr z,SNEGameNotQuiteWon ; in which case, continue with game over sequence
; put lives into bonus marker
    ld (MegaBonus),a
    ld a,50
    ld (BonusWait),a ; just used to space the 5000 point bonus for each life apart
; set player sprite status
    ld a,#80
    ld (Shield),a
; copy player location to sprite 1 for flying offscreen animation
; required as player sprite is compiled and would require a fix to fly
; off of screen edge
    ld hl,SpritesYX+12
    ld de,SpritesYX
    ldi
    ldi
    ld hl,SpriteData
    ld (hl),64+3
    inc l
    ld (hl),64+3
    inc l
    ld (hl),0
    inc l
    ld (hl),0
    inc l
    ld (hl),11
    inc l
    ld a,(PlayerFrame)
    add a,64
    ld (hl),a
    inc l
    ld (hl),7
; now put player sprite below visible screen so does not interfere with end seq
; with the background save and restore being offset by a pixel between frames
    ld a,192
    ld (SpritesYX+12),a
; set up pause to clear enemy sprite from visible screen address space
    ld a,3 ; this ensures enemy sprite used to show player flying off screen has it''s
    ld (GameCompletePlyrClear+1),a ; screen addresses set offscreen for both frames
                                   ; to avoid old background being written over end sequence
    jr SNECommonExit ; use common exit above to map out wave data bank


;read "MegaHeroasm"
HeroText ; defines character grid for game won screen
    defb 160,40,170,168,42,160,42,160
    defb 168,169,165,85,165,84,165,104
    defb 170,169,170,0,164,0,164,41
    defb 166,105,165,64,164,40,170,169
    defb 164,105,164,0,164,41,165,105
    defb 164,41,170,168,42,165,164,41
    defb 20,5,21,85,5,84,20,5
    defb 160,40,170,168,170,160,42,160
    defb 164,41,165,85,165,104,165,104
    defb 170,169,170,0,164,41,164,41
    defb 165,105,165,64,170,165,164,41
    defb 164,41,164,0,165,104,164,41
    defb 164,41,170,168,164,41,42,165
    defb 20,5,21,85,20,5,5,84


; more default starting values, copied to #118
SetupVariables
;base_addr
dw #c000

;paint_addr
dw #c04d

;scroll_step
db 0

;scroll
db 0

;ZSCharPtr
    defw ZoomScrollMsg-1

;ZSCharCol
    defb 7

;HighZoomScrlOffset
    defw 0
;LowZoomScrlOffset
    defw 0

;ResetYX
defb 232,16+48

;ResetHigh
defb 0
;ResetLow
defb 0

;ScoreASC
defb 0,0,0,0,0,0

;ScoreDisplay
defs 3

;ScoreH
defb 0
;ScoreM
defb 0
;ScoreL
defb 0

;ScoreFrame
defb 0
defb 0

;Lives
defb 3
;Shield
defb 0
;ExplosionSet
defb 0

;ReturnToMenu
defb 0
;WaveDelay
defb 23
;WavePointer
defw wave_data

;EndCharPtr
defb 0
;MegaPtr
defw HeroText
;MegaByte
defb 0
;HeroPtr
defw HeroText+111
;HeroByte
defb 0
;CompleteWait
defb 0

;ScorePtr
defb 0
;CurrentBank
defb #c0
;GrindState
defb 0

;LivesUpdPtr
defb 0
;MegaBonus
defb 0
;BonusWait
defb 0

EndEG

; arkos music (x2)
org #26d7


; won4 / music
db #41,#54,#31,#30,#01,#40,#42,#0f
db #02,#06,#7d,#00,#ef,#26,#f8,#26
db #ff,#26,#11,#27,#23,#27,#39,#27
db #00,#00,#00,#00,#00,#00,#0d,#f1
db #26,#01,#fe,#05,#2c,#0d,#fa,#26
db #01,#00,#7e,#25,#09,#7a,#21,#06
db #78,#04,#78,#02,#38,#30,#2c,#0d
db #0d,#27,#03,#00,#3c,#38,#34,#30
db #34,#34,#34,#30,#ac,#ff,#ff,#28
db #28,#0d,#1b,#27,#02,#00,#3c,#78
db #0c,#34,#70,#0c,#34,#78,#0c,#34
db #f0,#ff,#ff,#0c,#2c,#6c,#0c,#0d
db #2f,#27,#09,#00,#be,#2e,#10,#00
db #3a,#2e,#b6,#2e,#10,#00,#32,#2e
db #ae,#2e,#10,#00,#2a,#2e,#a6,#2e
db #10,#00,#22,#2e,#9e,#2e,#10,#00
db #1a,#2e,#16,#2e,#12,#2e,#0d,#f1
db #26,#28,#00,#fd,#f9,#02,#28,#00
db #71,#29,#71,#29,#71,#29,#1c,#00
db #00,#22,#29,#65,#29,#08,#28,#20
db #0c,#fd,#fe,#22,#29,#71,#29,#08
db #28,#0c,#00,#fc,#22,#29,#03,#28
db #08,#28,#0c,#fd,#fb,#22,#29,#71
db #29,#08,#28,#0c,#00,#00,#22,#29
db #39,#28,#08,#28,#08,#fe,#22,#29
db #45,#28,#08,#28,#08,#fc,#22,#29
db #54,#28,#08,#28,#18,#f7,#22,#29
db #65,#28,#08,#28,#1f,#18,#00,#03
db #28,#03,#28,#6d,#29,#01,#10,#8d
db #28,#39,#28,#08,#28,#20,#08,#fe
db #8d,#28,#45,#28,#08,#28,#08,#fc
db #8d,#28,#54,#28,#08,#28,#08,#f7
db #8d,#28,#6e,#28,#08,#28,#0c,#0c
db #00,#22,#29,#da,#28,#08,#28,#08
db #fe,#22,#29,#da,#28,#08,#28,#0c
db #00,#fc,#8d,#28,#da,#28,#08,#28
db #08,#03,#8d,#28,#7a,#29,#08,#28
db #01,#6d,#27,#00,#42,#80,#00,#00
db #00,#78,#e0,#00,#00,#01,#08,#42
db #60,#00,#78,#60,#01,#02,#78,#60
db #02,#04,#42,#60,#00,#60,#60,#01
db #39,#02,#21,#39,#08,#42,#60,#00
db #78,#60,#01,#02,#78,#60,#02,#02
db #39,#02,#78,#60,#01,#02,#78,#60
db #02,#00,#b6,#e1,#00,#00,#03,#2e
db #77,#02,#79,#06,#7d,#00,#42,#80
db #00,#00,#1a,#c6,#60,#03,#12,#87
db #02,#8b,#06,#87,#00,#42,#80,#00
db #00,#1a,#c0,#60,#03,#0e,#7d,#02
db #81,#02,#8b,#06,#87,#00,#42,#80
db #00,#00,#1a,#bc,#60,#03,#00,#42
db #80,#00,#00,#1a,#ce,#60,#03,#10
db #42,#80,#04,#00,#42,#00,#42,#00
db #42,#00,#42,#00,#42,#00,#42,#00
db #42,#80,#08,#00,#42,#00,#a8,#e1
db #00,#00,#04,#ae,#47,#ae,#41,#a8
db #47,#b6,#63,#05,#ae,#67,#04,#bc
db #41,#b6,#47,#a8,#41,#bc,#47,#b6
db #41,#c0,#47,#ba,#63,#05,#b6,#67
db #04,#b6,#41,#bc,#47,#a8,#41,#b6
db #47,#ae,#41,#a8,#47,#b6,#63,#05
db #ae,#67,#04,#bc,#41,#b6,#47,#bc
db #41,#c0,#47,#b6,#41,#c6,#47,#ba
db #63,#05,#b6,#67,#04,#ba,#63,#05
db #bc,#67,#04,#ce,#e3,#00,#00,#03
db #04,#42,#60,#00,#ca,#60,#03,#42
db #60,#00,#c6,#60,#03,#04,#42,#60
db #00,#c0,#60,#03,#04,#42,#60,#00
db #bc,#60,#03,#42,#60,#00,#c0,#60
db #03,#02,#42,#60,#00,#c6,#60,#03
db #02,#42,#60,#00,#ca,#60,#03,#42
db #60,#00,#c6,#60,#03,#04,#42,#60
db #00,#c0,#60,#03,#42,#60,#00,#bc
db #60,#03,#00,#a8,#e3,#00,#00,#04
db #c6,#49,#b6,#43,#a8,#49,#ae,#43
db #b6,#49,#ac,#43,#ae,#49,#bc,#43
db #ac,#49,#c0,#43,#bc,#49,#b6,#43
db #c0,#49,#c6,#43,#b6,#49,#a8,#43
db #c6,#49,#b6,#43,#a8,#49,#ae,#43
db #b6,#49,#ac,#43,#ae,#49,#bc,#43
db #ac,#49,#c0,#43,#bc,#49,#c4,#43
db #c0,#49,#b6,#43,#c4,#49,#42,#60
db #00,#42,#80,#00,#00,#00,#42,#81
db #00,#00,#72,#e1,#00,#00,#05,#32
db #42,#1f,#00,#ce,#e0,#00,#00,#03
db #04,#42,#60,#00,#ca,#60,#03,#42
db #60,#00,#c6,#60,#03,#04,#42,#60
db #00,#c0,#60,#03,#04,#42,#60,#00
db #bc,#60,#03,#42,#60,#00,#c0,#60
db #03,#02,#42,#60,#00,#c6,#60,#03
db #02,#42,#60,#00,#ca,#60,#03,#42
db #60,#00,#ce,#60,#03,#02,#42,#60
db #00,#ca,#60,#03,#02,#42,#60,#00
db #c6,#60,#03,#00

; edgea / music
main_sound_track
db #41,#54,#31,#30,#01,#40,#42,#0f
db #02,#03,#a9,#01,#f3,#29,#fc,#29
db #25,#2a,#36,#2a,#41,#2a,#57,#2a
db #75,#2a,#84,#2a,#9f,#2a,#ba,#2a
db #ce,#2a,#e2,#2a,#f6,#2a,#0a,#2b
db #1e,#2b,#30,#2b,#42,#2b,#5d,#2b
db #00,#00,#00,#00,#00,#00,#0d,#f5
db #29,#06,#fe,#05,#2c,#05,#2c,#05
db #2c,#05,#2c,#05,#2c,#05,#2c,#05
db #2c,#05,#2c,#05,#2c,#05,#2c,#05
db #2c,#05,#2c,#25,#2c,#ff,#25,#2c
db #fe,#25,#2c,#fd,#25,#2c,#fc,#0d
db #f5,#29,#01,#00,#38,#38,#3c,#38
db #34,#30,#34,#38,#38,#38,#34,#30
db #0d,#32,#2a,#03,#00,#34,#00,#34
db #00,#34,#00,#0d,#f5,#29,#01,#00
db #7a,#25,#09,#78,#06,#78,#04,#78
db #02,#38,#30,#2c,#2c,#2c,#2c,#2c
db #2c,#0d,#f5,#29,#01,#00,#3e,#39
db #7e,#34,#03,#7e,#2c,#0c,#36,#29
db #32,#28,#2e,#26,#2a,#26,#26,#26
db #22,#26,#1e,#26,#68,#01,#28,#0d
db #f5,#29,#01,#00,#00,#7c,#0c,#3c
db #3c,#38,#38,#38,#34,#30,#0d,#f5
db #29,#04,#00,#34,#78,#04,#7c,#07
db #74,#0c,#74,#07,#70,#04,#34,#70
db #04,#74,#07,#70,#0c,#6c,#07,#6c
db #04,#0d,#91,#2a,#04,#00,#34,#78
db #03,#7c,#07,#74,#0c,#74,#07,#70
db #03,#34,#70,#03,#74,#07,#70,#0c
db #6c,#07,#6c,#03,#0d,#ac,#2a,#02
db #00,#38,#78,#05,#78,#08,#78,#0c
db #78,#11,#78,#0c,#78,#08,#78,#05
db #0d,#bc,#2a,#02,#00,#38,#78,#05
db #78,#08,#78,#0c,#78,#0f,#78,#0c
db #78,#08,#78,#05,#0d,#d0,#2a,#02
db #00,#38,#78,#05,#78,#08,#78,#0a
db #78,#0e,#78,#0a,#78,#08,#78,#05
db #0d,#e4,#2a,#02,#00,#38,#78,#05
db #78,#08,#78,#0c,#78,#0f,#78,#0c
db #78,#08,#78,#05,#0d,#f8,#2a,#02
db #00,#38,#78,#04,#78,#07,#78,#0b
db #78,#0c,#78,#0b,#78,#07,#78,#04
db #0d,#0c,#2b,#01,#00,#3c,#3c,#38
db #38,#34,#34,#b0,#ff,#ff,#30,#30
db #30,#30,#0d,#26,#2b,#01,#00,#38
db #38,#38,#38,#74,#0c,#74,#0c,#74
db #0c,#74,#0c,#30,#0d,#3e,#2b,#04
db #00,#34,#78,#03,#7c,#06,#74,#09
db #74,#06,#70,#03,#34,#70,#03,#74
db #06,#70,#09,#6c,#06,#6c,#03,#0d
db #4f,#2b,#02,#00,#34,#78,#04,#7c
db #07,#74,#0c,#74,#07,#70,#04,#34
db #70,#04,#74,#07,#70,#0c,#6c,#07
db #6c,#04,#0d,#6a,#2b,#20,#00,#00
db #00,#69,#2e,#38,#00,#6d,#2e,#a4
db #31,#d3,#3d,#20,#69,#2e,#02,#03
db #f8,#36,#f8,#36,#d3,#3d,#08,#03
db #6d,#2e,#f8,#36,#d3,#3d,#02,#00
db #f8,#36,#f8,#36,#d3,#3d,#0a,#08
db #08,#6d,#2e,#f8,#36,#d3,#3d,#02
db #00,#f8,#36,#f8,#36,#d3,#3d,#0a
db #05,#05,#6d,#2e,#f8,#36,#d3,#3d
db #02,#00,#f8,#36,#f8,#36,#d3,#3d
db #08,#00,#6d,#2e,#75,#2e,#d3,#3d
db #18,#03,#6d,#2e,#75,#2e,#d3,#3d
db #40,#28,#08,#d0,#2e,#75,#2e,#d3
db #3d,#67,#2e,#28,#00,#6d,#2e,#75
db #2e,#d3,#3d,#65,#2e,#00,#d0,#2e
db #75,#2e,#a1,#2e,#00,#1d,#2f,#75
db #2e,#d8,#2e,#00,#3a,#2f,#75,#2e
db #d8,#2e,#00,#1d,#2f,#5e,#2f,#9c
db #2f,#00,#3a,#2f,#5e,#2f,#9c,#2f
db #00,#8a,#33,#5e,#2f,#9c,#2f,#00
db #a7,#33,#62,#31,#9c,#2f,#02,#0c
db #50,#31,#52,#30,#9c,#2f,#00,#5a
db #31,#d0,#30,#f7,#2f,#00,#50,#31
db #52,#30,#9c,#2f,#00,#5a,#31,#d0
db #30,#f7,#2f,#10,#2a,#32,#a4,#31
db #ac,#31,#20,#02,#00,#a4,#31,#ac
db #31,#74,#32,#00,#a4,#31,#ac,#31
db #74,#32,#00,#d8,#2e,#ac,#31,#74
db #32,#10,#d8,#2e,#ac,#31,#74,#32
db #40,#10,#d8,#2e,#a4,#31,#74,#32
db #20,#00,#d8,#2e,#a4,#31,#74,#32
db #10,#e4,#31,#a4,#31,#fe,#32,#42
db #10,#d8,#2e,#a4,#31,#be,#32,#20
db #10,#d8,#2e,#a4,#31,#52,#30,#40
db #10,#d8,#2e,#a4,#31,#52,#30,#20
db #00,#e4,#31,#a4,#31,#52,#30,#10
db #d8,#2e,#a4,#31,#d0,#30,#40,#00
db #d8,#2e,#3a,#33,#52,#30,#00,#d8
db #2e,#52,#30,#75,#2e,#00,#e4,#31
db #d0,#30,#75,#2e,#00,#d8,#2e,#52
db #30,#3a,#33,#0e,#03,#03,#03,#d8
db #2e,#52,#30,#75,#2e,#00,#e4,#31
db #d0,#30,#75,#2e,#0e,#00,#00,#00
db #d8,#2e,#52,#30,#75,#2e,#00,#f7
db #33,#3b,#34,#cb,#33,#00,#b9,#34
db #29,#35,#fd,#34,#00,#a5,#35,#15
db #36,#e9,#35,#00,#d8,#2e,#52,#30
db #93,#36,#00,#d8,#2e,#d0,#30,#fd
db #36,#00,#d8,#2e,#52,#30,#93,#36
db #00,#d8,#2e,#d0,#30,#c5,#36,#00
db #94,#39,#52,#30,#93,#36,#00,#86
db #39,#52,#30,#a4,#31,#00,#94,#39
db #52,#30,#a4,#31,#00,#86,#39,#d0
db #30,#b1,#39,#00,#86,#39,#d0,#30
db #d6,#39,#00,#86,#39,#d0,#30,#b1
db #39,#00,#d8,#2e,#52,#30,#7a,#38
db #00,#d8,#2e,#52,#30,#c2,#38,#00
db #d8,#2e,#d0,#30,#48,#39,#00,#d8
db #2e,#52,#30,#c2,#38,#00,#86,#39
db #d0,#30,#7a,#38,#00,#86,#39,#d0
db #30,#7a,#38,#00,#86,#39,#d0,#30
db #0a,#39,#30,#d8,#2e,#a1,#2e,#f8
db #36,#20,#69,#2e,#30,#d8,#2e,#a1
db #2e,#f8,#36,#40,#6b,#2e,#22,#f4
db #31,#37,#59,#37,#a9,#37,#65,#2e
db #00,#02,#38,#59,#37,#a9,#37,#00
db #02,#38,#59,#37,#a9,#37,#02,#00
db #2d,#3b,#72,#3b,#cb,#3b,#00,#28
db #3c,#6a,#3c,#c3,#3c,#00,#2d,#3b
db #72,#3b,#cb,#3b,#00,#28,#3c,#6a
db #3c,#c3,#3c,#00,#2d,#3b,#6a,#3d
db #07,#3d,#04,#fe,#2d,#3b,#6a,#3d
db #07,#3d,#04,#00,#2d,#3b,#6a,#3d
db #07,#3d,#04,#fe,#2d,#3b,#6a,#3d
db #07,#3d,#04,#00,#2d,#3b,#72,#3b
db #07,#3d,#08,#08,#2d,#3b,#72,#3b
db #07,#3d,#08,#0c,#28,#3c,#6a,#3c
db #07,#3d,#08,#00,#a4,#31,#07,#3d
db #f8,#36,#06,#fe,#fe,#3e,#38,#59
db #37,#a9,#37,#06,#f4,#00,#02,#38
db #a1,#2e,#75,#2e,#00,#02,#38,#a4
db #31,#75,#2e,#02,#00,#52,#30,#a4
db #31,#75,#2e,#00,#d0,#30,#a4,#31
db #75,#2e,#00,#52,#30,#a4,#31,#75
db #2e,#00,#d0,#30,#a4,#31,#75,#2e
db #00,#f1,#39,#15,#3a,#1b,#3a,#00
db #f1,#39,#15,#3a,#cc,#3a,#00,#55
db #3a,#79,#3a,#81,#3a,#00,#9e,#3a
db #c2,#3a,#12,#3b,#00,#f1,#39,#15
db #3a,#1b,#3a,#00,#f1,#39,#15,#3a
db #cc,#3a,#00,#55,#3a,#79,#3a,#81
db #3a,#00,#9e,#3a,#c2,#3a,#1c,#3b
db #00,#a4,#31,#a4,#31,#d3,#3d,#08
db #0c,#a4,#31,#a4,#31,#d3,#3d,#01
db #7e,#2b,#0d,#00,#11,#00,#11,#00
db #19,#00,#66,#e0,#00,#00,#01,#3e
db #2d,#00,#ae,#e1,#00,#00,#02,#06
db #7d,#06,#6f,#02,#7d,#06,#6f,#02
db #79,#06,#6f,#02,#79,#06,#6f,#02
db #79,#06,#6f,#06,#75,#06,#6f,#02
db #75,#06,#6f,#02,#79,#06,#6f,#02
db #75,#06,#6f,#02,#79,#00,#42,#80
db #00,#00,#02,#ae,#6d,#02,#06,#7d
db #06,#6f,#02,#7d,#06,#6f,#02,#79
db #06,#6f,#02,#79,#06,#6f,#02,#79
db #06,#6f,#06,#75,#06,#6f,#02,#75
db #06,#6f,#02,#79,#06,#6f,#02,#79
db #06,#6f,#02,#75,#00,#5e,#e0,#00
db #00,#01,#3e,#23,#00,#ae,#e0,#00
db #00,#03,#75,#7d,#c6,#43,#7d,#75
db #6f,#75,#7d,#87,#7d,#75,#6f,#75
db #7d,#6f,#75,#7d,#83,#7d,#75,#6f
db #75,#7d,#83,#7d,#75,#6f,#75,#7d
db #83,#7d,#6f,#75,#79,#7d,#79,#75
db #6f,#75,#79,#7d,#79,#75,#6f,#75
db #79,#7d,#6f,#75,#79,#87,#7d,#75
db #6f,#75,#79,#87,#7d,#75,#6f,#75
db #79,#6f,#66,#e0,#00,#00,#01,#3e
db #2d,#1c,#42,#60,#00,#6c,#60,#01
db #08,#42,#60,#00,#6c,#60,#01,#08
db #42,#60,#00,#6c,#60,#01,#00,#5e
db #e0,#00,#00,#01,#2c,#42,#60,#00
db #5e,#60,#01,#0e,#23,#1c,#42,#60
db #00,#62,#60,#01,#08,#42,#60,#00
db #62,#60,#01,#08,#42,#60,#00,#62
db #60,#01,#00,#7e,#e0,#00,#00,#04
db #06,#3f,#02,#96,#60,#05,#06,#57
db #02,#7e,#60,#04,#06,#3f,#06,#3f
db #02,#96,#60,#05,#06,#57,#02,#57
db #06,#7e,#60,#04,#06,#3f,#02,#96
db #60,#05,#06,#57,#02,#7e,#60,#04
db #0a,#3f,#06,#3f,#3f,#7e,#60,#05
db #02,#7e,#60,#04,#02,#3f,#02,#3f
db #00,#ae,#e3,#00,#00,#06,#02,#ae
db #49,#02,#bc,#43,#02,#bc,#49,#02
db #ae,#43,#02,#7d,#02,#bc,#49,#02
db #ae,#43,#02,#79,#02,#b8,#49,#02
db #ae,#43,#02,#79,#02,#b8,#49,#02
db #ae,#43,#02,#79,#02,#b8,#49,#02
db #ae,#43,#02,#ae,#49,#02,#b4,#43
db #02,#b4,#49,#02,#ae,#43,#02,#75
db #02,#b4,#49,#02,#ae,#43,#02,#79
db #02,#b8,#49,#02,#ae,#43,#02,#79
db #02,#b8,#49,#02,#ae,#43,#02,#75
db #02,#b4,#49,#00,#a6,#e3,#00,#00
db #06,#02,#a6,#49,#02,#bc,#43,#02
db #bc,#49,#02,#a6,#43,#02,#7d,#02
db #bc,#49,#02,#a6,#43,#02,#79,#02
db #b8,#49,#02,#a6,#43,#02,#79,#02
db #b8,#49,#02,#a6,#43,#02,#79,#02
db #b8,#49,#02,#a6,#43,#02,#a6,#49
db #02,#b4,#43,#02,#b4,#49,#02,#a6
db #43,#02,#75,#02,#b4,#49,#02,#a6
db #43,#02,#79,#02,#b8,#49,#02,#aa
db #43,#02,#79,#02,#b8,#49,#02,#aa
db #43,#02,#75,#02,#b4,#49,#00,#7e
db #e1,#00,#00,#04,#02,#66,#60,#01
db #02,#7e,#60,#04,#02,#96,#60,#05
db #02,#66,#60,#01,#02,#96,#60,#05
db #02,#7e,#60,#04,#02,#66,#60,#01
db #02,#7e,#60,#04,#02,#66,#60,#01
db #02,#7e,#60,#04,#02,#96,#60,#05
db #02,#66,#60,#01,#02,#96,#60,#05
db #02,#57,#02,#66,#60,#01,#02,#7e
db #60,#04,#02,#6c,#60,#01,#02,#7e
db #60,#04,#02,#96,#60,#05,#02,#6c
db #60,#01,#02,#96,#60,#05,#02,#7e
db #60,#04,#02,#6c,#60,#01,#02,#2d
db #02,#7e,#60,#04,#02,#6c,#60,#01
db #02,#7e,#60,#04,#3f,#7e,#60,#05
db #02,#7e,#60,#04,#02,#6c,#60,#01
db #02,#7e,#60,#04,#00,#7e,#e0,#00
db #00,#04,#02,#5e,#60,#01,#02,#7e
db #60,#04,#02,#96,#60,#05,#02,#5e
db #60,#01,#02,#96,#60,#05,#02,#7e
db #60,#04,#02,#5e,#60,#01,#02,#7e
db #60,#04,#02,#5e,#60,#01,#02,#7e
db #60,#04,#02,#96,#60,#05,#02,#5e
db #60,#01,#02,#96,#60,#05,#02,#57
db #02,#5e,#60,#01,#02,#7e,#60,#04
db #02,#62,#60,#01,#02,#7e,#60,#04
db #02,#96,#60,#05,#02,#62,#60,#01
db #02,#96,#60,#05,#02,#7e,#60,#04
db #02,#96,#60,#05,#02,#62,#60,#01
db #02,#7e,#60,#04,#02,#62,#60,#01
db #02,#7e,#60,#04,#3f,#7e,#60,#05
db #02,#7e,#60,#04,#02,#62,#60,#01
db #02,#7e,#60,#04,#00,#96,#e1,#00
db #00,#07,#3e,#96,#60,#08,#00,#9c
db #e0,#00,#00,#07,#3e,#6b,#00,#7e
db #e0,#00,#00,#04,#06,#3f,#02,#96
db #60,#05,#06,#57,#02,#3f,#06,#7e
db #60,#04,#06,#3f,#02,#96,#60,#05
db #06,#57,#02,#57,#06,#7e,#60,#04
db #06,#3f,#02,#96,#60,#05,#06,#57
db #02,#7e,#60,#04,#06,#57,#02,#3f
db #06,#3f,#02,#7e,#60,#05,#02,#7e
db #60,#04,#02,#96,#60,#05,#02,#57
db #57,#42,#60,#00,#42,#9f,#00,#00
db #00,#42,#80,#00,#00,#02,#7e,#61
db #04,#02,#3f,#02,#7e,#43,#02,#3f
db #02,#7e,#40,#02,#7e,#45,#02,#7e
db #47,#02,#7e,#49,#02,#7e,#4b,#1e
db #7e,#41,#02,#3f,#02,#7e,#43,#02
db #3f,#02,#7e,#45,#02,#7e,#47,#02
db #7e,#49,#02,#7e,#4b,#02,#7e,#4d
db #00,#ae,#e0,#00,#00,#03,#75,#7d
db #87,#7d,#75,#6f,#75,#7d,#87,#7d
db #75,#6f,#75,#7d,#6f,#75,#7d,#83
db #7d,#75,#6f,#75,#7d,#83,#7d,#75
db #6f,#75,#7d,#83,#7d,#6f,#75,#79
db #7d,#79,#75,#6f,#75,#79,#7d,#79
db #75,#6f,#75,#79,#7d,#6f,#75,#79
db #7f,#7d,#75,#6f,#75,#79,#7f,#7d
db #75,#6f,#75,#79,#6f,#75,#79,#ae
db #e5,#00,#00,#07,#42,#80,#04,#00
db #42,#00,#42,#00,#42,#00,#42,#00
db #42,#07,#42,#00,#42,#80,#06,#00
db #42,#00,#42,#00,#42,#00,#42,#09
db #42,#00,#42,#00,#42,#00,#42,#80
db #08,#00,#42,#00,#42,#00,#42,#00
db #42,#0b,#42,#00,#42,#00,#42,#00
db #42,#0d,#42,#00,#42,#00,#42,#0f
db #42,#00,#42,#11,#42,#80,#00,#00
db #00,#42,#80,#00,#00,#02,#66,#60
db #01,#08,#42,#60,#00,#66,#60,#01
db #08,#42,#60,#00,#66,#60,#01,#04
db #42,#60,#00,#66,#60,#01,#08,#42
db #60,#00,#66,#60,#01,#08,#42,#60
db #00,#66,#60,#01,#06,#2d,#08,#42
db #60,#00,#6c,#60,#01,#08,#42,#60
db #00,#6c,#60,#01,#04,#42,#60,#00
db #6c,#60,#01,#0c,#42,#60,#00,#6c
db #60,#01,#00,#7e,#e1,#00,#00,#04
db #02,#66,#60,#01,#02,#7e,#60,#04
db #02,#96,#60,#05,#02,#66,#60,#01
db #02,#96,#60,#05,#02,#7e,#60,#04
db #02,#66,#60,#01,#02,#7e,#60,#04
db #02,#66,#60,#01,#02,#7e,#60,#04
db #02,#96,#60,#05,#02,#66,#60,#01
db #02,#96,#60,#05,#02,#57,#02,#66
db #60,#01,#00,#42,#80,#00,#00,#02
db #66,#60,#01,#0a,#27,#0a,#27,#06
db #27,#0a,#27,#0a,#27,#06,#2d,#08
db #42,#60,#00,#6c,#60,#01,#08,#42
db #60,#00,#6c,#60,#01,#04,#42,#60
db #00,#6c,#60,#01,#06,#7e,#61,#04
db #42,#60,#00,#7e,#60,#04,#02,#3f
db #02,#3f,#02,#3f,#02,#3f,#00,#bc
db #fd,#00,#00,#02,#02,#42,#1b,#02
db #42,#19,#02,#42,#17,#02,#42,#15
db #02,#42,#13,#02,#42,#11,#02,#42
db #0f,#02,#42,#0d,#02,#42,#0b,#08
db #42,#09,#08,#42,#07,#0e,#42,#05
db #0e,#42,#03,#0e,#42,#01,#06,#42
db #80,#04,#00,#42,#80,#08,#00,#42
db #80,#0c,#00,#42,#80,#10,#00,#42
db #80,#14,#00,#42,#80,#18,#00,#42
db #80,#1c,#00,#42,#80,#20,#00,#66
db #e0,#00,#00,#01,#3e,#2d,#1c,#42
db #60,#00,#6c,#60,#01,#08,#42,#60
db #00,#6c,#60,#01,#08,#42,#60,#00
db #6c,#60,#01,#00,#76,#e0,#00,#00
db #01,#2c,#42,#60,#00,#76,#60,#01
db #0e,#31,#1c,#42,#60,#00,#70,#60
db #01,#08,#42,#60,#00,#70,#60,#01
db #08,#42,#60,#00,#74,#60,#01,#00
db #ac,#e0,#00,#00,#02,#06,#7d,#06
db #6d,#02,#7d,#06,#6d,#02,#79,#06
db #6d,#02,#79,#06,#6d,#02,#79,#06
db #6d,#06,#75,#06,#6d,#02,#75,#06
db #6d,#02,#79,#06,#6d,#02,#75,#06
db #6d,#02,#79,#00,#ac,#e0,#00,#00
db #03,#75,#7d,#85,#7d,#75,#6d,#75
db #7d,#85,#7d,#75,#6d,#75,#7d,#6d
db #6d,#75,#7d,#87,#7d,#75,#6d,#75
db #7d,#87,#7d,#75,#6d,#75,#7d,#87
db #6d,#75,#79,#7d,#79,#75,#6d,#75
db #79,#7d,#79,#75,#6d,#75,#79,#7d
db #6d,#75,#79,#85,#7d,#75,#6d,#75
db #79,#85,#7d,#75,#6d,#75,#79,#6d
db #7c,#e1,#00,#00,#04,#02,#64,#60
db #01,#02,#7c,#60,#04,#02,#94,#60
db #05,#02,#64,#60,#01,#02,#94,#60
db #05,#02,#7c,#60,#04,#02,#64,#60
db #01,#02,#7c,#60,#04,#02,#64,#60
db #01,#02,#7c,#60,#04,#02,#94,#60
db #05,#02,#64,#60,#01,#02,#94,#60
db #05,#02,#55,#02,#64,#60,#01,#02
db #7c,#60,#04,#02,#6c,#60,#01,#02
db #7c,#60,#04,#02,#94,#60,#05,#02
db #6c,#60,#01,#02,#94,#60,#05,#02
db #7c,#60,#04,#02,#6c,#60,#01,#02
db #2d,#02,#7c,#60,#04,#02,#6c,#60
db #01,#02,#7c,#60,#04,#3d,#7c,#60
db #05,#02,#7c,#60,#04,#02,#6c,#60
db #01,#02,#7c,#60,#04,#00,#aa,#e0
db #00,#00,#03,#75,#7d,#83,#7d,#75
db #6b,#75,#7d,#83,#7d,#75,#6b,#75
db #7d,#83,#6b,#75,#7d,#85,#7d,#75
db #6b,#75,#7d,#85,#7d,#75,#6b,#75
db #7d,#85,#6d,#75,#7d,#87,#7d,#75
db #6d,#75,#7d,#87,#7d,#75,#6d,#75
db #7d,#87,#6b,#75,#7d,#83,#7d,#75
db #6b,#75,#7d,#83,#7d,#75,#6b,#75
db #7d,#83,#aa,#e0,#00,#00,#02,#06
db #7d,#06,#6b,#02,#7d,#06,#6b,#02
db #83,#06,#6b,#02,#83,#06,#6b,#02
db #83,#06,#6b,#06,#79,#06,#6b,#02
db #79,#06,#6b,#02,#7d,#06,#6b,#02
db #79,#06,#6b,#02,#75,#00,#84,#e1
db #00,#00,#04,#02,#6c,#60,#01,#02
db #84,#60,#04,#02,#9c,#60,#05,#02
db #6c,#60,#01,#02,#9c,#60,#05,#02
db #84,#60,#04,#02,#6c,#60,#01,#02
db #84,#60,#04,#02,#6c,#60,#01,#02
db #84,#60,#04,#02,#9c,#60,#05,#02
db #6c,#60,#01,#02,#9c,#60,#05,#02
db #5d,#02,#6c,#60,#01,#02,#84,#60
db #04,#02,#6c,#60,#01,#02,#7c,#60
db #04,#02,#94,#60,#05,#02,#6c,#60
db #01,#02,#94,#60,#05,#02,#7c,#60
db #04,#02,#6c,#60,#01,#02,#2d,#02
db #7c,#60,#04,#02,#6c,#60,#01,#02
db #7c,#60,#04,#3d,#3d,#02,#7c,#60
db #05,#02,#6c,#60,#01,#02,#7c,#60
db #04,#00,#a8,#e0,#00,#00,#03,#6f
db #79,#81,#79,#6f,#69,#6f,#79,#81
db #79,#6f,#69,#6f,#79,#81,#69,#6f
db #79,#81,#79,#6f,#69,#6f,#79,#81
db #79,#6f,#69,#6f,#79,#81,#69,#6f
db #79,#81,#79,#6f,#69,#6f,#79,#81
db #79,#6f,#69,#6f,#79,#81,#69,#6f
db #79,#81,#79,#6f,#69,#6f,#79,#81
db #79,#6f,#69,#6f,#79,#81,#a8,#e0
db #00,#00,#02,#06,#7d,#06,#69,#02
db #7d,#06,#69,#02,#87,#06,#69,#02
db #87,#06,#69,#02,#87,#06,#69,#06
db #79,#06,#69,#02,#79,#06,#69,#02
db #7d,#06,#69,#02,#79,#06,#69,#02
db #75,#00,#88,#e1,#00,#00,#04,#02
db #70,#60,#01,#02,#88,#60,#04,#02
db #a0,#60,#05,#02,#70,#60,#01,#02
db #a0,#60,#05,#02,#88,#60,#04,#02
db #70,#60,#01,#02,#88,#60,#04,#02
db #70,#60,#01,#02,#88,#60,#04,#02
db #a0,#60,#05,#02,#70,#60,#01,#02
db #a0,#60,#05,#02,#61,#02,#70,#60
db #01,#02,#8c,#60,#04,#02,#74,#60
db #01,#02,#8c,#60,#04,#02,#a4,#60
db #05,#02,#74,#60,#01,#02,#a4,#60
db #05,#02,#8c,#60,#04,#02,#74,#60
db #01,#02,#35,#02,#8c,#60,#04,#02
db #6c,#60,#01,#02,#84,#60,#04,#45
db #84,#60,#05,#02,#84,#60,#04,#02
db #6c,#60,#01,#02,#9c,#60,#05,#00
db #bc,#e0,#00,#00,#06,#06,#7d,#02
db #79,#06,#79,#06,#75,#0a,#6f,#02
db #6b,#02,#6f,#02,#6b,#02,#6f,#02
db #6b,#02,#7d,#02,#7d,#06,#79,#02
db #79,#06,#75,#02,#75,#0a,#6f,#02
db #6b,#02,#6f,#02,#65,#02,#6f,#02
db #6b,#00,#bc,#e0,#00,#00,#06,#06
db #7d,#02,#79,#06,#79,#06,#75,#0a
db #6f,#02,#6b,#02,#6f,#02,#6b,#02
db #6f,#02,#6b,#02,#7d,#02,#7d,#06
db #83,#02,#83,#06,#79,#02,#79,#0a
db #79,#02,#87,#02,#83,#02,#87,#02
db #7d,#02,#83,#42,#09,#42,#80,#00
db #00,#00,#bc,#e0,#00,#00,#06,#06
db #7d,#02,#79,#06,#79,#06,#75,#0a
db #6f,#02,#6b,#02,#6f,#02,#6b,#02
db #6f,#02,#6b,#02,#79,#02,#79,#06
db #7d,#02,#7d,#06,#75,#02,#75,#06
db #65,#02,#61,#02,#65,#02,#6b,#02
db #61,#02,#6b,#02,#65,#00,#7e,#e0
db #00,#00,#06,#02,#3f,#06,#3f,#06
db #3f,#06,#3f,#06,#3f,#02,#3f,#06
db #3f,#06,#3f,#06,#3f,#02,#3f,#06
db #3f,#06,#3f,#06,#3f,#06,#3f,#02
db #3f,#06,#3f,#06,#3f,#00,#7e,#e7
db #00,#00,#06,#02,#3f,#06,#3f,#02
db #7e,#60,#04,#02,#7e,#60,#06,#06
db #7e,#63,#04,#06,#7e,#67,#06,#06
db #3f,#02,#3f,#02,#7e,#63,#04,#02
db #7e,#67,#06,#02,#7e,#63,#04,#02
db #7a,#67,#06,#06,#3b,#02,#3b,#06
db #7e,#63,#04,#02,#3f,#02,#7a,#67
db #06,#06,#3b,#02,#7e,#63,#04,#02
db #7a,#67,#06,#02,#7e,#63,#04,#02
db #3f,#02,#7a,#60,#06,#00,#bc,#e3
db #00,#00,#06,#02,#ae,#69,#02,#02
db #75,#02,#7d,#02,#bc,#63,#06,#02
db #ae,#69,#02,#02,#75,#02,#7d,#02
db #be,#63,#06,#02,#ae,#69,#02,#02
db #75,#02,#7d,#02,#be,#63,#06,#02
db #ae,#69,#02,#02,#75,#02,#7d,#02
db #7f,#02,#7d,#02,#75,#02,#6f,#02
db #75,#02,#7d,#02,#7f,#02,#7d,#02
db #c2,#63,#06,#02,#ae,#69,#02,#02
db #75,#02,#7d,#02,#c2,#63,#06,#02
db #aa,#49,#02,#6b,#02,#6b,#00,#7e
db #e0,#00,#00,#06,#02,#3f,#06,#3f
db #02,#7e,#60,#04,#02,#7e,#60,#06
db #06,#3f,#06,#3f,#02,#3f,#06,#7e
db #60,#04,#06,#7e,#60,#06,#06,#3f
db #02,#3f,#06,#3f,#02,#7e,#60,#04
db #02,#7e,#60,#06,#06,#3f,#06,#3f
db #02,#3f,#06,#7e,#60,#04,#06,#7e
db #60,#06,#00,#7e,#e1,#00,#00,#06
db #02,#3f,#06,#3f,#02,#7e,#60,#04
db #02,#7e,#60,#06,#06,#3f,#06,#3f
db #02,#3f,#06,#7e,#60,#04,#06,#7e
db #60,#06,#06,#3b,#02,#3b,#06,#3b
db #02,#7e,#60,#04,#02,#7a,#60,#06
db #06,#3b,#06,#3b,#02,#3b,#06,#7e
db #60,#04,#06,#7a,#60,#06,#00,#c6
db #e1,#00,#00,#06,#06,#87,#02,#7d
db #02,#c6,#49,#02,#bc,#41,#06,#75
db #02,#bc,#49,#02,#b4,#41,#02,#73
db #02,#ae,#49,#02,#ae,#41,#02,#73
db #02,#75,#02,#7d,#02,#7f,#02,#b2
db #49,#02,#be,#41,#02,#7d,#06,#7d
db #02,#be,#49,#02,#b4,#41,#02,#b2
db #49,#02,#75,#02,#b2,#41,#06,#6f
db #02,#73,#02,#75,#02,#7d,#00,#c2
db #e1,#00,#00,#06,#02,#bc,#49,#02
db #c2,#41,#02,#7f,#06,#7f,#02,#b8
db #69,#02,#02,#bc,#61,#06,#02,#bc
db #49,#06,#b8,#41,#02,#75,#02,#79
db #02,#7d,#02,#6f,#02,#75,#02,#7d
db #02,#ae,#49,#02,#bc,#41,#02,#79
db #06,#79,#02,#b2,#49,#02,#b4,#41
db #06,#6f,#02,#6b,#02,#65,#02,#75
db #02,#6f,#02,#75,#02,#79,#00,#c2
db #e1,#00,#00,#06,#06,#83,#02,#7f
db #06,#7f,#06,#7d,#02,#bc,#49,#06
db #b8,#41,#02,#75,#02,#79,#02,#7d
db #02,#6f,#02,#75,#02,#7d,#02,#b2
db #49,#02,#bc,#41,#02,#79,#06,#79
db #06,#75,#02,#b2,#49,#02,#ae,#41
db #02,#6b,#02,#65,#02,#75,#06,#6f
db #02,#ae,#67,#02,#00,#c6,#e0,#00
db #00,#06,#06,#87,#02,#7d,#06,#7d
db #06,#75,#02,#b2,#49,#02,#75,#02
db #b2,#41,#02,#ae,#49,#02,#ae,#41
db #02,#73,#02,#75,#02,#7d,#02,#7f
db #06,#7f,#02,#7d,#06,#7d,#06,#83
db #02,#b2,#49,#02,#be,#41,#02,#7d
db #02,#79,#02,#7d,#02,#7f,#02,#7d
db #02,#79,#00,#a4,#e1,#00,#00,#09
db #3e,#a4,#60,#0a,#1e,#a4,#60,#0b
db #00,#a4,#ed,#00,#00,#0c,#02,#42
db #0b,#02,#42,#09,#02,#42,#07,#02
db #42,#05,#06,#42,#03,#26,#a6,#60
db #0d,#1e,#a4,#60,#0c,#00,#b4,#e1
db #00,#00,#0e,#32,#42,#80,#fe,#ff
db #42,#00,#42,#00,#42,#80,#fc,#ff
db #42,#80,#fa,#ff,#42,#00,#c2,#c0
db #00,#00,#1e,#87,#06,#83,#06,#7d
db #02,#83,#00,#b4,#e0,#00,#00,#0e
db #2e,#7d,#0e,#79,#1a,#42,#80,#04
db #00,#42,#80,#08,#00,#b2,#c0,#00
db #00,#0a,#75,#0a,#79,#00,#7e,#e3
db #00,#00,#0f,#06,#57,#06,#3f,#06
db #57,#06,#49,#06,#61,#06,#49,#06
db #61,#06,#3b,#06,#53,#06,#3b,#06
db #53,#06,#3f,#06,#57,#06,#3f,#06
db #57,#00,#ae,#e5,#00,#00,#08,#00
db #42,#80,#00,#00,#0e,#bc,#63,#06
db #02,#b8,#49,#02,#bc,#43,#02,#b8
db #49,#02,#be,#43,#02,#bc,#49,#02
db #7f,#0e,#be,#43,#02,#bc,#49,#02
db #b8,#43,#02,#b4,#49,#02,#b8,#43
db #02,#b4,#49,#02,#b8,#43,#02,#b4
db #49,#02,#bc,#43,#02,#b8,#49,#02
db #7d,#00,#76,#e0,#00,#00,#0f,#06
db #4f,#06,#37,#06,#4f,#06,#37,#06
db #4f,#06,#37,#06,#4f,#06,#3b,#06
db #53,#06,#3b,#06,#53,#06,#3b,#06
db #53,#06,#3b,#06,#53,#00,#a6,#e0
db #00,#00,#07,#3e,#6b,#00,#b4,#e3
db #00,#00,#06,#2e,#75,#02,#b2,#49
db #02,#b8,#43,#02,#b4,#47,#32,#bc
db #43,#02,#b8,#49,#02,#b8,#43,#02
db #b4,#49,#00,#78,#e0,#00,#00,#0f
db #06,#51,#06,#39,#06,#51,#06,#39
db #06,#51,#06,#39,#06,#51,#06,#37
db #06,#4f,#06,#37,#06,#4f,#06,#37
db #06,#4f,#06,#37,#06,#4f,#00,#a8
db #e0,#00,#00,#10,#3e,#a6,#60,#07
db #00,#42,#80,#00,#00,#0e,#bc,#63
db #06,#02,#b8,#49,#02,#bc,#43,#02
db #b8,#49,#02,#be,#43,#02,#bc,#49
db #02,#7f,#0e,#be,#43,#02,#bc,#49
db #02,#b8,#43,#02,#b4,#49,#02,#b8
db #43,#02,#b4,#49,#02,#b8,#43,#02
db #b2,#49,#02,#bc,#43,#02,#b8,#49
db #02,#7d,#0e,#bc,#43,#02,#ae,#49
db #02,#b8,#43,#02,#b4,#49,#00,#b4
db #e3,#00,#00,#06,#2e,#75,#06,#79
db #00,#b4,#e3,#00,#00,#06,#2e,#75
db #04,#42,#80,#04,#00,#b4,#c0,#00
db #00,#00,#66,#e1,#00,#00,#06,#02
db #27,#06,#27,#02,#7e,#60,#04,#02
db #66,#60,#06,#06,#27,#06,#27,#02
db #27,#06,#84,#60,#04,#06,#45,#02
db #6c,#67,#06,#02,#66,#41,#02,#27
db #06,#27,#02,#7e,#60,#04,#02,#66
db #60,#06,#06,#27,#06,#27,#02,#27
db #06,#88,#60,#04,#02,#a0,#47,#02
db #88,#41,#02,#88,#67,#06,#00,#7e
db #e7,#00,#00,#06,#02,#3f,#06,#3f
db #02,#7e,#60,#04,#02,#7e,#60,#06
db #06,#7e,#63,#04,#06,#7e,#67,#06
db #02,#27,#02,#3f,#02,#45,#02,#84
db #63,#04,#02,#84,#67,#06,#02,#84
db #63,#04,#02,#7a,#67,#06,#02,#27
db #02,#3f,#02,#3f,#02,#66,#63,#04
db #02,#7e,#40,#02,#3f,#02,#7e,#67
db #06,#06,#3f,#02,#7e,#63,#04,#02
db #7e,#67,#06,#02,#88,#63,#04,#02
db #49,#02,#88,#60,#06,#02,#49,#00
db #c2,#e3,#00,#00,#0f,#0e,#42,#80
db #18,#00,#42,#80,#e8,#ff,#42,#80
db #18,#00,#42,#80,#e8,#ff,#42,#80
db #18,#00,#42,#80,#00,#00,#04,#42
db #05,#02,#42,#07,#02,#42,#09,#02
db #42,#0b,#0e,#42,#85,#e8,#ff,#42
db #80,#18,#00,#42,#83,#30,#00,#42
db #80,#00,#00,#0c,#42,#80,#18,#00
db #42,#80,#e8,#ff,#42,#80,#18,#00
db #42,#80,#e8,#ff,#42,#80,#f8,#ff
db #42,#80,#18,#00,#42,#80,#e8,#ff
db #42,#80,#00,#00,#00,#66,#e1,#00
db #00,#06,#02,#27,#06,#27,#02,#7e
db #60,#04,#02,#66,#60,#06,#06,#27
db #06,#27,#02,#27,#06,#6c,#60,#04
db #06,#6c,#60,#06,#06,#27,#02,#27
db #02,#27,#02,#27,#02,#7e,#60,#04
db #02,#66,#60,#06,#06,#35,#06,#74
db #60,#04,#02,#74,#60,#06,#06,#70
db #60,#04,#06,#74,#60,#06,#00,#7e
db #e7,#00,#00,#06,#02,#3f,#06,#3f
db #02,#7e,#60,#04,#02,#7e,#60,#06
db #06,#7e,#63,#04,#06,#7e,#67,#06
db #02,#27,#02,#3f,#02,#45,#02,#84
db #63,#04,#02,#84,#67,#06,#02,#84
db #63,#04,#02,#7a,#67,#06,#02,#27
db #02,#3f,#02,#3f,#02,#66,#63,#04
db #02,#7e,#40,#02,#3f,#02,#8c,#67
db #06,#06,#4d,#02,#8c,#63,#04,#02
db #8c,#67,#06,#02,#88,#63,#04,#02
db #49,#02,#8c,#60,#06,#02,#4d,#00
db #c6,#e3,#00,#00,#0f,#0e,#42,#80
db #18,#00,#42,#80,#e8,#ff,#42,#80
db #18,#00,#42,#80,#e8,#ff,#42,#80
db #28,#00,#42,#80,#00,#00,#04,#42
db #05,#02,#42,#07,#02,#42,#09,#02
db #42,#0b,#12,#c2,#43,#0e,#42,#80
db #18,#00,#42,#80,#e8,#ff,#42,#80
db #18,#00,#42,#80,#e8,#ff,#bc,#e7
db #00,#00,#02,#00,#ae,#e3,#00,#00
db #0f,#02,#aa,#49,#02,#b4,#43,#02
db #ae,#49,#02,#bc,#43,#02,#b4,#49
db #02,#c2,#43,#02,#bc,#49,#02,#bc
db #43,#02,#c2,#49,#02,#b4,#43,#02
db #bc,#49,#02,#c2,#43,#02,#b4,#49
db #02,#bc,#43,#02,#c2,#49,#02,#c6
db #43,#02,#bc,#49,#02,#bc,#43,#02
db #c6,#49,#02,#b4,#43,#02,#bc,#49
db #02,#c2,#43,#02,#b4,#49,#02,#bc
db #43,#02,#c2,#49,#02,#b4,#43,#02
db #bc,#49,#02,#bc,#43,#02,#b4,#49
db #02,#c2,#43,#02,#bc,#49,#00,#ca
db #e1,#00,#00,#02,#16,#87,#16,#7d
db #02,#42,#80,#18,#00,#42,#80,#e8
db #ff,#42,#80,#18,#00,#42,#80,#e8
db #ff,#42,#83,#18,#00,#42,#80,#e8
db #ff,#42,#80,#18,#00,#42,#85,#e8
db #ff,#42,#80,#00,#00,#42,#07,#02
db #42,#80,#08,#00,#42,#00,#42,#00
db #42,#00,#42,#00,#42,#00,#42,#00
db #42,#00,#42,#00,#42,#00,#42,#00
db #42,#00,#42,#00,#42,#00,#42,#00
db #42,#00,#42,#00,#42,#00,#42,#00
db #42,#00,#42,#00,#42,#00,#42,#00
db #42,#00,#42,#00,#42,#00,#42,#00
db #ae,#f7,#00,#00,#11,#06,#42,#13
db #02,#42,#0f,#02,#42,#0b,#02,#42
db #09,#02,#42,#07,#02,#42,#05,#02
db #42,#03,#06,#42,#05,#02,#42,#07
db #02,#42,#09,#02,#42,#0b,#02,#42
db #0f,#02,#42,#13,#00

org #4000

; title screen centre text part starts at #5d0
; panel occupies up to #140
; gives #490 (1168 dec) bytes free in 8 segments within the base #4000-#7fff range

PanelBlock0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,192,128,0,0,0,0,0,0,0,0,64,192,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,192,128,0,0,0,0,0,0,0,0,64,192,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 68,81,162,217,179,243,99,243,179,162,34,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,68,243,230,0,0,0,192,128,0,0,0,0,0,0,0,0,64,192,0,0,0,217,243,136,34,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,81,115,243,147,243,115,230,81,162,136
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,68,179,243,102,65,115,115,243,217,204,230,204,204,217,204,230,243,179,179,130,179,162,243,162,34,0,17,67,35,168,17,67,35,168,17,67,35,168,0,17,81,243,81,115,65,115,115,243,217,204,230,204,204,217
    defb 204,230,243,179,179,130,153,243,115,136,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,128,162,0,0,0,0,0,0,81,64,0,0,0,136,136,204,204,65,115,115,243,217,204,230,204,204,217,204,230,243,179,179,130,204,204,68,68,0,0,0,128,162,0,0,0,0,0,0,81,64,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0

    defs #c0 ; laserframe1 here
; ytable at #4200
;read "YTableasm"
YTable
    defw #640,#640,#640,#640
    defw #640,#640,#640,#640
    defw #640,#640,#640,#640
    defw #640,#640,#640,#640
;
    defw #000,#1000,#2000,#3000
    defw #050,#1050,#2050,#3050
    defw #0a0,#10a0,#20a0,#30a0
    defw #0f0,#10f0,#20f0,#30f0
;
    defw #140,#1140,#2140,#3140
    defw #190,#1190,#2190,#3190
    defw #1e0,#11e0,#21e0,#31e0
    defw #230,#1230,#2230,#3230
;
    defw #280,#1280,#2280,#3280
    defw #2d0,#12d0,#22d0,#32d0
    defw #320,#1320,#2320,#3320
    defw #370,#1370,#2370,#3370
;
    defw #3c0,#13c0,#23c0,#33c0
    defw #410,#1410,#2410,#3410
    defw #460,#1460,#2460,#3460
    defw #4b0,#14b0,#24b0,#34b0
;
    defw #500,#1500,#2500,#3500
    defw #550,#1550,#2550,#3550
    defw #5a0,#15a0,#25a0,#35a0
    defw #5f0,#15f0,#25f0,#35f0
;
    defw #640,#640,#640,#640
    defw #640,#640,#640,#640
    defw #640,#640,#640,#640
    defw #640,#640,#640,#640
;
    defw #640,#640,#640,#640
    defw #640,#640,#640,#640
    defw #640,#640,#640,#640
    defw #640,#640,#640,#640


; game font at #4300
;read "EG_Gamefontasm"
gamefont0
    defb 1,0,130,130,34,34,0,84,3,2,34,34,0,0,0,0
gamefont1
    defb 1,0,0,65,51,0,168,252,3,2,0,17,0,0,0,0
gamefont2
    defb 1,0,130,0,34,34,168,252,3,2,0,17,0,0,0,0
gamefont3
    defb 3,0,130,65,0,34,168,252,3,2,34,0,0,0,0,0
gamefont4
    defb 2,2,130,130,34,34,168,0,0,2,34,51,0,0,0,0
gamefont5
    defb 3,2,130,195,34,0,168,252,3,2,34,0,0,0,0,0
gamefont6
    defb 3,2,130,195,34,0,168,252,3,2,34,34,0,0,0,0
gamefont7
    defb 3,2,130,0,0,34,168,0,0,2,34,0,0,0,0,0
gamefont8
    defb 1,0,130,195,34,34,0,84,3,2,34,34,0,0,0,0
gamefont9
    defb 1,0,130,195,34,34,0,84,3,2,34,0,0,0,0,0
;gamefont10
;    defb 17,67,35,0,189,23,86,35,0,35,67,17,35,86,23,189
;gamefont11
;    defb 35,168,2,42,19,42,0,168,42,2,168,35,168,0,42,3
;gamefont12
;    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;gamefont13
;    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
playerlife
    defb 17,67,35,168,2,42,35,0,189,23,19,42,0,168,86,35
    defb 0,35,42,2,168,35,67,17,35,86,168,0,42,3,23,189
blanklife
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


; ends at #43e0
defs 32 ; until have final wave data and music, leave compiled sprites in bank
;PlayerFrameList
;    defw PlayerSprite0 ; #255
;    defw PlayerSprite1 ; #22d
;    defw PlayerSprite2 ; #1f9
;    defw PlayerSprite3 ; #1dd
;    defw PlayerSprite4 ; #1e1
;    defw PlayerSprite5 ; #20d
;    defw PlayerSprite6 ; #22f
;    defw PlayerSprite4 ; dummy entry
;LaserFrameList
;    defw LaserFrame0 ; #128
;    defw LaserFrame5 ; #12b
;    defw LaserFrame4 ; #12e
;    defw LaserFrame3 ; #131
;    defw LaserFrame2 ; #e9
;    defw LaserFrame1 ; #bc
;    defw LaserFrame1 ; dummy entry
;    defw LaserFrame1 ; dummy entry
; zoom scroller font at #4400
;read "zsfontasm"
ZoomScrollFont
; 27 characters for zoom scroller in vertical strips, 8 bytes a character
; last 5 characters are blank, occupies whole page at #4400 in base ram
    defb 62,126,72,72,72,126,62,0
    defb 126,126,82,82,82,126,44,0
    defb 60,126,66,66,66,66,66,0
    defb 126,126,66,66,66,126,60,0
    defb 126,126,82,82,66,66,66,0
    defb 126,126,72,72,64,64,64,0
    defb 60,126,66,66,66,78,76,0
    defb 126,126,16,16,16,126,126,0
    defb 0,0,0,126,126,0,0,0
    defb 12,78,66,66,66,126,124,0
    defb 126,126,16,16,16,126,110,0
    defb 126,126,2,2,2,2,2,0
    defb 126,126,48,24,48,126,126,0
    defb 126,126,64,64,64,126,62,0
    defb 60,126,66,66,66,126,60,0
    defb 126,126,72,72,72,120,48,0
    defb 60,126,66,66,74,116,58,0
    defb 126,126,72,72,72,126,54,0
    defb 34,114,82,82,82,94,12,0
    defb 0,64,64,126,126,64,64,0
    defb 124,126,2,2,2,126,124,0
    defb 120,124,6,2,6,124,120,0
    defb 126,126,12,24,12,126,126,0
    defb 70,110,56,16,56,110,70,0
    defb 96,114,18,18,18,126,124,0
    defb 66,70,78,90,114,98,66,0
    defb 4,46,122,90,124,46,10,0
    defb 0,0,2,6,4,0,0,0
    defb 0,0,0,122,122,0,0,0

defs 24 ; 3 spare letters

    defs #300 ;#6c0
PanelBlock1
    defb 0,0
    defb 0,0,0,0,0,0,68,243,243,204,136,0,96,32,202,202,202,202,202,202,202,202,64,96,0,68,204,243,243,136,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,68,243,243,204,136,0,144,128,197,197,197,197,197,197,197,197,16,144,0,68,204,243,243,136,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,68,217,115,81,0,0,1,0,1,0,1,0,1,0,1,0,1,0,0,0,162,179,211,115,230,0,96,32,202,202,202,202,197,197,197,197,16,144,0,217,179,227,115,81,0,0,1,0,1,0,1,0,3,0,2,2,3,2,0,0,162,179,230,136,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,68,243,0,68,162,0,0,0,0,0,0,0,0,0,0,0,0,0,0,81,115,162,179,81,0,0,0,35,42,2,0,35,42,2,0,35,42,2,0,0,162,115,81,179,162,0,0,0,0,0,0,0,0,0,0,0,0,0,0,81,136,0,243,136,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,136,0,0,0,136,0,0,68,0,0,0,0,68,68,68,179,162,0,0,0,0,0,0,0,0,0,0,0,0,0,0,81,115,136,136,136,0,0,0,0,136,0,0,68,0,0,0,68,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0
; ends at #940
    defs #4c
; org #498c
PrintCredits
; first clear the section of the screen used for credit lines
    ld hl,#45d0
    ld a,8
PrnCrClrLp
    ld d,h
    ld e,l
    inc de
    ld (hl),0
    ld bc,#230-1
    ldir
    ld de,#800-#230
    add hl,de
    dec a
    jr nz,PrnCrClrLp
; now write credits
    ld hl,CreditText
    ld d,#4c ;ff
    ld c,#e0
    exx
    ld de,#45d0+#50
    exx
PrnCreditLoop
    ld a,(hl)
    cp a,5
    jr c,PrnCrControlCode
    sub a,65
    jr c,PrnCrSpace
; now have ascii code - 65
    exx
    ld h,#4a ;fd
    add a,a
    add a,a
    add a,a
    add a,a
    jr nc,PrnCrLpNoC
    inc h
PrnCrLpNoC
    ld l,a
; hl now has source for char
    ld b,8
PrnCreditCharLp
    ld a,(hl)
    exx
    or c
    ld e,a
    ld a,(de)
    exx
    ld (de),a
    inc e
    inc l
    ld a,(hl)
    exx
    or c
    ld e,a
    ld a,(de)
    exx
    ld (de),a
    dec e
    inc l
    ld a,8
    add a,d
    ld d,a
    djnz PrnCreditCharLp
    ld a,#c0
    add a,d
    ld d,a
PrnCrSpaceReturn
    inc e
    inc de
    exx
    inc hl
    jr PrnCreditLoop
PrnCrSpace
    exx
    jr PrnCrSpaceReturn
PrnCrControlCode
    or a
    ret z
    rrca
    rrca
    rrca ; ax32
    add a,#60
    ld c,a
    cp a,#80
    jr nz,PrnCrSkipLineInc
    exx
    ex de,hl
    ld bc,80
    add hl,bc
    ex de,hl
    exx
PrnCrSkipLineInc
    inc hl
    jr PrnCreditLoop

; want small font to be at #4a00
;read "EG_small_fontasm"
SmallFont
    defb 1,0,5,2,16,16,14,14,19,16,6,6,15,15,2,2
    defb 3,0,7,2,16,16,17,2,16,16,7,6,18,2,3,0
    defb 1,2,5,6,16,2,14,0,16,2,7,6,11,15,1,2
    defb 3,0,7,2,16,16,14,14,16,16,7,6,18,2,3,0
    defb 3,2,7,6,16,2,17,2,16,2,7,6,18,15,3,2
    defb 3,2,7,6,16,2,14,0,19,2,6,0,15,0,2,0
    defb 1,2,5,6,16,2,14,14,16,16,7,6,11,15,1,2
    defb 2,2,6,6,16,16,17,14,16,16,6,6,15,15,2,2
    defb 1,0,4,2,12,2,8,2,12,2,4,2,9,2,1,0
    defb 3,2,7,6,3,16,2,14,16,16,7,6,18,2,3,0
    defb 2,2,6,6,16,16,17,2,16,16,6,6,15,15,2,2
    defb 2,0,6,0,16,0,14,0,16,2,7,6,18,15,3,2
    defb 2,2,6,6,19,16,17,14,16,16,6,6,15,15,2,2
    defb 3,0,7,2,16,16,14,14,16,16,6,6,15,15,2,2
    defb 1,0,5,2,16,16,14,14,16,16,7,6,11,2,1,0
    defb 3,0,7,2,16,16,14,14,19,2,6,0,15,0,2,0
    defb 1,0,5,2,16,16,14,14,16,16,7,6,11,15,1,2
    defb 3,0,7,2,16,16,14,14,19,2,6,6,15,15,2,2
    defb 1,2,5,6,16,2,10,2,1,16,3,6,18,2,3,0
    defb 3,2,7,6,13,2,8,2,12,2,4,2,9,2,1,0
    defb 2,2,6,6,16,16,14,14,16,16,6,6,11,2,1,0
    defb 2,2,6,6,16,16,14,14,16,16,7,6,11,2,1,0
    defb 2,2,6,6,16,16,14,14,19,16,7,6,15,15,2,2
    defb 2,2,6,6,16,16,10,2,16,16,6,6,15,15,2,2
    defb 2,2,6,6,16,16,14,14,19,16,3,6,18,2,3,0
    defb 3,2,7,6,3,16,10,2,16,2,7,6,18,15,3,2
    defb 0,0,1,0,12,2,8,2,19,16,4,2,9,2,1,0


CreditText
; have 208 bytes to pad out
;   defm "0123456789012345678901234567890123456789"
    defm "EDGE GRINDER      BY      COSINE SYSTEMS"
    defb 1
    defm "CODING                     PAUL KOOISTRA"
    defb 3
    defm "GRAPHICS             TREVOR SMILA STOREY"
    defb 2
    defm "MUSIC                          TOM[JERRY"
    defb 4
;   defm "RELEASED BY                   FORMAT WAR"
    defm "       RELEASED  BY  FORMAT  WAR        "
    defb 0
    defs 3

; want FontMaskColour to be at #4c80
;read "fntmaskasm"
FontMaskColour
    defb 0,4,8,12,16,24,36,48,64,68,72,76,80,88,132,140,164,192,204,240
    defs 12
    defb 0,4,8,12,84,92,172,252,64,20,72,28,1,9,132,44,6,192,60,3
    defs 12
    defb 0,65,130,195,69,199,203,207,64,5,194,135,17,147,193,75,99,192,15,51
    defs 12
    defb 0,81,162,243,21,183,123,63,21,21,183,183,21,183,123,123,123,63,63,63
    defs 12

    defs #300 ;#6c0
PanelBlock2
    defb 0,0
    defb 0,68,81,162,217,179,243,99,179,147,230,0,48,32,77,77,77,77,77,77,77,77,16,48,0,217,99,115,147,243,115,230,81,162,136,0,0,0,0,0,0,68,81,162,217,179,243,99,179,147,230,0,48,32,142,142,142,142,142,142,142,142,16,48,0,217,99,115,147
    defb 243,115,230,81,162,136,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,68,230,243,115,211,68,0,0,34,34,34,34,34,34,34,34,34,34,34,34,0,0,136,227,115,230,0,204,48,96,77,77,77,77,142,142,142,142,144,48,204,0,217,179,211,68,0,0,34,34,51,0,34,34,0,34,34,34,34,0,0,0,136,227,179,243,217,136,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,217,99,115,0,48,32,217,115,147,195,195,99,179,230,16,48,0,179,243,136,243,68,0,0,35,86,168,0,35,86,168,0,35,86,168,0,0,0,136,243,68,243,115,0,48,32,217,115,147,195,195,99,179,230,16,48,0,179,147,230,0,0,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,162,0,0,0,0,0,0,0,0,136,136,217,115,0,48,32,195,195,195,195,195,195,195,195,16,48,0,179,230,68,68,0,0,0,0,0,0,0,0,81,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0
; player sprite 0 and 6

ZoomScrollMsg
;   defm "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
;    defb 255
    defm "EDGE GRINDER   "
    defm "DEVELOPED BY COSINE "
    defm "FOR FORMAT WAR    "
;   defm "published on cartridge by rgcd    "
    defm "CODE BY PAUL   "
    defm "GRAPHICS BY SMILA   "
    defm "MUSIC BY TOM[JERRY    "
    defm "THANKS TO ARNOLDEMU\ EXECUTIONER [ GRIM FOR ALL THE HELP ON SCREEN SPLITTING]    "
    defm "GREETINGS TO TARGHAN\ SUPER SYLVESTRE\ MATTHEW VAN ROOIJEN\ NICHOLAS CAMPBELL\ "
    defm " JASON MACKENZIE\ FRANK GASKING\ RICHARD BAYLISS AND EVERYONE AT FORMAT WAR]     "
    defb 255
ZoomScrollMsgEnd
    defs #6c0-ZoomScrollMsgEnd+ZoomScrollMsg
PanelBlock3
    defb 0,0
    defb 0,0,0,0,0,0,68,243,243,99,115,204,37,96,12,12,12,12,12,12,12,12,133,37,204,179,147,243,243,136,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,68,243,243,99,115,204,26,74,12,12,12,12,12,12,12,12,144,26,204,179,147,243,243,136,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,68,230,243,115,211,68,0,0,130,130,130,130,130,130,130,130,130,130,130,130,0,0,136,179,230,0,217,204,37,96,12,12,12,12,12,12,12,12,144,26,204,230,0,217,115,68,0,0,130,130,65,0,0,130,65,130,130,130,195,130,0,0,136,227
    defb 179,243,217,136,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,217,204,243,211,204,15,74,179,162,0,0,0,0,81,115,133,15,204,243,230,68,179,68,0,0,189,23,19,42,189,23,19,42,189,23,19,42,0,0,136,115,136,217,243,204,15,74,179,162,0,0,0,0,81,115,133,15,204,227,243,204,230,0,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,81,0,0,0,68,162,162,243,230,230,68,68,179,204,15,74,134,134,134,134,73,73,73,73,133,15,204,115,136,136,217,217,243,81,81,136,0,0,0,162,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0
; player sprite 1, laser frame 3#4
    defs #6c0
PanelBlock4
    defb 0,0
    defb 0,0,0,0,0,68,217,243,179,195,115,204,15,74,134,134,134,134,134,134,134,134,133,15,204,179,195,115,243,230,136,0,0,0,0,0,0,0,0,0,0,0,0,0,0,68,217,243,179,99,115,204,15,74,73,73,73,73,73,73,73,73,133,15,204,179,195,115,243,230,136,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,68,217,211,68,0,0,34,34,34,34,34,34,34,34,34,34,34,34,0,0,136,243,136,217,243,204,15,74,134,134,134,134,73,73,73,73,133,15,204,243,230,68,243,68,0,0,34,34,17,0,17,0,0,34,51,34,0,34,0,0,136,227,230,136,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,68,81,162,217,179,99,195,211,204,37,96,115,0,138,197,202,69,0,179,133,37,204,230,0,217,179,68,0,0,189,23,3,42,189,23,3,42,189,23,3,42,0,0,136,115,230,0,217,204,26,74,115,0,138,197,202,69,0,179,144,26,204,227,195,147,115,230,81,162,136,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,243,115,51,195,198,102,99,198,230,136,136,227,204,37,96,12,12,12,12,12,12,12,12,144,26,204,211,68,68,217,201,147,153,201,195,51,179,243,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0
; player sprite 5, laser frame 0#5
    defs #6c0
PanelBlock5
    defb 0,0
    defb 0,136,243,68,243,115,179,211,99,147,230,0,48,32,195,195,195,195,195,195,195,195,16,48,0,217,99,147,227,115,179,243,136,243,68,0,0,0,0,0,0,136,243,68,243,115,179,211,99,147,230,0,48,32,195,195,195,195,195,195,195,195,16,48,0
    defb 217,99,147,227,115,179,243,136,243,68,0
    defb 0,0
    defb 0,0
    defb 68,81,162,217,179,243,99,211,211,68,0,0,3,2,3,2,3,2,3,2,3,2,3,2,0,0,136,243,68,243,115,0,48,32,195,195,195,195,195,195,195,195,16,48,0,179,243,136,243,68,0,0,3,2,3,2,3,2,3,2,0,2,3,2,0,0,136,227,227,147,243,115,230,81,162,136
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,217,204,243,211,0,48,32,130,128,8,12,12,4,64,65,16,48,0,227,102,68,243,68,0,0,35,86,168,0,35,86,168,0,35,86,168,0,0,0,136,243,136,153,211,0,48,32,130,128,8,12,12,4,64,65,16,48,0,227,243,204,230,0,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,68,162,162,243,230,230,68,0,179,204,48,96,142,142,142,142,77,77,77,77,144,48,204,115,0,136,217,217,243,81,81,136,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0
; player sprite 2#4
    defs #6c0
PanelBlock6
    defb 0,0
    defb 0,0,0,0,0,68,204,217,243,179,136,0,0,0,0,0,0,0,0,0,0,0,0,0,0,68,243,243,230,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,217,243,243,136,0,0,0,0,0,0,0,0,0,0,0,0,0,0,68,115,243,230,204,136,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,68,243,243,115,81,0,0,84,0,84,0,84,0,84,0,84,0,84,0,0,0,162,230,81,179,162,0,0,0,0,0,0,0,0,0,0,0,0,0,0,81,115,162,217,81,0,0,84,0,252,168,252,168,252,168,0,168,252,168,0,0,162,179,243,243,136,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,68,243,99,115,0,96,32,34,8,130,73,134,4,4,17,64,96,0,243,230,136,179,81,0,0,0,35,42,2,0,35,42,2,0,35,42,2,0,0,162,115,68,217,243,0,144,128,34,8,8,73,134,65,4,17,16,144,0,179,147,243,136,0,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,136,243,0,96,32,197,197,197,197,202,202,202,202,16,144,0,243,68,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0
; player sprite 3
    defs #6c0
PanelBlock7
    defb 0,0
    defb 0,0,0,0,0,0,0,68,243,102,65,147,179,243,115,243,217,204,204,230,243,179,243,115,99,130,217,147,136,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,68,99,230,65,147,179,243,115,243,217,204,204,230,243,179,243,115,99,130,153,243,136,0,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,217,115,179,162,34,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,81,162,204,204,65,147,179,243,115,243,217,204,204,230,243,179,243,115,99,130,204,204,81,162,34,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,81,115,179,230,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,68,243,243,0,192,128,162,130,130,195,195,65,65,81,64,192,0,68,136,0,243,162,34,0,17,67,35,168,17,67,35,168,17,67,35,168,0,17,81,243,0,68,136,0,192,128,162,130,130,195,195,65,65,81,64,192,0,243,243,136,0,0,0,0,0,0,0,0
    defb 0,0
    defb 0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,192,128,0,0,0,0,0,0,0,0,64,192,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0
; laser frame 2
    defs #6c0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BANK 4
org #4000
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#15,#00,#40,#00,#48,#00
db #82,#80,#00,#00,#00,#00,#49,#2e
db #1d,#0c,#86,#86,#2e,#a0,#00,#00
db #00,#00,#40,#04,#1d,#86,#58,#1d
db #2e,#49,#00,#80,#00,#00,#04,#d0
db #0c,#2e,#1d,#2e,#80,#e0,#00,#00
db #00,#00,#d0,#15,#2e,#49,#48,#7a
db #00,#80,#00,#00,#00,#00,#00,#40
db #00,#15,#00,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#08,#00
db #40,#00,#08,#00,#84,#00,#00,#00
db #41,#04,#c3,#86,#0c,#84,#86,#86
db #0c,#49,#00,#80,#40,#04,#49,#c3
db #1d,#0c,#0c,#49,#1d,#7a,#48,#80
db #40,#00,#b5,#2e,#1d,#86,#0c,#3f
db #3f,#2e,#48,#86,#00,#40,#0c,#d0
db #49,#2e,#86,#c3,#86,#58,#80,#80
db #00,#00,#04,#c1,#86,#0c,#58,#1d
db #80,#48,#00,#00,#00,#00,#80,#d0
db #50,#0c,#7a,#0c,#00,#80,#00,#00
db #00,#00,#00,#00,#00,#40,#80,#e0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#80,#00
db #00,#00,#00,#00,#15,#00,#1d,#2a
db #04,#40,#86,#1d,#c0,#00,#2a,#80
db #15,#04,#86,#86,#3f,#84,#0c,#c3
db #e0,#1d,#00,#80,#00,#00,#6b,#49
db #48,#58,#b5,#3f,#1d,#6a,#80,#00
db #15,#40,#f0,#84,#2e,#1d,#86,#58
db #7a,#7a,#c0,#b5,#2e,#2e,#86,#1d
db #a4,#49,#86,#86,#0c,#7a,#a0,#80
db #00,#40,#84,#49,#b5,#58,#f0,#0c
db #0c,#c3,#00,#08,#00,#00,#15,#15
db #1d,#c0,#84,#6a,#48,#58,#00,#00
db #00,#00,#00,#40,#c0,#7a,#e0,#6a
db #00,#80,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#00,#00,#40,#00,#3f,#80
db #00,#00,#00,#00,#2e,#95,#3f,#6a
db #84,#15,#97,#1d,#2a,#80,#80,#40
db #c1,#6b,#97,#1d,#7a,#b5,#97,#7a
db #e0,#6a,#00,#00,#40,#15,#3f,#2e
db #3f,#e0,#3f,#1d,#3f,#f0,#80,#80
db #3f,#40,#e0,#95,#2e,#b5,#86,#1d
db #7a,#e0,#6a,#c0,#2e,#97,#7a,#d0
db #2e,#49,#86,#c3,#3f,#1d,#c0,#6a
db #40,#15,#7a,#3f,#95,#b5,#1d,#1d
db #49,#95,#2a,#80,#00,#00,#50,#b5
db #3f,#a4,#b5,#7a,#b5,#2e,#00,#80
db #00,#00,#40,#40,#b5,#7a,#7a,#95
db #80,#6a,#00,#00,#00,#00,#00,#00
db #40,#d0,#80,#e0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #15,#00,#00,#00,#40,#00,#3f,#e0
db #00,#00,#00,#00,#49,#2e,#7a,#6a
db #15,#50,#c3,#0c,#6a,#80,#00,#40
db #3f,#49,#7a,#1d,#80,#50,#2e,#49
db #7a,#6a,#80,#00,#00,#40,#c0,#f0
db #e0,#e0,#6a,#b5,#e0,#f0,#e0,#80
db #3f,#50,#c0,#40,#2e,#95,#86,#1d
db #1d,#d0,#e0,#c0,#6b,#49,#6a,#7a
db #2e,#49,#86,#c3,#3f,#0c,#e0,#6a
db #15,#a4,#e0,#6a,#40,#95,#2a,#1d
db #95,#f0,#80,#c0,#00,#50,#c0,#f0
db #b5,#c0,#1d,#6a,#95,#2e,#80,#2a
db #00,#40,#c0,#c0,#b5,#84,#d0,#6a
db #c0,#c0,#00,#00,#00,#00,#00,#40
db #c0,#d0,#c0,#e0,#00,#80,#00,#00
db #00,#00,#40,#80,#00,#00,#00,#00
db #a4,#50,#a0,#00,#40,#00,#f0,#c0
db #80,#00,#00,#00,#f0,#6b,#e0,#80
db #50,#50,#49,#2e,#58,#e0,#00,#00
db #40,#d0,#e0,#58,#80,#40,#d0,#a4
db #e0,#e0,#80,#80,#00,#40,#d0,#c0
db #58,#e0,#e0,#c0,#80,#c0,#c0,#40
db #2e,#f0,#e0,#c0,#d0,#f0,#58,#f0
db #d0,#d0,#d0,#e0,#95,#a4,#f0,#e0
db #d0,#a4,#58,#86,#e0,#f0,#c0,#c0
db #00,#d0,#40,#d0,#c0,#d0,#e0,#f0
db #e0,#58,#40,#c0,#50,#40,#d0,#e0
db #c0,#80,#e0,#80,#95,#f0,#80,#a0
db #00,#40,#c0,#00,#a4,#d0,#d2,#58
db #80,#40,#00,#00,#00,#00,#40,#c0
db #c0,#d0,#e0,#f0,#80,#c0,#00,#00
db #00,#00,#40,#c0,#00,#00,#00,#00
db #a4,#50,#a0,#00,#00,#00,#d0,#40
db #a0,#00,#00,#00,#d0,#b5,#a0,#80
db #40,#00,#b5,#a4,#f0,#7a,#80,#00
db #40,#40,#c0,#e0,#e0,#80,#40,#d0
db #80,#c0,#40,#80,#80,#00,#b5,#d0
db #1d,#7a,#e0,#c0,#d0,#40,#c0,#f0
db #d0,#c0,#c0,#d0,#e0,#7a,#e0,#a0
db #c0,#00,#e0,#00,#d0,#e0,#d0,#d0
db #40,#d0,#f0,#58,#7a,#f0,#80,#80
db #00,#40,#50,#b5,#00,#a0,#d0,#b5
db #7a,#1d,#80,#e0,#50,#40,#e0,#c0
db #00,#00,#c0,#40,#d0,#e0,#80,#00
db #40,#c0,#40,#80,#a4,#d0,#7a,#e0
db #d0,#50,#80,#e0,#00,#00,#40,#40
db #d0,#95,#d0,#e0,#c0,#c0,#00,#00
db #00,#00,#40,#c0,#00,#00,#00,#00
db #d0,#40,#00,#00,#00,#00,#50,#00
db #80,#00,#00,#00,#50,#b5,#80,#a0
db #00,#00,#d0,#b5,#d0,#e0,#80,#00
db #00,#40,#00,#80,#80,#00,#00,#40
db #40,#80,#e0,#40,#00,#00,#d0,#40
db #7a,#e0,#80,#00,#40,#50,#c0,#c0
db #e0,#c0,#80,#40,#80,#e0,#80,#80
db #40,#00,#e0,#d0,#40,#d0,#40,#00
db #00,#40,#c0,#e0,#e0,#80,#00,#c0
db #00,#00,#40,#d0,#00,#80,#40,#d0
db #e0,#7a,#00,#80,#40,#00,#00,#00
db #00,#00,#00,#00,#40,#80,#80,#00
db #c0,#d0,#00,#80,#40,#00,#e0,#00
db #40,#d0,#e0,#c0,#00,#00,#00,#00
db #c0,#d0,#e0,#7a,#80,#80,#00,#80
db #00,#00,#40,#c0,#00,#00,#00,#00
db #d0,#c0,#00,#00,#00,#00,#40,#00
db #80,#00,#00,#00,#00,#40,#00,#80
db #00,#00,#d0,#d0,#80,#80,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#40
db #00,#00,#40,#40,#80,#00,#40,#00
db #e0,#80,#00,#00,#00,#00,#00,#00
db #80,#c0,#00,#00,#00,#80,#00,#00
db #00,#00,#d0,#80,#00,#00,#00,#00
db #00,#00,#00,#80,#80,#00,#00,#40
db #00,#00,#00,#40,#00,#00,#40,#40
db #80,#e0,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #80,#00,#00,#00,#00,#00,#00,#00
db #c0,#00,#c0,#80,#00,#80,#00,#00
db #c0,#40,#c0,#e0,#80,#40,#80,#e0
db #00,#00,#00,#80,#00,#00,#00,#00
db #c0,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#40,#80,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #a0,#00,#00,#00,#00,#00,#00,#00
db #00,#80,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#00,#00,#00,#00
db #00,#00,#00,#a0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#c0,#00,#00,#00,#c0,#80
db #00,#00,#00,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#e6,#cc,#e6,#cc,#f3,#cc
db #88,#00,#00,#00,#00,#00,#e6,#73
db #e6,#73,#f3,#93,#f3,#e6,#88,#00
db #44,#00,#d9,#00,#63,#b3,#73,#e6
db #88,#00,#00,#d9,#00,#99,#44,#b3
db #93,#d3,#e6,#cc,#cc,#00,#00,#00
db #e6,#cc,#f3,#cc,#b3,#f3,#f3,#d9
db #73,#f3,#e6,#88,#e6,#73,#f3,#73
db #b3,#63,#f3,#b3,#73,#93,#e6,#e6
db #00,#cc,#44,#cc,#93,#f3,#e6,#d9
db #cc,#f3,#00,#88,#44,#99,#d9,#b3
db #63,#d3,#73,#cc,#88,#00,#00,#00
db #00,#00,#e6,#00,#e6,#b3,#f3,#e6
db #f3,#00,#88,#d9,#00,#00,#e6,#73
db #e6,#73,#f3,#93,#88,#e6,#00,#00
db #00,#cc,#cc,#cc,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#cc,#00
db #cc,#00,#cc,#00,#00,#00,#00,#00
db #00,#00,#73,#e6,#73,#e6,#33,#f3
db #e6,#88,#00,#00,#11,#00,#b3,#cc
db #93,#f3,#e6,#cc,#cc,#f3,#d9,#88
db #e6,#cc,#f3,#cc,#b3,#73,#f3,#d9
db #73,#f3,#e6,#88,#e6,#73,#cc,#73
db #b3,#63,#f3,#b3,#73,#93,#e6,#e6
db #44,#99,#d9,#b3,#b3,#d3,#e6,#cc
db #cc,#cc,#d9,#88,#00,#00,#73,#e6
db #d3,#e6,#93,#f3,#e6,#f3,#00,#88
db #00,#00,#cc,#e6,#cc,#e6,#cc,#f3
db #00,#88,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#73,#cc
db #73,#cc,#33,#cc,#cc,#88,#88,#00
db #f3,#cc,#f3,#cc,#f3,#b3,#b3,#d3
db #93,#73,#e6,#d9,#f3,#63,#e6,#b3
db #e6,#93,#f3,#f3,#f3,#73,#88,#e6
db #00,#cc,#e6,#73,#e6,#d3,#f3,#c3
db #f3,#f3,#88,#f3,#00,#00,#00,#cc
db #00,#cc,#00,#cc,#00,#88,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#44,#00,#cc,#00,#00,#00
db #e6,#cc,#f3,#cc,#e6,#d9,#cc,#b3
db #d9,#d3,#e6,#88,#e6,#73,#f3,#d3
db #f3,#d3,#f3,#c3,#e6,#f3,#88,#d9
db #44,#cc,#cc,#cc,#88,#cc,#00,#cc
db #00,#88,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#cc,#00
db #cc,#00,#cc,#00,#88,#00,#00,#00
db #f3,#cc,#d3,#f3,#d3,#f3,#c3,#f3
db #f3,#e6,#d9,#00,#e6,#66,#f3,#e6
db #d9,#e6,#cc,#f3,#d9,#99,#cc,#e6
db #00,#cc,#00,#cc,#cc,#cc,#cc,#cc
db #88,#cc,#00,#88,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#cc,#00,#cc,#00,#cc,#00
db #00,#00,#00,#00,#44,#00,#73,#e6
db #d3,#e6,#63,#f3,#f3,#88,#88,#00
db #e6,#cc,#cc,#e6,#cc,#e6,#cc,#f3
db #73,#cc,#88,#d9,#b3,#73,#b3,#f3
db #c3,#33,#d9,#b3,#73,#93,#e6,#e6
db #44,#cc,#e6,#cc,#e6,#e6,#f3,#d9
db #cc,#f3,#cc,#cc,#00,#00,#cc,#cc
db #cc,#cc,#cc,#cc,#88,#cc,#00,#88
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#cc,#00
db #cc,#00,#cc,#00,#00,#00,#00,#00
db #00,#00,#73,#e6,#73,#e6,#63,#f3
db #e6,#88,#88,#00,#99,#44,#b3,#e6
db #c3,#e6,#c6,#f3,#cc,#f3,#00,#d9
db #e6,#cc,#e6,#cc,#b3,#73,#f3,#d9
db #73,#f3,#e6,#88,#e6,#73,#cc,#73
db #b3,#63,#f3,#b3,#73,#93,#e6,#e6
db #44,#99,#cc,#e3,#93,#73,#e6,#d9
db #cc,#f3,#00,#88,#00,#00,#73,#cc
db #73,#b3,#33,#e6,#e6,#f3,#88,#d9
db #00,#00,#cc,#e6,#cc,#e6,#cc,#f3
db #00,#88,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#2c,#00,#2c,#00,#08,#00
db #00,#40,#00,#94,#40,#94,#2c,#49
db #2c,#49,#08,#86,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #c0,#00,#2c,#c0,#c2,#80,#00,#00
db #00,#00,#00,#00,#c0,#00,#2c,#c0
db #c2,#80,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#c0,#00,#80,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#2c,#00,#2c,#00,#08,#00
db #00,#40,#00,#94,#40,#94,#2c,#49
db #2c,#49,#08,#86,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #cb,#00,#c7,#00,#00,#00,#00,#00
db #00,#00,#cb,#45,#c3,#c7,#cb,#cb
db #8a,#8a,#cb,#45,#00,#00,#41,#45
db #c3,#c3,#c3,#c3,#c3,#c7,#c3,#c3
db #c3,#cf,#c3,#cb,#c7,#c3,#c7,#c7
db #c7,#c7,#cb,#c3,#45,#45,#c7,#c3
db #00,#8a,#8a,#8a,#c3,#c3,#cf,#45
db #cf,#c3,#00,#8a,#cb,#45,#cb,#cf
db #c3,#c3,#cb,#c7,#00,#45,#cf,#8a
db #45,#c3,#cb,#cb,#cf,#c7,#c3,#c3
db #00,#00,#00,#cf,#cf,#8a,#cf,#00
db #00,#8a,#45,#cb,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#cb,#00,#c7,#00
db #00,#00,#00,#00,#00,#00,#cb,#45
db #c3,#c7,#cb,#cb,#8a,#8a,#cb,#45
db #00,#00,#41,#45,#c3,#c3,#c3,#c3
db #c3,#c7,#c3,#c3,#c3,#cf,#c3,#cb
db #c7,#c3,#c7,#c7,#c7,#c7,#cb,#c3
db #45,#45,#c7,#c3,#00,#8a,#8a,#8a
db #c3,#c3,#8a,#45,#45,#41,#8a,#8a
db #cb,#45,#cb,#cf,#c3,#c3,#c3,#c7
db #c7,#45,#c7,#8a,#41,#c3,#cb,#cb
db #c3,#c3,#cb,#c7,#00,#cf,#41,#cb
db #c7,#8a,#c7,#00,#cb,#c7,#c3,#c3
db #00,#00,#cb,#45,#c3,#c3,#cb,#c3
db #8a,#c7,#cb,#c3,#00,#00,#00,#45
db #cb,#c7,#c7,#cf,#00,#8a,#00,#45
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#45,#00,#c7,#cb,#cb,#c7
db #8a,#00,#45,#00,#00,#00,#45,#cb
db #c3,#c3,#c3,#cb,#c7,#8a,#c3,#cb
db #cf,#00,#cb,#41,#c3,#c3,#c7,#c3
db #c7,#c3,#c3,#c3,#45,#c3,#c3,#c3
db #8a,#c7,#8a,#c7,#c3,#c7,#45,#cb
db #41,#45,#8a,#c7,#cb,#45,#cb,#cf
db #c3,#c3,#c7,#8a,#41,#45,#8a,#8a
db #cb,#c3,#cb,#cb,#c3,#c3,#c7,#c3
db #45,#45,#c3,#c7,#8a,#45,#8a,#cf
db #c3,#c3,#45,#8a,#cf,#c3,#cb,#c3
db #c3,#c7,#c7,#c7,#c7,#c7,#c3,#cb
db #00,#00,#45,#41,#c3,#c3,#c3,#c3
db #c7,#c3,#c3,#c3,#00,#00,#45,#cb
db #c7,#c3,#cb,#cb,#8a,#8a,#45,#cb
db #00,#00,#cb,#c7,#00,#00,#00,#00
db #00,#00,#00,#00,#cb,#00,#c7,#00
db #00,#00,#00,#00,#00,#00,#cb,#45
db #c3,#c7,#cb,#cb,#8a,#8a,#cb,#45
db #00,#00,#41,#45,#c7,#c3,#c7,#c3
db #c3,#c7,#c3,#c3,#c7,#cf,#c7,#cb
db #41,#8a,#cb,#00,#c3,#c3,#cb,#c3
db #45,#41,#8a,#8a,#cb,#c3,#cb,#cb
db #c3,#c3,#c3,#c7,#45,#41,#c7,#8a
db #00,#45,#8a,#cf,#c3,#c3,#8a,#c7
db #c3,#cf,#c3,#c3,#c7,#8a,#c7,#8a
db #c7,#c3,#cb,#45,#00,#cf,#41,#cb
db #c3,#c3,#c3,#c7,#c3,#c7,#c3,#c3
db #00,#00,#cb,#45,#c3,#c3,#cb,#c3
db #8a,#c7,#cb,#c3,#00,#00,#00,#45
db #cb,#c7,#c7,#cb,#00,#8a,#00,#45
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #c7,#41,#c3,#82,#00,#00,#45,#00
db #00,#00,#c7,#cb,#c3,#8a,#cb,#00
db #c7,#8a,#c3,#cb,#cf,#45,#45,#cb
db #c3,#c3,#cb,#cb,#c3,#c3,#c3,#c3
db #45,#c3,#c7,#8a,#00,#45,#8a,#cf
db #c3,#c3,#cf,#c7,#c3,#45,#c3,#c3
db #c7,#8a,#c7,#8a,#c7,#c3,#cb,#45
db #00,#cf,#41,#cb,#c3,#c3,#c3,#c7
db #c3,#c7,#c3,#c3,#00,#00,#cb,#45
db #c3,#c3,#cb,#c3,#8a,#c7,#cb,#c3
db #00,#00,#00,#45,#cb,#c7,#c7,#cb
db #00,#8a,#00,#45,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#01,#00,#83,#03,#c3,#03
db #02,#00,#00,#00,#00,#00,#c3,#43
db #83,#83,#c3,#c3,#c3,#83,#00,#00
db #41,#01,#c3,#03,#c3,#03,#83,#03
db #43,#c3,#82,#02,#43,#01,#43,#03
db #83,#43,#c3,#c3,#83,#03,#03,#83
db #c3,#c3,#83,#43,#c3,#c3,#83,#43
db #c3,#c3,#02,#c3,#c3,#c3,#83,#83
db #c3,#c3,#83,#83,#c3,#c3,#02,#c3
db #43,#c3,#43,#43,#83,#c3,#c3,#43
db #83,#c3,#03,#c3,#41,#01,#c3,#03
db #c3,#43,#83,#c3,#43,#03,#82,#83
db #00,#01,#c3,#03,#83,#03,#c3,#03
db #c3,#c3,#00,#02,#00,#00,#01,#43
db #83,#83,#c3,#c3,#02,#83,#00,#00
db #00,#00,#03,#03,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#01,#00
db #83,#00,#c3,#00,#02,#00,#00,#00
db #01,#00,#03,#43,#03,#83,#03,#c3
db #c3,#83,#02,#00,#43,#01,#43,#03
db #83,#c3,#c3,#83,#83,#43,#03,#82
db #c3,#c3,#83,#43,#c3,#c3,#83,#43
db #c3,#c3,#82,#c3,#c3,#c3,#c3,#83
db #c3,#c3,#83,#83,#c3,#c3,#82,#c3
db #43,#c3,#03,#43,#03,#c3,#c3,#43
db #83,#c3,#03,#c3,#01,#41,#03,#c3
db #03,#c3,#03,#83,#c3,#43,#02,#82
db #00,#00,#01,#43,#83,#83,#c3,#c3
db #02,#83,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#03,#00,#03,#00
db #02,#00,#00,#00,#43,#01,#03,#01
db #03,#83,#03,#c3,#c3,#03,#02,#00
db #c3,#c3,#83,#43,#c3,#c3,#c3,#83
db #c3,#43,#c3,#82,#c3,#c3,#43,#c3
db #c3,#c3,#43,#83,#c3,#c3,#c3,#c3
db #43,#c3,#03,#c3,#03,#c3,#43,#83
db #c3,#43,#02,#82,#00,#01,#00,#43
db #83,#83,#c3,#c3,#02,#83,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#43,#01,#43,#01
db #c3,#03,#03,#03,#c3,#00,#02,#00
db #c3,#c3,#43,#c3,#c3,#c3,#43,#83
db #c3,#43,#83,#82,#c3,#c3,#43,#83
db #83,#c3,#c3,#c3,#c3,#c3,#83,#c3
db #43,#c3,#01,#03,#02,#83,#03,#83
db #00,#43,#00,#82,#00,#01,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#83,#00,#c3,#00
db #02,#00,#00,#00,#43,#01,#03,#43
db #03,#83,#43,#c3,#c3,#83,#02,#00
db #c3,#c3,#01,#c3,#83,#c3,#41,#83
db #c3,#43,#c3,#82,#c3,#c3,#83,#43
db #41,#c3,#83,#03,#c3,#c3,#c3,#c3
db #43,#c3,#03,#43,#03,#c3,#03,#83
db #c3,#43,#02,#82,#00,#01,#00,#01
db #03,#83,#03,#c3,#02,#03,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#01,#00
db #83,#00,#c3,#00,#02,#00,#00,#00
db #01,#00,#03,#43,#03,#83,#03,#c3
db #c3,#83,#02,#00,#43,#41,#03,#c3
db #03,#c3,#c3,#83,#83,#43,#03,#82
db #c3,#c3,#c3,#43,#c3,#c3,#83,#43
db #c3,#c3,#82,#c3,#c3,#c3,#83,#83
db #c3,#c3,#83,#83,#c3,#c3,#82,#c3
db #03,#c3,#43,#43,#83,#c3,#c3,#43
db #83,#c3,#00,#c3,#00,#41,#00,#03
db #00,#c3,#00,#83,#c3,#41,#02,#82
db #00,#00,#01,#43,#82,#82,#c3,#c3
db #02,#83,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #61,#10,#c3,#c3,#92,#20,#00,#00
db #00,#00,#00,#00,#41,#30,#10,#30
db #20,#30,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#10,#10,#c3,#92,#20
db #00,#00,#20,#00,#00,#00,#00,#00
db #00,#00,#41,#61,#92,#30,#c3,#92
db #61,#10,#c3,#30,#92,#20,#00,#00
db #c3,#c3,#61,#c3,#61,#c3,#c3,#c3
db #92,#c3,#00,#61,#c3,#c3,#61,#61
db #00,#10,#00,#30,#00,#20,#41,#00
db #92,#c3,#c3,#c3,#00,#00,#00,#00
db #10,#00,#92,#61,#00,#30,#20,#92
db #41,#00,#10,#10,#20,#c3,#00,#20
db #00,#00,#00,#00,#61,#30,#c3,#30
db #92,#30,#00,#00,#00,#00,#00,#00
db #10,#c3,#20,#00,#00,#00,#00,#00
db #10,#00,#c3,#00,#20,#00,#00,#00
db #00,#00,#00,#00,#61,#61,#30,#c3
db #c3,#92,#00,#00,#00,#00,#00,#00
db #10,#10,#30,#30,#20,#20,#41,#20
db #00,#00,#00,#00,#c3,#61,#c3,#c3
db #c3,#92,#00,#00,#92,#30,#92,#20
db #10,#61,#30,#c3,#20,#92,#41,#82
db #c3,#c3,#c3,#c3,#10,#00,#30,#00
db #20,#00,#10,#00,#c3,#c3,#c3,#c3
db #30,#30,#30,#30,#30,#30,#00,#20
db #92,#c3,#92,#c3,#10,#20,#30,#00
db #20,#10,#41,#00,#00,#30,#00,#20
db #c3,#61,#c3,#c3,#c3,#92,#00,#82
db #00,#00,#00,#00,#10,#61,#30,#c3
db #20,#92,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#10,#00,#30,#00
db #20,#00,#00,#00,#00,#00,#00,#00
db #c3,#61,#c3,#c3,#c3,#92,#00,#00
db #00,#00,#00,#00,#10,#61,#30,#c3
db #20,#92,#41,#82,#92,#30,#82,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #c3,#c3,#c3,#c3,#00,#00,#00,#00
db #00,#00,#00,#00,#c3,#c3,#c3,#c3
db #10,#00,#30,#00,#20,#00,#41,#00
db #92,#c3,#82,#c3,#c3,#61,#c3,#c3
db #c3,#92,#00,#82,#00,#30,#00,#00
db #10,#61,#30,#c3,#20,#92,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #10,#00,#30,#00,#20,#00,#00,#00
db #00,#00,#00,#00,#c3,#61,#c3,#c3
db #c3,#92,#00,#00,#00,#00,#00,#00
db #10,#61,#30,#c3,#20,#92,#41,#82
db #00,#00,#20,#00,#30,#20,#30,#00
db #30,#10,#20,#00,#92,#30,#30,#30
db #10,#30,#30,#30,#20,#30,#00,#10
db #c3,#c3,#61,#92,#10,#00,#30,#00
db #20,#00,#41,#00,#c3,#c3,#61,#61
db #c3,#61,#c3,#c3,#c3,#92,#00,#82
db #92,#c3,#30,#92,#10,#61,#30,#c3
db #20,#92,#10,#00,#00,#30,#20,#30
db #61,#10,#30,#30,#92,#20,#00,#20
db #00,#00,#00,#00,#10,#61,#c3,#c3
db #20,#92,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #41,#00,#f3,#c3,#d3,#00,#e3,#f3
db #c3,#d3,#f3,#a2,#41,#51,#f3,#f3
db #00,#f3,#41,#e3,#c3,#c3,#c3,#e3
db #00,#00,#00,#00,#00,#00,#e3,#51
db #c3,#c3,#f3,#d3,#d3,#00,#c3,#00
db #c3,#e3,#a2,#c3,#f3,#f3,#a2,#f3
db #00,#00,#00,#00,#00,#00,#51,#00
db #f3,#f3,#00,#a2,#d3,#00,#d3,#00
db #d3,#51,#a2,#f3,#00,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #41,#00,#c3,#c3,#c3,#00,#e3,#e3
db #c3,#c3,#f3,#a2,#00,#41,#f3,#f3
db #00,#f3,#41,#e3,#c3,#c3,#c3,#e3
db #00,#00,#00,#00,#00,#00,#41,#51
db #c3,#c3,#a2,#d3,#00,#00,#00,#00
db #00,#00,#c3,#e3,#d3,#c3,#00,#00
db #d3,#00,#c3,#00,#c3,#e3,#a2,#d3
db #00,#00,#00,#00,#00,#f3,#00,#f3
db #00,#a2,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #41,#00,#c3,#c3,#c3,#00,#e3,#e3
db #c3,#c3,#f3,#a2,#00,#41,#f3,#c3
db #00,#f3,#41,#e3,#f3,#c3,#c3,#e3
db #00,#00,#00,#00,#00,#00,#51,#51
db #c3,#c3,#82,#f3,#00,#00,#00,#00
db #00,#00,#e3,#41,#c3,#c3,#00,#a2
db #00,#00,#00,#00,#51,#00,#c3,#c3
db #a2,#d3,#00,#00,#d3,#00,#c3,#00
db #c3,#e3,#a2,#d3,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #41,#00,#c3,#c3,#c3,#00,#e3,#e3
db #c3,#c3,#f3,#a2,#00,#41,#c3,#c3
db #00,#d3,#41,#e3,#c3,#c3,#c3,#e3
db #00,#00,#00,#00,#00,#00,#51,#41
db #c3,#f3,#a2,#d3,#00,#00,#00,#00
db #00,#00,#e3,#f3,#c3,#c3,#a2,#82
db #d3,#00,#d3,#00,#d3,#51,#c3,#e3
db #d3,#c3,#00,#00,#00,#00,#00,#00
db #e3,#51,#d3,#c3,#00,#a2,#00,#00
db #00,#d3,#00,#c3,#00,#c3,#00,#a2
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #51,#00,#c3,#f3,#f3,#00,#e3,#e3
db #c3,#c3,#f3,#a2,#00,#41,#c3,#c3
db #51,#c3,#e3,#e3,#c3,#c3,#e3,#e3
db #d3,#00,#d3,#00,#d3,#f3,#e3,#e3
db #f3,#c3,#82,#d3,#00,#00,#00,#00
db #00,#00,#51,#51,#c3,#00,#a2,#a2
db #00,#00,#00,#00,#00,#00,#41,#51
db #c3,#c3,#a2,#82,#00,#00,#00,#00
db #00,#00,#c3,#e3,#d3,#c3,#00,#00
db #00,#00,#00,#00,#e3,#51,#d3,#c3
db #00,#a2,#00,#00,#00,#d3,#00,#c3
db #00,#c3,#00,#a2,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#f3,#00,#c3,#00,#a2,#00
db #51,#00,#c3,#f3,#f3,#f3,#e3,#e3
db #c3,#c3,#f3,#a2,#00,#e3,#c3,#c3
db #00,#d3,#41,#e3,#c3,#c3,#e3,#e3
db #00,#00,#00,#00,#00,#00,#41,#41
db #c3,#c3,#82,#d3,#00,#00,#00,#00
db #00,#00,#51,#41,#00,#f3,#a2,#82
db #00,#00,#00,#00,#00,#00,#51,#51
db #c3,#c3,#82,#a2,#00,#00,#00,#00
db #00,#00,#e3,#41,#c3,#c3,#00,#a2
db #00,#00,#00,#00,#51,#00,#c3,#c3
db #a2,#d3,#00,#00,#d3,#00,#c3,#00
db #c3,#e3,#a2,#d3,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #41,#00,#41,#45,#cb,#45,#cf,#00
db #00,#00,#00,#00,#41,#cb,#41,#cb
db #cb,#cb,#cb,#cb,#c7,#8a,#00,#00
db #00,#00,#00,#45,#00,#41,#cb,#c7
db #cb,#c3,#8a,#8a,#00,#00,#41,#45
db #c3,#c7,#cb,#45,#c3,#c7,#c3,#cf
db #00,#00,#41,#c3,#c3,#c3,#cf,#c3
db #cf,#c3,#c3,#cf,#00,#00,#41,#45
db #c3,#8a,#cf,#45,#cf,#cb,#c3,#c3
db #00,#00,#41,#c3,#c3,#c3,#cb,#c3
db #c3,#c3,#c3,#cf,#00,#00,#00,#45
db #00,#c7,#cb,#45,#cb,#c7,#8a,#cf
db #41,#00,#41,#45,#cb,#41,#cb,#c7
db #c7,#c3,#00,#8a,#41,#cb,#41,#cb
db #cb,#cb,#cf,#cb,#00,#8a,#00,#00
db #00,#45,#45,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#41,#00,#41,#45
db #cb,#45,#cf,#00,#00,#00,#00,#00
db #45,#cb,#45,#cb,#cb,#cb,#c3,#cb
db #c7,#8a,#00,#00,#00,#00,#45,#cf
db #c7,#cf,#45,#cf,#cf,#cf,#c3,#cf
db #00,#00,#c7,#41,#cf,#c3,#c7,#cf
db #cf,#cb,#cf,#c3,#00,#00,#c3,#41
db #c3,#c3,#c3,#cf,#c3,#c3,#c3,#c3
db #00,#00,#45,#41,#c7,#c3,#41,#cb
db #c3,#c3,#c3,#c7,#41,#00,#41,#cf
db #cb,#cf,#cb,#c7,#00,#c7,#00,#cf
db #41,#cb,#41,#cb,#cb,#cb,#cf,#cb
db #00,#00,#00,#00,#00,#00,#00,#45
db #00,#45,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#45,#00,#45,#00,#00,#00
db #45,#00,#cf,#00,#cb,#45,#cb,#41
db #cf,#cb,#45,#cf,#cb,#cf,#c3,#c3
db #00,#00,#cb,#45,#c3,#c7,#cb,#cf
db #c3,#cf,#c3,#cf,#00,#00,#cf,#c3
db #c7,#c3,#c7,#c7,#c3,#c3,#c3,#c3
db #cb,#41,#cb,#41,#cb,#cb,#cb,#cb
db #c3,#c3,#c3,#c7,#00,#41,#45,#41
db #45,#cb,#00,#cf,#45,#c7,#cf,#c3
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #45,#00,#c3,#cf,#00,#00,#00,#00
db #00,#00,#cf,#45,#cf,#cb,#cf,#c3
db #41,#00,#41,#45,#cb,#45,#c7,#cf
db #c3,#cf,#cb,#c7,#41,#cb,#41,#cb
db #cb,#cb,#cb,#cb,#c3,#c3,#cb,#c3
db #00,#00,#00,#45,#00,#45,#cb,#cf
db #cf,#cf,#cf,#c7,#00,#00,#00,#00
db #00,#00,#00,#45,#45,#cb,#c3,#c3
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#cf,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#45,#00,#45,#00,#00,#00
db #45,#00,#cf,#00,#cb,#41,#cb,#41
db #cb,#cb,#cb,#cf,#c3,#c7,#c3,#c3
db #00,#41,#cb,#41,#c7,#cb,#c7,#cb
db #c3,#c3,#c3,#c7,#00,#00,#cb,#c7
db #cb,#cb,#cb,#c7,#c3,#c3,#c3,#c3
db #cb,#00,#cb,#45,#cf,#c7,#45,#cf
db #cb,#cf,#c3,#cf,#00,#45,#45,#41
db #45,#cb,#00,#cf,#45,#cf,#cf,#c3
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#41,#00,#41,#45
db #cb,#45,#cf,#00,#00,#00,#00,#00
db #41,#cb,#41,#cb,#cb,#cb,#cb,#cb
db #00,#00,#00,#00,#00,#00,#45,#cf
db #c7,#cf,#41,#c7,#c3,#c7,#c3,#cf
db #00,#00,#c3,#41,#c3,#c3,#c3,#cb
db #c3,#c3,#c3,#c7,#00,#00,#c7,#41
db #cf,#c3,#c7,#cf,#cf,#c3,#cf,#c3
db #00,#00,#45,#41,#c7,#c3,#45,#cf
db #cf,#cb,#c3,#c3,#45,#00,#45,#cf
db #cb,#cf,#c3,#cf,#c7,#cf,#00,#cf
db #41,#cb,#41,#cb,#cb,#cb,#cf,#cb
db #00,#8a,#00,#00,#00,#00,#00,#45
db #00,#45,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#e3,#51,#82,#a2
db #00,#00,#00,#00,#00,#00,#f3,#51
db #d3,#c3,#00,#a2,#00,#00,#00,#00
db #51,#00,#c3,#d3,#d3,#d3,#00,#00
db #00,#00,#00,#00,#41,#41,#c3,#d3
db #e3,#c3,#a2,#a2,#00,#00,#00,#00
db #c3,#f3,#e3,#c3,#e3,#e3,#c3,#d3
db #e3,#51,#a2,#00,#c3,#c3,#e3,#e3
db #e3,#c3,#c3,#c3,#e3,#c3,#a2,#d3
db #41,#f3,#c3,#c3,#e3,#e3,#a2,#d3
db #00,#51,#00,#00,#51,#41,#c3,#d3
db #d3,#c3,#00,#a2,#00,#00,#00,#00
db #00,#00,#f3,#d3,#d3,#d3,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#51
db #e3,#c3,#82,#a2,#00,#00,#00,#00
db #00,#00,#51,#a2,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#51,#00,#c3,#e3,#a2,#82
db #00,#00,#00,#00,#51,#00,#c3,#d3
db #d3,#d3,#a2,#00,#00,#00,#00,#00
db #c3,#f3,#e3,#c3,#e3,#e3,#c3,#d3
db #d3,#a2,#00,#00,#d3,#c3,#c3,#e3
db #e3,#c3,#c3,#c3,#d3,#c3,#00,#a2
db #51,#e3,#c3,#c3,#d3,#e3,#00,#f3
db #00,#a2,#00,#00,#00,#00,#51,#d3
db #c3,#d3,#a2,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#e3,#00,#82
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#51,#00
db #c3,#00,#a2,#00,#00,#00,#00,#00
db #c3,#f3,#e3,#c3,#c3,#e3,#c3,#d3
db #a2,#00,#00,#00,#c3,#d3,#c3,#c3
db #c3,#c3,#e3,#c3,#a2,#d3,#00,#00
db #00,#f3,#51,#d3,#c3,#c3,#82,#51
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #e3,#f3,#c3,#f3,#c3,#f3,#e3,#f3
db #a2,#00,#00,#00,#e3,#c3,#c3,#c3
db #c3,#c3,#e3,#c3,#a2,#d3,#00,#00
db #00,#f3,#00,#f3,#00,#f3,#00,#f3
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#51,#00
db #e3,#00,#a2,#00,#00,#00,#00,#00
db #c3,#f3,#c3,#d3,#e3,#f3,#e3,#51
db #d3,#a2,#00,#00,#c3,#d3,#e3,#c3
db #e3,#e3,#c3,#c3,#d3,#c3,#00,#a2
db #00,#f3,#51,#c3,#f3,#e3,#a2,#d3
db #00,#a2,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#51,#00,#c3,#e3,#a2,#82
db #00,#00,#00,#00,#51,#00,#f3,#d3
db #f3,#d3,#00,#00,#00,#00,#00,#00
db #d3,#e3,#c3,#c3,#e3,#e3,#c3,#f3
db #e3,#51,#a2,#00,#c3,#c3,#e3,#e3
db #e3,#c3,#c3,#c3,#e3,#c3,#a2,#d3
db #51,#f3,#d3,#c3,#f3,#e3,#a2,#d3
db #00,#51,#00,#00,#00,#00,#51,#f3
db #d3,#f3,#a2,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#e3,#00,#a2
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#41,#00,#c3,#c3,#c3,#c3
db #82,#00,#00,#00,#00,#00,#3c,#69
db #c3,#c3,#c3,#c3,#c3,#c3,#00,#00
db #41,#14,#c3,#3c,#c3,#3c,#3c,#69
db #3c,#c3,#28,#28,#00,#69,#14,#69
db #c3,#c3,#c3,#96,#69,#69,#69,#3c
db #82,#3c,#00,#3c,#14,#69,#c3,#c3
db #69,#c3,#69,#c3,#96,#82,#c3,#69
db #96,#3c,#c3,#69,#69,#41,#69,#14
db #00,#3c,#14,#3c,#c3,#69,#c3,#c3
db #69,#c3,#69,#c3,#41,#69,#c3,#69
db #c3,#c3,#3c,#96,#3c,#69,#28,#3c
db #00,#14,#3c,#3c,#c3,#3c,#c3,#69
db #c3,#c3,#00,#28,#00,#00,#41,#69
db #c3,#c3,#c3,#c3,#82,#c3,#00,#00
db #00,#00,#c3,#c3,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#14,#00
db #c3,#00,#c3,#00,#82,#00,#00,#00
db #14,#00,#96,#69,#3c,#c3,#69,#c3
db #c3,#c3,#82,#00,#00,#69,#14,#c3
db #c3,#c3,#c3,#3c,#69,#3c,#96,#28
db #82,#3c,#00,#3c,#3c,#69,#c3,#c3
db #69,#c3,#c3,#c3,#c3,#96,#c3,#c3
db #c3,#96,#c3,#69,#69,#41,#c3,#14
db #00,#3c,#14,#3c,#c3,#69,#c3,#c3
db #69,#c3,#3c,#c3,#14,#69,#3c,#c3
db #3c,#c3,#69,#3c,#c3,#3c,#82,#28
db #00,#00,#14,#69,#c3,#c3,#c3,#c3
db #82,#c3,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#14,#00,#c3,#00
db #c3,#00,#c3,#00,#96,#00,#00,#00
db #00,#c3,#14,#c3,#c3,#3c,#c3,#69
db #69,#c3,#96,#28,#c3,#3c,#c3,#c3
db #96,#c3,#c3,#c3,#69,#c3,#c3,#c3
db #69,#00,#c3,#14,#c3,#69,#c3,#c3
db #c3,#c3,#3c,#c3,#00,#14,#00,#c3
db #00,#c3,#00,#c3,#00,#96,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #14,#00,#3c,#00,#c3,#00,#69,#00
db #69,#00,#c3,#3c,#69,#3c,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #00,#14,#00,#3c,#00,#c3,#00,#69
db #00,#69,#3c,#c3,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#14,#00,#69,#00
db #c3,#00,#c3,#00,#96,#00,#00,#00
db #00,#69,#14,#3c,#69,#3c,#c3,#3c
db #69,#3c,#69,#3c,#3c,#96,#3c,#c3
db #69,#96,#c3,#c3,#69,#3c,#69,#69
db #c3,#00,#3c,#14,#3c,#c3,#3c,#c3
db #69,#3c,#28,#3c,#00,#14,#00,#c3
db #00,#c3,#00,#c3,#00,#96,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#14,#00
db #c3,#00,#c3,#00,#28,#00,#00,#00
db #14,#00,#3c,#69,#3c,#96,#3c,#69
db #c3,#96,#28,#00,#00,#69,#14,#c3
db #c3,#c3,#c3,#3c,#69,#3c,#3c,#28
db #96,#3c,#69,#3c,#3c,#69,#c3,#c3
db #69,#c3,#c3,#c3,#82,#82,#c3,#c3
db #96,#82,#c3,#69,#69,#41,#c3,#14
db #00,#3c,#14,#3c,#c3,#69,#c3,#c3
db #69,#c3,#96,#c3,#14,#69,#3c,#69
db #3c,#c3,#3c,#3c,#c3,#3c,#28,#28
db #00,#00,#14,#69,#c3,#96,#c3,#69
db #28,#96,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#15,#00,#6b,#00
db #6b,#3f,#c3,#3f,#c3,#3f,#2a,#00
db #97,#6b,#3f,#c3,#2a,#c3,#c3,#c3
db #6b,#c3,#2a,#97,#3f,#3f,#3f,#3f
db #00,#2a,#6b,#41,#c3,#c3,#82,#82
db #6b,#97,#c3,#00,#c3,#15,#3f,#c3
db #15,#6b,#97,#2a,#00,#15,#00,#6b
db #3f,#3f,#3f,#3f,#3f,#6b,#00,#2a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#6b,#00,#6b,#3f,#c3,#3f
db #c3,#3f,#2a,#00,#3f,#15,#3f,#c3
db #2a,#c3,#6b,#c3,#2a,#c3,#00,#97
db #97,#6b,#3f,#c3,#2a,#97,#c3,#97
db #6b,#15,#2a,#00,#3f,#3f,#3f,#c3
db #00,#2a,#6b,#41,#c3,#c3,#82,#82
db #6b,#97,#c3,#00,#c3,#15,#3f,#c3
db #15,#3f,#00,#2a,#15,#15,#c3,#3f
db #c3,#3f,#c3,#3f,#c3,#2a,#97,#00
db #00,#00,#00,#6b,#3f,#6b,#3f,#c3
db #3f,#c3,#00,#2a,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#3f,#00,#3f,#00
db #3f,#00,#00,#00,#15,#00,#c3,#6b
db #c3,#6b,#c3,#c3,#c3,#c3,#97,#2a
db #2a,#41,#00,#2a,#00,#00,#6b,#15
db #2a,#3f,#00,#97,#15,#00,#3f,#00
db #6b,#15,#82,#97,#00,#00,#00,#00
db #97,#6b,#c3,#c3,#2a,#c3,#c3,#3f
db #6b,#15,#2a,#00,#3f,#6b,#3f,#c3
db #00,#2a,#6b,#41,#3f,#c3,#2a,#82
db #6b,#97,#c3,#00,#c3,#15,#3f,#c3
db #15,#6b,#00,#2a,#2a,#15,#00,#3f
db #00,#3f,#6b,#97,#2a,#00,#00,#00
db #15,#41,#c3,#2a,#c3,#00,#c3,#15
db #c3,#3f,#97,#97,#00,#00,#00,#6b
db #3f,#6b,#3f,#c3,#3f,#c3,#00,#2a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#6b,#00,#6b,#3f,#c3,#3f
db #c3,#3f,#2a,#00,#41,#15,#2a,#c3
db #00,#c3,#15,#c3,#3f,#c3,#97,#97
db #00,#2a,#00,#00,#15,#00,#97,#6b
db #00,#2a,#00,#00,#15,#00,#3f,#00
db #3f,#41,#2a,#82,#00,#00,#00,#00
db #97,#6b,#c3,#c3,#2a,#c3,#c3,#3f
db #6b,#15,#2a,#00,#3f,#6b,#97,#c3
db #00,#2a,#6b,#41,#3f,#3f,#2a,#2a
db #6b,#97,#c3,#00,#c3,#15,#3f,#c3
db #15,#6b,#00,#2a,#00,#15,#00,#3f
db #15,#6b,#97,#82,#00,#00,#00,#00
db #41,#2a,#2a,#00,#00,#00,#15,#6b
db #3f,#2a,#97,#00,#00,#15,#6b,#c3
db #6b,#c3,#c3,#c3,#c3,#c3,#2a,#97
db #00,#00,#3f,#3f,#3f,#00,#00,#00
db #00,#00,#00,#00,#3f,#00,#3f,#00
db #3f,#00,#00,#00,#15,#00,#c3,#6b
db #c3,#6b,#c3,#c3,#c3,#c3,#97,#2a
db #2a,#41,#00,#2a,#00,#00,#6b,#15
db #2a,#3f,#00,#97,#15,#00,#3f,#00
db #6b,#15,#3f,#97,#00,#00,#00,#00
db #97,#6b,#c3,#c3,#2a,#c3,#c3,#3f
db #6b,#15,#2a,#00,#3f,#6b,#c3,#c3
db #00,#2a,#41,#6b,#c3,#3f,#82,#2a
db #41,#97,#c3,#00,#c3,#15,#82,#c3
db #15,#6b,#00,#2a,#2a,#00,#00,#00
db #00,#15,#6b,#97,#2a,#00,#00,#00
db #15,#41,#c3,#2a,#c3,#00,#c3,#15
db #c3,#3f,#97,#97,#00,#00,#00,#6b
db #3f,#6b,#3f,#c3,#3f,#c3,#00,#2a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#6b,#00,#6b,#3f,#c3,#3f
db #c3,#3f,#2a,#00,#15,#15,#3f,#c3
db #6b,#c3,#3f,#c3,#2a,#c3,#00,#97
db #97,#6b,#c3,#c3,#82,#c3,#c3,#3f
db #3f,#15,#2a,#00,#3f,#6b,#c3,#c3
db #00,#2a,#41,#6b,#c3,#c3,#82,#82
db #6b,#97,#c3,#00,#c3,#15,#97,#c3
db #15,#6b,#00,#2a,#15,#3f,#c3,#3f
db #c3,#2a,#c3,#6b,#c3,#2a,#97,#00
db #00,#00,#00,#6b,#3f,#6b,#3f,#c3
db #3f,#c3,#00,#2a,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#15,#00,#2e,#00
db #3f,#3f,#3f,#3f,#2e,#3f,#2a,#00
db #0c,#2e,#c3,#0c,#1d,#0c,#86,#3f
db #2e,#15,#2a,#1d,#2e,#49,#0c,#c3
db #2a,#08,#41,#6b,#49,#49,#08,#08
db #3f,#1d,#49,#0c,#49,#2a,#c3,#86
db #c3,#2e,#1d,#2a,#00,#15,#00,#2e
db #3f,#2e,#3f,#0c,#3f,#0c,#00,#2a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#01,#00,#33,#01
db #23,#02,#00,#00,#13,#00,#c3,#13
db #23,#83,#63,#63,#41,#11,#83,#02
db #00,#93,#03,#33,#63,#13,#63,#63
db #41,#11,#93,#23,#00,#00,#00,#00
db #00,#01,#00,#13,#00,#00,#00,#00
db #00,#00,#01,#00,#11,#01,#83,#22
db #83,#22,#23,#02,#00,#00,#01,#41
db #11,#43,#83,#93,#83,#83,#23,#93
db #00,#00,#00,#00,#00,#01,#00,#22
db #00,#22,#00,#02,#00,#00,#03,#00
db #63,#01,#63,#13,#41,#00,#93,#00
db #13,#93,#c3,#33,#23,#13,#63,#63
db #41,#11,#83,#23,#00,#00,#00,#13
db #01,#83,#33,#63,#23,#11,#00,#02
db #00,#00,#00,#01,#02,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#01,#00
db #02,#00,#00,#00,#00,#00,#13,#00
db #83,#01,#63,#33,#11,#83,#02,#00
db #c3,#43,#33,#c3,#13,#23,#c3,#c3
db #41,#41,#23,#83,#00,#00,#00,#03
db #01,#63,#13,#c3,#00,#41,#00,#93
db #00,#00,#02,#00,#33,#03,#83,#22
db #83,#22,#23,#02,#00,#00,#02,#83
db #33,#c3,#83,#93,#83,#83,#23,#93
db #00,#00,#00,#00,#01,#03,#13,#22
db #00,#22,#00,#02,#c3,#00,#33,#03
db #13,#63,#c3,#c3,#41,#41,#23,#93
db #00,#43,#13,#c3,#83,#23,#63,#c3
db #11,#41,#02,#83,#00,#00,#00,#00
db #00,#01,#01,#33,#02,#83,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#13,#00,#33,#00
db #02,#00,#00,#00,#63,#01,#93,#63
db #43,#63,#c3,#93,#c3,#83,#02,#00
db #01,#00,#11,#00,#13,#01,#83,#22
db #83,#22,#23,#02,#01,#41,#11,#43
db #03,#63,#03,#93,#03,#83,#23,#93
db #63,#01,#93,#13,#c3,#c3,#93,#93
db #c3,#c3,#02,#22,#00,#01,#00,#63
db #13,#63,#33,#93,#02,#83,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #02,#00,#22,#02,#03,#01,#03,#22
db #03,#22,#23,#02,#02,#63,#22,#93
db #03,#13,#03,#93,#03,#c3,#23,#13
db #00,#00,#00,#02,#00,#01,#00,#22
db #00,#22,#00,#02,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#03,#00,#03,#00
db #02,#00,#00,#00,#33,#01,#33,#33
db #13,#13,#02,#22,#13,#23,#02,#00
db #02,#01,#22,#13,#03,#33,#03,#02
db #03,#13,#23,#22,#02,#83,#22,#83
db #13,#63,#83,#93,#83,#83,#23,#93
db #33,#00,#33,#02,#13,#01,#03,#22
db #13,#22,#02,#02,#00,#01,#00,#33
db #03,#13,#03,#22,#02,#23,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#01,#00
db #02,#00,#00,#00,#00,#00,#13,#00
db #83,#01,#63,#33,#11,#23,#02,#00
db #93,#13,#33,#93,#13,#23,#33,#33
db #11,#41,#23,#83,#00,#00,#00,#03
db #01,#33,#13,#33,#00,#11,#00,#93
db #00,#00,#02,#00,#33,#03,#83,#22
db #83,#22,#23,#02,#00,#00,#02,#83
db #33,#c3,#83,#93,#83,#83,#23,#93
db #00,#00,#00,#00,#01,#03,#13,#22
db #00,#22,#00,#02,#93,#00,#33,#03
db #13,#33,#33,#33,#11,#11,#23,#93
db #00,#13,#13,#93,#83,#23,#63,#33
db #11,#41,#02,#83,#00,#00,#00,#00
db #00,#01,#01,#33,#02,#23,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#10,#00,#20,#00,#00,#00
db #00,#00,#00,#00,#10,#00,#0a,#25
db #87,#0f,#92,#20,#0a,#20,#0a,#00
db #25,#61,#0a,#82,#0f,#0f,#92,#1a
db #0a,#92,#0a,#92,#00,#4b,#00,#0a
db #1a,#0f,#25,#30,#20,#30,#00,#00
db #25,#10,#61,#05,#61,#05,#0f,#4b
db #0f,#0a,#00,#00,#25,#4b,#61,#61
db #61,#4b,#30,#0f,#25,#0a,#00,#00
db #00,#10,#00,#05,#1a,#05,#25,#0f
db #20,#0a,#00,#00,#25,#4b,#0a,#0a
db #0f,#0f,#1a,#30,#20,#30,#20,#00
db #10,#61,#0a,#82,#87,#0f,#92,#1a
db #0a,#92,#0a,#92,#00,#00,#10,#25
db #20,#0f,#00,#20,#00,#20,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#10,#00,#30,#00,#20,#00
db #20,#00,#00,#00,#10,#00,#92,#61
db #10,#41,#92,#92,#92,#82,#92,#82
db #61,#41,#30,#92,#30,#10,#61,#92
db #92,#82,#00,#82,#61,#c3,#61,#61
db #61,#c3,#92,#92,#92,#61,#00,#00
db #10,#10,#92,#41,#30,#41,#30,#61
db #92,#20,#92,#00,#00,#00,#10,#61
db #30,#41,#20,#92,#20,#82,#00,#20
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #61,#10,#30,#41,#30,#41,#92,#20
db #82,#20,#82,#00,#61,#92,#30,#c3
db #30,#c3,#92,#92,#82,#92,#82,#92
db #00,#10,#00,#41,#00,#41,#00,#20
db #00,#20,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#10,#00,#c3,#00,#20,#00
db #20,#00,#00,#00,#10,#00,#c3,#61
db #c3,#c3,#30,#92,#92,#82,#92,#20
db #61,#10,#61,#41,#61,#41,#c3,#61
db #92,#20,#00,#00,#61,#c3,#30,#61
db #30,#c3,#61,#c3,#30,#c3,#00,#00
db #10,#41,#c3,#c3,#c3,#c3,#92,#92
db #92,#82,#92,#82,#00,#00,#10,#61
db #c3,#c3,#20,#92,#20,#82,#00,#82
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#10,#00,#20,#00,#00,#00
db #00,#00,#00,#00,#10,#00,#82,#61
db #c3,#c3,#92,#20,#82,#20,#82,#00
db #61,#61,#82,#82,#c3,#c3,#92,#92
db #20,#92,#20,#92,#00,#c3,#00,#82
db #92,#c3,#61,#30,#20,#30,#00,#00
db #61,#10,#61,#41,#61,#41,#30,#c3
db #61,#82,#00,#00,#61,#c3,#61,#61
db #61,#c3,#c3,#c3,#c3,#82,#00,#00
db #00,#10,#00,#41,#92,#41,#61,#c3
db #20,#82,#00,#00,#61,#c3,#82,#82
db #c3,#c3,#92,#30,#82,#30,#82,#00
db #10,#61,#82,#82,#c3,#c3,#92,#92
db #82,#92,#82,#92,#00,#00,#10,#61
db #20,#c3,#00,#20,#00,#20,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#61,#10,#c3,#20,#92,#20
db #82,#20,#82,#00,#61,#10,#82,#82
db #c3,#c3,#92,#92,#82,#92,#82,#92
db #c3,#61,#82,#82,#c3,#c3,#00,#82
db #00,#20,#00,#00,#00,#00,#00,#00
db #00,#92,#c3,#61,#82,#20,#00,#00
db #61,#10,#61,#41,#61,#41,#c3,#c3
db #82,#c3,#00,#00,#61,#c3,#61,#61
db #61,#c3,#c3,#10,#82,#20,#00,#00
db #00,#10,#00,#41,#00,#41,#c3,#c3
db #82,#c3,#00,#00,#c3,#00,#82,#00
db #c3,#92,#00,#61,#00,#20,#00,#00
db #61,#61,#82,#82,#c3,#c3,#92,#82
db #82,#20,#82,#00,#00,#10,#61,#82
db #c3,#c3,#92,#92,#82,#92,#82,#92
db #00,#10,#20,#20,#20,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#14,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#14,#14,#96,#69
db #00,#00,#00,#00,#c3,#41,#c3,#14
db #c3,#c3,#96,#96,#96,#28,#28,#00
db #00,#14,#14,#14,#3c,#96,#96,#96
db #96,#96,#96,#82,#00,#00,#41,#41
db #3c,#3c,#3c,#3c,#3c,#96,#96,#c3
db #69,#14,#96,#14,#3c,#3c,#3c,#3c
db #3c,#3c,#28,#82,#00,#14,#00,#00
db #14,#96,#c3,#3c,#00,#28,#00,#00
db #00,#00,#00,#00,#00,#14,#14,#69
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #14,#14,#96,#28,#00,#00,#00,#00
db #c3,#41,#c3,#14,#c3,#c3,#96,#96
db #82,#28,#00,#00,#00,#41,#00,#14
db #3c,#96,#96,#96,#96,#96,#28,#00
db #00,#00,#41,#14,#69,#3c,#3c,#3c
db #96,#96,#96,#82,#00,#00,#41,#41
db #69,#69,#96,#3c,#96,#3c,#96,#c3
db #00,#00,#00,#14,#3c,#3c,#c3,#96
db #3c,#96,#28,#82,#69,#14,#c3,#14
db #96,#96,#96,#69,#28,#69,#00,#00
db #00,#14,#00,#14,#14,#96,#96,#3c
db #00,#82,#00,#00,#00,#00,#00,#00
db #00,#41,#00,#82,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#14,#00,#28,#00
db #00,#00,#00,#00,#41,#00,#14,#00
db #c3,#14,#96,#96,#28,#00,#00,#00
db #41,#c3,#14,#c3,#96,#c3,#96,#96
db #96,#82,#00,#00,#00,#00,#00,#00
db #3c,#14,#3c,#96,#96,#96,#82,#00
db #00,#00,#41,#14,#69,#3c,#96,#3c
db #96,#96,#96,#82,#00,#00,#41,#41
db #69,#69,#c3,#c3,#96,#96,#96,#c3
db #00,#00,#00,#14,#28,#3c,#3c,#96
db #3c,#96,#82,#82,#14,#00,#14,#00
db #96,#14,#3c,#96,#96,#3c,#00,#00
db #14,#69,#14,#c3,#c3,#96,#96,#96
db #28,#82,#00,#00,#00,#00,#00,#00
db #14,#41,#82,#96,#00,#00,#00,#00
db #00,#00,#14,#28,#00,#00,#00,#00
db #00,#00,#00,#00,#14,#14,#96,#28
db #00,#00,#00,#00,#c3,#41,#c3,#14
db #c3,#c3,#96,#96,#82,#28,#00,#00
db #00,#41,#00,#14,#14,#96,#96,#96
db #96,#96,#00,#00,#00,#00,#00,#00
db #28,#00,#28,#14,#3c,#96,#82,#28
db #00,#00,#41,#14,#69,#3c,#c3,#96
db #96,#96,#96,#82,#00,#00,#41,#41
db #69,#69,#c3,#c3,#96,#96,#96,#c3
db #00,#00,#00,#14,#28,#3c,#28,#96
db #3c,#96,#82,#82,#00,#00,#00,#00
db #14,#00,#96,#14,#96,#96,#00,#28
db #69,#41,#c3,#14,#c3,#96,#96,#96
db #82,#96,#00,#00,#00,#41,#00,#14
db #14,#c3,#96,#96,#00,#28,#00,#00
db #00,#00,#14,#28,#00,#00,#00,#00
db #00,#00,#00,#00,#14,#00,#28,#00
db #00,#00,#00,#00,#14,#00,#14,#00
db #c3,#14,#96,#96,#28,#00,#00,#00
db #14,#69,#14,#c3,#96,#96,#3c,#96
db #96,#82,#00,#00,#00,#00,#00,#00
db #28,#14,#3c,#96,#3c,#3c,#82,#28
db #00,#00,#41,#14,#69,#3c,#c3,#96
db #96,#96,#96,#82,#00,#00,#41,#41
db #69,#69,#96,#c3,#96,#96,#96,#c3
db #00,#00,#00,#14,#3c,#3c,#96,#3c
db #96,#96,#82,#82,#41,#00,#14,#00
db #c3,#41,#96,#96,#96,#96,#00,#28
db #41,#c3,#14,#c3,#96,#96,#96,#96
db #28,#28,#00,#00,#00,#00,#00,#00
db #14,#14,#28,#3c,#00,#00,#00,#00
db #00,#00,#14,#28,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #41,#14,#96,#82,#00,#00,#00,#00
db #69,#14,#c3,#14,#96,#96,#96,#3c
db #28,#82,#00,#00,#00,#14,#00,#14
db #3c,#96,#c3,#69,#3c,#3c,#28,#00
db #00,#00,#41,#14,#69,#3c,#96,#96
db #96,#96,#96,#28,#00,#00,#41,#41
db #3c,#69,#96,#3c,#96,#96,#96,#c3
db #00,#00,#00,#14,#69,#3c,#96,#96
db #96,#96,#28,#28,#c3,#41,#c3,#14
db #96,#c3,#96,#96,#28,#96,#00,#00
db #00,#41,#00,#14,#14,#96,#3c,#3c
db #00,#28,#00,#00,#00,#00,#00,#00
db #00,#14,#00,#28,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#14,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#14,#14,#c3,#69
db #00,#00,#00,#00,#69,#14,#96,#14
db #96,#96,#3c,#96,#3c,#28,#28,#00
db #00,#14,#41,#14,#3c,#3c,#96,#3c
db #96,#3c,#3c,#28,#00,#00,#41,#41
db #69,#69,#96,#96,#96,#96,#3c,#c3
db #c3,#41,#c3,#14,#96,#96,#96,#96
db #3c,#96,#28,#28,#00,#41,#00,#14
db #14,#96,#3c,#3c,#00,#28,#00,#00
db #00,#00,#00,#00,#00,#14,#14,#69
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#69,#14,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#14,#28,#c3
db #00,#00,#00,#00,#00,#00,#14,#00
db #69,#14,#96,#3c,#3c,#00,#28,#00
db #69,#14,#3c,#14,#c3,#69,#96,#96
db #96,#96,#96,#28,#69,#c3,#3c,#c3
db #96,#96,#96,#96,#96,#96,#96,#c3
db #00,#14,#14,#14,#3c,#3c,#3c,#96
db #3c,#3c,#28,#28,#00,#00,#00,#00
db #00,#14,#28,#3c,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#14,#69,#c3
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#14,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#c3,#00,#a2,#00,#51,#00
db #00,#00,#00,#00,#00,#00,#a2,#00
db #e3,#c3,#d3,#c3,#51,#00,#00,#00
db #c3,#00,#d3,#82,#f3,#e3,#f3,#d3
db #e3,#41,#a2,#00,#51,#51,#f3,#f3
db #f3,#d3,#f3,#e3,#f3,#f3,#e3,#f3
db #c3,#e3,#e3,#f3,#c3,#d3,#c3,#e3
db #d3,#f3,#c3,#c3,#c3,#c3,#e3,#e3
db #f3,#c3,#f3,#c3,#d3,#d3,#c3,#c3
db #51,#f3,#f3,#f3,#e3,#f3,#d3,#f3
db #f3,#f3,#e3,#e3,#51,#c3,#d3,#d3
db #c3,#c3,#c3,#c3,#e3,#e3,#a2,#e3
db #00,#00,#a2,#82,#f3,#e3,#f3,#d3
db #51,#41,#00,#00,#00,#00,#c3,#00
db #82,#f3,#41,#f3,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#e3,#00
db #e3,#82,#d3,#41,#00,#00,#00,#00
db #00,#00,#a2,#82,#d3,#f3,#e3,#f3
db #51,#41,#00,#00,#c3,#51,#f3,#d3
db #f3,#f3,#f3,#f3,#f3,#e3,#f3,#a2
db #c3,#41,#e3,#f3,#e3,#d3,#d3,#e3
db #d3,#f3,#c3,#c3,#f3,#d3,#f3,#e3
db #e3,#f3,#d3,#f3,#f3,#d3,#e3,#e3
db #51,#c3,#d3,#d3,#c3,#c3,#c3,#c3
db #e3,#e3,#e3,#e3,#00,#51,#a2,#d3
db #e3,#e3,#d3,#d3,#51,#e3,#00,#a2
db #00,#00,#c3,#a2,#d3,#f3,#e3,#f3
db #00,#51,#00,#00,#00,#00,#00,#00
db #00,#82,#00,#41,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#e3,#a2,#d3,#51
db #00,#00,#00,#00,#51,#00,#d3,#a2
db #d3,#f3,#e3,#f3,#e3,#51,#a2,#00
db #e3,#51,#e3,#f3,#e3,#f3,#d3,#f3
db #d3,#f3,#c3,#f3,#f3,#c3,#d3,#d3
db #c3,#c3,#c3,#c3,#e3,#e3,#e3,#e3
db #51,#51,#f3,#d3,#e3,#e3,#d3,#d3
db #f3,#e3,#a2,#e3,#00,#00,#c3,#a2
db #d3,#d3,#e3,#e3,#00,#51,#00,#00
db #00,#00,#00,#00,#00,#82,#00,#41
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#a2,#00
db #f3,#f3,#f3,#f3,#51,#00,#00,#00
db #f3,#51,#d3,#f3,#c3,#c3,#c3,#c3
db #e3,#f3,#e3,#a2,#f3,#c3,#f3,#d3
db #c3,#e3,#c3,#d3,#f3,#e3,#e3,#e3
db #00,#51,#a2,#c3,#d3,#d3,#e3,#e3
db #51,#f3,#00,#a2,#00,#00,#00,#00
db #00,#f3,#00,#f3,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#f3,#a2,#f3,#51
db #00,#00,#00,#00,#51,#00,#c3,#a2
db #c3,#c3,#c3,#c3,#e3,#51,#a2,#00
db #c3,#f3,#f3,#d3,#e3,#e3,#d3,#d3
db #f3,#e3,#e3,#e3,#e3,#d3,#e3,#f3
db #f3,#f3,#f3,#f3,#d3,#f3,#c3,#e3
db #51,#f3,#f3,#f3,#f3,#f3,#f3,#f3
db #f3,#f3,#a2,#f3,#00,#00,#00,#a2
db #e3,#f3,#d3,#f3,#00,#51,#00,#00
db #00,#00,#00,#00,#00,#a2,#00,#51
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#c3,#00
db #d3,#82,#e3,#41,#00,#00,#00,#00
db #00,#00,#a2,#a2,#c3,#c3,#c3,#c3
db #51,#51,#00,#00,#51,#51,#d3,#d3
db #e3,#e3,#d3,#d3,#e3,#e3,#e3,#a2
db #f3,#c3,#f3,#f3,#f3,#e3,#f3,#d3
db #f3,#f3,#e3,#e3,#c3,#d3,#e3,#e3
db #e3,#f3,#d3,#f3,#d3,#d3,#c3,#e3
db #51,#e3,#f3,#f3,#f3,#d3,#f3,#e3
db #f3,#f3,#f3,#c3,#00,#c3,#a2,#d3
db #d3,#f3,#e3,#f3,#51,#e3,#00,#a2
db #00,#00,#c3,#82,#e3,#f3,#d3,#f3
db #00,#41,#00,#00,#00,#00,#00,#00
db #00,#82,#00,#41,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#c3,#00,#82,#00,#41,#00
db #00,#00,#00,#00,#00,#00,#a2,#00
db #c3,#d3,#c3,#e3,#51,#00,#00,#00
db #51,#00,#d3,#82,#e3,#c3,#d3,#c3
db #e3,#41,#e3,#00,#51,#c3,#f3,#f3
db #f3,#e3,#f3,#d3,#f3,#f3,#e3,#e3
db #c3,#f3,#e3,#f3,#f3,#f3,#f3,#f3
db #d3,#f3,#c3,#f3,#c3,#c3,#e3,#e3
db #c3,#c3,#c3,#c3,#d3,#d3,#c3,#c3
db #51,#e3,#f3,#f3,#f3,#d3,#f3,#e3
db #f3,#f3,#e3,#d3,#c3,#51,#d3,#f3
db #f3,#e3,#f3,#d3,#e3,#f3,#f3,#e3
db #00,#00,#a2,#82,#e3,#e3,#d3,#d3
db #51,#41,#00,#00,#00,#00,#e3,#00
db #a2,#c3,#51,#c3,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#c3,#f3,#82,#f3,#41
db #00,#00,#00,#00,#00,#00,#82,#a2
db #c3,#e3,#c3,#d3,#41,#51,#00,#00
db #51,#c3,#f3,#d3,#e3,#c3,#d3,#c3
db #f3,#e3,#e3,#a2,#51,#00,#a2,#00
db #a2,#00,#51,#00,#51,#00,#e3,#41
db #c3,#e3,#e3,#f3,#c3,#d3,#c3,#e3
db #d3,#f3,#c3,#d3,#c3,#c3,#e3,#e3
db #c3,#c3,#c3,#c3,#d3,#d3,#c3,#c3
db #51,#e3,#a2,#f3,#a2,#d3,#51,#e3
db #51,#f3,#e3,#d3,#51,#00,#f3,#00
db #e3,#00,#d3,#00,#f3,#00,#e3,#41
db #00,#c3,#82,#d3,#c3,#c3,#c3,#c3
db #41,#e3,#00,#a2,#00,#00,#00,#a2
db #f3,#e3,#f3,#d3,#00,#51,#00,#00
db #00,#c3,#82,#41,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#15,#00,#3f,#3f,#3f,#2a
db #00,#00,#00,#00,#3f,#00,#c3,#6b
db #c3,#c3,#c3,#c3,#97,#2a,#2a,#00
db #6b,#6b,#c3,#c3,#3f,#3f,#6b,#6b
db #c3,#c3,#2a,#2a,#6b,#6b,#3f,#c3
db #3f,#3f,#3f,#6b,#6b,#c3,#2a,#2a
db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#3f
db #3f,#3f,#2a,#2a,#00,#00,#41,#3f
db #3f,#97,#6b,#97,#00,#2a,#00,#00
db #00,#00,#00,#00,#00,#97,#00,#82
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#15,#00
db #3f,#3f,#3f,#2a,#00,#00,#00,#00
db #00,#00,#c3,#6b,#c3,#c3,#c3,#c3
db #82,#2a,#00,#00,#6b,#15,#c3,#c3
db #3f,#3f,#6b,#6b,#c3,#97,#2a,#00
db #c3,#6b,#97,#c3,#6b,#3f,#3f,#6b
db #c3,#c3,#82,#2a,#6b,#c3,#97,#3f
db #c3,#6b,#97,#3f,#c3,#6b,#2a,#82
db #3f,#6b,#3f,#97,#3f,#97,#3f,#97
db #3f,#c3,#2a,#2a,#00,#41,#3f,#3f
db #97,#97,#97,#97,#2a,#6b,#00,#00
db #00,#00,#41,#97,#97,#3f,#c3,#3f
db #00,#82,#00,#00,#00,#00,#00,#00
db #00,#c3,#00,#82,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#3f,#00,#2a,#00
db #00,#00,#00,#00,#00,#00,#6b,#15
db #c3,#3f,#c3,#3f,#2a,#00,#00,#00
db #15,#00,#c3,#c3,#3f,#c3,#6b,#c3
db #97,#82,#00,#00,#6b,#41,#c3,#c3
db #3f,#3f,#6b,#6b,#c3,#c3,#2a,#00
db #c3,#6b,#97,#c3,#c3,#3f,#97,#6b
db #c3,#c3,#82,#2a,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#82,#82
db #6b,#6b,#3f,#97,#2a,#97,#3f,#97
db #6b,#c3,#2a,#2a,#15,#41,#97,#3f
db #3f,#97,#3f,#97,#97,#6b,#00,#00
db #00,#00,#6b,#c3,#c3,#97,#c3,#c3
db #2a,#82,#00,#00,#00,#00,#00,#41
db #97,#c3,#82,#c3,#00,#00,#00,#00
db #00,#00,#3f,#2a,#00,#00,#00,#00
db #00,#00,#15,#00,#97,#3f,#97,#2a
db #00,#00,#00,#00,#00,#00,#c3,#6b
db #c3,#c3,#c3,#c3,#82,#2a,#00,#00
db #41,#15,#c3,#c3,#97,#97,#c3,#c3
db #c3,#97,#00,#00,#6b,#6b,#2a,#97
db #2a,#00,#2a,#15,#6b,#c3,#2a,#2a
db #c3,#c3,#c3,#97,#c3,#97,#c3,#97
db #c3,#c3,#82,#82,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#82,#82
db #6b,#c3,#2a,#97,#2a,#97,#2a,#97
db #6b,#c3,#2a,#82,#41,#6b,#c3,#97
db #97,#00,#c3,#15,#c3,#c3,#00,#2a
db #00,#15,#c3,#c3,#c3,#97,#c3,#c3
db #82,#97,#00,#00,#00,#00,#15,#6b
db #97,#c3,#97,#c3,#00,#2a,#00,#00
db #00,#00,#3f,#2a,#00,#00,#00,#00
db #00,#00,#00,#00,#3f,#00,#2a,#00
db #00,#00,#00,#00,#00,#00,#6b,#41
db #c3,#3f,#c3,#6b,#2a,#00,#00,#00
db #15,#00,#97,#c3,#3f,#3f,#3f,#6b
db #97,#82,#00,#00,#6b,#6b,#3f,#3f
db #2a,#97,#3f,#97,#6b,#6b,#2a,#2a
db #c3,#c3,#c3,#97,#c3,#97,#c3,#97
db #c3,#c3,#82,#82,#c3,#c3,#97,#c3
db #c3,#c3,#97,#c3,#c3,#c3,#82,#82
db #6b,#6b,#c3,#97,#3f,#3f,#6b,#3f
db #c3,#c3,#2a,#2a,#15,#6b,#c3,#c3
db #c3,#c3,#c3,#c3,#97,#c3,#00,#2a
db #00,#00,#3f,#6b,#3f,#3f,#3f,#6b
db #2a,#2a,#00,#00,#00,#00,#00,#15
db #3f,#3f,#2a,#3f,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#41,#00
db #c3,#3f,#c3,#2a,#00,#00,#00,#00
db #00,#00,#3f,#97,#97,#3f,#97,#3f
db #2a,#82,#00,#00,#6b,#15,#3f,#3f
db #3f,#97,#3f,#97,#6b,#3f,#2a,#00
db #c3,#6b,#c3,#97,#c3,#97,#c3,#97
db #c3,#c3,#82,#2a,#6b,#c3,#c3,#c3
db #3f,#6b,#6b,#6b,#c3,#c3,#2a,#82
db #3f,#6b,#c3,#c3,#c3,#3f,#c3,#6b
db #97,#c3,#2a,#2a,#00,#15,#6b,#c3
db #3f,#c3,#6b,#c3,#2a,#97,#00,#00
db #00,#00,#15,#3f,#3f,#3f,#3f,#3f
db #00,#2a,#00,#00,#00,#00,#00,#00
db #00,#3f,#00,#2a,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#41,#00,#3f,#97,#6b,#82
db #00,#00,#00,#00,#3f,#00,#3f,#3f
db #3f,#97,#3f,#97,#3f,#2a,#2a,#00
db #6b,#6b,#c3,#3f,#3f,#3f,#6b,#3f
db #c3,#6b,#2a,#2a,#6b,#6b,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#2a,#2a
db #3f,#3f,#6b,#c3,#3f,#3f,#6b,#6b
db #3f,#97,#2a,#2a,#00,#00,#15,#3f
db #3f,#3f,#3f,#3f,#00,#2a,#00,#00
db #00,#00,#00,#00,#00,#3f,#00,#2a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#3f,#00,#6b,#15
db #c3,#3f,#c3,#3f,#3f,#00,#2a,#00
db #6b,#6b,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#2a,#2a,#6b,#6b,#c3,#c3
db #97,#97,#c3,#c3,#c3,#c3,#2a,#2a
db #3f,#3f,#3f,#6b,#3f,#c3,#3f,#c3
db #3f,#3f,#2a,#2a,#00,#00,#00,#15
db #00,#3f,#00,#3f,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#6b,#15,#c3,#3f
db #c3,#00,#2a,#00,#00,#00,#97,#41
db #6b,#c3,#97,#c3,#6b,#97,#c3,#15
db #82,#41,#c3,#6b,#c3,#97,#c3,#6b
db #2a,#c3,#00,#2a,#00,#2a,#00,#2a
db #15,#00,#c3,#6b,#2a,#00,#2a,#00
db #00,#00,#15,#00,#15,#c3,#c3,#c3
db #c3,#97,#00,#c3,#00,#00,#15,#00
db #15,#00,#c3,#c3,#c3,#6b,#00,#00
db #00,#00,#00,#00,#15,#c3,#c3,#c3
db #2a,#97,#2a,#c3,#82,#2a,#c3,#2a
db #c3,#00,#c3,#6b,#2a,#00,#00,#00
db #00,#41,#97,#6b,#6b,#97,#97,#6b
db #6b,#c3,#c3,#2a,#00,#00,#00,#41
db #6b,#c3,#c3,#c3,#c3,#97,#2a,#15
db #00,#00,#15,#3f,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #6b,#15,#c3,#3f,#c3,#00,#2a,#00
db #00,#00,#97,#41,#6b,#c3,#97,#c3
db #6b,#97,#c3,#15,#2a,#41,#2a,#6b
db #00,#97,#6b,#6b,#00,#c3,#00,#2a
db #00,#00,#00,#00,#c3,#15,#c3,#c3
db #97,#2a,#c3,#2a,#00,#00,#00,#15
db #c3,#15,#c3,#c3,#97,#c3,#6b,#00
db #2a,#00,#2a,#00,#00,#15,#3f,#3f
db #00,#2a,#00,#2a,#00,#15,#3f,#3f
db #6b,#97,#97,#6b,#6b,#c3,#c3,#2a
db #00,#00,#00,#41,#3f,#c3,#c3,#c3
db #c3,#97,#2a,#15,#00,#00,#00,#00
db #00,#15,#00,#3f,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#15,#00,#3f,#00
db #00,#00,#00,#00,#41,#00,#c3,#41
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#2a
db #00,#2a,#00,#2a,#6b,#00,#c3,#c3
db #82,#00,#41,#00,#00,#00,#00,#15
db #3f,#c3,#3f,#3f,#2a,#97,#00,#2a
db #15,#2a,#3f,#2a,#3f,#00,#3f,#3f
db #3f,#00,#3f,#00,#00,#00,#00,#00
db #00,#3f,#00,#3f,#00,#3f,#00,#2a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #15,#00,#6b,#00,#c3,#15,#c3,#3f
db #c3,#3f,#2a,#00,#15,#6b,#6b,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#2a,#c3
db #00,#00,#00,#00,#00,#15,#00,#3f
db #00,#3f,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#15,#00,#3f,#00
db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#2a
db #00,#2a,#00,#2a,#3f,#00,#c3,#3f
db #2a,#00,#00,#00,#00,#00,#00,#15
db #6b,#c3,#c3,#3f,#82,#97,#41,#2a
db #41,#2a,#c3,#2a,#c3,#00,#c3,#c3
db #c3,#00,#c3,#00,#00,#00,#00,#41
db #15,#c3,#3f,#c3,#00,#c3,#00,#2a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #3f,#15,#c3,#3f,#c3,#00,#2a,#00
db #00,#00,#3f,#41,#6b,#c3,#97,#c3
db #6b,#97,#c3,#15,#2a,#15,#2a,#3f
db #00,#97,#3f,#6b,#00,#c3,#00,#2a
db #00,#00,#00,#00,#c3,#15,#c3,#3f
db #97,#2a,#6b,#2a,#00,#00,#00,#15
db #c3,#15,#c3,#c3,#97,#c3,#c3,#00
db #2a,#00,#2a,#00,#00,#15,#6b,#c3
db #00,#2a,#00,#2a,#00,#41,#97,#6b
db #6b,#97,#97,#6b,#6b,#c3,#c3,#2a
db #00,#00,#00,#41,#6b,#c3,#c3,#c3
db #c3,#97,#2a,#15,#00,#00,#00,#00
db #00,#15,#00,#3f,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#cb,#45,#c3,#c3
db #82,#00,#00,#00,#00,#00,#c7,#41
db #cb,#c3,#c3,#c3,#c3,#c3,#00,#00
db #82,#41,#c3,#cb,#c3,#c7,#cf,#cb
db #cf,#c3,#8a,#8a,#00,#8a,#00,#8a
db #45,#00,#c3,#c7,#cb,#cb,#cb,#cf
db #00,#00,#45,#00,#45,#c3,#c3,#c3
db #cb,#c3,#cb,#c3,#00,#00,#45,#00
db #45,#00,#c3,#cb,#cb,#41,#cb,#45
db #00,#00,#00,#00,#45,#c3,#c3,#c3
db #cb,#c3,#cb,#c3,#82,#8a,#c3,#8a
db #c3,#00,#cf,#c7,#cf,#cb,#8a,#cf
db #00,#41,#c7,#cb,#cb,#c7,#c3,#cb
db #c3,#c3,#00,#8a,#00,#00,#00,#41
db #cb,#c3,#c3,#c3,#82,#c3,#00,#00
db #00,#00,#45,#c3,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #cb,#45,#c3,#00,#82,#00,#00,#00
db #00,#00,#c7,#41,#cb,#c3,#cb,#c3
db #c3,#c3,#82,#00,#8a,#41,#8a,#cb
db #00,#c7,#c3,#cf,#cb,#cf,#c7,#8a
db #00,#00,#00,#00,#c3,#45,#c3,#c3
db #cb,#c3,#c3,#c3,#00,#00,#00,#45
db #c3,#45,#c3,#cb,#cb,#41,#c3,#45
db #8a,#00,#8a,#00,#00,#45,#c3,#c3
db #cb,#c3,#cf,#c3,#00,#45,#cf,#cf
db #cb,#c7,#cb,#cf,#c3,#cf,#82,#8a
db #00,#00,#00,#41,#cf,#c3,#c3,#c3
db #82,#c3,#00,#00,#00,#00,#00,#00
db #00,#45,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#45,#00,#00,#00
db #00,#00,#00,#00,#41,#00,#c3,#41
db #c3,#c3,#cf,#c3,#cb,#c7,#8a,#00
db #00,#8a,#00,#8a,#cb,#00,#c3,#c3
db #cb,#cf,#cb,#cf,#00,#00,#00,#45
db #cf,#c3,#c3,#c3,#cb,#cf,#cb,#cb
db #45,#8a,#cf,#8a,#cf,#00,#c3,#cf
db #c7,#cf,#00,#cf,#00,#00,#00,#00
db #00,#cf,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #45,#00,#cb,#00,#c3,#45,#cb,#00
db #cb,#00,#c3,#cf,#45,#cb,#cb,#c3
db #c3,#c3,#cb,#c3,#cb,#c3,#c3,#c3
db #00,#00,#00,#00,#00,#45,#00,#00
db #00,#00,#00,#cf,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#45,#00,#cf,#00
db #cf,#cf,#c3,#00,#c7,#00,#00,#00
db #00,#8a,#00,#8a,#cf,#00,#c3,#cf
db #cb,#cf,#cb,#cf,#00,#00,#00,#45
db #cb,#c3,#c3,#c3,#cb,#cf,#cb,#cb
db #41,#8a,#c3,#8a,#c3,#00,#cf,#c3
db #cb,#cf,#8a,#cf,#00,#00,#00,#41
db #45,#c3,#00,#c3,#00,#c7,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #cf,#45,#c3,#00,#8a,#00,#00,#00
db #00,#00,#cf,#41,#cb,#c3,#cf,#cb
db #c3,#c7,#8a,#00,#8a,#45,#8a,#cf
db #00,#c7,#c3,#cf,#cb,#cf,#cf,#8a
db #00,#00,#00,#00,#c3,#45,#c3,#c3
db #cb,#c3,#c3,#c3,#00,#00,#00,#45
db #c3,#45,#c3,#cb,#cb,#41,#c3,#45
db #8a,#00,#8a,#00,#00,#45,#c3,#c3
db #cb,#c3,#c7,#c3,#00,#41,#c7,#cb
db #cb,#c7,#cf,#cf,#c3,#cf,#8a,#8a
db #00,#00,#00,#41,#cb,#c3,#c3,#cb
db #8a,#c7,#00,#00,#00,#00,#00,#00
db #00,#45,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #51,#00,#c3,#f3,#d3,#82,#e3,#41
db #c3,#f3,#a2,#00,#c3,#e3,#f3,#c3
db #e3,#c3,#d3,#c3,#f3,#c3,#c3,#d3
db #00,#d3,#41,#00,#c3,#c3,#c3,#c3
db #82,#00,#00,#e3,#00,#00,#f3,#51
db #00,#f3,#00,#f3,#f3,#a2,#00,#00
db #51,#51,#51,#a2,#c3,#e3,#c3,#d3
db #a2,#51,#a2,#a2,#51,#51,#00,#51
db #f3,#e3,#f3,#d3,#00,#a2,#a2,#a2
db #00,#51,#e3,#a2,#51,#00,#a2,#00
db #d3,#51,#00,#a2,#00,#00,#41,#51
db #c3,#e3,#c3,#d3,#82,#a2,#00,#00
db #c3,#d3,#f3,#00,#e3,#c3,#d3,#c3
db #f3,#00,#c3,#e3,#51,#e3,#c3,#c3
db #d3,#c3,#e3,#c3,#c3,#c3,#a2,#d3
db #00,#f3,#82,#41,#f3,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#f3,#00
db #d3,#a2,#e3,#51,#f3,#00,#00,#00
db #e3,#51,#a2,#c3,#00,#c3,#00,#c3
db #51,#c3,#d3,#a2,#a2,#d3,#f3,#51
db #00,#f3,#00,#f3,#f3,#a2,#51,#e3
db #51,#51,#51,#a2,#c3,#e3,#c3,#d3
db #a2,#51,#a2,#a2,#51,#51,#00,#51
db #f3,#e3,#f3,#d3,#00,#a2,#a2,#a2
db #82,#51,#e3,#a2,#51,#00,#a2,#00
db #d3,#51,#41,#a2,#e3,#c3,#c3,#e3
db #c3,#c3,#c3,#c3,#c3,#d3,#d3,#c3
db #00,#51,#f3,#c3,#d3,#c3,#e3,#c3
db #f3,#c3,#00,#a2,#00,#00,#00,#00
db #00,#a2,#00,#51,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#a2,#00,#51,#00
db #00,#00,#00,#00,#f3,#51,#f3,#f3
db #00,#f3,#00,#f3,#f3,#f3,#f3,#a2
db #f3,#d3,#51,#a2,#c3,#e3,#c3,#d3
db #a2,#51,#f3,#e3,#c3,#f3,#c3,#51
db #c3,#e3,#c3,#d3,#c3,#a2,#c3,#f3
db #e3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#d3,#c3,#00,#51,#00,#f3
db #a2,#d3,#51,#e3,#00,#f3,#00,#a2
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#f3,#51
db #00,#f3,#00,#f3,#f3,#a2,#00,#00
db #e3,#51,#c3,#a2,#c3,#e3,#c3,#d3
db #c3,#51,#d3,#a2,#e3,#e3,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#d3,#d3
db #00,#51,#e3,#a2,#51,#00,#a2,#00
db #d3,#51,#00,#a2,#00,#00,#00,#51
db #00,#e3,#00,#d3,#00,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#a2,#00,#51,#00
db #00,#00,#00,#00,#e3,#51,#c3,#f3
db #c3,#d3,#c3,#e3,#c3,#f3,#d3,#a2
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#c3,#f3,#f3,#00,#51
db #f3,#e3,#f3,#d3,#00,#a2,#f3,#f3
db #f3,#d3,#e3,#a2,#51,#00,#a2,#00
db #d3,#51,#f3,#e3,#00,#51,#00,#f3
db #a2,#e3,#51,#d3,#00,#f3,#00,#a2
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#f3,#00
db #d3,#a2,#e3,#51,#f3,#00,#00,#00
db #e3,#51,#c3,#c3,#d3,#c3,#e3,#c3
db #c3,#c3,#d3,#a2,#82,#c3,#f3,#e3
db #00,#c3,#00,#c3,#f3,#d3,#41,#c3
db #51,#51,#51,#a2,#c3,#e3,#c3,#d3
db #a2,#51,#a2,#a2,#51,#51,#00,#51
db #f3,#e3,#f3,#d3,#00,#a2,#a2,#a2
db #a2,#51,#e3,#a2,#51,#00,#a2,#00
db #d3,#51,#51,#a2,#e3,#d3,#a2,#51
db #00,#e3,#00,#d3,#51,#a2,#d3,#e3
db #00,#51,#f3,#c3,#d3,#c3,#e3,#c3
db #f3,#c3,#00,#a2,#00,#00,#00,#00
db #00,#a2,#00,#51,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BANK 5
org #4000

PlayerFrameList
    defw PlayerSprite0 ; #255
    defw PlayerSprite1 ; #22d
    defw PlayerSprite2 ; #1f9
    defw PlayerSprite3 ; #1dd
    defw PlayerSprite4 ; #1e1
    defw PlayerSprite5 ; #20d
    defw PlayerSprite6 ; #22f
    defw PlayerSprite4 ; dummy entry
PlayerFrameGrindList
    defw PlayerSpriteGrind0 ;
    defw PlayerSpriteGrind1 ;
    defw PlayerSpriteGrind2 ;
    defw PlayerSpriteGrind3 ;
    defw PlayerSpriteGrind4 ;
    defw PlayerSpriteGrind5 ;
    defw PlayerSpriteGrind6 ;
    defw PlayerSpriteGrind4 ;
LaserFrameList
    defw LaserFrame0 ; #128
    defw LaserFrame5 ; #12b
    defw LaserFrame4 ; #12e
    defw LaserFrame3 ; #131
    defw LaserFrame2 ; #e9
    defw LaserFrame1 ; #bc
    defw LaserFrame1 ; dummy entry
    defw LaserFrame1 ; dummy entry

; the following compiled sprites were primarily autogenerated with some code
; they follow the same sequence for printing the sprites as the code for printing
; normal sprites you will find in EG_Sprites10asm
; the tool used automatically commented out 0 bytes, but did not determine what if
; any redundant incs/decs could be commented out, so the compiled sprite code could
; be more efficient than it is here

PlayerSprite0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),147
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),99
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),217
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
    ld (hl),153
    inc hl
    set 3,h
    ld (hl),68
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),147
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),217
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),99
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),147
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),230
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),68
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),147
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),217
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
    ld (hl),153
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),99
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),217
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),147
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSprite1
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),51
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),17
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),147
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),217
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),99
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),147
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),230
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
    ld (hl),153
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),211
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),147
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSprite2
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),51
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),243
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),147
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),217
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),243
    res 3,h
    ld (hl),99
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),147
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),230
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),195
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),243
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSprite3
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),68
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),217
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),195
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),217
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSprite4
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),243
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),211
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),211
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),195
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),102
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),153
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSprite5
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),211
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),99
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),217
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),179
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),195
    res 3,h
    ld (hl),51
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),147
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),230
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),217
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSprite6
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),99
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),153
    res 3,h
    ld (hl),68
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),195
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),198
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),217
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),217
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),99
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),147
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),230
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
    ld (hl),153
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),227
    inc hl
    set 3,h
    ld (hl),147
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),217
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),51
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),217
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)


LaserFrame0
;    defb 0,0,0,0,0,0,0,0,0,0,0,0
;    ld e,(ix+0)
;    inc ixl
;    ld d,(ix+0)
;    inc ixl
;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),8
;    res 3,h
;    ld (hl),0

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),73
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),73
    inc hl
    set 3,h
    ld (hl),8
    res 3,h
    ld (hl),134

;    defb 0,0,0,0,0,0,0,0,0,0,0,0
;    ld l,(ix+0)
    inc ixl
;    ld h,(ix+0)
    inc ixl
;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    ld (hl),192
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
    ld (hl),194
    res 3,h
    ld (hl),128

;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    ld (hl),192
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
    ld (hl),194
    res 3,h
    ld (hl),128
;    defb 0,0,0,192,0,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),128

;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),8
;    res 3,h
;    ld (hl),0

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),73
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),73
    inc hl
    set 3,h
    ld (hl),8
    res 3,h
    ld (hl),134

    jp (iy)

LaserFrame5
;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),73
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),73

;    defb 0,0,0,0,0,0,0,0,0,0,0,0
;    ld l,(ix+0)
    inc ixl
;    ld h,(ix+0)
    inc ixl
;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    ld (hl),192
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
    ld (hl),194
    res 3,h
    ld (hl),128

;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    ld (hl),192
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
    ld (hl),194
    res 3,h
    ld (hl),128
;    defb 0,0,0,192,0,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),128

;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),73
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),73

    jp (iy)

LaserFrame4
;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),73

;    defb 0,0,0,0,0,0,0,0,0,0,0,0
;    ld l,(ix+0)
    inc ixl
;    ld h,(ix+0)
    inc ixl
;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    ld (hl),192
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
    ld (hl),194
    res 3,h
    ld (hl),128

;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    ld (hl),192
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
    ld (hl),194
    res 3,h
    ld (hl),128
;    defb 0,0,0,192,0,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),128

;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),73

    jp (iy)

LaserFrame3
;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
    ld (hl),148

;    defb 0,0,0,0,0,0,0,0,0,0,0,0
;    ld l,(ix+0)
    inc ixl
;    ld h,(ix+0)
    inc ixl
;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    ld (hl),192
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
    ld (hl),194
    res 3,h
    ld (hl),128

;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    ld (hl),192
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
    ld (hl),194
    res 3,h
    ld (hl),128
;    defb 0,0,0,192,0,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),192
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),128

;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),148
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
    ld (hl),148

    jp (iy)

LaserFrame2
;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),148

;    defb 0,0,0,0,0,0,0,0,0,0,0,0
;    ld l,(ix+0)
    inc ixl
;    ld h,(ix+0)
    inc ixl
;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    ld (hl),192
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),192

;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    ld (hl),192
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),44
    res 3,h
    ld (hl),192

;    defb 0,0,0,192,0,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),192

;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),148

    jp (iy)

LaserFrame1
;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
    ld (hl),64

;    defb 0,0,0,0,0,0,0,0,0,0,0,0
;    ld l,(ix+0)
    inc ixl
;    ld h,(ix+0)
    inc ixl
;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    ld (hl),192

;    defb 192,0,44,192,194,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    ld (hl),192

;    defb 0,0,0,192,0,128,0,0,0,0,0,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;

;    defb 0,0,0,0,64,0,44,0,44,0,8,0
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;

;    defb 0,64,0,148,64,148,44,73,44,73,8,134
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
    res 3,h
    inc hl
    set 3,h
;
;    ld (hl),0
    res 3,h
    ld (hl),64

    jp (iy)


PlayerSpriteGrind0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),164
    res 3,h
    ld (hl),149
    inc hl
    set 3,h
    ld (hl),180
    res 3,h
    ld (hl),212
    inc hl
    set 3,h
    ld (hl),168
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),225
    res 3,h
    ld (hl),73
    inc hl
    set 3,h
    ld (hl),180
    res 3,h
    ld (hl),134
    inc hl
    set 3,h
    ld (hl),121
    res 3,h
    ld (hl),108
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),73
    res 3,h
    ld (hl),164
    inc hl
    set 3,h
    ld (hl),28
    res 3,h
    ld (hl),244
    inc hl
    set 3,h
    ld (hl),168
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),217
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
    ld (hl),153
    inc hl
    set 3,h
    ld (hl),68
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),151
    res 3,h
    ld (hl),134
    inc hl
    set 3,h
    ld (hl),72
    res 3,h
    ld (hl),106
    inc hl
    set 3,h
    ld (hl),252
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),166
    res 3,h
    ld (hl),242
    inc hl
    set 3,h
    ld (hl),210
    res 3,h
    ld (hl),210
    inc hl
    set 3,h
    ld (hl),28
    res 3,h
    ld (hl),60
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),166
    res 3,h
    ld (hl),99
    inc hl
    set 3,h
    ld (hl),210
    res 3,h
    ld (hl),134
    inc hl
    set 3,h
    ld (hl),28
    res 3,h
    ld (hl),147
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),230
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),68
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),134
    res 3,h
    ld (hl),181
    inc hl
    set 3,h
    ld (hl),106
    res 3,h
    ld (hl),88
    inc hl
    set 3,h
    ld (hl),252
    res 3,h
    ld (hl),60
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
    ld (hl),153
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),73
    res 3,h
    ld (hl),195
    inc hl
    set 3,h
    ld (hl),28
    res 3,h
    ld (hl),212
    inc hl
    set 3,h
    ld (hl),168
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),181
    res 3,h
    ld (hl),164
    inc hl
    set 3,h
    ld (hl),88
    res 3,h
    ld (hl),106
    inc hl
    set 3,h
    ld (hl),60
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),217
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),226
    res 3,h
    ld (hl),114
    inc hl
    set 3,h
    ld (hl),88
    res 3,h
    ld (hl),134
    inc hl
    set 3,h
    ld (hl),168
    res 3,h
    ld (hl),124
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    res 3,h
    ld (hl),200
    inc hl
    set 3,h
    res 3,h
    ld (hl),106
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSpriteGrind1
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),132
    res 3,h
    ld (hl),21
    inc hl
    set 3,h
    ld (hl),212
    res 3,h
    ld (hl),128
    inc hl
    set 3,h
    ld (hl),236
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),55
    res 3,h
    ld (hl),225
    inc hl
    set 3,h
    ld (hl),88
    res 3,h
    ld (hl),106
    inc hl
    set 3,h
    ld (hl),25
    res 3,h
    ld (hl),60
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),17
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),166
    res 3,h
    ld (hl),200
    inc hl
    set 3,h
    ld (hl),134
    res 3,h
    ld (hl),210
    inc hl
    set 3,h
    ld (hl),124
    res 3,h
    ld (hl),252
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),181
    res 3,h
    ld (hl),200
    inc hl
    set 3,h
    ld (hl),12
    res 3,h
    ld (hl),88
    inc hl
    set 3,h
    ld (hl),121
    res 3,h
    ld (hl),188
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),193
    res 3,h
    ld (hl),12
    inc hl
    set 3,h
    ld (hl),164
    res 3,h
    ld (hl),107
    inc hl
    set 3,h
    ld (hl),121
    res 3,h
    ld (hl),57
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),147
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),230
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
    ld (hl),153
    inc hl
    set 3,h
    ld (hl),193
    res 3,h
    ld (hl),225
    inc hl
    set 3,h
    ld (hl),164
    res 3,h
    ld (hl),150
    inc hl
    set 3,h
    ld (hl),108
    res 3,h
    ld (hl),236
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),55
    res 3,h
    ld (hl),164
    inc hl
    set 3,h
    ld (hl),210
    res 3,h
    ld (hl),106
    inc hl
    set 3,h
    ld (hl),147
    res 3,h
    ld (hl),60
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),200
    res 3,h
    ld (hl),226
    inc hl
    set 3,h
    ld (hl),72
    res 3,h
    ld (hl),72
    inc hl
    set 3,h
    ld (hl),252
    res 3,h
    ld (hl),60
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
    ld (hl),106
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSpriteGrind2
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),28
    res 3,h
    ld (hl),126
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),236
    inc hl
    set 3,h
    ld (hl),51
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),225
    res 3,h
    ld (hl),132
    inc hl
    set 3,h
    ld (hl),180
    res 3,h
    ld (hl),212
    inc hl
    set 3,h
    ld (hl),121
    res 3,h
    ld (hl),57
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),147
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),217
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),181
    res 3,h
    ld (hl),73
    inc hl
    set 3,h
    ld (hl),194
    res 3,h
    ld (hl),46
    inc hl
    set 3,h
    ld (hl),124
    res 3,h
    ld (hl),147
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),230
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
    ld (hl),200
    inc hl
    set 3,h
    ld (hl),72
    res 3,h
    ld (hl),210
    inc hl
    set 3,h
    ld (hl),124
    res 3,h
    ld (hl),150
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),195
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),243
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
    ld (hl),106
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),252
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSpriteGrind3
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),68
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),21
    res 3,h
    ld (hl),64
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),124
    res 3,h
    ld (hl),252
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),217
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),225
    res 3,h
    ld (hl),132
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),124
    res 3,h
    ld (hl),28
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),211
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),195
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),132
    res 3,h
    ld (hl),193
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),84
    res 3,h
    ld (hl),252
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),136
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
    ld (hl),21
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSpriteGrind4
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),72
    res 3,h
    ld (hl),106
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),243
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),211
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),211
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),195
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),242
    res 3,h
    ld (hl),226
    inc hl
    set 3,h
    ld (hl),210
    res 3,h
    ld (hl),72
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),102
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),217
    res 3,h
    ld (hl),140
    inc hl
    set 3,h
    ld (hl),12
    res 3,h
    ld (hl),194
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),136
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),106
    res 3,h
    ld (hl),72
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
    ld (hl),128
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSpriteGrind5
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),106
    res 3,h
    ld (hl),128
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),21
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),72
    res 3,h
    ld (hl),72
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),211
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),99
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),164
    res 3,h
    ld (hl),132
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
    ld (hl),106
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),107
    res 3,h
    ld (hl),193
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
    ld (hl),148
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),179
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),243
    inc hl
    set 3,h
    ld (hl),195
    res 3,h
    ld (hl),51
    inc hl
    set 3,h
    ld (hl),216
    res 3,h
    ld (hl),166
    inc hl
    set 3,h
    ld (hl),210
    res 3,h
    ld (hl),151
    inc hl
    set 3,h
    ld (hl),124
    res 3,h
    ld (hl),124
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),243
    res 3,h
    ld (hl),216
    inc hl
    set 3,h
    ld (hl),46
    res 3,h
    ld (hl),29
    inc hl
    set 3,h
    ld (hl),212
    res 3,h
    ld (hl),252
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),132
    res 3,h
    ld (hl),132
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
    ld (hl),128
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),21
    res 3,h
    ld (hl),4
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
    ld (hl),128
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),64
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)
PlayerSpriteGrind6
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),132
    res 3,h
    ld (hl),21
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
    ld (hl),128
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),73
    res 3,h
    ld (hl),164
    inc hl
    set 3,h
    ld (hl),244
    res 3,h
    ld (hl),128
    inc hl
    set 3,h
    ld (hl),168
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),153
    res 3,h
    ld (hl),68
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),195
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),151
    res 3,h
    ld (hl),225
    inc hl
    set 3,h
    ld (hl),72
    res 3,h
    ld (hl),62
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),249
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),230
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),242
    res 3,h
    ld (hl),216
    inc hl
    set 3,h
    ld (hl),210
    res 3,h
    ld (hl),210
    inc hl
    set 3,h
    ld (hl),124
    res 3,h
    ld (hl),168
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),230
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),179
    res 3,h
    ld (hl),99
    inc hl
    set 3,h
    ld (hl),242
    res 3,h
    ld (hl),166
    inc hl
    set 3,h
    ld (hl),210
    res 3,h
    ld (hl),134
    inc hl
    set 3,h
    ld (hl),124
    res 3,h
    ld (hl),124
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    ld (hl),68
    res 3,h
    ld (hl),153
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),227
    inc hl
    set 3,h
    ld (hl),147
    res 3,h
    ld (hl),115
    inc hl
    set 3,h
    ld (hl),164
    res 3,h
    ld (hl),149
    inc hl
    set 3,h
    ld (hl),126
    res 3,h
    ld (hl),88
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),168
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),204
    inc hl
    set 3,h
    ld (hl),115
    res 3,h
    ld (hl),179
    inc hl
    set 3,h
    ld (hl),73
    res 3,h
    ld (hl),225
    inc hl
    set 3,h
    ld (hl),244
    res 3,h
    ld (hl),180
    inc hl
    set 3,h
    ld (hl),168
    res 3,h
    ld (hl),249
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),204
    res 3,h
    ld (hl),230
    inc hl
    set 3,h
    ld (hl),140
    res 3,h
    ld (hl),164
    inc hl
    set 3,h
    ld (hl),128
    res 3,h
    ld (hl),128
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    ld (hl),64
    res 3,h
    ld (hl),21
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
    ld (hl),128
    inc hl
    set 3,h
;    ld (hl),0
    res 3,h
;    ld (hl),0
;
    ld l,(ix+0)
    inc ixl
    ld h,(ix+0)
    inc ixl
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    inc hl
    set 3,h
    res 3,h
;    ld (hl),0
    jp (iy)

laserframeend
; wave data for level also stored in compiled sprite bank  has been modified from C64 original data

wave_data
; Wave 1
    defb 94,102,65,65,32,0,9,3,8
    defb 94,70,65,33,80,96,4,3,0
    defb 94,134,65,97,80,96,4,3,8
    defb 94,102,65,65,32,0,9,3,72
; Wave 2
    defb 94,102,65,97,80,96,1,5,8
    defb 94,102,65,97,80,96,1,5,32
; Wave 3
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,16
; Wave 4
    defb 94,78,65,65,128,0,5,5,12
    defb 94,102,65,65,128,0,5,5,12
    defb 94,126,65,65,128,0,5,5,32
; Wave 5
    defb 94,130,65,34,96,120,12,4,8
    defb 94,130,65,34,96,120,15,4,8
    defb 94,130,65,34,96,120,12,4,72
; Wave 6
    defb 94,134,64,65,24,240,0,3,8
    defb 94,102,64,65,24,240,0,3,8
    defb 94,118,64,65,24,240,0,3,56
; Wave 7
    defb 94,86,65,97,80,96,1,3,8
    defb 94,118,65,33,80,96,1,3,8
    defb 94,70,65,97,80,112,13,3,8
    defb 94,134,65,33,80,112,13,3,8
    defb 94,102,65,65,128,0,14,3,80
; Wave 8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,24
; Wave 9
    defb 94,70,65,97,80,96,0,3,8
    defb 94,134,65,33,80,96,0,3,8
    defb 94,70,65,97,80,96,0,3,8
    defb 94,134,65,33,80,96,0,3,56
; Wave 10
    defb 86,6,97,65,32,240,7,3,8
    defb 86,6,97,65,48,240,7,3,8
    defb 86,6,97,65,64,240,7,3,40
; Wave 11
    defb 94,102,64,64,80,96,2,2,8
    defb 94,102,64,64,80,96,2,2,8
    defb 94,102,64,64,80,96,2,2,8
    defb 94,102,64,64,80,96,2,2,8
    defb 94,102,64,64,80,96,2,2,16
; Wave 12
    defb 94,70,65,97,80,96,12,4,8
    defb 94,134,65,33,80,96,12,4,8
    defb 94,70,65,97,80,96,12,4,8
    defb 94,134,65,33,80,96,12,4,72
; Wave 13
    defb 94,102,65,33,80,96,11,4,8
    defb 94,102,65,97,80,96,11,4,8
    defb 94,102,65,33,80,96,11,4,8
    defb 94,102,65,97,80,96,11,4,68
; Wave 14
    defb 94,102,65,64,64,240,3,2,12
    defb 94,102,65,64,64,240,3,2,12
    defb 94,102,65,64,64,240,3,2,12
    defb 94,102,65,64,64,240,3,2,12
    defb 94,102,65,64,64,240,3,2,60
; Wave 15
    defb 94,70,65,97,80,96,0,4,8
    defb 94,134,65,33,80,96,0,4,8
    defb 94,134,65,33,80,96,0,4,8
    defb 94,70,65,97,80,96,0,4,72
; Wave 16
    defb 94,126,33,97,18,36,8,5,7
    defb 94,126,33,97,18,36,8,5,41
; Wave 17
    defb 94,126,33,97,18,36,6,5,7
    defb 94,126,33,97,18,36,6,5,49
; Wave 18
    defb 94,134,65,33,80,104,10,4,8
    defb 94,134,65,33,80,104,10,4,8
    defb 94,134,65,33,80,104,10,4,8
    defb 94,134,65,33,80,104,10,4,60
; Wave 19
    defb 94,70,65,97,80,116,4,3,8
    defb 94,70,65,97,80,116,4,3,8
    defb 94,70,65,97,80,116,4,3,8
    defb 94,70,65,97,80,116,4,3,48
; Wave 20
    defb 94,86,65,64,80,240,9,3,0
    defb 94,118,65,64,80,240,9,3,16
; Wave 21
    defb 94,102,65,64,80,240,9,3,48
; Wave 22
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,16
; Wave 23
    defb 94,86,65,97,80,88,0,5,8
    defb 94,118,65,33,80,88,0,5,32
; Wave 24
    defb 94,102,65,97,80,88,0,5,8
    defb 94,102,65,33,80,88,0,5,56
; Wave 25
    defb 94,66,97,65,18,240,0,5,8
    defb 94,138,33,65,18,240,0,5,8
    defb 94,66,97,65,18,240,0,5,32
; Wave 26
    defb 102,102,65,66,96,240,12,24,112
; Wave 27
    defb 8,-58,65,65,16,32,0,32,24
; Wave 28
    defb 102,38,96,64,32,224,0,3,8
    defb 102,38,96,64,32,224,0,3,8
    defb 102,38,96,64,32,224,0,3,8
    defb 102,38,96,64,32,224,0,3,40
; Wave 29
    defb 102,54,64,96,48,80,4,2,8
    defb 102,54,64,96,48,80,4,2,8
    defb 102,54,64,66,48,128,7,5,40
; Wave 30
    defb 102,50,65,65,48,128,5,5,8
    defb 102,62,65,65,48,128,5,5,8
    defb 102,38,65,65,48,128,5,5,16
; Wave 31
    defb 102,50,65,66,96,192,12,12,104
; Wave 32
    defb 102,134,32,64,48,192,9,2,0
    defb 102,166,32,64,48,192,9,2,8
    defb 102,134,32,64,40,192,10,2,0
    defb 102,166,32,64,40,192,10,2,52
; Wave 33
    defb 102,150,64,32,32,96,4,1,4
    defb 102,150,64,32,32,96,7,1,4
    defb 102,150,64,32,32,96,4,1,4
    defb 102,150,64,32,32,96,7,1,4
    defb 102,150,64,32,32,96,4,1,56
; Wave 34
    defb 94,150,65,64,64,240,3,4,12
    defb 94,162,65,64,64,240,3,4,12
    defb 94,138,65,64,64,240,3,4,12
    defb 94,156,65,64,64,240,3,4,12
    defb 94,144,65,64,64,240,3,4,48
; Wave 35
    defb 102,38,65,97,64,120,9,4,12
    defb 102,38,65,97,64,120,13,4,12
    defb 102,38,65,97,64,120,9,4,12
    defb 102,150,65,65,64,120,13,4,12
    defb 102,150,65,65,64,120,9,4,52
; Wave 36
    defb 102,70,65,97,80,112,11,5,12
    defb 102,70,65,33,96,112,11,5,12
    defb 102,70,65,97,80,112,11,5,12
    defb 102,70,65,33,96,112,11,5,48
; Wave 37
    defb 102,54,65,65,32,16,5,6,12
    defb 102,38,65,65,32,16,5,6,12
    defb 102,86,65,65,32,16,5,6,48
; Wave 38
    defb 102,86,65,65,32,16,5,6,12
    defb 102,54,65,65,32,16,5,6,112
; Wave 39
    defb 102,134,65,33,88,120,4,5,12
    defb 102,134,65,33,88,120,4,5,40
; Wave 40
    defb 102,134,65,33,96,112,7,5,12
    defb 102,102,65,97,96,112,7,5,12
    defb 102,134,65,33,96,112,7,5,12
    defb 102,102,65,97,96,112,7,5,88
; Wave 41
    defb 94,102,64,64,64,240,2,4,12
    defb 94,102,64,64,64,240,2,4,12
    defb 94,102,64,64,64,240,2,4,12
    defb 94,102,64,64,64,240,2,4,12
    defb 94,102,64,64,64,240,2,4,12
    defb 94,102,64,64,64,240,2,4,12
    defb 94,102,64,64,64,240,2,4,12
    defb 94,102,64,64,64,240,2,4,12
    defb 102,102,64,66,48,160,12,16,80
; Wave 42
    defb 102,86,64,66,48,160,15,12,8
    defb 102,118,64,66,48,160,15,12,72
; Wave 43
    defb 94,134,65,33,88,104,0,4,12
    defb 94,102,65,65,88,104,0,4,12
    defb 94,70,65,97,88,104,0,4,48
; Wave 44
    defb 94,62,65,97,88,108,4,4,12
    defb 94,102,65,65,88,108,4,4,12
    defb 94,142,65,33,88,108,4,4,48
; Wave 45
    defb 94,150,65,33,88,112,0,4,12
    defb 94,102,65,65,88,112,0,4,12
    defb 94,54,65,97,88,112,0,4,72
; Wave 46
    defb 94,134,65,33,88,104,10,6,12
    defb 94,70,65,97,88,104,10,6,12
    defb 94,134,65,33,88,104,10,6,40
; Wave 47
    defb 94,102,65,33,80,96,2,6,12
    defb 94,38,65,97,96,112,2,6,80
; Wave 48
    defb 94,110,65,64,64,240,3,4,12
    defb 94,94,65,64,64,240,3,4,12
    defb 94,102,65,64,64,240,3,4,40
; Wave 49
    defb 94,102,64,66,44,160,15,16,40
; Wave 50
    defb 110,102,64,66,52,160,15,16,64
; Wave 51
    defb 94,70,65,97,80,96,12,6,8
    defb 94,134,65,33,80,96,12,6,8
    defb 94,70,65,97,80,96,12,6,8
    defb 94,134,65,33,80,96,12,6,56
; Wave 52
    defb 94,102,65,33,80,96,11,5,8
    defb 94,102,65,97,80,96,11,5,8
    defb 94,102,65,33,80,96,11,5,8
    defb 94,102,65,97,80,96,11,5,52
; Wave 53
    defb 94,110,33,97,20,40,14,5,12
    defb 94,110,33,97,20,40,13,5,40
; Wave 54
    defb 94,54,65,97,80,108,0,5,12
    defb 94,54,65,97,80,108,0,5,12
    defb 94,54,65,97,80,108,0,5,32
; Wave 55
    defb 94,194,33,64,68,192,4,4,12
    defb 94,194,33,64,68,192,4,4,36
; Wave 56
    defb 94,102,64,64,80,96,2,4,8
    defb 94,86,64,64,80,96,2,4,8
    defb 94,118,64,64,80,96,2,4,20
; Wave 57
    defb 94,38,97,64,24,192,0,5,0
    defb 94,166,33,64,24,192,0,5,12
    defb 94,38,97,64,24,192,0,5,0
    defb 94,166,33,64,24,192,0,5,32
; Wave 58
    defb 94,102,65,64,64,240,3,4,12
    defb 94,102,65,64,64,240,3,4,12
    defb 94,102,65,64,64,240,3,4,12
    defb 94,102,65,64,64,240,3,4,32
; Wave 59
    defb 104,118,64,66,48,160,15,12,8
    defb 104,86,64,66,48,160,15,12,96
; Wave 60
    defb 94,102,64,64,80,96,2,2,8
    defb 94,102,64,64,80,96,2,2,8
    defb 94,102,64,64,80,96,2,2,8
    defb 94,102,64,64,80,96,2,3,8
    defb 94,102,64,64,80,96,2,3,8
    defb 104,102,64,66,48,160,12,14,100
; Wave 61
    defb 254,254,254,254,254,254,254,254,7
    defb 254,254,254,254,254,254,254,254,7



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BANK 6
org #4000
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#15,#00,#40,#00,#48,#00
db #82,#80,#00,#00,#00,#00,#49,#2e
db #1d,#0c,#86,#86,#2e,#a0,#00,#00
db #00,#00,#40,#04,#1d,#86,#58,#1d
db #2e,#49,#00,#80,#00,#00,#04,#d0
db #0c,#2e,#1d,#2e,#80,#e0,#00,#00
db #00,#00,#d0,#15,#2e,#49,#48,#7a
db #00,#80,#00,#00,#00,#00,#00,#40
db #00,#15,#00,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#08,#00
db #40,#00,#08,#00,#84,#00,#00,#00
db #41,#04,#c3,#86,#0c,#84,#86,#86
db #0c,#49,#00,#80,#40,#04,#49,#c3
db #1d,#0c,#0c,#49,#1d,#7a,#48,#80
db #40,#00,#b5,#2e,#1d,#86,#0c,#3f
db #3f,#2e,#48,#86,#00,#40,#0c,#d0
db #49,#2e,#86,#c3,#86,#58,#80,#80
db #00,#00,#04,#c1,#86,#0c,#58,#1d
db #80,#48,#00,#00,#00,#00,#80,#d0
db #50,#0c,#7a,#0c,#00,#80,#00,#00
db #00,#00,#00,#00,#00,#40,#80,#e0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#80,#00
db #00,#00,#00,#00,#15,#00,#1d,#2a
db #04,#40,#86,#1d,#c0,#00,#2a,#80
db #15,#04,#86,#86,#3f,#84,#0c,#c3
db #e0,#1d,#00,#80,#00,#00,#6b,#49
db #48,#58,#b5,#3f,#1d,#6a,#80,#00
db #15,#40,#f0,#84,#2e,#1d,#86,#58
db #7a,#7a,#c0,#b5,#2e,#2e,#86,#1d
db #a4,#49,#86,#86,#0c,#7a,#a0,#80
db #00,#40,#84,#49,#b5,#58,#f0,#0c
db #0c,#c3,#00,#08,#00,#00,#15,#15
db #1d,#c0,#84,#6a,#48,#58,#00,#00
db #00,#00,#00,#40,#c0,#7a,#e0,#6a
db #00,#80,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#00,#00,#40,#00,#3f,#80
db #00,#00,#00,#00,#2e,#95,#3f,#6a
db #84,#15,#97,#1d,#2a,#80,#80,#40
db #c1,#6b,#97,#1d,#7a,#b5,#97,#7a
db #e0,#6a,#00,#00,#40,#15,#3f,#2e
db #3f,#e0,#3f,#1d,#3f,#f0,#80,#80
db #3f,#40,#e0,#95,#2e,#b5,#86,#1d
db #7a,#e0,#6a,#c0,#2e,#97,#7a,#d0
db #2e,#49,#86,#c3,#3f,#1d,#c0,#6a
db #40,#15,#7a,#3f,#95,#b5,#1d,#1d
db #49,#95,#2a,#80,#00,#00,#50,#b5
db #3f,#a4,#b5,#7a,#b5,#2e,#00,#80
db #00,#00,#40,#40,#b5,#7a,#7a,#95
db #80,#6a,#00,#00,#00,#00,#00,#00
db #40,#d0,#80,#e0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #15,#00,#00,#00,#40,#00,#3f,#e0
db #00,#00,#00,#00,#49,#2e,#7a,#6a
db #15,#50,#c3,#0c,#6a,#80,#00,#40
db #3f,#49,#7a,#1d,#80,#50,#2e,#49
db #7a,#6a,#80,#00,#00,#40,#c0,#f0
db #e0,#e0,#6a,#b5,#e0,#f0,#e0,#80
db #3f,#50,#c0,#40,#2e,#95,#86,#1d
db #1d,#d0,#e0,#c0,#6b,#49,#6a,#7a
db #2e,#49,#86,#c3,#3f,#0c,#e0,#6a
db #15,#a4,#e0,#6a,#40,#95,#2a,#1d
db #95,#f0,#80,#c0,#00,#50,#c0,#f0
db #b5,#c0,#1d,#6a,#95,#2e,#80,#2a
db #00,#40,#c0,#c0,#b5,#84,#d0,#6a
db #c0,#c0,#00,#00,#00,#00,#00,#40
db #c0,#d0,#c0,#e0,#00,#80,#00,#00
db #00,#00,#40,#80,#00,#00,#00,#00
db #a4,#50,#a0,#00,#40,#00,#f0,#c0
db #80,#00,#00,#00,#f0,#6b,#e0,#80
db #50,#50,#49,#2e,#58,#e0,#00,#00
db #40,#d0,#e0,#58,#80,#40,#d0,#a4
db #e0,#e0,#80,#80,#00,#40,#d0,#c0
db #58,#e0,#e0,#c0,#80,#c0,#c0,#40
db #2e,#f0,#e0,#c0,#d0,#f0,#58,#f0
db #d0,#d0,#d0,#e0,#95,#a4,#f0,#e0
db #d0,#a4,#58,#86,#e0,#f0,#c0,#c0
db #00,#d0,#40,#d0,#c0,#d0,#e0,#f0
db #e0,#58,#40,#c0,#50,#40,#d0,#e0
db #c0,#80,#e0,#80,#95,#f0,#80,#a0
db #00,#40,#c0,#00,#a4,#d0,#d2,#58
db #80,#40,#00,#00,#00,#00,#40,#c0
db #c0,#d0,#e0,#f0,#80,#c0,#00,#00
db #00,#00,#40,#c0,#00,#00,#00,#00
db #a4,#50,#a0,#00,#00,#00,#d0,#40
db #a0,#00,#00,#00,#d0,#b5,#a0,#80
db #40,#00,#b5,#a4,#f0,#7a,#80,#00
db #40,#40,#c0,#e0,#e0,#80,#40,#d0
db #80,#c0,#40,#80,#80,#00,#b5,#d0
db #1d,#7a,#e0,#c0,#d0,#40,#c0,#f0
db #d0,#c0,#c0,#d0,#e0,#7a,#e0,#a0
db #c0,#00,#e0,#00,#d0,#e0,#d0,#d0
db #40,#d0,#f0,#58,#7a,#f0,#80,#80
db #00,#40,#50,#b5,#00,#a0,#d0,#b5
db #7a,#1d,#80,#e0,#50,#40,#e0,#c0
db #00,#00,#c0,#40,#d0,#e0,#80,#00
db #40,#c0,#40,#80,#a4,#d0,#7a,#e0
db #d0,#50,#80,#e0,#00,#00,#40,#40
db #d0,#95,#d0,#e0,#c0,#c0,#00,#00
db #00,#00,#40,#c0,#00,#00,#00,#00
db #d0,#40,#00,#00,#00,#00,#50,#00
db #80,#00,#00,#00,#50,#b5,#80,#a0
db #00,#00,#d0,#b5,#d0,#e0,#80,#00
db #00,#40,#00,#80,#80,#00,#00,#40
db #40,#80,#e0,#40,#00,#00,#d0,#40
db #7a,#e0,#80,#00,#40,#50,#c0,#c0
db #e0,#c0,#80,#40,#80,#e0,#80,#80
db #40,#00,#e0,#d0,#40,#d0,#40,#00
db #00,#40,#c0,#e0,#e0,#80,#00,#c0
db #00,#00,#40,#d0,#00,#80,#40,#d0
db #e0,#7a,#00,#80,#40,#00,#00,#00
db #00,#00,#00,#00,#40,#80,#80,#00
db #c0,#d0,#00,#80,#40,#00,#e0,#00
db #40,#d0,#e0,#c0,#00,#00,#00,#00
db #c0,#d0,#e0,#7a,#80,#80,#00,#80
db #00,#00,#40,#c0,#00,#00,#00,#00
db #d0,#c0,#00,#00,#00,#00,#40,#00
db #80,#00,#00,#00,#00,#40,#00,#80
db #00,#00,#d0,#d0,#80,#80,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#40
db #00,#00,#40,#40,#80,#00,#40,#00
db #e0,#80,#00,#00,#00,#00,#00,#00
db #80,#c0,#00,#00,#00,#80,#00,#00
db #00,#00,#d0,#80,#00,#00,#00,#00
db #00,#00,#00,#80,#80,#00,#00,#40
db #00,#00,#00,#40,#00,#00,#40,#40
db #80,#e0,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #80,#00,#00,#00,#00,#00,#00,#00
db #c0,#00,#c0,#80,#00,#80,#00,#00
db #c0,#40,#c0,#e0,#80,#40,#80,#e0
db #00,#00,#00,#80,#00,#00,#00,#00
db #c0,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#40,#80,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #a0,#00,#00,#00,#00,#00,#00,#00
db #00,#80,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#00,#00,#00,#00
db #00,#00,#00,#a0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#c0,#00,#00,#00,#c0,#80
db #00,#00,#00,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#e6,#cc,#e6,#cc,#f3,#cc
db #88,#00,#00,#00,#00,#00,#e6,#73
db #e6,#73,#f3,#93,#f3,#e6,#88,#00
db #44,#00,#d9,#00,#63,#b3,#73,#e6
db #88,#00,#00,#d9,#00,#99,#44,#b3
db #93,#d3,#e6,#cc,#cc,#00,#00,#00
db #e6,#cc,#f3,#cc,#b3,#f3,#f3,#d9
db #73,#f3,#e6,#88,#e6,#73,#f3,#73
db #b3,#63,#f3,#b3,#73,#93,#e6,#e6
db #00,#cc,#44,#cc,#93,#f3,#e6,#d9
db #cc,#f3,#00,#88,#44,#99,#d9,#b3
db #63,#d3,#73,#cc,#88,#00,#00,#00
db #00,#00,#e6,#00,#e6,#b3,#f3,#e6
db #f3,#00,#88,#d9,#00,#00,#e6,#73
db #e6,#73,#f3,#93,#88,#e6,#00,#00
db #00,#cc,#cc,#cc,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#cc,#00
db #cc,#00,#cc,#00,#00,#00,#00,#00
db #00,#00,#73,#e6,#73,#e6,#33,#f3
db #e6,#88,#00,#00,#11,#00,#b3,#cc
db #93,#f3,#e6,#cc,#cc,#f3,#d9,#88
db #e6,#cc,#f3,#cc,#b3,#73,#f3,#d9
db #73,#f3,#e6,#88,#e6,#73,#cc,#73
db #b3,#63,#f3,#b3,#73,#93,#e6,#e6
db #44,#99,#d9,#b3,#b3,#d3,#e6,#cc
db #cc,#cc,#d9,#88,#00,#00,#73,#e6
db #d3,#e6,#93,#f3,#e6,#f3,#00,#88
db #00,#00,#cc,#e6,#cc,#e6,#cc,#f3
db #00,#88,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#73,#cc
db #73,#cc,#33,#cc,#cc,#88,#88,#00
db #f3,#cc,#f3,#cc,#f3,#b3,#b3,#d3
db #93,#73,#e6,#d9,#f3,#63,#e6,#b3
db #e6,#93,#f3,#f3,#f3,#73,#88,#e6
db #00,#cc,#e6,#73,#e6,#d3,#f3,#c3
db #f3,#f3,#88,#f3,#00,#00,#00,#cc
db #00,#cc,#00,#cc,#00,#88,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#44,#00,#cc,#00,#00,#00
db #e6,#cc,#f3,#cc,#e6,#d9,#cc,#b3
db #d9,#d3,#e6,#88,#e6,#73,#f3,#d3
db #f3,#d3,#f3,#c3,#e6,#f3,#88,#d9
db #44,#cc,#cc,#cc,#88,#cc,#00,#cc
db #00,#88,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#cc,#00
db #cc,#00,#cc,#00,#88,#00,#00,#00
db #f3,#cc,#d3,#f3,#d3,#f3,#c3,#f3
db #f3,#e6,#d9,#00,#e6,#66,#f3,#e6
db #d9,#e6,#cc,#f3,#d9,#99,#cc,#e6
db #00,#cc,#00,#cc,#cc,#cc,#cc,#cc
db #88,#cc,#00,#88,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#cc,#00,#cc,#00,#cc,#00
db #00,#00,#00,#00,#44,#00,#73,#e6
db #d3,#e6,#63,#f3,#f3,#88,#88,#00
db #e6,#cc,#cc,#e6,#cc,#e6,#cc,#f3
db #73,#cc,#88,#d9,#b3,#73,#b3,#f3
db #c3,#33,#d9,#b3,#73,#93,#e6,#e6
db #44,#cc,#e6,#cc,#e6,#e6,#f3,#d9
db #cc,#f3,#cc,#cc,#00,#00,#cc,#cc
db #cc,#cc,#cc,#cc,#88,#cc,#00,#88
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#cc,#00
db #cc,#00,#cc,#00,#00,#00,#00,#00
db #00,#00,#73,#e6,#73,#e6,#63,#f3
db #e6,#88,#88,#00,#99,#44,#b3,#e6
db #c3,#e6,#c6,#f3,#cc,#f3,#00,#d9
db #e6,#cc,#e6,#cc,#b3,#73,#f3,#d9
db #73,#f3,#e6,#88,#e6,#73,#cc,#73
db #b3,#63,#f3,#b3,#73,#93,#e6,#e6
db #44,#99,#cc,#e3,#93,#73,#e6,#d9
db #cc,#f3,#00,#88,#00,#00,#73,#cc
db #73,#b3,#33,#e6,#e6,#f3,#88,#d9
db #00,#00,#cc,#e6,#cc,#e6,#cc,#f3
db #00,#88,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#2c,#00,#2c,#00,#08,#00
db #00,#40,#00,#94,#40,#94,#2c,#49
db #2c,#49,#08,#86,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #c0,#00,#2c,#c0,#c2,#80,#00,#00
db #00,#00,#00,#00,#c0,#00,#2c,#c0
db #c2,#80,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#c0,#00,#80,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#2c,#00,#2c,#00,#08,#00
db #00,#40,#00,#94,#40,#94,#2c,#49
db #2c,#49,#08,#86,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #84,#00,#ca,#00,#00,#00,#00,#00
db #00,#00,#c5,#40,#4d,#ca,#c5,#c5
db #80,#80,#c5,#40,#00,#00,#45,#40
db #86,#cb,#cf,#cb,#4d,#ca,#49,#8e
db #c7,#c0,#4d,#c1,#ca,#cf,#ca,#ca
db #ca,#ca,#c5,#8e,#40,#40,#ca,#cf
db #00,#80,#80,#80,#cf,#4d,#c0,#40
db #c0,#c7,#00,#80,#c5,#40,#c5,#c0
db #4d,#86,#c5,#ca,#00,#40,#c0,#80
db #40,#cf,#c5,#c5,#c0,#ca,#8e,#cb
db #00,#00,#00,#c0,#c0,#80,#c0,#00
db #00,#80,#40,#c5,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#84,#00,#ca,#00
db #00,#00,#00,#00,#00,#00,#c5,#40
db #4d,#ca,#c5,#c5,#80,#80,#c5,#40
db #00,#00,#45,#40,#86,#cb,#cf,#cb
db #4d,#ca,#49,#8e,#c7,#c0,#4d,#c1
db #ca,#cf,#ca,#ca,#ca,#ca,#c5,#8e
db #40,#40,#ca,#cf,#00,#80,#80,#80
db #cf,#4d,#80,#40,#40,#45,#80,#80
db #c5,#40,#c5,#c0,#c3,#c3,#4d,#ca
db #c2,#40,#48,#80,#45,#8e,#c5,#84
db #cf,#0c,#c5,#ca,#00,#c0,#45,#84
db #c2,#80,#ca,#00,#c5,#48,#49,#8e
db #00,#00,#c5,#40,#4d,#8e,#c5,#8e
db #80,#ca,#c5,#8e,#00,#00,#00,#40
db #84,#ca,#ca,#c0,#00,#80,#00,#40
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#ca,#84,#c5,#ca
db #80,#00,#40,#00,#00,#00,#40,#c5
db #cb,#4d,#cb,#c5,#ca,#80,#8e,#c5
db #c0,#00,#c1,#45,#cf,#86,#ca,#cf
db #ca,#4d,#8e,#49,#40,#c7,#cf,#4d
db #80,#ca,#80,#ca,#4d,#ca,#40,#c5
db #45,#40,#80,#ca,#c5,#40,#c5,#c0
db #c3,#cf,#ca,#80,#45,#40,#80,#80
db #c5,#cb,#c5,#84,#0c,#c3,#ca,#4d
db #40,#40,#cf,#ca,#80,#40,#80,#c0
db #4d,#cf,#40,#80,#c0,#c7,#c1,#4d
db #cf,#ca,#ca,#ca,#ca,#ca,#8e,#c5
db #00,#00,#40,#45,#8e,#c3,#cb,#cf
db #ca,#4d,#8e,#49,#00,#00,#40,#c5
db #ca,#4d,#c5,#c5,#80,#80,#40,#c5
db #00,#00,#84,#ca,#00,#00,#00,#00
db #00,#00,#00,#00,#84,#00,#ca,#00
db #00,#00,#00,#00,#00,#00,#c5,#40
db #4d,#ca,#c5,#c5,#80,#80,#c5,#40
db #00,#00,#45,#40,#c2,#cb,#ca,#86
db #4d,#ca,#49,#8e,#c2,#c0,#48,#c1
db #45,#80,#c1,#00,#c7,#86,#c5,#8e
db #40,#45,#80,#80,#c5,#cb,#c5,#84
db #c3,#86,#4d,#ca,#40,#45,#ca,#80
db #00,#40,#80,#c0,#cf,#0c,#80,#ca
db #c7,#c0,#4d,#cf,#ca,#80,#ca,#80
db #ca,#4d,#c5,#40,#00,#c0,#45,#c1
db #c3,#cf,#cf,#ca,#c7,#ca,#49,#8e
db #00,#00,#c5,#40,#4d,#8e,#c5,#8e
db #80,#ca,#c5,#8e,#00,#00,#00,#40
db #84,#ca,#ca,#c5,#00,#80,#00,#40
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #ca,#45,#cf,#08,#00,#00,#40,#00
db #00,#00,#ca,#c5,#cb,#80,#c1,#00
db #ca,#80,#8e,#c5,#c0,#40,#40,#c5
db #cf,#86,#c5,#84,#c3,#c3,#4d,#cb
db #40,#c7,#ca,#80,#00,#40,#80,#c0
db #cf,#0c,#c0,#ca,#c7,#40,#4d,#cf
db #ca,#80,#ca,#80,#ca,#4d,#c5,#40
db #00,#c0,#45,#c1,#c3,#cf,#cf,#ca
db #c7,#ca,#49,#8e,#00,#00,#c5,#40
db #4d,#8e,#c5,#8e,#80,#ca,#c5,#8e
db #00,#00,#00,#40,#84,#ca,#ca,#c5
db #00,#80,#00,#40,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#44,#00,#46,#cc,#23,#cc
db #88,#00,#00,#00,#00,#00,#13,#89
db #46,#c6,#03,#c3,#83,#46,#00,#00
db #41,#44,#13,#cc,#c3,#cc,#46,#cc
db #89,#13,#02,#88,#89,#44,#89,#cc
db #46,#89,#43,#83,#46,#cc,#cc,#46
db #63,#13,#46,#89,#43,#83,#46,#89
db #03,#23,#88,#23,#63,#c3,#46,#46
db #43,#43,#46,#46,#03,#13,#88,#83
db #89,#13,#89,#89,#46,#83,#43,#89
db #46,#23,#cc,#23,#11,#44,#13,#cc
db #c3,#89,#46,#83,#89,#cc,#02,#46
db #00,#44,#13,#cc,#46,#cc,#03,#cc
db #83,#13,#00,#88,#00,#00,#44,#89
db #46,#c6,#23,#c3,#88,#46,#00,#00
db #00,#00,#cc,#cc,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#44,#00
db #46,#00,#23,#00,#88,#00,#00,#00
db #44,#00,#cc,#89,#cc,#66,#cc,#c3
db #13,#c6,#88,#00,#89,#44,#89,#cc
db #46,#63,#c3,#46,#46,#89,#cc,#02
db #63,#13,#46,#89,#43,#23,#46,#89
db #03,#83,#02,#23,#63,#c3,#03,#46
db #23,#43,#46,#46,#03,#13,#02,#83
db #89,#13,#cc,#89,#cc,#03,#c3,#89
db #46,#23,#cc,#23,#44,#11,#cc,#13
db #cc,#c3,#cc,#46,#13,#89,#88,#02
db #00,#00,#44,#89,#46,#66,#23,#c3
db #88,#c6,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#cc,#00,#cc,#00
db #88,#00,#00,#00,#89,#44,#cc,#44
db #cc,#46,#cc,#23,#13,#cc,#88,#00
db #63,#13,#46,#89,#43,#23,#03,#46
db #23,#89,#23,#02,#23,#93,#89,#03
db #03,#93,#c9,#46,#83,#13,#23,#83
db #89,#13,#cc,#13,#cc,#c3,#89,#c6
db #93,#89,#88,#02,#00,#44,#00,#89
db #46,#c6,#23,#c3,#88,#46,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#89,#44,#89,#44
db #23,#cc,#cc,#cc,#13,#00,#88,#00
db #83,#13,#89,#43,#43,#83,#89,#46
db #03,#89,#46,#02,#83,#c3,#89,#46
db #c6,#43,#c3,#03,#83,#c3,#46,#83
db #89,#13,#44,#cc,#88,#46,#cc,#66
db #00,#89,#00,#02,#00,#44,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#46,#00,#83,#00
db #88,#00,#00,#00,#89,#44,#cc,#89
db #cc,#c6,#89,#c3,#93,#46,#88,#00
db #23,#13,#44,#13,#46,#c3,#01,#c6
db #23,#89,#23,#02,#63,#93,#46,#89
db #11,#03,#46,#cc,#23,#13,#23,#83
db #89,#13,#cc,#89,#cc,#03,#cc,#46
db #03,#89,#88,#02,#00,#44,#00,#44
db #cc,#46,#cc,#23,#88,#cc,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#44,#00
db #46,#00,#83,#00,#88,#00,#00,#00
db #44,#00,#cc,#89,#cc,#66,#cc,#63
db #13,#c6,#88,#00,#89,#11,#cc,#13
db #cc,#c3,#c3,#46,#46,#89,#cc,#02
db #63,#13,#03,#89,#23,#03,#46,#89
db #03,#23,#02,#23,#63,#c3,#46,#46
db #43,#43,#46,#46,#03,#13,#02,#83
db #cc,#13,#89,#89,#46,#23,#c3,#89
db #46,#23,#00,#23,#00,#01,#00,#cc
db #00,#63,#00,#46,#03,#01,#88,#02
db #00,#00,#44,#89,#02,#02,#23,#43
db #88,#46,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #98,#44,#0f,#30,#64,#88,#00,#00
db #00,#00,#00,#00,#10,#cc,#44,#cc
db #88,#cc,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#44,#44,#25,#64,#88
db #00,#00,#88,#00,#00,#00,#00,#00
db #00,#00,#10,#8d,#64,#cc,#1a,#64
db #98,#44,#c3,#cc,#64,#88,#00,#00
db #87,#1a,#c9,#25,#98,#30,#30,#92
db #c6,#61,#00,#c9,#25,#92,#c9,#c9
db #00,#44,#00,#cc,#00,#88,#10,#00
db #64,#1a,#1a,#25,#00,#00,#00,#00
db #44,#00,#64,#8d,#00,#cc,#88,#64
db #10,#00,#44,#44,#88,#25,#00,#88
db #00,#00,#00,#00,#98,#cc,#0f,#cc
db #64,#cc,#00,#00,#00,#00,#00,#00
db #44,#30,#88,#00,#00,#00,#00,#00
db #44,#00,#30,#00,#88,#00,#00,#00
db #00,#00,#00,#00,#98,#98,#cc,#30
db #30,#64,#00,#00,#00,#00,#00,#00
db #44,#44,#cc,#cc,#88,#88,#10,#88
db #00,#00,#00,#00,#30,#98,#1a,#c3
db #61,#64,#00,#00,#64,#cc,#64,#88
db #44,#98,#cc,#30,#88,#4e,#41,#20
db #c3,#92,#61,#1a,#44,#00,#cc,#00
db #88,#00,#44,#00,#61,#1a,#25,#61
db #cc,#cc,#cc,#cc,#cc,#cc,#00,#88
db #64,#1a,#64,#1a,#44,#88,#cc,#00
db #88,#44,#05,#00,#00,#cc,#00,#88
db #30,#98,#1a,#87,#25,#64,#00,#20
db #00,#00,#00,#00,#44,#98,#cc,#30
db #88,#4e,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#44,#00,#cc,#00
db #88,#00,#00,#00,#00,#00,#00,#00
db #30,#98,#1a,#87,#25,#64,#00,#00
db #00,#00,#00,#00,#44,#98,#cc,#30
db #88,#4e,#41,#20,#64,#cc,#20,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #c3,#92,#87,#1a,#00,#00,#00,#00
db #00,#00,#00,#00,#61,#92,#87,#c3
db #44,#00,#cc,#00,#88,#00,#41,#00
db #64,#1a,#20,#1a,#30,#98,#1a,#87
db #25,#64,#00,#20,#00,#cc,#00,#00
db #44,#98,#cc,#30,#88,#4e,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #44,#00,#cc,#00,#88,#00,#00,#00
db #00,#00,#00,#00,#30,#98,#1a,#c3
db #25,#4e,#00,#00,#00,#00,#00,#00
db #44,#98,#cc,#30,#88,#4e,#41,#20
db #00,#00,#88,#00,#cc,#88,#cc,#00
db #cc,#44,#88,#00,#64,#cc,#cc,#cc
db #44,#cc,#cc,#cc,#88,#cc,#00,#44
db #c3,#92,#98,#64,#44,#00,#cc,#00
db #88,#00,#41,#00,#25,#1a,#98,#98
db #30,#98,#1a,#c3,#61,#64,#00,#20
db #64,#1a,#cc,#64,#44,#98,#cc,#30
db #88,#4e,#44,#00,#00,#cc,#88,#cc
db #98,#44,#cc,#cc,#64,#88,#00,#88
db #00,#00,#00,#00,#44,#98,#30,#30
db #88,#64,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #41,#00,#cc,#f3,#e6,#00,#99,#cc
db #93,#e6,#cc,#88,#11,#44,#cc,#cc
db #00,#cc,#51,#d9,#f3,#f3,#f3,#d9
db #00,#00,#00,#00,#00,#00,#99,#44
db #73,#93,#cc,#e6,#e6,#00,#d3,#00
db #d3,#d9,#88,#f3,#cc,#cc,#88,#cc
db #00,#00,#00,#00,#00,#00,#44,#00
db #cc,#cc,#00,#88,#e6,#00,#e6,#00
db #e6,#44,#88,#cc,#00,#88,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #41,#00,#f3,#93,#f3,#00,#99,#d9
db #93,#f3,#cc,#88,#00,#11,#cc,#cc
db #00,#cc,#51,#d9,#f3,#f3,#f3,#d9
db #00,#00,#00,#00,#00,#00,#51,#44
db #93,#c3,#88,#e6,#00,#00,#00,#00
db #00,#00,#33,#c9,#e6,#73,#00,#00
db #e6,#00,#d3,#00,#d3,#d9,#88,#e6
db #00,#00,#00,#00,#00,#cc,#00,#cc
db #00,#88,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #51,#00,#33,#c3,#b3,#00,#99,#d9
db #93,#73,#cc,#88,#00,#11,#cc,#f3
db #00,#cc,#51,#d9,#cc,#f3,#f3,#d9
db #00,#00,#00,#00,#00,#00,#44,#44
db #c3,#f3,#a2,#cc,#00,#00,#00,#00
db #00,#00,#c9,#51,#73,#93,#00,#88
db #00,#00,#00,#00,#44,#00,#73,#93
db #88,#e6,#00,#00,#e6,#00,#73,#00
db #73,#d9,#88,#e6,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #51,#00,#c3,#f3,#b3,#00,#c9,#d9
db #c3,#d3,#cc,#88,#00,#51,#f3,#33
db #00,#e6,#51,#99,#f3,#33,#f3,#d9
db #00,#00,#00,#00,#00,#00,#44,#51
db #f3,#cc,#88,#e6,#00,#00,#00,#00
db #00,#00,#d9,#cc,#93,#93,#88,#a2
db #e6,#00,#e6,#00,#e6,#44,#93,#c9
db #e6,#73,#00,#00,#00,#00,#00,#00
db #d9,#44,#e6,#73,#00,#88,#00,#00
db #00,#e6,#00,#73,#00,#73,#00,#88
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #44,#00,#f3,#cc,#cc,#00,#99,#d9
db #f3,#d3,#cc,#88,#00,#51,#33,#c3
db #44,#f3,#d9,#99,#33,#c3,#d9,#d9
db #e6,#00,#e6,#00,#e6,#cc,#d9,#d9
db #cc,#f3,#a2,#e6,#00,#00,#00,#00
db #00,#00,#44,#44,#f3,#00,#88,#88
db #00,#00,#00,#00,#00,#00,#51,#44
db #93,#93,#88,#a2,#00,#00,#00,#00
db #00,#00,#93,#c9,#e6,#73,#00,#00
db #00,#00,#00,#00,#d9,#44,#e6,#73
db #00,#88,#00,#00,#00,#e6,#00,#73
db #00,#73,#00,#88,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#cc,#00,#f3,#00,#88,#00
db #44,#00,#f3,#cc,#cc,#cc,#99,#d9
db #f3,#93,#cc,#88,#00,#d9,#f3,#33
db #00,#e6,#11,#d9,#c3,#c3,#d9,#d9
db #00,#00,#00,#00,#00,#00,#51,#51
db #f3,#33,#a2,#e6,#00,#00,#00,#00
db #00,#00,#44,#51,#00,#cc,#88,#a2
db #00,#00,#00,#00,#00,#00,#44,#44
db #93,#f3,#a2,#88,#00,#00,#00,#00
db #00,#00,#c9,#51,#73,#93,#00,#88
db #00,#00,#00,#00,#44,#00,#73,#93
db #88,#e6,#00,#00,#e6,#00,#73,#00
db #73,#d9,#88,#e6,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #45,#00,#45,#40,#84,#40,#c0,#00
db #00,#00,#00,#00,#45,#84,#45,#84
db #84,#c5,#84,#c5,#ca,#80,#00,#00
db #00,#00,#00,#40,#00,#45,#c5,#ca
db #84,#c7,#80,#80,#00,#00,#45,#40
db #4d,#ca,#c5,#40,#cf,#ca,#8e,#c0
db #00,#00,#45,#8e,#cf,#c7,#c0,#4d
db #c0,#4d,#cf,#c0,#00,#00,#45,#40
db #4d,#80,#c0,#40,#c0,#c5,#cf,#49
db #00,#00,#45,#8e,#cf,#c7,#c5,#4d
db #cf,#4d,#8e,#c0,#00,#00,#00,#40
db #00,#ca,#c5,#40,#84,#ca,#80,#c0
db #45,#00,#45,#40,#84,#45,#84,#ca
db #ca,#c7,#00,#80,#45,#84,#45,#84
db #84,#c5,#c0,#c5,#00,#80,#00,#00
db #00,#40,#40,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#45,#00,#45,#40
db #84,#40,#c0,#00,#00,#00,#00,#00
db #40,#84,#40,#84,#c5,#c5,#cf,#c5
db #ca,#80,#00,#00,#00,#00,#40,#c0
db #ca,#c0,#40,#c0,#c0,#c0,#cf,#c0
db #00,#00,#ca,#45,#c0,#4d,#48,#c0
db #c0,#84,#c0,#c7,#00,#00,#8e,#45
db #c7,#4d,#4d,#c0,#86,#cb,#cf,#8e
db #00,#00,#40,#45,#ca,#cf,#45,#c5
db #cf,#4d,#8e,#ca,#45,#00,#45,#c0
db #84,#c0,#84,#ca,#00,#ca,#00,#c0
db #45,#84,#45,#84,#84,#c5,#c0,#c5
db #00,#00,#00,#00,#00,#00,#00,#40
db #00,#40,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#40,#00,#00,#00
db #40,#00,#c0,#00,#c5,#40,#c5,#45
db #c0,#c5,#40,#c0,#84,#c0,#cf,#c7
db #00,#00,#c5,#40,#4d,#ca,#c5,#c0
db #49,#c0,#cf,#c0,#00,#00,#c0,#8e
db #ca,#c7,#ca,#48,#86,#cb,#cf,#8e
db #84,#45,#84,#45,#c5,#84,#c5,#84
db #cf,#4d,#8e,#ca,#00,#45,#40,#45
db #40,#84,#00,#c0,#40,#ca,#c0,#cf
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#c7,#c0,#00,#00,#00,#00
db #00,#00,#c0,#40,#c0,#84,#c0,#cf
db #45,#00,#45,#40,#84,#40,#ca,#c0
db #cf,#c0,#c5,#ca,#45,#84,#45,#84
db #84,#c5,#c5,#84,#cf,#86,#c5,#8e
db #00,#00,#00,#40,#00,#40,#84,#c0
db #c0,#c0,#c0,#ca,#00,#00,#00,#00
db #00,#00,#00,#40,#40,#c5,#cf,#cf
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#c0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#40,#00,#00,#00
db #40,#00,#c0,#00,#84,#45,#84,#45
db #c5,#84,#c5,#c0,#cf,#ca,#8e,#c7
db #00,#45,#c5,#45,#ca,#84,#ca,#84
db #49,#c7,#cf,#ca,#00,#00,#c5,#ca
db #c5,#c5,#c5,#48,#0c,#cb,#cf,#8e
db #c5,#00,#c5,#40,#c0,#ca,#40,#c0
db #84,#c0,#cf,#c0,#00,#40,#40,#45
db #40,#c5,#00,#c0,#40,#c0,#c0,#cf
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#45,#00,#45,#40
db #84,#40,#c0,#00,#00,#00,#00,#00
db #45,#84,#45,#84,#84,#c5,#84,#c5
db #00,#00,#00,#00,#00,#00,#40,#c0
db #ca,#c0,#45,#ca,#cf,#ca,#8e,#c0
db #00,#00,#cf,#45,#cf,#4d,#4d,#c5
db #49,#c7,#cf,#ca,#00,#00,#ca,#45
db #c0,#cf,#48,#c0,#c0,#8e,#c0,#8e
db #00,#00,#40,#45,#ca,#cf,#40,#c0
db #c0,#84,#cf,#c3,#40,#00,#40,#c0
db #c5,#c0,#cf,#c0,#ca,#c0,#00,#c0
db #45,#84,#45,#84,#84,#c5,#c0,#c5
db #00,#80,#00,#00,#00,#00,#00,#40
db #00,#40,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#d9,#44,#22,#88
db #00,#00,#00,#00,#00,#00,#cc,#44
db #66,#e3,#00,#88,#00,#00,#00,#00
db #44,#00,#f3,#e6,#e6,#e6,#00,#00
db #00,#00,#00,#00,#11,#51,#d3,#66
db #99,#f3,#88,#88,#00,#00,#00,#00
db #f3,#cc,#99,#73,#d9,#d9,#73,#e6
db #d9,#44,#88,#00,#f3,#73,#99,#c9
db #d9,#b3,#73,#93,#d9,#b3,#88,#e6
db #11,#cc,#d3,#73,#99,#d9,#88,#e6
db #00,#44,#00,#00,#44,#51,#f3,#66
db #e6,#f3,#00,#88,#00,#00,#00,#00
db #00,#00,#cc,#e6,#66,#e6,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#44
db #d9,#e3,#22,#88,#00,#00,#00,#00
db #00,#00,#44,#88,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#44,#00,#93,#c9,#88,#22
db #00,#00,#00,#00,#44,#00,#e3,#e6
db #e6,#66,#88,#00,#00,#00,#00,#00
db #f3,#cc,#c9,#73,#d9,#d9,#73,#e6
db #e6,#88,#00,#00,#e6,#73,#73,#99
db #d9,#b3,#f3,#c3,#e6,#73,#00,#88
db #44,#99,#f3,#93,#66,#99,#00,#cc
db #00,#88,#00,#00,#00,#00,#44,#e6
db #63,#c6,#88,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#99,#00,#22
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#44,#00
db #b3,#00,#88,#00,#00,#00,#00,#00
db #f3,#cc,#99,#73,#f3,#d9,#d3,#e6
db #88,#00,#00,#00,#e3,#66,#d3,#d3
db #c3,#d3,#d9,#b3,#88,#e6,#00,#00
db #00,#cc,#44,#e6,#b3,#63,#22,#44
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #d9,#cc,#f3,#cc,#f3,#cc,#d9,#cc
db #88,#00,#00,#00,#d9,#e3,#f3,#d3
db #f3,#c3,#d9,#63,#88,#e6,#00,#00
db #00,#cc,#00,#cc,#00,#cc,#00,#cc
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#44,#00
db #d9,#00,#88,#00,#00,#00,#00,#00
db #e3,#cc,#d3,#e6,#c9,#cc,#d9,#44
db #e6,#88,#00,#00,#f3,#66,#99,#d3
db #d9,#d9,#73,#e3,#e6,#73,#00,#88
db #00,#cc,#44,#73,#cc,#d9,#88,#e6
db #00,#88,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#44,#00,#f3,#d9,#88,#22
db #00,#00,#00,#00,#44,#00,#cc,#e6
db #cc,#e6,#00,#00,#00,#00,#00,#00
db #e6,#99,#73,#d3,#d9,#99,#f3,#cc
db #d9,#44,#88,#00,#f3,#73,#99,#c9
db #d9,#b3,#73,#93,#d9,#b3,#88,#e6
db #44,#cc,#e6,#73,#cc,#d9,#88,#e6
db #00,#44,#00,#00,#00,#00,#44,#cc
db #e6,#cc,#88,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#d9,#00,#88
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#50,#00,#78,#a4,#a4,#58
db #a0,#00,#00,#00,#00,#00,#c0,#d0
db #f0,#f0,#f0,#f0,#b4,#58,#00,#00
db #14,#40,#f0,#c0,#f0,#c0,#c0,#d0
db #c0,#f0,#80,#80,#00,#d0,#40,#d0
db #a4,#1c,#78,#e0,#94,#d0,#d0,#c0
db #a0,#c0,#00,#c0,#40,#d0,#b4,#f0
db #d0,#a4,#d0,#b4,#e0,#a0,#b4,#d0
db #e0,#c0,#b4,#84,#d0,#14,#d0,#40
db #00,#c0,#40,#c0,#a4,#d0,#78,#f0
db #94,#a4,#d0,#b4,#14,#d0,#f0,#d0
db #f0,#1c,#c0,#e0,#c0,#d0,#80,#c0
db #00,#40,#c0,#c0,#f0,#c0,#f0,#d0
db #b4,#f0,#00,#80,#00,#00,#50,#d0
db #78,#f0,#a4,#f0,#a0,#58,#00,#00
db #00,#00,#a4,#58,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#40,#00
db #b4,#00,#1c,#00,#a0,#00,#00,#00
db #40,#00,#e0,#d0,#c0,#2c,#d0,#0c
db #b4,#78,#a0,#00,#00,#94,#40,#58
db #a4,#78,#78,#c0,#d0,#c0,#e0,#80
db #a0,#c0,#00,#c0,#c0,#d0,#b4,#f0
db #94,#a4,#b4,#f0,#f0,#e0,#2c,#f0
db #58,#e0,#b4,#84,#94,#50,#b4,#40
db #00,#c0,#40,#c0,#a4,#d0,#78,#f0
db #94,#f0,#c0,#f0,#40,#94,#c0,#58
db #c0,#f0,#d0,#c0,#b4,#c0,#a0,#80
db #00,#00,#40,#d0,#b4,#2c,#1c,#0c
db #a0,#78,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#2c,#00
db #0c,#00,#0c,#00,#68,#00,#00,#00
db #00,#b4,#40,#f0,#2c,#c0,#78,#d0
db #d0,#b4,#68,#80,#f0,#c0,#2c,#f0
db #68,#f0,#a4,#1c,#d0,#b4,#b4,#f0
db #94,#00,#f0,#40,#f0,#d0,#f0,#1c
db #78,#b4,#c0,#f0,#00,#40,#00,#2c
db #00,#0c,#00,#1c,#00,#e0,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#c0,#00,#f0,#00,#d0,#00
db #d0,#00,#f0,#c0,#84,#c0,#a4,#f0
db #f0,#58,#f0,#0c,#f0,#f0,#b4,#a4
db #00,#40,#00,#c0,#00,#f0,#00,#d0
db #00,#d0,#c0,#f0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#d0,#00
db #f0,#00,#78,#00,#e0,#00,#00,#00
db #00,#d0,#40,#c0,#d0,#c0,#78,#c0
db #d0,#c0,#d0,#c0,#c0,#e0,#c0,#b4
db #d0,#e0,#a4,#a4,#94,#c0,#d0,#94
db #f0,#00,#c0,#40,#c0,#b4,#c0,#58
db #d0,#c0,#80,#c0,#00,#40,#00,#f0
db #00,#f0,#00,#f0,#00,#e0,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#40,#00
db #b4,#00,#0c,#00,#80,#00,#00,#00
db #40,#00,#c0,#d0,#c0,#e0,#c0,#d0
db #f0,#68,#80,#00,#00,#94,#40,#f0
db #a4,#f0,#78,#c0,#94,#c0,#c0,#80
db #e0,#c0,#d0,#c0,#c0,#d0,#b4,#f0
db #94,#f0,#b4,#f0,#a0,#a0,#b4,#a4
db #e0,#a0,#b4,#84,#94,#50,#b4,#40
db #00,#c0,#40,#c0,#a4,#d0,#78,#f0
db #d0,#a4,#e0,#f0,#40,#94,#c0,#d0
db #c0,#78,#c0,#c0,#f0,#c0,#80,#80
db #00,#00,#40,#d0,#b4,#e0,#0c,#d0
db #80,#68,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#95,#00
db #95,#c0,#3f,#c0,#3f,#c0,#80,#00
db #6a,#95,#c0,#6b,#80,#6b,#1d,#c3
db #95,#c3,#80,#6a,#c0,#c0,#c0,#c0
db #00,#80,#84,#41,#2e,#6b,#2a,#2a
db #95,#6a,#2e,#00,#3f,#40,#c0,#1d
db #40,#95,#6a,#80,#00,#40,#00,#95
db #c0,#c0,#c0,#c0,#c0,#95,#00,#80
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#95,#00,#95,#c0,#3f,#c0
db #3f,#c0,#80,#00,#c0,#40,#c0,#2e
db #80,#6b,#95,#c3,#80,#86,#00,#6a
db #6a,#95,#c0,#3f,#80,#6a,#97,#48
db #95,#40,#80,#00,#c0,#c0,#c0,#3f
db #00,#80,#84,#41,#2e,#6b,#2a,#2a
db #95,#6a,#3f,#00,#3f,#40,#c0,#1d
db #40,#c0,#00,#80,#40,#40,#2e,#c0
db #2e,#c0,#0c,#c0,#0c,#80,#6a,#00
db #00,#00,#00,#95,#c0,#95,#c0,#3f
db #c0,#3f,#00,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#c0,#00,#c0,#00
db #c0,#00,#00,#00,#40,#00,#2e,#95
db #2e,#95,#c3,#3f,#86,#3f,#6a,#80
db #80,#15,#00,#80,#00,#00,#95,#40
db #80,#c0,#00,#6a,#40,#00,#c0,#00
db #c1,#40,#2a,#48,#00,#00,#00,#00
db #6a,#95,#3f,#3f,#80,#3f,#1d,#c0
db #95,#40,#80,#00,#c0,#95,#c0,#3f
db #00,#80,#84,#41,#c0,#2e,#80,#2a
db #95,#6a,#3f,#00,#3f,#40,#c0,#1d
db #40,#95,#00,#80,#80,#40,#00,#c0
db #00,#c0,#95,#48,#80,#00,#00,#00
db #40,#15,#2e,#80,#2e,#00,#49,#40
db #0c,#c0,#6a,#6a,#00,#00,#00,#95
db #c0,#95,#c0,#3f,#c0,#3f,#00,#80
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#95,#00,#95,#c0,#3f,#c0
db #3f,#c0,#80,#00,#15,#40,#80,#2e
db #00,#2e,#40,#c3,#c0,#86,#6a,#6a
db #00,#80,#00,#00,#40,#00,#48,#95
db #00,#80,#00,#00,#40,#00,#c0,#00
db #c0,#41,#80,#2a,#00,#00,#00,#00
db #6a,#95,#3f,#3f,#80,#3f,#1d,#c0
db #95,#40,#80,#00,#c0,#95,#6a,#1d
db #00,#80,#c1,#41,#c0,#c0,#80,#80
db #95,#6a,#3f,#00,#3f,#40,#c0,#1d
db #40,#95,#00,#80,#00,#40,#00,#c0
db #40,#84,#c2,#2a,#00,#00,#00,#00
db #15,#80,#80,#00,#00,#00,#40,#95
db #c0,#80,#6a,#00,#00,#40,#95,#2e
db #95,#2e,#3f,#c3,#3f,#86,#80,#6a
db #00,#00,#c0,#c0,#c0,#00,#00,#00
db #00,#00,#00,#00,#c0,#00,#c0,#00
db #c0,#00,#00,#00,#40,#00,#2e,#95
db #2e,#95,#49,#3f,#0c,#3f,#6a,#80
db #80,#15,#00,#80,#00,#00,#95,#40
db #80,#c0,#00,#6a,#40,#00,#c0,#00
db #95,#40,#c0,#48,#00,#00,#00,#00
db #6a,#95,#3f,#3f,#80,#3f,#1d,#c0
db #95,#40,#80,#00,#c0,#95,#3f,#49
db #00,#80,#41,#c1,#2e,#c0,#2a,#80
db #15,#6a,#3f,#00,#2e,#40,#2a,#1d
db #40,#95,#00,#80,#80,#00,#00,#00
db #00,#40,#95,#c2,#80,#00,#00,#00
db #40,#15,#2e,#80,#2e,#00,#c3,#40
db #86,#c0,#6a,#6a,#00,#00,#00,#95
db #c0,#95,#c0,#3f,#c0,#3f,#00,#80
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#95,#00,#95,#c0,#3f,#c0
db #3f,#c0,#80,#00,#40,#40,#c0,#2e
db #95,#2e,#c0,#0c,#80,#0c,#00,#6a
db #6a,#95,#2e,#3f,#2a,#3f,#1d,#c0
db #c0,#40,#80,#00,#c0,#95,#3f,#49
db #00,#80,#04,#c1,#6b,#2e,#2a,#2a
db #95,#6a,#3f,#00,#3f,#40,#48,#97
db #40,#95,#00,#80,#40,#c0,#2e,#c0
db #6b,#80,#c3,#95,#86,#80,#6a,#00
db #00,#00,#00,#95,#c0,#95,#c0,#3f
db #c0,#3f,#00,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#95,#00
db #c0,#c0,#c0,#c0,#95,#c0,#80,#00
db #3f,#95,#49,#3f,#6a,#3f,#1d,#c0
db #95,#40,#80,#6a,#95,#2e,#3f,#c3
db #80,#2a,#04,#c1,#2e,#6b,#2a,#2a
db #c0,#6a,#6b,#3f,#6b,#80,#c3,#97
db #c3,#95,#6a,#80,#00,#40,#00,#95
db #c0,#95,#c0,#3f,#c0,#3f,#00,#80
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#44,#00,#03,#44
db #46,#88,#00,#00,#89,#00,#63,#89
db #46,#66,#13,#13,#41,#01,#66,#88
db #00,#23,#cc,#03,#13,#89,#43,#43
db #41,#01,#23,#46,#00,#00,#00,#00
db #00,#44,#00,#89,#00,#00,#00,#00
db #00,#00,#44,#00,#01,#44,#66,#02
db #66,#02,#46,#88,#00,#00,#44,#11
db #01,#99,#66,#83,#66,#c6,#46,#23
db #00,#00,#00,#00,#00,#44,#00,#02
db #00,#02,#00,#88,#00,#00,#cc,#00
db #13,#44,#43,#89,#41,#00,#23,#00
db #89,#23,#63,#03,#46,#89,#13,#43
db #41,#01,#66,#46,#00,#00,#00,#89
db #44,#66,#03,#13,#46,#01,#00,#88
db #00,#00,#00,#44,#88,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#44,#00
db #88,#00,#00,#00,#00,#00,#89,#00
db #66,#44,#13,#03,#01,#66,#88,#00
db #63,#99,#03,#93,#89,#46,#63,#33
db #41,#11,#46,#66,#00,#00,#00,#cc
db #44,#13,#89,#c3,#00,#41,#00,#23
db #00,#00,#88,#00,#03,#cc,#66,#02
db #66,#02,#46,#88,#00,#00,#88,#66
db #03,#63,#66,#83,#66,#c6,#46,#23
db #00,#00,#00,#00,#44,#cc,#89,#02
db #00,#02,#00,#88,#63,#00,#03,#cc
db #89,#13,#63,#c3,#41,#41,#46,#23
db #00,#99,#89,#93,#66,#46,#13,#33
db #01,#11,#88,#66,#00,#00,#00,#00
db #00,#44,#44,#03,#88,#66,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#89,#00,#03,#00
db #88,#00,#00,#00,#13,#44,#83,#13
db #99,#43,#c3,#83,#93,#66,#88,#00
db #44,#00,#01,#00,#89,#44,#66,#02
db #c6,#02,#46,#88,#44,#11,#01,#99
db #cc,#13,#cc,#83,#cc,#66,#46,#23
db #13,#44,#83,#89,#63,#c3,#83,#83
db #93,#c3,#88,#02,#00,#44,#00,#13
db #89,#13,#03,#23,#88,#66,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #88,#00,#02,#88,#cc,#44,#cc,#02
db #cc,#02,#46,#88,#88,#43,#02,#83
db #cc,#89,#cc,#83,#cc,#93,#46,#89
db #00,#00,#00,#88,#00,#44,#00,#02
db #00,#02,#00,#88,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#cc,#00,#cc,#00
db #88,#00,#00,#00,#03,#44,#03,#03
db #89,#89,#88,#02,#89,#46,#88,#00
db #88,#44,#02,#89,#cc,#03,#cc,#88
db #cc,#89,#46,#02,#88,#66,#02,#c6
db #89,#43,#66,#83,#66,#c6,#46,#23
db #03,#00,#03,#88,#89,#44,#cc,#02
db #89,#02,#88,#88,#00,#44,#00,#03
db #cc,#89,#cc,#02,#88,#46,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#44,#00
db #88,#00,#00,#00,#00,#00,#89,#00
db #66,#44,#13,#03,#01,#46,#88,#00
db #23,#89,#03,#23,#89,#46,#03,#03
db #01,#41,#46,#66,#00,#00,#00,#cc
db #44,#03,#89,#03,#00,#01,#00,#23
db #00,#00,#88,#00,#03,#cc,#66,#02
db #66,#02,#46,#88,#00,#00,#88,#66
db #03,#63,#66,#83,#66,#c6,#46,#23
db #00,#00,#00,#00,#44,#cc,#89,#02
db #00,#02,#00,#88,#23,#00,#03,#cc
db #89,#03,#03,#03,#01,#01,#46,#23
db #00,#89,#89,#23,#66,#46,#13,#03
db #01,#41,#88,#66,#00,#00,#00,#00
db #00,#44,#44,#03,#88,#46,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#80,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#20,#90
db #1a,#30,#4a,#80,#20,#80,#20,#00
db #90,#c1,#20,#0a,#30,#30,#4a,#60
db #20,#4a,#20,#4a,#00,#25,#00,#20
db #60,#30,#90,#c0,#80,#c0,#00,#00
db #90,#40,#85,#10,#85,#10,#30,#25
db #30,#20,#00,#00,#90,#25,#85,#c1
db #85,#61,#c0,#30,#90,#20,#00,#00
db #00,#40,#00,#10,#60,#10,#90,#30
db #80,#20,#00,#00,#90,#25,#20,#20
db #30,#30,#60,#c0,#80,#c0,#80,#00
db #40,#c1,#20,#0a,#1a,#30,#4a,#60
db #20,#4a,#20,#4a,#00,#00,#40,#90
db #80,#30,#00,#80,#00,#80,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#c0,#00,#80,#00
db #80,#00,#00,#00,#40,#00,#60,#90
db #40,#10,#60,#4a,#4a,#20,#4a,#20
db #90,#10,#c0,#60,#c0,#40,#90,#4a
db #60,#20,#00,#20,#90,#25,#85,#c1
db #85,#61,#60,#60,#60,#90,#00,#00
db #40,#40,#60,#10,#c0,#10,#c0,#90
db #60,#80,#60,#00,#00,#00,#40,#90
db #c0,#10,#80,#60,#80,#20,#00,#80
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #90,#40,#c0,#10,#c0,#10,#4a,#80
db #20,#80,#20,#00,#90,#60,#c0,#4b
db #c0,#25,#c2,#c2,#20,#c2,#20,#4a
db #00,#40,#00,#10,#00,#10,#00,#80
db #00,#80,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#30,#00,#80,#00
db #80,#00,#00,#00,#40,#00,#0f,#c1
db #87,#61,#c0,#60,#60,#20,#60,#80
db #90,#40,#c1,#10,#c1,#10,#61,#90
db #60,#80,#00,#00,#90,#25,#c0,#85
db #c0,#25,#90,#25,#c0,#1a,#00,#00
db #40,#10,#4b,#c3,#61,#25,#60,#c2
db #4a,#20,#4a,#20,#00,#00,#40,#85
db #30,#25,#80,#c2,#80,#20,#00,#20
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#80,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#20,#85
db #1a,#30,#4a,#80,#20,#80,#20,#00
db #90,#c1,#82,#0a,#c3,#87,#60,#60
db #80,#4a,#80,#4a,#00,#61,#00,#0a
db #60,#0f,#90,#c0,#80,#c0,#00,#00
db #90,#40,#85,#10,#85,#10,#c0,#25
db #90,#20,#00,#00,#90,#25,#85,#c1
db #85,#61,#25,#61,#1a,#20,#00,#00
db #00,#40,#00,#10,#60,#10,#90,#30
db #80,#20,#00,#00,#90,#61,#82,#0a
db #c3,#0f,#4a,#c0,#20,#c0,#20,#00
db #40,#c1,#20,#0a,#1a,#87,#4a,#60
db #20,#4a,#20,#4a,#00,#00,#40,#85
db #80,#30,#00,#80,#00,#80,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#90,#40,#30,#80,#4a,#80
db #20,#80,#20,#00,#85,#40,#82,#20
db #92,#1a,#4a,#60,#20,#4a,#20,#4a
db #25,#90,#82,#20,#1a,#92,#00,#20
db #00,#80,#00,#00,#00,#00,#00,#00
db #00,#60,#61,#90,#20,#80,#00,#00
db #90,#40,#85,#10,#85,#10,#30,#25
db #20,#1a,#00,#00,#90,#25,#85,#c1
db #85,#61,#61,#40,#20,#80,#00,#00
db #00,#40,#00,#10,#00,#10,#30,#25
db #20,#1a,#00,#00,#25,#00,#82,#00
db #1a,#60,#00,#90,#00,#80,#00,#00
db #85,#90,#82,#20,#92,#92,#4a,#20
db #20,#80,#20,#00,#00,#40,#90,#20
db #30,#1a,#4a,#60,#20,#4a,#20,#4a
db #00,#40,#80,#80,#80,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#54,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#54,#54,#7c,#bc
db #00,#00,#00,#00,#2c,#14,#2c,#54
db #96,#3c,#d6,#5c,#7c,#a8,#a8,#00
db #00,#54,#54,#54,#fc,#7c,#7c,#7c
db #7c,#5c,#7c,#28,#00,#00,#14,#14
db #fc,#fc,#fc,#fc,#fc,#7c,#7c,#1c
db #bc,#54,#7c,#54,#fc,#fc,#fc,#fc
db #fc,#fc,#a8,#28,#00,#54,#00,#00
db #54,#7c,#3c,#fc,#00,#a8,#00,#00
db #00,#00,#00,#00,#00,#54,#54,#bc
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #54,#54,#7c,#a8,#00,#00,#00,#00
db #2c,#14,#2c,#54,#96,#3c,#d6,#5c
db #28,#a8,#00,#00,#00,#14,#00,#54
db #fc,#7c,#7c,#7c,#d6,#5c,#a8,#00
db #00,#00,#14,#54,#bc,#fc,#fc,#fc
db #7c,#5c,#5c,#28,#00,#00,#14,#14
db #bc,#bc,#5c,#fc,#5c,#fc,#5c,#96
db #00,#00,#00,#54,#fc,#fc,#3c,#7c
db #fc,#7c,#a8,#28,#ac,#54,#2c,#54
db #d6,#7c,#7c,#bc,#a8,#bc,#00,#00
db #00,#54,#00,#54,#54,#7c,#7c,#fc
db #00,#28,#00,#00,#00,#00,#00,#00
db #00,#14,#00,#08,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#54,#00,#a8,#00
db #00,#00,#00,#00,#14,#00,#54,#00
db #3c,#54,#5c,#7c,#a8,#00,#00,#00
db #14,#2c,#54,#2c,#7c,#96,#7c,#d6
db #5c,#28,#00,#00,#00,#00,#00,#00
db #fc,#54,#fc,#7c,#5c,#d6,#28,#00
db #00,#00,#14,#54,#bc,#fc,#7c,#fc
db #7c,#7c,#5c,#28,#00,#00,#14,#14
db #bc,#bc,#96,#1c,#5c,#7c,#5c,#96
db #00,#00,#00,#54,#a8,#fc,#fc,#7c
db #fc,#7c,#28,#28,#54,#00,#54,#00
db #7c,#54,#fc,#7c,#7c,#fc,#00,#00
db #54,#ac,#54,#2c,#3c,#d6,#d6,#7c
db #a8,#28,#00,#00,#00,#00,#00,#00
db #54,#14,#28,#5c,#00,#00,#00,#00
db #00,#00,#54,#a8,#00,#00,#00,#00
db #00,#00,#00,#00,#54,#54,#7c,#a8
db #00,#00,#00,#00,#2c,#14,#2c,#54
db #96,#3c,#5c,#7c,#28,#a8,#00,#00
db #00,#14,#00,#54,#54,#7c,#7c,#d6
db #5c,#7c,#00,#00,#00,#00,#00,#00
db #a8,#00,#a8,#54,#fc,#7c,#28,#a8
db #00,#00,#14,#54,#bc,#fc,#1c,#7c
db #5c,#7c,#d6,#08,#00,#00,#14,#14
db #bc,#bc,#1c,#96,#5c,#d6,#d6,#96
db #00,#00,#00,#54,#a8,#fc,#a8,#7c
db #fc,#7c,#28,#08,#00,#00,#00,#00
db #54,#00,#7c,#54,#5c,#7c,#00,#a8
db #ac,#14,#2c,#54,#96,#7c,#5c,#d6
db #28,#7c,#00,#00,#00,#14,#00,#54
db #54,#3c,#7c,#7c,#00,#a8,#00,#00
db #00,#00,#54,#a8,#00,#00,#00,#00
db #00,#00,#00,#00,#54,#00,#a8,#00
db #00,#00,#00,#00,#54,#00,#54,#00
db #3c,#54,#5c,#7c,#a8,#00,#00,#00
db #54,#ac,#54,#2c,#7c,#d6,#fc,#7c
db #7c,#28,#00,#00,#00,#00,#00,#00
db #a8,#54,#fc,#7c,#fc,#fc,#28,#a8
db #00,#00,#14,#54,#bc,#fc,#96,#7c
db #5c,#7c,#5c,#28,#00,#00,#14,#14
db #bc,#bc,#7c,#1c,#5c,#d6,#5c,#96
db #00,#00,#00,#54,#fc,#fc,#7c,#fc
db #5c,#7c,#28,#28,#14,#00,#54,#00
db #3c,#14,#5c,#d6,#7c,#7c,#00,#a8
db #14,#2c,#54,#2c,#7c,#d6,#7c,#7c
db #a8,#a8,#00,#00,#00,#00,#00,#00
db #54,#54,#a8,#fc,#00,#00,#00,#00
db #00,#00,#54,#a8,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #14,#54,#5c,#28,#00,#00,#00,#00
db #ac,#54,#2c,#54,#d6,#7c,#7c,#fc
db #a8,#28,#00,#00,#00,#54,#00,#54
db #fc,#7c,#3c,#ac,#fc,#fc,#a8,#00
db #00,#00,#14,#54,#bc,#fc,#5c,#7c
db #5c,#7c,#7c,#a8,#00,#00,#14,#14
db #fc,#bc,#7c,#fc,#d6,#d6,#7c,#1c
db #00,#00,#00,#54,#bc,#fc,#d6,#7c
db #7c,#5c,#a8,#a8,#2c,#14,#2c,#54
db #d6,#3c,#7c,#5c,#a8,#7c,#00,#00
db #00,#14,#00,#54,#54,#7c,#fc,#fc
db #00,#a8,#00,#00,#00,#00,#00,#00
db #00,#54,#00,#a8,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#54,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#54,#54,#1c,#e9
db #00,#00,#00,#00,#bc,#54,#7c,#54
db #7c,#7c,#fc,#7c,#fc,#a8,#a8,#00
db #00,#54,#14,#54,#fc,#fc,#7c,#fc
db #7c,#fc,#fc,#a8,#00,#00,#14,#14
db #bc,#bc,#5c,#d6,#7c,#5c,#fc,#3c
db #2c,#14,#2c,#54,#d6,#7c,#7c,#7c
db #fc,#7c,#a8,#a8,#00,#14,#00,#54
db #54,#7c,#fc,#fc,#00,#a8,#00,#00
db #00,#00,#00,#00,#00,#54,#54,#bc
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#e9,#54,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#54,#a8,#1c
db #00,#00,#00,#00,#00,#00,#54,#00
db #bc,#54,#7c,#fc,#fc,#00,#a8,#00
db #bc,#54,#fc,#54,#3c,#bc,#5c,#d6
db #5c,#d6,#7c,#a8,#bc,#2c,#fc,#2c
db #7c,#d6,#7c,#7c,#7c,#7c,#7c,#1c
db #00,#54,#54,#54,#fc,#fc,#fc,#7c
db #fc,#fc,#a8,#a8,#00,#00,#00,#00
db #00,#54,#a8,#fc,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#54,#bc,#3c
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#54,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#b3,#00,#88,#00,#44,#00
db #00,#00,#00,#00,#00,#00,#88,#00
db #99,#f3,#e6,#f3,#44,#00,#00,#00
db #f3,#00,#e6,#a2,#cc,#c9,#cc,#66
db #d9,#51,#88,#00,#44,#44,#cc,#cc
db #cc,#e6,#cc,#d9,#cc,#cc,#99,#cc
db #b3,#d9,#d9,#cc,#f3,#e6,#f3,#d9
db #e6,#cc,#73,#f3,#b3,#63,#d9,#99
db #cc,#d3,#cc,#e3,#e6,#66,#73,#93
db #44,#cc,#cc,#cc,#d9,#cc,#e6,#cc
db #cc,#cc,#99,#d9,#44,#b3,#e6,#e6
db #b3,#e3,#f3,#73,#d9,#d9,#88,#d9
db #00,#00,#88,#a2,#cc,#d9,#cc,#e6
db #44,#51,#00,#00,#00,#00,#b3,#00
db #a2,#cc,#51,#cc,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#d9,#00
db #d9,#a2,#e6,#51,#00,#00,#00,#00
db #00,#00,#88,#a2,#e6,#cc,#d9,#cc
db #44,#51,#00,#00,#f3,#44,#cc,#e6
db #cc,#cc,#cc,#cc,#cc,#d9,#cc,#88
db #e3,#51,#d9,#cc,#d9,#e6,#e6,#d9
db #e6,#cc,#d3,#b3,#cc,#66,#cc,#99
db #d9,#cc,#e6,#cc,#cc,#66,#d9,#99
db #44,#b3,#e6,#e6,#e3,#e3,#73,#d3
db #d9,#d9,#d9,#99,#00,#44,#88,#e6
db #d9,#99,#e6,#e6,#44,#d9,#00,#88
db #00,#00,#b3,#88,#c6,#cc,#99,#cc
db #00,#44,#00,#00,#00,#00,#00,#00
db #00,#a2,#00,#51,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#d9,#88,#e6,#44
db #00,#00,#00,#00,#44,#00,#e6,#88
db #e6,#cc,#d9,#cc,#d9,#44,#88,#00
db #d9,#44,#d9,#cc,#d9,#cc,#e6,#cc
db #e6,#cc,#e3,#cc,#cc,#b3,#e6,#e6
db #e3,#e3,#73,#d3,#d9,#d9,#99,#d9
db #44,#44,#cc,#e6,#d9,#99,#e6,#e6
db #cc,#d9,#88,#d9,#00,#00,#b3,#88
db #c6,#e6,#99,#d9,#00,#44,#00,#00
db #00,#00,#00,#00,#00,#a2,#00,#51
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#88,#00
db #cc,#cc,#cc,#cc,#44,#00,#00,#00
db #cc,#44,#e6,#cc,#e3,#f3,#73,#f3
db #d9,#cc,#d9,#88,#cc,#b3,#cc,#e6
db #f3,#99,#f3,#e6,#cc,#d9,#d9,#99
db #00,#44,#88,#b3,#e6,#c6,#d9,#99
db #44,#cc,#00,#88,#00,#00,#00,#00
db #00,#cc,#00,#cc,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#cc,#88,#cc,#44
db #00,#00,#00,#00,#44,#00,#f3,#88
db #63,#d3,#d3,#b3,#d9,#44,#88,#00
db #b3,#cc,#cc,#e6,#d9,#99,#e6,#e6
db #cc,#d9,#c9,#d9,#d9,#e6,#d9,#cc
db #cc,#cc,#cc,#cc,#e6,#cc,#b3,#d9
db #44,#cc,#cc,#cc,#cc,#cc,#cc,#cc
db #cc,#cc,#88,#cc,#00,#00,#00,#88
db #d9,#cc,#e6,#cc,#00,#44,#00,#00
db #00,#00,#00,#00,#00,#88,#00,#44
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#b3,#00
db #c6,#a2,#99,#51,#00,#00,#00,#00
db #00,#00,#88,#88,#e3,#f3,#d3,#f3
db #44,#44,#00,#00,#44,#44,#e6,#e6
db #99,#c9,#e6,#66,#d9,#d9,#d9,#88
db #cc,#b3,#cc,#cc,#cc,#d9,#cc,#e6
db #cc,#cc,#d9,#99,#e3,#66,#d9,#99
db #d9,#cc,#e6,#cc,#e6,#66,#d3,#99
db #44,#d9,#cc,#cc,#cc,#e6,#cc,#d9
db #cc,#cc,#cc,#b3,#00,#f3,#88,#e6
db #e6,#cc,#d9,#cc,#44,#d9,#00,#88
db #00,#00,#f3,#a2,#d9,#cc,#e6,#cc
db #00,#51,#00,#00,#00,#00,#00,#00
db #00,#a2,#00,#51,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#b3,#00,#a2,#00,#51,#00
db #00,#00,#00,#00,#00,#00,#88,#00
db #f3,#66,#f3,#99,#44,#00,#00,#00
db #44,#00,#e6,#a2,#99,#e3,#e6,#73
db #d9,#51,#d9,#00,#44,#b3,#cc,#cc
db #cc,#d9,#cc,#e6,#cc,#cc,#d9,#99
db #b3,#cc,#d9,#cc,#cc,#cc,#cc,#cc
db #e6,#cc,#73,#cc,#b3,#63,#d9,#99
db #f3,#d3,#f3,#e3,#e6,#66,#73,#93
db #44,#d9,#cc,#cc,#cc,#e6,#cc,#d9
db #cc,#cc,#d9,#e6,#b3,#44,#e6,#cc
db #cc,#d9,#cc,#e6,#d9,#cc,#cc,#99
db #00,#00,#88,#a2,#99,#d9,#e6,#e6
db #44,#51,#00,#00,#00,#00,#d9,#00
db #88,#f3,#44,#f3,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#b3,#cc,#a2,#cc,#51
db #00,#00,#00,#00,#00,#00,#a2,#88
db #b3,#d9,#f3,#e6,#51,#44,#00,#00
db #44,#b3,#cc,#e6,#d9,#e3,#e6,#73
db #cc,#d9,#d9,#88,#44,#00,#88,#00
db #88,#00,#44,#00,#44,#00,#d9,#11
db #b3,#d9,#d9,#cc,#f3,#e6,#f3,#d9
db #e6,#cc,#73,#e6,#b3,#63,#d9,#99
db #f3,#d3,#f3,#e3,#e6,#66,#d3,#93
db #44,#d9,#88,#cc,#88,#e6,#44,#d9
db #44,#cc,#d9,#e6,#44,#00,#cc,#00
db #d9,#00,#e6,#00,#cc,#00,#d9,#11
db #00,#b3,#a2,#e6,#b3,#e3,#f3,#73
db #51,#d9,#00,#88,#00,#00,#00,#88
db #cc,#d9,#cc,#e6,#00,#44,#00,#00
db #00,#b3,#a2,#51,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#c0,#c0,#c0,#80
db #00,#00,#00,#00,#c0,#00,#2e,#95
db #3f,#3f,#2e,#3f,#6a,#80,#80,#00
db #c1,#95,#2e,#c3,#c0,#c0,#84,#c1
db #6b,#97,#80,#80,#95,#84,#c0,#3f
db #c0,#c0,#c0,#95,#95,#2e,#80,#80
db #c0,#c0,#c0,#c0,#c0,#c0,#c0,#c0
db #c0,#c0,#80,#80,#00,#00,#15,#c0
db #c0,#6a,#95,#6a,#00,#80,#00,#00
db #00,#00,#00,#00,#00,#6a,#00,#2a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#40,#00
db #c0,#c0,#c0,#80,#00,#00,#00,#00
db #00,#00,#2e,#95,#3f,#3f,#2e,#3f
db #2a,#80,#00,#00,#95,#40,#86,#49
db #c0,#c0,#84,#c1,#97,#48,#80,#00
db #2e,#84,#6a,#1d,#95,#c0,#c0,#95
db #2e,#0c,#2a,#80,#84,#3f,#c2,#c0
db #97,#95,#c2,#c0,#86,#95,#80,#2a
db #c0,#95,#c0,#6a,#c0,#6a,#c0,#6a
db #c0,#3f,#80,#80,#00,#15,#c0,#c0
db #6a,#6a,#6a,#6a,#80,#95,#00,#00
db #00,#00,#15,#6a,#6a,#c0,#3f,#c0
db #00,#2a,#00,#00,#00,#00,#00,#00
db #00,#1d,#00,#08,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#c0,#00,#80,#00
db #00,#00,#00,#00,#00,#00,#95,#40
db #3f,#c0,#3f,#c0,#80,#00,#00,#00
db #40,#00,#49,#2e,#c0,#3f,#c1,#2e
db #48,#2a,#00,#00,#84,#15,#1d,#86
db #c0,#c0,#95,#84,#0c,#97,#80,#00
db #3f,#84,#6a,#3f,#3f,#c0,#6a,#95
db #3f,#2e,#2a,#80,#2e,#6b,#97,#6b
db #97,#1d,#97,#49,#86,#6b,#2a,#2a
db #95,#95,#c0,#6a,#80,#6a,#c0,#6a
db #95,#3f,#80,#80,#40,#15,#6a,#c0
db #c0,#6a,#c0,#6a,#6a,#95,#00,#00
db #00,#00,#95,#2e,#97,#6a,#97,#2e
db #80,#2a,#00,#00,#00,#00,#00,#15
db #6a,#1d,#2a,#1d,#00,#00,#00,#00
db #00,#00,#c0,#80,#00,#00,#00,#00
db #00,#00,#40,#00,#6a,#c0,#6a,#80
db #00,#00,#00,#00,#00,#00,#2e,#95
db #3f,#3f,#2e,#3f,#2a,#80,#00,#00
db #15,#40,#1d,#6b,#6a,#6a,#3f,#6b
db #1d,#6a,#00,#00,#84,#84,#80,#6a
db #80,#00,#80,#40,#84,#2e,#80,#80
db #6b,#6b,#1d,#6a,#1d,#6a,#1d,#6a
db #49,#6b,#2a,#2a,#6b,#6b,#1d,#c3
db #1d,#97,#1d,#c3,#49,#c3,#2a,#2a
db #84,#6b,#80,#6a,#80,#6a,#80,#6a
db #84,#6b,#80,#2a,#15,#84,#1d,#6a
db #6a,#00,#3f,#40,#1d,#2e,#00,#80
db #00,#40,#2e,#6b,#3f,#6a,#2e,#6b
db #2a,#6a,#00,#00,#00,#00,#40,#95
db #6a,#3f,#6a,#3f,#00,#80,#00,#00
db #00,#00,#c0,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#c0,#00,#80,#00
db #00,#00,#00,#00,#00,#00,#95,#15
db #3f,#c0,#3f,#95,#80,#00,#00,#00
db #40,#00,#6a,#2e,#c0,#c0,#c0,#84
db #6a,#2a,#00,#00,#95,#95,#c0,#c0
db #80,#6a,#c0,#6a,#95,#95,#80,#80
db #6b,#2e,#1d,#6a,#97,#6a,#97,#6a
db #49,#2e,#2a,#2a,#6b,#6b,#c2,#c3
db #3f,#1d,#6a,#49,#49,#c3,#2a,#2a
db #95,#84,#1d,#6a,#c0,#c0,#95,#c0
db #1d,#2e,#80,#80,#40,#95,#2e,#6b
db #3f,#3f,#2e,#6b,#6a,#3f,#00,#80
db #00,#00,#c0,#95,#c0,#c0,#c0,#95
db #80,#80,#00,#00,#00,#00,#00,#40
db #c0,#c0,#80,#c0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#15,#00
db #3f,#c0,#3f,#80,#00,#00,#00,#00
db #00,#00,#c0,#6a,#6a,#c0,#6a,#c0
db #80,#2a,#00,#00,#95,#40,#c0,#c0
db #c0,#6a,#c0,#6a,#95,#c0,#80,#00
db #2e,#95,#1d,#6a,#1d,#6a,#1d,#6a
db #0c,#3f,#2a,#80,#95,#2e,#97,#97
db #c0,#95,#95,#95,#97,#86,#80,#2a
db #c0,#95,#6b,#0c,#3f,#c0,#6b,#84
db #6a,#1d,#80,#80,#00,#40,#95,#2e
db #c0,#3f,#95,#2e,#80,#6a,#00,#00
db #00,#00,#40,#c0,#c0,#c0,#c0,#c0
db #00,#80,#00,#00,#00,#00,#00,#00
db #00,#c0,#00,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#15,#00,#c0,#6a,#95,#2a
db #00,#00,#00,#00,#c0,#00,#c0,#c0
db #c0,#6a,#c0,#6a,#c0,#80,#80,#00
db #c1,#95,#3f,#c0,#c0,#c0,#95,#c0
db #6b,#95,#80,#80,#95,#84,#6b,#86
db #3f,#3f,#6b,#2e,#3f,#86,#80,#80
db #c0,#c0,#95,#2e,#c0,#c0,#95,#84
db #c0,#6a,#80,#80,#00,#00,#40,#c0
db #c0,#c0,#c0,#c0,#00,#80,#00,#00
db #00,#00,#00,#00,#00,#c0,#00,#80
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#c0,#00,#95,#40
db #3f,#c0,#3f,#c0,#c0,#00,#80,#00
db #c1,#95,#c3,#86,#3f,#3f,#6b,#2e
db #c3,#97,#80,#80,#95,#84,#3f,#2e
db #6a,#6a,#3f,#2e,#3f,#2e,#80,#80
db #c0,#c0,#c0,#95,#c0,#3f,#c0,#3f
db #c0,#c0,#80,#80,#00,#00,#00,#40
db #00,#c0,#00,#c0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#d0,#40,#2e,#c0
db #7a,#00,#80,#00,#00,#00,#6a,#15
db #d0,#0c,#e0,#1d,#d0,#e0,#7a,#40
db #a0,#50,#b5,#d0,#58,#e0,#2e,#d0
db #80,#7a,#00,#80,#00,#80,#00,#80
db #40,#00,#b5,#d0,#80,#00,#80,#00
db #00,#00,#40,#00,#40,#7a,#0c,#2e
db #7a,#e0,#00,#b5,#00,#00,#40,#00
db #40,#00,#0c,#a4,#7a,#d0,#00,#00
db #00,#00,#00,#00,#40,#7a,#b5,#2e
db #80,#e0,#80,#b5,#a0,#80,#b5,#80
db #58,#00,#2e,#d0,#80,#00,#00,#00
db #00,#50,#6a,#d0,#d0,#e0,#e0,#d0
db #d0,#7a,#7a,#80,#00,#00,#00,#15
db #d0,#0c,#2e,#1d,#7a,#e0,#80,#40
db #00,#00,#40,#c0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #d0,#40,#0c,#c0,#7a,#00,#80,#00
db #00,#00,#6a,#15,#d0,#0c,#e0,#1d
db #d0,#e0,#7a,#40,#80,#50,#80,#d0
db #00,#e0,#d0,#d0,#00,#7a,#00,#80
db #00,#00,#00,#00,#7a,#40,#0c,#a4
db #e0,#80,#b5,#80,#00,#00,#00,#40
db #f0,#40,#f0,#3f,#e0,#58,#d0,#00
db #80,#00,#80,#00,#00,#40,#c0,#c0
db #00,#80,#00,#80,#00,#40,#c0,#c0
db #d0,#e0,#e0,#d0,#d0,#7a,#7a,#80
db #00,#00,#00,#50,#c0,#f0,#f0,#f0
db #f0,#e0,#80,#40,#00,#00,#00,#00
db #00,#40,#00,#c0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#c0,#00
db #00,#00,#00,#00,#50,#00,#2e,#50
db #58,#2e,#1d,#86,#f0,#7a,#7a,#80
db #00,#80,#00,#80,#d0,#00,#3f,#f0
db #a0,#00,#15,#00,#00,#00,#00,#40
db #c0,#f0,#c0,#c0,#80,#e0,#00,#80
db #40,#80,#c0,#80,#c0,#00,#c0,#c0
db #c0,#00,#c0,#00,#00,#00,#00,#00
db #00,#c0,#00,#c0,#00,#c0,#00,#80
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#d0,#00,#b5,#40,#0c,#c0
db #7a,#c0,#80,#00,#40,#d0,#d0,#2e
db #b5,#49,#0c,#c3,#7a,#86,#80,#7a
db #00,#00,#00,#00,#00,#40,#00,#c0
db #00,#c0,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#c0,#00
db #c0,#c0,#c0,#c0,#c0,#c0,#c0,#80
db #00,#80,#00,#80,#c0,#00,#f0,#c0
db #80,#00,#00,#00,#00,#00,#00,#40
db #d0,#f0,#3f,#c0,#a0,#e0,#15,#80
db #50,#80,#2e,#80,#f0,#00,#0c,#f0
db #f0,#00,#7a,#00,#00,#00,#00,#50
db #40,#2e,#c0,#86,#00,#7a,#00,#80
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #c0,#40,#f0,#c0,#f0,#00,#80,#00
db #00,#00,#c0,#50,#d0,#f0,#e0,#f0
db #d0,#e0,#7a,#40,#80,#40,#80,#c0
db #00,#e0,#c0,#d0,#00,#7a,#00,#80
db #00,#00,#00,#00,#f0,#40,#f0,#c0
db #e0,#80,#d0,#80,#00,#00,#00,#40
db #7a,#40,#2e,#0c,#e0,#7a,#b5,#00
db #80,#00,#80,#00,#00,#40,#d0,#b5
db #00,#80,#00,#80,#00,#50,#6a,#d0
db #d0,#e0,#e0,#d0,#d0,#7a,#7a,#80
db #00,#00,#00,#15,#d0,#0c,#2e,#1d
db #7a,#e0,#80,#40,#00,#00,#00,#00
db #00,#40,#00,#c0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#c5,#40,#cb,#4d
db #8a,#00,#00,#00,#00,#00,#48,#41
db #c5,#86,#cf,#cf,#8e,#c7,#00,#00
db #8a,#45,#8e,#c5,#c7,#ca,#c0,#c5
db #c0,#cf,#80,#80,#00,#80,#00,#80
db #40,#00,#4d,#ca,#c1,#c5,#c5,#c0
db #00,#00,#40,#00,#40,#4d,#8e,#cf
db #c5,#8e,#c5,#8e,#00,#00,#40,#00
db #40,#00,#8e,#c1,#c5,#04,#c5,#40
db #00,#00,#00,#00,#40,#4d,#4d,#cf
db #84,#cb,#c5,#8e,#8a,#80,#8e,#80
db #c7,#00,#c0,#ca,#c0,#c5,#80,#c0
db #00,#45,#48,#c5,#c5,#ca,#cf,#c5
db #8e,#cf,#00,#80,#00,#00,#00,#41
db #c5,#86,#cb,#cf,#8a,#c7,#00,#00
db #00,#00,#40,#4d,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #c5,#40,#c3,#00,#8a,#00,#00,#00
db #00,#00,#48,#41,#c5,#c3,#c5,#0c
db #8e,#c7,#8a,#00,#80,#45,#80,#c5
db #00,#ca,#4d,#c0,#c5,#c0,#ca,#80
db #00,#00,#00,#00,#4d,#40,#cb,#cf
db #84,#cb,#8e,#cf,#00,#00,#00,#40
db #cf,#40,#8e,#c1,#84,#45,#8e,#40
db #80,#00,#80,#00,#00,#40,#4d,#cf
db #84,#cf,#c0,#cf,#00,#40,#c0,#c0
db #c5,#ca,#c5,#c0,#cf,#c0,#8a,#80
db #00,#00,#00,#45,#c0,#cf,#cf,#cf
db #8a,#cf,#00,#00,#00,#00,#00,#00
db #00,#40,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#00,#00
db #00,#00,#00,#00,#45,#00,#49,#45
db #cf,#86,#c0,#cf,#c5,#ca,#80,#00
db #00,#80,#00,#80,#c5,#00,#cb,#c7
db #84,#c0,#c5,#c0,#00,#00,#00,#40
db #c0,#cf,#4d,#cb,#c5,#c0,#c5,#84
db #40,#80,#c0,#80,#c0,#00,#cf,#c0
db #ca,#c0,#00,#c0,#00,#00,#00,#00
db #00,#c0,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#c5,#00,#8e,#40,#c5,#00
db #c5,#00,#cf,#c0,#40,#c5,#c5,#49
db #8e,#c3,#c5,#86,#c5,#cf,#cf,#8e
db #00,#00,#00,#00,#00,#40,#00,#00
db #00,#00,#00,#c0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#c0,#00
db #c0,#c0,#cf,#00,#ca,#00,#00,#00
db #00,#80,#00,#80,#c0,#00,#4d,#c0
db #c5,#c0,#c5,#c0,#00,#00,#00,#40
db #c5,#cf,#cb,#cb,#84,#c0,#c5,#84
db #45,#80,#49,#80,#cf,#00,#c0,#c7
db #c5,#c0,#80,#c0,#00,#00,#00,#45
db #40,#86,#00,#cf,#00,#ca,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #c0,#40,#cf,#00,#80,#00,#00,#00
db #00,#00,#c0,#45,#c5,#cf,#c0,#c5
db #cf,#ca,#80,#00,#80,#40,#80,#c0
db #00,#ca,#4d,#c0,#84,#c0,#c0,#80
db #00,#00,#00,#00,#cf,#40,#8e,#cf
db #84,#cf,#8e,#cf,#00,#00,#00,#40
db #4d,#40,#8e,#c1,#c1,#45,#8e,#40
db #80,#00,#80,#00,#00,#40,#4d,#cf
db #c5,#8e,#ca,#cf,#00,#45,#48,#c5
db #c5,#ca,#c0,#c0,#cf,#c0,#80,#80
db #00,#00,#00,#04,#c5,#c3,#c3,#c5
db #80,#48,#00,#00,#00,#00,#00,#00
db #00,#40,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #44,#00,#f3,#cc,#66,#a2,#99,#51
db #f3,#cc,#88,#00,#e3,#d9,#cc,#c3
db #d9,#d3,#e6,#e3,#cc,#c3,#d3,#e6
db #00,#66,#11,#00,#f3,#63,#f3,#93
db #22,#00,#00,#99,#00,#00,#cc,#44
db #00,#cc,#00,#cc,#cc,#88,#00,#00
db #44,#44,#44,#88,#b3,#d9,#73,#e6
db #88,#44,#88,#88,#44,#44,#00,#44
db #cc,#d9,#cc,#e6,#00,#88,#88,#88
db #00,#44,#d9,#88,#44,#00,#88,#00
db #e6,#44,#00,#88,#00,#00,#11,#44
db #f3,#d9,#f3,#e6,#22,#88,#00,#00
db #e3,#66,#cc,#00,#d9,#63,#e6,#93
db #cc,#00,#d3,#99,#44,#d9,#f3,#c3
db #66,#d3,#99,#e3,#f3,#c3,#88,#e6
db #00,#cc,#a2,#51,#cc,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#cc,#00
db #e6,#88,#d9,#44,#cc,#00,#00,#00
db #d9,#44,#88,#f3,#00,#73,#00,#b3
db #44,#f3,#e6,#88,#88,#e6,#cc,#44
db #00,#cc,#00,#cc,#cc,#88,#44,#d9
db #44,#44,#44,#88,#b3,#d9,#73,#e6
db #88,#44,#88,#88,#44,#44,#00,#44
db #cc,#d9,#cc,#e6,#00,#88,#88,#88
db #22,#44,#d9,#88,#44,#00,#88,#00
db #e6,#44,#11,#88,#d9,#e3,#c3,#99
db #d3,#f3,#e3,#f3,#c3,#66,#e6,#d3
db #00,#44,#cc,#f3,#e6,#73,#d9,#b3
db #cc,#f3,#00,#88,#00,#00,#00,#00
db #00,#88,#00,#44,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#88,#00,#44,#00
db #00,#00,#00,#00,#cc,#44,#cc,#cc
db #00,#cc,#00,#cc,#cc,#cc,#cc,#88
db #cc,#e6,#44,#88,#b3,#d9,#73,#e6
db #88,#44,#cc,#d9,#73,#cc,#b3,#44
db #c3,#d9,#c3,#e6,#73,#88,#b3,#cc
db #d9,#b3,#f3,#c3,#73,#d3,#b3,#e3
db #f3,#c3,#e6,#73,#00,#44,#00,#cc
db #88,#e6,#44,#d9,#00,#cc,#00,#88
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#cc,#44
db #00,#cc,#00,#cc,#cc,#88,#00,#00
db #d9,#44,#f3,#88,#73,#d9,#b3,#e6
db #f3,#44,#e6,#88,#d9,#99,#f3,#c3
db #73,#c3,#b3,#c3,#f3,#c3,#e6,#66
db #00,#44,#d9,#88,#44,#00,#88,#00
db #e6,#44,#00,#88,#00,#00,#00,#44
db #00,#d9,#00,#e6,#00,#88,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#88,#00,#44,#00
db #00,#00,#00,#00,#d9,#44,#f3,#cc
db #73,#e6,#b3,#d9,#f3,#cc,#e6,#88
db #73,#b3,#b3,#c3,#c3,#d3,#c3,#e3
db #73,#c3,#b3,#73,#cc,#cc,#00,#44
db #cc,#d9,#cc,#e6,#00,#88,#cc,#cc
db #cc,#e6,#d9,#88,#44,#00,#88,#00
db #e6,#44,#cc,#d9,#00,#44,#00,#cc
db #88,#d9,#44,#e6,#00,#cc,#00,#88
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#cc,#00
db #e6,#88,#d9,#44,#cc,#00,#00,#00
db #d9,#44,#c3,#f3,#c6,#73,#c9,#b3
db #c3,#f3,#e6,#88,#22,#e3,#cc,#99
db #00,#f3,#00,#f3,#cc,#66,#11,#d3
db #44,#44,#44,#88,#b3,#d9,#73,#e6
db #88,#44,#88,#88,#44,#44,#00,#44
db #cc,#d9,#cc,#e6,#00,#88,#88,#88
db #88,#44,#d9,#88,#44,#00,#88,#00
db #e6,#44,#44,#88,#d9,#e6,#88,#44
db #00,#d9,#00,#e6,#44,#88,#e6,#d9
db #00,#44,#cc,#f3,#e6,#73,#d9,#b3
db #cc,#f3,#00,#88,#00,#00,#00,#00
db #00,#88,#00,#44,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BANK 7
org #4000
scroll_step equ #11c


Copy_Buffer
; enter with hl pointing to target screen column address to write
    ld bc,#4f60 ; start position of 160 byte buffer for current column to write to screen
    ld de,80 - #2000 ; last pixel line written is line 5, +#2000 from line 1
                     ; so next char lines pixel line 1 is 80-#2000 away
    ld a,20 ; screen is 20 chars high
CopyColLp
    ex af,af''
    ld a,(bc):inc c
    ld (hl),a:set 3,h ; copy line 1
    ld a,(bc):inc c
    ld (hl),a:set 4,h ; copy line 2
    ld a,(bc):inc c
    ld (hl),a:res 3,h ; copy line 4
    ld a,(bc):inc c
    ld (hl),a:set 5,h ; copy line 3
    ld a,(bc):inc c
    ld (hl),a:set 3,h ; copy line 7
    ld a,(bc):inc c
    ld (hl),a:res 4,h ; copy line 8
    ld a,(bc):inc c
    ld (hl),a:res 3,h ; copy line 6
    ld a,(bc):inc c
    ld (hl),a ;         copy line 5
    add hl,de:res 3,h ; go to top of next character line
    ex af,af''
    dec a
    jr nz,CopyColLp
    ret

Fill_Buffer
    ld a,(scroll_step)
    dec a ; get scroll step # dec  Was incremented by interrupt prior to first frame
    ld ix,LowCharWrite
    bit 0,a ; determine whether to use right or left pixels this frame
    jr nz,SkipHighCharWriteSet
    ld ix,HighCharWrite
SkipHighCharWriteSet
    ld c,a ; save scroll_step
    and #c
    add #50 ; character columns in tiles start at #5000, #5400, #5800 # #5c00
    ld (FillBufTileLp+1),a ; write high byte to loop later in routine
    ld a,c ; retrieve scroll step
    exx
    ld de,#4f60 ; set de'' to start of vertical column buffer
    ld h,#60 ; depending on stage, want left or right byte of each character
    bit 1,a
    jr z,FillBufFirstHalf ; left bytes start at #6000
    set 3,h ; right bytes start at #6800
FillBufFirstHalf
    ld a,h
    ld (FillBufCharHalf+1),a ; write high byte to loop later in routine
    exx
    ld de,(MapPointer) ; get pointer to tile column to display
    ld b,5 ; each column is 5 tiles
FillBufTileLp
    ld h,#50 ; this high byte tile pointer was pre determined above
    ld a,(de) ; get tile number from tile pointer
    ld l,a ; put tile in l so hl points to character list in tile
    ld c,4 ; each tile is 4 characters high
FillBufCharLp
    ld a,(hl) ; get character from tile pointer
    exx ; switch to alternate registers
    ld l,a ; put character number in low byte of tile pointer
FillBufCharHalf
    ld h,#60 ; this high byte char pointer was pre determined above
    jp (ix) ; shift left or right pixel of character bytes into the buffer
FillBufCharRet
    exx
    inc h ; point to next character in tile
    dec c
    jr nz,FillBufCharLp ; do all 4 characters of tile
    inc de ; point to next tile
    djnz FillBufTileLp ; do all 5 characters of screen column
    ret

LowCharWrite
; this routine shifts the right pixel of a given character byte into the buffer
    ld c,85 ; right pixel mask
    ld a,4 ; each character is a column of 8 bytes, handled in pairs
LowChrWrlp
    ex af,af'' ;1 - save counter
    ld a,(hl) ;2 - get right pixel from byte
    and c   ;1 - mask out left pixel
    ld b,a    ;1 - save result in b
    ld a,(de) ;2 - get current byte from buffer
    and c   ;1 - mask out left pixel
    rlca      ;1 - shift previously right pixel to left
    or b    ;1 - add new right pixel to buffer byte
    ld (de),a ;2 - write back to buffer
    inc h     ;1 - point to next byte in character
    inc e     ;1 - and next byte in buffer

    ld a,(hl) ;2 - get byte with next right pixel
    rrca      ;1 - even bytes stored swapped, so shift left pixel to right
    and c   ;1 - and mask out left pixel data
    ld b,a    ;1 - store result in b
    ld a,(de) ;2 - get current byte from buffer
    and c   ;1 - mask out left pixel
    rlca      ;1 - shift previously right pixel to left
    or b    ;1 - add new right pixel to buffer byte
    ld (de),a ;2 - write back to buffer
    inc h     ;1 - point to next byte in character
    inc e     ;1 - and next byte in buffer

    ex af,af'' ;1 - get counter back
    dec a     ;1 - repeat for all 4 byte pairs
    jr nz,LowChrWrlp  ;2/3 - 33*4-1 = 131 per character, so around 41 scan lines for a whole column
    jp FillBufCharRet ; return to main loop

HighCharWrite
; this routine shifts the left pixel of a given character byte into the buffer
    ld c,85 ; right pixel mask
    ld a,4 ; each character is a column of 8 bytes, handled in pairs
HighChrWrlp
    ex af,af'' ;1 - save counter
    ld a,(hl) ;2 - get left pixel from byte
    rrca      ;1 - shift the left pixel to the right of the byte
    and c   ;1 - and mask out left pixel data
    ld b,a    ;1 - save result in b
    ld a,(de) ;2 - get current byte from buffer
    and c   ;1 - mask out left pixel
    rlca      ;1 - shift previously right pixel to left
    or b    ;1 - add new right pixel to buffer byte
    ld (de),a ;2 - write back to buffer
    inc h     ;1 - point to next byte in character
    inc e     ;1 - and next byte in buffer

    ld a,(hl) ;2 - get byte with next left pixel
    and c   ;1 - even bytes are swapped, left pixel is already right, so mask out left pixel
    ld b,a    ;1 - save result in b
    ld a,(de) ;2 - get current byte from buffer
    and c   ;1 - mask out left pixel
    rlca      ;1 - shift previously right pixel to left
    or b    ;1 - add new right pixel to buffer byte
    ld (de),a ;2 - write back to buffer
    inc h     ;1 - point to next byte in character
    inc e     ;1 - and next byte in buffer

    ex af,af'' ;1 - get counter back
    dec a     ;1 - repeat for all 4 byte pairs
    jr nz,HighChrWrlp  ;2/3 - 33*4-1 = 131 per character, so around 41 scan lines for a whole column
    jp FillBufCharRet ; return to main loop

ProcessMapPointer
    ld a,(scroll_step)
    dec a ; interupt has progressed scroll_step to 1 for first frame, so do test on scroll_step minus one
    and #f ; want new column of tiles every 4 characters, or 16 pixels
    ret nz
    ld hl,(MapPointer) ; if scroll_step-1 = 0, move to next row of tiles
    ld de,5 ; there are 5 tiles per column
    add hl,de
    ld a,(hl) ; for testing purposes, allowed loop of level data
    cp 255 ; if tile 255 is first tile
    jr nz,DontResetMapPtr
    ld hl,Map+40 ; reset the map pointer
DontResetMapPtr
    ld (MapPointer),hl ; write tile pointer back
    ret



MapPointer
    defw Map+40
; the C64 level map data, formatted for use on CPC

Map
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,50,0,0
    defb 0,207,18,0,0,0,11,18,0,0,0,12,110,196,0,0
    defb 116,18,195,0,0,116,189,63,0,0,172,143,0,0,0,127
    defb 37,0,0,66,113,67,0,0,0,80,50,0,0,0,34,48
    defb 0,0,0,33,49,0,0,0,35,18,63,0,0,80,49,0
    defb 0,0,36,175,159,0,0,154,79,132,0,0,155,16,103,0
    defb 0,155,18,0,0,0,155,49,0,0,0,156,18,63,0,0
    defb 0,49,0,0,0,170,51,0,0,0,0,0,0,0,0,106
    defb 90,0,0,0,108,92,0,0,0,108,92,0,0,0,108,92
    defb 0,0,0,107,91,0,0,0,93,0,0,0,57,97,110,0
    defb 0,99,94,110,26,0,100,98,78,0,0,117,96,78,26,0
    defb 101,94,78,0,0,58,97,78,0,0,0,95,19,0,0,0
    defb 0,8,0,0,0,145,8,0,0,0,0,103,0,0,0,145
    defb 0,0,0,0,170,0,0,0,0,66,0,0,0,145,126,149
    defb 143,0,127,167,141,0,0,0,125,168,0,0,0,152,67,0
    defb 0,0,66,168,0,0,0,152,113,0,0,0,97,130,0,129
    defb 0,130,102,0,130,0,86,50,0,0,0,34,110,0,0,0
    defb 94,78,0,0,0,77,78,0,0,0,77,78,0,0,86,77
    defb 78,0,0,9,77,79,151,0,71,77,78,0,0,185,77,78
    defb 0,0,52,77,78,0,0,0,77,78,147,0,52,77,78,97
    defb 0,113,77,97,147,0,146,113,130,0,0,0,130,0,0,0
    defb 0,0,109,0,0,0,93,113,0,0,0,98,134,0,0,0
    defb 94,132,0,0,25,97,109,209,0,0,96,16,54,0,154,94
    defb 114,135,0,155,98,112,135,0,155,97,110,55,0,155,94,112
    defb 56,0,156,96,114,210,0,0,95,110,0,0,0,99,114,209
    defb 0,0,116,110,61,0,0,100,110,49,0,0,101,112,62,0
    defb 0,70,113,0,0,0,119,114,0,0,0,72,110,0,0,0
    defb 0,112,0,0,0,181,113,0,0,0,180,111,0,0,0,181
    defb 0,0,0,0,180,97,147,0,146,113,78,0,0,0,77,97
    defb 132,0,116,113,78,0,0,0,77,97,67,0,80,113,78,0
    defb 0,0,77,97,132,0,116,113,78,0,0,0,77,97,147,0
    defb 146,113,90,0,0,0,74,79,59,0,57,79,16,17,0,1
    defb 16,110,18,0,33,94,125,18,0,32,141,150,18,0,2,151
    defb 0,130,0,130,0,165,0,0,0,163,166,0,0,0,164,0
    defb 129,0,129,0,150,48,0,33,151,125,49,0,2,141,113,18
    defb 0,32,95,16,19,0,3,16,79,60,0,58,79,91,0,0
    defb 0,75,80,37,0,0,157,37,0,0,0,1,0,0,0,157
    defb 173,0,0,0,1,149,0,0,157,173,149,0,0,1,20,68
    defb 0,0,97,113,79,0,154,32,69,64,0,155,2,81,169,0
    defb 156,32,69,65,0,0,97,113,79,0,0,3,94,93,0,0
    defb 158,174,96,0,0,154,32,94,0,0,156,33,96,0,0,0
    defb 2,95,0,0,0,3,16,0,0,0,158,174,59,0,0,0
    defb 3,17,0,0,0,58,175,159,0,0,0,174,17,0,0,0
    defb 3,175,59,0,154,58,174,17,0,155,26,3,49,0,155,28
    defb 9,18,138,155,0,9,49,139,155,28,9,48,139,155,26,9
    defb 49,140,155,97,126,113,0,155,42,130,44,0,156,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,34,50,0
    defb 0,0,32,48,0,0,0,35,51,0,0,0,0,0,0,0
    defb 0,0,0,0,150,0,0,0,0,127,0,0,127,149,169,0
    defb 0,155,139,128,0,0,155,139,95,0,0,156,140,99,0,0
    defb 154,138,100,0,0,155,139,101,0,0,155,139,119,138,0,146
    defb 149,153,139,0,0,0,86,139,0,0,86,16,139,0,170,126
    defb 142,139,0,0,179,142,139,0,0,192,79,139,0,179,142,79
    defb 140,0,0,0,79,197,0,0,0,126,79,195,0,0,79,126
    defb 194,0,0,179,79,193,0,0,180,142,194,0,0,181,79,195
    defb 0,0,155,79,194,0,0,155,90,0,0,0,74,126,61,0
    defb 45,142,191,78,0,77,190,190,78,0,77,191,191,78,0,77
    defb 190,190,78,0,77,191,142,126,0,142,126,190,187,0,186,191
    defb 191,187,0,186,191,190,187,0,186,190,126,194,0,179,142,191
    defb 204,0,203,190,190,204,0,203,191,191,204,0,203,190,126,195
    defb 0,180,142,191,206,0,205,190,190,206,0,205,191,191,206,0
    defb 205,190,142,196,0,181,126,78,0,0,0,77,78,0,0,0
    defb 77,78,0,0,0,77,142,0,0,0,126,187,0,0,0,186
    defb 187,0,0,0,186,187,0,0,0,186,194,0,0,0,179,204
    defb 0,0,0,203,204,0,0,0,203,204,0,0,0,203,195,0
    defb 0,0,180,206,0,0,0,205,206,0,0,0,205,206,0,0
    defb 0,205,196,0,0,0,181,0,0,0,0,0,0,0,129,0
    defb 0,0,0,130,0,0,0,0,0,0,0,0,129,0,0,0
    defb 0,130,0,0,129,0,0,0,0,130,0,0,0,0,0,90
    defb 0,0,0,74,110,90,0,74,97,4,92,0,76,69,5,92
    defb 0,76,4,69,92,0,76,5,4,92,0,76,4,79,91,0
    defb 75,79,19,0,0,0,3,8,0,0,0,9,103,0,0,0
    defb 87,0,0,0,0,0,165,0,0,0,163,6,0,0,0,7
    defb 6,0,0,0,7,6,0,129,0,7,6,0,130,0,7,6
    defb 0,0,0,7,37,0,0,0,36,17,0,0,0,74,18,0
    defb 0,152,168,18,0,0,152,168,19,0,0,152,168,8,0,0
    defb 152,168,8,0,0,152,168,8,0,0,152,168,124,0,0,152
    defb 168,124,0,0,66,67,124,0,0,0,154,124,0,0,0,155
    defb 124,0,0,0,156,151,0,0,0,0,0,0,0,0,0,59
    defb 0,0,0,57,17,0,0,0,1,18,26,0,25,32,19,0
    defb 0,0,3,60,0,0,0,58,0,0,0,0,0,142,37,0
    defb 80,126,78,204,0,203,77,78,204,0,203,77,78,204,0,203
    defb 77,78,204,0,203,77,78,204,0,203,77,78,204,0,203,77
    defb 97,113,0,97,113,93,54,0,119,144,96,56,0,117,112,96
    defb 137,0,93,112,94,134,0,94,110,97,113,0,97,113,96,112
    defb 0,117,112,95,132,0,118,111,79,132,0,116,113,16,103,0
    defb 119,110,98,139,0,119,113,97,132,0,121,109,128,135,0,121
    defb 111,166,139,0,120,110,200,139,0,0,75,36,37,0,0,121
    defb 113,0,0,0,119,132,0,0,0,116,135,0,0,0,119,137
    defb 0,0,0,121,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0

defb 255 ; end map
;list
EndCode
defs #93e
StartTiles
;nolist
; the C64 tile (4x4) data, formatted for use on CPC

Tiles
    defb 0,0,3,4,141,139,117,0,67,0,83,0,0,0,65,52
    defb 99,49,118,99,142,142,0,0,0,0,44,0,60,0,0,0
    defb 7,3,0,4,12,243,195,199,204,0,0,44,52,0,4,0
    defb 108,100,144,99,0,0,179,183,188,0,0,60,68,116,101,247
    defb 104,3,219,243,0,139,0,0,0,84,0,0,0,72,117,144
    defb 251,142,142,116,116,101,0,0,0,0,119,139,143,147,151,156
    defb 155,151,147,0,0,0,44,48,60,64,0,0,0,100,100,99
    defb 116,243,23,0,0,0,0,0,0,0,86,143,141,160,231,251
    defb 151,12,16,100,227,39,112,183,199,199,86,99,116,125,144,135
    defb 96,0,0,243,135,231,0,208,0,135,0,0,0,0,0,81
    defb 68,0,0,0,0,28,32,135,192,135,0,0,0,17,36,99
    defb 102,187,203,0,0,0,0,0,0,0,0,111,99,99,240,139
    defb 0,28,144,144,231,231,135,117,67,99,99,0,76,0,92,0
    defb 0,120,83,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,1,19,20,139,143,67,3,83,0,0,0,0,4,81,68
    defb 99,65,117,52,139,139,0,0,0,0,60,0,0,0,0,0
    defb 23,19,12,20,28,28,0,0,0,0,4,60,68,147,20,0
    defb 99,119,44,52,251,0,195,199,204,0,0,0,84,179,52,0
    defb 117,19,235,213,139,0,0,0,0,0,0,117,117,88,111,112
    defb 243,0,0,179,183,188,0,0,0,0,86,143,141,163,167,172
    defb 171,167,163,147,151,156,60,64,0,0,0,0,0,116,116,101
    defb 100,227,39,155,151,147,151,0,0,0,0,117,117,176,96,135
    defb 167,28,32,187,183,179,183,199,0,0,0,0,0,192,96,231
    defb 112,0,0,247,231,135,0,224,160,135,0,0,0,0,0,0
    defb 84,0,0,12,16,44,48,135,208,96,219,104,3,33,99,99
    defb 118,203,0,231,0,0,251,0,0,0,72,76,99,99,241,223
    defb 12,44,96,231,0,135,247,120,83,117,67,0,92,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,17,99,36,142,141,83,19,0,3,0,0,1,20,0,84
    defb 102,81,67,68,140,142,0,0,0,12,0,0,0,0,0,0
    defb 102,101,28,36,44,44,0,0,0,12,20,0,84,163,36,0
    defb 39,67,60,68,227,0,0,0,0,0,4,0,0,195,68,0
    defb 108,110,227,243,0,141,147,151,156,0,70,143,141,102,76,96
    defb 213,140,142,195,199,204,12,3,0,0,0,117,99,99,99,100
    defb 116,227,23,163,167,172,0,0,0,0,0,117,117,179,183,188
    defb 187,183,179,171,167,163,167,151,0,0,0,0,0,192,96,231
    defb 112,44,48,203,199,195,199,0,0,0,0,0,0,208,96,135
    defb 183,219,251,0,135,231,160,0,176,213,0,0,0,0,4,0
    defb 0,155,0,28,32,60,64,135,224,96,235,117,19,99,102,49
    defb 99,0,0,96,231,0,135,251,104,3,88,92,117,67,239,239
    defb 28,60,231,0,0,247,0,0,0,120,83,72,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,33,99,99,139,141,0,99,0,19,0,3,17,36,0,0
    defb 118,0,83,84,141,143,147,151,156,28,0,12,0,0,4,0
    defb 118,117,112,118,243,60,0,0,0,28,36,0,0,99,100,251
    defb 55,83,0,84,247,0,0,0,0,12,20,0,0,0,84,0
    defb 86,118,243,247,0,141,163,167,172,0,119,139,143,117,92,144
    defb 243,141,143,0,0,0,28,19,12,3,0,0,0,100,116,99
    defb 99,243,39,99,99,100,0,0,0,0,70,143,141,195,199,204
    defb 203,199,195,116,227,23,112,167,151,151,0,0,0,125,144,135
    defb 96,60,64,0,0,0,0,0,0,0,0,0,0,224,231,247
    defb 199,235,243,0,231,135,176,0,192,135,70,99,99,1,20,0
    defb 0,171,155,44,48,0,0,135,0,135,231,108,110,99,118,65
    defb 52,0,0,144,144,231,231,135,117,19,102,0,120,83,242,241
    defb 44,0,0,0,0,0,0,0,0,0,0,88,0,72,0,104
    defb 3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,3,5,142,142,118,0,67,0,83,0,0,0,66,53
    defb 100,99,119,100,0,139,0,0,0,0,45,0,61,0,0,0
    defb 8,11,0,5,13,244,196,200,205,0,0,45,53,0,5,0
    defb 109,100,145,144,0,0,180,184,189,0,0,61,69,117,102,248
    defb 105,3,220,244,0,0,0,0,0,85,0,0,0,73,117,145
    defb 252,0,0,117,117,102,0,0,0,0,139,140,140,148,152,157
    defb 156,153,148,0,0,0,45,40,61,56,0,0,0,101,101,116
    defb 117,244,139,0,0,0,0,0,0,0,99,70,142,161,232,252
    defb 153,13,8,101,228,40,113,185,201,201,99,116,117,126,145,136
    defb 97,0,0,244,136,232,0,209,0,136,0,0,0,0,0,82
    defb 69,0,0,0,0,29,24,136,193,136,0,0,0,18,37,100
    defb 103,188,204,0,0,0,0,0,0,0,0,100,100,100,241,241
    defb 0,29,145,145,232,232,136,117,67,116,116,0,77,0,93,0
    defb 0,121,83,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,2,19,21,141,141,67,3,83,0,0,0,0,5,82,69
    defb 116,66,118,53,142,0,0,0,0,0,61,0,0,0,0,0
    defb 24,27,13,21,29,29,0,0,0,0,5,61,69,148,157,0
    defb 116,116,45,53,252,0,196,200,205,0,0,0,85,180,189,0
    defb 117,19,236,214,0,141,0,0,0,0,0,71,99,89,100,113
    defb 244,142,0,180,184,189,0,0,0,0,99,70,142,164,168,173
    defb 172,169,164,148,152,157,61,56,0,0,0,0,0,117,117,102
    defb 101,228,40,156,153,148,153,0,0,0,0,87,117,177,97,136
    defb 169,29,24,188,185,180,185,201,0,0,0,0,0,193,97,232
    defb 113,0,0,248,232,136,0,225,161,136,0,0,0,0,0,0
    defb 85,0,0,13,8,45,40,136,209,97,220,105,3,54,100,116
    defb 119,204,0,232,0,0,252,0,0,0,73,77,116,116,242,241
    defb 13,45,97,232,0,136,248,121,83,117,67,0,93,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,18,100,37,0,142,83,19,0,3,0,0,2,21,0,85
    defb 103,82,67,69,143,139,0,0,0,13,0,0,0,0,0,0
    defb 103,102,29,37,45,45,0,0,0,13,21,0,85,164,173,0
    defb 40,43,61,69,228,0,0,0,0,0,5,0,0,196,205,0
    defb 101,111,228,244,0,0,148,152,157,0,99,86,139,101,77,97
    defb 214,0,0,196,200,205,13,8,0,0,0,87,117,100,100,101
    defb 117,228,24,164,168,173,0,0,0,0,0,71,99,180,184,189
    defb 188,185,180,172,169,164,169,153,0,0,0,0,0,193,97,232
    defb 113,45,40,204,201,196,201,0,0,0,0,0,0,209,97,136
    defb 185,220,252,0,136,232,161,0,177,214,0,0,0,0,5,0
    defb 0,156,0,29,24,61,56,136,225,97,236,117,19,100,103,99
    defb 100,0,0,97,232,0,136,252,105,3,89,93,117,67,242,242
    defb 29,61,232,0,0,248,0,0,0,121,83,73,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,54,116,100,141,141,0,100,0,19,0,3,18,37,0,0
    defb 119,0,83,85,142,139,148,152,157,29,0,13,0,0,5,0
    defb 119,118,113,115,244,61,0,0,0,29,37,0,0,100,101,252
    defb 56,59,0,85,119,141,0,0,0,13,21,0,0,0,85,0
    defb 119,99,244,248,141,141,164,168,173,0,139,140,140,117,93,145
    defb 244,142,0,0,0,0,29,24,13,8,0,0,0,101,117,100
    defb 100,244,40,100,100,101,0,0,0,0,99,86,139,196,200,205
    defb 204,201,196,117,228,24,113,169,153,153,0,0,0,126,145,136
    defb 97,61,56,0,0,0,0,0,0,0,0,0,0,225,232,248
    defb 201,236,244,0,232,136,177,0,193,136,117,116,116,2,21,0
    defb 0,172,156,45,40,0,0,136,0,136,232,101,111,116,119,66
    defb 53,0,0,145,145,232,232,136,117,19,101,0,121,83,223,223
    defb 45,0,0,0,0,0,0,0,0,0,0,89,0,73,0,105
    defb 3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,1,3,0,139,143,119,0,67,0,83,0,0,0,49,68
    defb 101,116,102,52,141,139,0,0,0,0,46,0,62,0,0,81
    defb 8,3,1,0,14,245,197,200,206,0,0,49,46,1,0,0
    defb 110,101,146,145,0,0,181,184,190,0,0,65,62,117,103,249
    defb 3,14,221,245,139,143,0,0,0,0,0,0,0,74,118,146
    defb 253,141,0,117,118,103,0,0,0,0,142,141,141,149,152,158
    defb 154,151,158,0,0,0,40,46,56,62,0,0,0,101,102,117
    defb 118,245,24,0,0,0,0,0,0,0,71,99,143,162,233,253
    defb 154,8,14,102,229,40,114,186,202,199,99,117,99,127,146,137
    defb 98,0,0,245,137,233,0,210,0,137,0,0,0,0,0,65
    defb 84,0,0,0,0,24,30,137,194,137,0,0,0,33,20,101
    defb 108,186,202,0,0,0,0,0,0,0,0,100,101,101,242,241
    defb 0,30,146,146,233,233,137,67,117,117,117,0,78,0,94,0
    defb 0,83,122,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,17,19,4,140,140,67,3,83,0,0,0,1,0,65,84
    defb 117,49,119,68,143,143,0,0,0,0,62,0,0,0,0,0
    defb 24,19,17,14,30,30,0,0,0,1,0,65,62,149,158,0
    defb 117,117,49,46,253,0,197,200,206,0,0,81,0,181,190,0
    defb 19,116,237,215,0,0,0,0,0,0,70,0,116,90,100,114
    defb 245,0,143,181,184,190,0,0,0,0,71,99,143,165,168,174
    defb 170,167,174,149,152,158,56,62,0,0,0,0,0,117,99,103
    defb 102,229,40,154,151,158,154,0,0,0,86,0,99,178,98,137
    defb 170,24,30,186,183,190,186,202,0,0,0,0,0,194,98,233
    defb 114,0,0,249,233,137,0,226,162,137,0,0,0,0,0,81
    defb 0,0,0,8,14,40,46,137,210,98,221,3,106,116,36,117
    defb 102,202,0,233,0,0,253,0,0,0,74,78,117,117,239,239
    defb 14,46,98,233,0,137,249,83,122,67,117,0,94,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,33,102,20,142,143,83,19,0,3,0,0,17,4,81,0
    defb 108,65,67,84,139,142,0,0,0,14,0,0,0,0,0,0
    defb 101,99,33,30,46,46,0,0,0,17,14,81,0,165,174,0
    defb 40,67,65,62,229,0,0,0,0,1,0,0,0,197,206,0
    defb 110,100,229,245,142,143,149,152,158,0,87,99,143,102,78,98
    defb 215,0,142,197,200,206,8,14,0,0,86,0,99,101,101,102
    defb 117,229,24,165,168,174,0,0,0,0,70,0,116,181,184,190
    defb 186,183,190,170,167,174,170,154,0,0,0,0,0,194,98,233
    defb 114,40,46,202,199,206,202,0,0,0,0,0,0,210,98,137
    defb 186,221,253,0,137,233,162,0,178,215,0,0,0,1,0,0
    defb 0,154,0,24,30,56,62,137,226,98,237,19,116,101,108,116
    defb 52,0,0,98,233,0,137,253,3,106,90,94,67,117,223,142
    defb 30,62,233,0,0,249,0,0,0,83,122,74,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,116,118,36,139,139,0,102,0,19,0,3,33,20,0,0
    defb 102,81,83,0,143,0,149,152,158,30,0,14,0,1,0,0
    defb 117,99,114,112,245,62,0,0,0,33,30,0,0,101,102,253
    defb 56,83,81,0,119,0,0,0,0,17,14,0,0,81,0,0
    defb 99,116,245,249,0,139,165,168,174,0,142,141,141,118,94,146
    defb 245,0,0,0,0,0,24,30,8,14,0,0,0,102,118,101
    defb 101,245,40,101,101,102,0,0,0,0,87,99,143,197,200,206
    defb 202,199,206,117,229,24,114,170,154,151,0,0,0,127,146,137
    defb 98,56,62,0,0,0,0,0,0,0,0,0,0,226,233,249
    defb 202,237,245,0,233,137,178,0,194,137,116,117,117,17,4,0
    defb 0,170,154,40,46,0,0,137,0,137,233,110,100,117,102,49
    defb 68,0,0,146,146,233,233,137,19,116,102,0,83,122,239,239
    defb 46,0,0,0,0,0,0,0,0,0,0,90,0,74,0,3
    defb 106,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,2,3,0,0,142,119,0,67,0,83,0,0,0,50,69
    defb 102,117,71,53,142,0,0,0,0,0,47,0,63,0,0,82
    defb 9,11,2,0,15,246,198,201,207,0,0,50,47,2,0,0
    defb 108,102,119,146,0,0,182,185,191,0,0,66,63,118,80,250
    defb 3,15,222,246,0,142,0,0,0,0,0,0,0,75,99,119
    defb 254,142,0,118,100,80,0,0,0,0,143,119,139,150,153,159
    defb 155,153,159,0,0,0,48,47,64,63,0,0,0,102,111,118
    defb 119,246,25,0,0,0,0,0,0,0,141,87,143,0,234,254
    defb 156,16,15,111,230,41,87,188,204,201,116,117,87,119,146,138
    defb 119,0,0,246,138,234,0,87,0,138,0,0,0,0,0,66
    defb 85,0,0,0,0,32,31,138,103,138,0,0,0,34,21,102
    defb 109,187,203,0,0,0,0,0,0,0,0,101,102,102,223,143
    defb 0,31,146,146,234,234,138,67,117,118,118,0,79,0,95,0
    defb 0,83,123,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,18,19,5,142,143,67,3,83,0,0,0,2,0,66,85
    defb 118,50,119,69,139,139,0,0,0,0,63,0,0,0,0,0
    defb 25,27,18,15,31,31,0,0,0,2,0,66,63,18,159,0
    defb 118,118,50,47,254,142,198,201,207,0,0,82,0,50,191,0
    defb 19,116,238,0,142,143,0,0,0,0,117,0,117,91,101,0
    defb 246,139,139,182,185,191,0,0,0,0,141,87,143,166,169,175
    defb 171,169,175,150,153,159,64,63,0,0,0,0,0,99,100,80
    defb 111,230,41,155,153,159,156,0,0,0,117,0,117,71,119,138
    defb 172,32,31,187,185,191,188,204,0,0,0,0,0,103,119,234
    defb 87,0,0,250,234,138,0,0,0,138,0,0,0,0,0,82
    defb 0,0,0,16,15,48,47,138,87,119,222,3,107,117,37,118
    defb 80,203,0,234,0,0,254,0,0,0,75,79,118,118,241,241
    defb 15,47,119,234,0,138,250,83,123,67,117,0,95,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,34,103,21,139,141,83,19,0,3,0,0,18,5,82,0
    defb 109,66,67,85,142,0,0,0,0,15,0,0,0,0,0,0
    defb 102,100,34,31,47,47,0,0,0,18,15,82,0,166,175,0
    defb 41,43,66,63,230,0,0,0,0,2,0,0,0,66,207,0
    defb 71,101,230,246,0,141,150,153,159,0,141,71,143,99,79,119
    defb 0,0,143,198,201,207,3,15,0,0,117,0,117,102,102,103
    defb 118,230,25,166,169,175,0,0,0,0,117,0,117,182,185,191
    defb 187,185,191,171,169,175,172,156,0,0,0,0,0,103,119,234
    defb 71,48,47,203,201,207,204,0,0,0,0,0,0,87,119,138
    defb 188,222,254,0,138,234,0,0,71,0,0,0,0,2,0,0
    defb 0,155,0,32,31,64,63,138,0,119,238,19,116,102,109,117
    defb 53,0,0,119,234,0,138,254,3,107,91,95,67,117,242,242
    defb 31,63,234,0,0,250,0,0,0,83,123,75,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,117,119,37,141,142,0,103,0,19,0,3,34,21,0,0
    defb 80,82,83,0,139,141,150,153,159,31,0,15,0,2,0,0
    defb 117,116,118,113,246,63,0,0,0,34,31,0,0,102,103,254
    defb 57,59,82,0,250,0,0,0,0,18,15,0,0,82,0,0
    defb 87,117,246,250,141,142,166,169,175,0,143,119,139,99,95,119
    defb 246,139,141,0,0,0,29,31,3,15,0,0,0,103,119,102
    defb 102,246,41,102,102,103,0,0,0,0,141,71,143,198,201,207
    defb 203,201,207,118,230,25,71,172,156,153,0,0,0,119,146,138
    defb 103,64,63,0,0,0,0,0,0,0,0,0,0,0,234,250
    defb 204,238,246,0,234,138,71,0,103,138,117,116,71,18,5,0
    defb 0,171,155,48,47,0,0,138,0,138,234,71,101,118,80,50
    defb 69,0,0,146,146,234,234,138,19,116,99,0,83,123,241,240
    defb 47,0,0,0,0,0,0,0,0,0,0,91,0,75,0,3
    defb 107,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; the 256 background characters

CharsBlock
    defb 0,255,255,243,247,255,226,226
    defb 192,192,213,226,255,255,213,255
    defb 243,115,115,246,249,195,247,247
    defb 213,213,213,247,234,226,249,249
    defb 246,252,234,99,234,192,192,192
    defb 192,192,192,192,192,192,192,192
    defb 192,234,234,252,234,234,226,226
    defb 192,192,213,226,255,226,243,243
    defb 243,243,213,192,192,212,234,192
    defb 194,194,192,194,192,192,234,192
    defb 99,179,147,243,243,211,227,227
    defb 73,192,73,192,132,202,174,202
    defb 209,147,226,192,213,255,255,227
    defb 255,251,247,255,227,227,227,192
    defb 209,147,226,192,192,213,179,179
    defb 234,227,226,211,227,227,243,243
    defb 255,192,255,255,255,240,250,213
    defb 254,232,234,234,255,234,234,255
    defb 209,147,226,255,192,192,255,192
    defb 226,209,192,255,234,255,192,213
    defb 255,252,255,179,51,243,243,211
    defb 174,226,115,243,249,234,51,99
    defb 234,243,209,192,192,192,192,192
    defb 255,212,192,48,192,192,192,192
    defb 193,213,234,99,195,115,255,211
    defb 255,226,147,232,243,234,195,195
    defb 209,213,234,209,147,255,255,255
    defb 255,48,192,255,255,255,255,255
    defb 212,124,212,255,48,192,255,255
    defb 48,192,255,186,255,96,255,255
    defb 255,209,209,144,75,48,192,234
    defb 243,243,213,255,255,255,255,0
    defb 0,255,255,115,179,255,243,243
    defb 226,226,212,243,255,255,192,255
    defb 115,211,243,246,243,147,212,192
    defb 213,213,255,192,247,212,249,249
    defb 246,192,192,211,234,213,213,213
    defb 213,213,213,213,192,213,234,234
    defb 213,234,253,249,253,213,209,209
    defb 212,212,254,209,255,185,179,193
    defb 243,249,192,213,234,252,226,249
    defb 195,195,195,195,234,174,255,174
    defb 211,247,195,243,115,115,115,115
    defb 73,192,73,192,192,142,213,142
    defb 213,243,234,243,209,255,255,211
    defb 255,115,145,255,115,115,115,209
    defb 255,255,255,243,226,209,226,226
    defb 213,99,209,99,115,147,179,246
    defb 213,249,213,255,234,225,213,149
    defb 213,234,255,213,255,213,213,255
    defb 226,179,246,213,243,249,192,115
    defb 195,195,243,255,232,192,243,209
    defb 255,188,192,179,243,249,51,179
    defb 215,209,243,192,249,213,243,115
    defb 226,179,243,243,243,243,243,249
    defb 93,246,226,96,226,243,226,209
    defb 211,255,255,147,195,115,243,227
    defb 192,209,195,243,115,209,195,195
    defb 115,255,255,255,255,255,48,96
    defb 255,48,192,255,255,144,255,234
    defb 232,105,212,255,48,192,255,192
    defb 135,48,192,96,235,234,255,213
    defb 234,213,213,96,135,48,192,255
    defb 115,179,213,255,255,247,255,0
    defb 0,255,179,195,211,255,211,211
    defb 243,243,246,211,255,209,145,255
    defb 195,147,243,192,212,243,213,213
    defb 255,255,255,213,192,249,212,192
    defb 192,213,234,249,234,192,213,213
    defb 255,255,255,213,209,246,192,179
    defb 213,234,212,211,243,234,243,243
    defb 249,249,232,243,255,227,249,213
    defb 179,115,252,213,234,249,179,179
    defb 12,142,142,142,213,73,255,73
    defb 227,255,115,179,195,247,249,243
    defb 234,174,234,174,77,73,197,73
    defb 234,243,213,243,243,243,179,227
    defb 255,227,115,247,145,179,243,179
    defb 234,226,234,243,209,226,234,209
    defb 255,147,211,98,179,99,249,249
    defb 209,243,249,255,226,240,234,122
    defb 234,213,250,234,192,234,234,234
    defb 209,115,249,179,195,115,99,147
    defb 226,209,195,243,179,115,195,195
    defb 212,124,212,115,255,255,192,243
    defb 239,179,255,37,255,255,255,251
    defb 179,115,192,179,243,243,243,179
    defb 174,249,209,75,209,243,209,251
    defb 227,255,255,99,195,179,243,211
    defb 192,192,195,195,195,246,195,195
    defb 179,255,255,255,255,255,48,144
    defb 255,48,192,255,144,255,255,232
    defb 255,255,255,144,75,48,192,255
    defb 48,192,255,48,48,255,255,234
    defb 253,255,234,144,75,48,192,255
    defb 192,192,213,255,234,226,253,0
    defb 0,255,247,147,115,255,179,179
    defb 243,243,209,179,255,213,226,255
    defb 147,195,249,232,252,115,254,234
    defb 255,255,255,234,253,249,246,192
    defb 232,192,234,115,213,234,255,255
    defb 255,255,255,255,234,255,255,255
    defb 255,192,226,179,226,234,185,185
    defb 249,249,251,185,255,227,249,251
    defb 179,243,212,255,213,243,243,179
    defb 73,73,73,73,255,73,255,73
    defb 211,255,211,179,147,179,243,179
    defb 174,234,174,234,197,73,213,73
    defb 226,99,209,147,179,255,213,211
    defb 255,147,249,234,243,179,179,179
    defb 255,192,234,195,243,179,213,115
    defb 255,227,249,243,179,211,243,243
    defb 192,246,192,255,255,240,245,46
    defb 213,234,213,192,255,192,192,255
    defb 226,99,209,226,51,243,243,147
    defb 243,243,51,192,246,249,51,51
    defb 213,105,212,115,192,192,243,212
    defb 93,192,192,255,192,213,192,226
    defb 246,243,232,179,179,51,195,179
    defb 215,249,115,26,115,147,115,243
    defb 194,234,213,147,195,179,192,99
    defb 243,145,195,243,147,212,195,195
    defb 226,234,213,213,179,255,255,255
    defb 255,48,192,255,213,213,255,209
    defb 213,212,232,255,48,192,255,255
    defb 48,192,255,96,175,255,255,192
    defb 209,255,226,96,135,48,192,255
    defb 243,243,234,255,255,192,251,0
    defb 0,251,195,243,179,179,226,226
    defb 232,232,253,226,255,118,115,194
    defb 243,246,192,234,213,252,234,234
    defb 234,234,234,234,192,234,213,213
    defb 234,213,254,99,254,234,232,232
    defb 234,234,255,232,251,232,246,246
    defb 249,192,192,213,213,234,243,243
    defb 209,209,232,243,255,255,192,255
    defb 179,227,243,249,243,99,227,227
    defb 192,77,234,77,134,192,134,192
    defb 179,255,255,179,115,255,213,255
    defb 213,93,255,93,195,195,195,195
    defb 209,147,226,255,234,255,255,227
    defb 234,147,226,147,227,227,255,227
    defb 234,243,213,255,255,234,234,179
    defb 255,179,98,255,227,227,226,243
    defb 209,147,226,255,255,240,250,224
    defb 234,213,234,192,192,255,255,192
    defb 209,147,226,99,195,179,243,211
    defb 192,226,195,243,179,226,195,195
    defb 212,150,232,243,243,243,243,246
    defb 174,249,209,144,209,243,209,226
    defb 233,213,234,115,243,246,51,115
    defb 235,226,243,192,246,234,243,179
    defb 193,213,234,234,243,246,192,179
    defb 195,195,243,255,212,192,243,226
    defb 209,192,192,255,213,255,48,144
    defb 255,48,192,255,26,75,234,255
    defb 255,124,192,144,75,48,192,255
    defb 48,192,255,192,192,234,255,255
    defb 255,255,209,144,75,48,192,255
    defb 255,251,255,255,179,115,234,0
    defb 0,115,99,243,243,227,209,209
    defb 192,192,234,209,255,209,243,243
    defb 243,243,234,192,192,232,192,192
    defb 192,192,192,192,192,192,192,192
    defb 192,213,213,246,213,213,251,251
    defb 234,234,234,251,213,209,246,246
    defb 249,252,213,209,213,192,249,209
    defb 192,192,234,209,255,255,234,255
    defb 243,179,179,249,246,195,211,211
    defb 72,197,93,197,134,192,134,192
    defb 226,255,255,243,251,255,213,192
    defb 192,192,213,192,193,193,192,193
    defb 213,243,234,192,234,255,255,211
    defb 213,211,209,227,211,211,192,115
    defb 226,179,226,192,192,234,213,226
    defb 255,247,251,255,211,147,192,192
    defb 226,179,246,226,99,240,213,234
    defb 255,255,213,213,213,255,255,213
    defb 226,179,246,147,195,179,255,227
    defb 255,209,99,212,243,213,195,195
    defb 232,188,232,192,192,192,192,192
    defb 255,232,192,48,192,192,192,192
    defb 211,255,255,115,51,243,243,227
    defb 93,209,179,243,246,213,51,147
    defb 115,255,255,255,192,192,255,192
    defb 209,226,192,255,213,255,192,234
    defb 213,192,192,255,255,255,48,96
    defb 255,255,255,213,192,97,255,255
    defb 255,252,255,255,48,192,255,255
    defb 48,192,255,96,135,26,144,255
    defb 255,255,213,96,135,48,192,255
    defb 255,255,255,213,243,243,234,0
    defb 0,255,227,115,99,115,98,118
    defb 246,246,247,98,255,211,246,247
    defb 115,243,232,255,234,243,255,255
    defb 255,255,255,255,213,255,255,255
    defb 255,192,209,179,209,213,213,213
    defb 255,255,255,213,254,246,249,232
    defb 212,192,213,226,234,213,115,115
    defb 243,243,226,115,255,234,209,255
    defb 99,195,246,212,252,179,227,227
    defb 202,134,234,134,93,213,93,213
    defb 227,255,251,99,179,255,192,192
    defb 255,134,255,134,134,134,134,134
    defb 234,243,213,192,192,255,234,227
    defb 255,211,246,243,227,227,192,227
    defb 234,226,234,192,192,213,209,209
    defb 255,99,246,213,227,99,232,249
    defb 209,115,249,234,115,240,234,240
    defb 234,213,234,234,192,255,234,234
    defb 209,115,249,99,195,115,192,147
    defb 243,98,195,243,99,232,195,195
    defb 234,232,212,115,115,51,195,115
    defb 235,246,179,37,179,99,179,243
    defb 227,247,255,179,192,192,243,232
    defb 174,212,192,255,192,234,192,209
    defb 179,255,255,209,51,243,243,99
    defb 243,243,51,192,249,246,51,51
    defb 243,192,234,255,255,255,48,144
    defb 255,255,255,255,97,144,255,255
    defb 234,150,232,255,48,192,255,255
    defb 48,192,255,144,75,37,96,255
    defb 255,234,234,144,75,48,192,255
    defb 255,192,247,255,243,243,213,0
    defb 0,255,179,115,195,251,243,243
    defb 246,246,212,243,255,211,246,234
    defb 115,179,252,234,213,246,234,234
    defb 255,255,255,234,226,249,192,115
    defb 234,213,232,246,243,213,234,234
    defb 255,255,255,234,192,246,232,192
    defb 192,234,213,249,253,192,227,227
    defb 243,243,249,227,255,226,98,255
    defb 195,99,243,192,232,243,211,211
    defb 142,134,202,134,213,93,213,93
    defb 211,255,115,195,227,255,249,249
    defb 234,134,255,134,12,77,77,77
    defb 226,99,209,209,209,209,226,211
    defb 255,99,227,145,211,211,209,211
    defb 213,243,234,209,192,209,243,115
    defb 255,211,179,251,211,211,249,243
    defb 232,99,209,255,255,240,245,240
    defb 213,234,213,213,255,255,255,255
    defb 226,99,209,147,195,115,243,227
    defb 192,192,195,195,195,249,195,195
    defb 255,255,255,115,243,243,243,115
    defb 93,246,226,135,226,243,226,247
    defb 214,209,213,179,255,255,192,243
    defb 223,115,255,26,255,255,255,247
    defb 194,234,213,115,195,179,147,99
    defb 209,226,195,243,115,179,195,195
    defb 226,234,192,255,209,255,48,96
    defb 255,48,192,255,48,234,234,234
    defb 232,188,232,255,48,192,255,192
    defb 135,48,192,48,96,255,255,255
    defb 234,192,226,96,135,48,192,255
    defb 213,209,254,255,192,192,234,0
    defb 0,255,251,243,255,255,209,192
    defb 192,209,213,226,255,234,255,255
    defb 246,195,246,246,179,179,192,213
    defb 213,192,213,247,246,246,209,213
    defb 247,192,213,115,213,252,192,192
    defb 192,192,192,192,192,192,192,192
    defb 213,234,234,192,234,255,209,192
    defb 192,209,213,226,243,243,209,255
    defb 226,232,192,192,234,243,192,213
    defb 194,194,194,215,202,192,207,213
    defb 115,227,243,243,99,115,226,226
    defb 77,192,77,213,134,192,134,213
    defb 179,243,209,192,255,255,234,226
    defb 255,251,247,255,226,226,226,192
    defb 179,243,209,192,192,213,243,226
    defb 227,209,211,213,226,115,243,243
    defb 234,255,255,255,255,245,224,213
    defb 124,255,234,234,234,234,234,255
    defb 227,243,192,234,192,255,255,226
    defb 209,192,213,255,192,192,192,255
    defb 234,232,255,147,51,213,243,209
    defb 93,179,246,243,179,243,51,115
    defb 243,243,213,192,192,192,192,232
    defb 255,192,192,96,192,192,192,192
    defb 226,255,212,195,195,213,255,209
    defb 255,179,243,212,99,179,195,147
    defb 226,255,212,99,226,255,255,255
    defb 234,186,234,255,255,255,255,255
    defb 105,124,212,234,186,234,255,234
    defb 186,234,255,96,235,255,213,255
    defb 255,192,213,186,133,186,234,212
    defb 51,232,213,255,255,255,255,0
    defb 0,255,115,115,255,255,98,226
    defb 226,98,212,243,255,192,255,255
    defb 243,99,243,246,243,227,247,213
    defb 213,247,255,192,246,246,232,251
    defb 212,234,213,249,192,192,213,213
    defb 213,213,213,213,213,213,234,192
    defb 255,213,253,246,213,213,246,212
    defb 212,246,254,209,194,115,118,255
    defb 209,252,213,213,192,246,243,209
    defb 195,73,195,73,142,234,134,234
    defb 209,179,179,243,195,251,243,209
    defb 197,72,197,72,134,192,134,234
    defb 226,192,192,243,255,255,226,209
    defb 255,98,179,255,243,209,243,243
    defb 255,255,255,243,226,209,226,234
    defb 147,226,147,234,243,195,179,212
    defb 232,192,255,213,255,234,208,255
    defb 252,213,224,213,192,213,213,255
    defb 147,179,226,226,243,192,192,195
    defb 195,179,212,255,243,246,243,234
    defb 232,188,255,179,243,234,195,226
    defb 235,115,246,192,243,246,243,115
    defb 115,243,209,226,209,243,243,249
    defb 174,246,209,96,209,243,243,243
    defb 209,255,226,195,195,226,243,226
    defb 192,115,179,243,195,179,195,99
    defb 209,255,226,255,255,213,117,213
    defb 213,117,213,255,96,255,255,255
    defb 124,252,192,213,117,213,255,117
    defb 74,117,213,26,213,255,255,213
    defb 234,213,255,117,74,117,213,226
    defb 195,209,255,255,251,255,255,0
    defb 0,255,227,195,115,255,227,243
    defb 243,227,246,211,255,98,226,255
    defb 211,243,232,192,243,99,234,255
    defb 255,234,255,213,192,232,246,192
    defb 213,192,254,232,255,234,255,255
    defb 255,255,255,213,115,192,249,226
    defb 213,213,179,227,213,213,185,249
    defb 249,185,232,243,234,246,211,255
    defb 243,246,213,213,252,179,243,226
    defb 12,134,12,194,213,93,213,93
    defb 226,251,195,179,179,255,243,232
    defb 234,134,234,134,77,77,77,93
    defb 209,192,192,243,115,243,243,226
    defb 251,179,211,255,243,192,243,243
    defb 243,226,234,243,209,226,234,213
    defb 145,227,99,255,243,243,249,226
    defb 243,243,192,209,255,213,224,245
    defb 252,192,224,234,192,234,234,234
    defb 99,115,209,195,195,179,195,226
    defb 209,99,115,243,195,179,195,115
    defb 105,124,192,247,255,255,212,115
    defb 223,243,255,96,255,255,255,179
    defb 211,213,209,247,226,243,243,246
    defb 93,115,226,26,226,243,243,115
    defb 226,255,209,195,195,249,243,192
    defb 192,179,195,195,195,115,195,147
    defb 226,255,209,255,255,234,186,234
    defb 234,186,234,255,96,234,255,226
    defb 255,255,255,186,133,186,234,234
    defb 186,234,255,75,146,255,234,234
    defb 253,255,255,186,133,186,234,234
    defb 212,234,255,254,179,213,255,0
    defb 0,255,179,147,251,255,211,243
    defb 243,211,209,179,255,209,234,255
    defb 179,179,252,232,246,195,213,255
    defb 255,213,255,234,232,249,246,254
    defb 234,213,213,209,213,192,255,255
    defb 255,255,255,255,255,255,255,213
    defb 255,213,226,115,192,192,243,249
    defb 249,243,251,185,247,246,211,255
    defb 185,243,234,255,232,243,147,212
    defb 73,134,73,142,93,255,93,255
    defb 209,115,99,179,227,255,147,209
    defb 234,134,234,134,77,197,77,239
    defb 115,243,226,195,234,255,115,209
    defb 213,246,99,255,147,209,147,147
    defb 192,192,255,99,243,179,213,209
    defb 243,246,211,255,51,179,243,243
    defb 246,212,192,255,255,250,208,234
    defb 252,192,208,192,213,192,192,255
    defb 211,243,192,51,51,246,243,243
    defb 243,99,249,192,51,243,51,209
    defb 124,252,234,209,192,234,243,212
    defb 174,192,192,255,192,192,192,179
    defb 147,212,192,243,179,195,195,246
    defb 235,115,179,144,179,99,115,115
    defb 209,255,232,195,195,192,232,98
    defb 243,147,99,243,195,115,195,99
    defb 192,255,232,115,234,255,255,255
    defb 213,117,213,255,48,234,255,255
    defb 212,232,234,213,117,213,255,213
    defb 117,213,255,146,135,255,213,192
    defb 209,255,234,117,74,117,213,213
    defb 243,234,255,247,226,255,255,0
    defb 0,115,115,243,195,247,209,232
    defb 232,249,253,226,193,179,185,255
    defb 226,252,234,234,192,249,234,234
    defb 234,234,234,234,234,234,213,192
    defb 255,234,254,115,234,234,251,234
    defb 234,251,255,232,249,249,212,247
    defb 232,213,234,234,192,192,185,209
    defb 209,145,232,243,255,192,255,255
    defb 243,147,243,249,243,211,246,226
    defb 73,192,73,213,202,132,202,132
    defb 226,255,179,179,255,255,255,234
    defb 77,213,77,213,195,134,195,134
    defb 179,243,209,255,255,255,213,226
    defb 99,209,99,213,246,226,255,246
    defb 209,192,255,255,255,234,234,226
    defb 255,145,115,255,246,115,226,243
    defb 227,243,192,255,255,245,224,255
    defb 252,192,192,192,192,234,255,192
    defb 227,243,192,195,195,209,243,209
    defb 192,179,115,243,195,115,195,147
    defb 188,252,192,209,226,243,243,246
    defb 93,249,226,144,226,243,243,243
    defb 243,255,212,115,243,213,195,209
    defb 215,179,249,192,243,249,243,179
    defb 226,255,212,209,243,192,192,195
    defb 195,115,232,255,243,249,243,213
    defb 192,192,192,234,255,234,186,234
    defb 234,186,234,48,192,255,255,255
    defb 212,124,255,186,133,186,234,234
    defb 186,234,255,192,192,255,234,255
    defb 255,255,213,186,133,186,234,255
    defb 247,255,255,209,195,226,255,0
    defb 0,211,243,243,147,179,226,192
    defb 192,226,234,209,243,243,226,255
    defb 209,212,192,192,213,243,192,192
    defb 192,192,192,192,192,192,192,192
    defb 234,213,213,254,213,255,232,234
    defb 234,232,234,251,249,249,226,234
    defb 251,192,234,226,234,252,226,192
    defb 192,226,234,209,255,213,255,255
    defb 249,195,249,249,115,115,209,209
    defb 73,192,73,234,142,192,142,234
    defb 234,255,247,243,255,255,192,234
    defb 197,192,197,234,193,193,193,235
    defb 226,192,192,192,255,255,213,209
    defb 211,226,227,234,209,209,192,209
    defb 147,179,226,192,192,234,213,234
    defb 255,247,251,255,209,243,192,209
    defb 147,179,192,147,209,234,208,234
    defb 192,213,213,213,213,213,255,192
    defb 147,179,226,195,195,234,255,226
    defb 255,115,243,232,147,115,195,99
    defb 150,188,232,192,192,192,192,212
    defb 255,192,192,144,192,192,192,192
    defb 209,255,226,99,51,234,243,226
    defb 174,115,249,243,115,243,51,179
    defb 209,255,226,213,192,255,255,209
    defb 226,192,234,255,192,192,192,255
    defb 192,192,234,255,255,213,117,213
    defb 255,255,255,48,95,255,255,255
    defb 213,212,255,213,117,213,255,213
    defb 117,213,255,37,75,144,96,255
    defb 255,255,255,117,74,117,213,255
    defb 255,255,255,232,51,212,234,0
    defb 0,179,147,115,211,255,243,246
    defb 246,243,247,98,251,249,227,255
    defb 118,243,213,255,212,243,255,255
    defb 255,255,255,255,255,255,255,234
    defb 255,234,209,246,192,192,254,255
    defb 255,254,255,213,212,246,249,253
    defb 213,234,234,209,234,192,227,243
    defb 243,227,226,115,255,226,213,255
    defb 115,115,252,212,249,195,243,226
    defb 142,202,142,223,213,73,213,73
    defb 226,255,115,99,247,255,192,192
    defb 174,255,174,255,134,73,134,77
    defb 209,192,192,192,213,255,192,226
    defb 243,249,227,255,243,226,192,243
    defb 243,226,234,192,192,213,209,213
    defb 234,249,147,255,243,243,192,226
    defb 99,115,192,179,213,213,224,213
    defb 252,192,224,234,192,234,255,192
    defb 99,115,209,195,195,192,212,145
    defb 243,99,147,243,195,179,195,147
    defb 232,212,213,243,115,195,195,249
    defb 215,179,115,96,115,147,179,179
    defb 243,255,209,226,192,213,243,232
    defb 93,192,192,255,192,192,192,115
    defb 226,255,209,51,51,249,243,243
    defb 243,147,246,192,51,243,51,226
    defb 226,234,192,255,255,234,186,234
    defb 255,255,255,144,96,255,255,255
    defb 188,252,213,234,186,234,255,234
    defb 186,234,255,48,135,96,144,255
    defb 255,234,255,186,133,186,234,251
    defb 209,255,255,234,243,213,255,0
    defb 0,247,195,115,115,255,98,246
    defb 246,118,212,243,213,249,227,255
    defb 243,249,234,234,252,115,255,255
    defb 255,255,255,234,179,192,246,209
    defb 234,234,115,212,234,234,213,255
    defb 255,213,255,234,192,212,249,192
    defb 234,192,253,246,255,213,211,243
    defb 243,211,249,227,255,145,209,255
    defb 227,243,212,192,243,147,249,209
    defb 142,142,142,174,213,73,213,73
    defb 209,255,211,195,179,255,249,209
    defb 234,174,234,174,12,73,12,193
    defb 115,243,226,209,209,209,226,209
    defb 98,211,147,255,249,209,209,249
    defb 226,192,255,209,192,209,115,209
    defb 247,115,227,255,249,179,249,243
    defb 115,249,192,255,255,250,208,250
    defb 252,192,208,213,192,213,255,255
    defb 211,243,192,195,195,246,243,192
    defb 192,115,195,195,195,179,195,99
    defb 255,255,255,251,209,243,243,249
    defb 174,179,209,37,209,243,243,179
    defb 115,255,232,251,255,255,232,179
    defb 239,243,255,144,255,255,255,115
    defb 209,255,232,195,195,115,195,209
    defb 226,147,179,243,195,115,195,179
    defb 192,255,192,226,255,213,117,213
    defb 213,117,213,213,37,255,255,234
    defb 150,188,192,213,117,213,255,117
    defb 74,117,213,75,48,255,213,255
    defb 234,226,234,117,74,117,213,253
    defb 115,234,255,213,232,213,255,0
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: game
  SELECT id INTO tag_uuid FROM tags WHERE name = 'game';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
