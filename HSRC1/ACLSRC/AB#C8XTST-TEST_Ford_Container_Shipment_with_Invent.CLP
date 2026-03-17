             PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(06)

             DLTF       FILE(QTEMP/ABP2L01)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/ABP2P01)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/ABP1P01)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABP1P01) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABP2P01) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABP2L01) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     QTEMP/ABP1P01
             CLRPFM     QTEMP/ABP2P01

             OVRDBF     FILE(ABP1P01) TOFILE(QTEMP/ABP1P01)
             OVRDBF     FILE(ABP2P01) TOFILE(QTEMP/ABP2P01)
             OVRDBF     FILE(ABP2L01) TOFILE(QTEMP/ABP2L01)



             CALL       PGM(TOBJ1/AB#R8X)

             DLTF       FILE(QTEMP/ABP2L01)
             DLTF       FILE(QTEMP/ABP2P01)
             DLTF       FILE(QTEMP/ABP1P01)

             DLTOVR     FILE(*ALL)

             ENDPGM
