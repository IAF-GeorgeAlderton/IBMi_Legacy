             PGM
             /*** ABHC30 ***************************************/
             /* INTRA-PROCESS KANBAN ISSUE LOG FILE            */
             /*         KIRI                2018.08.03         */
             /*************************************** ABHC01 ***/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

 STP1:

             CALL       PGM(ABHR30)

             ENDPGM
