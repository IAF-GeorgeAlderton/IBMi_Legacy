             PGM
/** ABBC57H ************************************************/
/*  HONDA SHIPMENT & FORECAST AVERAGE                      */
/*                                                         */
/* TCHK  12/04/14 CREATE(COPY FROM ABBC57)                 */
/************************************************ ABBC57H **/
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


             CRTDUPOBJ  OBJ(ABBWP57H) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABBWP57H)
             OVRDBF     FILE(ABBWP57H) TOFILE(QTEMP/ABBWP57H)

             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(LANPRT03)

             IF         COND((&USER = 'I0777') *OR            +
                             (&USER = 'TEST ')) THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(WATALIB)
             ENDDO

             CALL       PGM(ABBR57H)

             CPYF       FROMFILE(QTEMP/ABBWP57H) +
                          TOFILE(TWFILE1/ABBWP57H) MBROPT(*REPLACE)

             DLTOVR     FILE(*ALL)


             ENDPGM
