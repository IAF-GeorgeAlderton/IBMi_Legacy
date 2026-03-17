  PGM
/** AB#C6V ************************************************/
/*  CONTAINER SHIPMENT VS INVENTORY CONTROL               */
/**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(06)
 /* AB#WP6V */
             DLTF       FILE(QTEMP/AB#WL6V)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/AB#WP6V)
             MONMSG     MSGID(CPF0000)

           CRTDUPOBJ  OBJ(AB#WP6V) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
           MONMSG     MSGID(CPF0000)
           CRTDUPOBJ  OBJ(AB#WL6V) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
           MONMSG     MSGID(CPF0000)
           CLRPFM     QTEMP/AB#WP6V
 /* AB#WP6V2 */
             DLTF       FILE(QTEMP/AB#WP6V2)
             MONMSG     MSGID(CPF0000)

           CRTDUPOBJ  OBJ(AB#WP6V2) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
           MONMSG     MSGID(CPF0000)
           CLRPFM     QTEMP/AB#WP6V2

             OVRDBF     FILE(AB#WP6V)  TOFILE(QTEMP/AB#WP6V)
             OVRDBF     FILE(AB#WL6V)  TOFILE(QTEMP/AB#WL6V)
             OVRDBF     FILE(AB#WP6V2) TOFILE(QTEMP/AB#WP6V2)

             CALL       PGM(AB#R6V2)

             CPYF       FROMFILE(QTEMP/AB#WP6V) +
                          TOFILE(TWFILE1/AB#WP6V) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(QTEMP/AB#WP6V2) +
                          TOFILE(TWFILE1/AB#WP6V2) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             DLTOVR     FILE(*ALL)

             ENDPGM
