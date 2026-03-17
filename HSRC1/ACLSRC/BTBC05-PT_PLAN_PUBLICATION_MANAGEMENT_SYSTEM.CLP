             PGM
             /*** BTBC05 ******************************/
             /* PT PLAN PUBLICATION MANAGEMENT SYSTEM */
             /*          A-MAMIYA   2000.11.25        */
             /******************************* BTBC05 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(BTBR05) PARM(&USER)

             ENDPGM
