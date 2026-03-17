             PGM
             /** ABNC01 ************************/
             /* KANBAN M/F INFO                */
             /*   SAKAKI.          2019.04.09  */
             /**********************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ABNR01)
             CALL       PGM(ABNR02)
             CALL       PGM(ABNR03)
             CALL       PGM(ABNR04)
             CALL       PGM(ABNR05)
             CALL       PGM(ABNR06)

             ENDPGM
