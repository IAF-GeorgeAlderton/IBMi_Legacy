     H DATEDIT(*YMD.)
     F** VRFR53 **************************************************
     F*  REFORMAT AND SAVE AB#PP65                               *
     F*  J.WATANABE      2022.12.05                              *
     F*  FUNCTION: PURGE RECORD BY DESIGNATED DATE               *
     F*          : PURGED RECORD WILL BE MOVED OUT TO  AB#PP65B  *
     F*----------------------------------------------------------*
     F*  IN  $DATE: 8A DATE (YYYYMMDD) PURGE IF A6NYMD =< $DATE
     F*  OUT $BFR : 9A RECORD BEFORE RUN
     F*      $AFR : 9A RECORD AFTER  RUN
     F*  ----------------------------------                        *
     F*  * ADD VRFR53   TO UTLC20                                  *
     F*  * ADD AB#PP65  BY OPT#1 (FILE REFORMATION MASTER UPDATE)  *
     F*  * ADD AB#PP65  BY OPT#3 (UPDATE FILE NAME              )  *
     F*  * ADD AB#PP65  TO UTLC63A FOR REORGANIZATION              *
     F**************************************************************
     FAB#PL65C  UP   E           K DISK    INFDS(INF1)
     FAB#PP65B  O    E             DISK
     F                                     RENAME(AB#PP651:AB#PP65X)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  A6NOHZ                 1      8  0
     D  A6NOYY                 1      4  0
     D  A6NOMM                 5      6  0
     D  A6NODD                 7      8  0
      *
     C     *ENTRY        PLIST
     C                   PARM                    PYMD              8            SHIP DATE
     C                   PARM                    PREC1             9            BEFORE
     C                   PARM                    PREC2             9            AFTER
     C                   MOVE      PYMD          XDATE             8 0
      *
     C     A6NOHZ        IFLE      XDATE
     C                   WRITE     AB#PP65X
     C                   DELETE    AB#PP651
     C                   ADD       1             WDEL              9 0
     C                   ELSE
     C                   MOVE      '1'           *INLR
     C                   END
      *
     CLR                 Z-ADD     RCNT          WREC              9 0
     CLR                 MOVE      WREC          PREC1
     CLR   WREC          SUB       WDEL          WREC
     CLR                 MOVE      WREC          PREC2
