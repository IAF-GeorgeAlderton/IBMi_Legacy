             PGM
             /** ADHC30 **************************/
             /* IAF QUENCHING OPERATION DATA     */
             /*                                  */
             /*    CREATE DATE  2000.09.29       */
             /************************** ADHC30 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&REC)   TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID)  USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(ADHR30)

             ENDPGM
