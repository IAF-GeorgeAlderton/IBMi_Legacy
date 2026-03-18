     H DATEDIT(*YMD.)
     F** VJBR62 ****************************************
     F*  REFORMATTING FILES                            *
     F*      I-HASADA                    87.10.22      *
     F*-------------------------------------------     *
JW1  F*  J.WATANABE  2017.04.06 CHG CALL TO            *
     F**************************************************
     FVJBPW62   CF   E             WORKSTN
     F                                     SFILE(SFL:RRN)
     FVJBPL62   IF   E           K DISK
     FDGAPL01   IF   E           K DISK
     D HRRN            S              3  0 DIM(12)                              RRN
     D HSGY            S              6  0 DIM(12)                              REFORM DAY
     D HPGM            S              6    DIM(12)                              PGM
     D**JW1               HFIL       12  7               FILE NAME
JW1  D HFIL            S              8    DIM(12)                              FILE NAME
     D HSKR            S              3  0 DIM(12)                              DLT CODE POSITION
     D HSKH            S              3  0 DIM(12)                              DLT DATE POSITION
     D HSTI            S              2  0 DIM(12)                              SETTING MONTH ﾞl
     D HKUB            S              1    DIM(12)                              SORT APPOINTMENT
     D HLIB            S              8    DIM(12)                              LIBRARY
     D ER              S             60    DIM(3) CTDATA PERRCD(1)              ERROR MESSAGE
     D                 DS
     D  KE                     1     24  0
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
     D                 DS
     D  YMD                    1      8  0
     D  YM                     1      6  0
     D  Y                      1      4  0
     D  M                      5      6  0
     D  D                      7      8  0
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
     D  WKEHZ                  1      8  0
     D  WKEHH                  3      8  0
     D  WKEYM                  1      6  0
     D  WKEDD                  7      8  0
     D                 DS
     D  WYMD                   1      8  0
     D  WYM                    1      6  0
     D  WYY                    1      4  0
     D  WMM                    5      6  0
     D  WDD                    7      8  0
     D                 DS
     D  STIME                  1     14  0
     D  NOW                    1      6  0
     D  TODAY                  7     14  0
      *=============================================================
     C     FKEY1         KLIST
     C                   KFLD                    PGM1
     C                   KFLD                    KEY1
      *
     C     FKEY2         KLIST
     C                   KFLD                    PGM2
     C                   KFLD                    KEY2
      *
     C     ACALL         PLIST
     C                   PARM                    AFILE                          FILE
     C                   PARM                    ALIBR                          LIBRARY
     C                   PARM                    ANUKI                          DATE
     C**JW1                PARM           ASKRE            NOT USE
     C**                   PARM           ASKHI            NOT USE
      *
     C                   TIME                    STIME
      *=============================================================
      *
     C**JW1                MOVE *BLANK    KEY1    7
JW1  C                   MOVE      *BLANK        KEY1              8
     C                   MOVE      *BLANK        PGM1              6
      *
     C                   Z-ADD     12            SFLSIZ            2 0
     C                   Z-ADD     *DATE         YMD
     C                   Z-ADD     0             RRN               4 0
     C                   Z-ADD     0             HRRN
     C                   Z-ADD     0             HSGY
     C                   MOVE      *BLANK        HPGM
     C                   MOVE      *BLANK        HFIL
     C                   Z-ADD     0             HSKR
     C                   Z-ADD     0             HSKH
     C                   Z-ADD     0             HSTI
     C                   MOVE      *BLANK        HKUB
     C                   MOVE      *BLANK        HLIB
      *
     C***        STP0      TAG
     C***                  WRITEVJBPW623
     C***                  EXFMTVJBPW621
     C                   Z-ADD     0             A                 2 0
     C                   Z-ADD     0             WNO
     C     FKEY1         SETLL     VJBPL621
     C                   EXSR      SFLSET
      * F1
     C***        *INKA     IFEQ '1'
     C***                  SETON                     LR
     C***                  RETRN
     C***                  ENDIF
     C**JW                 WRITEVJBPW621
      *
     C                   DO        *HIVAL
     C* DISPLAY SUB-FILE
     C     RRN           COMP      0                                  20
     C                   SETON                                        21
