             PGM        PARM(&WORKER &WUSRID)
             /** AM#C04 ************************/
             /* PACKING                        */
             /*   ITS.             2015.06.01  */
             /**********************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WUSRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1PPUL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P9TICK) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(AM#R04) PARM(&WORKER &WUSRID &PCMD)

 END:
             ENDPGM
