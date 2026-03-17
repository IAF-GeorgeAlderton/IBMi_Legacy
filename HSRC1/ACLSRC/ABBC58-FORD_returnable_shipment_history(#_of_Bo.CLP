 PGM
/** ABBC58 ************************************************/
/*  FORD RETURNABLE SHIPMENT HISTORY(# OF BOX)            */
/*                                                        */
/*  TCHK  10/25/05 CREATE                                 */
/************************************************ ABBC58 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)


             CRTDUPOBJ  OBJ(ABBWP58) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABBWP58)
             OVRDBF     FILE(ABBWP58) TOFILE(QTEMP/ABBWP58)

             CALL       PGM(ABBR58)

             DLTOVR     FILE(*ALL)


             ENDPGM
