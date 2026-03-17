             PGM
             /** AH#C77 **********************************/
             /* YELLOW/ORAGE LIST                        */
             /*                                          */
             /*                                          */
             /*                                          */
             /********************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CRTDUPOBJ  OBJ(AJSWP10) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM QTEMP/AJSWP10

             OVRDBF     FILE(AJSWP10) TOFILE(QTEMP/AJSWP10)

             CALL       PGM(AH#R77)

             DLTOVR     FILE(*ALL)

             ENDPGM
