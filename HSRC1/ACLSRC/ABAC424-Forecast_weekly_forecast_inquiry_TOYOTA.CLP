  PGM
/** ABAC424 ***********************************************/
/* TOYOTA FORECAST WEEKLY INQUIRY BY PART,NONY,DOCK       */
/* TCHK1 01/08/09 CREATE(COPY FROM ABAC421)               */
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

             DLTF       FILE(QTEMP/ABAWP41A)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABAWP41A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABAWP41A)

             OVRDBF     FILE(ABAWP41A) TOFILE(QTEMP/ABAWP41A)
             CALL       PGM(ABAR424)

             ENDPGM
