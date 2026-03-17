             PGM
             /** AM#C37 ************************/
             /*  PASSWORD MAINTENANCE (WIRE)   */
             /*  JW       2020.07.07           */
             /**********************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1PGM) TYPE(*DEC) LEN(2 0)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

         /*  PASSWORD   */
             CHGVAR     VAR(&P1PGM) VALUE(7)
             CALL       PGM(AM#R31) PARM(&P1PGM)

             ENDPGM
