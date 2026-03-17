             PGM
             /** GDWC59 ************************/
             /*                                */
             /*                                */
             /************************ GDWC59 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCLF       FILE(GDWPW59)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
  @STRT:
             SNDRCVF    RCDFMT(DSP01)
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@STRT))

             CRTDUPOBJ  OBJ(GDWWP58) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/GDWWP58
             OVRDBF     FILE(GDWWP58) TOFILE(QTEMP/GDWWP58)

             IF         COND(&USER *EQ 'TEST') THEN(CHGVAR +
                          VAR(&OUTQ) VALUE(QDKT))
             IF         COND(&USER *NE 'TEST') THEN(CHGVAR +
                          VAR(&OUTQ) VALUE(LANPRT03))

             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 80) OUTQ(&OUTQ)

             CALL       PGM(GDWR59)
             DLTOVR     FILE(*ALL)
  @END:
             ENDPGM
