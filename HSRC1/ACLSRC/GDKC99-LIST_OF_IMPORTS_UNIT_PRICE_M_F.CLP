             PGM
             /*** GDKC99 ************************/
             /* LIST OF IMPORTS UNIT PRICE M/F  */
             /*     CREATE DATE  : 1997/OCT/31. */
             /*     AUTHOR       : K.OKACHI     */
             /************************ GDKC99 ***/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)
             CALL       PGM(GDKR99)

             DLTOVR     FILE(*ALL)
 END:        ENDPGM
