             PGM
             /** ADAC61 ************************************/
             /*INQUIRY  UPDATE UNWORKING NIGHT ATTENDANCE*/
             /*          M S K          1986.12.08         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(5) VALUE('     ')
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(5) VALUE('     ')
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(2) VALUE('  ')
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PARM6) TYPE(*CHAR) LEN(8) +
                          VALUE('        ')
             DCL        VAR(&PARM7) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&HD) TYPE(*CHAR) LEN(2)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CHGVAR     VAR(&PARM7) VALUE('*')

 STEP03:     CALL       PGM(ADAR61) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5 &PARM6 &PARM7)

             IF         COND(&PARM1 *EQ 'X') THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&PARM7) VALUE('*')

             IF         COND(&PARM1 *EQ '1') THEN(DO)
             CALL       PGM(ADAR62) PARM(&PARM2 &PARM3 &PARM4 &PARM5 +
                          &PARM6)
             GOTO       CMDLBL(STEP03)
             ENDDO

             IF         COND(&PARM1 *EQ '2') THEN(DO)
             CALL       PGM(ADAR63) PARM(&PARM2 &PARM3 &PARM4 &PARM5 +
                          &PARM6)
             GOTO       CMDLBL(STEP03)
             ENDDO

             IF         COND(&PARM1 *EQ '3') THEN(DO)
             CALL       PGM(ADAR64) PARM(&PARM2 &PARM3 &PARM4 &PARM5 +
                          &PARM6)
             GOTO       CMDLBL(STEP03)
             ENDDO

             IF         COND(&PARM1 *EQ '4') THEN(DO)
             CALL       PGM(ADAR65) PARM(&PARM2 &PARM3 &PARM4 &PARM5 +
                          &PARM6)
             GOTO       CMDLBL(STEP03)
             ENDDO

             IF         COND(&PARM1 *EQ '5') THEN(DO)
             CALL       PGM(ADAR66) PARM(&PARM2 &PARM3 &PARM4 &PARM5 +
                          &PARM6)
             GOTO       CMDLBL(STEP03)
             ENDDO

             IF         COND(&PARM1 *EQ '6') THEN(DO)
             CALL       PGM(ADAR67) PARM(&PARM2 &PARM3 &PARM4 &PARM5 +
                          &PARM6)
             GOTO       CMDLBL(STEP03)
             ENDDO

             IF         COND(&PARM1 *EQ '7') THEN(DO)
             CALL       PGM(ADAR68) PARM(&PARM2 &PARM3 &PARM4 &PARM5 +
                          &PARM6)
             GOTO       CMDLBL(STEP03)
             ENDDO

 END:        ENDPGM
