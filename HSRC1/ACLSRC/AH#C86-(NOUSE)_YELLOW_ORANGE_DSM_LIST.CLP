             PGM
             /** AH#C86 **********************************/
             /* YELLOW/ORANGE DSM LIST                   */
             /*                                          */
             /* TCHK  11/13/13 CREATE(COPY FROM AH#C77)  */
             /********************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(AJSWP50) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     QTEMP/AJSWP50

             OVRDBF     FILE(AJSWP50) TOFILE(QTEMP/AJSWP50)

             CALL       PGM(AH#R86)

             DLTOVR     FILE(*ALL)

             ENDPGM
