             PGM
             /*** BTAC04 ******************************************/
             /*つるべ生産指示A-PICS PLAN PUBLICATION MANAGEMENT */
             /*                SYSTEM            INPUT FOR MINUS  */
             /*   2020.07.20                                      */
             /*****************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(BTAR90)

             ENDPGM
