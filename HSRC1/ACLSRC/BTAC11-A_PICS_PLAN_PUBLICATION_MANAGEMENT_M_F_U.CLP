             PGM
             /*** BTAC11 *********************************/
             /* A-PICS PLAN PUBLICATION MANAGEMENT M/F UPDATE */
             /* S.YAMAGAMI 1994.06.15                    */
             /********************************** BTAC11 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(BTAR11) PARM(&USER)

             ENDPGM
