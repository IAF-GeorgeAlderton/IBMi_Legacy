             PGM
             /** RATC01 ************************************/
             /* UPDATE OF IAF RATE FILE.                   */
             /*       CREATE DATE : JUL/02/1997.           */
             /*       AUTHOR      : S.OHTAKE.              */
             /**********************************************/
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WSID)  USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(RATR01) PARM(&US)
             ENDPGM
