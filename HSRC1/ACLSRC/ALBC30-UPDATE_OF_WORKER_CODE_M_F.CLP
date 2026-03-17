             PGM
             /** ALBC30 ************************************/
             /* UPDATE OF WORKER CODE M/F                  */
             /*               CREATE DATE : 1997/JUN/02    */
             /*               AUTHOR      : K.OKACHI       */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ALBR30) PARM(&USER)

             ENDPGM
