             PGM
             /*** AJUC15 *********************************************/
             /* INQUIRY OF OUTSOURCE WEIGHT RESULT 1                 */
             /*                                                      */
             /*   KIRI 2015/12/08                                    */
             /********************************************* AJUC15 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       AGAR00 PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)


             CALL       PGM(AJUR15)


 END:        ENDPGM
