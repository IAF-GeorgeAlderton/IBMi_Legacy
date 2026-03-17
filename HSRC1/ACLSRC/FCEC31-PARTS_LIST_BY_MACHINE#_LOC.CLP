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
             DCL        VAR(&US)   TYPE(*CHAR) LEN(2)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&US) VALUE(%SUBSTRING(&USER 1 2))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)



             CRTDUPOBJ  OBJ(FCEWP31) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(FCEWL31) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/FCEWP31

             OVRDBF     FILE(FCEWP31) TOFILE(QTEMP/FCEWP31)
             IF         COND(&US *NE 'I4') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1)
             ENDDO

             IF         COND(&US *EQ 'I4') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(LANPRT04) +
                          FORMTYPE(K6S1)
             ENDDO

             CALL       PGM(FCER31)

             DLTOVR     FILE(*ALL)

             ENDPGM