JW   C                   WRITE     VJBPW621
     C                   WRITE     VJBPW623
     C                   EXFMT     SFLCTL
     C                   SETOFF                                       102021
     C                   SETOFF                                       319899
      * F1
     C     *INKA         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C* ROLL UP/DOWN
     C     *IN25         IFEQ      '1'
     C     *IN26         OREQ      '1'
     C                   EXSR      ROLLUD
     C                   EXSR      SFLSET
     C                   ELSE
      *
     C* INITIAL FILE POINTER SET
     C* F5 OR F7
     C     *INKE         IFEQ      '1'
     C     *INKG         OREQ      '1'
     C     WNO           IFEQ      0
     C                   SETON                                        1099
     C                   MOVE      ER(3)         MSG
     C                   ELSE
      *
     C                   Z-ADD     1             B                 2 0
     C     WNO           LOOKUP    HRRN(B)                                31
     C     *IN31         IFEQ      '0'
     C                   SETON                                        1099
     C                   MOVE      ER(1)         MSG
     C                   ELSE
      * F5
     C     HSGY(B)       IFNE      0
     C     *INKE         ANDEQ     '1'
     C                   SETON                                        1099
     C                   MOVE      ER(2)         MSG
     C                   ELSE
      *
     C                   Z-ADD     0             WNO
     C                   MOVE      *BLANK        CPGMR            10
     C                   MOVEL     HPGM(B)       CPGMR
     C                   MOVE      HFIL(B)       AFILE
     C                   MOVE      HLIB(B)       ALIBR             8
     C                   MOVE      HSKR(B)       ASKRE             3
     C                   MOVE      HSKH(B)       ASKHI             3
      *
     C     HKUB(B)       IFEQ      'S'
     C                   MOVE      *DATE         ANUKI             8
     C                   ELSE
      *
     C                   SETOFF                                       31
     C                   Z-ADD     YM            WYM
     C                   Z-ADD     31            WDD
     C                   Z-ADD     HSTI(B)       W                 2 0
      *
     C     1             DO        W
     C     WMM           IFEQ      01
     C                   SUB       1             WYY
     C                   Z-ADD     12            WMM
     C                   ELSE
     C                   SUB       1             WMM
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      WYMD          ANUKI
     C                   ENDIF
      *
     C                   SETON                                        98
     C**JW1                CALL CPGMR     ACALL
JW1  C                   CALL      'UTLC20'      ACALL
      *
     C**JW1                MOVE HFIL,1    KEY2    7
