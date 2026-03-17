/* CREATE:TCHK  2005.09.26 COPIED FROM ABBC7B */

  PGM     PARM(&PDAT &CPY &OUTQ)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             DCL        VAR(&PDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(ABBWP91) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABBWL91) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/ABBWP91

             OVRDBF     FILE(ABBWP91) TOFILE(QTEMP/ABBWP91)
             OVRDBF     FILE(ABBWL91) TOFILE(QTEMP/ABBWL91)
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&OUTQ) +
                          FORMTYPE(K6H1) COPIES(&CPY)

             CALL       PGM(ABBR7C) PARM(&PDAT)

             DLTOVR *ALL

             ENDPGM
