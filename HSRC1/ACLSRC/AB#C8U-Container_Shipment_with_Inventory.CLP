  PGM
/** AB#C8U ************************************************/
/*  CONTAINER SHIPMENT VS INVENTORY CONTROL               */
/*                                                        */
/* TCHK1 05/27/11 CREATE(COPY FROM AB#C9E)                */
/**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(06)
 /* ABP1P01 */
             DLTF       FILE(QTEMP/ABP1P01)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABP1P01) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/ABP1P01
 /* ABP2P01 */
             DLTF       FILE(QTEMP/ABP2L01)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/ABP2P01)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABP2P01) FROMLIB(HFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABP2L01) FROMLIB(HFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/ABP2P01
 /* ABP3P01 */
             DLTF       FILE(QTEMP/ABP3L01)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/ABP3P01)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABP3P01) FROMLIB(HFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABP3L01) FROMLIB(HFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/ABP3P01


             OVRDBF     FILE(ABP1P01) TOFILE(QTEMP/ABP1P01)
             OVRDBF     FILE(ABP2P01) TOFILE(QTEMP/ABP2P01)
             OVRDBF     FILE(ABP2L01) TOFILE(QTEMP/ABP2L01)
             OVRDBF     FILE(ABP3P01) TOFILE(QTEMP/ABP3P01)
             OVRDBF     FILE(ABP3L01) TOFILE(QTEMP/ABP3L01)

             CALL       PGM(AB#R8U)

             DLTOVR     FILE(*ALL)

             ENDPGM
