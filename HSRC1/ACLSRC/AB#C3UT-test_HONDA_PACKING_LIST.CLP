             PGM

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(4)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&JOB)
             CHGVAR     VAR(&WSID) VALUE(%SUBSTRING(&JOB 1 4))

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

             CRTDUPOBJ  OBJ(ABWPP3X) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABWPP3X

             OVRDBF     FILE(ABWPP3X) TOFILE(QTEMP/ABWPP3X)
             OVRDBF     FILE(AB#PP31) TOFILE(QTEMP/ABWPP31)
             OVRDBF     FILE(AB#PL31) TOFILE(QTEMP/ABWPL31)
             OVRDBF     FILE(AB#PL32) TOFILE(QTEMP/ABWPL32)
             OVRDBF     FILE(AB#PL33) TOFILE(QTEMP/ABWPL33)
             OVRDBF     FILE(ABWPL33) TOFILE(QTEMP/ABWPL33)

             CHKOBJ     OBJ(AB#WP60) OBJTYPE(*FILE) MBR(&WSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(AB#WP60) MBR(&WSID))

             CLRPFM     FILE(AB#WP60) MBR(&WSID)

             OVRDBF     FILE(AB#WP60) TOFILE(AB#WP60) MBR(&WSID)
             OVRDBF     FILE(AB#PW3U) TOFILE(TOBJ1/AB#PW3U)

             CALL       PGM(TOBJ1/AB#R3U)

/* JW SAVE WORK FILE */
             CPYF       FROMFILE(QTEMP/ABWPP3X) +
                          TOFILE(*LIBL/AB#PP31S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

             DLTOVR     FILE(*ALL)

             ENDPGM
