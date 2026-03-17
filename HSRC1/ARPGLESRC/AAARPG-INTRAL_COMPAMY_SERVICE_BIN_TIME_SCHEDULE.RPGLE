     H DATEDIT(*YMD)
     F*********************************************************
     F*INTRAL COMPAMY SERVICE BIN TIME SCHEDULE  AAKR13 *
     F* M S K                                                 *
     F*********************************************************
     FAAKPW13   CF   E             WORKSTN
     FAAKTL15   IF   E           K DISK
     FAAKTL14   IF   E           K DISK
     FAAKPL11   IF   E           K DISK
     FFGBPL01   IF   E           K DISK
     FRGAPL11   IF   E           K DISK
     FAAKPR13   O    E             PRINTER
     D $MSG            S             14    DIM(4) CTDATA PERRCD(1)
     D $EMSG           S             50    DIM(3) CTDATA PERRCD(1)
     D AR1             S              4    DIM(500)
     D                 DS
     D  DFBSY1                 1      2
     D  DFBSY2                 3      4
     D  WBSY                   1      4
     D                 DS
     D  @BINS                  1      4
     D  #BINS1                 1      2
     D  #BINS2                 3      4
     D                 DS
     D  WKSUN                  1      4
     D  IN1                    1      1
     D  SUN                    2      3
     D  OUT1                   4      4
     D                 DS
     D  WKMON                  1      4
     D  IN2                    1      1
     D  MON                    2      3
     D  OUT2                   4      4
     D                 DS
     D  WKTUE                  1      4
     D  IN3                    1      1
     D  TUE                    2      3
     D  OUT3                   4      4
     D                 DS
     D  WKWED                  1      4
     D  IN4                    1      1
     D  WED                    2      3
     D  OUT4                   4      4
     D                 DS
     D  WKTHU                  1      4
     D  IN5                    1      1
     D  THU                    2      3
     D  OUT5                   4      4
     D                 DS
     D  WKFRI                  1      4
     D  IN6                    1      1
     D  FRI                    2      3
     D  OUT6                   4      4
     D                 DS
     D  WKSAT                  1      4
     D  IN7                    1      1
     D  SAT                    2      3
     D  OUT7                   4      4
     D                 DS
     D  IN                     1      1
     D  SUN1                   2      3
     D  MON1                   4      5
     D  TUE1                   6      7
     D  WED1                   8      9
     D  THU1                  10     11
     D  FRI1                  12     13
     D  SAT1                  14     15
     D  OUT                   16     16
     D  NOUNY                  1     16
     C*-------------------*
     C*  K L I S T        *
     C*-------------------*
     C     #KEY          KLIST
     C                   KFLD                    #KB1              2
     C                   KFLD                    #KB2              2
     C/SPACE 1
     C     *ENTRY        PLIST
     C                   PARM                    PARM1            10
     C                   MOVE      PARM1         #WKEY            10
     C     #WKEY         CHAIN     RGAPL111                           62
     C     *IN62         IFEQ      '0'
     C                   MOVEL     J8NAME        @HAKOH
     C                   END
     C     $100S         TAG
     C                   EXFMT     AAKPW131
     C   KA              SETON                                        LR
     C   KA              RETURN
     C   KE              GOTO      LIST
     C                   SETOFF                                       1099
     C                   MOVE      *BLANK        @ERR
     C                   MOVEL     @BINS         #KB1
     C                   MOVE      @BINS         #KB2
     C     @BINS         IFNE      '9999'
     C     #KEY          CHAIN     AAKPL111                           10
     C   10              SETON                                          99
     C   10              MOVEL     $EMSG(1)      @ERR
     C   10              GOTO      $100S
     C     DFSKJY        IFEQ      'D'
     C                   SETON                                          9910
     C   10              MOVEL     $EMSG(1)      @ERR
     C   10              GOTO      $100S
     C                   END
     C     X             IFGT      500
     C                   MOVEL     $EMSG(2)      @ERR
     C                   MOVE      *BLANK        AR1
     C                   Z-ADD     0             X                 3 0
     C                   SETON                                        1199
     C                   GOTO      $100S
     C                   END
     C     X             ADD       1             X
     C                   MOVE      @BINS         AR1(X)
     C                   MOVE      @BINS         @ZENKI
     C                   MOVE      *BLANK        @BINS
     C                   GOTO      $100S
     C                   ELSE
     C     *LOVAL        SETLL     AAKPL111
     C                   SETOFF                                         81
     C                   Z-ADD     0             X
     C                   DO        *HIVAL
     C                   READ      AAKPL111                               81
     C     *IN81         IFEQ      '0'
     C     *IN11         ANDEQ     '0'
     C     ASW           IFEQ      *BLANK
     C                   MOVE      DFBSYU        ASBSYU            4
     C                   MOVE      '*'           ASW               1
     C                   END
     C     ASBSYU        IFNE      DFBSYU
     C                   ADD       1             X
     C     X             COMP      500                                11
     C  N11              MOVE      ASBSYU        AR1(X)
     C                   END
     C                   MOVE      DFBSYU        ASBSYU
     C                   END
     C  N81
     CANN11              END
     C                   ADD       1             X
     C                   MOVE      ASBSYU        AR1(X)
     C     X             IFGT      500
     C                   MOVEL     $EMSG(2)      @ERR
     C                   MOVE      *BLANK        AR1
     C                   Z-ADD     0             X
     C                   SETON                                        1199
     C                   GOTO      $100S
     C                   END
     C                   END
     C                   MOVE      @BINS         @ZENKI
     C                   MOVE      *BLANK        @BINS
     C                   MOVE      *BLANK        ASW
     C                   GOTO      $100S
     C****************
     C* 時刻表作成 *
     C****************
     C     LIST          TAG
     C                   TIME                    @TIME
     C                   MOVE      *DATE         @DATE
     C                   Z-ADD     0             @PAGE
     C                   Z-ADD     0             X
     C                   DO        *HIVAL
     C     X             ADD       1             X                 3 0
     C     AR1(X)        IFEQ      *BLANK
     C                   SETON                                          84
     C                   ELSE
     C                   SETOFF                                       313233
     C                   SETOFF                                       343536
     C                   SETOFF                                         37
     C                   MOVEL     AR1(X)        #KB1
     C                   MOVE      AR1(X)        #KB2
     C                   Z-ADD     *ZERO         DCTR
     C                   MOVEL     *BLANK        @1BMN
     C                   MOVEL     *BLANK        @2BMN
     C                   MOVEL     *BLANK        @3BMN
     C                   MOVEL     *BLANK        @4BMN
     C                   MOVEL     *BLANK        @5BMN
     C                   MOVEL     *BLANK        @6BMN
     C                   MOVEL     *BLANK        @7BMN
     C                   MOVEL     *BLANK        @8BMN
     C                   MOVE      *BLANK        WTBMN
     C                   MOVEL     *BLANK        @UNKOH
     C                   SETOFF                                           80
     C*------------*
     C* vjﾞﾆ  ﾆｭﾒ  *
     C*------------*
     C     #KEY          SETLL     AAKTL141
     C                   DO        *HIVAL
     C* ﾎｦbﾓ ﾉ ﾑv  *
     C     #KEY          READE     AAKTL141                               80
     C     *IN80         IFEQ      '0'
     C                   MOVE      DFSBMN        #SKEY             4 0
     C* ﾅbyh uﾇjｰ ﾉ ﾑv *
     C     #SKEY         CHAIN     FGBPL011                           60
     C     *IN60         IFEQ      '0'
     C                   MOVEL     B2SMEI        WSBMN            10
     C                   ELSE
     C                   MOVE      *BLANK        WSBMN
     C                   END
     C                   MOVE      DFTBMN        #TKEY             4 0
     C     #TKEY         CHAIN     FGBPL011                           61
     C     *IN61         IFEQ      '0'
     C                   MOVEL     B2SMEI        WTBMN            10
     C                   ELSE
     C                   MOVE      *BLANK        WTBMN
     C                   END
     C* c]ﾃc ﾆﾞｭcjb *
     C     DFTSEQ        IFEQ      1
     C                   MOVE      DFBSYU        @BIN
     C     DFGKKB        IFEQ      'M'
     C                   MOVEL     $MSG(1)       @UNKOH
     C                   END
     C     DFGKKB        IFEQ      'G'
     C                   MOVEL     $MSG(2)       @UNKOH
     C                   END
     C     DFGKKB        IFEQ      'K'
     C                   MOVEL     $MSG(3)       @UNKOH
     C                   END
     C     DFGKKB        IFEQ      'I'
     C                   MOVEL     $MSG(4)       @UNKOH
     C                   END
     C* ﾑcﾍﾞ ﾆmb *
     C     DFGKKB        IFEQ      ' '
     C     DFSUND        IFNE      *BLANK
     C                   ADD       1             DCTR              1 0
     C                   MOVE      'SUN '        WKSUN
     C                   END
     C     DFMOND        IFNE      *BLANK
     C                   ADD       1             DCTR
     C                   MOVE      'MON '        WKMON
     C                   END
     C     DFTUED        IFNE      *BLANK
     C                   ADD       1             DCTR
     C                   MOVE      'TUE '        WKTUE
     C                   END
     C     DFWEDD        IFNE      *BLANK
     C                   ADD       1             DCTR
     C                   MOVE      'WED '        WKWED
     C                   END
     C     DFTHUD        IFNE      *BLANK
     C                   ADD       1             DCTR
     C                   MOVE      'THR '        WKTHU
     C                   END
     C     DFFRID        IFNE      *BLANK
     C                   MOVE      'FRI '        WKFRI
     C                   END
     C     DFSATD        IFNE      *BLANK
     C                   MOVE      'SAT '        WKSAT
     C                   END
     C     DCTR          IFEQ      7
     C                   MOVEL     $MSG(1)       @UNKOH
     C                   ELSE
     C                   MOVE      SUN           SUN1
     C                   MOVE      MON           MON1
     C                   MOVE      TUE           TUE1
     C                   MOVE      WED           WED1
     C                   MOVE      THU           THU1
     C                   MOVE      FRI           FRI1
     C                   MOVE      SAT           SAT1
     C                   MOVEL     '  '          IN
     C                   MOVE      '  '          OUT
     C                   MOVE      NOUNY         @UNKOH
     C                   END
     C                   END
     C                   MOVEL     WSBMN         @SYUBM
     C                   MOVEL     WTBMN         @1BMN
     C                   END
     C* ﾎﾞy]xb  m]c *
     C     DFTSEQ        IFEQ      2
     C                   MOVEL     WTBMN         @2BMN
     C                   END
     C     DFTSEQ        IFEQ      3
     C                   MOVEL     WTBMN         @3BMN
     C                   END
     C     DFTSEQ        IFEQ      4
     C                   MOVEL     WTBMN         @4BMN
     C                   END
     C     DFTSEQ        IFEQ      5
     C                   MOVEL     WTBMN         @5BMN
     C                   END
     C     DFTSEQ        IFEQ      6
     C                   MOVEL     WTBMN         @6BMN
     C                   END
     C     DFTSEQ        IFEQ      7
     C                   MOVEL     WTBMN         @7BMN
     C                   END
     C     DFTSEQ        IFEQ      8
     C                   MOVEL     WTBMN         @8BMN
     C                   END
     C                   END
     C  N80              END
     C     *IN80         IFEQ      '1'
     C                   ADD       1             @PAGE
     C* vjﾞﾆ  WRITE *
     C                   WRITE     AAKPR131
     C                   WRITE     AAKPR132
     C                   Z-ADD     0             LCTR              2 0
     C                   EXSR      $SAB
     C                   END
     C*----------*
     C* xbﾅb ﾆｭﾒ *
     C*----------*
     C                   SETOFF                                         81
     C                   MOVE      *BLANK        FSW               1
     C     #KEY          SETLL     AAKTL151
     C                   DO        *HIVAL
     C     #KEY          READE     AAKTL151                               81
     C     FSW           IFEQ      ' '
     C                   MOVE      DFBINN        WKBINN            2 0
     C                   MOVE      '*'           FSW
     C                   END
     C* xbﾅb  WRITE *
     C     DFBINN        IFNE      WKBINN
     C                   WRITE     AAKPR133
     C* ﾎｧｰﾓnﾞ  CIEAR *
     C                   MOVE      *ZERO         @SYUJI
     C                   MOVE      *ZERO         @TOHU1
     C                   MOVE      *ZERO         @HATU1
     C                   MOVE      *ZERO         @TOHU2
     C                   MOVE      *ZERO         @HATU2
     C                   MOVE      *ZERO         @TOHU3
     C                   MOVE      *ZERO         @HATU3
     C                   MOVE      *ZERO         @TOHU4
     C                   MOVE      *ZERO         @HATU4
     C                   MOVE      *ZERO         @TOHU5
     C                   MOVE      *ZERO         @HATU5
     C                   MOVE      *ZERO         @TOHU6
     C                   MOVE      *ZERO         @HATU6
     C                   MOVE      *ZERO         @TOHU7
     C                   MOVE      *ZERO         @HATU7
     C                   MOVE      *ZERO         @TOHU8
     C                   ADD       1             LCTR              2 0
     C* eｰﾌﾞｰﾎﾜc ﾆｭﾒ *
     C     LCTR          IFGE      50
     C                   ADD       1             @PAGE
     C                   WRITE     AAKPR131
     C                   WRITE     AAKPR132
     C                   Z-ADD     0             LCTR
     C                   END
     C                   END
     C* ﾍﾞ]ﾆｬ  bﾛfd *
     C                   MOVE      DFBINN        WKBINN
     C* xbﾅb m]c *
     C     DFTSEQ        IFEQ      1
     C                   MOVE      DFSTTI        @SYUJI
     C                   MOVE      DFTYTI        @TOHU1
     C                   MOVE      DFBINN        @BINME
     C                   MOVE      DFCBIN        @TIKA
     C                   MOVE      DFHRYR        @KUBUN
     C                   END
     C     DFTSEQ        IFEQ      2
     C                   MOVE      DFSTTI        @HATU1
     C                   MOVE      DFTYTI        @TOHU2
     C                   END
     C     DFTSEQ        IFEQ      3
     C                   MOVE      DFSTTI        @HATU2
     C                   MOVE      DFTYTI        @TOHU3
     C                   END
     C     DFTSEQ        IFEQ      4
     C                   MOVE      DFSTTI        @HATU3
     C                   MOVE      DFTYTI        @TOHU4
     C                   END
     C     DFTSEQ        IFEQ      5
     C                   MOVE      DFSTTI        @HATU4
     C                   MOVE      DFTYTI        @TOHU5
     C                   END
     C     DFTSEQ        IFEQ      6
     C                   MOVE      DFSTTI        @HATU5
     C                   MOVE      DFTYTI        @TOHU6
     C                   END
     C     DFTSEQ        IFEQ      7
     C                   MOVE      DFSTTI        @HATU6
     C                   MOVE      DFTYTI        @TOHU7
     C                   END
     C     DFTSEQ        IFEQ      8
     C                   MOVE      DFSTTI        @HATU7
     C                   MOVE      DFTYTI        @TOHU8
     C                   END
     C  N81              END
     C* xbﾅb  WRITE *
     C     *IN81         IFEQ      '1'
     C                   WRITE     AAKPR133
     C                   MOVE      *ZERO         @SYUJI
     C                   MOVE      *ZERO         @TOHU1
     C                   MOVE      *ZERO         @HATU1
     C                   MOVE      *ZERO         @TOHU2
     C                   MOVE      *ZERO         @HATU2
     C                   MOVE      *ZERO         @TOHU3
     C                   MOVE      *ZERO         @HATU3
     C                   MOVE      *ZERO         @TOHU4
     C                   MOVE      *ZERO         @HATU4
     C                   MOVE      *ZERO         @TOHU5
     C                   MOVE      *ZERO         @HATU5
     C                   MOVE      *ZERO         @TOHU6
     C                   MOVE      *ZERO         @HATU6
     C                   MOVE      *ZERO         @TOHU7
     C                   MOVE      *ZERO         @HATU7
     C                   MOVE      *ZERO         @TOHU8
     C                   ADD       1             LCTR              2 0
     C     LCTR          IFGE      50
     C                   ADD       1             @PAGE
     C* vjﾞﾆ  WRITE *
     C                   WRITE     AAKPR131
     C                   WRITE     AAKPR132
     C                   MOVEL     *BLANK        @UNKOH
     C                   MOVEL     *BLANK        @SYUBM
     C                   MOVEL     *BLANK        @1BMN
     C                   MOVEL     *BLANK        @2BMN
     C                   MOVEL     *BLANK        @3BMN
     C                   MOVEL     *BLANK        @4BMN
     C                   MOVEL     *BLANK        @5BMN
     C                   MOVEL     *BLANK        @6BMN
     C                   MOVEL     *BLANK        @7BMN
     C                   MOVEL     *BLANK        @8BMN
     C                   Z-ADD     0             LCTR
     C                   END
     C                   END
     C                   END
     C  N84              END
     C                   MOVEA     '1'           *IN(97)
     C                   MOVEL     $EMSG(3)      @ERR
     C                   GOTO      $100S
     C* ﾅﾎﾞ ﾓｰk] *
     CSR   $SAB          BEGSR
     C     @2BMN         IFNE      *BLANK
     C                   SETON                                        31
     C                   END
     C     @3BMN         IFNE      *BLANK
     C                   SETON                                        32
     C                   END
     C     @4BMN         IFNE      *BLANK
     C                   SETON                                        33
     C                   END
     C     @5BMN         IFNE      *BLANK
     C                   SETON                                        34
     C                   END
     C     @6BMN         IFNE      *BLANK
     C                   SETON                                        35
     C                   END
     C     @7BMN         IFNE      *BLANK
     C                   SETON                                        36
     C                   END
     C     @8BMN         IFNE      *BLANK
     C                   SETON                                        37
     C                   END
     CSR                 ENDSR
**    $MSG
DELV EVERY DAY
DELV EVEN DAY
DELV ODD DAY
DELV EVR 2DAYS
**    $EMSG
BIN TYPE ISN'T RIGHT
BIN TYPE INPUT EXCEEDED 500
COMPLETED A LIST
