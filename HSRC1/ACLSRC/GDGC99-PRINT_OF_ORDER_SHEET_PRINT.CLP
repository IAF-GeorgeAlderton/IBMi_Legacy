             PGM
             /*** GDGC16 *****************************/
             /*  PRINT OF ORDER SHEET       / PRINT  */
             /*    K.YASUDA            2000/03/23    */
             /*  SELECT PRINTER                      */
             /*    03/24/2004                        */
             /***************************** GDGC16 ***/
             DCLF       FILE(GDGPW16)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SYSNAME) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRNTR) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&PPUSER)
             RTVNETA    SYSNAME(&SYSNAME)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)

             CHGVAR     VAR(&PODR1) VALUE('  ')
             CHGVAR     VAR(&PODR2) VALUE('  ')
             CHGVAR     VAR(&PODR3) VALUE('  ')
             CHGVAR     VAR(&D@PRT) VALUE('1')
             CALL       PGM(GDGR1A) PARM(&PODR1 &PODR2 &PODR3)
 DSP1:       CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
 DSP2:       SNDRCVF    RCDFMT(GDGPW161)

             IF         (&IN01 = '1') GOTO END
             IF         (&PODR1 *EQ '  ') GOTO STP1
             IF         (&PODR2 *EQ '  ') GOTO STP1
             IF         (&PODR3 *EQ '  ') GOTO STP1

             IF         COND(&D@PRT *LT '1' *OR &D@PRT *GT '3') +
                          THEN(DO)
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('SELECT PRINTER.')
             GOTO       DSP2
             ENDDO

             IF         COND(&D@PRT *EQ '1') THEN(CHGVAR VAR(&PRNTR) +
                          VALUE('LANPRT03'))
             IF         COND(&D@PRT *EQ '2') THEN(CHGVAR VAR(&PRNTR) +
                          VALUE('LANPRT02'))
             IF         COND(&D@PRT *EQ '3') THEN(CHGVAR VAR(&PRNTR) +
                          VALUE('LANPRT07'))

             IF         (&IN05 = '0') GOTO DSP1
             IF         (&IN05 = '1') GOTO SKIP

 STP1:       CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('INPUT ODER#.')
             GOTO       DSP2

 SKIP:       OVRPRTF    FILE(GDGPR13) DEVTYPE(*SCS) PAGESIZE(66 80) +
                          LPI(6) OVRFLW(58) RPLUNPRT(*YES) +
                          OUTQ(&PRNTR) FORMTYPE(K6S1)

             DLTF       FILE(&WLIB/GDGWPE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDGWPE1) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(GDGR16) PARM(&PODR1 &PODR2 &PODR3 &SYSNAME)

             OVRPRTF    FILE(GDIPR13) DEVTYPE(*SCS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(58) RPLUNPRT(*YES) +
                          OUTQ(&PRNTR) FORMTYPE(K6S1)

             DLTF       FILE(&WLIB/GDGWPE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDGWPE2) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(GDIR16) PARM(&PODR1 &PODR2 &PODR3 &SYSNAME)
             DLTOVR     FILE(*ALL)


 END:        ENDPGM
