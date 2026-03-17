     H DATEDIT(*YMD.)
     F*** VJBR61 *************************************
     F*   UPDATE OF FILE REORGANIZATION INPUT M/F    *
     F*             H.ITO          87.10.12          *
     F************************************* VJBR11 ***
     FVJBPW61   CF   E             WORKSTN
     FVJBPL61   UF A E           K DISK
     D KOCD            S              1    DIM(3) CTDATA PERRCD(1)              UPDATE INSTR
     D KONM            S              6    DIM(3) ALT(KOCD)
     D ER              S             60    DIM(17) CTDATA PERRCD(1)             ERROR MESSAGE
     D                 DS
     D  WTIME                  1      6  0
     D  FEKOHH                 1      2  0
     D  FEKOSS                 3      4  0
     D                 DS
     D  FENUKI                 1      8  0
     D  FENUKH                 3      8  0
     D  FENUYY                 1      4  0
     D  FENUMM                 5      6  0
     D  FENUDD                 7      8  0
     D                 DS
     D  FESGYO                 1      8  0
     D  FESGYH                 3      8  0
     D  FESGYY                 1      4  0
     D  FESGMM                 5      6  0
     D  FESGDD                 7      8  0
     D                 DS
     D  FESKHZ                 1      8  0
     D  FESKYY                 1      4  0
     D  FESKMM                 5      6  0
     D  FESKDD                 7      8  0
     D                 DS
     D  FEKOHZ                 1      8  0
     D  FEKOYY                 1      4  0
     D  FEKOMM                 5      6  0
     D  FEKODD                 7      8  0
     D                 DS
     D**JW1                                   1   7 FEFILE
JW1  D  FEFILE                 1      8
     D  FILEP                  5      5
     D                 DS
     D  HKE                    1     24  0
     D                                     DIM(12)                              PLAN DAY
     D  FEKE01                 1      2  0
     D  FEKE02                 3      4  0
     D  FEKE03                 5      6  0
     D  FEKE04                 7      8  0
     D  FEKE05                 9     10  0
     D  FEKE06                11     12  0
     D  FEKE07                13     14  0
     D  FEKE08                15     16  0
     D  FEKE09                17     18  0
     D  FEKE10                19     20  0
     D  FEKE11                21     22  0
     D  FEKE12                23     24  0
      *************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    USER             10            USER NAME
      *
     C                   Z-ADD     0             FESKHZ
     C/SPACE 1
     C*------------------*
     C*    SCREEN-1      *
     C*------------------*
     C     STP1          TAG
     C                   EXFMT     VJBPW611
     C                   SETOFF                                       010299
      * F1: END
     C   KA              SETON                                        LR
     C   KA              RETURN
      *
      * F10: INQ
