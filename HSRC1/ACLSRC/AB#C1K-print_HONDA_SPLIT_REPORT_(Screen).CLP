             PGM
             /*** AB#C1K *********************************/
             /* PRINT HONDA SPLIT REPORT (SCREEN)        */
             /* JW (SRA)    2016.11.09                   */
             /********************************************/
             DCLF       FILE(AB#PW1K)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&QDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&TRUE )  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN  )  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)

       /*    set Printer to LANPRT03                           */
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(LANPRT03) +
                          HOLD(*YES) USRDTA('HND-SPLIT')

       /*    set DEFAULT DATE (TODAY)                         */
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CVTDAT     DATE(&QDATE) TOVAR(&XDATE) FROMFMT(*SYSVAL) +
                          TOFMT(*YYMD) TOSEP(*NONE)
@DSP00:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE('   ')
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

       /* CMD1: Exit  */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@CANCEL))

       /* CHECK DATE  */
             CALL       PGM(UTLC01) PARM(&XDATE &TRUE &RTN)
             IF         COND(&RTN *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Date is invalid!')
             GOTO @DSP00
             ENDDO

       /* CMD5: Start */
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP00))

             CHGVAR     VAR(&XDATE) VALUE(&TRUE)
             CALL       PGM(AB#C1K1) PARM(&XDATE)
             GOTO       CMDLBL(@EXIT)
@CANCEL:
             SNDPGMMSG  MSG('Job has been canceled without printing..')
@EXIT:
             ENDPGM
