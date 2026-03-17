             PGM
             /*** MCEC51 *********************************/
             /* DESIGN CHANGE PART NUMBER M/F UPDATE */
             /*        H.ITO         90.02.26            */
             /********************************* MCEC51 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(MCER51) PARM(&USER)

             ENDPGM