JW1  C                   MOVE      HFIL(1)       KEY2              8
     C                   MOVE      HPGM(1)       PGM2              6
     C                   SUB       C             A
     C                   Z-ADD     0             WNO
     C     FKEY2         SETLL     VJBPL621
     C                   EXSR      SFLSET
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C                   ENDDO
      *
     C*****************************************************************
     C     ROLLUD        BEGSR
     C*****************************************************************
     C     *IN26         IFEQ      '1'
     C     HFIL(12)      IFEQ      *BLANK
     C                   ADD       1             A
     C                   ADD       1             C
     C                   ENDIF
     C     SFLSIZ        ADD       C             ROLLL#            2 0
     C     1             DO        ROLLL#
     C     STP1          TAG
     C                   SETOFF                                       9097
     C                   READP     VJBPL621                               90
     C     *IN90         IFEQ      '1'
     C                   SUB       1             A
     C     *LOVAL        SETLL     VJBPL621
     C                   GOTO      STP3
     C                   ENDIF
      *
     C     FEFILE        IFLT      KEY1
     C                   SETON                                        90
     C                   SUB       1             A
     C                   GOTO      STP3
     C                   ENDIF
     C     FESKJY        IFEQ      'D'
     C     FESKHZ        ANDLE     *DATE
     C                   GOTO      STP1
     C                   ENDIF
     C     KE(M)         IFEQ      0
     C                   GOTO      STP1
     C                   ENDIF
     C                   SUB       1             A
     C     STP3          TAG
     C  N90              ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
     C     SFLSET        BEGSR
     C*****************************************************************
     C                   SETOFF                                       8090
     C                   Z-ADD     0             RRN
     C                   SETON                                        22
     C                   WRITE     SFLCTL
     C                   SETOFF                                       22
      *
     C     *IN90         DOWEQ     '0'
     C                   SETOFF                                       90
     C                   READ      VJBPL621                               90
     C     *IN90         IFEQ      '0'
     C     FESKJY        IFEQ      'D'
     C     FESKHZ        ANDLE     *DATE
     C                   GOTO      STP2
     C                   END
     C     KE(M)         IFEQ      0
     C                   GOTO      STP2
     C                   END
      *
     C     *IN80         IFEQ      '0'
     C                   SETON                                        80
     C                   Z-ADD     0             C                 2 0
     C                   Z-ADD     0             HRRN
     C                   Z-ADD     0             HSGY
     C                   MOVE      *BLANK        HPGM
     C                   MOVE      *BLANK        HFIL
     C                   Z-ADD     0             HSKR
     C                   Z-ADD     0             HSKH
     C                   Z-ADD     0             HSTI
     C                   MOVE      *BLANK        HKUB
     C                   MOVE      *BLANK        HLIB
     C                   END
      *
     C                   ADD       1             RRN
     C                   ADD       1             A
     C                   ADD       1             C
     C                   Z-ADD     A             HRRN(C)
     C                   Z-ADD     FESGYO        HSGY(C)
     C                   MOVE      FEJPGM        HPGM(C)
     C                   MOVE      FEFILE        HFIL(C)
     C                   Z-ADD     FESKRE        HSKR(C)
     C                   Z-ADD     FESKHI        HSKH(C)
     C                   Z-ADD     FESTEI        HSTI(C)
     C                   MOVE      FEKUBN        HKUB(C)
     C                   MOVE      FELIBL        HLIB(C)
     C                   EXSR      MOV001
      * SET INDICATOR
     C     FESGYO        IFEQ      TODAY
     C                   MOVE      *ON           IND
     C                   MOVE      *ON           *IN40
     C                   ELSE
     C                   MOVE      *OFF          IND
     C                   MOVE      *OFF          *IN40
     C                   ENDIF
      *
     C                   WRITE     SFL                                    90
     C                   ELSE
      *
     C     HFIL(12)      IFEQ      *BLANK
     C     *HIVAL        SETLL     VJBPL621
     C                   ELSE
      *
     C     *HIVAL        SETGT     VJBPL621
     C     *IN97         IFEQ      '0'
     C                   SETON                                        97
     C                   ADD       1             A
     C                   ADD       1             C
     C                   END
     C                   END
      *
     C                   END
     C     STP2          TAG
     C                   END
     C                   ENDSR
      *
     C*****************************************************************
     C     MOV001        BEGSR
     C*****************************************************************
     C                   SETOFF                                       3032
     C                   Z-ADD     A             CNO
     C                   Z-ADD     YM            WKEYM
     C                   Z-ADD     KE(M)         WKEDD
      *
     C     FESGYO        IFEQ      0
     C     KE(M)         ANDLE     D
     C                   SETON                                        30
     C                   END
      *
     C                   MOVE      *BLANK        WFINM
     C     FEFILE        CHAIN     DGAPL011                           32
     C     *IN32         IFEQ      '0'
     C                   MOVEL     A1TXTN        WFINM
     C                   END
     C                   ENDSR
** ER
ER-01 NO DATA FOUND
ER-02 ALREADY PROCESSED
ER-03 ENTER NUMBER
