     H DATEDIT(*YMD.)
     F** VRFR27 ********************************************
     F*   .. OUT-GOING TRACK DATA FILE REFORMATION ..      *
     F*       K.OKACHI                    1998.03.21       *
     F******************************************** ALDR80 **
     FALDPL3A   UF   E           K DISK    INFDS(INF1)
     FALDPP30B  O    E             DISK
     F                                     RENAME(ALDPP301:ALDPP30X)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  A3SYHZ                 1      8  0
     D  A3SYYY                 1      4  0
     D  A3SYMM                 5      6  0
     D  A3SYDD                 7      8  0
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
     C                   MOVE      PDATE         XDATE             8 0
     C     *LOVAL        SETLL     ALDPL3A
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      ALDPL3A                                90
     C     *IN90         IFEQ      *OFF
      *
     C     A3SYHZ        IFLE      XDATE
     C                   ADD       1             WKENS             7 0
     C                   WRITE     ALDPP30X
     C                   DELETE    ALDPP301
     C                   ADD       1             WDEL              9 0
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   Z-ADD     RCNT          WREC1             9 0
     C                   MOVE      WREC1         PREC1
     C     WREC1         SUB       WDEL          WREC2             9 0
     C                   MOVE      WREC2         PREC2
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
