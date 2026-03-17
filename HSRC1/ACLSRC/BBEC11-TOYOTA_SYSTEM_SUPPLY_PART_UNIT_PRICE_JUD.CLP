             PGM
             /** BBEC11 ****************************************/
             /* TOYOTA SYSTEM SUPPLY PART UNIT PRICE JUDGMENT USER M/F UPDATE */
             /*         KOHHY.            90.04.20             */
             /**************************************** BBEC11 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       CHGJOB     OUTQ(&PRTG)
             CALL       PGM(BBER11) PARM(&USER)

 END:        ENDPGM
