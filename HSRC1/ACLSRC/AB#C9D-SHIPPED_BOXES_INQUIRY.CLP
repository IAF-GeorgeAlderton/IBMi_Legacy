             PGM
             /** AB#CAA ************************/
             /* ..SHIPPED BOXES INQUIRY        */
             /*                                */
             /**********************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(06)

             DLTF       FILE(QTEMP/ABP9D)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABP9D) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/ABP9D

             OVRDBF     FILE(ABP9D) TOFILE(QTEMP/ABP9D)

             CALL       PGM(AB#R9D)

             DLTF       FILE(QTEMP/ABP9D)

             DLTOVR     FILE(*ALL)

             ENDPGM
