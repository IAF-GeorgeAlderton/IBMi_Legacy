             PGM
             /** GDLC80 *************************************/
             /*  MATERIAL UNITV PRICE MUSTER UPDATE SYSTEM  */
             /*                       K.YASUDA  2000.08.30  */
             /************************************* GDLC80 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(GDLR80) PARM(&USER)

             ENDPGM
