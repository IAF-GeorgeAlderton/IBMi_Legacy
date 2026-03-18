     H DATEDIT(*YMD.)
     F** INQR16 ********************************************
     F*  DELIVERY CODE INQ BY CODE                         *
     F*  J.WATANABE  2021.06.24                            *
     F******************************************************
     FINQPW16   CF   E             WORKSTN
     F                                     INFDS(INFDS)
     F                                     SFILE(SFREC1:RRN)
     FFGBPL01   IF   E           K DISK
      *
     D INFDS           DS
     D  $$RRN                378    379B 0
      *
     D                SDS
     D  W$PGM            *PROC
     D  W$WSID               244    253
     D  W$USER               254    263
     D  W$JBNO               264    269
     D                 DS
     D  SBSKHZ                 1      8  0
     D  SBSKYY                 1      4  0
     D  SBSKMM                 5      6  0
     D  SBSKDD                 7      8  0
     D                 DS
     D  B2KOHZ                 1      8  0
     D  B2KOYY                 1      4  0
     D  B2KOMM                 5      6  0
     D  B2KODD                 7      8  0
     D                 DS
     D  B2KOTM                 1      4  0
     D  B2KOJI                 1      2  0
     D  B2KOPN                 3      4  0
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
     C*  SFLCLR
     C                   SETON                                        82
     C                   WRITE     SFCTL1
     C                   SETOFF                                       82
     C                   Z-ADD     0             RRN               4 0
     C                   Z-ADD     0             ENDRRN            4 0
     C                   MOVE      *BLANK        @@UMU             1
      *
     C     $ID           IFEQ      *BLANK
     C                   Z-ADD     0             K#PL01            4 0
     C                   ELSE
     C                   MOVEL     $ID           K#PL01
     C                   ENDIF
      *
     C     K#PL01        SETLL     FGBPL01
     C*-------------------------
S1   C                   DO        *HIVAL
     C                   READ      FGBPL01                                90
     C   90              LEAVE
 S2  C     B2SKJY        IFEQ      'D'
     C                   ITER
 E2  C                   ENDIF
     C*
     C                   MOVEL     B2CODE        @CODE
     C                   MOVEL     B2SMEI        @NAME
      *
     C                   MOVEL     B2CODE        $DLV
     C                   CALL      'UTLR62D'
     C                   PARM                    $DLV              4
     C                   PARM                    $GRP              3
     C                   PARM                    $GNAM            10
     C                   MOVEL     $GRP          @GRP
     C                   MOVEL     $GNAM         @GNAM
      *
     C                   Z-ADD     B2KOHZ        @KOHZ
     C                   Z-ADD     B2KOTM        @KOTM
     C                   MOVEL     B2KOME        @KOUS
      *
     C                   MOVEL     *BLANK        WCODE             4
     C                   MOVEL     *BLANK        WNAME            15
     C                   MOVEL     B2CODE        WCODE
     C                   MOVEL     B2SMEI        WNAME
      *
     C                   ADD       1             RRN
     C                   WRITE     SFREC1
E1   C                   ENDDO
     C*-------------------------
     C     RRN           IFEQ      0
     C                   MOVE      '#END    '    @STEP
     C                   ELSE
     C                   MOVE      '#DSP1   '    @STEP
     C                   Z-ADD     1             DSPRRN
     C                   ENDIF
     C                   ENDSR
     C*===============================================================
      *  DISPLAY SREEN
     C*===============================================================
     C     #DSP1         BEGSR
     C                   SETON                                        71
     C                   WRITE     DSP01
     C                   EXFMT     SFCTL1
     C                   SETOFF                                       71
     C                   MOVEA     '0'           *IN(99)
     C                   Z-ADD     $$RRN         DSPRRN
      *----*
      * F3 *
      *----*
     C   KA              MOVE      '#END    '    @STEP
     C   KC              MOVE      '#END    '    @STEP
     C   KL              MOVE      '#END    '    @STEP
      *
     C                   ENDSR
