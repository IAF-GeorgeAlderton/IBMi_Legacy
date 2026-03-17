  PGM
/** AB#CAY2 ***********************************************/
/* ALL SHIP-TO ORDER DAILY CONT INQ                       */
/*                                                        */
/* TCHK  02/10/11 CREATE(COPY FROM AB#CAY1)               */
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

             DLTF       FILE(QTEMP/AB#WPAY)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPAY) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WPAY)

             OVRDBF     FILE(AB#WPAY) TOFILE(QTEMP/AB#WPAY)
             CALL       PGM(AB#RAY2)

             ENDPGM
