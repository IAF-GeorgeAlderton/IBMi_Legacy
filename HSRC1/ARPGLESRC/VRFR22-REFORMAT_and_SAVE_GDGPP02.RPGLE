     H DATEDIT(*YMD.)
     F** VRFR22 ****************************************
     F*  REFORMATION FOR GDGPP02                       *
     F*  J-WATANABE  CRT 2016.07.15                    *
     F**************************************************
     FGDGPL11   UF   E           K DISK    INFDS(INF1)
     FGDGPP02B  O    E           K DISK
     F                                     RENAME(GDGPP021:GDGPP02X)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  TRDATE                 1      8  0
     D  IAKOYY                 1      4  0
     D  IAKOMM                 5      6  0
     D  IAKODD                 7      8  0
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC              9            BEFORE
     C                   PARM                    PKEN              9            AFTER
      *
     C                   MOVE      PDATE         XDATE             8 0
     C     *LOVAL        SETLL     GDGPL11
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      GDGPL11                                90
     C     *IN90         IFEQ      *OFF
      *
     C     TRDATE        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     GDGPP02X
     C                   DELETE    GDGPP021
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      * FOOT
     C                   Z-ADD     RCNT          WREC1             9 0
     C                   MOVE      WREC1         PREC
     C     WREC1         SUB       WDEL          WREC2             9 0
     C                   MOVE      WREC2         PKEN
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
