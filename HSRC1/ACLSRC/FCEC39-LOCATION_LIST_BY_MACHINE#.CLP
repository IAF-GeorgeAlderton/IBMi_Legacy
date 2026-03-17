             PGM
             /** FCEC39 *******************************************/
             /* LOCATION LIST BY MACHINE#                         */
             /*         JAN/07/03                                 */
             /******************************************* FCEC39 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)



             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)
             CRTDUPOBJ  OBJ(FCEWP39) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/FCEWP39

             OVRDBF     FILE(FCEWP39) TOFILE(QTEMP/FCEWP39)

             CALL       PGM(FCER39)
             DLTOVR     FILE(*ALL)

             ENDPGM
