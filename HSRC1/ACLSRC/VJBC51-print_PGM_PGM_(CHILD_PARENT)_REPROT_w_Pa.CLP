             PGM        PARM(&PGM &TYPE)
             /*** VJBC50 ****************************************/
             /* PRINT PGM-PGM (CHILD/PARENT) REPROT             */
             /* JW (SRA)    2016.04.06                          */
             /*********************************************++++**/
             DCLF       FILE(VJBPW50)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PGM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&XMSG)  VALUE(&PGM)
             CHGVAR     VAR(&XMSG)  VALUE(' ')
             CHGVAR     VAR(&XPGM)  VALUE(&PGM)
             IF         COND(&XTYPE *EQ ' ') THEN(DO)
             CHGVAR     VAR(&XTYPE) VALUE('2')
             ENDDO
@DSP00:
             CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             SNDRCVF    DEV(&WSID) RCDFMT(VJBPW501)
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
             CHGVAR     VAR(&IN85) VALUE('0')

       /* CMD1: Exit  */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@CANCEL))
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(@CANCEL))
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(@CANCEL))

CHK:    /* CHECK */
             IF         COND(&XPGM *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&IN85) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Enter Prpgram Name!')
             GOTO       @DSP00
             ENDDO

             IF         COND((&XTYPE *NE '1') *AND (&XTYPE *NE '2')) +
                          THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&IN85) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Enter 1 or 2 for Report +
                          Type!')
             GOTO       @DSP00
             ENDDO

RUN:   /* If No Error, RUN PROGRAM */

             OVRDBF     FILE(VVVPPB0) TOFILE(HFILE1/VVVPPB0)
             OVRDBF     FILE(VVVPLC2) TOFILE(HFILE1/VVVPLC2)
             OVRDBF     FILE(VVVPLC3) TOFILE(HFILE1/VVVPLC3)
             OVRDBF     FILE(VVVPLC4) TOFILE(HFILE1/VVVPLC4)
             OVRDBF     FILE(VVVPLC5) TOFILE(HFILE1/VVVPLC5)
             OVRDBF     FILE(VVVPLC6) TOFILE(HFILE1/VVVPLC6)
             OVRDBF     FILE(VVVPLC7) TOFILE(HFILE1/VVVPLC7)
             OVRDBF     FILE(VVVPLC8) TOFILE(HFILE1/VVVPLC8)
             OVRDBF     FILE(VVVPLC9) TOFILE(HFILE1/VVVPLC9)
             OVRDBF     FILE(VVVPLB0) TOFILE(HFILE1/VVVPLB0)
             OVRDBF     FILE(VVVPLB2) TOFILE(HFILE1/VVVPLB2)
             OVRDBF     FILE(VVVPLB3) TOFILE(HFILE1/VVVPLB3)
             OVRDBF     FILE(VVVPLB4) TOFILE(HFILE1/VVVPLB4)
             OVRDBF     FILE(VVVPLB5) TOFILE(HFILE1/VVVPLB5)
             OVRDBF     FILE(VVVPLB6) TOFILE(HFILE1/VVVPLB6)
             OVRDBF     FILE(VVVPLB7) TOFILE(HFILE1/VVVPLB7)
             OVRDBF     FILE(VVVPLB8) TOFILE(HFILE1/VVVPLB8)
             OVRDBF     FILE(VVVPLB9) TOFILE(HFILE1/VVVPLB9)
             OVRDBF     FILE(EGBPL13) TOFILE(HFILE1/EGBPL13)

             IF         COND(&XTYPE *EQ '1') THEN(DO)
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(LANPRT03) +
                          USRDTA('PGM-PGM1')
             CALL       PGM(VJBR50) PARM(&XPGM)
             ENDDO

             IF         COND(&XTYPE *EQ '2') THEN(DO)
             OVRPRTF    FILE(QPRINT) TOFILE(QPRINT) OUTQ(LANPRT03) +
                          HOLD(*YES) USRDTA('PGM-PGM2')
             CALL       PGM(VJBR51) PARM(&XPGM)
             ENDDO

SPL:   /* DISPLAY SPOOL FILE       */
             DSPSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST) CRTDATE(*LAST)
             CHGVAR     VAR(&XMSG) VALUE('Report has been printed. +
                          Enter next program.')
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             MONMSG MSGID(CPF0000)
             GOTO       @DSP00
@CANCEL:
             SNDPGMMSG  MSG('Job has been canceled..')
@EXIT:
             DLTOVR     FILE(*ALL)
             MONMSG MSGID(CPF0000)

             ENDPGM
