     H DATEDIT(*YMD.)
     F** VRFR45 ****************************************************
     F*  REFORMATION FOR AB#EP71S                                  *
     F*  J-WATANABE  CRT 2021.01.15                                *
     F*  ----------------------------------                        *
     F*  * ADD VRFR45   TO UTLC20                                  *
     F*  * ADD AB#EP71B BY OPT#1 (FILE REFORMATION MASTER UPDATE)  *
     F*  * ADD AB#EP71B BY OPT#3 (UPDATE FILE NAME              )  *
     F**************************************************************
     FAB#EL71S  UF   E           K DISK    INFDS(INF1)
     FAB#EP71B  O    E           K DISK
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
     C                   MOVE      PDATE         XDATE             8 0
      *
     C     *LOVAL        SETLL     AB#EL71S
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      AB#EL71S                               90
     C     *IN90         IFEQ      *OFF
      *
     C     E7CRDT        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     AB#E71B1
     C                   DELETE    AB#E71S1
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
