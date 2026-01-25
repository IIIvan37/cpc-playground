-- Migration: Import z80code projects batch 61
-- Projects 121 to 122
-- Generated: 2026-01-25T21:43:30.201547

-- Project 121: load_run-raw by Longshot
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'load_run-raw',
    'Imported from z80Code. Author: Longshot.',
    'public',
    false,
    false,
    '2019-11-13T16:12:10.167000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'org #BEBE

start:
 di
 ld bc,#7F10
 ld hl,#4B5C
 out (c),c
noend:
 out (c),h
 nop
 out (c),l
 nop
 jr noend
 defs #bfff-$,#be
end:

SAVE ''-RUN.BIN'', start, end-start ,DSK, ''raw.dsk'' 
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

-- Project 122: catalogue-orion prime by Targhan
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'catalogue-orion prime',
    'Imported from z80Code. Author: Targhan. Test catalogue détourné d''Orion Prime',
    'public',
    false,
    false,
    '2022-06-25T10:01:27.348000'::timestamptz,
    '2022-06-26T19:36:25.705000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Decryptage du détournement de CATalogue du fabuleux jeu ''Orion Prime''
;
; Non seulement c''est plein d''astuces, mais en plus c''est Bô !


BUILDSNA
BANKSET 0

ORG #4000
RUN start

start
        ld sp,#c000

        ; Select lower ROM
        ld bc,#7f80 | %1001
        out (c),c

        exx
        xor a
        ex af,af''

        call #0044                  ; Restore #00-#40 and
        call #08bd                  ; Restore vectors

        ; Other calls made by the ROM
        call #1b5c
        call #1fe9
        call #0abf
        call #1074
        call #15a8
        call #24bc
        call #07e0

        ; Back to RAM
        ld   bc,#7f80 | %1101
        out  (c),c

        ld   hl,cat
.printf
        ld   a,(hl)
        cp   #ff
        jr   z,.next
        call #bb5a
        inc  hl
        jr   .printf
 
.next
        jr   $


; ----------------------------------
; data
; ----------------------------------
cat
;        DEFB #04,#02,#1D,#00,#00,#0E,#01,#0F,".",#16,#01,#1C,"   1k   " ; ...........
        DEFB #04,#02                    ; mode 2
        DEFB #1D,#00,#00                ; border 0,0
        DEFB #0E,#01,#0F                ; paper 1,15
        DEFB "."                        ; print "."
        DEFB #16,#01                    ; mode normal (char + background)
        DEFB #1C,"  "                   ; ink 0,0 (space modulo 32?)
        DEFB " 1k   "

;        DEFB #44,#1C,#01,#16,#16,#0B,#0D,#20,".",#4E,#19,#00,"   1k   " ; D...... N..
        DEFB #44
        DEFB #1C,#01,#16                ; ink 1,22
        DEFB #16,#0B                    ; mode OR on or off?
        DEFB #0D                        ; CR
        DEFB #20,".",#4E                ; print " .N"
        DEFB #19,#00,"   1k   "         ; SYMBOL (consume system text)
        
;        DEFB #06,#61,#76,#43,#6F,#6D,#53,#17,".",#79,#73,#19,"   1k   " ; .avComS.ys.
        DEFB #06                        ; echo on
        DEFB #61,#76,#43,#6F,#6D,#53    ; print "avComS"
        DEFB #17,"."                    ; graphic mode on (consume ".")
        DEFB #79,#73                    ; print "ys"
        DEFB #19,"   1k   "             ; SYMBOL (consume system text)

;        DEFB #47,#0A,#0D,#0A,#18,#2F,#53,#17,".",#6C,#65,#15,"   1k   " ; G..../S.le.
        DEFB #47                        ; consumed by SYMBOL
        DEFB #0A,#0D,#0A                ; LF+CR+LF
        DEFB #18                        ; invert video
        DEFB #2F,#53                    ; print "/S"
        DEFB #17,"."                    ; graphic mode on (consume ".")
        DEFB #6C,#65                    ; print "le"
        DEFB #15                        ; echo off

