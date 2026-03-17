     H DATEDIT(*YMD.)
     F** INQR01 ********************************************
     F*  EDI SHIPPING LEAD TIME TABLE INQ                  *
     F*  J.W     2024.07.08                                *
     F*----------------------------------------------------*
     F*  MANTENANCE PROGRAM FOR AB#EP02 IS EDIR74          *
     F******************************************************
     FINQPW01A  CF   E             WORKSTN
     F                                     INFDS(INFDS)
     F                                     SFILE(SFL01:RRN)
     FAB#EP02   IF   E           K DISK
      *****************************************************
     D MSG             S             60    DIM(1) CTDATA PERRCD(1)
     D INFDS           DS
     D  $$RRN                378    379B 0
      *
     D                 DS
     D  SDATE                  1     14  0
     D  NOW                    1      6  0
     D  TODAY                  7     14  0
     D  @TODAY                 7     12  0
     C*===============================================================
     C                   MOVE      '#INIT   '    @STEP             8
      *
     C     @STEP         DOUEQ     '#END    '
     C     @STEP         CASEQ     '#INIT   '    #INIT
     C     @STEP         CASEQ     '#DSP1   '    #DSP1
     C                   ENDCS
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
     C*===============================================================
      * DSPLAY SCREEN 1
     C*===============================================================
     C     #DSP1         BEGSR
      *
     C                   SETON                                        70
     C     ENDRRN        IFNE      0
     C                   SETON                                        71
     C                   ENDIF
      *
     C                   WRITE     DSP99
     C                   EXFMT     CTL01
     C                   SETOFF                                       7071
     C                   MOVEA     '0'           *IN(99)
     C                   Z-ADD     $$RRN         DSPRRN
      *---------*
      * F3: END *
      *---------*
     C     *INKA         IFEQ      *ON
     C     *INKC         OREQ      *ON
     C     *INKL         OREQ      *ON
     C                   MOVE      '#END    '    @STEP
     C                   GOTO      XDSP1
     C                   ENDIF
      *--------------*
      * PAGE UP/DOWN *
      *--------------*
     C     *IN73         IFEQ      *ON
     C                   MOVE      '#DSP1   '    @STEP
     C                   GOTO      XDSP1
     C                   ENDIF
      *-------------*
      * ENTR KEY    *
      *-------------*
     C                   EXSR      #SET
     C                   MOVE      '#DSP1   '    @STEP
     C                   Z-ADD     1             DSPRRN
     C                   GOTO      XDSP1
      *
     C     XDSP1         ENDSR
     C*===============================================================
     C* SET SUBFILE
     C*===============================================================
     C     #SET          BEGSR
      *  SFLCLR
     C                   SETON                                        72
     C                   WRITE     CTL01
     C                   SETOFF                                       72
     C                   Z-ADD     0             RRN               4 0
     C                   Z-ADD     0             ENDRRN            4 0
     C                   CLEAR                   SFL01
      *
      *-------------------------
     C                   MOVEL     XNONY         @NONY
      *
     C     @NONY         SETLL     AB#EP02
S1   C                   DO        *HIVAL
     C                   READ      AB#EP02                                98
     C   98              LEAVE
      *
     C     P2SKJY        IFEQ      'D'
     C**         P2NOTE    OREQ *BLANK
     C                   ITER
     C                   ENDIF
      *
     C     XNONY         IFNE      0
     C     XNONY         ANDGT     P2NONY
     C                   ITER
     C                   ENDIF
      * DETAIL
     C                   Z-ADD     P2NONY        S1NONY
     C                   MOVEL     P2NAME        S1NAME
     C                   Z-ADD     P2LDTM        S1LDTM
     C                   MOVEL     P2CND1        S1CND1
     C                   MOVEL     P2DAY1        S1DAY1
     C                   MOVEL     P2DAY2        S1DAY2
     C                   MOVEL     P2NOTE        S1NOTE
     C                   MOVEL     P2FLG1        S1FLG1
     C     P2FLG1        IFEQ      'Y'
     C                   MOVE      'YES'         S1FLGX
     C                   ELSE
     C                   MOVE      *BLANK        S1FLGX
     C                   ENDIF
      *
     C     P2UPHZ        IFEQ      0
     C                   Z-ADD     P2CRHZ        S1KOHZ
     C                   ELSE
     C                   Z-ADD     P2UPHZ        S1KOHZ
     C                   ENDIF
      *
     C                   MOVEL     P2PRTN        S1PRTN
      *
     C                   ADD       1             RRN
     C                   WRITE     SFL01
E1   C                   ENDDO
      *
     C     RRN           IFEQ      0
     C                   ADD       1             RRN
     C                   MOVEL     MSG(1)        S1NAME
     C                   WRITE     SFL01
     C                   ENDIF
      *
     C                   Z-ADD     RRN           ENDRRN
      *
     C                   ENDSR
     C*===============================================================
     C* INITIAL SETTINGS
     C*===============================================================
     C     #INIT         BEGSR
      *
     C                   MOVEA     *ALL'0'       *IN
     C                   TIME                    SDATE
     C                   Z-ADD     0             @NONY             4 0
     C*-------------------------
     C                   EXSR      #SET
      *
     C     RRN           IFEQ      0
     C                   MOVE      '#END    '    @STEP
     C                   ELSE
     C                   MOVE      '#DSP1   '    @STEP
     C                   Z-ADD     1             DSPRRN
     C                   ENDIF
      *
     C                   ENDSR
** MSG (60A) ......2.........3.........4.........5.........6
 ** NO DATA EXISTS **
