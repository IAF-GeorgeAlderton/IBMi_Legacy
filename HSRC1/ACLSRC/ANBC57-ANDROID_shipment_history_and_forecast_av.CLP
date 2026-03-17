  PGM
/** ANBC57 ************************************************/
/*  ANDROID SHIPMENT & FORECAST AVERAGE                   */
/*                                                        */
/* TCHK1 07/28/06 CREATE(COPY FROM ABBC57                 */
/**********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)


             CRTDUPOBJ  OBJ(ABRWP57) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABRWP57)
             OVRDBF     FILE(ABRWP57) TOFILE(QTEMP/ABRWP57)
             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(QPRINTC)

             CALL       PGM(ANBR57)

             DLTOVR     FILE(*ALL)


             ENDPGM
