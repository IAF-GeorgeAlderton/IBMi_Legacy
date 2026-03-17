             PGM
             /*** MCHC14 ******************************************/
             /* FACILITY ABILITY INQUIRY                   */
             /*            M-OKUDA        1985.05.10              */
             /*****************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7) VALUE(QPRINT )
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BYYMM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BKADO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BNAJ1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BNAJ2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BNAJ3) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MCHDTA) TYPE(*CHAR) LEN(27)
             RTVDTAARA  DTAARA(MCHDTA) RTNVAR(&MCHDTA)

             CHGVAR     VAR(&BYYMM) VALUE(%SUBSTRING(&MCHDTA 1 6))
             CHGVAR     VAR(&BKADO) VALUE(%SUBSTRING(&MCHDTA 7 2))
             CHGVAR     VAR(&BNAJ1) VALUE(%SUBSTRING(&MCHDTA 9 6))
             CHGVAR     VAR(&BNAJ2) VALUE(%SUBSTRING(&MCHDTA 15 6))
             CHGVAR     VAR(&BNAJ3) VALUE(%SUBSTRING(&MCHDTA 21 6))

             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(MCHR14) PARM(&BYYMM &BNAJ1 &BNAJ2 &BNAJ3 +
                          &BKADO)

             ENDPGM
