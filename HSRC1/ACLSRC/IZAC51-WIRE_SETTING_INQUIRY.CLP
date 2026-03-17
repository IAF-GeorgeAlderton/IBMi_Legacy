             PGM
             /***IZAC51 ****************************************/
             /* WIRE SETTING INQUIRY                           */
             /*    ITS.                      2013.12.17        */
             /**************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1SUPP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:
             CALL       PGM(IZAR51) PARM(&P1SUPP &PCMD)
             IF         COND(&PCMD *EQ '03') THEN(GOTO CMDLBL(#END))

             CALL       PGM(IZAR53) PARM(&P1SUPP &PCMD)
             GOTO       CMDLBL(STP1)
 #END:
             ENDPGM
