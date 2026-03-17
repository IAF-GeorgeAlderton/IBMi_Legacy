  PGM
/** AB#CAW ************************************************/
/* HONDA ORDER DAILY CONT INQ                             */
/*                                                        */
/* TCHK1 01/14/09 CREATE(COPY FROM AB#CAY)                */
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

             DLTF       FILE(QTEMP/AB#WPAW)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPAW) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WPAW)

             OVRDBF     FILE(AB#WPAW) TOFILE(QTEMP/AB#WPAW)
             CALL       PGM(AB#RAW)

             ENDPGM
