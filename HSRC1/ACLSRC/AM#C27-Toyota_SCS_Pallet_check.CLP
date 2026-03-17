  PGM
/*  AM#C27  ***********************************************/
/*  TOYOTA SCS PALLET CHECK                               */
/*                                                        */
/*  LEC   2019/05/17                                      */
/**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(06)

             DLTF       FILE(QTEMP/ABP2P27)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/ABP1P27)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABP1P27) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABP2P27) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     QTEMP/ABP1P27
             CLRPFM     QTEMP/ABP2P27

             OVRDBF     FILE(ABP1P27) TOFILE(QTEMP/ABP1P27)
             OVRDBF     FILE(ABP2P27) TOFILE(QTEMP/ABP2P27)

             CALL       PGM(AM#R27)

             DLTF       FILE(QTEMP/ABP1P27)
             DLTF       FILE(QTEMP/ABP2P27)

             DLTOVR     FILE(*ALL)

             ENDPGM
