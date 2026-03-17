             PGM
             /** AAFC45 *****************/
             /*  MAKE PRODUCTION ORDER  */
             /*       CHIEF OF G.B.C    */
             /***************** AAFC45 **/
             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKYM) TYPE(*CHAR) LEN(6)

             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WS) USER(&US)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABBDS3 1 6))

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             IF         COND(&US *EQ 'A4039') THEN(DO)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(TPRINT) FORMTYPE('D973(ENG)')
             ENDDO
             ELSE       DO
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          ALIGN(*YES) OUTQ(&PRTG) FORMTYPE(D973)
             ENDDO
             CALL       PGM(AAFR45) PARM(&US &PKYM)
             DLTOVR     FILE(QPRINT)

             /*------------------*/
             /*  ..SNDNETSPLF..  */
             /*------------------*/
             IF         COND(&US *EQ 'A4039     ') THEN(DO)
             CALL       PGM(AGGC01)
             ENDDO

             ENDPGM
