             PGM        PARM(&SUPP &SUPX)
             /** AFDC09 ****************************/
             /* CHANGE BIN#                        */
             /*                                    */
             /*                                    */
             /**************************** AFDC09 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SUPX)  TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)  USER(&USER)


             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AFDR09) PARM(&SUPP &SUPX)

     /* JW  SAVE LOG */
       /**JW CALL       PGM(UTLR07) PARM('AFDC09 --> AFDR09: CHANGE BIN#') **/
             CALL       PGM(UTLR07D) PARM('AFDR09' 'AFDC09 --> +
                          AFDR09: CHANGE BIN#')

             ENDPGM