;        DEFB #06,#65,#70,#20,#6D,#6F,#64,#17,".",#65,#20,#19,"   1k   " ; .ep mod.e .
        DEFB #06                        ; echo on
        DEFB #65,#70,#20,#6D,#6F,#64    ; print "ep mod"
        DEFB #17,"."                    ; graphic mode on (consume ".")
        DEFB #65,#20                    ; print "e "
        DEFB #19,"   1k   "             ; SYMBOL (consume system text)
        
;        DEFB #48,#4F,#66,#66,#14,#14,#14,#17,".",#14,#14,#18,"   1k   ",#0D,#0A ; HOff.......
        DEFB #48                        ; consumed by SYMBOL
        DEFB #4F,#66,#66,#14,#14,#14    ; print "Off..."
        DEFB #17,"."                    ; graphic mode on (consume ".")
        DEFB #14,#14                    ; print ".."
        DEFB #18                        ; invert video (?!?)
        DEFB "   1k   ",#0D,#0A
        
        DEFB #18,#14,#2F,#41,#75,#74,#6F,#17,".",#63,#68,#19,"   1k   " ; ../Auto.ch.
        
        DEFB #49,#65,#63,#6B,#20,#70,#72,#17,".",#6F,#63,#15,"   1k   " ; Ieck pr.oc.
        
        DEFB #1B,#06,#65,#64,#75,#72,#65,#17,".",#14,#14,#19,"   1k   " ; ..edure....
        
        DEFB #4A,#14,#14,#14,#14,#14,#14,#17,".",#14,#14,#18,"   1k   ",#0D,#0A ; J..........
        
        DEFB #1B,#18,#50,#6F,#77,#65,#72,#14,".",#14,#14,#19,"   1k   " ; ..Power....
        
        DEFB #4B,#2E,#14,#14,#2E,#14,#14,#14,".",#14,#14,#15,"   1k   " ; K..........
        
        DEFB #22,#06,#2E,#6F,#6B,#0A,#0D,#17,".",#53,#68,#19,"   1k   " ; "..ok...Sh.
        
        DEFB #4C,#69,#65,#6C,#64,#14,#14,#14,".",#14,#14,#15,"   1k   " ; Lield......
        
        DEFB #23,#06,#2E,#14,#2E,#14,#14,#14,".",#6F,#6B,#19,"   1k   " ; #.......ok.
        
        DEFB #4D,#0A,#0D,#57,#65,#61,#70,#17,".",#6F,#6E,#15,"   1k   " ; M..Weap.on.
        
        DEFB #24,#06,#73,#2E,#14,#2E,#14,#14,".",#14,#6F,#19,"   1k   " ; $.s......o.
        
        DEFB #4D,#6B,#0A,#0D,#48,#75,#6C,#6C,".",#14,#14,#15,"   1k   " ; Mk..Hull...
        
        DEFB #25,#06,#14,#14,#2E,#14,#14,#14,".",#14,#14,#19,"   1k   " ; %..........
        
        DEFB #4E,#14,#2E,#14,#14,#2E,#14,#14,".",#14,#14,#15,"   1k   " ; N..........
        
        DEFB #26,#06,#6F,#6B,#0A,#0D,#2F,#17,".",#44,#6F,#19,"   1k   " ; &.ok../.Do.
        
        DEFB #4F,#6E,#65,#0A,#0A,#0D,#3E,#17,".",#14,#14,#15,"   1k   " ; One...>....
        
        DEFB #27,#06,#14,#14,#14,#14,#14,#17,".",#14,#14,#19,"   1k   " ; ''..........
        
        DEFB #50,#14,#14,#14,#14,#14,#14,#17,".",#74,#14,#15,"   1k   " ; P.......t..
        
        DEFB #28,#06,#14,#61,#14,#14,#14,#17,".",#14,#72,#19,"   1k   " ; (..a.....r.
        
        DEFB #51,#14,#14,#14,#14,#14,#67,#17,".",#14,#68,#15,"   1k   " ; Q.....g..h.
        
        DEFB #29,#06,#14,#14,#14,#14,#08,#17,".",#14,#65,#19,"   1k   " ; )........e.
        
        DEFB #52,#14,#14,#14,#14,#74,#20,#17,".",#14,#14,#15,"   1k   " ; R....t ....
        
        DEFB #2A,#06,#41,#14,#14,#14,#14,#37,".",#14,#14,#19,"   1k   " ; *.A....7...
        
        DEFB #53,#14,#35,#14,#14,#14,#57,#17,".",#14,#14,#18,"   1k   ",#0D,#0A ; S.5...W....
        
        DEFB #2B,#18,#08,#2F,#53,#63,#61,#17,".",#6E,#6E,#19,"   1k   " ; +../Sca.nn.
        
        DEFB #54,#69,#6E,#67,#14,#14,#14,#17,".",#14,#14,#15,"   1k   ",#0D,#0A ; Ting.......
        
        DEFB #2C,#06,#1A,#09,#7F,#0B,#30,#14,".",#14,#14,#19,"   1k   " ; ,.....0....
        
        DEFB #55,#14,#14,#14,#2E,#14,#14,#14,".",#14,#14,#15,"   1k   ",#0D,#0A ; U..........
        
        DEFB #2D,#06,#14,#0C,#14,#14,#14,#14,".",#14,#14,#19,"   1k   " ; -..........
        
        DEFB #56,#14,#14,#2E,#14,#14,#14,#14,".",#14,#14,#15,"   1k   ",#0D,#0A ; V..........
        
        DEFB #2E,#06,#14,#0C,#14,#14,#14,#14,".",#14,#14,#19,"   1k   " ; ...........
        
        DEFB #57,#14,#14,#2E,#14,#14,#14,#14,".",#14,#14,#15,"   1k   ",#0D,#0A ; W..........
        
        DEFB #2F,#06,#14,#14,#1A,#00,#50,#0C,".",#2F,#14,#19,"   1k   " ; /.....P./..
        
        DEFB #58,#41,#63,#71,#75,#69,#72,#17,".",#65,#64,#18,"   1k   ",#0D,#0A ; XAcquir.ed.
        
        DEFB #30,#18,#0A,#0D,#3E,#14,#14,#17,".",#14,#14,#19,"   1k   " ; 0...>......
        
        DEFB #59,#14,#14,#14,#14,#14,#6A,#17,".",#14,#14,#15,"   1k   ",#0D,#0A ; Y.....j....
        
        DEFB #31,#06,#14,#14,#14,#14,#14,#17,".",#75,#14,#19,"   1k   " ; 1.......u..
        
        DEFB #5A,#14,#14,#14,#14,#14,#6D,#17,".",#14,#14,#15,"   1k   ",#0D,#0A ; Z.....m....
        
        DEFB #32,#06,#14,#70,#14,#14,#14,#17,".",#14,#14,#19,"   1k   " ; 2..p.......
        
        DEFB #5B,#0A,#0D,#2F,#48,#79,#70,#17,".",#65,#72,#15,"   1k   ",#0D,#0A ; [../Hyp.er.
        
        DEFB #33,#06,#73,#70,#61,#63,#65,#17,".",#20,#65,#19,"   1k   " ; 3.space. e.
        
        DEFB #5C,#6E,#67,#61,#67,#65,#64,#17,".",#14,#14,#18,"   1k   ",#0D,#0A ; \ngaged....
        
        DEFB #34,#08,#18,#2F,#14,#14,#14,#17,".",#14,#14,#19,"   1k   " ; 4../.......
        
        DEFB #5D,#14,#14,#14,#14,#14,#14,#17,".",#14,#14,#15,"   1k   ",#0D,#0A ; ]..........
        
        DEFB #37,#06,#14,#14,#14,#14,#14,#17,".",#14,#14,#19,"   1k   " ; 7..........
        
        DEFB #5E,#14,#14,#14,#14,#52,#65,#17,".",#61,#19,#00,"   1k   " ; ^....Re.a..
        
        DEFB #38,#64,#79,#20,#74,#6F,#20,#17,".",#6C,#61,#19,"   1k   " ; 8dy to .la.
        
        DEFB #5F,#75,#6E,#63,#68,#20,#61,#17,".",#66,#74,#15,"   1k   " ; _unch a.ft.
        
        DEFB #39,#06,#65,#72,#20,#43,#4F,#17,".",#50,#59,#19,"   1k   " ; 9.er CO.PY.
        
        DEFB #60,#69,#6E,#67,#20,#74,#68,#17,".",#65,#20,#15,"   1k   " ; `ing th.e .
        
        DEFB #3A,#06,#66,#6F,#6C,#6C,#6F,#17,".",#77,#69,#19,"   1k   " ; :.follo.wi.
        
        DEFB #61,#6E,#67,#20,#6B,#65,#79,#17,".",#3A,#19,#00,"   1k   " ; ang key.:..
        
        DEFB #3B,#0A,#0D,#3E,#20,#20,#00,#52,".",#08,#50,#19,"   1k   " ; ;..>  .R.P.
        
        DEFB #62,#55,#31,#08,#4C,#4E,#41,#08,".",#00,#22,#15,"   1k   " ; bU1.LNA..".
        
        DEFB #3C,#06,#34,#08,#75,#4F,#46,#08,".",#52,#2D,#19,"   1k   " ;  <.4.uOF.R-.
        
        DEFB #63,#08,#44,#49,#53,#08,#3D,#4F,".",#08,#57,#15,"   1k   " ; c.DIS.=O.W.
        
        DEFB #3D,#06,#4E,#36,#08,#37,#1A,#01,".",#10,#20,#15,"   1k   " ; =.N6.7... .
        
        DEFB #FF


