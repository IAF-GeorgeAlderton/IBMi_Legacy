     H DATEDIT(*YMD.)
     F***CHKR39D ***************************************************************
     F*  PROGRAM    : CHECK DUPLICATE FORECAST BY USER PART#                   *
     F*             : READ ABBPL05                                             *
     F*  WRITTEN    : JW   2022.12.02                                          *
     F**************************************************************************
     FABBPL05   IF   E           K DISK
     FQPRINT    O    F  198        PRINTER OFLIND(*INOF)
     D DK              S              4    DIM(5)
     D                 DS
     D  SDATE                  1     14  0
     D  NOW                    1      6  0
     D  TODAY                  7     14  0
     D                 DS
     D  Q5MHIN                 1     23
     D  Q5MHN1                 1      5
     D  HP1                    6      6
     D  Q5MHN2                 7     11
     D  HP2                   12     12
     D  Q5MHN3                13     17
     D  HP3                   18     18
     D  Q5MHN4                19     23
     D                SDS
     D  #PGM                   1     10
     D  #WSID                244    253
     D  #USER                254    263
      *************************************************************************
     C                   EXSR      #INIT
      *
     C                   DO        *HIVAL
     C                   READ      ABBPL05                                98
     C   98              LEAVE
      * FIRST?
     C                   IF        FIRST  = 'Y'
     C                   EVAL      FIRST  = 'N'
     C                   EVAL      SVCUST = Q5TOKU
     C                   EVAL      SVNONY = Q5NONY
     C                   EVAL      SVMHIN = Q5MHIN
     C                   ENDIF
      * BREAK?
     C                   IF        Q5NONY <> SVNONY
     C                   EXSR      #BRK1
     C                   EXSR      #BRK2
     C                   ELSE
     C                   IF        Q5MHIN <> SVMHIN
     C                   EXSR      #BRK1
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      PX = PX + 1
     C                   IF        PX = 5
     C                   EVAL      DK(PX) = Q5NUKE
     C                   ENDIF
      *
     C                   ENDDO
      * LAST BREAK
     C                   IF        FIRST = 'N'
     C                   EXSR      #BRK1
     C                   EXSR      #BRK2
     C                   ENDIF
      * SET FLAG
     C                   IF        SEQ# <> 0
     C                   EVAL      $RTN = '*'
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *----------------------------------------------------*
      *  BREAK1: MHIN                                      *
      *----------------------------------------------------*
     C     #BRK1         BEGSR
      *
     C                   IF        PX >= 2
     C                   EXSR      #CHKD                                        CHECK DOCK
     C                   IF        *IN85 = *ON
     C                   EXSR      #PRNT1
     C                   EVAL      PFLG = *ON
      *
     C                   IF        $UPD = 'Y'
     C                   EXSR      #PRG1
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      * RESET
     C                   EVAL      SVMHIN = Q5MHIN
     C                   EVAL      PX = 0
     C                   EVAL      DK = *ALL' '
      *
     C                   ENDSR
      *----------------------------------------------------*
      *  PURGE ABBPP01
      *----------------------------------------------------*
     C     #PRG1         BEGSR
      * REMOVE BLANK
     C                   EVAL      $FLD1 = SVMHIN
     C                   CALL      'UUUR05 '
     C                   PARM                    $FLD1            25
     C                   PARM                    $FLD2            25
      * PURGE
     C                   MOVEL     SVCUST        $CUST
     C                   MOVEL     SVNONY        $NONY
     C                   EVAL      $MHIN = $FLD2
     C                   CALL      'CHKR39F'
     C                   PARM                    $CUST             4
     C                   PARM                    $NONY             4
     C                   PARM                    $MHIN            20
      *
     C                   ENDSR
      *----------------------------------------------------*
      *  CHECK DOCK CODE = '00'                            *
      *----------------------------------------------------*
     C     #CHKD         BEGSR
      * 00
     C                   MOVE      *OFF          *IN85
     C     1             DO        5             IX                2 0
     C     DK(IX)        IFEQ      '00'
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDDO
      *
      * SAME DOCK
     C     DK(1)         IFNE      *BLANK
     C     DK(2)         ANDNE     *BLANK
     C     DK(1)         IFEQ      DK(2)
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDIF
     C     DK(1)         IFNE      *BLANK
     C     DK(3)         ANDNE     *BLANK
     C     DK(1)         IFEQ      DK(3)
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDIF
     C     DK(1)         IFNE      *BLANK
     C     DK(4)         ANDNE     *BLANK
     C     DK(1)         IFEQ      DK(4)
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDIF
     C     DK(1)         IFNE      *BLANK
     C     DK(5)         ANDNE     *BLANK
     C     DK(1)         IFEQ      DK(5)
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDIF
      *
     C     DK(2)         IFNE      *BLANK
     C     DK(3)         ANDNE     *BLANK
     C     DK(2)         IFEQ      DK(3)
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDIF
     C     DK(2)         IFNE      *BLANK
     C     DK(4)         ANDNE     *BLANK
     C     DK(2)         IFEQ      DK(4)
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDIF
     C     DK(2)         IFNE      *BLANK
     C     DK(5)         ANDNE     *BLANK
     C     DK(2)         IFEQ      DK(5)
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDIF
      *
     C     DK(3)         IFNE      *BLANK
     C     DK(4)         ANDNE     *BLANK
     C     DK(3)         IFEQ      DK(4)
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDIF
     C     DK(3)         IFNE      *BLANK
     C     DK(5)         ANDNE     *BLANK
     C     DK(3)         IFEQ      DK(5)
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDIF
      *
     C     DK(4)         IFNE      *BLANK
     C     DK(5)         ANDNE     *BLANK
     C     DK(4)         IFEQ      DK(5)
     C                   MOVE      *ON           *IN85
     C                   GOTO      XCHKD
     C                   ENDIF
     C                   ENDIF
      *
     C     XCHKD         ENDSR
      *----------------------------------------------------*
      *  BREAK2: NONY                                      *
      *----------------------------------------------------*
     C     #BRK2         BEGSR
      *
     C     PFLG          IFEQ      *ON
     C                   EXSR      #PRNT2
     C                   ENDIF
      * RESET
     C                   Z-ADD     Q5TOKU        SVCUST
     C                   Z-ADD     Q5NONY        SVNONY
     C                   MOVE      *OFF          PFLG
      *
     C                   ENDSR
      *----------------------------------------------------*
      *  PRINT 1                                           *
      *----------------------------------------------------*
     C     #PRNT1        BEGSR
      *
     C     LIN#          IFGE      66
     C                   EXCEPT    @HDR
     C                   Z-ADD     3             LIN#
     C                   ENDIF
      *
     C                   ADD       1             SEQ#
     C                   EXCEPT    @DTL1
     C                   ADD       1             LIN#
     C                   Z-ADD     0             PX                3 0
      *
     C                   ENDSR
      *----------------------------------------------------*
      *  PRINT 2                                           *
      *----------------------------------------------------*
     C     #PRNT2        BEGSR
      *
     C                   EXCEPT    @DTL2
     C                   ADD       1             LIN#
      *
     C                   ENDSR
      *----------------------------------------------------*
      *  INITIAL SETTING                                   *
      *----------------------------------------------------*
     C     #INIT         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    $UPD              1
     C                   PARM                    $RTN              1
      *
     C     $UPD          IFNE      'Y'
     C                   MOVE      'N'           $UPD
     C                   ENDIF
      *
     C                   MOVE      *BLANK        $RTN
     C                   TIME                    SDATE
     C                   Z-ADD     0             SEQ#              4 0
     C                   Z-ADD     88            LIN#              3 0
     C                   MOVE      'Y'           FIRST             1
     C                   MOVE      *OFF          PFLG              1            PRINT FLG
     C                   MOVE      *ALL' '       DK
     C                   Z-ADD     0             SVCUST            4 0
     C                   Z-ADD     0             SVNONY            4 0
     C                   MOVE      *BLANK        SVMHIN           23
     C
     C
      *
     C                   ENDSR
      *****************************************************************
     OQPRINT    E            @HDR             01
     O                       #PGM                10
     O                                           18 'UPDATE='
     O                       $UPD                19
     O                                           40 '** DUPLICATE FORECAS'
     O                                           60 'T DATA (ABBPP01) ** '
     O                                           99 'DATE'
     O                       TODAY               82 '    .  .  '
     O                       NOW                 92 '  :  :  '
     O                                           95 'P.'
     O                       PAGE          Z     99
     O          E            @HDR             03
     O                                            6 'SEQ#'
     O                                           12 'DELV'
     O                                           23 'USER_PART'
     O                                           42 'DK1'
     O                                           48 'DK2'
     O                                           54 'DK3'
     O                                           60 'DK4'
     O                                           66 'DK5'
     O          E            @DTL1       1
     O                       SEQ#          Z   +002
     O                       SVNONY            +002
     O                       SVMHIN            +002
     O                       DK(1)             +002
     O                       DK(2)             +002
     O                       DK(3)             +002
     O                       DK(4)             +002
     O                       DK(5)             +002
      *
     O          E            @DTL2       1
     O                                         +000 '.'
