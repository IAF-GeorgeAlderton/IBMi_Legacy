             PGM
             /** AAPC10 **************************************/
             /* PUBLICATION OF COMPLETION PART KANBAN(DAILY) */
             /*   I-HASADA                     97.05.02      */
             /************************************** AAPC10 **/
             DCLF       FILE(AAPPW10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AAPPW101)
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN05 *EQ '0') GOTO STP1

             CALL       PGM(AAPR10) PARM(&USER)

 END:        ENDPGM
