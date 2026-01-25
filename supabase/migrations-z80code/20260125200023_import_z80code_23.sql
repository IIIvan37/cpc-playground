-- Migration: Import z80code projects batch 23
-- Projects 45 to 46
-- Generated: 2026-01-25T21:43:30.186805

-- Project 45: cubegrospixels by demoniak
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'cubegrospixels',
    'Imported from z80Code. Author: demoniak. Rotation d''un cube fais avec de "gros" pixels ;-)',
    'public',
    false,
    false,
    '2021-06-04T17:15:44.311000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '        ORG     #8000
        run     $
;
;
; Tracé de lignes avec de "gros" points (résolution de 80x50 point)
; Un point = 4x4 pixels mode 1 (4 octets verticaux)
;
; 4 types de lignes possibles :
; - Type A = descendante, xd>=yd
; - Type B = montante, xd>=yd
; - Type C = descendante, xd<=yd
; - Type D = montante, xd<=yd
;
;
        DI
        LD      HL,#4000
        LD      DE,#4001
        LD      BC,#3FCF
        LD      (HL),L
        LDIR
        LD      HL,#C000
        LD      DE,#C001
        LD      BC,#3FCF
        LD      (HL),L
        LDIR
        LD      DE,Datas
        LD      (PtrAffiche+2),DE
        LD      HL,Vide                 ; Au départ, on efface rien
        LD      (PtrEfface+2),HL
		; Début boucle principale => effacer ancienne image
PtrEfface:
        LD      IX,Vide
SetDblBuffer:
        LD      A,#BC                   ; Trace en #40 (RES 7,H)
        LD      (DrawLigne+1),A
        LD      BC,#BC0C
        OUT     (C),C
        XOR     #DC
        RRCA
        INC     B
        OUT     (C),A                   ; Affiche #C0
        RLCA
        XOR     #9C                     ; Inverser le code SET/RES
        LD      (SetDblBuffer+1),A

        LD      A,#10
        LD      BC,#7F54
        OUT     (C),A
        OUT     (C),C

        LD      B,#F5
SyncVBL:
        IN      A,(C)
        RRA
        JR      NC,SyncVBL
		
        LD      BC,#7F4B
        OUT     (C),C

        LD      D,#00                 ; 0 = effacer (pas de pixels)
        CALL    AfficheTrame
        LD      A,B
        OR      C
        JR      NZ,SetPtrEfface
        LD      IX,Datas              ; Remise au début des données
SetPtrEfface:
        LD      (PtrEfface+2),IX
PtrAffiche:
        LD      IX,Datas
        LD      D,#F0                 ; F0 = 4 pixels en pen 1
        CALL    AfficheTrame
        LD      A,B
        OR      C
        JR      NZ,SetPtrAffiche
        LD      IX,Datas
SetPtrAffiche:
        LD      (PtrAffiche+2),IX
        JR      PtrEfface

AfficheTrame:
        LD      H,(IX+1)
        LD      L,(IX+0)
        LD      B,(IX+3)
        LD      C,(IX+2)
        INC     IX
        INC     IX
        LD      A,H
        OR      L
        RET     Z
        INC     IX
        INC     IX
 
DrawLigne:
        SET     7,H                     ; #CB-#BC = RES #CB-#FC = SET
        LD      A,H
        RES     4,H
        RES     3,H
        LD      E,B
        LD      (DrawLigneFin+1),SP
;
;    HL = adresse du point
;    B = E = dy
;    C = dx
;    D = couleur
;
        AND     #18
        JR      Z,DrawLigneTypeA
        SUB     #08
        JR      Z,DrawLigneTypeB
        SUB     #08
        JR      Z,DrawLigneTypeC

        LD      SP,#1FB0
DrawLigneTypeD1:
        LD      (HL),D
        SET     3,H
        LD      (HL),D
        SET     4,H
        LD      (HL),D
        RES     3,H
        LD      (HL),D
        RES     4,H
        BIT     5,H                     ; Tester BIT 5 HL
        RES     5,H                     ; Remise à zéro BIT 5 HL
        JR      NZ,DrawLigneTypeD2      ; Si pas déjà à zéro, OK
        ADD     HL,SP
DrawLigneTypeD2:
        ADD     A,C                     ; D = D + DX
        JR      C,DrawLigneTypeDDX2
        CP      E                       ; D >= DY ?
        JR      C,DrawLigneTypeD3
DrawLigneTypeDDX2:
        SUB     E
        INC     HL
DrawLigneTypeD3:
        DJNZ    DrawLigneTypeD1
        JR      DrawLigneFin

DrawLigneTypeC:
        LD      SP,#E050
DrawLigneTypeC1:
        LD      (HL),D
        SET     3,H
        LD      (HL),D
        SET     4,H
        LD      (HL),D
        RES     3,H
        LD      (HL),D
        RES     4,H
        BIT     5,H                     ; Tester BIT 5 HL
        SET     5,H                     ; Positionner BIT 5 HL
        JR      Z,DrawLigneTypeC2       ; Si pas déjà positionné, OK
        ADD     HL,SP
DrawLigneTypeC2:
        ADD     A,C                     ; D = D + DX
        JR      C,DrawLigneTypeCDX2
        CP      E                       ; D >= DY ?
        JR      C,DrawLigneTypeC3
DrawLigneTypeCDX2:
        SUB     E
        INC     HL
DrawLigneTypeC3:
        DJNZ    DrawLigneTypeC1
        JR      DrawLigneFin

DrawLigneTypeB:
        LD      SP,#1FB0
DrawLigneTypeB1:
        LD      (HL),D
        SET     3,H
        LD      (HL),D
        SET     4,H
        LD      (HL),D
        RES     3,H
        LD      (HL),D
        RES     4,H
        INC     HL
        ADD     A,C                     ; D = D + DY
        JR      C,DrawLigneTypeBDX1
        CP      E                       ; D >= DX ?
        JR      C,DrawLigneTypeB3
DrawLigneTypeBDX1:
        SUB     E                       ; D = D - DX
        BIT     5,H                     ; Tester BIT 5 HL
        RES     5,H                     ; Remise à zéro BIT 5 HL
        JR      NZ,DrawLigneTypeB3      ; Si pas déjà à zéro, OK
        ADD     HL,SP
DrawLigneTypeB3:
        DJNZ    DrawLigneTypeB1
        JR      DrawLigneFin

DrawLigneTypeA:
        LD      SP,#E050
DrawLigneTypeA1:
        LD      (HL),D
        SET     3,H
        LD      (HL),D
        SET     4,H
        LD      (HL),D
        RES     3,H
        LD      (HL),D
        RES     4,H
        INC     HL
        ADD     A,C                     ; D = D + DY
        JR      C,DrawLigneTypeADX1
        CP      E                       ; D >= DX ?
        JR      C,DrawLigneTypeA3
DrawLigneTypeADX1:
        SUB     E                       ; D = D - DX
        BIT     5,H                     ; Tester BIT 5 HL
        SET     5,H                     ; Positionner BIT 5 HL
        JR      Z,DrawLigneTypeA3       ; Si pas déjà positionné, OK
        ADD     HL,SP
DrawLigneTypeA3:
        DJNZ    DrawLigneTypeA1
DrawLigneFin:
        LD      SP,0
        JP	AfficheTrame


vide:
        DW      #C101, #0100, #0000, #C101, #0100, #0000, #0000
datas:
; Frame 0
        DW      #C339, #1C00
        DW      #C4C9, #1E00
        DW      #D33A, #1701
        DW      #D355, #1701
        DW      #D4C8, #0D02
        DW      #DB54, #0F02
        DW      #E0B9, #1E00
        DW      #E6A9, #1C00
        DW      #F0B8, #0F02
        DW      #F0B9, #1901
        DW      #F0D6, #1901
        DW      #FEC4, #0D02
        DW      #00

; Frame 1
        DW      #D127, #1902
        DW      #D353, #1802
        DW      #DB52, #0E05
        DW      #DF13, #0D05
        DW      #E0BB, #1D01
        DW      #E2E7, #1C01
        DW      #E47B, #1E02
        DW      #E6A7, #1D01
        DW      #F0BB, #1801
        DW      #F2E8, #1801
        DW      #FAE8, #0E04
        DW      #FEA8, #0E04
        DW      #00

