             PGM        PARM(&WORKER &WUSRID)
             /** AM#C21 ************************/
             /* LOADING                        */
             /*   LEC.             2018.09.19  */
             /**********************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WUSRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(AM#R21) PARM(&WORKER &WUSRID &PCMD)

             ENDPGM
