             PGM
             /** AFBC20 **************************/
             /* IAF CHANGE DETAILS M/F UPDATE */
             /* C:Y.AOYAMA 1992.07.08 */
             /************************** AFBC20 **/
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(AFBR20) PARM(&US)

 END:        ENDPGM
