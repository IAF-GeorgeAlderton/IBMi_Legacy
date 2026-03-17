             PGM
             /*** UUUC01 **************************************/
             /*   CLEAR FORECAST SUMMARY (ABAWL10=ABAWP10)    */
             /*   JW    2021.02.04                            */
             /*************************************************/
             DCLF       FILE(UUUPW01)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&NONY)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&DATE)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&QTY )   TYPE(*CHAR) LEN(9)
             DCL        VAR(&RTN )   TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&XNONY) VALUE(0)
             CHGVAR     VAR(&XNKOJ) VALUE('0')
             CHGVAR     VAR(&XNUKE) VALUE('00')
             CHGVAR     VAR(&XMHN1) VALUE(' ')
             CHGVAR     VAR(&XMHN2) VALUE(' ')
             CHGVAR     VAR(&XMHN3) VALUE(' ')
             CHGVAR     VAR(&XMHN4) VALUE(' ')
             CHGVAR     VAR(&XDATE) VALUE(202101)
             CHGVAR     VAR(&XQTY ) VALUE(0)
@DSP00:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE('   ')
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
             CHGVAR     VAR(&IN43) VALUE('0')
             CHGVAR     VAR(&IN44) VALUE('0')

       /* F1: END */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@EXIT))

       /* F12: END */
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(@EXIT))

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

       /* CHECK DATE      */
             IF         COND(&XDATE *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN43) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER SCHEDULE DATE !')
             GOTO @DSP00
             ENDDO

       /* CHECK QTY  */
             IF         COND(&XQTY *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN44) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER TOTAL QTY !')
             GOTO @DSP00
             ENDDO

       /* F5: PROCESS */
             IF         COND(&IN05 *EQ '0') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('PRESS F5 TO CLEAR...')
             GOTO @DSP00
             ENDDO

             CHGVAR     VAR(&NONY ) VALUE(&XNONY)
             CHGVAR     VAR(&DATE ) VALUE(&XDATE)
             CHGVAR     VAR(&QTY  ) VALUE(&XQTY)
             CHGVAR     VAR(&RTN  ) VALUE(' ')
             CALL       PGM(UUUR01) PARM(&NONY &NKOJ &NUKE &XMHN1 +
                          &XMHN2 &XMHN3 &XMHN4 &DATE &QTY &RTN)

       /* ERROR */
             IF         COND(&RTN  *EQ '*') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('PROCESS ENDED WITH ERROR !!')
             GOTO @DSP00
             ENDDO
             IF         COND(&RTN  *EQ ' ') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('DATA WAS CLEARED...')
             GOTO @DSP00
             ENDDO

@EXIT:
             ENDPGM
