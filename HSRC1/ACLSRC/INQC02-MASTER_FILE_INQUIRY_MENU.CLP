             PGM
             /** INQC02 ************************************/
             /*  MASTER FILE INQUIRY MENU                  */
             /*  JW     2025.01.23                         */
             /**********************************************/
             DCLF       FILE(INQPW02)
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

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(END))
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(END))

  /** SELECT **/

             IF         COND(&SLCT *EQ '1') THEN(CALL PGM(INQC17))

             IF         COND(&SLCT *EQ '2') THEN(CALL PGM(GADR10B))

             IF         COND(&SLCT *EQ '3') THEN(CALL PGM(UAAC01))

             IF         COND(&SLCT *EQ '4') THEN(CALL PGM(EDIR72))

             IF         COND(&SLCT *EQ '5') THEN(CALL PGM(FCEC62))

             IF         COND(&SLCT *EQ '6') THEN(CALL PGM(INQR01A))

             IF         COND(&SLCT *EQ '7') THEN(CALL PGM(INQC05B))



             GOTO       CMDLBL(STRT)

 END:        ENDPGM
