     H DATEDIT(*YMD.) OPTION(*SRCSTMT : *NODEBUGIO)
     F** AA#R02 ********************************************
     F*  DELIVERY CODE INQ BY CODE                         *
     F*  J.WATANABE  2021.06.24                            *
     F*  ABCDEFG HIJKLMNOP                                 *
     F*  abcdefg hijklmnop                                 *
     F******************************************************
     FAA#PW01   CF   E             WORKSTN
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
     C     @STEP         CASEQ     '#INIT   '    #INIT
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
     C**   *ENTRY        PLIST
     C**                 PARM                    $ID               4
     C                   CLEAR                   $ID               4
      *
     C                   EVAL      *IN = *ALL'0'
      *  CLEAR SFL01
     C                   SETON                                        82
     C                   WRITE     SFCTL1
     C                   SETOFF                                       82
     C                   CLEAR                   RRN               4 0
     C                   CLEAR                   ENDRRN            4 0
     C                   CLEAR                   K#PL01            4 0
     C                   CLEAR                   @@UMU             1
      *
     C                   IF        $ID = *BLANK
     C                   EVAL      K#PL01 = 0
     C                   ELSE
     C                   MOVEL     $ID           K#PL01
     C                   ENDIF
      *
     C     K#PL01        SETLL     FGBPL01
     C*-------------------------
S1   C                   DO        *HIVAL
     C                   READ      FGBPL01
     C                   IF        %EOF
     C                   LEAVE
     C                   ENDIF
      *
 S2  C                   IF        B2SKJY <> 'D'
     C*
     C                   MOVEL     B2CODE        @CODE
     C                   EVAL      @NAME = B2SMEI
     C                   EVAL      @KOHZ = B2KOHZ
     C                   EVAL      @KOTM = B2KOTM
     C                   EVAL      @KOUS = B2KOME
      *
     C                   MOVEL     *BLANK        WCODE             4
     C                   MOVEL     *BLANK        WNAME            15
     C                   MOVEL     B2CODE        WCODE
     C                   MOVEL     B2SMEI        WNAME
      *
     C                   EVAL      RRN = RRN + 1
     C                   WRITE     SFREC1
      *
 E2  C                   ENDIF
E1   C                   ENDDO
     C*-------------------------
     C                   IF        RRN = 0
     C                   EVAL      @STEP = '#END    '
     C                   ELSE
     C                   EVAL      @STEP = '#DSP1   '
     C                   EVAL      DSPRRN = DSPRRN + 1
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
     C                   EVAL      DSPRRN = $$RRN
      *----*
      * F3 *
      *----*
     C                   IF        (*INKA = *ON) OR (*INKC = *ON) OR
     C                             (*INKL = *ON)
     C                   EVAL      @STEP = '#END    '
     C                   ENDIF
      *
     C                   ENDSR
