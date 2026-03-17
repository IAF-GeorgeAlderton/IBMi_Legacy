             PGM
             /** GAEC11 ************************************/
             /* QUENCHING PRODUCTION INFORMATION MANAGEMENT SYSTEM  */
             /* M S K                             87.05.12 */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JIKAN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HITSK) TYPE(*CHAR) LEN(6)
             DCLF       FILE(GAEPW11) RCDFMT(GAEPW111)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     RUNPTY(40)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

 STEP02:     CHGJOB     OUTQ(&PRTG)

 MO:         RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&JIKAN)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&HITSK)

             CHGVAR     VAR(&CO) VALUE(':')
             CHGVAR     VAR(&@TIME) VALUE(%SST(&JIKAN 1 2) *CAT &CO +
                          *CAT %SST(&JIKAN 3 2) *CAT &CO *CAT +
                          %SST(&JIKAN 5 2))
             CHGVAR     VAR(&@DATE) VALUE(%SST(&HITSK 1 2) *CAT &CO +
                          *CAT %SST(&HITSK 3 2) *CAT &CO *CAT +
                          %SST(&HITSK 5 2))

             SNDRCVF    RCDFMT(GAEPW111)
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN10) VALUE('0')

             IF         COND(&@BANGO *EQ '1') THEN(DO)
             CHGVAR     VAR(&PARM1) VALUE(' ')
             CLRPFM     FILE(GAEWP01)

 SAIDO:      CALL       PGM(GAER12) PARM(&PARM1)

             IF         COND(&PARM1 *EQ 'O') THEN(DO)
             CHGVAR     VAR(&@BANGO) VALUE(' ')
             GOTO       CMDLBL(MO)
             ENDDO

             IF         COND(&PARM1 *EQ 'M') THEN(DO)
             CHGVAR     VAR(&PARM1) VALUE(' ')
            /* CLRPFM GAEWP01 */
             GOTO       CMDLBL(SAIDO)
             ENDDO

             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&@BANGO *EQ '2') THEN(DO)
             CHGVAR     VAR(&PARM1) VALUE(' ')
             CALL       PGM(GAEC16) PARM(&PARM1)

             IF         COND(&PARM1 *EQ 'M') THEN(DO)
             CHGVAR     VAR(&@BANGO) VALUE(' ')
             GOTO       CMDLBL(MO)
             ENDDO

             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(&@BANGO *EQ '3') THEN(DO)
             CHGVAR     VAR(&PARM1) VALUE(' ')
             CALL       PGM(GAEC18) PARM(&PARM1)

             IF         COND(&PARM1 *EQ 'M') THEN(DO)
             CHGVAR     VAR(&@BANGO) VALUE(' ')
             GOTO       CMDLBL(MO)
             ENDDO

             GOTO       CMDLBL(END)
             ENDDO

             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('WORK INSTRUCTION IS DIFFERENCE.')
             GOTO       CMDLBL(MO)

 END:        CHGJOB     OUTQ(&PRT)
             CHGJOB     RUNPTY(20)

             ENDPGM
