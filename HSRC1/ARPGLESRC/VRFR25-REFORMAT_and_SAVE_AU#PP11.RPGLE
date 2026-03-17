     H DATEDIT(*YMD.)
     F*- VRFR25 --------------------------------------------*
     F*  REFORMATION FOR AU#PP11                            *
     F*                                                     *
     F*  COPIED FROM AFARZZ                                 *
     F*-----------------------------------------------------*
     FAU#PL13   UF   E           K DISK    INFDS(INF1)
JW1  FAU#PP11B  O    E             DISK
     F                                     RENAME(AU#PP111:AU#PP11X)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  CQSKHZ                 1      8  0
     D  CQSKYY                 1      4  0
     D  CQSKMM                 5      6  0
     D  CQSKDD                 7      8  0
      *
     C     *ENTRY        PLIST
     C                   PARM                    PYMD              8
     C                   PARM                    PRECD             9            BEFORE
     C                   PARM                    PKENS             9            AFTER
      *
     C                   MOVEL     PYMD          WYMD              8 0
      * MAIN LOOP
     C     20000101      SETLL     AU#PL13
     C     *IN90         DOWEQ     *OFF
     C                   READ      AU#PL13                                90
     C     *IN90         IFEQ      *OFF
     C     CQSKJY        ANDEQ     'D'
      *
     C     CQSKHZ        IFLT      WYMD
     C                   WRITE     AU#PP11X
     C                   DELETE    AU#PL131
     C                   ADD       1             WDEL              9 0
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      * FOOT
     C                   Z-ADD     RCNT          WREC1             9 0
     C                   MOVE      WREC1         PRECD
     C     WREC1         SUB       WDEL          WREC2             9 0
     C                   MOVE      WREC2         PKENS
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
