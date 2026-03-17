             PGM
             /*** AKICP1 *************************************/
             /* IAF COMPONENTS  TUNNEL KANBAN M/F UPDATE     */
             /*           S.YAMAGAMI 93.05.22                */
             /************************************* AKICP1 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AKIR03) PARM(&USER)

             ENDPGM
