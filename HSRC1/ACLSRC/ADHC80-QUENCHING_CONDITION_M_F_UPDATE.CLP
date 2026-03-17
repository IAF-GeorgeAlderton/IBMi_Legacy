             PGM
             /*** ADHC80 ***********************************/
             /* QUENCHING CONDITION M/F UPDATE             */
             /*        KIRI            2017.08.10          */
             /*********************************** ADHC80 ***/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ADHR80)

             ENDPGM
