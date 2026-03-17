  PGM
/* ABAC47  ************************************************/
/* FORECAST WEEKLY INQUIRY FOR ALL CUSTOMERS              */
/* J.WATANABAE  2021.08.25                                */
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

             DLTF       FILE(QTEMP/ABAWP47A)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABAWP47A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ABAWP47A)

             OVRDBF     FILE(ABAWP47A) TOFILE(QTEMP/ABAWP47A)
             CALL       PGM(ABAR47 )

             ENDPGM