; Frame 2
        DW      #C0BD, #1C03
        DW      #C2E6, #1B03
        DW      #C6A6, #1C03
        DW      #D0BD, #1901
        DW      #D2E7, #1801
        DW      #DAE7, #0E07
        DW      #DEA7, #0D07
        DW      #E47D, #1D03
        DW      #F128, #1902
        DW      #F351, #1802
        DW      #FB50, #0E08
        DW      #FF11, #0D08
        DW      #00

; Frame 3
        DW      #D179, #1902
        DW      #E06F, #1B05
        DW      #E295, #1A04
        DW      #E47F, #1C04
        DW      #E655, #1B04
        DW      #F06F, #1A01
        DW      #F296, #1801
        DW      #F34F, #1802
        DW      #FA96, #0E0A
        DW      #FB4E, #0D0B
        DW      #FE56, #0C0A
        DW      #FF0F, #0C0B
        DW      #00

; Frame 4
        DW      #C654, #1A05
        DW      #CE55, #0D0B
        DW      #E071, #1A06
        DW      #E244, #1906
        DW      #E481, #1B05
        DW      #EA45, #0D0C
        DW      #EB4C, #0E0C
        DW      #EF0D, #0E0B
        DW      #F071, #1A01
        DW      #F17A, #1902
        DW      #F245, #1901
        DW      #F34D, #1802
        DW      #00

; Frame 5
        DW      #C243, #1806
        DW      #CA44, #100B
        DW      #CB4A, #110A
        DW      #D1CB, #1901
        DW      #D244, #1901
        DW      #D34B, #1902
        DW      #E073, #1907
        DW      #E484, #1806
        DW      #E603, #1906
        DW      #EE04, #110A
        DW      #EF0B, #100A
        DW      #F073, #1A02
        DW      #00

; Frame 6
        DW      #C4D6, #1706
        DW      #C603, #1607
        DW      #CB48, #1309
        DW      #CE04, #1308
        DW      #D349, #1901
        DW      #E075, #1708
        DW      #E1F3, #1607
        DW      #E9F4, #120A
        DW      #EF08, #1409
        DW      #F075, #1B02
        DW      #F1CB, #1902
        DW      #F1F4, #1901
        DW      #00

; Frame 7
        DW      #C0C8, #1408
        DW      #C4D8, #1408
        DW      #C603, #1406
        DW      #CE04, #1508
        DW      #CF06, #1506
        DW      #D0C8, #1A01
        DW      #D21B, #1A01
        DW      #E1A3, #1408
        DW      #E9A4, #1507
        DW      #EAF6, #1507
        DW      #F1A4, #1B01
        DW      #F2F7, #1901
        DW      #00

; Frame 8
        DW      #C0CA, #1209
        DW      #C1A3, #1208
        DW      #C9A4, #1706
        DW      #CAF4, #1705
        DW      #CF04, #1705
        DW      #D0CA, #1B01
        DW      #D2F5, #1A01
        DW      #E4DA, #1208
        DW      #E5B2, #1307
        DW      #EDB3, #1806
        DW      #F21B, #1A01
        DW      #FDB2, #1B02
        DW      #00

; Frame 9
        DW      #C5B3, #1007
        DW      #CDB4, #1903
        DW      #DDB3, #1B02
        DW      #DE79, #1B02
        DW      #E0CD, #0F08
        DW      #E154, #1008
        DW      #E52C, #0F07
        DW      #E955, #1904
        DW      #EAA3, #1804
        DW      #EEB2, #1803
        DW      #FD2B, #1C02
        DW      #FEB2, #1A02
        DW      #00

; Frame 10
        DW      #C11F, #0D08
        DW      #C155, #0D08
        DW      #C57D, #0D07
        DW      #C956, #1A02
        DW      #CAA1, #1A02
        DW      #CEAF, #1A01
        DW      #DD7C, #1C03
        DW      #DEAF, #1A03
        DW      #E563, #0D07
        DW      #ED64, #1A01
        DW      #FD63, #1B03
        DW      #FE78, #1B03
        DW      #00

; Frame 11
        DW      #C171, #0A06
        DW      #C250, #1A00
        DW      #C5CF, #0A05
        DW      #DDCE, #1C03
        DW      #E106, #0B07
        DW      #E107, #1B01
        DW      #E563, #0B06
        DW      #E564, #1C01
        DW      #E65D, #1B00
        DW      #FD63, #1C04
        DW      #FE5D, #1B04
        DW      #FE77, #1B03
        DW      #00

; Frame 12
        DW      #DEC6, #1B04
        DW      #E107, #0906
        DW      #E108, #1C02
        DW      #E173, #0806
        DW      #E1FF, #1B02
        DW      #E563, #0904
        DW      #E564, #1D02
        DW      #E5D0, #0805
        DW      #E60B, #1C03
        DW      #FD63, #1C05
        DW      #FDCF, #1C04
        DW      #FE0B, #1A05
        DW      #00

; Frame 13
        DW      #C609, #1C04
        DW      #DE09, #1B06
        DW      #DEC4, #1B05
        DW      #E109, #0604
        DW      #E10A, #1C04
        DW      #E1AE, #1B04
        DW      #E1C5, #0504
        DW      #E564, #0603
        DW      #E565, #1D04
        DW      #E621, #0503
        DW      #FD64, #1C06
        DW      #FE20, #1C05
        DW      #00

; Frame 14
        DW      #C5B7, #1C06
        DW      #C671, #0302
        DW      #D217, #0303
        DW      #DDB7, #1B07
        DW      #DE70, #1C07
        DW      #DEC2, #1B07
        DW      #E10B, #0302
        DW      #E10C, #1C05
        DW      #E15D, #1C06
        DW      #E564, #0401
        DW      #E565, #1D05
        DW      #FD64, #1C08
        DW      #00

; Frame 15
        DW      #C15D, #1B07
        DW      #C566, #1B07
        DW      #DD66, #1A08
        DW      #DEC1, #1C08
        DW      #E10C, #0201
        DW      #E10D, #1D07
        DW      #E566, #1D07
        DW      #E670, #0201
        DW      #EA67, #0201
        DW      #ED65, #0201
        DW      #FD65, #1C08
        DW      #FE70, #1A08
        DW      #00

; Frame 16
        DW      #C10D, #1B09
        DW      #C15F, #1C08
        DW      #C514, #1B09
        DW      #D10E, #0202
        DW      #D515, #0303
        DW      #DD14, #1A0A
        DW      #E267, #0301
        DW      #E567, #1C08
        DW      #E66E, #0402
        DW      #FD66, #1B09
        DW      #FE6E, #1A0A
        DW      #FEC1, #1B09
        DW      #00

; Frame 17
        DW      #C266, #0605
        DW      #C4C3, #1A0A
        DW      #D4C4, #0504
        DW      #D66C, #0505
        DW      #DCC3, #190B
        DW      #DE6C, #1A0B
        DW      #E0BD, #1A09
        DW      #E161, #1C0A
        DW      #E567, #1B0A
        DW      #F0BE, #0404
        DW      #FD66, #1A0B
        DW      #FF10, #1A0C
        DW      #00

; Frame 18
        DW      #C1B3, #1B0B
        DW      #C472, #190A
        DW      #C5B7, #1B0A
        DW      #D266, #0707
        DW      #D473, #0805
        DW      #D61A, #0807
        DW      #DC72, #190D
        DW      #DDB6, #1A0D
        DW      #DE1A, #180D
        DW      #DF60, #190D
        DW      #E06E, #190B
        DW      #F06F, #0705
        DW      #00

; Frame 19
        DW      #C06E, #190B
        DW      #C421, #190B
        DW      #C5B8, #190B
        DW      #D06F, #0907
        DW      #D422, #0A07
        DW      #DC21, #180E
        DW      #DDB7, #190E
        DW      #E1B5, #1A0C
        DW      #F216, #0A08
        DW      #F5C9, #0A07
        DW      #FDC9, #180E
        DW      #FF5F, #180F
        DW      #00

