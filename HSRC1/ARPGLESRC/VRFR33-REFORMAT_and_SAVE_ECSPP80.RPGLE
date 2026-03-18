     H DATEDIT(*YMD.)
     F** VRFR32 **********************************
     F*  REFORMATION FOR ECSPP80                 *
     F*  HFILE1/ECSPP80 --> BACKUP/ALPPA1B       *
     F*                                          *
     F*       J-WATANABE             2018.01.17  *
     F********************************************
     FECSPL84   UF   E           K DISK    INFDS(INF1)
     FECSPP80B  O    E             DISK
     F                                     RENAME(ECSPP801:ECSPP80X)
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
     C     *LOVAL        SETLL     ECSPL84
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      ECSPL84                                90
     C     *IN90         IFEQ      *OFF
      *
     C     E8IOHZ        IFLE      XDATE
     C                   WRITE     ECSPP80X
     C                   DELETE    ECSPL841
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
