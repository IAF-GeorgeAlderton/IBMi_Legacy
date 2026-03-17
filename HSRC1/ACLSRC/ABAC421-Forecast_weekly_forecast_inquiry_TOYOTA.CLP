  PGM
/** ABAC421 ***********************************************/
/* TOYOTA FORECAST WEEKLY INQUIRY BY NONY,DOCK             */
/*                                                        */
/* TCHK1 01/07/09 CREATE(COPY FROM ABAC44)                */
/**********************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(QTEMP/ABAWP421)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABAWP421) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABAWP421)

             OVRDBF     FILE(ABAWP421) TOFILE(QTEMP/ABAWP421)
             CALL       PGM(ABAR421)

             ENDPGM
