     H DATEDIT(*YMD.)
     F** VRFR41 ****************************************************
     F*  REFORMATION FOR AM#PP01                                   *
     F*  J-WATANABE  CRT 2019.12.02                                *
     F*  ----------------------------------                        *
     F*  * ADD VRFR41  TO UTLC20                                   *
     F*  * ADD AM#PP01 BY OPT#1 (FILE REFORMATION MASTER UPDATE)   *
     F*  * CREATE   AM#PP01B  IN BACKUP                            *
     F*  * CREATE   AM#PP01SV IN BACKUP                            *
     F**************************************************************
     FAM#PL06   UF   E           K DISK    INFDS(INF1)
     F**          AL#PP011                          KRENAMEAM#PL061
     FAM#PP01B  O    E           K DISK
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
     C                   MOVE      PDATE         XDATE             8
      *
     C     *LOVAL        SETLL     AM#PL06
      * LOOP
     C                   DO        *HIVAL
     C                   READ      AM#PL06                                91
     C   91              LEAVE
      *
     C     R1SHID        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     AM#PP011
     C                   DELETE    AM#PL061
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