; Frame 20
        DW      #C06F, #170B
        DW      #C3D1, #170B
        DW      #D070, #0B08
        DW      #D3D2, #0D07
        DW      #DBD1, #160F
        DW      #DFAE, #1710
        DW      #E207, #180C
        DW      #E5B8, #180B
        DW      #F215, #0C09
        DW      #F577, #0D08
        DW      #FD77, #160F
        DW      #FDB7, #1810
        DW      #00

; Frame 21
        DW      #C380, #160B
        DW      #D215, #0F09
        DW      #D381, #0F08
        DW      #DB80, #1511
        DW      #DFAD, #1511
        DW      #E020, #160B
        DW      #E259, #160C
        DW      #E5B8, #170B
        DW      #F021, #0E09
        DW      #F525, #0F09
        DW      #FD25, #1511
        DW      #FDB7, #1612
        DW      #00

; Frame 22
        DW      #C2FA, #160B
        DW      #C330, #150B
        DW      #C608, #150A
        DW      #CFAB, #1413
        DW      #D215, #110A
        DW      #D331, #1208
        DW      #DB30, #1313
        DW      #DE07, #1413
        DW      #E022, #140B
        DW      #F023, #1108
        DW      #F4D4, #1108
        DW      #FCD4, #1312
        DW      #00

; Frame 23
        DW      #C2E0, #140A
        DW      #C34C, #130B
        DW      #C608, #140A
        DW      #CAE0, #1411
        DW      #CC83, #1411
        DW      #CE07, #1512
        DW      #CFAA, #1411
        DW      #D2E1, #1408
        DW      #D483, #1408
        DW      #E023, #140A
        DW      #F024, #1309
        DW      #F1C6, #1408
        DW      #00

; Frame 24
        DW      #CC32, #150F
        DW      #D432, #1508
        DW      #E024, #130A
        DW      #E290, #1309
        DW      #E39D, #1209
        DW      #E608, #1308
        DW      #EA90, #1510
        DW      #EE07, #1610
        DW      #EF59, #150F
        DW      #F025, #1609
        DW      #F1C6, #1508
        DW      #F291, #1608
        DW      #00

; Frame 25
        DW      #C076, #1109
        DW      #C43D, #1208
        DW      #CF57, #170C
        DW      #D077, #1807
        DW      #E240, #1208
        DW      #E607, #1207
        DW      #EA40, #170D
        DW      #EB91, #160C
        DW      #EE06, #170D
        DW      #F1C6, #1708
        DW      #F241, #1807
        DW      #F391, #1707
        DW      #00

; Frame 26
        DW      #C241, #1107
        DW      #C48E, #1007
        DW      #CA41, #170B
        DW      #D1C7, #1906
        DW      #D242, #1906
        DW      #E077, #1107
        DW      #E607, #1106
        DW      #EB41, #170B
        DW      #EE06, #180B
        DW      #EF06, #170A
        DW      #F078, #1907
        DW      #F341, #1806
        DW      #00

; Frame 27
        DW      #C0C9, #0F06
        DW      #CAF0, #1808
        DW      #CF04, #1908
        DW      #D0CA, #1B05
        DW      #D1C7, #1A06
        DW      #D2F0, #1A05
        DW      #E1F1, #1005
        DW      #E4DE, #1005
        DW      #E606, #1005
        DW      #E9F1, #1909
        DW      #EE05, #1908
        DW      #F1F2, #1A05
        DW      #00

; Frame 28
        DW      #C11A, #0F04
        DW      #C1F2, #1004
        DW      #C57E, #0F03
        DW      #C9F2, #1906
        DW      #CAA1, #1806
        DW      #CEB3, #1905
        DW      #D11B, #1C04
        DW      #D1C8, #1B04
        DW      #D1F3, #1B04
        DW      #D2A1, #1A03
        DW      #E606, #0F03
        DW      #EE05, #1905
        DW      #00

; Frame 29
        DW      #C16B, #0F02
        DW      #C5CD, #0F02
        DW      #CE62, #1902
        DW      #D16C, #1C02
        DW      #D1C9, #1C02
        DW      #E1A3, #0F02
        DW      #E605, #0F01
        DW      #E9A3, #1903
        DW      #EA01, #1903
        DW      #EE04, #1903
        DW      #F1A4, #1C02
        DW      #F201, #1B02
        DW      #00

; Frame 30
        DW      #C1A3, #1001
        DW      #C1A3, #1A00
        DW      #C1BC, #0E01
        DW      #C612, #1800
        DW      #D1A4, #1D01
        DW      #D1BD, #1D01
        DW      #DE13, #1B01
        DW      #DE2A, #1B01
        DW      #E1B2, #1800
        DW      #E603, #1A00
        DW      #EE04, #1001
        DW      #EE1D, #0E01
        DW      #00

; Frame 31
        DW      #C1A4, #1903
        DW      #C5C1, #1903
        DW      #C603, #1903
        DW      #C9A4, #0F01
        DW      #CE04, #0F02
        DW      #DDC2, #1B02
        DW      #DE03, #1C02
        DW      #E162, #1902
        DW      #EA0C, #0F02
        DW      #EE6C, #0F02
        DW      #FE2A, #1C02
        DW      #FE6B, #1C02
        DW      #00

; Frame 32
        DW      #C1A5, #1905
        DW      #C9A5, #0F03
        DW      #E113, #1905
        DW      #E521, #1806
        DW      #E5B2, #1906
        DW      #EA5D, #0F03
        DW      #EDB3, #1004
        DW      #EEBB, #0F04
        DW      #FD22, #1A03
        DW      #FDB2, #1B04
        DW      #FE29, #1B04
        DW      #FEBA, #1C04
        DW      #00

; Frame 33
        DW      #C1A5, #1908
        DW      #C5B1, #1909
        DW      #C9A5, #1005
        DW      #CAFD, #1005
        DW      #CDB2, #1005
        DW      #DDB1, #1A05
        DW      #E0C4, #1908
        DW      #E4D0, #1808
        DW      #EF0A, #0F06
        DW      #FCD1, #1A05
        DW      #FE28, #1A06
        DW      #FF09, #1B05
        DW      #00

; Frame 34
        DW      #C0C6, #170A
        DW      #C1A6, #180B
        DW      #C481, #170B
        DW      #C9A6, #1106
        DW      #CF58, #1107
        DW      #DC82, #1806
        DW      #DF57, #1907
        DW      #E561, #170B
        DW      #EB4D, #1007
        DW      #ED62, #1107
        DW      #FD61, #1906
        DW      #FE28, #1906
        DW      #00

; Frame 35
        DW      #C1A6, #170D
        DW      #C431, #160C
        DW      #C560, #170D
        DW      #C9A6, #1207
        DW      #CD61, #1208
        DW      #DC32, #1707
        DW      #DD60, #1807
        DW      #DE27, #1708
        DW      #E077, #170C
        DW      #EB9C, #1208
        DW      #EF57, #1109
        DW      #FF56, #1807
        DW      #00

; Frame 36
        DW      #C079, #150F
        DW      #C1A7, #1610
        DW      #C510, #1510
        DW      #C9A7, #1308
        DW      #CC3C, #1209
        DW      #CD11, #1309
        DW      #CFA5, #130A
        DW      #DD10, #1608
        DW      #DE27, #1508
        DW      #DFA4, #1609
        DW      #E392, #150F
        DW      #FB93, #1508
        DW      #00

; Frame 37
        DW      #CFA4, #140A
        DW      #DE27, #1408
        DW      #DFA3, #1309
        DW      #E02A, #1411
        DW      #E1A7, #1512
        DW      #E343, #1411
        DW      #E4C0, #1411
        DW      #E9A7, #140A
        DW      #EC8B, #130B
        DW      #ECC1, #140A
        DW      #FB44, #1408
        DW      #FCC0, #1408
        DW      #00

; Frame 38
        DW      #CFA3, #140B
        DW      #D2F4, #1312
        DW      #DAF5, #1108
        DW      #DFA2, #1108
        DW      #E02B, #1413
        DW      #E9A7, #150A
        DW      #EC71, #150B
        DW      #ECD9, #160B
        DW      #F1A7, #1413
        DW      #F470, #1313
        DW      #FC70, #1208
        DW      #FDD6, #110A
        DW      #00

