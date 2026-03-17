             PGM
             /** GDIC81 ************************/
             /*  PRINT  OF DIE LOCATION M/F    */
             /*   G.B.C             97/03/21   */
             /**********************************/
             DCLF       FILE(GDIPW81)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CHGVAR     VAR(&D#MSG) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&IN11) VALUE('0')

 DSP1:       CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')

             SNDRCVF    RCDFMT(DSP01)
             IF         (&IN01 = '1') GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&D1NO  *EQ 1) GOTO GO
             IF         (&D1NO  *EQ 2) GOTO GO

 ERR1:
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&D#MSG) VALUE('INCORRECT NUMBER.')
             GOTO       DSP1

 GO:
             IF         (&IN05  *EQ '0') GOTO DSP1

             IF         COND(&D1NO *EQ 1) THEN(DO)
             OVRPRTF    FILE(GDIPR81) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1)
             CALL       PGM(GDIR81) PARM(&USER)
             DLTOVR     FILE(*ALL)
             ENDDO

             IF         COND(&D1NO *EQ 2) THEN(DO)
             OVRPRTF    FILE(GDIPR82) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1)
             CALL       PGM(GDIR82) PARM(&USER)
             DLTOVR     FILE(*ALL)
             ENDDO

 END:        ENDPGM
