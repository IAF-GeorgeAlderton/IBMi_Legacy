     H DATEDIT(*YMD.)
     F** VRFR28 **********************************
     F*  REFORMATION FOR NZUPP01                 *
     F*       A.MAMIYA        2002.05.23         *
     F*       J-WATANABE             2016.06.03  *
     F*       LEC  CHG TO N2DEHZ     2023.09.07  *
     F********************************************
     FNZUPL03   UF   E           K DISK    INFDS(INF1)
     FNZUPP01B  O    E             DISK
     F                                     RENAME(NZUPP011:NZUPP01X)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                 DS
     D  N2HAHB                 1     10  0
     D  N2HAHZ                 1      8  0
     D  N2HABB                 9     10  0
     D                 DS
     D  WYMD                   1     10  0
     D  @YMD                   1      8  0
     D  @BB                    9     10  0
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
      *
     C                   MOVE      PDATE         XDATE             8 0
      *
      * set file cursor past zero shipment date...
     C     N2DEHZ        SETGT     NZUPL03
      * LOOP
     C     *IN90         DOWEQ     *OFF
     C                   READ      NZUPL03                                90
     C     *IN90         IFEQ      *OFF
     C     N2DEHZ        IFLE      XDATE
     C     N2DEHZ        ANDNE     *ZERO
     C                   WRITE     NZUPP01X
     C                   DELETE    NZUPL011
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
