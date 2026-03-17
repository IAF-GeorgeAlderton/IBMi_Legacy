             PGM        PARM(&WORKER &WUSRID)
             /** AM#C21BR **********************/
             /* LOADING - Blowout Recovery     */
             /*   LEC.             2019.03.18  */
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

             CALL       PGM(AM#R21BR) PARM(&WORKER &WUSRID)

             ENDPGM
