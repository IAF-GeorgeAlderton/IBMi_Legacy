             PGM
             /** MBDC65 *********************************/
             /* # OF BOXES SHIPPED              ... */
             /*           FEB/02/2003                   */
             /*                                         */
             /********************************* MBDC65 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WS) USER(&US)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)


             CALL       PGM(MBDR65TT)

             ENDPGM
