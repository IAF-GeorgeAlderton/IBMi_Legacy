 PGM PARM(&REC)

/** ANAC1E ************************************************/
/*  ANDROID PRODUCT DEMAND FORECAST                       */
/*                                                        */
/* TCHK1 07/07/06 CREATE(COPY FROM ABAC1E)                */
/**********************************************************/

             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE1)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&USR) NBR(&NBR)
             CALL       PGM(ALBC00) PARM(&USR  &WLIB)

/*------------------------*/
/*  ANDROID  EDI(830) ..  */
/*------------------------*/

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE('OUT' *CAT &WS)
             DLTF       FILE(&WLIB/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(OUTFILE) TOFILE(&WLIB/&FILE1)

             CALL       PGM(ANAR1E)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(&WLIB/&FILE1) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(@END))


             DLTOVR     FILE(QPRINT)
             MONMSG     MSGID(CPF0000)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(FORECAST) FORMTYPE(K6H1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)

             CHGJOB     SWS(XX0XXXXX)
             CALL       PGM(ANAR2K) PARM(&USR)

             DLTOVR     FILE(OUTFILE)
             DLTOVR     FILE(QPRINT2)
             DLTOVR     FILE(QPRINT)

             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)
             CPYSPLF    FILE(QPRINT2) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USR/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)
             ENDDO


             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(&WLIB/&FILE1) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(@END))

             CHGVAR     VAR(&FILE2) VALUE('IN' *CAT &WS)
             DLTF       FILE(&WLIB/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(FMTSRC) SRCMBR(ABAS2J) OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(FORECAST) FORMTYPE(K6H1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) PAGESIZE(*N 198) LPI(6) +
                          CPI(15) OUTQ(FORECAST) FORMTYPE(K6H1) +
                          HOLD(*YES)
             OVRPRTF    FILE(QPRINT3) PAGESIZE(*N 132) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)


             OVRDBF     FILE(INFILE) TOFILE(&WLIB/&FILE2)
             CALL       PGM(ABAR2J)

  @END:
             CLRPFM     FILE(ABAEP15)
             DLTOVR *ALL
             MONMSG     MSGID(CPF0000)

             ENDPGM