; Frame 39
        DW      #C9F7, #170B
        DW      #CD78, #160C
        DW      #CFA1, #160B
        DW      #D1F7, #1612
        DW      #D2A5, #1511
        DW      #DAA6, #0F09
        DW      #DFA0, #0E09
        DW      #EC21, #160B
        DW      #F02D, #1511
        DW      #F420, #1511
        DW      #FC20, #0F08
        DW      #FDD6, #0F09
        DW      #00

; Frame 40
        DW      #C9F7, #180B
        DW      #CDC6, #180C
        DW      #D1F7, #1810
        DW      #D257, #160F
        DW      #DA58, #0D08
        DW      #DDD6, #0C09
        DW      #EBD2, #170B
        DW      #EF50, #170B
        DW      #F02E, #1710
        DW      #F3D1, #160F
        DW      #FBD1, #0D07
        DW      #FF4F, #0B08
        DW      #00

; Frame 41
        DW      #CE14, #1A0C
        DW      #D07F, #180F
        DW      #D209, #180E
        DW      #DA0A, #0A07
        DW      #DDD7, #0A08
        DW      #E9F7, #190B
        DW      #EB82, #190B
        DW      #EF4F, #190B
        DW      #F1F7, #190E
        DW      #F381, #180E
        DW      #FB81, #0A07
        DW      #FF4E, #0907
        DW      #00

; Frame 42
        DW      #CF4F, #190B
        DW      #DF4E, #0705
        DW      #E9F6, #1B0A
        DW      #EB33, #190A
        DW      #EE12, #1B0B
        DW      #F080, #190D
        DW      #F1BA, #180D
        DW      #F1F6, #1A0D
        DW      #F332, #190D
        DW      #F9BB, #0807
        DW      #FB32, #0805
        DW      #FD87, #0707
        DW      #00

; Frame 43
        DW      #CA46, #1B0A
        DW      #CE60, #1C0A
        DW      #CEFE, #1A09
        DW      #D0D0, #1A0C
        DW      #D246, #1A0B
        DW      #DEFD, #0404
        DW      #EAE4, #1A0A
        DW      #ED87, #0605
        DW      #F16C, #1A0B
        DW      #F2E3, #190B
        DW      #F96D, #0505
        DW      #FAE3, #0504
        DW      #00

; Frame 44
        DW      #C96F, #0402
        DW      #CA46, #1C08
        DW      #CD88, #0301
        DW      #D121, #1B09
        DW      #D16E, #1A0A
        DW      #D246, #1B09
        DW      #EA95, #1B09
        DW      #EE5E, #1C08
        DW      #EEAE, #1B09
        DW      #F294, #1A0A
        DW      #FA94, #0303
        DW      #FEAD, #0202
        DW      #00

; Frame 45
        DW      #C246, #0201
        DW      #C588, #0201
        DW      #C971, #0201
        DW      #CA45, #1D07
        DW      #CEAC, #1D07
        DW      #CEAD, #0201
        DW      #D170, #1A08
        DW      #D245, #1C08
        DW      #EA47, #1B07
        DW      #EE5E, #1B07
        DW      #F121, #1C08
        DW      #F246, #1A08
        DW      #00

; Frame 46
        DW      #CA44, #1D05
        DW      #CA45, #0401
        DW      #CE5E, #1C06
        DW      #CEAB, #1C05
        DW      #CEAC, #0302
        DW      #D244, #1C08
        DW      #E970, #0302
        DW      #E9F8, #1C06
        DW      #F122, #1B07
        DW      #F170, #1C07
        DW      #F1F7, #1B07
        DW      #FDD6, #0303
        DW      #00

; Frame 47
        DW      #C9C0, #0503
        DW      #CA44, #1D04
        DW      #CA45, #0603
        DW      #CE0F, #1B04
        DW      #CE24, #0504
        DW      #CEA9, #1C04
        DW      #CEAA, #0604
        DW      #D1C0, #1C05
        DW      #D244, #1C06
        DW      #E9AA, #1C04
        DW      #F124, #1B05
        DW      #F1A9, #1B06
        DW      #00

; Frame 48
        DW      #C9AC, #1C03
        DW      #CA0F, #0805
        DW      #CA43, #1D02
        DW      #CA44, #0904
        DW      #CDC0, #1B02
        DW      #CE72, #0806
        DW      #CEA7, #1C02
        DW      #CEA8, #0906
        DW      #D1AB, #1A05
        DW      #D20F, #1C04
        DW      #D243, #1C05
        DW      #F126, #1B04
        DW      #00

; Frame 49
        DW      #C15E, #1B00
        DW      #CA43, #1C01
        DW      #CA44, #0B06
        DW      #CEA6, #1B01
        DW      #CEA7, #0B07
        DW      #D15D, #1B04
        DW      #D177, #1B03
        DW      #D243, #1C04
        DW      #E571, #1A00
        DW      #EA0E, #0A05
        DW      #EE70, #0A06
        DW      #F20E, #1C03
        DW      #00

; Frame 50
        DW      #C243, #1A01
        DW      #CA44, #0D07
        DW      #D178, #1B03
        DW      #D243, #1B03
        DW      #E110, #1A01
        DW      #E522, #1A02
        DW      #E655, #1A02
        DW      #EA5C, #0D07
        DW      #EE56, #0D08
        DW      #EEBE, #0D08
        DW      #F10F, #1A03
        DW      #F25C, #1C03
        DW      #00

; Frame 51
        DW      #C113, #1803
        DW      #C524, #1804
        DW      #C654, #1904
        DW      #CAAB, #0F07
        DW      #CE55, #1008
        DW      #CF0C, #0F08
        DW      #D112, #1A02
        DW      #D2AB, #1C02
        DW      #E1F3, #1903
        DW      #E9F4, #1007
        DW      #F179, #1B02
        DW      #F1F3, #1B02
        DW      #00

; Frame 52
        DW      #C1F2, #1806
        DW      #C9F3, #1307
        DW      #CAF9, #1208
        DW      #D1F2, #1B02
        DW      #DDDB, #1A01
        DW      #E0C5, #1705
        DW      #E4D5, #1705
        DW      #E603, #1706
        DW      #EE04, #1208
        DW      #EF09, #1209
        DW      #FCD5, #1A01
        DW      #FF0A, #1B01
        DW      #00

; Frame 53
        DW      #C4D7, #1507
        DW      #C603, #1507
        DW      #CE04, #1408
        DW      #DCD7, #1901
        DW      #DE04, #1B01
        DW      #E0C7, #1506
        DW      #E1A3, #1508
        DW      #E9A4, #1406
        DW      #EAF7, #1408
        DW      #EF07, #1408
        DW      #FDDB, #1A01
        DW      #FF08, #1A01
        DW      #00

; Frame 54
        DW      #C0C9, #1409
        DW      #C5B3, #120A
        DW      #CDB4, #1607
        DW      #CF54, #1708
        DW      #DDB4, #1901
        DW      #DE2B, #1902
        DW      #DF55, #1B02
        DW      #E1A3, #1308
        DW      #E489, #1309
        DW      #E9A4, #1607
        DW      #EAF5, #1706
        DW      #FC89, #1901
        DW      #00

; Frame 55
        DW      #C0CC, #100A
        DW      #C1A3, #110A
        DW      #C9A4, #1906
        DW      #CB43, #1806
        DW      #CF52, #1907
        DW      #DF53, #1A02
        DW      #E48B, #110A
        DW      #E563, #100B
        DW      #ED64, #1806
        DW      #FC8B, #1902
        DW      #FD64, #1901
        DW      #FE2B, #1901
        DW      #00

; Frame 56
        DW      #C0CE, #0E0B
        DW      #C48D, #0E0C
        DW      #C564, #0D0C
        DW      #CB40, #1B05
        DW      #CD65, #1906
        DW      #CF50, #1A06
        DW      #DC8D, #1802
        DW      #DD65, #1901
        DW      #DE7A, #1902
        DW      #DF51, #1A01
        DW      #E154, #0D0B
        DW      #E955, #1A05
        DW      #00

; Frame 57
        DW      #C956, #1B04
        DW      #CB3E, #1C04
        DW      #CD16, #1A04
        DW      #CF4E, #1B05
        DW      #D0D0, #0C0B
        DW      #D155, #0C0A
        DW      #D48F, #0D0B
        DW      #D515, #0E0A
        DW      #DC8F, #1802
        DW      #DD16, #1801
        DW      #DF4F, #1A01
        DW      #FE79, #1902
        DW      #00