JW   C     *INKJ         IFEQ      *ON
.    C                   CALL      'VJBC61A'
.    C                   GOTO      STP1
.    C                   ENDIF
      *
     C** UPDATE INSTRUCTION **
     C                   SETOFF                                       30
     C                   Z-ADD     1             A                 1 0
     C     PKOSN         LOOKUP    KOCD(A)                                30
     C     *IN30         IFEQ      '0'
     C                   SETON                                        0199
     C                   MOVE      ER(1)         MSG
     C                   GOTO      STP1
     C                   END
     C                   MOVE      KONM(A)       PKONM             6
     C/SPACE 1
     C**  FILE NAME  **
     C     FEFILE        IFEQ      *BLANK
     C                   SETON                                        0299
     C                   MOVE      ER(2)         MSG
     C                   GOTO      STP1
     C                   END
     C*          FILEP     IFNE 'P'
     C*                    SETON                     0299
     C*                    MOVE ER,3      MSG
     C*                    GOTO STP1
     C*                    END
     C/SPACE 1
     C**  IN CASE OF ADD  **
     C                   SETOFF                                       30
     C     FEFILE        CHAIN     VJBPL611                           30
     C     PKOSN         IFEQ      '2'
     C     *IN30         IFEQ      '0'
     C     FESKJY        IFEQ      'D'
     C     FESKHZ        ANDLE     *DATE
     C                   GOTO      SP1
     C                   END
     C                   SETON                                        010299
     C                   MOVE      ER(4)         MSG
     C                   GOTO      STP1
     C                   END
     C                   END
     C/SPACE 1
     C**  IN CASE OF CHANGE  **
     C     PKOSN         IFEQ      '1'
     C     *IN30         IFEQ      '1'
     C                   SETON                                        010299
     C                   MOVE      ER(5)         MSG
     C                   GOTO      STP1
     C                   END
     C     FESKJY        IFEQ      'D'
     C     FESKHZ        ANDLE     *DATE
     C                   SETON                                        010299
     C                   MOVE      ER(6)         MSG
     C                   GOTO      STP1
     C                   END
     C                   END
     C/SPACE 1
     C**  IN CASE OF CANCEL  **
     C     PKOSN         IFEQ      '0'
     C     *IN30         IFEQ      '1'
     C                   SETON                                        010299
     C                   MOVE      ER(7)         MSG
     C                   GOTO      STP1
     C                   END
     C     FESKJY        IFEQ      'D'
     C     FESKHZ        ANDLE     *DATE
     C                   SETON                                        010299
     C                   MOVE      ER(8)         MSG
     C                   GOTO      STP1
     C                   END
     C                   END
     C     SP1           TAG
     C/SPACE 1
     C     PKOSN         IFEQ      '2'
     C                   Z-ADD     0             FEKE01
     C                   Z-ADD     0             FEKE02
     C                   Z-ADD     0             FEKE03
     C                   Z-ADD     0             FEKE04
     C                   Z-ADD     0             FEKE05
     C                   Z-ADD     0             FEKE06
     C                   Z-ADD     0             FEKE07
     C                   Z-ADD     0             FEKE08
     C                   Z-ADD     0             FEKE09
     C                   Z-ADD     0             FEKE10
     C                   Z-ADD     0             FEKE11
     C                   Z-ADD     0             FEKE12
     C                   Z-ADD     0             FENUKI
     C                   MOVE      *BLANK        FEKUBN
     C                   Z-ADD     0             FESTEI
     C                   MOVE      *BLANK        FEJPGM
     C                   MOVE      *BLANK        FELIBL
     C                   Z-ADD     0             FESKRE
     C                   Z-ADD     0             FESKHI
     C                   Z-ADD     0             FESGYO
     C                   Z-ADD     0             FERECD
     C                   Z-ADD     0             FEKENS
     C                   END
     C                   MOVE      PKONM         QKONM
     C                   MOVE      FEFILE        QFILE
     C/SPACE 1
     C*------------------*
     C*    SCREEN-2      *
     C*------------------*
     C     STP2          TAG
     C                   EXFMT     VJBPW612
     C                   MOVEA     '00000'       *IN(01)
     C                   MOVEA     '00000'       *IN(06)
     C                   MOVEA     '00000'       *IN(11)
     C                   MOVEA     '0000'        *IN(16)
     C                   SETOFF                                       99
     C/SPACE 1
     C   KC              MOVE      *BLANK        PKOSN
     C   KC              MOVE      *BLANK        FEFILE
     C   KC              GOTO      STP1
     C/SPACE 1
     C**  PLAN DAY  **
     C     FEKE01        IFEQ      0
     C     FEKE02        ANDEQ     0
     C     FEKE03        ANDEQ     0
     C     FEKE04        ANDEQ     0
     C     FEKE05        ANDEQ     0
     C     FEKE06        ANDEQ     0
     C     FEKE07        ANDEQ     0
     C     FEKE08        ANDEQ     0
     C     FEKE09        ANDEQ     0
     C     FEKE10        ANDEQ     0
     C     FEKE11        ANDEQ     0
     C     FEKE12        ANDEQ     0
     C                   MOVEA     '11111'       *IN(01)
     C                   MOVEA     '11111'       *IN(06)
     C                   SETON                                        111299
     C                   MOVE      ER(9)         MSG
     C                   GOTO      STP2
     C                   END
     C/SPACE 1
     C                   Z-ADD     1             B                 2 0
     C     1             DO        12            B
     C     HKE(B)        IFNE      0
     C     HKE(B)        IFGT      31
     C                   MOVE      '1'           *IN(B)
     C                   SETON                                        99
     C                   MOVE      ER(10)        MSG
     C                   GOTO      STP2
     C                   END
     C                   END
     C                   END
     C/SPACE 1
     C**  I PULL IT OUT AND SORT APPOINTMENT  **
     C     FEKUBN        IFNE      *BLANK
     C     FEKUBN        ANDNE     'S'
     C                   SETON                                        1499
     C                   MOVE      ER(17)        MSG
     C                   GOTO      STP2
     C                   END
     C/SPACE 1
     C**  SETTING MONTH WHEN IT IS PULLED OUT, AND IS EXPECTED  **
     C     FEKUBN        IFEQ      *BLANK
     C     FESTEI        IFEQ      0
     C                   SETON                                        1499
     C                   MOVE      ER(11)        MSG
     C                   GOTO      STP2
     C                   END
     C                   ELSE
     C/SPACE 1
     C     FESTEI        IFNE      0
     C                   SETON                                        1599
     C                   MOVE      ER(12)        MSG
     C                   GOTO      STP2
     C                   END
     C                   END
     C/SPACE 1
     C**  EXECUTE PGM  **
     C     FEJPGM        IFEQ      *BLANK
     C                   SETON                                        1699
     C                   MOVE      ER(13)        MSG
     C                   GOTO      STP2
     C                   END
     C/SPACE 1
     C**  LIBRARY  **
     C     FELIBL        IFEQ      *BLANK
     C                   SETON                                        1799
     C                   MOVE      ER(14)        MSG
     C                   GOTO      STP2
     C                   END
     C/SPACE 1
     C**  DELETE CODE START POSITION  **
     C     FESKRE        IFEQ      0
     C                   SETON                                        1899
     C                   MOVE      ER(15)        MSG
     C                   GOTO      STP2
     C                   END
     C/SPACE 1
     C**  DELETE DUE DATE START POSITION  **
     C     FESKHI        IFEQ      0
     C                   SETON                                        1999
     C                   MOVE      ER(16)        MSG
     C                   GOTO      STP2
     C                   END
     C/SPACE 1
     C     *INKE         IFEQ      '0'
     C                   GOTO      STP2
     C                   END
     C/SPACE 1
     C                   MOVE      QKONM         MKONM
     C                   MOVE      QFILE         MFILE
     C/SPACE 1
     C     PKOSN         IFEQ      '0'
     C                   MOVE      'D'           FESKJY
     C                   Z-ADD     *DATE         FESKHZ
     C                   ELSE
     C                   MOVE      *BLANK        FESKJY
     C                   Z-ADD     0             FESKHZ
     C                   END
     C                   Z-ADD     *DATE         FEKOHZ
     C                   TIME                    WTIME
     C                   MOVE      USER          FEKOME
     C     *IN30         IFEQ      '0'
     C                   UPDATE    VJBPL611
     C                   ELSE
     C                   WRITE     VJBPL611
     C                   END
     C/SPACE 1
     C                   MOVE      *BLANK        PKOSN
     C                   MOVE      *BLANK        FEFILE
     C                   GOTO      STP1
**  (KOCD/KONM)
0DELETE
1UPDATE
2ADD
**  ER
E-01 UPDATE INSTR IS 0, 1 OR 2.
E-02 ENTER FILE
E-03 FILE MUST BE PHYSICAL FILE
E-04 EXIST IN MASTER ALREADY
E-05 NO DATA TO UPDATE MASTER
E-06 NO DATA TO UPDATE MASTER (ALREADY DELETED).
E-07 NO DATA TO DELETE MASTER
E-08 ALREADY DELETED.
E-09 ENTER PLAN DATA
E-10 PLAN DATE ENTERED IS INVALID
E-11 ENTER LAST DATE OF DELETION INSTR
E-12 NUMBER OF MONTHS CANNOT BE ENTERED.
E-13 ENTER PROGRAM
E-14 ENTER LIBRARY
E-15 ENTER STARTING DELETE CODE
E-16 ENTER SCHEDULED DATE TO PERFORM DELETION
E-17 LAST DATE OF DELETION INSTR  SHOULD BE S OR BLANK
