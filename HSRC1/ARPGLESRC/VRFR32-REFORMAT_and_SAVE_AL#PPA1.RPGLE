     H DATEDIT(*YMD.)
     F** VRFR32 **********************************
     F*  REFORMATION FOR AL#PPA1                 *
     F*  HFILE1/AL#PPA1 --> BACKUP/ALPPA1B       *
     F*                                          *
     F*       J-WATANABE             2018.01.17  *
     F********************************************
     FAL#PLA1   UF   E           K DISK    INFDS(INF1)
     FAL#PPA1B  O    E             DISK
     F                                     RENAME(AL#PPA11:AL#PPA1X)
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
     C     *LOVAL        SETLL     AL#PLA1
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      AL#PLA1                                90
     C     *IN90         IFEQ      *OFF
     C     CRFIXD        IFLE      XDATE
     C     CRKOHZ        ANDLE     XDATE
     C                   WRITE     AL#PPA1X
     C                   DELETE    AL#PLA11
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
