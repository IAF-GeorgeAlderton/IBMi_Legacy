     H DATEDIT(*YMD.)
     F** VRFR47 ****************************************************
     F*  REFORMATION FOR AB#EP50S                                  *
     F*  J-WATANABE  CRT 2021.09.20                                *
     F*  ----------------------------------                        *
     F*  * ADD VRFR47   TO UTLC20                                  *
     F*  * ADD AB#EP71B BY OPT#1 (FILE REFORMATION MASTER UPDATE)  *
     F*  * ADD AB#EP71B BY OPT#3 (UPDATE FILE NAME              )  *
     F**************************************************************
     FAB#EL51S  UF   E           K DISK    INFDS(INF1)
     FAB#EP50B  O    E           K DISK
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  SDATE                  1     14  0
     D  NOW                    1      6  0
     D  TODAY                  7     14  0
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
     C                   MOVE      PDATE         XDATE             8 0
     C                   TIME                    SDATE
      *
     C     *LOVAL        SETLL     AB#EL51S
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      AB#EL51S                               90
     C     *IN90         IFEQ      *OFF
      *
     C     A5SVDT        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   Z-ADD     TODAY         A5RFDT
     C                   Z-ADD     NOW           A5RFTM
     C                   WRITE     AB#E50B1
     C                   DELETE    AB#E50S1
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
