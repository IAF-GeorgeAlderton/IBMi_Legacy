     H DATEDIT(*YMD.)
     F** VRFR51 **************************************************
     F*  REFORMAT AND SAVE AB#PP2B                               *
     F*  J.WATANABE      2022.11.10                              *
     F*  FUNCTION: PURGE RECORD BY DESIGNATED DATE               *
     F*          : PURGED RECORD WILL BE MOVED OUT TO  AB#PP2BB  *
     F*----------------------------------------------------------*
     F*  IN  $DATE: 8A DATE (YYYYMMDD) PURGE IF A6NYMD =< $DATE
     F*  OUT $BFR : 9A RECORD BEFORE RUN
     F*      $AFR : 9A RECORD AFTER  RUN
     F*  ----------------------------------                        *
     F*  * ADD VRFR50   TO UTLC20                                  *
     F*  * ADD ABF6P01  BY OPT#1 (FILE REFORMATION MASTER UPDATE)  *
     F*  * ADD ABF6P01  BY OPT#3 (UPDATE FILE NAME              )  *
     F************************************************************
     FAB#PL2B1  UP   E           K DISK    INFDS(INF1)
     FAB#PP2BB  O    E             DISK
     F                                     RENAME(AB#PP2B1:AB#P2BB)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    PYMD              8            SHIP DATE
     C                   PARM                    PREC1             9            BEFORE
     C                   PARM                    PREC2             9            AFTER
     C                   MOVE      PYMD          XDATE             8 0
      *
     C     ABSHDT        IFLE      XDATE
     C                   WRITE     AB#P2BB
     C                   DELETE    AB#PP2B1
     C                   ADD       1             WDEL              9 0
     C                   ELSE
     C                   MOVE      '1'           *INLR
     C                   END
      *
     CLR                 Z-ADD     RCNT          WREC              9 0
     CLR                 MOVE      WREC          PREC1
     CLR   WREC          SUB       WDEL          WREC
     CLR                 MOVE      WREC          PREC2
