     H DATEDIT(*YMD.)
     F** VRFR39 ****************************************************
     F*  REFORMATION FOR AB#PP70                                   *
     F*  J-WATANABE  CRT 2019.10.08                                *
     F*  ----------------------------------                        *
     F*  * ADD VRFR39  TO UTLC20                                   *
     F*  * ADD AB#PP70 BY OPT#1 (FILE REFORMATION MASTER UPDATE)   *
     F*  * CREATE   AB#PP70O  IN BACKUP                            *
     F*  * CREATE   AB#PP70SV IN BACKUP                            *
     F**************************************************************
     FAB#PL73   UF   E           K DISK    INFDS(INF1)
     F                                     RENAME(AB#PP701:AB#PL731)
     FAB#PP70B  O    E           K DISK
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  EKNOHZ                 1      8  0
     D  EKNOYY                 1      4  0
     D  EKNOMM                 5      6  0
     D  EKNODD                 7      8  0
      ***************************************************
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
      *
     C                   MOVE      PDATE         XDATE             8 0
      *
     C     *LOVAL        SETLL     AB#PL73
      * LOOP
     C                   DO        *HIVAL
     C                   READ      AB#PL73                                91
     C   91              LEAVE
      *
     C     EKNOHZ        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     AB#PP701
     C                   DELETE    AB#PL731
     C                   ENDIF
      *
     C                   ENDDO
      * FOOT
     C                   Z-ADD     RCNT          WREC1             9 0
     C                   MOVE      WREC1         PREC1
     C     WREC1         SUB       WDEL          WREC2             9 0
     C                   MOVE      WREC2         PREC2
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
