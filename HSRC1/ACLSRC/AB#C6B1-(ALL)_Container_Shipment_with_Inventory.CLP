  PGM
/** AB#C6B1 ***********************************************/
/*  CONTAINER SHIPMENT VS INVENTORY CONTROL (ALL)         */
/*  JW        2023.03.23                                  */
/**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(06)
 /* AB#WP6B */
             DLTF       FILE(QTEMP/AB#WL6B)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/AB#WP6B)
             MONMSG     MSGID(CPF0000)
           CRTDUPOBJ  OBJ(AB#WP6B) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
           MONMSG     MSGID(CPF0000)
           CRTDUPOBJ  OBJ(AB#WL6B) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
           MONMSG     MSGID(CPF0000)
           CLRPFM     QTEMP/AB#WP6B
 /* AB#WP6B3 */
             DLTF       FILE(QTEMP/AB#WP6B3)
             MONMSG     MSGID(CPF0000)

           CRTDUPOBJ  OBJ(AB#WP6B3) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
           MONMSG     MSGID(CPF0000)
           CLRPFM     QTEMP/AB#WP6B3

 /* AB#WP6B4 */
           DLTF       FILE(QTEMP/AB#WP6B4)
           MONMSG     MSGID(CPF0000)

           CRTDUPOBJ  OBJ(AB#WP6B4) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
           MONMSG     MSGID(CPF0000)

           CLRPFM     QTEMP/AB#WP6B4

             OVRPRTF    FILE(QPRINT)   PAGESIZE(66 198) CPI(15)
             OVRDBF     FILE(AB#WP6B)  TOFILE(QTEMP/AB#WP6B)
             OVRDBF     FILE(AB#WL6B)  TOFILE(QTEMP/AB#WL6B)
             OVRDBF     FILE(AB#WP6B3) TOFILE(QTEMP/AB#WP6B3)
             OVRDBF     FILE(AB#WP6B4) TOFILE(QTEMP/AB#WP6B4)

             CALL       PGM(AB#R6B4)

             CPYF       FROMFILE(QTEMP/AB#WP6B) +
                          TOFILE(TWFILE1/AB#WP6B) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(QTEMP/AB#WP6B3) +
                          TOFILE(TWFILE1/AB#WP6B3) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             DLTOVR     FILE(*ALL)

             ENDPGM
