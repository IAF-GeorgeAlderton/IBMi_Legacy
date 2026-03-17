             PGM

             DCLF       FILE(AM#PW40  )
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRUE) TYPE(*CHAR) LEN(8 )
             DCL        VAR(&RTN2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNT ) TYPE(*CHAR) LEN(4 )

             RTVJOBA    JOB(&WSID)

             CHGVAR     VAR(&PRTR ) VALUE('EPRINT1')

/* GET DEFAULT DATE */
             CHGVAR     VAR(&SRC  ) VALUE(' ')
             CALL       PGM(UTLR01) PARM(&SRC &TRUE &RTN)
             CHGVAR     VAR(&XFROM) VALUE(&TRUE)
             CHGVAR     VAR(&XTO  ) VALUE(&TRUE)

  STP1:      SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE(' ')
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')

/* END */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

/*  CHECK XFROM   */
             IF         COND(&XFROM *EQ ' ') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('ENTER DATE FROM !')
             CHGVAR     VAR(&IN41) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&SRC ) VALUE(&XFROM)
             CALL       PGM(UTLR01) PARM(&SRC &TRUE &RTN)
             IF         COND(&RTN *NE ' ') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('DATE FROM IS INVALID !')
             CHGVAR     VAR(&IN41) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO
             CHGVAR     VAR(&XFROM) VALUE(&TRUE)

/*  CHECK XTO     */
             IF         COND(&XTO *EQ ' ') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('ENTER DATE TO !')
             CHGVAR     VAR(&IN42) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&SRC ) VALUE(&XTO  )
             CALL       PGM(UTLR01) PARM(&SRC &TRUE &RTN)
             IF         COND(&RTN *NE ' ') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('DATE TO IS INVALID !')
             CHGVAR     VAR(&IN42) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO
             CHGVAR     VAR(&XTO  ) VALUE(&TRUE)

/*  CHECK XFROM <= XTO   */
             IF         COND(&XFROM *GT &XTO) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('FROM DATE IS GREATER THAN TO !')
             CHGVAR     VAR(&IN41) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

/*  IF NO EEROR   */
             IF         COND((&IN05 *EQ '0') *AND (&IN10 *EQ '0')) +
                          THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('PRESS F5 TO PRINT ...')
             GOTO       CMDLBL(STP1)
             ENDDO

/*  SELECT PRINTER */
             IF         COND(&IN05 *EQ '1') THEN(DO)
             CALL       PGM(UTLR69) PARM(&PRTR &RTN2)
             IF         COND(&PRTR *EQ ' ') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('PRINTER ERROR !')
             GOTO       CMDLBL(STP1)
             ENDDO
             ENDDO

/*  PRINT */
             OVRPRTF    FILE(QPRINT) OUTQ(&PRTR)
             CALL       PGM(AM#R40) PARM(&XFROM &XTO &CNT &RTN2)

/*  IF NO DATA  */
             IF         COND(&RTN2 *EQ '*') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('THERE IS NO DATA !')
             GOTO       CMDLBL(STP1)
             ENDDO

/*  IF F10: COUNT */
             IF         COND(&IN10 *EQ '1') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('XXXX RECORDS ARE MISSING !')
             CHGVAR     VAR(%SUBSTRING(&XMSG 1 4)) VALUE(&CNT)
             GOTO       CMDLBL(STP1)
             ENDDO


 END:        ENDPGM
