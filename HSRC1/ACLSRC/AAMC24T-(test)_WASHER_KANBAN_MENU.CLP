             PGM
             /** AAMC24 ************************************/
             /* WASHER KANBAN MENU                              */
             /*                                            */
             /**********************************************/
             DCLF       FILE(AAMPW24)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

  STRT:
             CHGVAR     VAR(&SLCT) VALUE(' ')
             SNDRCVF    RCDFMT(DSP01)
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&SLCT *EQ '1') THEN(CALL PGM(AKCCP1T))

             IF         COND(&SLCT *EQ '2') THEN(CALL PGM(AKHCP1))

             IF         COND(&SLCT *EQ '3') THEN(CALL PGM(AKBCP1))

             IF         COND(&SLCT *EQ '4') THEN(CALL PGM(AKGCP1))

             IF         COND(&SLCT *EQ '5') THEN(CALL PGM(AKICP1))

             IF         COND(&SLCT *EQ '6') THEN(CALL PGM(AKBC11))


             GOTO       CMDLBL(STRT)

 END:        ENDPGM