; Frame 58
        DW      #CB3C, #1D03
        DW      #D0D2, #0D08
        DW      #D491, #0E08
        DW      #DC91, #1802
        DW      #DEC8, #1902
        DW      #E907, #1C03
        DW      #ECC7, #1B03
        DW      #EEFC, #1C03
        DW      #F106, #0D07
        DW      #F4C6, #0E07
        DW      #FCC7, #1801
        DW      #FEFD, #1901
        DW      #00

; Frame 59
        DW      #C908, #1D01
        DW      #CB3A, #1E02
        DW      #CCC8, #1C01
        DW      #CEFA, #1D01
        DW      #D107, #0E04
        DW      #D4C7, #0E04
        DW      #DCC8, #1801
        DW      #DEFB, #1801
        DW      #F0D4, #0D05
        DW      #F493, #0E05
        DW      #FC93, #1802
        DW      #FEC7, #1902
        DW      #00

; Frame 60
        DW      #C10A, #1C00
        DW      #C6F8, #1E00
        DW      #D125, #0D02
        DW      #DEF9, #0F02
        DW      #DEF9, #1901
        DW      #DF16, #1901
        DW      #E2E8, #1E00
        DW      #E47A, #1C00
        DW      #F495, #0F02
        DW      #FAE9, #0D02
        DW      #FC7A, #1701
        DW      #FC95, #1701
        DW      #00

; Frame 61
        DW      #C2E6, #1E02
        DW      #D2E6, #1902
        DW      #DAE7, #0D05
        DW      #DB53, #0E04
        DW      #DCE7, #1801
        DW      #DF13, #0E04
        DW      #DF14, #1801
        DW      #E0BB, #1D01
        DW      #E47C, #1C01
        DW      #E6A7, #1D01
        DW      #F0BA, #1802
        DW      #FEA8, #0E05
        DW      #00

; Frame 62
        DW      #C0BD, #1C03
        DW      #C47E, #1B03
        DW      #C6A6, #1C03
        DW      #D0BC, #1802
        DW      #DB51, #0D07
        DW      #DEA7, #0E08
        DW      #E295, #1D03
        DW      #F295, #1902
        DW      #FA96, #0D08
        DW      #FCE8, #1801
        DW      #FF11, #0E07
        DW      #FF12, #1901
        DW      #00

; Frame 63
        DW      #C0BF, #1B04
        DW      #C294, #1C04
        DW      #C480, #1A04
        DW      #D0BE, #1802
        DW      #D294, #1902
        DW      #DA95, #0C0B
        DW      #DB4F, #0C0A
        DW      #DD39, #1801
        DW      #DF5F, #0E0A
        DW      #DF60, #1A01
        DW      #E655, #1B05
        DW      #FE56, #0D0B
        DW      #00

; Frame 64
        DW      #C0C1, #1A05
        DW      #C482, #1906
        DW      #C654, #1A06
        DW      #CB4D, #0D0B
        DW      #CE55, #0E0C
        DW      #CF5D, #0D0C
        DW      #D0C0, #1802
        DW      #DD8A, #1901
        DW      #DF5E, #1A01
        DW      #E243, #1B05
        DW      #EA44, #0E0B
        DW      #F243, #1902
        DW      #00

; Frame 65
        DW      #C0C3, #1906
        DW      #C243, #1806
        DW      #CA44, #100A
        DW      #CB4A, #110A
        DW      #CF5B, #100B
        DW      #D0C2, #1902
        DW      #D34A, #1A02
        DW      #E484, #1806
        DW      #E603, #1907
        DW      #EE04, #110A
        DW      #FD8B, #1901
        DW      #FE04, #1901
        DW      #00

; Frame 66
        DW      #C0C6, #1607
        DW      #C603, #1708
        DW      #CE04, #1309
        DW      #CF59, #120A
        DW      #DDDB, #1901
        DW      #E1F2, #1706
        DW      #E486, #1607
        DW      #E9F3, #1409
        DW      #EAF8, #1308
        DW      #F1F2, #1902
        DW      #F2F8, #1B02
        DW      #FC86, #1901
        DW      #00

; Frame 67
        DW      #C4D8, #1408
        DW      #DCD8, #1901
        DW      #DE2B, #1B01
        DW      #E0C8, #1406
        DW      #E1A3, #1408
        DW      #E5B3, #1408
        DW      #E9A4, #1506
        DW      #EAF6, #1508
        DW      #EDB4, #1507
        DW      #EF06, #1507
        DW      #FDB4, #1A01
        DW      #FF07, #1A01
        DW      #00

; Frame 68
        DW      #C1A3, #1208
        DW      #C5B3, #1209
        DW      #C9A4, #1705
        DW      #CAF4, #1806
        DW      #CDB4, #1705
        DW      #DDB4, #1A01
        DW      #E0CA, #1307
        DW      #E4DA, #1208
        DW      #EF04, #1706
        DW      #FCDA, #1A01
        DW      #FE2B, #1B02
        DW      #FF05, #1B01
        DW      #00

; Frame 69
        DW      #C11C, #1007
        DW      #C52B, #1008
        DW      #C5B3, #0F08
        DW      #CAA2, #1903
        DW      #CDB4, #1804
        DW      #CF01, #1904
        DW      #DD2B, #1A02
        DW      #DDB4, #1B02
        DW      #DE7A, #1B02
        DW      #DF02, #1C02
        DW      #E154, #0F07
        DW      #E955, #1803
        DW      #00

; Frame 70
        DW      #C155, #0D07
        DW      #C956, #1A01
        DW      #E11F, #0D07
        DW      #E52D, #0D08
        DW      #E563, #0D08
        DW      #EA51, #1A01
        DW      #ED64, #1A02
        DW      #EEAF, #1A02
        DW      #FD2D, #1A03
        DW      #FD64, #1B03
        DW      #FE79, #1B03
        DW      #FEB0, #1C03
        DW      #00

; Frame 71
        DW      #C156, #0A05
        DW      #C157, #1B00
        DW      #C171, #0B06
        DW      #DEC8, #1C04
        DW      #E1FF, #1C01
        DW      #E564, #0A06
        DW      #E565, #1A00
        DW      #E57E, #0B07
        DW      #E65D, #1B01
        DW      #FD65, #1B03
        DW      #FD7E, #1B04
        DW      #FE5E, #1C03
        DW      #00

; Frame 72
        DW      #C1C3, #0904
        DW      #C1FE, #1D02
        DW      #C564, #0806
        DW      #C565, #1B02
        DW      #C5CF, #0906
        DW      #C65B, #1C02
        DW      #DD65, #1B04
        DW      #DDCF, #1A05
        DW      #DE5C, #1C04
        DW      #DEC7, #1C05
        DW      #E107, #0805
        DW      #E108, #1C03
        DW      #00

; Frame 73
        DW      #C1AD, #1D04
        DW      #C565, #0504
        DW      #C566, #1B04
        DW      #C609, #1C04
        DW      #C620, #0604
        DW      #DD66, #1B05
        DW      #DE0A, #1C05
        DW      #DE20, #1B06
        DW      #DEC5, #1C06
        DW      #E109, #0503
        DW      #E10A, #1C04
        DW      #E1C5, #0603
        DW      #00

; Frame 74
        DW      #C566, #1C06
        DW      #C671, #0302
        DW      #D565, #0303
        DW      #DD66, #1B07
        DW      #DE71, #1B07
        DW      #DEC3, #1C08
        DW      #E10B, #0302
        DW      #E10C, #1C06
        DW      #E15D, #1D05
        DW      #E217, #0401
        DW      #E5B7, #1C05
        DW      #FDB8, #1C07
        DW      #00

; Frame 75
        DW      #C15E, #1B07
        DW      #C567, #1B07
        DW      #DD67, #1A08
        DW      #DEC2, #1C08
        DW      #E10C, #1D07
        DW      #E10D, #0201
        DW      #E565, #1D07
        DW      #E671, #0201
        DW      #EA68, #0201
        DW      #ED66, #0201
        DW      #FD66, #1C08
        DW      #FE71, #1A08
        DW      #00

