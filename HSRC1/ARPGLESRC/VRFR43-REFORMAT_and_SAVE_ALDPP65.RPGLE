     H DATEDIT(*YMD.)
     F** VRFR43 ****************************************************
     F*  REFORMATION FOR ALDPP65                                   *
     F*  J-WATANABE  CRT 2020.02.26                                *
     F*  ----------------------------------                        *
     F*  * ADD VRFR43  TO UTLC20                                   *
     F*  * ADD ALDPP65 BY OPT#1 (FILE REFORMATION MASTER UPDATE)   *
     F*  * CREATE   ALDPP65B  IN BACKUP                            *
     F*  * CREATE   ALDPP65SV IN BACKUP                            *
     F**************************************************************
     FALDPL67   UF   E           K DISK    INFDS(INF1)
     F                                     RENAME(ALDPP651:ALDPL671)
     FALDPP65B  O    E           K DISK
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     I**          DS
     I**                                      1   80EKNOHZ
     I**                                      1   40EKNOYY
     I**                                      5   60EKNOMM
     I**                                      7   80EKNODD
      ***************************************************
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
      *
     C                   MOVE      PDATE         XDATE             8 0
      *
     C     *LOVAL        SETLL     ALDPL67
      * LOOP
     C                   DO        *HIVAL
     C                   READ      ALDPL67                                91
     C   91              LEAVE
      *
     C     AFNODT        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     ALDPP651
     C                   DELETE    ALDPL671
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
