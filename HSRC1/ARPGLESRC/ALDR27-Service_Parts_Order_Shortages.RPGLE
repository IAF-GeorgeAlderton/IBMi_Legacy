     H DATEDIT(*YMD.)
     F** ALDR27 *********************************************
     F* SERVICE PARTS - ORDER SHORTAGES                     *
     F*    LEC.  2021.05.21                                 *
     F*******************************************************
     FALDPW27   CF   E             WORKSTN INFDS(@INFDS) MAXDEV(*FILE)
     FAB#PL1L   IF   E           K DISK
     FAB#PL44C  IF   E           K DISK
     FAB#PL71   UF   E           K DISK
     FALDWP27   UF A E             DISK
     D ER              S             65    DIM(4) CTDATA PERRCD(1)
      *
     D @INFDS          DS
     D  @STTS            *STATUS
      *
     D                 DS
     D  D1BARC                 1     18
      *
     D                 DS
     D  WTIME                  1     14  0
     D  SDATE                  7     14  0
     D  SDYY                   7     10  0
     D  SDMM                  11     12  0
     D  SDDD                  13     14  0
     D  STIME                  1      6  0
     D  STHH                   1      2  0
     D  STMM                   3      4  0
      *
     D                 DS
     D  SHID                   1      8  0
     D  EKNOYY                 1      4  0
     D  EKNOMM                 5      6  0
     D  EKNODD                 7      8  0
      *
     D                 DS
     D  IPART                  1     12
     D  EKSHN1                 1      5
     D  EKSHN2                 6     10
     D  EKSHN3                11     12
      *
     D                 DS
     D  CPART                  1     20
     D  CPART1                 1     12
     D  EKMHN1                 1      5
     D  EKMHN2                 6     10
     D  EKMHN3                11     15
     D  EKMHN4                16     20
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
     C     *ENTRY        PLIST
     C                   PARM                    WORKER            6
     C                   PARM                    WUSRID           10
      *----------------------------------------------------*
      * MAIN                                               *
      *----------------------------------------------------*
     C                   EXSR      #SB100
     C     DSPSW         DOUEQ     '99'
     C                   EXSR      #SB200
     C                   ENDDO
     C                   EXSR      #SB300
      *----------------------------------------------------*
      * INZ                                                *
      *----------------------------------------------------*
     CSR   #SB100        BEGSR
      *
     C     K#1L          KLIST
     C                   KFLD                    NONY              4 0
     C                   KFLD                    EKNOYY
     C                   KFLD                    EKNOMM
     C                   KFLD                    EKNODD
     C                   KFLD                    EKNUKE
     C                   KFLD                    EKODRN
     C                   KFLD                    EKMHN1
     C                   KFLD                    EKMHN2
     C                   KFLD                    EKMHN3
      *
     C     K#44C         KLIST
     C                   KFLD                    NONY
     C                   KFLD                    SHID
     C                   KFLD                    ORDN             15
     C                   KFLD                    EKMHN1
     C                   KFLD                    EKMHN2
     C                   KFLD                    EKMHN3
     C                   KFLD                    EKMHN4
      *
     C                   TIME                    WTIME
     C                   MOVEL     '01'          DSPSW             2
     C                   MOVEL     WORKER        USRCD             6
     C                   CLEAR                   DSP01
      *
      *   DUMMY READ
     C                   READ(N)   ALDWP27                                77
      *
     CSR   ESB100        ENDSR
      *----------------------------------------------------*
      * MAIN                                               *
      *----------------------------------------------------*
     CSR   #SB200        BEGSR
      *
     C                   WRITE     DSP01
     C                   READ      ALDPW27                              7171
      *
      **********           EXFMTDSP01
     C                   MOVEL     *BLANK        MSG
     C                   SETOFF                                       3199
      *
     C     *IN71         IFEQ      '1'
     C     @STTS         ANDEQ     1331
     C                   MOVE      '99'          DSPSW
     C                   GOTO      ESB200
     C                   ENDIF
      *
     C                   TIME                    WTIME
     C     *INKC         IFEQ      *ON
     C                   MOVEL     '99'          DSPSW             2
     C                   GOTO      ESB200
     C                   ENDIF
      *
     C                   EXSR      #CHK01
      *
     C     *IN99         IFEQ      *OFF
     C                   EXSR      #SB500
     C                   ADD       1             D1SHRT
     C                   ELSE
     C                   EXSR      #SB999
     C                   SETOFF                                       3199
     C                   MOVEL     *BLANK        MSG
     C                   ENDIF
      *
     C                   CLEAR                   D1BARC
      *
     CSR   ESB200        ENDSR
      *----------------------------------------------------*
      *瀗疢�⒳�痧�　　　　　　　　　　　　　　　　　　�
      *----------------------------------------------------*
     CSR   #CHK01        BEGSR
      *
     C                   Z-ADD     *ZERO         ORDQTY
      *
      * check barcode...
     C     D1BARC        IFEQ      *BLANK
     C                   SETON                                        3199
     C                   MOVEL     ER(1)         MSG
     C                   GOTO      ECHK01
     C                   ENDIF
      *
      * check label file...
     C     D1BARC        CHAIN(N)  AB#PL71                            50
      *
     C                   SELECT
     C     *IN50         WHENEQ    *ON
     C                   SETON                                        3199
     C                   MOVEL     ER(3)         MSG
     C                   GOTO      ECHK01
     C     *IN50         WHENEQ    *OFF
     C     EKSKJY        ANDEQ     'D'
     C     EKKOME        ANDEQ     'SHORT'
     C                   SETON                                        3199
     C                   MOVEL     ER(2)         MSG
     C                   GOTO      ECHK01
     C     *IN50         WHENEQ    *OFF
     C     EKSKJY        ANDEQ     'D'
     C     EKKOME        ANDNE     'SHORT'
     C                   SETON                                        3199
     C                   MOVEL     ER(3)         MSG
     C                   GOTO      ECHK01
     C                   ENDSL
      *
     C                   MOVEL     EKSYOS        QPC               5 0
      * check order file...
     C                   EXSR      GETQTY
     C     ORDQTY        IFEQ      *ZERO
     C                   SETON                                        3199
     C                   MOVEL     ER(4)         MSG
     C                   ENDIF
      *
     CSR   ECHK01        ENDSR
      *----------------------------------------------------*
      * Display Error Message                              *
      *----------------------------------------------------*
     CSR   #SB999        BEGSR
      *
     C                   MOVEL     MSG           P1ERR
     C                   CALL      'AM#R08'
     C                   PARM                    P1ERR            25
      *
     CSR   ESB999        ENDSR
      *----------------------------------------------------*
      * End the Program                                    *
      *----------------------------------------------------*
     CSR   #SB300        BEGSR
     C                   SETON                                        LR
     C                   RETURN
     CSR   ESB300        ENDSR
      *----------------------------------------------------*
      * Write to Shortage Workfile - ALDWP27               *
      *----------------------------------------------------*
     C     #SB500        BEGSR
      *
     C                   CLEAR                   ALDWP271
     C                   MOVEL     WORKER        W1KOME
     C                   MOVEL     W#PGM         W1KPGM
     C                   Z-ADD     SDATE         W1SSHZ
     C                   Z-ADD     STIME         W1SSTI
      *
     C                   MOVEL     EKSERL        W1SERL
     C                   MOVEL     SHID          W1SHID
     C                   MOVEL     EKDETM        W1SHIT
     C                   MOVEL     EKNONY        W1NONY
     C                   MOVEL     EKNUKE        W1NUKE
     C                   MOVEL     EKODRN        W1ORD#
     C                   MOVEL     CPART         W1MHN
     C                   MOVEL     IPART         W1SHN
     C                   MOVEL     EKSYOS        W1QPC
     C                   MOVEL     EKNOBN        W1NOBN
     C                   EXSR      GETQTY
     C                   EVAL      W1HPOS = BAHPOS
     C                   EVAL      W1LIN# = BALIN#
     C                   EVAL      W1LINE = BALIN#
     C                   EVAL      W1IAF# = BAIAF#
      *
     C                   EXSR      GETLIN
     C                   EXSR      GETRDA
     C                   WRITE     ALDWP271
      *
     C                   EXSR      #SB525
      *
     C                   ENDSR
      *----------------------------------------------------*
      * Call Pgm to Update Order Files - Adjust Quantity.  *
      *----------------------------------------------------*
     C     #SB525        BEGSR
      *
     C     D1BARC        CHAIN     AB#PL71                            50
     C     *IN50         IFEQ      *OFF
     C                   MOVEL     'D'           EKSKJY
     C                   MOVEL     'SHORT'       EKKOME
     C                   Z-ADD     SDYY          EKSKYY
     C                   Z-ADD     SDMM          EKSKMM
     C                   Z-ADD     SDDD          EKSKDD
     C**jw               Z-ADD     SDYY          EKKOYY
     C**                 Z-ADD     SDMM          EKKOMM
     C**                 Z-ADD     SDDD          EKKODD
     C**                 Z-ADD     STHH          EKKOHH
     C**                 Z-ADD     STMM          EKKOMN
     C                   UPDATE    AB#PP701
     C                   ENDIF
      *
     C                   Z-ADD     BAODER        QTYORD            5 0
     C                   MOVEL     EKNONY        NONY#             4 0
      *
     C                   CALL      'ALDC27H'
     C                   PARM                    CPART1
     C                   PARM                    NONY#
     C                   PARM                    SHID
     C                   PARM                    EKODRN
     C                   PARM                    EKNUKE
     C                   PARM                    QTYORD
     C                   PARM                    WORKER
      *
     C                   ENDSR
      *----------------------------------------------------*
      * Get Ordered Qty from the Order File.               *
      *----------------------------------------------------*
     C     GETQTY        BEGSR
      *
     C                   MOVEL     EKNONY        NONY
      *
     C     K#1L          SETLL     AB#PL1L
      *
     C                   DO        *HIVAL
     C     K#1L          READE     AB#PL1L                                50
      *
     C     *IN50         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
      *
     C     BASKJY        IFNE      *BLANK
     C     BAODRN        ORNE      EKODRN
     C     BANUKE        ORNE      EKNUKE
     C     BAUSYS        ORNE      QPC
     C                   ITER
     C                   ENDIF
      *
      * ordered qty...
     C                   Z-ADD     BAODER        W1ODER
     C                   Z-ADD     BAODER        ORDQTY            5 0
      *
     C                   LEAVE
      *
     C                   ENDDO
      *
     C                   ENDSR
      *----------------------------------------------------*
      * Get Orignial PO Line Number from EDI file.         *
      *----------------------------------------------------*
     C     GETLIN        BEGSR
      *
     C                   IF        W1LINE = *BLANKS
      *
     C                   MOVEL     EKNONY        NONY
     C                   MOVEL     EKODRN        ORDN
      *
     C     K#44C         SETLL     AB#PL44C
      *
     C                   DO        *HIVAL
     C     K#44C         READE     AB#PL44C                               50
      *
     C     *IN50         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
      *
     C     DANUKE        IFNE      EKNUKE
     C                   ITER
     C                   ENDIF
      *
      * line number...
     C                   MOVEL     DALINE        W1LINE
     C                   MOVEL     DALINE        W1LIN#
      *
     C                   LEAVE
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *----------------------------------------------------*
     C     GETRDA        BEGSR
      *
     C                   MOVEL     SHID          SHPDAT
     C                   MOVE      *BLANKS       RDADAT
      *
     C                   CALL      'UTLR10'
     C                   PARM                    SHPDAT            8
     C                   PARM      '+'           SIGN              1
     C                   PARM      '0115'        DAYS              4
     C                   PARM      'Y'           IAFNO             1
     C                   PARM                    RDADAT            8
     C                   PARM                    RTN               1
      *
     C                   MOVEL     RDADAT        W1RDA
      *
     C                   ENDSR
      *----------------------------------------------------*
**
SCAN SERIAL BARCODE.
NO LABEL DATA.
ALREADY SHORTED.
NO ORDER DATA.
