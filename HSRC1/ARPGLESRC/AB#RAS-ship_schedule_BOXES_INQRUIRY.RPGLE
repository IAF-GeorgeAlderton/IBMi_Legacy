     H DATEDIT(*YMD.)
     F** AB#RABA *******************************************************
     F*  SHIP/SCHEDULE BOXES INQRUIRY                                  *
      *
      * TCHK1 08/11/08 CREATE(CCOPY FROM AB#RAB)
JW1   * JW    2020.08.11 ADD F6: (HT:OQ/LOQ/LAN/AOQ)
      *                  ADD F7: (ST:BZ/DS/DSM)
      *                  ADD F8: (JC:JC)
     F******************************************************* AB#RABA **
     FAB#PWAS   CF   E             WORKSTN
     F                                     SFILE(SFL02:RRN2)
     F                                     INFDS(@INFDS)
     FMBDPL03   IF   E           K DISK
     FFCEPL01   IF   E           K DISK
     FFGBPL01   IF   E           K DISK
     FAB#PL19C  IF   E           K DISK
     FAAPTL01   IF   E           K DISK
     FFCEPL40   IF   E           K DISK
JW1  FAB#WPAR   UF A E           K DISK
     FAB#WPAS   UF A E           K DISK
     FAB#WPAT   UF A E           K DISK
     FAAMPL11   IF   E           K DISK
     FABBPP7G   IF   E           K DISK
      *------------------------------------------------------------
     D CMD             S             78    DIM(4) CTDATA PERRCD(1)
     D**                  MSG     1   7 78
JW1  D MSG             S             60    DIM(10) CTDATA PERRCD(1)
     D YM              S              6  0 DIM(6)
TCHK1D @DT             S              8  0 DIM(31)
TCHK1D @AB             S              8  1 DIM(31)
TCHK1D @AQ             S              9  0 DIM(31)
TCHK1D @BB             S              8  1 DIM(31)
TCHK1D @BQ             S              9  0 DIM(31)
TCHK1D @CB             S              8  1 DIM(31)
TCHK1D @CQ             S              9  0 DIM(31)
TCHK1D @DB             S              8  1 DIM(31)
TCHK1D @DQ             S              9  0 DIM(31)
      *------------------------------------------------------------
     D @INFDS          DS
     D  @@REC                378    379B 0
     D                 DS
     D  QT                     1     42  0
     D                                     DIM(6)
     D  F3ENSU                 1      7  0
     D  F3DNSU                 8     14  0
     D  F3CNSU                15     21  0
     D  F3BNSU                22     28  0
     D  F3ANSU                29     35  0
     D  F3TNSU                36     42  0
TCHK1D                 DS
TCHK1D  DB                     1     42  0
     D                                     DIM(6)
TCHK1D  H@BOX1                 1      7  0
TCHK1D  H@BOX2                 8     14  0
TCHK1D  H@BOX3                15     21  0
TCHK1D  H@BOX4                22     28  0
TCHK1D  H@BOX5                29     35  0
TCHK1D  H@BOX6                36     42  0
TCHK1D                 DS
TCHK1D  DQ                     1     54  0
     D                                     DIM(6)
TCHK1D  H@QTY1                 1      9  0
TCHK1D  H@QTY2                10     18  0
TCHK1D  H@QTY3                19     27  0
TCHK1D  H@QTY4                28     36  0
TCHK1D  H@QTY5                37     45  0
TCHK1D  H@QTY6                46     54  0
     D                 DS
     D  DT                     1     42  0
     D                                     DIM(6)
     D  D@BOX1                 1      7  0
     D  D@BOX2                 8     14  0
     D  D@BOX3                15     21  0
     D  D@BOX4                22     28  0
     D  D@BOX5                29     35  0
     D  D@BOX6                36     42  0
TCHK1D                 DS
TCHK1D  DY                     1     54  0
     D                                     DIM(6)
TCHK1D  D@QTY1                 1      9  0
TCHK1D  D@QTY2                10     18  0
TCHK1D  D@QTY3                19     27  0
TCHK1D  D@QTY4                28     36  0
TCHK1D  D@QTY5                37     45  0
TCHK1D  D@QTY6                46     54  0
     D                 DS
     D  DD                     1     36  0
     D                                     DIM(6)
     D  D@YM1                  1      6  0
     D  D@YM2                  7     12  0
     D  D@YM3                 13     18  0
     D  D@YM4                 19     24  0
     D  D@YM5                 25     30  0
     D  D@YM6                 31     36  0
     D                 DS
     D  W@YMD                  1      8  0
     D  W@YY                   1      4  0
     D  W@MM                   5      6  0
     D  W@YM                   1      6  0
TCHK2D                 DS
TCHK2D  WW@YMD                 1      8  0
TCHK2D  WW@YM                  1      6  0
TCHK2D  WW@YY                  1      4  0
TCHK2D  WW@MM                  5      6  0
TCHK2D  WW@DD                  7      8  0
     D                 DS
     D  K@YM                   1      6  0
     D  K@NOYY                 1      4  0
     D  K@NOMM                 5      6  0
     D                 DS
     D  WFRM                   1      8  0
     D  WFYY                   1      4  0
     D  WFMM                   5      6  0
     D  WFDD                   7      8  0
     D                 DS
     D  WTO                    1      6  0
     D  WTYY                   1      4  0
     D  WTMM                   5      6  0
     D                SDS
     D  #PGM                   1      8
     D  #WSID                244    253
     D  #USER                254    263
TCHK2D                 DS
TCHK2D  BANOHZ                 1      8  0
TCHK2D  BANOYY                 1      4  0
TCHK2D  BANOMM                 5      6  0
TCHK2D  BANODD                 7      8  0
TCHK2D                 DS
TCHK2D  W@NOHZ                 1      8  0
TCHK2D  W@NOYY                 1      4  0
TCHK2D  W@NOMM                 5      6  0
TCHK2D  W@NODD                 7      8  0
TCHK2D                 DS
TCHK2D  BASHIN                 1     12
TCHK2D  BASHN1                 1      5
TCHK2D  BASHN2                 6     10
TCHK2D  BASHN3                11     12
TCHK2D                 DS
TCHK2D  W@SHIN                 1     12
TCHK2D  W@SHN1                 1      5
TCHK2D  W@SHN2                 6     10
TCHK2D  W@SHN3                11     12
TCHK2D                 DS
TCHK2D  A2SYHZ                 1      8  0
TCHK2D  A2SYYY                 1      4  0
TCHK2D  A2SYMM                 5      6  0
TCHK2D  A2SYDD                 7      8  0
TCHK2D                 DS
TCHK2D  #DT                    1     50
     D                                     DIM(5)
TCHK2D  S2SDT1                 1     10
TCHK2D  S2SDT2                11     20
TCHK2D  S2SDT3                21     30
TCHK2D  S2SDT4                31     40
TCHK2D  S2SDT5                41     50
TCHK2D                 DS
TCHK2D  #AB                    1     35  0
     D                                     DIM(5)
TCHK2D  S2B@A1                 1      7  0
TCHK2D  S2B@A2                 8     14  0
TCHK2D  S2B@A3                15     21  0
TCHK2D  S2B@A4                22     28  0
TCHK2D  S2B@A5                29     35  0
TCHK2D                 DS
TCHK2D  #AQ                    1     45  0
     D                                     DIM(5)
TCHK2D  S2Q@A1                 1      9  0
TCHK2D  S2Q@A2                10     18  0
TCHK2D  S2Q@A3                19     27  0
TCHK2D  S2Q@A4                28     36  0
TCHK2D  S2Q@A5                37     45  0
TCHK2D                 DS
TCHK2D  #BB                    1     35  0
     D                                     DIM(5)
TCHK2D  S2B@B1                 1      7  0
TCHK2D  S2B@B2                 8     14  0
TCHK2D  S2B@B3                15     21  0
TCHK2D  S2B@B4                22     28  0
TCHK2D  S2B@B5                29     35  0
TCHK2D                 DS
TCHK2D  #BQ                    1     45  0
     D                                     DIM(5)
TCHK2D  S2Q@B1                 1      9  0
TCHK2D  S2Q@B2                10     18  0
TCHK2D  S2Q@B3                19     27  0
TCHK2D  S2Q@B4                28     36  0
TCHK2D  S2Q@B5                37     45  0
TCHK2D                 DS
TCHK2D  #CB                    1     35  0
     D                                     DIM(5)
TCHK2D  S2B@C1                 1      7  0
TCHK2D  S2B@C2                 8     14  0
TCHK2D  S2B@C3                15     21  0
TCHK2D  S2B@C4                22     28  0
TCHK2D  S2B@C5                29     35  0
TCHK2D                 DS
TCHK2D  #CQ                    1     45  0
     D                                     DIM(5)
TCHK2D  S2Q@C1                 1      9  0
TCHK2D  S2Q@C2                10     18  0
TCHK2D  S2Q@C3                19     27  0
TCHK2D  S2Q@C4                28     36  0
TCHK2D  S2Q@C5                37     45  0
TCHK2D                 DS
TCHK2D  #DB                    1     35  0
     D                                     DIM(5)
TCHK2D  S2B@D1                 1      7  0
TCHK2D  S2B@D2                 8     14  0
TCHK2D  S2B@D3                15     21  0
TCHK2D  S2B@D4                22     28  0
TCHK2D  S2B@D5                29     35  0
TCHK2D                 DS
TCHK2D  #DQ                    1     45  0
     D                                     DIM(5)
TCHK2D  S2Q@D1                 1      9  0
TCHK2D  S2Q@D2                10     18  0
TCHK2D  S2Q@D3                19     27  0
TCHK2D  S2Q@D4                28     36  0
TCHK2D  S2Q@D5                37     45  0
TCHK2D                 DS
TCHK2D  W@DPDT                 1      8
TCHK2D  W@DPDA                 1      4
TCHK2D  W@DPDB                 5      6
TCHK2D  W@DPDC                 7      8
TCHK2D                 DS
TCHK2D  W#DPDT                 1      8
TCHK2D  W#DPD1                 1      5
TCHK2D  W#DPDB                 1      2
TCHK2D  W#DPSA                 3      3
TCHK2D  W#DPDC                 4      5
TCHK2D  W#DPSB                 6      6
TCHK2D  W#DPDA                 7      8
      *------------------------------------------------------------
      *   MAIN
      *------------------------------------------------------------
     C     @@ID          DOWNE     '99'
     C     @@ID          CASEQ     '01'          #DSP01
TCHK1C     @@ID          CASEQ     '03'          #DSP03
     C                   ENDCS
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *-----------------------------------------------------
     C     *INZSR        BEGSR
      *-----------------------------------------------------
     C     K#FCE         KLIST
     C                   KFLD                    F3SHN1
     C                   KFLD                    F3SHN2
     C                   KFLD                    F3SHN3
      *
     C                   MOVE      '01'          @@ID              2
     C                   Z-ADD     *ZERO         DD
     C                   Z-ADD     *ZERO         DB
     C                   Z-ADD     *ZERO         DT
TCHK1C                   Z-ADD     *ZERO         DQ
TCHK1C                   Z-ADD     *ZERO         DY
      *
TCHK1C                   MOVEL     *OFF          *IN71
      *
TCHK1C                   Z-ADD     *DATE         D@FRM
     C                   Z-ADD     *DATE         W@YMD
     C                   Z-ADD     *ZERO         YM
      *
     C                   ENDSR
      *-----------------------------------------------------
     C     #DSP01        BEGSR
      *-----------------------------------------------------
     C                   MOVE      CMD(1)        D@CMD
      *
     C                   WRITE     DSP99
     C                   EXFMT     DSP01
      *
     C                   SELECT
     C     *INKA         WHENEQ    *ON
     C                   MOVE      '99'          @@ID
     C                   OTHER
     C                   EXSR      #CHK1
     C     *IN99         IFEQ      *OFF
TCHK1C                   EXSR      #SET2
TCHK1C     RRN2          IFGT      *ZERO
TCHK1C                   MOVE      '03'          @@ID
TCHK1C                   ELSE
TCHK1C                   MOVE      MSG(1)        D@MSG
TCHK1C                   END
TCHK1C                   END
     C                   ENDSL
      *
     C                   ENDSR
      *-----------------------------------------------------
     C     #CHK1         BEGSR
      *-----------------------------------------------------
     C                   MOVEA     '00000000'    *IN(61)
     C                   MOVE      *OFF          *IN99
     C                   MOVE      *BLANK        D@MSG
      *
     C                   SELECT
     C     D@FRM         WHENEQ    *ZERO
     C                   MOVE      MSG(3)        D@MSG
     C                   SETON                                        6199
     C                   ENDSL
      *
     C     D@SHTO        IFNE      *BLANK
     C                   MOVE      D@SHTO        K@NONY            4 0
     C     K@NONY        CHAIN     MBDPL03                            90
     C     *IN90         IFEQ      *ON
     C  N99              MOVE      MSG(4)        D@MSG
     C                   SETON                                        6299
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
TCHK1C*-----------------------------------------------------
TCHK1C     #SET2         BEGSR
TCHK1C*-----------------------------------------------------
TCHK1C                   MOVE      *ON           *IN57
TCHK1C                   WRITE     CTL02
TCHK1C                   MOVE      *OFF          *IN57
TCHK1C                   Z-ADD     *ZERO         RRN2              4 0
TCHK1C*
TCHK1C                   CLEAR                   @DT
TCHK1C                   CLEAR                   @AB
TCHK1C                   CLEAR                   @AQ
TCHK1C                   CLEAR                   @BB
TCHK1C                   CLEAR                   @BQ
TCHK1C                   CLEAR                   @CB
TCHK1C                   CLEAR                   @CQ
TCHK1C                   CLEAR                   @DB
TCHK1C                   CLEAR                   @DQ
     C                   EXSR      #WPCLR
TCHK1C*
TCHK1C                   Z-ADD     *ZERO         W@AB              8 1
TCHK1C                   Z-ADD     *ZERO         W@AQ              9 0
TCHK1C                   Z-ADD     *ZERO         W@BB              8 1
TCHK1C                   Z-ADD     *ZERO         W@BQ              9 0
TCHK1C                   Z-ADD     *ZERO         W@CB              8 1
TCHK1C                   Z-ADD     *ZERO         W@CQ              9 0
TCHK1C                   Z-ADD     *ZERO         W@DB              8 1
TCHK1C                   Z-ADD     *ZERO         W@DQ              9 0
TCHK1C                   MOVEL     *BLANK        W@SHIN
TCHK1C                   Z-ADD     *ZERO         W@QTY             9 0
TCHK1C                   Z-ADD     *ZERO         W@BOX
TCHK1C                   Z-ADD     *ZERO         W@NOHZ
TCHK1C*
TCHK1C                   MOVEL     D@SHTO        C2NONY
TCHK1C                   MOVEL     *BLANK        C2NONM
TCHK1C     D@SHTO        IFNE      *BLANK
TCHK1C     K@NONY        CHAIN     FGBPL01                            92
TCHK1C     *IN92         IFEQ      *OFF
TCHK1C                   MOVEL     B2SMEI        C2NONM
TCHK1C                   END
TCHK1C                   ELSE
TCHK1C                   MOVE(P)   'ALL'         C2NONY
TCHK1C                   END
TCHK1C*
TCHK1C                   Z-ADD     D@FRM         WFRM
TCHK1C     K#P19A        KLIST
TCHK1C                   KFLD                    WFYY
TCHK1C                   KFLD                    WFMM
TCHK1C                   KFLD                    WFDD
TCHK1C     K#P19A        SETLL     AB#PL19C
TCHK1C*
TCHK1C                   DO        *HIVAL
TCHK1C*
TCHK1C                   READ      AB#PL19C                               93
TCHK1C   93              LEAVE
TCHK1C     BASKJY        IFNE      *BLANK
TCHK1C                   ITER
TCHK1C                   END
JW   C     BASRYO        IFEQ      0
     C                   ITER
     C                   ENDIF
TCHK1C     D@SHTO        IFNE      *BLANK
TCHK1C     K@NONY        ANDNE     BANONY
TCHK1C                   ITER
TCHK1C                   END
TCHK1C*
TCHK1C     W@SHIN        IFEQ      *BLANK
TCHK1C                   MOVEL     BASHIN        W@SHIN
TCHK1C                   END
TCHK1C     W@NOHZ        IFEQ      *ZERO
TCHK1C                   MOVEL     BANOHZ        W@NOHZ
TCHK1C                   END
TCHK1C     W@SHIN        IFNE      BASHIN
TCHK1C     W@NOHZ        ORNE      BANOHZ
TCHK1C                   MOVEL     *OFF          W@LIMT            1
TCHK1C                   EXSR      #SET2A
TCHK1C     W@LIMT        IFEQ      *ON
TCHK1C                   LEAVE
TCHK1C                   END
TCHK1C                   MOVEL     BASHIN        W@SHIN
TCHK1C                   MOVEL     BANOHZ        W@NOHZ
TCHK1C                   Z-ADD     *ZERO         W@QTY
TCHK1C                   END
TCHK1C*
TCHK1C                   ADD       BASRYO        W@QTY
TCHK1C*
TCHK1C                   ENDDO
TCHK1C*
TCHK1C                   CLEAR                   SFL02
TCHK1C                   CLEAR                   #DT
TCHK1C                   CLEAR                   #AB
TCHK1C                   CLEAR                   #AQ
TCHK1C                   CLEAR                   #BB
TCHK1C                   CLEAR                   #BQ
TCHK1C                   CLEAR                   #CB
TCHK1C                   CLEAR                   #CQ
TCHK1C                   CLEAR                   #DB
TCHK1C                   CLEAR                   #DQ
TCHK1C                   Z-ADD     *ZERO         J                 2 0
TCHK1C                   Z-ADD     *ZERO         K                 2 0
TCHK1C*
TCHK1C                   DO        *HIVAL
TCHK1C*
TCHK1C                   ADD       1             J
TCHK1C     J             IFGT      31
TCHK1C                   XFOOT     @AB           W@AB
TCHK1C                   XFOOT     @AQ           W@AQ
TCHK1C                   XFOOT     @BB           W@BB
TCHK1C                   XFOOT     @BQ           W@BQ
TCHK1C                   XFOOT     @CB           W@CB
TCHK1C                   XFOOT     @CQ           W@CQ
TCHK1C                   XFOOT(H)  @DB           W@DB
TCHK1C                   XFOOT     @DQ           W@DQ
TCHK1C                   ADD       1             K
TCHK1C     K             IFGT      5
TCHK1C                   ADD       1             RRN2
TCHK1C                   WRITE     SFL02
TCHK1C                   CLEAR                   SFL02
TCHK1C                   CLEAR                   #DT
TCHK1C                   CLEAR                   #AB
TCHK1C                   CLEAR                   #AQ
TCHK1C                   CLEAR                   #BB
TCHK1C                   CLEAR                   #BQ
TCHK1C                   CLEAR                   #CB
TCHK1C                   CLEAR                   #CQ
TCHK1C                   CLEAR                   #DB
TCHK1C                   CLEAR                   #DQ
TCHK1C                   Z-ADD     1             K
TCHK1C                   END
TCHK1C                   MOVE      'TOTAL'       #DT(K)
TCHK1C                   Z-ADD     W@AB          #AB(K)
TCHK1C                   Z-ADD     W@AQ          #AQ(K)
TCHK1C                   Z-ADD     W@BB          #BB(K)
TCHK1C                   Z-ADD     W@BQ          #BQ(K)
TCHK1C                   Z-ADD     W@CB          #CB(K)
TCHK1C                   Z-ADD     W@CQ          #CQ(K)
TCHK1C                   Z-ADD(H)  W@DB          #DB(K)
TCHK1C                   Z-ADD     W@DQ          #DQ(K)
TCHK1C                   ADD       1             RRN2
TCHK1C                   WRITE     SFL02
TCHK1C                   LEAVE
TCHK1C                   ELSE
TCHK1C     @DT(J)        IFEQ      *ZERO
TCHK1C                   ITER
TCHK1C                   END
TCHK1C                   ADD       1             K
TCHK1C     K             IFGT      5
TCHK1C                   ADD       1             RRN2
TCHK1C                   WRITE     SFL02
TCHK1C                   CLEAR                   SFL02
TCHK1C                   CLEAR                   #DT
TCHK1C                   CLEAR                   #AB
TCHK1C                   CLEAR                   #AQ
TCHK1C                   CLEAR                   #BB
TCHK1C                   CLEAR                   #BQ
TCHK1C                   CLEAR                   #CB
TCHK1C                   CLEAR                   #CQ
TCHK1C                   CLEAR                   #DB
TCHK1C                   CLEAR                   #DQ
TCHK1C                   Z-ADD     1             K
TCHK1C                   END
TCHK1C                   MOVEL     @DT(J)        W@DPDT
TCHK1C                   MOVE      W@DPDA        W#DPDA
TCHK1C                   MOVEL     W@DPDB        W#DPDB
TCHK1C                   MOVEL     W@DPDC        W#DPDC
TCHK1C                   MOVEL     '/'           W#DPSA
TCHK1C                   MOVEL     '/'           W#DPSB
TCHK1C                   MOVE(P)   W#DPD1        #DT(K)
TCHK1C                   Z-ADD     @AB(J)        #AB(K)
TCHK1C                   Z-ADD     @AQ(J)        #AQ(K)
TCHK1C                   Z-ADD     @BB(J)        #BB(K)
TCHK1C                   Z-ADD     @BQ(J)        #BQ(K)
TCHK1C                   Z-ADD     @CB(J)        #CB(K)
TCHK1C                   Z-ADD     @CQ(J)        #CQ(K)
TCHK1C                   Z-ADD(H)  @DB(J)        #DB(K)
TCHK1C                   Z-ADD     @DQ(J)        #DQ(K)
TCHK1C                   END
TCHK1C*
TCHK1C                   ENDDO
TCHK1C*
TCHK1C                   Z-ADD     1             #RCNO2
TCHK1 *
TCHK1C                   ENDSR
TCHK1C*-----------------------------------------------------
TCHK1C     #SET2A        BEGSR
TCHK12*-----------------------------------------------------
TCHK1C                   DO
TCHK1C*
TCHK1C     K#FCEA        KLIST
TCHK1C                   KFLD                    W@SHN1
TCHK1C                   KFLD                    W@SHN2
TCHK1C                   KFLD                    W@SHN3
TCHK1C     K#FCEA        CHAIN     FCEPL01                            95
TCHK1C   95              LEAVE
      *
JW   C     A2GSKD        IFNE      *BLANK
     C                   ITER
     C                   ENDIF
      *
TCHK1C     A2SYHZ        IFGT      W@NOHZ
TCHK1C                   Z-ADD     A2KSYS        W@SYS             5 0
TCHK1C                   ELSE
TCHK1C                   Z-ADD     A2SSYS        W@SYS
TCHK1C                   END
TCHK1C     W@SYS         IFEQ      *ZERO
TCHK1C                   LEAVE
TCHK1C                   END
TCHK1C     W@QTY         DIV(H)    W@SYS         W@BOX             7 1
      *
TCHK1C                   Z-ADD     1             Z                 2 0
TCHK1C     W@NOHZ        LOOKUP    @DT(Z)                                 81
TCHK1C     *IN81         IFEQ      *OFF
TCHK1C                   Z-ADD     1             Z
TCHK1C                   Z-ADD     *ZERO         W@@8N             8 0
TCHK1C     W@@8N         LOOKUP    @DT(Z)                                 81
TCHK1C     *IN81         IFEQ      *ON
TCHK1C                   Z-ADD     W@NOHZ        @DT(Z)
     C                   EXSR      #SB790
JW1  C                   EXSR      #SB890
TCHK1C                   ELSE
TCHK1C                   MOVEL     *ON           W@LIMT
TCHK1C                   LEAVE
TCHK1C                   END
TCHK1C                   END
TCHK1C* DAYS TOTAL
TCHK1C                   ADD       W@BOX         @DB(Z)
TCHK1C                   ADD       W@QTY         @DQ(Z)
TCHK1C* PASS THROUGH
TCHK1C     K#FCEA        SETLL     AAPTL01
TCHK1C     *IN96         DOUEQ     *ON
TCHK1C     K#FCEA        READE     AAPTL01                                96
TCHK1C     *IN96         IFEQ      *OFF
TCHK1C     L5STYY        ANDEQ     9999
TCHK1C     L5SKJY        ANDEQ     *BLANK
TCHK1C                   ADD       W@QTY         @AQ(Z)
TCHK1C                   ADD       W@BOX         @AB(Z)
TCHK1C                   LEAVE
TCHK1C                   END
TCHK1C                   ENDDO
TCHK1C* HALF FINISHED
TCHK1C     *IN96         IFEQ      *ON
TCHK1C     K#FCEA        SETLL     FCEPL40
TCHK1C     *IN96         DOUEQ     *ON
TCHK1C     K#FCEA        READE     FCEPL40                                96
TCHK1C     *IN96         IFEQ      *OFF
TCHK1C     F4GSKD        ANDEQ     *BLANK
TCHK1C                   ADD       W@QTY         @BQ(Z)
TCHK1C                   ADD       W@BOX         @BB(Z)
TCHK1C                   LEAVE
TCHK1C                   END
TCHK1C                   ENDDO
TCHK1C                   END
TCHK1C* IAF
TCHK1C     *IN96         IFEQ      *ON
TCHK1C                   ADD       W@QTY         @CQ(Z)
TCHK1C                   ADD       W@BOX         @CB(Z)
TCHK1C                   Z-ADD     @CB(Z)        X@BOX             8 1
     C                   EXSR      #SB700
JW1  C**TEMP               EXSR #SB800
TCHK1C                   END
TCHK1C*
TCHK1C                   ENDDO
TCHK1C*
TCHK1C                   ENDSR
TCHK1 *-----------------------------------------------------
TCHK1C     #DSP03        BEGSR
TCHK1 *-----------------------------------------------------
TCHK1C                   MOVE      CMD(4)        D@CMD
TCHK1 *
TCHK1C                   MOVE      *ON           *IN56
TCHK1C                   WRITE     DSP99
TCHK1C                   EXFMT     CTL02
TCHK1C                   MOVE      *OFF          *IN56                                     C
TCHK1 *
TCHK1C     @@REC         IFNE      *ZERO
TCHK1C                   Z-ADD     @@REC         #RCNO2
TCHK1C                   END
      *
TCHK1C                   SELECT
      * F3: END
TCHK1C     *INKA         WHENEQ    *ON
TCHK1C                   MOVE      '99'          @@ID
      * F12: GO BACK
TCHK1C     *INKL         WHENEQ    *ON
TCHK1C                   MOVE      '01'          @@ID
      * F5: HD DETAIL
TCHK1C     *INKE         WHENEQ    *ON
JW1  C                   MOVE      '5'           @PF               1
     C                   CALL      'AB#RAT'
 "   C                   PARM                    @PF
 "   C                   MOVE      *BLANK        D@MSG
JW1   * F6: HT DETAIL
 |   C     *INKF         WHENEQ    *ON
 |   C                   MOVE      MSG(6)        D@MSG
 |   C**                   MOVE '6'       @PF     1
 |   C**                   CALL 'AB#RAT'
 |   C**                   PARM           @PF
 |    * F7: ST DETAIL
 |   C     *INKG         WHENEQ    *ON
 |   C                   MOVE      MSG(6)        D@MSG
 |   C**                   MOVE '7'       @PF     1
 |   C**                   CALL 'AB#RAT'
 |   C**                   PARM           @PF
 |    * F8: JC DETAIL
 |   C     *INKH         WHENEQ    *ON
 |   C                   MOVE      MSG(6)        D@MSG
 |   C**                   MOVE '8'       @PF     1
 |   C**                   CALL 'AB#RAT'
JW1  C**                   PARM           @PF
TCHK1C                   ENDSL
TCHK1 *
TCHK1C                   ENDSR
      *-----------------------------------------------------
      * AB#WPAS DELETE
      *-----------------------------------------------------
     C     #WPCLR        BEGSR
JW1   *
 |   C     #WSID         SETLL     AB#WPAR1
 |   C     #WSID         READE     AB#WPAR1                               94
 |   C     *IN94         DOWEQ     '0'
 |   C                   DELETE    AB#WPAR1
 |   C     #WSID         READE     AB#WPAR1                               94
JW1  C                   ENDDO
      *
     C     #WSID         SETLL     AB#WPAS1
     C     #WSID         READE     AB#WPAS1                               94
     C     *IN94         DOWEQ     '0'
     C                   DELETE    AB#WPAS1
     C     #WSID         READE     AB#WPAS1                               94
     C                   ENDDO
      *
     C     #WSID         SETLL     AB#WPAT1
     C     #WSID         READE     AB#WPAT1                               94
     C     *IN94         DOWEQ     '0'
     C                   DELETE    AB#WPAT1
     C     #WSID         READE     AB#WPAT1                               94
     C                   ENDDO
      *
     C                   ENDSR
      *-----------------------------------------------------
      * AB#WPAS CREATE
      *-----------------------------------------------------
     C     #SB790        BEGSR
      *
     C                   Z-ADD     @DT(Z)        W@DT
     C     *LOVAL        SETLL     ABBPP7G
     C                   READ      ABBPP7G                                94
     C     *IN94         DOWEQ     '0'
     C     A#SKJY        IFEQ      *BLANK
     C                   MOVEL     A#SIZE        W@SIZE
     C     KEYW#         CHAIN     AB#WPAS1                           94
     C     *IN94         IFEQ      '1'
     C                   CLEAR                   AB#WPAS1
     C                   MOVEL     #WSID         W#WSID
     C                   Z-ADD     @DT(Z)        W#DATE
     C                   MOVEL     W@SIZE        W#SIZE
     C                   Z-ADD     0             W#QTY
     C                   Z-ADD     0             W#BOX
     C                   WRITE     AB#WPAS1
     C                   ENDIF
     C                   ENDIF
     C                   READ      ABBPP7G                                94
     C                   ENDDO
      *OTHER
     C                   CLEAR                   AB#WPAS1
     C                   MOVEL     #WSID         W#WSID
     C                   Z-ADD     @DT(Z)        W#DATE
     C                   MOVEL     X'FFFFFF'     W#SIZE
     C                   Z-ADD     0             W#QTY
     C                   Z-ADD     0             W#BOX
     C                   WRITE     AB#WPAS1
      *SHIP DATE
     C                   CLEAR                   AB#WPAT1
     C                   MOVEL     #WSID         W#WSID
     C                   Z-ADD     @DT(Z)        W#DATE
     C                   WRITE     AB#WPAT1
      *
     C                   ENDSR
      *-----------------------------------------------------
      * AB#WPAS CREATE
      *-----------------------------------------------------
     C     #SB700        BEGSR
      *
     C                   MOVEL     *BLANK        W@KB              3
     C     K#FCEA        CHAIN     AAMPL11                            94
     C     *IN94         IFEQ      '0'
     C     CKKO01        IFEQ      'HD '
     C     CKKO01        OREQ      'BM '
     C     CKKO01        OREQ      'NF '
     C                   MOVEL     CKKB01        W@KB
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     X'FFFFFF'     W@SIZE            3
     C     W@KB          CHAIN     ABBPP7G                            94
     C     *IN94         IFEQ      '0'
     C     A#SKJY        IFEQ      *BLANK
     C                   MOVEL     A#SIZE        W@SIZE
     C                   ENDIF
     C                   ENDIF
      *
     C     KEYW#         KLIST
     C                   KFLD                    #WSID
     C                   KFLD                    W@DT              8 0
     C                   KFLD                    W@SIZE
     C                   Z-ADD     @DT(Z)        W@DT
     C     KEYW#         CHAIN     AB#WPAS1                           94
     C     *IN94         IFEQ      '0'
     C                   ADD       W@QTY         W#QTY
     C                   ADD       W@BOX         W#BOX
     C                   UPDATE    AB#WPAS1
     C                   ELSE
     C                   CLEAR                   AB#WPAS1
     C                   MOVEL     #WSID         W#WSID
     C                   Z-ADD     @DT(Z)        W#DATE
     C                   MOVEL     W@SIZE        W#SIZE
     C                   Z-ADD     W@QTY         W#QTY
     C                   Z-ADD     W@BOX         W#BOX
     C                   WRITE     AB#WPAS1
     C                   ENDIF
      *
     C                   ENDSR
      *-----------------------------------------------------
      * AB#WPAR CREATE
      *-----------------------------------------------------
     C     #SB890        BEGSR
      * TEMP
     C                   GOTO      XSB890
      *
     C                   Z-ADD     @DT(Z)        W@DT
     C     *LOVAL        SETLL     ABBPP7G
     C                   READ      ABBPP7G                                94
     C     *IN94         DOWEQ     '0'
     C     A#SKJY        IFEQ      *BLANK
     C                   MOVEL     A#SIZE        W@SIZE
     C                   MOVEL     A#MANO        W@MCN
     C     KEYW#2        CHAIN     AB#WPAR1                           94
     C     *IN94         IFEQ      '1'
     C                   CLEAR                   AB#WPAR1
     C                   MOVEL     #WSID         W#WSID
     C                   Z-ADD     @DT(Z)        W#DATE
     C                   MOVEL     W@SIZE        W#SIZE
     C                   MOVEL     W@MCN         W#MCNT
     C                   Z-ADD     0             W#QTY
     C                   Z-ADD     0             W#BOX
     C                   WRITE     AB#WPAR1
     C                   ENDIF
     C                   ENDIF
     C                   READ      ABBPP7G                                94
     C                   ENDDO
      *OTHER
     C                   CLEAR                   AB#WPAR1
     C                   MOVEL     #WSID         W#WSID
     C                   Z-ADD     @DT(Z)        W#DATE
     C**TEMP               MOVELX'FFFFFF' W#SIZE
     C**TEMP               MOVELX'FFF'    W#MCNT
     C                   Z-ADD     0             W#QTY
     C                   Z-ADD     0             W#BOX
     C                   WRITE     AB#WPAR1
      *SHIP DATE
     C**                   CLEARAB#WPAT1
     C**                   MOVEL#WSID     W#WSID
     C**                   Z-ADD@DT,Z     W#DATE
     C**                   WRITEAB#WPAT1
      *
     C     XSB890        ENDSR
      *-----------------------------------------------------
JW1   * AB#WPAR CREATE
 |    *-----------------------------------------------------
 |   C     #SB800        BEGSR
 V    * TEMP
 .   C                   GOTO      XSB800
 .    *
 .   C                   MOVEL     *BLANK        W@KB              3
 .   C     K#FCEA        CHAIN     AAMPL11                            94
     C     *IN94         IFEQ      '0'
     C     CKKO01        IFEQ      'HD '
     C     CKKO01        OREQ      'BM '
     C     CKKO01        OREQ      'NF '
     C                   MOVEL     CKKB01        W@KB
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     X'FFFFFF'     W@SIZE            3
     C     W@KB          CHAIN     ABBPP7G                            94
     C     *IN94         IFEQ      '0'
     C     A#SKJY        IFEQ      *BLANK
     C                   MOVEL     A#SIZE        W@SIZE
     C                   ENDIF
     C                   ENDIF
      *
     C     KEYW#2        KLIST
     C                   KFLD                    #WSID
     C                   KFLD                    W@DT              8 0
     C                   KFLD                    W@SIZE
     C                   KFLD                    W@MCN             3
      *
     C                   Z-ADD     @DT(Z)        W@DT
     C**TEMP               MOVELX         W@MCN
     C     KEYW#2        CHAIN     AB#WPAR1                           94
     C     *IN94         IFEQ      '0'
     C                   ADD       W@QTY         W#QTY
     C                   ADD       W@BOX         W#BOX
     C                   UPDATE    AB#WPAR1
     C                   ELSE
     C                   CLEAR                   AB#WPAR1
     C                   MOVEL     #WSID         W#WSID
     C                   Z-ADD     @DT(Z)        W#DATE
 .   C                   MOVEL     W@SIZE        W#SIZE
 .   C                   MOVEL     W@KB          W#PRC1
 .   C                   MOVEL     W@KB          W#PRCT
 .   C                   MOVEL     W@MCN         W#MCNT
 .   C                   Z-ADD     W@QTY         W#QTY
 |   C                   Z-ADD     W@BOX         W#BOX
 |   C                   WRITE     AB#WPAR1
 V   C                   ENDIF
 .    *
JW1  C     XSB800        ENDSR
      *-----------------------------------------------------
** CMD(78A)
    F1:END
    F1:END     F12:GO BACK    F9:NEXT 3 MONTH
    F1:END     F12:GO BACK    F9:PREV 3 MONTH
F1:END  F12:GO BACK  F5:HD DETAIL  F6:HT DETAIL  F7:ST DETAIL  F8:JC DETAIL
** MSG(60A) .......2.........3.........4.........5.........6
   NO DATA !                                                 01
DATE SHOULD BE WITHIN 6 MONTHS !                             02
  DATE ERROR !                                               03
  SHIP-TO ERROR !                                            04
THIS MONTH'S DATA IS NOT AVAILABLE YET !                     05
THIS FUNCTION IS NOT READY YET !                             06
                                                             07
                                                             08
                                                             09
                                                             10
