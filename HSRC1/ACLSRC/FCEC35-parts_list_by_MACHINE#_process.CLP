             PGM
             /** FCEC35 *******************************************/
             /* PARTS LIST BY MACHINE#/PROCESS                    */
             /*         JAN/14/03                                 */
             /******************************************* FCEC35 **/
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



             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(*N +
                          198) CPI(15) RPLUNPRT(*YES) OUTQ(QPRINTC) +
                          FORMTYPE(K6H1)
             CRTDUPOBJ  OBJ(FCEWP35) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/FCEWP35

             OVRDBF     FILE(FCEWP35) TOFILE(QTEMP/FCEWP35)

             CALL       PGM(FCER35)
             DLTOVR     FILE(*ALL)

             ENDPGM
