     H DATEDIT(*YMD.)
      ** VRFR24 ****************************************
      *  REFORMATION FOR ALDPP25                       *
      *  J-WATANABE  CRT 2017.04.06                    *
      *  LEC   2023.08.25 - UPD DELETE LOGIC TO CHECK  *
      *                   IF IT SHIPPED OUT BEFORE     *
      *                   PURGE DATE.                  *
      **************************************************
     FALDPL28   UF   E           K DISK    INFDS(INF1)
     FNZUPL01   IF   E           K DISK
     FALDPP25B  O    E             DISK
     F                                     RENAME(ALDPP251:ALDPP25X)
      ***************************************************
     D INF1            DS
     D  RCNT                 156    159B 0
     D                SDS
     D  #PGM                   1      8
     D  #WSID                244    253
     D  #USER                254    263
      *
     D                 DS
     D  @SDATE                 1     14  0
     D  NOW                    1      6  0
     D  TODAY                  7     14  0
      *
      ***************************************************
     C     *ENTRY        PLIST
     C                   PARM                    PDATE             8
     C                   PARM                    PREC1             9
     C                   PARM                    PREC2             9
     C                   MOVE      PDATE         XDATE             8 0
      *
     C     KEY           KLIST
     C                   KFLD                    A9AZET
     C                   KFLD                    A9TEHA
     C                   KFLD                    A9PAGE
      *
     C                   TIME                    @SDATE
      *
      * MAIN LOOP
     C     *LOVAL        SETLL     ALDPL28
     C     *IN90         DOWEQ     *OFF
     C                   READ      ALDPL28                                90
      *
     C     *IN90         IFEQ      *OFF
      * NG...
     C     A9OKNG        IFEQ      'NG'
      *
     C     A9KODT        IFLT      XDATE
     C                   ADD       1             WDEL              9 0
     C                   WRITE     ALDPP25X
     C                   DELETE    ALDPP251
     C                   ENDIF
      * OK...
     C                   ELSE
      * if the kanban has been scanned out (shipped) then delete from
      * final location...
     C     KEY           CHAIN     NZUPL01                            51
     C     *IN51         DOWEQ     *OFF
     C     N2NYHZ        IFEQ      A9CODT
     C     N2DEHZ        ANDGT     *ZERO
     C     N2DEHZ        ANDLT     XDATE
     C                   ADD       1             WDEL
     C                   WRITE     ALDPP25X
     C                   DELETE    ALDPP251
     C                   LEAVE
     C                   ENDIF
     C     KEY           READE     NZUPL01                                51
     C                   ENDDO
      *
     C                   ENDIF
      *
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
