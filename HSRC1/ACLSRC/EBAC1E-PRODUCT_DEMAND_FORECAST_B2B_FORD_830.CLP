             PGM        PARM(&REC)
             /** EBAC1E ******************************************/
             /* PRODUCT DEMAND FORECAST  B2B FORD 830            */
             /*    T.SAKAKI 06/14/2017                           */
             /********************************* ORIGINAL:ABAC1E **/
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE1)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&USR) NBR(&NBR)
             CALL       PGM(ALBC01) PARM(&USR &PLIB &WLIB)

             /*------------------------*/
             /*  ..FORD   EDI(830) ..  */
             /*------------------------*/
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE('OUT' *CAT &WS)
             DLTF       FILE(&WLIB/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(OUTFILE) TOFILE(&WLIB/&FILE1)

       /* CLEAR EBAEP25 */
             CLRPFM     FILE(EBAEP25)

       /* EBAEP10,EBAEP11 -> ABAWP10 */
       /*                 -> ABFPP10, ABFPP20, ABFPP30 */
       /*                 -> EBAEP25 */
       /*                 -> OUTFILE */
             CALL       PGM(EBAR1E)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(&WLIB/&FILE1) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(@END))

             DLTOVR     FILE(QPRINT)
             MONMSG     MSGID(CPF0000)

             OVRPRTF    FILE(QPRINT3) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(FORECAST) FORMTYPE(K6H1) HOLD(*YES)

             CHGJOB     SWS(XX0XXXXX)

       /* ABFPP10 -> ABFPP20 */
       /*         -> QPRINT3 */
             CALL       PGM(ABAR2L) PARM(&USR)

             OVRPRTF    FILE(QPRINT2) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(FORECAST) +
                          FORMTYPE(K6H1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(FORECAST) FORMTYPE(K6H1) HOLD(*YES)

       /* ABFPP10 -> ABFPP20 */
       /*         -> QPRINT, QPRINT2 */
             CALL       PGM(ABAR2K) PARM(&USR)

             DLTOVR     FILE(OUTFILE)
             DLTOVR     FILE(QPRINT2)
             DLTOVR     FILE(QPRINT3)
             DLTOVR     FILE(QPRINT)

             CHGVAR     VAR(&FILE2) VALUE('IN' *CAT &WS)
             DLTF       FILE(&WLIB/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL) +
                          SIZE(*NOMAX)
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

       /* INFILE -> QPRINT, QPRINT2, QPRINT3 */
             OVRDBF     FILE(INFILE) TOFILE(&WLIB/&FILE2)
             CALL       PGM(ABAR2J)
  @END:

/* call pgm to verify plant/dock/stg facility in ford route master, email list*/
             CALL       PGM(AB#CG8)

             DLTOVR *ALL
             MONMSG     MSGID(CPF0000)

             ENDPGM
