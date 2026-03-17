  PGM PARM(&PCBL)
/** ABAC43 ************************************************/
/* HONDA FORECAST WEEKLY INQUIRY                          */
/*                                                        */
/* TCHK1 12/08/10 CREATE(COPY FROM ABAC44)                */
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

             DLTF       FILE(QTEMP/ABAWP43)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABAWP43) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABAWP43)

             OVRDBF     FILE(ABAWP43) TOFILE(QTEMP/ABAWP43)
             OVRDBF     FILE(ABAPW43) TOFILE(TOBJ1/ABAPW43)
             CALL       PGM(TOBJ1/ABAR43) PARM(&PCBL)

             ENDPGM
