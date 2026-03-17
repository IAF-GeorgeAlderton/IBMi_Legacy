             PGM        PARM(&GRTP)
             /** EDIC50 ******************************************/
             /*  CUSTOMER GROUP CODE MAINTENANCE                 */
             /*  JW   2017.09.06                                 */
             /****************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GRTP) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(EDIR50) PARM(&GRTP)

             ENDPGM