; Frame 76
        DW      #C10C, #1C08
        DW      #C10D, #0402
        DW      #C160, #1B09
        DW      #C567, #1B09
        DW      #D267, #0303
        DW      #DD67, #1A0A
        DW      #E514, #1C08
        DW      #E515, #0301
        DW      #F66F, #0202
        DW      #FD15, #1B09
        DW      #FE70, #1B09
        DW      #FEC1, #1A0A
        DW      #00

; Frame 77
        DW      #C0BD, #1B0A
        DW      #C4C2, #1C0A
        DW      #C4C3, #0605
        DW      #D0BE, #0505
        DW      #D267, #0504
        DW      #D66D, #0404
        DW      #DCC3, #1A0C
        DW      #DE6E, #1A0B
        DW      #DF11, #190B
        DW      #E162, #1A0A
        DW      #E568, #1A09
        DW      #FD68, #1A0B
        DW      #00

; Frame 78
        DW      #C471, #1B0B
        DW      #D472, #0707
        DW      #DC72, #190D
        DW      #DF60, #190D
        DW      #E06D, #1B0A
        DW      #E1B4, #190A
        DW      #E568, #190B
        DW      #F06E, #0807
        DW      #F217, #0805
        DW      #F61B, #0705
        DW      #FD68, #180D
        DW      #FE1C, #1A0D
        DW      #00

; Frame 79
        DW      #C06E, #190B
        DW      #C205, #190B
        DW      #C420, #1A0C
        DW      #C5B8, #190B
        DW      #D06F, #0A07
        DW      #D421, #0A08
        DW      #D619, #0907
        DW      #DC21, #180F
        DW      #DDB8, #180E
        DW      #DE1A, #190E
        DW      #F216, #0A07
        DW      #FF60, #180E
        DW      #00

; Frame 80
        DW      #C257, #170B
        DW      #C3D0, #180C
        DW      #C5B9, #170B
        DW      #D216, #0D07
        DW      #D3D1, #0C09
        DW      #D5C7, #0B08
        DW      #DBD1, #1710
        DW      #DDB9, #160F
        DW      #DDC8, #1810
        DW      #E01F, #180B
        DW      #F020, #0D08
        DW      #FF5F, #160F
        DW      #00

; Frame 81
        DW      #C2A9, #160B
        DW      #C380, #160C
        DW      #D216, #0F08
        DW      #D381, #0F09
        DW      #D575, #0E09
        DW      #DB81, #1511
        DW      #DD76, #1612
        DW      #DFAE, #1511
        DW      #E020, #170B
        DW      #E5B9, #160B
        DW      #F021, #0F09
        DW      #FDB9, #1511
        DW      #00

; Frame 82
        DW      #C2FA, #150B
        DW      #C32F, #160B
        DW      #CB30, #1413
        DW      #D330, #110A
        DW      #DFAC, #1313
        DW      #E022, #150A
        DW      #E5B9, #140B
        DW      #F023, #1108
        DW      #F1C6, #1208
        DW      #F4D4, #1108
        DW      #FCD5, #1413
        DW      #FDB9, #1312
        DW      #00

; Frame 83
        DW      #C2E0, #130B
        DW      #C608, #140A
        DW      #CAE1, #1411
        DW      #CE08, #1411
        DW      #CFAB, #1411
        DW      #D2E1, #1408
        DW      #E023, #140A
        DW      #E34B, #140A
        DW      #EC83, #1512
        DW      #F024, #1408
        DW      #F1C6, #1408
        DW      #F482, #1309
        DW      #00

; Frame 84
        DW      #C074, #1308
        DW      #C608, #130A
        DW      #CC32, #1610
        DW      #CE08, #150F
        DW      #CFAA, #1510
        DW      #D075, #1508
        DW      #D1C6, #1608
        DW      #D431, #1609
        DW      #E290, #1209
        DW      #E39C, #1309
        DW      #EA91, #150F
        DW      #F291, #1508
        DW      #00

; Frame 85
        DW      #C43D, #1208
        DW      #C608, #1109
        DW      #CE08, #160C
        DW      #D1C7, #1807
        DW      #E076, #1207
        DW      #E240, #1208
        DW      #EA41, #170C
        DW      #EB92, #170D
        DW      #EF58, #170D
        DW      #F077, #1707
        DW      #F241, #1708
        DW      #F391, #1807
        DW      #00

; Frame 86
        DW      #C0C7, #1106
        DW      #C241, #1007
        DW      #C48D, #1107
        DW      #CA42, #170A
        DW      #CF57, #170B
        DW      #D0C8, #1806
        DW      #D1C7, #1906
        DW      #D242, #1906
        DW      #E607, #1107
        DW      #EB41, #180B
        DW      #EE07, #170B
        DW      #F340, #1907
        DW      #00

; Frame 87
        DW      #CAF1, #1908
        DW      #D1C8, #1A05
        DW      #D2F0, #1B05
        DW      #E0C9, #1005
        DW      #E1F1, #1005
        DW      #E4DE, #1005
        DW      #E607, #0F06
        DW      #E9F2, #1908
        DW      #EE07, #1808
        DW      #EF05, #1909
        DW      #F0CA, #1A05
        DW      #F1F2, #1A06
        DW      #00

; Frame 88
        DW      #C1F2, #0F03
        DW      #C9F3, #1905
        DW      #D1C8, #1B04
        DW      #D1F3, #1B04
        DW      #E11A, #0F03
        DW      #E52D, #1004
        DW      #E606, #0F04
        DW      #EA51, #1905
        DW      #EE06, #1806
        DW      #EEB4, #1906
        DW      #F11B, #1A03
        DW      #F250, #1C04
        DW      #00

; Frame 89
        DW      #C5CD, #0F02
        DW      #D1C9, #1C02
        DW      #E16B, #0F01
        DW      #E1A3, #0F02
        DW      #E605, #0F02
        DW      #E9A4, #1902
        DW      #EA02, #1903
        DW      #EE05, #1903
        DW      #EE63, #1903
        DW      #F16C, #1B02
        DW      #F1A4, #1C02
        DW      #F201, #1C02
        DW      #00

; Frame 90
        DW      #C1B2, #1A00
        DW      #C605, #0E01
        DW      #C605, #1800
        DW      #C61C, #1001
        DW      #E1A5, #1800
        DW      #E612, #1A00
        DW      #E9A4, #0E01
        DW      #E9BB, #1001
        DW      #F1A5, #1B01
        DW      #F1BC, #1B01
        DW      #FE12, #1D01
        DW      #FE2B, #1D01
        DW      #00

; Frame 91
        DW      #C163, #1903
        DW      #C1A5, #1903
        DW      #C5C2, #1903
        DW      #C604, #1902
        DW      #C9A4, #0F02
        DW      #CE04, #0F02
        DW      #CE6C, #0F01
        DW      #DDC2, #1C02
        DW      #DE03, #1C02
        DW      #DE6B, #1B02
        DW      #EA0C, #0F02
        DW      #FE2A, #1C02
        DW      #00

; Frame 92
        DW      #C114, #1906
        DW      #C1A6, #1806
        DW      #C571, #1905
        DW      #C9A5, #0F04
        DW      #CAAC, #1004
        DW      #CEBB, #0F03
        DW      #DD71, #1C04
        DW      #DEBA, #1A03
        DW      #E5B3, #1905
        DW      #EDB3, #0F03
        DW      #FDB2, #1B04
        DW      #FE29, #1B04
        DW      #00

; Frame 93
        DW      #C0C5, #1909
        DW      #C1A7, #1808
        DW      #C5B2, #1908
        DW      #C9A6, #0F06
        DW      #CAFD, #1005
        DW      #CDB2, #1005
        DW      #CF0A, #1005
        DW      #DDB1, #1A06
        DW      #DF09, #1A05
        DW      #E4D1, #1908
        DW      #FCD1, #1B05
        DW      #FE29, #1A05
        DW      #00

; Frame 94
        DW      #C1A7, #170B
        DW      #C481, #180B
        DW      #C9A6, #1107
        DW      #DC81, #1907
        DW      #E077, #170B
        DW      #E562, #170A
        DW      #EB4C, #1107
        DW      #ED62, #1007
        DW      #EF08, #1106
        DW      #FD61, #1906
        DW      #FE28, #1906
        DW      #FF07, #1806
        DW      #00

