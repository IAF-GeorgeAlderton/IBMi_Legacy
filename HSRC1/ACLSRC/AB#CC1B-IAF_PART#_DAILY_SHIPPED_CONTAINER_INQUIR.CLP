  PGM
/** AB#CC1B ***********************************************/
/* IAF PART# DAILY SHIPPED CONTAINER INQUIRY              */
/* JW        2025.04.23                                   */
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

             DLTF       FILE(QTEMP/AB#WPC1)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPC1) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WPC1)

             DLTF       FILE(QTEMP/AB#WPC1T)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPC1T) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WPC1T)

             OVRDBF     FILE(AB#WPC1)  TOFILE(QTEMP/AB#WPC1)
             OVRDBF     FILE(AB#WPC1T) TOFILE(QTEMP/AB#WPC1T)
             CALL       PGM(AB#RC1B)

             ENDPGM
