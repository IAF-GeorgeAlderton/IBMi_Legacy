             PGM
             /*** AAAC02 *****************************/
             /*        CONDITION M/F LIST          */
             /* H.ITO               86.06.02         */
             /*--------------------------------------*/
             /* JW1   2024.06.25 ADD PRINTER OPTION  */
             /****************************************/

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             DCL        VAR(&DNAM ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FILE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&POP  ) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

/* SELECT PRINTER */
             CALL       PGM(UTLC79B ) PARM(&PRTG)

             IF         COND(&PRTG *NE 'PDF') THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             ENDDO

             CALL       PGM(AAAR02)

             IF         COND(&PRTG *EQ 'PDF') THEN(DO)
             CHGVAR     VAR(&DNAM ) VALUE('CONDITION MF LIST')
             CHGVAR     VAR(&NONY ) VALUE(' ')
             CHGVAR     VAR(&FILE ) VALUE('QPRINT')
             CHGVAR     VAR(&POP  ) VALUE('Y')
             CALL       PGM(SPLC20) PARM(&DNAM &NONY &FILE &POP)
             ENDDO

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF9841)

             ENDPGM
