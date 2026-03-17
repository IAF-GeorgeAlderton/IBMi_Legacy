             PGM
             /** EDIR35 ************************************/
             /*  CUSTOMER NUMBER FOR ACCUNTING             */
             /*                                            */
             /*       CREATE DATE : 2000.09.21             */
             /*       CODING      : A.MAMIYA.              */
             /************************************ EDIR35 **/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)

             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(EDIR35) PARM(&US)

             ENDPGM
