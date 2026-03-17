             PGM

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&JOB)
             CHGVAR     VAR(&WSID) VALUE(%SUBSTRING(&JOB 1 3))

             CRTDUPOBJ  OBJ(ABWPP31) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABWPL31) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABWPL32) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABWPL33) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABWPP31


             OVRDBF     FILE(ABWPP31) TOFILE(QTEMP/ABWPP31)
             OVRDBF     FILE(ABWPL32) TOFILE(QTEMP/ABWPL32)
             OVRDBF     FILE(ABWPL33) TOFILE(QTEMP/ABWPL33)

             OVRPRTF    FILE(AB#PR44) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1) COPIES(1)

             CALL       PGM(AB#R3T)

             DLTOVR     FILE(*ALL)

             ENDPGM
