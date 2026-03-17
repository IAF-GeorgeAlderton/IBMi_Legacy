             PGM
             /** AGAC50 **************************************/
             /*    UPDATE OF PROCESSING CYCLE CHECK M/F      */
             /*                   WRITTEN ==> S.OOTAKE       */
             /*                   UPDATE  ==> 1993/07/08     */
             /************************************** AGAC50 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WSID) USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AGAR50) PARM(&US)
             ENDPGM
