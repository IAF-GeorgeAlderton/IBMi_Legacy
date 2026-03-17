     H DATEDIT(*YMD.)
      ***AM#R24*****************************************************************
      *  LOADING VERIFICATION                                                  *
      *
      **************************************************************************
     FAM#PW24   CF   E             WORKSTN
     F                                     SFILE(SFL010:RRN1)
     F                                     INFDS(@INFDS)
     FAM#PL06   IF   E           K DISK
     FAGDPL12   IF   E           K DISK
     FAM#PL21   IF   E           K DISK
     FAM#WP24   UF A E           K DISK
      **************************************************************************
     D MAN             S             50    DIM(9999)
     D ERR             S             70    DIM(10) CTDATA PERRCD(1)
     D CMD             S             70    DIM(1) CTDATA PERRCD(1)
      **************************************************************************
     D @INFDS          DS
     D  @STTS            *STATUS
     D  @@LIN                370    371B 0
     D  @@REC                378    379B 0
     D                SDS
     D  #PGM                   1      8
     D  #WSID                244    253
     D  #USER                254    263
      * SYSTEM TIME
     D                 DS
     D  WSDT                   1     14  0
     D  WSSTM6                 1      6  0
     D  WSSTM4                 1      4  0
     D  WSSHHH                 1      2  0
     D  WSSNNN                 3      4  0
     D  WSSSSS                 5      6  0
     D  WSSDAT                 7     14  0
     D  WSSYYY                 7     10  0
     D  WSSMMM                11     12  0
     D  WSSDDD                13     14  0
      * SHIP DATE
     D                 DS
     D  F1SHDT                 1      8  0
     D  F1SHYY                 1      4  0
     D  F1SHMM                 5      6  0
     D  F1SHDD                 7      8  0
     D                 DS
     D  W1SHDT                 1      8  0
     D  W1SHYY                 1      4  0
     D  W1SHMM                 5      6  0
     D  W1SHDD                 7      8  0
     D                 DS
     D  MFBC                   1     50
     D  MFFIL1                 1     43
     D  MFSIDE                44     44
     D  MFFIL2                45     50
      **************************************************************************
      *                    MAIN ROUTINE
      **************************************************************************
     C     @@ID          DOWNE     '99'
     C     @@ID          CASEQ     '10'          #FMT10
     C     @@ID          CASEQ     '15'          #FMT15
     C                   ENDCS
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      **************************************************************************
      *         INITIALIZE
      **************************************************************************
     C     *INZSR        BEGSR
      *
     C                   TIME                    WSDT
      *
     C                   Z-ADD     *ZERO         F1SHDT
     C                   MOVEL     *BLANK        F1SURT
     C                   MOVEL     *BLANK        MSG
      *
     C                   MOVEL     '10'          @@ID              2
     C                   MOVEL     *OFF          *IN49
      *
     C                   ENDSR
      *************************************************************************
      *     1ST SCREEN(SHIP DATE)
      **************************************************************************
     C     #FMT10        BEGSR
      *
     C                   SETOFF                                       4748
     C                   WRITE     FMT099
     C                   EXFMT     FMT010
     C                   MOVEL     *BLANK        MSG
     C                   MOVEL     *OFF          *IN49
      *
     C                   SELECT
     C     *INKA         WHENEQ    *ON
     C                   MOVE      '99'          @@ID
     C                   OTHER
     C                   EXSR      #CHK10
     C     *IN49         IFEQ      *OFF
     C                   EXSR      #SET15
     C                   MOVEL     '15'          @@ID
     C                   ENDIF
     C     *IN49         IFEQ      *ON
     C                   MOVEL     '10'          @@ID
     C                   ENDIF
     C                   ENDSL
      *
     C                   ENDSR
      *************************************************************************
      *     1ST SCREEN CHECK
      **************************************************************************
     C     #CHK10        BEGSR
      *
     C                   SETOFF                                       313249
     C                   TIME                    WSDT
      *
     C     F1SHDT        IFEQ      *ZERO
     C                   SETON                                        3149
     C                   MOVEL     ERR(1)        MSG
     C                   ENDIF
     C                   Z-ADD     F1SHDT        W1SHDT
      *
     C     K#AGDA        KLIST
     C                   KFLD                    W1SHYY
     C                   KFLD                    W1SHMM
     C                   KFLD                    W1SHDD
      *
     C     K#AGDA        CHAIN     AGDPL12                            98
     C     *IN98         IFEQ      *ON
     C                   SETON                                        3149
     C                   MOVEL     ERR(1)        MSG
     C                   GOTO      #EF10
     C                   ENDIF
      *
      *
     C     #EF10         ENDSR
      *************************************************************************
      *     2ND SCREEN SET
      **************************************************************************
     C     #SET15        BEGSR
      *
     C                   MOVE      'N'           LOADED            1
     C                   MOVEL     *ON           *IN61
     C                   WRITE     CTL010
     C                   MOVEL     *OFF          *IN61
     C                   MOVEL     *OFF          *IN62
     C                   Z-ADD     *ZERO         RRN1              4 0
      *
      * close and clear workfile before recreating.
      *
     C                   CLOSE     AM#WP24
     C     P#CMD         PLIST
     C                   PARM                    P@CMD           256
     C                   PARM                    P@LEN            15 5
     C                   Z-ADD     70            P@LEN
     C                   MOVEL     CMD(1)        P@CMD
     C                   CALL      'QCMDEXC'     P#CMD
     C                   OPEN      AM#WP24
      *
      * start with getting all rcds for selected routes and ship date.
      *
     C                   MOVEL     F1SHDT        F1DATE            8
     C                   MOVEA     *BLANKS       MAN
     C                   Z-ADD     *ZERO         IX
      *
     C     KEY1          KLIST
     C                   KFLD                    F1DATE
      *
     C     KEY2          KLIST
     C                   KFLD                    F1DATE
     C                   KFLD                    F1SURT
      *
      * if truck/route is blank, then select all trucks/routes.
     C     F1SURT        IFEQ      *BLANKS
     C     KEY1          SETLL     AM#PL06
     C                   ELSE
     C     KEY2          SETLL     AM#PL06
     C                   ENDIF
      *
     C                   DO        *HIVAL
      *
     C     F1SURT        IFEQ      *BLANKS
     C     KEY1          READE     AM#PL06                                97
     C                   ELSE
     C     KEY2          READE     AM#PL06                                97
     C                   ENDIF
      *
     C   97              LEAVE
      *
     C     R1HNTE        IFEQ      'NG'
     C     R1SKJY        OREQ      'D'
     C     R1EXCD        ORGT      *BLANK
     C                   ITER
     C                   ENDIF
      *
     C                   MOVEL     R1MFBC        MFBC
     C                   MOVE      'A'           MFSIDE
      *
     C     MFBC          LOOKUP    MAN                                    88
     C     *IN88         IFEQ      *OFF
     C                   ADD       1             IX                4 0
     C                   MOVEL     MFBC          MAN(IX)
     C                   ELSE
     C                   ITER
     C                   ENDIF
      *
      *
      *  check load file to see if manifest has been scanned to a truck.
      *        only write to wf if not scanned to a truck or it was overridden
      *        to a different truck.
      *
     C                   MOVE      *BLANKS       R2F5OV
     C                   MOVE      *BLANKS       R2SURT
     C                   MOVE      *BLANKS       R2SHID
     C                   MOVE      *BLANKS       R2SKJY
      *
     C     R1MFBC        CHAIN     AM#PL21                            96
     C     *IN96         IFEQ      *OFF
     C     R2SKJY        ANDEQ     ' '
     C                   MOVE      'Y'           LOADED
     C     R2F5OV        IFEQ      'Y'
     C                   SETON                                        96
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN96         IFEQ      *ON
     C                   CLEAR                   AM#WP241
     C                   MOVEL     R1SHID        LVSHID
     C                   MOVEL     R1SURT        LVSURT
     C                   MOVEL     R1IAFP        LVIAFP
     C                   MOVEL     R1SMEI        LVSMEI
     C                   MOVEL     R1DOCK        LVDOCK
     C                   MOVEL     R1ORD#        LVORD#
     C                   MOVEL     R1PALT        LVPALT
     C                   MOVEL     R1MFBC        LVMFBC
     C     R2F5OV        IFEQ      'Y'
     C                   MOVE      R2F5OV        LVF5OV
     C                   MOVE      R2SURT        LVPSUR
     C                   MOVE      R2SHID        LVPSHD
     C                   ENDIF
      *
     C                   WRITE     AM#WP241
     C                   ENDIF
      *
     C                   ENDDO
      *
      *
      * now read workfile and write to subfile to be displayed.
      *
     C     *LOVAL        SETLL     AM#WP24
      *
     C                   DO        *HIVAL
      *
     C                   READ      AM#WP24                                94
     C   94              LEAVE
      *
     C                   CLEAR                   SFL010
     C                   Z-ADD     LVSHID        S1SHDT
     C                   MOVEL     LVSURT        S1SURT
     C                   MOVEL     LVIAFP        S1IAFP
     C                   MOVEL     LVSMEI        S1SMEI
     C                   MOVEL     LVDOCK        S1DOCK
     C                   MOVEL     LVORD#        S1ORD#
     C                   MOVEL     LVPALT        S1PALT
     C                   MOVEL     LVPSUR        S1OVRT
     C                   Z-ADD     LVPSHD        S1OVSH
      *
     C                   ADD       1             RRN1
     C                   WRITE     SFL010
      *
     C                   ENDDO
      *
     C     RRN1          IFEQ      *ZERO
     C     MSG           IFEQ      *BLANK
     C                   SELECT
     C     LOADED        WHENEQ    'N'
     C                   SETON                                        313249
     C                   MOVEL     ERR(3)        MSG
     C     LOADED        WHENEQ    'Y'
     C                   SETON                                            49
     C                   MOVEL     ERR(4)        MSG
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *************************************************************************
      *     2ND SCREEN DISPLAY
      **************************************************************************
     C     #FMT15        BEGSR
      *
     C                   Z-ADD     1             W#RNP1            4 0
     C                   MOVEL     *OFF          *IN49
      *
     C                   DO        *HIVAL
      *
     C                   MOVEL     *OFF          *IN47
     C                   MOVEL     *ON           *IN48
     C                   WRITE     FMT099
     C                   Z-ADD     W#RNP1        #RCN01
     C                   EXFMT     CTL010
      *
     C     @@REC         IFNE      *ZERO
     C                   Z-ADD     @@REC         W#RNP1
     C                   ENDIF
      *
     C                   MOVEL     *BLANK        MSG
     C                   MOVEL     *OFF          *IN49
      *
     C                   SELECT
     C     *INKA         WHENEQ    *ON
     C                   MOVEL     '99'          @@ID
     C                   LEAVE
     C     *INKL         WHENEQ    *ON
     C                   MOVEL     '10'          @@ID
     C                   LEAVE
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      **************************************************************************
** ERR
DATE ERROR
ERROR 2
NO DATA FOUND!
ALL LOADED






** CMD
CLRPFM QTEMP/AM#WP24
