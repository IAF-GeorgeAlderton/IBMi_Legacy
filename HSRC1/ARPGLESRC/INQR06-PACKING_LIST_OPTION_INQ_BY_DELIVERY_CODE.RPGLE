     H DATEDIT(*YMD.)
     F** INQR06  *******************************************
     F*  PACKING LIST OPTION INQ BY DELIVERY CODE          *
     F*  J.WATANABE  2026.03.04                            *
     F******************************************************
     FINQPW06   CF   E             WORKSTN
     F                                     INFDS(INFDS)
     F                                     SFILE(SFL01:RRN)
     FAB#PL90   IF   E           K DISK
      *
     D INFDS           DS
     D  $$RRN                378    379B 0
      *
     D                 DS
     D  YAKOHZ                 1      8  0
     D  YAKOYY                 1      4  0
     D  YAKOMM                 5      6  0
     D  YAKODD                 7      8  0
     D                 DS
     D  YAKOTM                 1      4  0
     D  YAKOHH                 1      2  0
     D  YAKOSS                 3      4  0
      *****************************************************
      * MAIN ROUTINE                                      *
      *****************************************************
     C                   MOVE      '#INIT   '    @STEP             8
     C*
     C     @STEP         DOUEQ     '#END    '
     C     @STEP         CASEQ     '#INIT   '    #INIT                          初期処理
     C     @STEP         CASEQ     '#DSP1   '    #DSP1
     C                   ENDCS
     C                   ENDDO
     C*
     C                   SETON                                        LR
     C                   RETURN
     C*===============================================================
     C*  INITIAL SET
     C*===============================================================
     C     #INIT         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    $ID               4
      *
     C                   MOVEA     *ALL'0'       *IN
     C                   MOVEL     $ID           K#PL09            4
     C                   EXSR      #SET
      *
     C                   ENDSR
     C*===============================================================
      *  DISPLAY SREEN
     C*===============================================================
     C     #DSP1         BEGSR
     C                   SETON                                        71
     C                   WRITE     DSP99
     C                   EXFMT     CTL01
     C                   SETOFF                                       71
     C                   MOVEA     '0'           *IN(99)
     C                   Z-ADD     $$RRN         DSPRRN
      *-----*
      * END *
      *-----*
     C     *INKA         IFEQ      *ON
     C     *INKC         OREQ      *ON
     C     *INKL         OREQ      *ON
     C                   MOVE      '#END    '    @STEP
     C                   GOTO      XDSP1
     C                   ENDIF
      *
     C     *IN73         IFEQ      *OFF
     C                   MOVEL     D1POS         K#PL09
     C                   EXSR      #SET
     C                   ENDIF
      *
     C     XDSP1         ENDSR
     C*===============================================================
      *  SET SFL01
     C*===============================================================
     C     #SET          BEGSR
      *  SFLCLR
     C                   SETON                                        72
     C                   WRITE     CTL01
     C                   SETOFF                                       72
     C                   Z-ADD     0             RRN               4 0
     C                   MOVE      *BLANK        @@UMU             1
      *
     C     K#PL09        SETLL     AB#PL90
     C*-------------------------
S1   C                   DO        *HIVAL
     C                   READ      AB#PL90                                90
     C   90              LEAVE
 S2  C     YASKJY        IFEQ      'D'
     C                   ITER
 E2  C                   ENDIF
     C*
     C                   MOVEL     YATOKU        S1NONY
      *
     C                   MOVEL     YATOKU        $DLV
     C                   CALL      'UTLR62'
     C                   PARM                    $DLV              4
     C                   PARM                    $GRP              3
     C                   PARM                    $NAME1           15
     C                   PARM                    $NAME2           50
     C                   PARM                    $RTN              1
     C                   MOVEL     $NAME1        S1NAME
      *
     C                   Z-ADD     YAKOHZ        S1KOHZ
     C                   Z-ADD     YAKOTM        S1KOTM
     C                   MOVEL     YAKOME        S1KOME
      *
     C                   MOVEL     YATYPE        S1TYPE
     C                   Z-ADD     YAMXPL        S1MAX
     C                   Z-ADD     YAPICK        S1PICK
     C                   Z-ADD     YA#MIX        S1MIX
     C                   Z-ADD     YACUST        S1CUST
     C                   Z-ADD     YA#LAB        S1#LAB
      * RETRIEVE SPLIT FLAG
     C                   CALL      'UTLR52B'
     C                   PARM                    $DLV
     C                   PARM                    $MIX              1
     C                   MOVEL     $MIX          S1MFLG
      *
     C                   ADD       1             RRN
     C                   WRITE     SFL01
E1   C                   ENDDO
     C*-------------------------
     C     RRN           IFEQ      0
     C                   MOVE      '#END    '    @STEP
     C                   ELSE
     C                   MOVE      '#DSP1   '    @STEP
     C                   Z-ADD     1             DSPRRN
     C                   ENDIF
      *
     C                   ENDSR
