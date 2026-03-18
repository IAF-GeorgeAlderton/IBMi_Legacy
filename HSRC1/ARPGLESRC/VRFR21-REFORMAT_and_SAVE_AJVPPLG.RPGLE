     H DATEDIT(*YMD.)
     F** VRFR21 ****************************************
     F*  REFORMATION FOR AJVPPLG                       *
     F*  J-WATANABE  CRT 2016.07.15                    *
     F**************************************************
     FAJVPPLG   UF   E           K DISK    INFDS(INF1)
     FAJVPPLGB  O    E           K DISK
     F                                     RENAME(AJVPPLG1:AJVPPLGX)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  LGDATE                 1      8  0
     D  LGDTYY                 1      4  0
     D  LGDTMM                 5      6  0
     D  LGDTDD                 7      8  0
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9            BEFORE
     C                   PARM                    PREC2             9            AFTER
      *
     C                   MOVE      PDATE         XDATE             8 0
     C     *LOVAL        SETLL     AJVPPLG
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      AJVPPLG                                90
     C     *IN90         IFEQ      *OFF
      *
     C     LGDATE        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     AJVPPLGX
     C                   DELETE    AJVPPLG1
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      * FOOT
     C                   Z-ADD     RCNT          WREC1             9 0
     C                   MOVE      WREC1         PREC1
     C     WREC1         SUB       WDEL          WREC2             9 0
     C                   MOVE      WREC2         PREC2
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
