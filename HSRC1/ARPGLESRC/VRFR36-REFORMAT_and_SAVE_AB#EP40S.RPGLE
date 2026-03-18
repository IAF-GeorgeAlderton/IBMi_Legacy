     H DATEDIT(*YMD.)
     F** VRFR36 ****************************************
     F*  REFORMATION FOR AB#EP40S                      *
     F*  J-WATANABE  CRT 2018.10.08                    *
     F**************************************************
     FAB#EL40S  UF   E           K DISK    INFDS(INF1)
     FAB#EP40B  O    E           K DISK
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  LGDATE                 1      8  0
     D  LGDTYY                 1      4  0
     D  LGDTMM                 5      6  0
     D  LGDTDD                 7      8  0
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
     C                   MOVE      PDATE         XDATE             8 0
     C     *LOVAL        SETLL     AB#EL40S
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      AB#EL40S                               90
     C     *IN90         IFEQ      *OFF
      *
     C     ECRDT         IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     AB#E40B1
     C                   DELETE    AB#E40S1
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
