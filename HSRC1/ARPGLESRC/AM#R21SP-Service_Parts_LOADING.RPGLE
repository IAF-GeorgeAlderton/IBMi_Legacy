     H DATEDIT(*YMD.)
     F** AM#R21SP  ******************************************
     F* SERVICE PARTS - LOADING                             *
     F*    LEC              2021.12.22                      *
     F*******************************************************
     FAM#PW21S  CF   E             WORKSTN
     FALBPL30   IF   E           K DISK
     FAB#PP66   IF   E           K DISK
     FAB#PL78   IF   E           K DISK
     FAB#PP44   IF   E           K DISK
     FAM#PL21S  UF A E           K DISK
     D ER              S             65    DIM(12) CTDATA PERRCD(1)
     D ROUT            S              1    DIM(10)
     D TICK            S              1    DIM(12)
      *
      * TRUCK TICKET QR BARCODE
     D                 DS
     D  TT                     1     25
     D  TTSURT                 1      7
     D  TTSHDT                 8     15
     D  TTSHYY                 8     11
     D  TTSHMM                12     13
     D  TTSHDD                14     15
     D  TTSHTM                16     21
     D  TTSHHH                16     17
     D  TTSHMN                18     19
     D  TTSHSS                20     21
     D  TTDTTM                 8     19
     D  TTFILR                22     25
      *
     D                 DS
     D  WTIME                  1     14  0
     D  SDATE                  7     14  0
     D  STIME                  1      6  0
      *
     D                 DS
     D  SHDT                   1     10
     D  SHYY                   1      4
     D  SLSH1                  5      5    INZ('/')
     D  SHMM                   6      7
     D  SLSH2                  8      8    INZ('/')
     D  SHDD                   9     10
      *
     D                 DS
     D  SHTM                   1      8
     D  SHHH                   1      2
     D  COLN1                  3      3    INZ(':')
     D  SHMN                   4      5
     D  COLN2                  6      6    INZ(':')
     D  SHSS                   7      8
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
     C                   PARM                    WTT              25
     C                   PARM                    TOKEN          2500
      *----------------------------------------------------*
      * MAIN                                               *
      *----------------------------------------------------*
     C                   EXSR      #SB100
      *
     C     WTT           IFEQ      *BLANKS
     C                   EXSR      #SB150
     C                   ELSE
     C                   MOVEL     WTT           TT
     C                   MOVEL     TTSURT        D1SURT
      *
     C                   MOVEL     TTSHYY        SHYY
     C                   MOVEL     TTSHMM        SHMM
     C                   MOVEL     TTSHDD        SHDD
     C                   MOVEL     SHDT          D1SHDT
      *
     C                   MOVEL     TTSHHH        SHHH
     C                   MOVEL     TTSHMN        SHMN
     C                   MOVEL     '00'          SHSS
     C                   MOVEL     '  '          TTSHSS
     C                   MOVEL     SHTM          D1SHTM
      *
     C                   MOVEL     '02'          DSPSW
     C                   ENDIF
      *
     C     DSPSW         DOWEQ     '02'
     C                   EXSR      #SB200
     C                   ENDDO
      *
     C                   EXSR      #SB300
      *----------------------------------------------------*
      * INITIALIZE                                         *
      *----------------------------------------------------*
     CSR   #SB100        BEGSR
      *
     C                   MOVEL     WORKER        WKCD              6 0
     C     WKCD          CHAIN     ALBPL30                            61
     C     *IN61         IFEQ      *ON
     C                   MOVE      *BLANKS       ALWKNM
     C                   ENDIF
      *
     C                   TIME                    WTIME
     C                   MOVEL     '01'          DSPSW             2
      *
     C     K#78          KLIST
     C                   KFLD                    NOYY
     C                   KFLD                    NOMM
     C                   KFLD                    NODD
     C                   KFLD                    A6TOKU
     C                   KFLD                    A6NONY
     C                   KFLD                    A6NKOJ
     C                   KFLD                    A6NUKE
      *
     CSR   ESB100        ENDSR
      *----------------------------------------------------*
      *　⒳�痧���Ј灈�聭饎�　　　　　　　　　　　　�
      *----------------------------------------------------*
     CSR   #SB150        BEGSR
      *
     C                   EXFMT     DSP01
     C                   MOVEL     *BLANK        MSG
     C                   SETOFF                                       3199
      *
     C                   TIME                    WTIME
     C     *IN03         IFEQ      *ON
     C                   MOVEL     '99'          DSPSW             2
     C                   GOTO      ESB150
     C                   ENDIF
      *
     C     BAR01         IFEQ      *BLANK
     C                   SETON                                        3199
     C                   MOVEL     ER(1)         MSG
     C                   EXSR      #SB999
     C                   SETOFF                                       3199
     C                   MOVEL     *BLANK        MSG
     C                   GOTO      ESB150
     C                   ENDIF
      *
     C                   MOVEL     BAR01         TT
      *
     C                   MOVE      *BLANK        EXPEDT            1
      * if this an expedite route, skip check...
      *    else check truck ticket.
     C     'EX-'         SCAN      TT:1          POS               3 0
     C     POS           IFGT      *ZERO
     C                   MOVE      'Y'           EXPEDT
     C                   MOVE      *BLANKS       TTSHTM
     C                   ELSE
      *
      * check truck ticket date and time for blanks.
      * if date and time contains a blank it's invalid.
     C                   MOVE      *BLANKS       TICK
      *
     C                   MOVEA     TTDTTM        TICK
     C                   DO        12            X                 2 0
     C     TICK(X)       IFEQ      *BLANK
     C                   SETON                                        3199
     C                   MOVEL     ER(2)         MSG
     C                   EXSR      #SB999
     C                   SETOFF                                       3199
     C                   MOVEL     *BLANK        MSG
     C                   GOTO      ESB150
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   MOVEL     TTSURT        D1SURT
      *
     C                   MOVEL     TTSHYY        SHYY
     C                   MOVEL     TTSHMM        SHMM
     C                   MOVEL     TTSHDD        SHDD
     C                   MOVEL     SHDT          D1SHDT
      *
     C                   MOVEL     TTSHHH        SHHH
     C                   MOVEL     TTSHMN        SHMN
     C                   MOVEL     '00'          SHSS
     C                   MOVEL     SHTM          D1SHTM
      *
     C                   MOVEL     '02'          DSPSW             2
      *
     CSR   ESB150        ENDSR
      *----------------------------------------------------*
      *　⒳�痧���橐�鯐沴�⒳�痧　　　　　　　　　　�
      *----------------------------------------------------*
     CSR   #SB200        BEGSR
      *
     C                   EXSR      #GETTL
      *
     C                   EXFMT     DSP02
     C                   MOVEL     *BLANK        MSG
     C                   SETOFF                                       3199
      *
     C                   TIME                    WTIME
      *
      * if f3, then end program.
     C     *IN03         IFEQ      *ON
     C                   MOVEL     *BLANKS       D2CASE
     C                   MOVEL     '99'          DSPSW             2
     C                   GOTO      ESB200
     C                   ENDIF
      *
      * if f4, then display delete case screen.
     C     *IN04         IFEQ      *ON
     C                   EXSR      #SB400
     C                   MOVEL     *BLANKS       D4CASE
     C                   GOTO      ESB200
     C                   ENDIF
      *
      * check case label screen for errors.
     C     D2CASE        IFEQ      *BLANK
     C                   SETON                                        3199
     C                   MOVEL     ER(3)         MSG
     C                   EXSR      #SB999
     C                   SETOFF                                       3199
     C                   MOVEL     *BLANK        MSG
     C                   GOTO      ESB200
     C                   ENDIF
      *
      * check to verify this case label has not already been entered.
      * then if case label is new, check to verify it is in asn file.
     C                   EXSR      #SB710
     C     *IN99         IFEQ      *OFF
     C                   EXSR      #SB720
     C                   ENDIF
      *
      * no errors, so write to service parts loading out-file.
     C     *IN99         IFEQ      *OFF
     C                   TIME                    WTIME
     C                   MOVEL     *BLANK        MSG
     C                   EXSR      #SB500
     C                   EXSR      #CASE
     C                   MOVEL     *BLANKS       D2CASE
     C                   ENDIF
      *
     CSR   ESB200        ENDSR
      *----------------------------------------------------*
      *　⒳�痧���痡瘏�濰⒵�槈痡���鰖槖　　　　　�
      *----------------------------------------------------*
     CSR   #SB400        BEGSR
      *
     C     *IN03         DOUEQ     *ON
      *
     C                   EXFMT     DSP04
     C                   MOVEL     *BLANK        MSG
     C                   SETOFF                                       3199
      *
     C                   TIME                    WTIME
      * F3 to cancel delete and go back to screen 2.
     C     *IN03         IFEQ      *ON
     C                   MOVEL     '02'          DSPSW
     C                   LEAVE
     C                   ENDIF
      *
      * verify that case label has been scanned to load out-file.
     C     D4CASE        IFEQ      *BLANK
     C                   SETON                                        3199
     C                   MOVEL     ER(3)         MSG
     C                   EXSR      #SB999
     C                   SETOFF                                       3199
     C                   MOVEL     *BLANK        MSG
     C                   ITER
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN26
     C     D4CASE        SETLL     AM#PL21S
     C     *IN26         DOWEQ     *OFF
     C     D4CASE        READE     AM#PL21S                               26
     C     *IN26         IFEQ      *OFF
     C     S2SKJY        ANDEQ     *BLANK
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
      * if case label was not found in loading out-file, display error.
     C     *IN26         IFEQ      *ON
     C                   SETON                                        3199
     C                   MOVEL     ER(7)         MSG
     C                   EXSR      #SB999
     C                   SETOFF                                       3199
     C                   MOVEL     *BLANK        MSG
     C                   ITER
      *
     C                   ELSE
      *
      * if case label was found...
     C                   MOVEL     'D'           S2SKJY
     C                   Z-ADD     SDATE         S2SKHZ
     C                   UPDATE    AM#PP21R
     C                   MOVEL     *BLANKS       D4CASE
     C                   MOVEL     *BLANKS       D2CASE
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     CSR   ESB400        ENDSR
      *----------------------------------------------------*
      * ERROR ON SCREEN.                                   *
      *----------------------------------------------------*
     CSR   #SB999        BEGSR
      *
     C                   MOVEL     MSG           P1ERR
     C                   CALL      'AM#R08'
     C                   PARM                    P1ERR            25
      *
     CSR   ESB999        ENDSR
      *----------------------------------------------------*
      * GET PACKING LIST NUMBER                            *
      *----------------------------------------------------*
     CSR   GETPCK        BEGSR
      *
     C                   MOVEL     TTSHYY        NOYY              4 0
     C                   MOVEL     TTSHMM        NOMM              2 0
     C                   MOVEL     TTSHDD        NODD              2 0
      *
     C     K#78          CHAIN     AB#PL78                            60
     C     *IN60         IFEQ      *OFF
     C                   MOVEL     P8SERL        S2SERL
     C                   ENDIF
      *
     CSR                 ENDSR
      *----------------------------------------------------*
      * END PROGRAM.                                       *
      *----------------------------------------------------*
     CSR   #SB300        BEGSR
     C                   SETON                                        LR
     C                   RETURN
     CSR   ESB300        ENDSR
      *----------------------------------------------------*
      * WRITE TO LOADING OUT-FILE AM#PP21S.                *
      *----------------------------------------------------*
     CSR   #SB500        BEGSR
      *
     C                   CLEAR                   AM#PP21R
     C                   Z-ADD     SDATE         S2SSHZ
     C                   Z-ADD     STIME         S2SSTI
     C                   MOVEL     WORKER        S2USCD
     C                   MOVEL     ALWKNM        S2USNM
     C                   MOVEL     W#PGM         S2KPGM
     C                   MOVEL     SUPP          S2SUPP
      *
     C                   MOVEL     TT            S2TICK
     C                   MOVEL(P)  TTSURT        S2SURT
     C                   MOVEL     TTSHDT        S2SHID
     C                   MOVEL     TTSHTM        S2SHIT
     C                   MOVE      '00'          S2SHIT
      *
     C                   MOVEL     D2CASE        S2MLBL
     C                   MOVEL     HPOS          S2NUKE
     C                   EXSR      GETPCK
     C                   WRITE     AM#PP21R
      *
     CSR   ESB500        ENDSR
      *----------------------------------------------------*
      *  CHECK TO VERIFY NOT ALREADY SCANNED.              *
      *----------------------------------------------------*
     CSR   #SB710        BEGSR
      *
     C                   MOVE      *OFF          *IN26
     C     D2CASE        SETLL     AM#PL21S
     C     *IN26         DOWEQ     *OFF
     C     D2CASE        READE     AM#PL21S                               26
     C     *IN26         IFEQ      *OFF
     C     S2SKJY        ANDEQ     *BLANK
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
      * if already scanned, set error message.
     C     *IN26         IFEQ      *OFF
     C                   SETON                                        3199
     C                   MOVEL     ER(5)         MSG
     C                   EXSR      #SB999
     C                   ENDIF
      *
     CSR   ESB710        ENDSR
      *----------------------------------------------------*
      *  CHECK TO VERIFY THIS CASE LABEL WAS SCANNED IN.   *
      *----------------------------------------------------*
     CSR   #SB720        BEGSR
      *
     C                   SETOFF                                       26
     C     D2CASE        SETLL     AB#PP66
     C     *IN26         DOWEQ     *OFF
     C     D2CASE        READE     AB#PP66                                26
      *
     C     *IN26         IFEQ      *OFF
     C                   MOVEL     A6NONY        NONY              4
     C                   MOVEL     A6HPOS        HPOS              1
     C                   EXSR      #GETSU
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
      * if not scanned to asn out-file, set error message.
     C     *IN26         IFEQ      *ON
     C                   MOVEL     *BLANKS       NONY
     C                   SETON                                        3199
     C                   MOVEL     ER(6)         MSG
     C                   EXSR      #SB999
     C                   GOTO      ESB720
     C                   ENDIF
      *
     CSR   ESB720        ENDSR
      *----------------------------------------------------*
      * CREATE AND SEND CASE BUILD JSON TO SCS.            *
      *----------------------------------------------------*
     CSR   #CASE         BEGSR
      *
     C                   CALL      'AM#C400'
     C                   PARM                    WORKER
     C                   PARM                    D2CASE
     C                   PARM                    NONY
     C                   PARM                    TOKEN
      *
     CSR                 ENDSR
      *----------------------------------------------------*
      * CALL PGM TO GET TOTAL CASES FOR TRUCK TICKET.      *
      *----------------------------------------------------*
     CSR   #GETTL        BEGSR
      *
     C                   CALL      'AM#R22T'
     C                   PARM                    TT
     C                   PARM                    D2TOTL
      *
     CSR                 ENDSR
      *----------------------------------------------------*
      * GET SUPPLIER CODE.                                 *
      *----------------------------------------------------*
     CSR   #GETSU        BEGSR
      *
     C     KEY44         KLIST
     C                   KFLD                    A6TOKU
     C                   KFLD                    A6NONY
     C                   KFLD                    A6NKOJ
     C                   KFLD                    A6NUKE
     C                   KFLD                    A6NYMD
      *
     C     KEY44         CHAIN     AB#PP44                            62
     C     *IN62         IFEQ      *OFF
     C                   MOVEL     DASUNM        SUPP              5
     C                   ELSE
     C                   MOVEL     '0242C'       SUPP
     C                   ENDIF
      *
     CSR                 ENDSR
      *----------------------------------------------------*
**
INPUT TRUCK TICKET.
INVALID TRUCK TICKET
INPUT CASE LABEL.
INVALID CASE LABEL.
ALREADY SCANNED TO TRUCK.
CASE LABEL NOT IN ASN FILE.
CASE LABEL NOT SCANNED TO TRUCK.
