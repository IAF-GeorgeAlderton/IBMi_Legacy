     F***************************************************
     F*  DETERMINE IF GENTRAN ERROR STATIS CODE '12'    *
JW1  F*  JW    2017.07.20 ADD USER ID                   *
     F*  RMK   2018/05/18 Check MSGHDR records written  *
     F*                   within last 15 Minutes so not *
     F*                   to read previous errors.      *
     F***************************************************
     FMSGHDRL4  IF   E           K DISK
     FMSGDTLL1  IF   E           K DISK
     FQPRINT    O    F  132        PRINTER OFLIND(*INOF)
     D                SDS
     D  #PGM                   1      8
     D  #WSID                244    253
     D  #USER                254    263
     d Times           s              6s 0
     IMSGDR
     I              MSGPGMCDE                   PGMCDE
     I              MSGPGMDES                   PGMDES
     I              MSGJOBSEQ                   JOBSEQ
     I              MSGSUBSYS                   SUBSYS
     I              MSGAUDTYP                   AUDTYP
     I              MSGAUDID                    AUDID
     I              MSGSEGID                    SEGID
     I              MSGELESEQ                   ELESEQ
     I              MSGRECNO                    RECNO
     I              MSGAPPNAM                   APPNAM
     I              MSGMAPNAM                   MAPNAM
     I              MSGADDINFO                  ADDINF
      *---------------------------------------------------------
     C*                    EXCPT@HED
     C     CYMD          SETLL     MSGHDRL4                               60
     C     CYMD          READE     MSGHDRL4                               60
      *
     C     *IN60         DOWEQ     *OFF
     C     JOBNBR        IFEQ      MSGNBR
     C     MSGCDE        ANDEQ     '12'
     C     Msgtim        ANDGT     Times
     C                   EXSR      GETDET
     C                   ENDIF
     C     CYMD          READE     MSGHDRL4                               60
     C                   ENDDO
     C                   MOVE      *ON           *INLR
      *
     C     GETDET        BEGSR
     C     MSGSEQ        SETLL     MSGDTLL1                               61
     C     MSGSEQ        READE     MSGDTLL1                               61
     C     *IN61         DOWEQ     *OFF
     C     MSGMCD        IFEQ      195
     C     MSGFPM        ANDEQ     'EBDI001'
      *
     C     FIRST         IFEQ      *BLANKS
     C                   EXCEPT    @HED
     C                   MOVE      'Y'           FIRST             1
     C                   ENDIF
      *
     C                   MOVEL     MSGIPT        IPT15            15
     C                   EXCEPT    @DTL
     C                   EXCEPT    @DTL1
     C                   ENDIF
      *
     C     *INOF         IFEQ      *ON
     C                   EXCEPT    @HED
     C                   ENDIF
      *
     C     MSGSEQ        READE     MSGDTLL1                               61
     C                   ENDDO
     C                   ENDSR
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    JOBNUM            6
     C                   PARM                    CYMD              7 0
     C                   PARM                    FIRST
     C*                    Z-ADD144735    JOBNBR  60
     C*                    Z-ADD1151218   CYMD    70
     C                   TIME                    @@TIME            6 0
     C                   MOVE      *ALL'-'       @LINE           132
     C                   MOVE      JOBNUM        JOBNBR            6 0
      /Free
          times=%dec((%time(@@time:*hms)- %minutes(15) ) ) ;
      /End-Free
      *
     C                   ENDSR
      *****************************************************************
     OQPRINT    E            @HED             01
     O                       #PGM                 8
     O                                           14 'JOB#:'
     O                       JOBNBR              21
JW1  O                                           28 'USR:'
JW1  O                       #USER               39
     O                                           86 'DATE'
     O                       UDATE         Y     95
     O                       @@TIME             104 '  :  :  '
     O                                          110 'PAGE'
     O                       PAGE          Z    114
     O          E            @HED             02
     O                                           56 'GENTRAN ERROR LISTING'
      *
     O          E            @HED             04
     O                                            7 'PARTNER'
     O                                           29 'INTERCHANGE#'
     O                                           35 'GROUP'
     O                                           46 'GROUP ID'
     O                                           61 'BATCH#'
     O          E            @HED        1
     O                       @LINE              132
     O          E            @DTL        1
     O                       IPT15               15
     O                       MSGINB              31
     O                       MSGFGP              36
     O                       ADDINF              53
     O                       MSGBSQ              62
     O          E            @DTL1       1
     O                       PGMDES             132
