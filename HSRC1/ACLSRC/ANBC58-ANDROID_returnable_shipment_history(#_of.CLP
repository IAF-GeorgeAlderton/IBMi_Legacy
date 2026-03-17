 PGM
/** ANBC58 ************************************************/
/*  ANDROID RETURNABLE SHIPMENT HISTORY(# OF BOX)         */
/*                                                        */
/*  TCHK1 08/01/06 CREATE(COPY FROM ABBC58)               */
/**********************************************************/
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


             CRTDUPOBJ  OBJ(ABRWP58) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABRWP58)
             OVRDBF     FILE(ABRWP58) TOFILE(QTEMP/ABRWP58)

             CALL       PGM(ANBR58)

             DLTOVR     FILE(*ALL)


             ENDPGM
