     H DATEDIT(*YMD.)
     F** INQR05B *******************************************
     F*  USER ID INQ BY NAME                               *
     F*  J.WATANABE  2026.02.25                            *
     F******************************************************
     FINQPW05B  CF   E             WORKSTN
     F                                     INFDS(INFDS)
     F                                     SFILE(SFL01:RRN)
     FRGAPL12   IF   E           K DISK
      *
     D INFDS           DS
     D  $$RRN                378    379B 0
      *
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
     C                   MOVEL(P)  $ID           K#PL12           15
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
      * F10: BY USER ID
     C     *INKJ         WHENEQ    *ON
     C                   MOVE      *BLANK        PNONY
     C                   CALL      'INQR05A'
     C                   PARM                    PNONY             4
      * ENTR
     C                   OTHER
      *
     C     *IN73         IFEQ      *OFF
     C                   MOVEL(P)  D1POS         K#PL12
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
     C     K#PL12        SETLL     RGAPL12
     C*-------------------------
S1   C                   DO        *HIVAL
     C                   READ      RGAPL12                                90
     C   90              LEAVE
 S2  C     J8SKJY        IFEQ      'D'
     C                   ITER
 E2  C                   ENDIF
     C*
     C                   MOVEL     J8PROF        S1CODE
     C                   MOVEL     J8NAME        S1NAME
     C                   Z-ADD     J8KOHZ        S1KOHZ
     C                   Z-ADD     J8KOTM        S1KOTM
      *
     C                   MOVEL     *BLANK        WCODE             7
     C                   MOVEL     *BLANK        WNAME            15
     C                   MOVEL     J8PROF        WCODE
     C                   MOVEL     J8NAME        WNAME
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
