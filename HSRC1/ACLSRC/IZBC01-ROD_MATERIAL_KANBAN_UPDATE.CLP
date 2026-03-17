             PGM
             /***IZBC01 ****************************************/
             /* ROD  MATERIAL KANBAN UPDATE                    */
             /*  MSK KUNIEDA                 2000.08.22        */
             /*************************************** IZBC01 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(IZBR01) PARM(&USER)

             ENDPGM
