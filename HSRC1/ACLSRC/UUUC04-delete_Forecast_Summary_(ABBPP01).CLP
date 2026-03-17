             PGM
             /*** UUUC04 **************************************/
             /*   DELETE FORECAST SUMMARY (ABBPP01)           */
             /*   JW    2021.05.06                            */
             /*************************************************/
             DCLF       FILE(UUUPW04)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOKU)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN )   TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&XTOKU) VALUE(0)
             CHGVAR     VAR(&XNONY) VALUE(0)
             CHGVAR     VAR(&XNKOJ) VALUE('0')
             CHGVAR     VAR(&XNUKE) VALUE('00')
             CHGVAR     VAR(&XMHN1) VALUE(' ')
             CHGVAR     VAR(&XMHN2) VALUE(' ')
             CHGVAR     VAR(&XMHN3) VALUE(' ')
             CHGVAR     VAR(&XMHN4) VALUE(' ')
             CHGVAR     VAR(&XSBAN) VALUE(' ')
@DSP00:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE('   ')
             CHGVAR     VAR(&IN40) VALUE('0')
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')

       /* F1: END */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@EXIT))

       /* F12: END */
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(@EXIT))

       /* CHECK TOKU  */
             IF         COND(&XTOKU *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN40) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER CUSTOMER# !')
             GOTO @DSP00
             ENDDO

       /* CHECK NONY  */
             IF         COND(&XNONY *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER DELIVERY# !')
             GOTO @DSP00
             ENDDO

       /* CHECK USER PART */
             IF         COND(&XMHN1 *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER USER PART# !')
             GOTO @DSP00
             ENDDO

       /* F5: PROCESS */
             IF         COND(&IN05 *EQ '0') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('PRESS F5 TO DELETE..')
             GOTO @DSP00
             ENDDO

             CHGVAR     VAR(&TOKU ) VALUE(&XTOKU)
             CHGVAR     VAR(&NONY ) VALUE(&XNONY)
             CHGVAR     VAR(&RTN  ) VALUE(' ')
             CALL       PGM(UUUR04) PARM(&TOKU &NONY &XNKOJ &XNUKE &XMHN1 +
                          &XMHN2 &XMHN3 &XMHN4 &XSBAN &RTN)

       /* ERROR */
             IF         COND(&RTN  *EQ '1') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('RECORD NOT FOUND !!')
             GOTO @DSP00
             ENDDO

             IF         COND(&RTN  *EQ '2') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('FORECAST QTY ISNOT 0 !!')
             GOTO @DSP00
             ENDDO

             IF         COND(&RTN  *EQ ' ') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('DATA HAS BEEN DELETED +
                          SUCCESSFULY...')
             GOTO @DSP00
             ENDDO

@EXIT:
             ENDPGM
