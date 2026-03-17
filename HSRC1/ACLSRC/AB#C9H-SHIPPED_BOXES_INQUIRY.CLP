  PGM
/** AB#C9H *************************************************/
/*  SHIPPED BOXES INQUIRY                                  */
/*                                                         */
/* TCHK1 03/19/10 CREATE(COPY FROM AB#C9D)                 */
/***********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(06)

             DLTF       FILE(QTEMP/ABP9H)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABP9H) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/ABP9H

             OVRDBF     FILE(ABP9H) TOFILE(QTEMP/ABP9H)

             CALL       PGM(AB#R9H)

             DLTF       FILE(QTEMP/ABP9H)

             DLTOVR     FILE(*ALL)

             ENDPGM
