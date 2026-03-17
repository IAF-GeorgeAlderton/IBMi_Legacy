  PGM        PARM(&MODE +
                  &HIN1 +
                  &HIN2 +
                  &HIN3 +
                  &SHIZ +
                  &DAT1 +
                  &TOL1 +
                  &UNS1 +
                  &DAT2 +
                  &TOL2 +
                  &UNS2 +
                  &DAT3 +
                  &TOL3 +
                  &UNS3)
/** AB#CAY ************************************************/
/* IAF PART# ORDER DAILY CONT INQ                         */
/*                                                        */
/* TCHK1 04/24/10 CREATE(COPY FROM AB#CAY)                */
/**********************************************************/
             DCL        VAR(&MODE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&HIN1)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN2)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN3)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&SHIZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DAT1)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TOL1)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&UNS1)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAT2)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TOL2)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&UNS2)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAT3)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TOL3)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&UNS3)  TYPE(*CHAR) LEN(6)

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
             CALL       PGM(AB#RAY1) PARM(&MODE +
                                          &HIN1 +
                                          &HIN2 +
                                          &HIN3 +
                                          &SHIZ +
                                          &DAT1 +
                                          &TOL1 +
                                          &UNS1 +
                                          &DAT2 +
                                          &TOL2 +
                                          &UNS2 +
                                          &DAT3 +
                                          &TOL3 +
                                          &UNS3)

             ENDPGM
