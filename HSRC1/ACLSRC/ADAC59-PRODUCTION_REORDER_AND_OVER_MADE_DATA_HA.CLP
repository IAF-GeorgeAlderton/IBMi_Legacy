             PGM
             /** ADAC59 ****************************/
             /*PRODUCTION REORDER AND OVER MADE DATA HANDLING*/
             /* NEW*/
             /* I-HASADA 91.03.19 */
             /**************************** ADAC59 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

 STP:        CHGJOB     SWS(00000000)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) FORMTYPE(K6H1)
             CALL       PGM(ADAR59) PARM(&USER)
             DLTOVR     FILE(QPRINT)

             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)
             SNDPGMMSG  MSG('THER ARE PRODUCTION REORDER AND OVER +
                          MADE DATA INPUT ERROR LISTS') TOMSGQ(&WSNO)
             ENDDO

             IF         (%SWITCH(1XXXXXXX)) DO
             CALL       PGM(ADAC48)
             GOTO       CMDLBL(STP)
             ENDDO

             IF         (%SWITCH(X1XXXXXX)) DO
             CALL       PGM(ADAC47)
             GOTO       CMDLBL(STP)
             ENDDO

             ENDPGM
