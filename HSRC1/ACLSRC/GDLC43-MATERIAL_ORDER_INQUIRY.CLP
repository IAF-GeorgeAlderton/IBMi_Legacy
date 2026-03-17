             PGM
             /** GDLC43 ***********************/
             /*  MATERIAL ORDER INQUIRY       */
             /*                               */
             /*********************** GDLC40 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(GDLR43)

             ENDPGM
