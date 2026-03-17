             PGM        PARM(&USER &WKCD &SUPP &PID)
             /** AFDC01 **************************************/
             /*  OUTGOING DETAIL                             */
             /*      TO CURTIS (SUPPLYER CODE = 2222)        */
             /*  TCH 2001.12.12                              */
             /*                                              */
             /************************************** AFDC01 **/
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKCD)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&SUPP)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PID)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    USER(&USR)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)

     /*      CHGVAR     VAR(&SUPP) VALUE('2222')       */
             DLTF       FILE(QTEMP/AFDWP01)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/AFDWP02)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AFDWP01) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CRTDUPOBJ  OBJ(AFDWP02) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             OVRDBF     FILE(AFDWP01) TOFILE(QTEMP/AFDWP01)
             OVRDBF     FILE(AFDWP02) TOFILE(QTEMP/AFDWP02)

             CALL       PGM(AFDR01) PARM(&USER &WKCD &SUPP &PID)
             DLTOVR     FILE(*ALL)

             ENDPGM
