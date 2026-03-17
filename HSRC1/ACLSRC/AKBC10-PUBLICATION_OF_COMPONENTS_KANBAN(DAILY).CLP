             PGM
             /** AKBC10 *********************************/
             /* PUBLICATION OF COMPONENTS KANBAN(DAILY) */
             /*   I-HASADA                97.05.02      */
             /********************************* AKBC10 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(AKBR10) PARM(&USER)

             ENDPGM