; Track 00, sectors #C1-#C4 dump:
;
; 0000:0200 | 00 4F 52 49  4F 4E 20 20  20 A0 A0 20  00 00 00 10 | .ORION      ....
; 0000:0210 | 02 03 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0220 | 00 44 1C 01  16 16 0B 0D  20 4E 19 00  E5 E5 E5 E5 | .D...... N..åååå
; 0000:0230 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0240 | 00 06 61 76  43 6F 6D 53  17 79 73 19  E5 E5 E5 E5 | ..avComS.ys.åååå
; 0000:0250 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0260 | 00 47 0A 0D  0A 18 2F 53  17 6C 65 15  E5 E5 E5 E5 | .G..../S.le.åååå
; 0000:0270 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0280 | 00 06 65 70  20 6D 6F 64  17 65 20 19  E5 E5 E5 E5 | ..ep mod.e .åååå
; 0000:0290 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:02A0 | 00 48 4F 66  66 14 14 14  17 14 14 18  E5 E5 E5 E5 | .HOff.......åååå
; 0000:02B0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:02C0 | 00 18 14 2F  41 75 74 6F  17 63 68 19  E5 E5 E5 E5 | .../Auto.ch.åååå
; 0000:02D0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:02E0 | 00 49 65 63  6B 20 70 72  17 6F 63 15  E5 E5 E5 E5 | .Ieck pr.oc.åååå
; 0000:02F0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0300 | 00 1B 06 65  64 75 72 65  17 14 14 19  E5 E5 E5 E5 | ...edure....åååå
; 0000:0310 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0320 | 00 4A 14 14  14 14 14 14  17 14 14 18  E5 E5 E5 E5 | .J..........åååå
; 0000:0330 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0340 | 00 1B 18 50  6F 77 65 72  14 14 14 19  E5 E5 E5 E5 | ...Power....åååå
; 0000:0350 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0360 | 00 4B 2E 14  14 2E 14 14  14 14 14 15  E5 E5 E5 E5 | .K..........åååå
; 0000:0370 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0380 | 00 22 06 2E  6F 6B 0A 0D  17 53 68 19  E5 E5 E5 E5 | ."..ok...Sh.åååå
; 0000:0390 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:03A0 | 00 4C 69 65  6C 64 14 14  14 14 14 15  E5 E5 E5 E5 | .Lield......åååå
; 0000:03B0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:03C0 | 00 23 06 2E  14 2E 14 14  14 6F 6B 19  E5 E5 E5 E5 | .#.......ok.åååå
; 0000:03D0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:03E0 | 00 4D 0A 0D  57 65 61 70  17 6F 6E 15  E5 E5 E5 E5 | .M..Weap.on.åååå
; 0000:03F0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 
; 0000:0600 | 00 24 06 73  2E 14 2E 14  14 14 6F 19  E5 E5 E5 E5 | .$.s......o.åååå
; 0000:0610 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0620 | 00 4D 6B 0A  0D 48 75 6C  6C 14 14 15  E5 E5 E5 E5 | .Mk..Hull...åååå
; 0000:0630 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0640 | 00 25 06 14  14 2E 14 14  14 14 14 19  E5 E5 E5 E5 | .%..........åååå
; 0000:0650 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0660 | 00 4E 14 2E  14 14 2E 14  14 14 14 15  E5 E5 E5 E5 | .N..........åååå
; 0000:0670 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0680 | 00 26 06 6F  6B 0A 0D 2F  17 44 6F 19  E5 E5 E5 E5 | .&.ok../.Do.åååå
; 0000:0690 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:06A0 | 00 4F 6E 65  0A 0A 0D 3E  17 14 14 15  E5 E5 E5 E5 | .One...>....åååå
; 0000:06B0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:06C0 | 00 27 06 14  14 14 14 14  17 14 14 19  E5 E5 E5 E5 | .''..........åååå
; 0000:06D0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:06E0 | 00 50 14 14  14 14 14 14  17 74 14 15  E5 E5 E5 E5 | .P.......t..åååå
; 0000:06F0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0700 | 00 28 06 14  61 14 14 14  17 14 72 19  E5 E5 E5 E5 | .(..a.....r.åååå
; 0000:0710 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0720 | 00 51 14 14  14 14 14 67  17 14 68 15  E5 E5 E5 E5 | .Q.....g..h.åååå
; 0000:0730 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0740 | 00 29 06 14  14 14 14 08  17 14 65 19  E5 E5 E5 E5 | .)........e.åååå
; 0000:0750 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0760 | 00 52 14 14  14 14 74 20  17 14 14 15  E5 E5 E5 E5 | .R....t ....åååå
; 0000:0770 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0780 | 00 2A 06 41  14 14 14 14  37 14 14 19  E5 E5 E5 E5 | .*.A....7...åååå
; 0000:0790 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:07A0 | 00 53 14 35  14 14 14 57  17 14 14 18  E5 E5 E5 E5 | .S.5...W....åååå
; 0000:07B0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:07C0 | 00 2B 18 08  2F 53 63 61  17 6E 6E 19  E5 E5 E5 E5 | .+../Sca.nn.åååå
; 0000:07D0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:07E0 | 00 54 69 6E  67 14 14 14  17 14 14 15  E5 E5 E5 E5 | .Ting.......åååå
; 0000:07F0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00    | ...............
; 
; 0000:0A00 | 00 2C 06 1A  09 7F 0B 30  14 14 14 19  E5 E5 E5 E5 | .,.....0....åååå
; 0000:0A10 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0A20 | 00 55 14 14  14 2E 14 14  14 14 14 15  E5 E5 E5 E5 | .U..........åååå
; 0000:0A30 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0A40 | 00 2D 06 14  0C 14 14 14  14 14 14 19  E5 E5 E5 E5 | .-..........åååå
; 0000:0A50 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0A60 | 00 56 14 14  2E 14 14 14  14 14 14 15  E5 E5 E5 E5 | .V..........åååå
; 0000:0A70 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0A80 | 00 2E 06 14  0C 14 14 14  14 14 14 19  E5 E5 E5 E5 | ............åååå
; 0000:0A90 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0AA0 | 00 57 14 14  2E 14 14 14  14 14 14 15  E5 E5 E5 E5 | .W..........åååå
; 0000:0AB0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0AC0 | 00 2F 06 14  14 1A 00 50  0C 2F 14 19  E5 E5 E5 E5 | ./.....P./..åååå
; 0000:0AD0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0AE0 | 00 58 41 63  71 75 69 72  17 65 64 18  E5 E5 E5 E5 | .XAcquir.ed.åååå
; 0000:0AF0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0B00 | 00 30 18 0A  0D 3E 14 14  17 14 14 19  E5 E5 E5 E5 | .0...>......åååå
; 0000:0B10 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0B20 | 00 59 14 14  14 14 14 6A  17 14 14 15  E5 E5 E5 E5 | .Y.....j....åååå
; 0000:0B30 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0B40 | 00 31 06 14  14 14 14 14  17 75 14 19  E5 E5 E5 E5 | .1.......u..åååå
; 0000:0B50 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0B60 | 00 5A 14 14  14 14 14 6D  17 14 14 15  E5 E5 E5 E5 | .Z.....m....åååå
; 0000:0B70 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0B80 | 00 32 06 14  70 14 14 14  17 14 14 19  E5 E5 E5 E5 | .2..p.......åååå
; 0000:0B90 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0BA0 | 00 5B 0A 0D  2F 48 79 70  17 65 72 15  E5 E5 E5 E5 | .[../Hyp.er.åååå
; 0000:0BB0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0BC0 | 00 33 06 73  70 61 63 65  17 20 65 19  E5 E5 E5 E5 | .3.space. e.åååå
; 0000:0BD0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0BE0 | 00 5C 6E 67  61 67 65 64  17 14 14 18  E5 E5 E5 E5 | .\ngaged....åååå
; 0000:0BF0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00    | ...............
; 
; 0000:0E00 | 00 34 08 18  2F 14 14 14  17 14 14 19  E5 E5 E5 E5 | .4../.......åååå
; 0000:0E10 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0E20 | 00 5D 14 14  14 14 14 14  17 14 14 15  E5 E5 E5 E5 | .]..........åååå
; 0000:0E30 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0E40 | 00 37 06 14  14 14 14 14  17 14 14 19  E5 E5 E5 E5 | .7..........åååå
; 0000:0E50 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0E60 | 00 5E 14 14  14 14 52 65  17 61 19 00  E5 E5 E5 E5 | .^....Re.a..åååå
; 0000:0E70 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0E80 | 00 38 64 79  20 74 6F 20  17 6C 61 19  E5 E5 E5 E5 | .8dy to .la.åååå
; 0000:0E90 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0EA0 | 00 5F 75 6E  63 68 20 61  17 66 74 15  E5 E5 E5 E5 | ._unch a.ft.åååå
; 0000:0EB0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0EC0 | 00 39 06 65  72 20 43 4F  17 50 59 19  E5 E5 E5 E5 | .9.er CO.PY.åååå
; 0000:0ED0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0EE0 | 00 60 69 6E  67 20 74 68  17 65 20 15  E5 E5 E5 E5 | .`ing th.e .åååå
; 0000:0EF0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0F00 | 00 3A 06 66  6F 6C 6C 6F  17 77 69 19  E5 E5 E5 E5 | .:.follo.wi.åååå
; 0000:0F10 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0F20 | 00 61 6E 67  20 6B 65 79  17 3A 19 00  E5 E5 E5 E5 | .ang key.:..åååå
; 0000:0F30 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0F40 | 00 3B 0A 0D  3E 20 20 00  52 08 50 19  E5 E5 E5 E5 | .;..>  .R.P.åååå
; 0000:0F50 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0F60 | 00 62 55 31  08 4C 4E 41  08 00 22 15  E5 E5 E5 E5 | .bU1.LNA..".åååå
; 0000:0F70 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0F80 | 00 3C 06 34  08 75 4F 46  08 52 2D 19  E5 E5 E5 E5 | .<.4.uOF.R-.åååå
; 0000:0F90 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0FA0 | 00 63 08 44  49 53 08 3D  4F 08 57 15  E5 E5 E5 E5 | .c.DIS.=O.W.åååå
; 0000:0FB0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0FC0 | 00 3D 06 4E  36 08 37 1A  01 10 20 15  E5 E5 E5 E5 | .=.N6.7... .åååå
; 0000:0FD0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................
; 0000:0FE0 | 00 04 02 1D  00 00 0E 01  0F 16 01 1C  E5 E5 E5 E5 | ............åååå
; 0000:0FF0 | 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00 | ................


; Control codes:
;
; #00 : n''affiche et ne fait rien
; #01 : le caractère de contrôle suivant est affiché comme un caractère graphique (1 param)
; #02 : rend le curseur invisible
; #03 : affiche le curseur
; #04 : mode (1 param)
; #05 : permet d''afficher une ligne horizontale ayant pour trame la configuration binaire du caractère
;       passé en paramètre. La valeur 170 aura pour effet de tracer des pointillés (1 param)
; #06 : affichage autorisé
; #07 : cloche
; #08 : recule le curseur et nettoie la place
; #09 : déplacement du curseur d''un caractère vers la droite
; #0A : idem vers le bas
; #0B : pour changer, vers le haut
; #0C : effacement de l''écran
; #0D : retour chariot, carriage return. Le curseur vient se positionner en début de ligne.
; #0E : couleur de fond de l''écran. Le caractère suivant doit être un code entre 0 et 15 (1 param)
; #0F : couleur d''encre. Prend en paramètre le même type d''argument que le précédent (1 param)
; #10 : effacement du caractère situé sous le curseur, comme le fait la touche CLR
; #11 : efface la partie de la ligne située avant le curseur, dans la fenêtre courante
; #12 : comme ci-dessus, mais après le curseur
; #13 : efface toute la zone située entre le coin haut gauche et le curseur de la fenêtre courante.
; #14 : comme ci-dessus, mais du curseur au coin bas droit
; #15 : interdiction d''affichage
; #16 : mode d''affichage OR. Si vous lancez #16 00, l''affichage se fera comme à l''habitude.
;       Si, en revanche, c''est #16 01 qui est rencontré, le fait d''afficher un caractère sur un autre
;       provoquera une superposition des deux (1 param)
; #17 : positionne le mode d''écriture graphique (1 param)
; #18 : vidéo inverse. PAPER devient PEN et vice versa
; #19 : redéfinition de caractère, en la faisant suivre de 9 caractères représentant le code et la
;       matrice à modifier (9 params)
; #1A : définition des limites de la fenêtre active. Comme WINDOW en Basic, #1A permet de créer une et
;       une seule fenêtre. Les quatre paramètres à passer sont la ligne et la colonne du coin haut droit,
;       suivies de la largeur et de la hauteur de la fenêtre (4 params)
; #1B : encore un truc qui ne fait rien ou dont les possibilités me sont passées inaperçues
; #1C : modification de la couleur d''encre (2 params)
; #1D : changement des couleurs de bord (2 params)
; #1E : positionnement du curseur dans le coin haut gauche de l''écran
; #1F : positionnement du curseur sur l''écran, col et ligne (2 params)
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
