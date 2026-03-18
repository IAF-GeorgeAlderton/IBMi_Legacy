     H DATEDIT(*YMD.)
     F** VRFR37 ****************************************************
     F*  REFORMATION FOR ADKPP01                                   *
     F*  J-WATANABE  CRT 2018.12.13                                *
     F*  ----------------------------------                        *
     F*  * ADD VRFR38  TO UTLC20                                   *
     F*  * ADD KU#PP11 BY OPT#1 (FILE REFORMATION MASTER UPDATE)   *
     F*  * CREATE   KU#PP11O  IN BACKUP                            *
     F*  * CREATE   KU#PP11SV IN BACKUP                            *
     F**************************************************************
     FKU#PL11   UF   E           K DISK    INFDS(INF1)
     FKU#PP11B  O    E           K DISK
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     I**          DS
     I**                                      1   80D0THHZ
     I**                                      1   40D0THYY
     I**                                      5   60D0THMM
     I**                                      7   80D0THDD
      ***************************************************
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
      *
     C                   MOVE      PDATE         XDATE             8 0
      *
     C     20000000      SETLL     KU#PL11
      * LOOP
     C                   DO        *HIVAL
     C                   READ      KU#PL11                                91
     C   91              LEAVE
      *
     C     KQNKHZ        IFEQ      0
     C                   ITER
     C                   ENDIF
      *
     C     KQNKHZ        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     KU#PP111
     C                   DELETE    KU#PL111
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
