     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IZAR70U ******************************************************
      *  UPDATE WIRE KANBAN IN INVENTORY AND LOG
      *   LEC   2025.05.19
      *****************************************************************
     FALBPL30   IF   E           K DISK
     FIZAPL02   IF   E           K DISK
     FCACPL02   IF   E           K DISK
     FIZAPP70   UF A E           K DISK
     FIZAPP7L   O  A E           K DISK
      *
     D WK1             S              1    DIM(20)
     D WK2             S              1    DIM(20)
      *
     D                 DS
     D  @TIME                  1     14  0
     D  @SYSTM                 1      6  0
     D  @SYSHZ                 7     14  0
      *
     D                 DS
     D  @WKBN                  1     17
     D  @WTYPE                 1      1
     D  @WZETI                 2      5
     D  @WMFG#                 6     12
     D  @WCOIL                13     15
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
     C     *ENTRY        PLIST
     C                   PARM                    PWKBN            20
     C                   PARM                    PLOCN             6
     C                   PARM                    PWKCD             6
     C                   PARM                    PPGMN            10
     C                   PARM                    PLOTN             8
     C                   PARM                    PCHRG#            7
     C                   PARM                    PWGT              5 1
     C                   PARM                    PCHGQ             1
     C                   PARM                    PNEWQ             2 1
     C                   PARM                    #RTNC             1
      *
      * GET WORKER NAME...
     C                   MOVEL     PWKCD         NUM6              6 0
     C     NUM6          CHAIN     ALBPL30                            98
     C     *IN98         IFEQ      *OFF
     C                   MOVEL     ALWKNM        ##TMNM           20
     C                   ELSE
     C                   MOVEL     *BLANK        ##TMNM
     C                   ENDIF
      *
      *----------------------------------------------------*
      * MAINLINE                                           *
      *----------------------------------------------------*
      *
     C                   EXSR      #EDIT
     C                   MOVEL     PWKBN         @WKBN
     C                   EXSR      #SB100
      *
     C     VALID         IFEQ      'Y'
     C                   EXSR      #SB500
     C     LOGFLG        IFEQ      'Y'
     C                   EXSR      #SB501
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      VALID         #RTNC
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *------------------------------------------------------*
      * CHECK WIRE MATERIAL MASTER FILE                      *
      *------------------------------------------------------*
     C     #SB100        BEGSR
      *
      * CHECK FOR PART ID IN MATERIAL MASTER...
     C     KEY1          KLIST
     C                   KFLD                    @WTYPE
     C                   KFLD                    @WZETI
      *
      *
     C     KEY1          SETGT     IZAPL02
     C     KEY1          READPE    IZAPL02                                91
      *
     C  N91ZCSKJY        IFEQ      'D'
     C                   SETON                                        91
     C                   ENDIF
      *
     C  N91ZCSTYY        IFNE      9999
     C                   SETON                                        91
     C                   ENDIF
      *
     C     *IN91         IFEQ      *ON
     C                   MOVE      'N'           VALID             1
     C                   ELSE
     C                   MOVE      'Y'           VALID
     C                   ENDIF
      *
     C                   ENDSR
      *----------------------------------------------------*
      *  WIRE KANBAN SCAN TO INVENTORY FILE
      *----------------------------------------------------*
     C     #SB500        BEGSR
      *
     C                   TIME                    @TIME
     C                   CLEAR                   IZAPP701
      *
     C                   MOVEL     PWKBN         KBNQR            20
     C     KBNQR         CHAIN     IZAPP70                            62
     C     *IN62         IFEQ      *ON
     C                   Z-ADD     @SYSHZ        WICODT
     C                   Z-ADD     @SYSTM        WICOTM
     C                   MOVEL     ##TMNM        WICOUS
     C                   MOVEL     PPGMN         WIKOPG
      *
     C                   MOVEL     PWKBN         WIKBQR
     C                   MOVEL     @WZETI        WIZETI
     C                   MOVEL     ZCZAIS        WIMATN
     C                   Z-ADD     ZCZAIK        WIDIAM
     C                   MOVEL     ZCKAKE        WISUPP
      *
     C     WIMATN        CHAIN     CACPL02                            55
     C     *IN55         IFEQ      *OFF
     C                   MOVEL     C1ZAIR        WIMATC
     C                   ENDIF
      *
     C                   MOVEL     @WMFG#        WIQA#
     C                   MOVEL     @WCOIL        WICOIL
     C                   MOVEL     PLOCN         WICLOC
     C     PCHGQ         IFEQ      'Y'
     C                   Z-ADD     PNEWQ         WIQTY
     C                   ELSE
     C                   Z-ADD     1             WIQTY
     C                   ENDIF
      *
     C     PLOTN         IFNE      *BLANK
     C                   MOVEL     PLOTN         WILOT
     C                   ENDIF
      *
     C     PCHRG#        IFNE      *BLANK
     C                   MOVEL     PCHRG#        WICHRG
     C                   ENDIF
      *
     C     PWGT          IFGT      *ZERO
     C     WISUPP        IFEQ      '4550'
     C     PWGT          MULT      10            WIWGT
     C                   ELSE
     C                   MOVEL     PWGT          WIWGT
     C                   ENDIF
     C                   ENDIF
      *
     C                   WRITE     IZAPP701
     C                   MOVE      'Y'           LOGFLG            1
      *
     C                   ELSE
      *********  PLOCN     IFNE WICLOC
     C                   Z-ADD     @SYSHZ        WIKODT
     C                   Z-ADD     @SYSTM        WIKOTM
     C                   MOVEL     ##TMNM        WIKOUS
     C                   MOVEL     PPGMN         WIKOPG
     C                   MOVEL     WICLOC        WIPLOC
     C                   MOVEL     PLOCN         WICLOC
     C     PCHGQ         IFEQ      'Y'
     C                   Z-ADD     PNEWQ         WIQTY
     C                   ENDIF
      *
     C     PLOTN         IFNE      *BLANK
     C                   MOVEL     PLOTN         WILOT
     C                   ENDIF
      *
     C     PCHRG#        IFNE      *BLANK
     C                   MOVEL     PCHRG#        WICHRG
     C                   ENDIF
      *
     C     PWGT          IFNE      *ZERO
     C                   MOVEL     PWGT          WIWGT
     C                   ENDIF
      *
     C                   UPDATE    IZAPP701
     C                   MOVE      'Y'           LOGFLG
      *
      *********            ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *----------------------------------------------------*
      * WRITE WIRE KANBAN SCAN TO INVENTORY LOG FILE
      *----------------------------------------------------*
     C     #SB501        BEGSR
      *
     C                   CLEAR                   IZAPP7L1
     C                   Z-ADD     @SYSHZ        LGKODT
     C                   Z-ADD     @SYSTM        LGKOTM
     C                   MOVEL     ##TMNM        LGKOUS
     C                   MOVEL     PPGMN         LGKOPG
      *
     C                   MOVEL     WIKBQR        LGKBQR
     C                   MOVEL     WIZETI        LGZETI
     C                   MOVEL     WIMATN        LGMATN
     C                   Z-ADD     WIDIAM        LGDIAM
     C                   MOVEL     WISUPP        LGSUPP
     C                   MOVEL     WIMATC        LGMATC
     C                   MOVEL     WIQA#         LGQA#
     C                   MOVEL     WICOIL        LGCOIL
     C                   MOVEL     WIPLOC        LGPLOC
     C                   MOVEL     WICLOC        LGCLOC
     C                   Z-ADD     WIQTY         LGQTY
     C                   MOVEL     WILOT         LGLOT
     C                   MOVEL     WICHRG        LGCHRG
     C                   Z-ADD     WIWGT         LGWGT
      *
     C                   WRITE     IZAPP7L1
      *
     C                   ENDSR
      *------------------------------------------------------------*
      * EDIT WIRE KANBAN BARCODE - REMOVE DASHES UNLSESS CHECK DIGIT
      *------------------------------------------------------------*
     C     #EDIT         BEGSR
      *
     C                   MOVEA(P)  PWKBN         WK1
     C                   MOVEA     *BLANK        WK2
     C                   Z-ADD     *ZERO         X                 2 0
     C                   Z-ADD     *ZERO         Y                 2 0
      *
     C     1             DO        20            X
     C     WK1(X)        IFNE      '-'
     C     WK1(X)        ANDNE     *BLANK
     C     X             ORGT      15
     C                   ADD       1             Y
     C                   MOVE      WK1(X)        WK2(Y)
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVEA(P)  WK2           PWKBN
      *
     C                   ENDSR
      *
      *----------------------------------------------------*
