             PGM
             /** INVCS1 ************************************/
             /*   UPDATE OF PRIORITY LT MASTER             */
             /*                                            */
             /*               CREATE DATE : 2014.08.05     */
             /*               KIRI                         */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

 @STP01:
             CALL       PGM(INVRS1)


 @END:
             ENDPGM
