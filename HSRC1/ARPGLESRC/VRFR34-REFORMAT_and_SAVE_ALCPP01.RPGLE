     H DATEDIT(*YMD.)
     F** VRFR34 **********************************
     F*  REFORMATION FOR ALCPP01                 *
     F*  HFILE1/ALCPP01 --> BACKUP/ALCPP01B      *
     F*                                          *
     F*       J-WATANABE             2018.09.22  *
     F********************************************
     FALCPP01   UF   E           K DISK    INFDS(INF1)
     FALCPP01B  O    E             DISK
     F                                     RENAME(ALCPP011:ALCPP01X)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
      *
     C                   MOVE      PDATE         XDATE             8 0
     C     *LOVAL        SETLL     ALCPP01
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      ALCPP01                                90
     C     *IN90         IFEQ      *OFF
      *
     C     A8DATE        IFLE      XDATE
     C                   WRITE     ALCPP01X
     C                   DELETE    ALCPP011
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
