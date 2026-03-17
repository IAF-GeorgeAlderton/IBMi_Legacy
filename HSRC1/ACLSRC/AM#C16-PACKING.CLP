             PGM        PARM(&WORKER &WUSRID)
             /** AM#C16 ************************/
             /* PACKING - SUPP & EXPORTS       */
             /*   LEC.             2018.11.29  */
             /**********************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WUSRID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(AM#R16) PARM(&WORKER &WUSRID)

 END:
             ENDPGM
