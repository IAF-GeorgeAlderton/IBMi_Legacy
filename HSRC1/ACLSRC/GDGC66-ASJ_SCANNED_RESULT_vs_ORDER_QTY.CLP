/*  ASJ PARTS SCANNED RESULT VS. ORDER QTY                         */
/*               TCH  OCT/23/02                                    */
/*-----------------------------------------------------------------*/
             PGM

             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(GDGWP65) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/GDGWP65)
             OVRDBF     FILE(GDGWP65) TOFILE(QTEMP/GDGWP65)

             CALL       PGM(GDGR66)
             DLTOVR     FILE(*ALL)

             ENDPGM
