             PGM
             /** NSUC68 **************************/
             /* INVENTORY COUNTING ACCUMULATION FILE DATA CHANGE */
             /* A.IDOTA             88.07.04     */
             /************************** NSUC68 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

      /* INVENTORY COUNTING  ACCUMULATION FILE UPDATE*/

             CALL       PGM(NSUR68)

 END:        ENDPGM
