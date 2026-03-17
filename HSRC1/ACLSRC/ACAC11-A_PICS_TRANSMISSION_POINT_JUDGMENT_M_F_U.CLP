             PGM
             /** ACAC11 **************************************/
             /*   A-PICS TRANSMISSION POINT JUDGMENT M/F UPDATE   */
             /* I-HASADA                      95.02.07       */
             /************************************** ACAC11 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ACAR11) PARM(&USER)

             ENDPGM
