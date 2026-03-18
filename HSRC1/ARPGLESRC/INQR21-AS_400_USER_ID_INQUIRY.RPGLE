     H DATEDIT(*YMD.)
     F** CHKR21 CHANGED TO --> INQR21 **********************
     F*     AS/400 USER ID INQUIRY                         *
     F*  T.SAKAKI                           2017.06.27     *
     F******************************************************
     FINQPW22   CF   E             WORKSTN
     F                                     INFDS(INFDS)
     F                                     SFILE(SFREC1:RRN)
     FRGAPL11   IF   E           K DISK
     F******************************************************
      *
     D INFDS           DS
     D  $$RRN                378    379B 0
     D****************************
     D*プログラム状況データ構造*
     D****************************
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
     D  J8KOHZ                 1      8  0
     D  J8KOYY                 1      4  0
     D  J8KOMM                 5      6  0
     D  J8KODD                 7      8  0
     D                 DS
     D  J8KOTM                 1      4  0
     D  J8KOJI                 1      2  0
     D  J8KOFN                 3      4  0
     C*************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    MSW1              1
     C*
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
     C* 初期ﾈｮmb
     C*===============================================================
     C     #INIT         BEGSR
     C                   MOVEA     *ALL'0'       *IN
     C*  SFLCLR
     C                   SETON                                        82
     C                   WRITE     SFCTL1
     C                   SETOFF                                       82
     C                   Z-ADD     0             RRN               4 0
     C                   Z-ADD     0             ENDRRN            4 0
     C                   MOVE      *BLANK        @@UMU             1            データ有無
     C*
     C*          1         SETLLRGAPL11
     C*-------------------------
S1   C                   DO        *HIVAL
     C                   READ      RGAPL11                                90
     C   90              LEAVE
 S2  C     J8SKJY        IFEQ      'D'
     C                   ITER
 E2  C                   ENDIF
     C*
     C                   MOVEL     J8PROF        @USRID
     C                   MOVEL     J8NAME        @USRNM
     C                   Z-ADD     J8KOHZ        @KOHZ
     C                   Z-ADD     J8KOTM        @KOTM
      *
     C                   MOVEL     *BLANK        WUSRID           10
     C                   MOVEL     *BLANK        WUSRNM           15
     C                   MOVEL     J8PROF        WUSRID
     C                   MOVEL     J8NAME        WUSRNM
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
      *画面１*
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
     C   KC              MOVE      '#END    '    @STEP
      *-----*
      * F10 *
      *-----*
     C   KJ              MOVEL     '1'           MSW1
     C   KJ              MOVE      '#END    '    @STEP
     C                   ENDSR
      *****************************************************************
