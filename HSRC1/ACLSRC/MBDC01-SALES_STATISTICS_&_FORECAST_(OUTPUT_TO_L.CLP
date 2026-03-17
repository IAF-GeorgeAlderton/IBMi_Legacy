         PGM
         /** MBDC01 *****************************************/
         /*  SALES STATISTICS & FORECAST (OUTPUT TO L:IFS)  */
         /*  W.WATANABE  2019.02.18                         */
         /***************************************************/
             DCL        VAR(&REC)    TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DIR)    TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(29) VALUE('SALES +
                          STATISTICS and FORECAST')
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&XUSR)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&STAMP) TYPE(*CHAR) LEN(21)
             DCL        VAR(&DATE)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30) +
                          VALUE('SALES STATISTICS & FORECAST')
             DCL        VAR(&TOKU)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(2)

 RUN:
             RTVJOBA    JOB(&WSID) USER(&USER)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WS) USER(&USER)

             CHGVAR     VAR(&XUSR) VALUE(%SST(&USER 1 2))

             IF         COND(&XUSR *EQ 'I3') THEN(DO)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/Sale+
                          s/Download/' *CAT &USER)
             ENDDO
             IF         COND(&XUSR *NE 'I3') THEN(DO)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/PC/D+
                          ownload/' *CAT &USER)
             ENDDO

 /* RETRIEVE TODAY'S DATE */
             CALL       PGM(UTLR08) PARM(&STAMP)
             CHGVAR     VAR(&DATE) VALUE(&STAMP)

             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE +
                          *BCAT &DATE *TCAT '.csv')

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 /* CREATE MBDWP02 (SALES WORK FILE) */
             CLRPFM     FILE(QTEMP/MBDWP02)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105 CPF3142)
             CRTDUPOBJ  OBJ(MBDWP02) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

 /* CREATE MBDWP03 (SALES WORK FILE) */
             CLRPFM     FILE(QTEMP/MBDWP03)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105 CPF3142)
             CRTDUPOBJ  OBJ(MBDWP03) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

 /* OUTPUT MBDWP02 (SALES WORK FILE) */
             OVRDBF     FILE(MBDWP02) TOFILE(QTEMP/MBDWP02)
             CALL       PGM(MBDR01) PARM(&TOKU &NONY &NKOJ &NUKE &RTN)
             IF         COND(&RTN *EQ 'F1') THEN(GOTO #END)

 /* ADD FORECAST TO MBDWP02    */
             CALL       PGM(ABBC32) PARM(&TOKU &NONY &NKOJ &NUKE)

             RTVMBRD    FILE(QTEMP/MBDWP02) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
 /* TRANSFER.....*/
             OVRDBF     FILE(MBDWP03) TOFILE(QTEMP/MBDWP03)
             CALL       PGM(MBDR03)
             CALL       PGM(APLC97) PARM('2' 'MBDWP03' 'QTEMP' +
                          &FNAM 'Y' ' ' 'Y')
             ENDDO

 #END:
             DLTOVR     FILE(*ALL)
             ENDPGM
