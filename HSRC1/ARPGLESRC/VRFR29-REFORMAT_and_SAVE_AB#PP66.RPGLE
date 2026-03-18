     H DATEDIT(*YMD.)
     F** VRFR29 **************************************************
     F*  REFORMATION FOR AB#PP66                                 *
     F*  J.WATANABE      2017.04.9                               *
     F*  FUNCTION: PURGE RECORD BY DESIGNATED DATE               *
     F*          : PURGED RECORD WILL BE MOVED OUT TO FAB#PP66B  *
     F*----------------------------------------------------------*
     F*  IN  $DATE: 8A DATE (YYYYMMDD) PURGE IF A6NYMD =< $DATE
     F*  OUT $BFR : 9A RECORD BEFORE RUN
     F*      $AFR : 9A RECORD AFTER  RUN
     F************************************************** VJBR40 **
     FAB#PL68   UP   E           K DISK    INFDS(INF1)
     FAB#PP66B  O    E             DISK
     F                                     RENAME(AB#PP661:AB#PP66X)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    PYMD              8
     C                   PARM                    PREC1             9            BEFORE
     C                   PARM                    PREC2             9            AFTER
     C                   MOVE      PYMD          XDATE             8 0
      *
     C     A6NYMD        IFLE      XDATE
     C                   WRITE     AB#PP66X
     C                   DELETE    AB#PP661
     C                   ADD       1             WDEL              9 0
     C                   ELSE
     C                   MOVE      '1'           *INLR
     C                   END
      *
     CLR                 Z-ADD     RCNT          WREC              9 0
     CLR                 MOVE      WREC          PREC1
     CLR   WREC          SUB       WDEL          WREC
     CLR                 MOVE      WREC          PREC2
