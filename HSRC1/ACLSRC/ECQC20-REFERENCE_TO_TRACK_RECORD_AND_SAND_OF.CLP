             PGM
             /** ECQC20  **************************************/
             /* REFERENCE TO TRACK RECORD AND SAND OF         */
             /*                          DIE FOR HALF A YEAR  */
             /*   M-OKUDA                       95.07.25      */
             /*************************************** ECQC20 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ECQR20)

             ENDPGM
