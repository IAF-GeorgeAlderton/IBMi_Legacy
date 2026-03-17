             PGM
             /*** FCHC37 ***********************************/
             /* MACHINE ABILITY M/F INQUIRY                         */
             /*            M-OKUDA        1985.02.12       */
             /**********************************************/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7) VALUE(QPRINT )
             RTVJOBA    JOB(&WS)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRT)
             CALL       PGM(FCHR37)

             ENDPGM
