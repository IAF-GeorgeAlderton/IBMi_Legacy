             PGM
             /** GDLC55 ******************************/
             /*  MATERIAL STOCK MASTER AMEND SYSTEM  */
             /*                K.YASUDA  2000.11.28  */
             /****************************** GDLC55 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(GDLR55) PARM(&USER)

             ENDPGM
