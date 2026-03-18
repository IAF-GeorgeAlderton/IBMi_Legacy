     H DATEDIT(*YMD.)
     F** VRFR37 ****************************************
     F*  REFORMATION FOR ADKPP01                       *
     F*  J-WATANABE  CRT 2018.12.13                    *
     F**************************************************
     FADKPL02   UF   E           K DISK    INFDS(INF1)
     FADKPP01B  O    E           K DISK
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  D0THHZ                 1      8  0
     D  D0THYY                 1      4  0
     D  D0THMM                 5      6  0
     D  D0THDD                 7      8  0
      ***************************************************
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
      *
     C                   MOVE      PDATE         XDATE             8 0
      *
     C     *LOVAL        SETLL     ADKPL02
      * LOOP
     C                   DO        *HIVAL
     C                   READ      ADKPL02                                91
     C   91              LEAVE
      *
     C     D0THHZ        IFGT      XDATE
     C                   LEAVE
     C                   ELSE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     ADKPP011
     C                   DELETE    ADKPL021
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
