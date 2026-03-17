     H DATEDIT(*YMD.)
     F** INWR04 ********************************************
     F*  WORKER CODE INQ BY NAME                           *
     F*  J.WATANABE  2025.10.23                            *
     F******************************************************
     FINQPW04   CF   E             WORKSTN
     F                                     INFDS(INFDS)
     F                                     SFILE(SFL01:RRN)
     FAJSPLCE   IF   E           K DISK
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
     D  JAKOHZ                 1      8  0
     D  JAKOYY                 1      4  0
     D  JAKOMM                 5      6  0
     D  JAKODD                 7      8  0
     D                 DS
     D  JAKOTM                 1      4  0
     D  JAKOHH                 1      2  0
     D  JAKOSS                 3      4  0
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
     C                   PARM                    $ID               5
      *
     C                   MOVEA     *ALL'0'       *IN
     C                   MOVEL(P)  $ID           K#PL12           20
     C                   EXSR      #SET
      *
     C                   ENDSR
     C*===============================================================
      *  DISPLAY SCREEN
     C*===============================================================
     C     #DSP1         BEGSR
     C                   SETON                                        71
     C                   WRITE     DSP01
     C                   EXFMT     CTL01
     C                   SETOFF                                       71
     C                   MOVEA     '0'           *IN(99)
     C                   Z-ADD     $$RRN         DSPRRN
      *
     C                   SELECT
      * F1/3/12: END
     C     *INKA         WHENEQ    *ON
     C     *INKC         OREQ      *ON
     C     *INKL         OREQ      *ON
     C                   MOVE      '#END    '    @STEP
      * F10: BY CODE
     C     *INKJ         WHENEQ    *ON
     C                   MOVE      *BLANK        PCODE
     C                   CALL      'INQR03'
     C                   PARM                    PCODE             6
      * ENTR
     C                   OTHER
      *
     C     *IN73         IFEQ      *OFF
     C                   MOVEL(P)  XID           K#PL12
     C                   EXSR      #SET
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
     C*===============================================================
     C*  SET SFL
     C*===============================================================
     C     #SET          BEGSR
      *  SFLCLR
     C                   SETON                                        72
     C                   WRITE     CTL01
     C                   SETOFF                                       72
      *
     C                   Z-ADD     0             RRN               4 0
     C                   MOVE      *BLANK        @@UMU             1
      *
     C     K#PL12        SETLL     AJSPLCE
     C*-------------------------
S1   C                   DO        *HIVAL
     C                   READ      AJSPLCE                                90
     C   90              LEAVE
 S2  C     JASKJY        IFEQ      'D'
     C                   ITER
 E2  C                   ENDIF
     C*
     C                   MOVEL     JAWKCD        @CODE
     C                   MOVEL     JAWKNM        @NAME
     C                   Z-ADD     JAKOHZ        @KOHZ
     C                   Z-ADD     JAKOTM        @KOTM
     C                   MOVEL     JAKOME        @KOUS
      *
     C                   MOVEL     *BLANK        WCODE             4
     C                   MOVEL     *BLANK        WNAME            15
     C                   MOVEL     JAWKCD        WCODE
     C                   MOVEL     JAWKNM        WNAME
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
