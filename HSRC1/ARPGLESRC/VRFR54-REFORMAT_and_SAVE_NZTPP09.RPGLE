     H DATEDIT(*YMD.)
     F** VRFR54 **************************************************
     F*  REFORMAT AND SAVE NZTPP09                               *
     F*  J.WATANABE      2023.05.12                              *
     F*  FUNCTION: PURGE RECORD BY DESIGNATED DATE               *
     F*          : PURGED RECORD WILL BE MOVED OUT TO  NZTPP09B  *
     F*----------------------------------------------------------*
     F*  IN  $DATE: 8A DATE (YYYYMMDD) PURGE IF A6NYMD =< $DATE
     F*  OUT $BFR : 9A RECORD BEFORE RUN
     F*      $AFR : 9A RECORD AFTER  RUN
     F*  ----------------------------------                        *
     F*  * ADD VRFR54   TO UTLC20                                  *
     F*  * ADD NZTPP09  BY OPT#1 (FILE REFORMATION MASTER UPDATE)  *
     F*  * ADD NZTPP09  BY OPT#3 (UPDATE FILE NAME              )  *
     F*  * ADD NZTPP09  TO UTLC63A FOR REORGANIZATION              *
     F**************************************************************
     FNZTPL09   UP   E           K DISK    INFDS(INF1)
     FNZTPP09B  O    E             DISK
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
     C     N1KOHZ        IFLE      XDATE
     C                   WRITE     NZTPP9B1
     C                   DELETE    NZTPP091
     C                   ADD       1             WDEL              9 0
     C                   ELSE
     C                   MOVE      '1'           *INLR
     C                   END
      *
     CLR                 Z-ADD     RCNT          WREC              9 0
     CLR                 MOVE      WREC          PREC1
     CLR   WREC          SUB       WDEL          WREC
     CLR                 MOVE      WREC          PREC2