; Frame 95
        DW      #C078, #170D
        DW      #C432, #170D
        DW      #C561, #170C
        DW      #CD61, #1208
        DW      #CF57, #1207
        DW      #DC32, #1807
        DW      #DD60, #1708
        DW      #DF56, #1707
        DW      #E1A8, #160C
        DW      #E9A7, #1109
        DW      #EB9C, #1208
        DW      #FE28, #1807
        DW      #00

; Frame 96
        DW      #C511, #150F
        DW      #CC3B, #1309
        DW      #CD11, #1209
        DW      #DD10, #1508
        DW      #E02A, #1510
        DW      #E1A8, #150F
        DW      #E392, #1610
        DW      #E9A7, #130A
        DW      #EF55, #1308
        DW      #FB92, #1609
        DW      #FE27, #1608
        DW      #FF54, #1508
        DW      #00

; Frame 97
        DW      #C343, #1512
        DW      #CC8A, #140A
        DW      #CFA4, #140A
        DW      #DB43, #1309
        DW      #DE27, #1408
        DW      #DFA3, #1408
        DW      #E02B, #1411
        DW      #E1A8, #1411
        DW      #E4C1, #1411
        DW      #E9A7, #140A
        DW      #ECC1, #130B
        DW      #FCC0, #1408
        DW      #00

; Frame 98
        DW      #C9F8, #140B
        DW      #CFA3, #150A
        DW      #D1F9, #1312
        DW      #D2F5, #1413
        DW      #DAF5, #1108
        DW      #DE27, #1208
        DW      #DFA2, #1108
        DW      #E470, #1413
        DW      #EC70, #160B
        DW      #ECD9, #150B
        DW      #F02C, #1313
        DW      #FC6F, #110A
        DW      #00

; Frame 99
        DW      #C9F8, #160B
        DW      #CFA1, #170B
        DW      #D1F9, #1511
        DW      #DFA0, #0F09
        DW      #EC21, #160C
        DW      #ED28, #160B
        DW      #F02E, #1511
        DW      #F256, #1612
        DW      #F421, #1511
        DW      #FA56, #0E09
        DW      #FC20, #0F09
        DW      #FDD7, #0F08
        DW      #00

; Frame 100
        DW      #CFA0, #180B
        DW      #D07F, #160F
        DW      #DF9F, #0D08
        DW      #E9F8, #170B
        DW      #EBD1, #180C
        DW      #ED76, #170B
        DW      #F1F9, #160F
        DW      #F208, #1810
        DW      #F3D1, #1710
        DW      #FA08, #0B08
        DW      #FBD0, #0C09
        DW      #FDD7, #0D07
        DW      #00

; Frame 101
        DW      #D080, #180E
        DW      #DDD7, #0A07
        DW      #E9F7, #190B
        DW      #EB81, #1A0C
        DW      #EDC4, #190B
        DW      #EF4F, #190B
        DW      #F1BA, #190E
        DW      #F1F8, #180E
        DW      #F381, #180F
        DW      #F9BA, #0907
        DW      #FB80, #0A08
        DW      #FF4E, #0A07
        DW      #00

; Frame 102
        DW      #CA47, #190B
        DW      #CE13, #190A
        DW      #CF4E, #1B0A
        DW      #D1BC, #1A0D
        DW      #D248, #180D
        DW      #D9BC, #0705
        DW      #DDD8, #0805
        DW      #DF4D, #0807
        DW      #EB32, #1B0B
        DW      #F080, #190D
        DW      #F332, #190D
        DW      #FB31, #0707
        DW      #00

; Frame 103
        DW      #CA47, #1A09
        DW      #CE61, #1A0A
        DW      #D248, #1A0B
        DW      #EAE2, #0605
        DW      #EAE3, #1C0A
        DW      #EEFE, #1B0A
        DW      #F0D1, #190B
        DW      #F16E, #1A0B
        DW      #F2E3, #1A0C
        DW      #F96E, #0404
        DW      #FD88, #0504
        DW      #FEFD, #0505
        DW      #00

; Frame 104
        DW      #CA94, #0301
        DW      #CA95, #1C08
        DW      #D121, #1A0A
        DW      #D170, #1B09
        DW      #D295, #1B09
        DW      #D970, #0202
        DW      #EA46, #1B09
        DW      #EE5F, #1B09
        DW      #EEAC, #0402
        DW      #EEAD, #1C08
        DW      #F247, #1A0A
        DW      #FD88, #0303
        DW      #00

; Frame 105
        DW      #C245, #0201
        DW      #C587, #0201
        DW      #C970, #0201
        DW      #CA46, #1D07
        DW      #CEAC, #0201
        DW      #CEAD, #1D07
        DW      #D171, #1A08
        DW      #D246, #1C08
        DW      #EA46, #1B07
        DW      #EE5D, #1B07
        DW      #F122, #1C08
        DW      #F247, #1A08
        DW      #00

; Frame 106
        DW      #C9F8, #1C05
        DW      #CDD6, #0401
        DW      #CE5E, #1D05
        DW      #CEAB, #1C06
        DW      #CEAC, #0302
        DW      #D1F8, #1C07
        DW      #E970, #0302
        DW      #EA45, #1C06
        DW      #F123, #1C08
        DW      #F171, #1B07
        DW      #F246, #1B07
        DW      #FA46, #0303
        DW      #00

; Frame 107
        DW      #CE24, #0603
        DW      #CEA9, #1C04
        DW      #CEAA, #0503
        DW      #E9AA, #1C04
        DW      #E9BF, #0604
        DW      #EA45, #1B04
        DW      #EA46, #0504
        DW      #EE0E, #1D04
        DW      #F125, #1C06
        DW      #F1AA, #1C05
        DW      #F1C0, #1B06
        DW      #F246, #1B05
        DW      #00

; Frame 108
        DW      #CEA7, #1C03
        DW      #CEA8, #0805
        DW      #E95C, #1C02
        DW      #EA0E, #0906
        DW      #EA44, #1B02
        DW      #EA45, #0806
        DW      #EDBF, #1D02
        DW      #EE22, #0904
        DW      #F127, #1C05
        DW      #F15C, #1C04
        DW      #F20F, #1A05
        DW      #F245, #1B04
        DW      #00

; Frame 109
        DW      #C244, #1A00
        DW      #C95E, #1B01
        DW      #CA45, #0A06
        DW      #CA5D, #0B07
        DW      #CDC0, #1C01
        DW      #D15E, #1C03
        DW      #D245, #1B03
        DW      #D25E, #1B04
        DW      #E656, #1B00
        DW      #EE57, #0A05
        DW      #EE70, #0B06
        DW      #F128, #1C04
        DW      #00

; Frame 110
        DW      #C110, #1A02
        DW      #C243, #1A02
        DW      #C572, #1A01
        DW      #CA44, #0D08
        DW      #CAAC, #0D08
        DW      #CEBE, #0D07
        DW      #D110, #1C03
        DW      #D179, #1B03
        DW      #D244, #1B03
        DW      #D2AD, #1A03
        DW      #E655, #1A01
        DW      #EE56, #0D07
        DW      #00

; Frame 111
        DW      #C654, #1803
        DW      #CE55, #0F07
        DW      #E0C2, #1904
        DW      #E1F3, #1804
        DW      #E523, #1903
        DW      #E9F4, #0F08
        DW      #EAAA, #1008
        DW      #EEBB, #1007
        DW      #F0C2, #1C02
        DW      #F17A, #1B02
        DW      #F1F4, #1B02
        DW      #F2AB, #1A02
        DW      #00

; Frame 112
        DW      #C0C5, #1706
        DW      #CAF9, #1208
        DW      #CF09, #1307
        DW      #D0C5, #1B01
        DW      #D1CB, #1B02
        DW      #D2FA, #1A01
        DW      #E1F3, #1705
        DW      #E4D5, #1806
        DW      #E603, #1705
        DW      #E9F4, #1209
        DW      #EE04, #1208
        DW      #F1F4, #1A01
        DW      #00

