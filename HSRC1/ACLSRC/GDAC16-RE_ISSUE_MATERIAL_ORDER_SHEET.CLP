             PGM
             /*** GDGA16 *****************************/
             /* RE-ISSUE MATERIAL ORDER SHEET        */
             /*                        2003/02/10    */
             /***************************** GDAC16 ***/
             DCLF       FILE(GDAPW16)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRNTR) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&PPUSER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&PODR1) VALUE('  ')
             CHGVAR     VAR(&PODR2) VALUE('  ')
             CHGVAR     VAR(&PODR3) VALUE('  ')
             CHGVAR     VAR(&D@PRT) VALUE('1')
 DSP1:       CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
 DSP2:       SNDRCVF    RCDFMT(DSP01)

             IF         (&IN01 = '1') GOTO END
             IF         (&PODR1 *EQ '  ') GOTO STP1
             IF         (&PODR2 *EQ '  ') GOTO STP1
             IF         (&PODR3 *EQ '  ') GOTO STP1

             IF         COND(&D@PRT *LT '1' *OR &D@PRT *GT '3') +
                          THEN(DO)
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('SELECT PRINTER')
             GOTO       DSP2

             ENDDO

             IF         (&IN05 = '0') GOTO DSP1
             IF         (&IN05 = '1') GOTO SKIP

 STP1:       CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('INPUT ODER#.')
             GOTO       DSP2

 SKIP:
             IF         COND(&D@PRT *EQ '1') THEN(CHGVAR VAR(&PRNTR) +
                          VALUE('LANPRT03'))
             IF         COND(&D@PRT *EQ '2') THEN(CHGVAR VAR(&PRNTR) +
                          VALUE('LANPRT02'))
             IF         COND(&D@PRT *EQ '3') THEN(CHGVAR VAR(&PRNTR) +
                          VALUE('LANPRT07'))
             OVRPRTF    FILE(GDLPR10) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(&PRNTR) +
                          FORMTYPE(K6S1)
             CALL       PGM(GDAR16) PARM(&PODR1 &PODR2 &PODR3)

             DLTOVR     FILE(*ALL)


 END:        ENDPGM
