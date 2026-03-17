     H DATEDIT(*YMD.)
     F** VRFR48 **************************************************
     F*  REFORMATION FOR AB#PP6A                                 *
     F*  J.WATANABE      2022.02.21                              *
     F*  FUNCTION: PURGE RECORD BY DESIGNATED DATE               *
     F*          : PURGED RECORD WILL BE MOVED OUT TO  AB#PP6AB  *
     F*----------------------------------------------------------*
     F*  IN  $DATE: 8A DATE (YYYYMMDD) PURGE IF A6NYMD =< $DATE
     F*  OUT $BFR : 9A RECORD BEFORE RUN
     F*      $AFR : 9A RECORD AFTER  RUN
     F*  ----------------------------------                        *
     F*  * ADD VRFR48   TO UTLC20                                  *
     F*  * ADD AB#PP6A  BY OPT#1 (FILE REFORMATION MASTER UPDATE)  *
     F*  * ADD AB#PP6A  BY OPT#3 (UPDATE FILE NAME              )  *
     F************************************************************
     FAB#PL6B   UP   E           K DISK    INFDS(INF1)
     FAB#PP6AB  O    E             DISK
     F                                     RENAME(AB#PP6A1:AB#PP6AX)
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
     C     APPRDT        IFLE      XDATE
     C                   WRITE     AB#PP6AX
     C                   DELETE    AB#PP6A1
     C                   ADD       1             WDEL              9 0
     C                   ELSE
     C                   MOVE      '1'           *INLR
     C                   END
      *
     CLR                 Z-ADD     RCNT          WREC              9 0
     CLR                 MOVE      WREC          PREC1
     CLR   WREC          SUB       WDEL          WREC
     CLR                 MOVE      WREC          PREC2
