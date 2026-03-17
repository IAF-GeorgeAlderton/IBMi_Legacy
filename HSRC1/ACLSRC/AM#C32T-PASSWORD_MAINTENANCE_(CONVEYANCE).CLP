             PGM        PARM(&P)
             /** AM#C31 ************************/
             /* CONVEYANCE                     */
             /*   ITS.             2015.06.04  */
             /**********************************/
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1PGM) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&P    ) TYPE(*CHAR) LEN(2)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
         /* CONVEYANCE                     */
             CHGVAR     VAR(&P1PGM) VALUE(&P)
             CALL       PGM(AM#R32) PARM(&P1PGM)

             ENDPGM
