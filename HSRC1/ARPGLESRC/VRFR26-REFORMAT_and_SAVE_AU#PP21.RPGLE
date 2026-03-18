     H DATEDIT(*YMD.)
     F** VRFR26 ****************************************
     F*  REFORMATION FOR AU#PP21                       *
     F*  COPIED FROM AU#R80                            *
     F*  J-WATANABE         2017.04.09                 *
     F**************************************************
     FAU#PL25   UP   E           K DISK    INFDS(INF1)
     FAU#PP21B  O    E             DISK
     F                                     RENAME(AU#PP211:AU#PP21X)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  CQNOHZ                 1      8  0
     D  CQNOYY                 1      4  0
     D  CQNOMM                 5      6  0
     D  CQNODD                 7      8  0
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
     C                   MOVE      PDATE         XDATE             8 0
      *
     C     CQNOHZ        IFGT      XDATE
     C                   MOVE      '1'           *INLR
     C                   ELSE
     C                   DELETE    AU#PP211
     C                   WRITE     AU#PP21X
     C                   ADD       1             WDEL              9 0
     C                   ENDIF
      *
     CLR                 Z-ADD     RCNT          WREC              9 0
     CLR                 MOVE      WREC          PREC1
     CLR   WREC          SUB       WDEL          WREC
     CLR                 MOVE      WREC          PREC2
