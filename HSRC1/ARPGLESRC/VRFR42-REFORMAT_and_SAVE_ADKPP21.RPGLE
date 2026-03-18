     H DATEDIT(*YMD.)
     F** VRFR42 ****************************************************
     F*  REFORMATION FOR ADKPP21                                   *
     F*  J-WATANABE  CRT 2019.12.06                                *
     F*  ----------------------------------                        *
     F*  * ADD VRFR42  TO UTLC20                                   *
     F*  * ADD ADKPP21 BY OPT#1 (FILE REFORMATION MASTER UPDATE)   *
     F*  * CREATE   ADKPP21B  IN BACKUP                            *
     F*  * CREATE   ADKPP21SV IN BACKUP                            *
     F**************************************************************
     FADKPL21   UF   E           K DISK    INFDS(INF1)
     F**          AL#PP011                          KRENAMEADKPL211
     FADKPP21B  O    E           K DISK
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
     C     *LOVAL        SETLL     ADKPL21
      * LOOP
     C                   DO        *HIVAL
     C                   READ      ADKPL21                                91
     C   91              LEAVE
      *
     C     D2APHZ        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     ADKPP211
     C                   DELETE    ADKPL211
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
