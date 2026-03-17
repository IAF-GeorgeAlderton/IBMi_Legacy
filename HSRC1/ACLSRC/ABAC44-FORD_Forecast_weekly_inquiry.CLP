  PGM PARM(&PCBL)
/** ABAC44 ************************************************/
/* FORD FORECAST WEEKLY INQUIRY                           */
/*                                                        */
/* TCHK1 10/08/08 CREATE(COPY FROM ABBC25)                */
/**********************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PCBL)  TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(QTEMP/ABAWP44)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABAWP44) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABAWP44)

             OVRDBF     FILE(ABAWP44) TOFILE(QTEMP/ABAWP44)
             CALL       PGM(ABAR44) PARM(&PCBL)

             ENDPGM
