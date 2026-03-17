     H DATEDIT(*YMD.)
     F** VRFR30 **********************************
     F*  REFORMATION FOR AB#HP10                 *
     F*       J-WATANABE             2016.06.03  *
     F********************************************
     FAB#HL10   UF   E           K DISK    INFDS(INF1)
     FAB#HP10B  O    E             DISK
     F                                     RENAME(AB#HP101:AB#HP10X)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  AHNOHZ                 1      8  0
     D  AHNOYY                 1      4  0
     D  AHNOMM                 5      6  0
     D  AHNODD                 7      8  0
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
     C                   MOVE      PDATE         XDATE             8 0
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      AB#HL10                                90
     C     *IN90         IFEQ      *OFF
     C     AHNOHZ        IFLE      XDATE
     C                   WRITE     AB#HP10X
     C                   DELETE    AB#HP101
     C                   ADD       1             WDEL              9 0
     C                   ELSE
     C                   LEAVE
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
