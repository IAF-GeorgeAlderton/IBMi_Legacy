             PGM
             /** BBCC01 ****************************************/
             /* UPDATE VOLUME PRODUCTION UNIT PRICE M/F BESIDES TOYOTA SYSTEM */
             /*         KOHHY             90.04.13             */
             /**************************************** BBCC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       CHGJOB     OUTQ(&PRTG)
             CALL       PGM(BBCR01) PARM(&USER)

 END:        ENDPGM