; Frame 113
        DW      #C0C7, #1507
        DW      #C1F3, #1507
        DW      #C4D7, #1508
        DW      #C603, #1506
        DW      #C9F4, #1408
        DW      #CE04, #1408
        DW      #CF07, #1406
        DW      #D0C7, #1A01
        DW      #D1F4, #1A01
        DW      #EAF7, #1408
        DW      #F1CB, #1B01
        DW      #F2F8, #1901
        DW      #00

; Frame 114
        DW      #C4D9, #1308
        DW      #C5B2, #1409
        DW      #CB45, #1607
        DW      #CDB3, #1706
        DW      #D346, #1901
        DW      #DCD8, #1B02
        DW      #DDB2, #1902
        DW      #E07A, #120A
        DW      #E1A3, #1309
        DW      #E9A4, #1708
        DW      #EF05, #1607
        DW      #F21B, #1901
        DW      #00

; Frame 115
        DW      #C1A3, #110A
        DW      #C9A4, #1907
        DW      #CB43, #1806
        DW      #D1A4, #1901
        DW      #D26B, #1901
        DW      #E07C, #100B
        DW      #E48B, #110A
        DW      #E563, #100A
        DW      #ED64, #1806
        DW      #EF02, #1906
        DW      #FC8A, #1A02
        DW      #FF02, #1902
        DW      #00

; Frame 116
        DW      #C563, #0E0B
        DW      #CD64, #1B05
        DW      #DD63, #1902
        DW      #E07E, #0D0C
        DW      #E154, #0E0C
        DW      #E48E, #0D0B
        DW      #E955, #1A06
        DW      #EB41, #1906
        DW      #EF00, #1A05
        DW      #F07E, #1A01
        DW      #F26A, #1901
        DW      #FF00, #1802
        DW      #00

; Frame 117
        DW      #C956, #1B05
        DW      #D155, #0D0B
        DW      #EB3F, #1A04
        DW      #ED15, #1C04
        DW      #EEFE, #1B04
        DW      #F080, #0E0A
        DW      #F080, #1A01
        DW      #F2B9, #1801
        DW      #F490, #0C0A
        DW      #F514, #0C0B
        DW      #FD14, #1902
        DW      #FEFE, #1802
        DW      #00

; Frame 118
        DW      #CD16, #1D03
        DW      #D0D2, #0E07
        DW      #D0D2, #1901
        DW      #D308, #1801
        DW      #D515, #0D08
        DW      #DD15, #1902
        DW      #E907, #1C03
        DW      #EB3D, #1B03
        DW      #EEFC, #1C03
        DW      #F106, #0E08
        DW      #F492, #0D07
        DW      #FEFC, #1802
        DW      #00

; Frame 119
        DW      #C908, #1D01
        DW      #CB3B, #1C01
        DW      #CEFA, #1D01
        DW      #D107, #0E05
        DW      #DEFA, #1802
        DW      #ECC7, #1E02
        DW      #F0D4, #0E04
        DW      #F0D4, #1801
        DW      #F307, #1801
        DW      #F494, #0E04
        DW      #F4C6, #0D05
        DW      #FCC6, #1902
        DW      #00

	DW	0
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

-- Project 46: twolinesrupture by Ast
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'twolinesrupture',
    'Imported from z80Code. Author: Ast. 2 lines-to-line rupture + rasters',
    'public',
    false,
    false,
    '2019-09-11T12:06:14.102000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Rupture 2 lignes a 2 lignes
;     Compatible All Crtc
; Code by AsT/iMPact Fevrier 2019.
; 1er code de l''annee.
;
; Sept.2019: Adapted for RASM, use of macros (siko)

org #1000
run $

NUMRASTLINES EQU (248+4)

 di
 ld hl,#c9fb ; kill int
 ld (#38),hl
;
; Creation de la Trame 1 ligne sur 2
;
ld hl,#c000
 ld b,80
 ld a,%01010101
pixg 
 ld (hl),a
 inc l
 djnz pixg
 rlca
 
ld hl,#c800
 ld b,80
pixd 
 ld (hl),a
 inc l
 
 djnz pixd

 ei
;
main ld b,#f5
vbl in a,(c)
 rra
 jr nc,vbl
;
 ld bc,#7f8e
 out (c),c
;
 ld bc,#bc07 ; kill vbl R7> Max R4
 out (c),c
 inc b
 out (c),c
;
y1 ld de,background ; Declaration et affichage 8 rasters
 call pokeraster
y2 ld de,background
 call pokeraster
y3 ld de,background
 call pokeraster
y4 ld de,background
 call pokeraster
y5 ld de,background
 call pokeraster
y6 ld de,background
 call pokeraster
y7 ld de,background
 call pokeraster
y8 ld de,background
 call pokeraster
;
 ld b,1 ; manque 1 ligne avant que l''overflow du r9
l0 defs 60,0
 djnz l0
;
 ld bc,#bc09 
 ld a,1
 out (c),c
 inc b
 out (c),a
;
 ld bc,#bc04
 out (c),c
 inc b
 ld a,0 ; 33-1
 out (c),a
;
 ei
 

halt

;
 call raster
;
 ld bc,#bc07 ; Re-Positionne la Vbl
 ld a,2
 out (c),c
 inc b
 out (c),a
 ld bc,#bc04
 out (c),c
 ld a,6-1
 inc b
 out (c),a
 ld bc,#bc09
 ld a,7
 out (c),c
 inc b
 out (c),a
;
 call clearraster2
 call calculy1
;
 jp main
;
; Routine de Rasters Simplifies
;
raster di
 ld bc,#7f01
 ld hl,background
 ld a,NUMRASTLINES
 defs 13,0
;
looprast
;
 out (c),0 ; selectionne couleur 0 
 inc b
 outi
 out (c),c ; selectionne couleur 1
 inc b
 outi
;
 defs 64-4-20,0
;
 dec a
 jr nz,looprast
 ei
 ret
;
; Efface Raster dans la Table BackGround
;
clearraster2
 di
 ld (pile+1),sp
 ld sp,bgend
 ld hl,#5444
 defs NUMRASTLINES,#E5 ; push hl
pile  ld sp,0
 ei
 ret
;
; Affiche Raster dans la table BackGround
;
pokeraster
 ld hl,tableraster
 ;40 x Ldi car 20 couleurs (pen 0 et pen 1)
 repeat 40
  ldi
 rend
 ret


MACRO calculY bpoffs,Y
@calculy0:
 ld hl,bumptab+{bpoffs}
 ld a,(hl)
 inc l
 ld (@calculy0+1),hl
 ld l,a
 ld h,0
 add hl,hl
 ld bc,background
 add hl,bc
 ld ({Y}+1),hl
MEND

;
; Calcul Y de la position des rasters
; grace a une table generee en amont
;
calculy1 

 calculY 0,y1
 calculY 8,y2
 calculY #10,y3
 calculY #18,y4
 calculY #20,y5
 calculY #28,y6
 calculY #30,y7
 calculY #38,y8
 ret
;
; BackGround ou comment remplir chaque lignes avec la couleur noire
;
background
 defs NUMRASTLINES*2,#54
bgend
;
; Table des couleurs de mon raster
;
tableraster
 ;defb #54,#54 ; 1
 defb #54,#5c ; 2
 defb #5c,#5c ; 3
 defb #5c,#4c ; 4
 defb #4c,#4c ; 5
 defb #4c,#4e ; 6
 defb #4e,#4e ; 7
 defb #4e,#4a ; 8
 defb #4a,#4a ; 9
 defb #4a,#4b ; 10
 defb #4b,#4b ; 11
 defb #4b,#4b ; 12
 defb #4a,#4b ; 13
 defb #4a,#4a ; 14
 defb #4e,#4a ; 15
 defb #4e,#4e ; 16
 defb #4c,#4e ; 17
 defb #4c,#4c ; 18
 defb #5c,#4c ; 19
 defb #5c,#5c ; 20
 defb #5c,#54 ; 21 

; Table for animating rasters
org #800
bumptab
; Simple sinus
;repeat 32*8,angle
;	db sin(360*(angle-1)/256)*100+100;
;rend

;bouncing
repeat 32*8,angle
	db 200-abs(sin(360*(angle-1)/256))*200+10;
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

  -- Add category tag: rupture
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rupture';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
