             PGM
             /** AB#CFA *******************************************************/
             /*  FORD PICK-UP LIST (PALLETIZE LIST FREEZED)                   */
             /*                                                               */
             /*  N-HYOTO 2001.05.11                                           */
             /*  H-AMANO 2003.08.21 ADD QTY/CONT. CHECK                       */
             /*  H-AMANO 2003.12.11 ADD PRINT OPTION                          */
             /*  TCH     12/12/20   ADD PR NT OPTION                          */
             /*  TCHK1   12/24/05   ADD PRINT OPTION                          */
             /*  TCHK2   05/17/07   ADD &KOTAE='g'                            */
             /*  TCHK3   02/26/10   RMV LANPRT07 , CHG DEFAULT PRINTER        */
             /*  T.SAKAKI  07/01/18 ADD NEW COMMON LAYOUT  %0001              */
             /*  J.WATANABE    JW1   07/12/18 CHG MESSAGE                     */
             /******************************************************* AB#CFA **/
             DCLF       FILE(AB#PWFA)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPICK) TYPE(*DEC) LEN(2)
             DCL        VAR(&PCUST) TYPE(*DEC) LEN(2)
             DCL        VAR(&TRAN)   TYPE(*CHAR) LEN(30)
             DCL        VAR(&CTYP)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDOCK)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PMANI)  TYPE(*CHAR) LEN(11)
             DCL        VAR(&WNOHZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WREDT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PPS#) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&QCK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT)  TYPE(*CHAR) LEN(10)
 /*%0001*/   DCL        VAR(&ORGOUT)  TYPE(*CHAR) LEN(10)
 /*%0001*/   DCL        VAR(&PLTP) TYPE(*CHAR) LEN(1) VALUE(' ')

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&US &WLIB)


             CHGVAR     VAR(&PSIRE) VALUE('    ')
             CHGVAR     VAR(&PSIRK) VALUE('0')
             CHGVAR     VAR(&PNOHZ) VALUE(0)
             CHGVAR     VAR(&PNOBI) VALUE(0)
             CHGVAR     VAR(&PDOCK) VALUE('    ')
             CHGVAR     VAR(&PREDT) VALUE(0)

             CHGVAR     VAR(&D@P1) VALUE(Y)
             CHGVAR     VAR(&D@P2) VALUE(Y)
             CHGVAR     VAR(&D@CHG) VALUE(Y)
/* TCHK3 */  CHGVAR     VAR(&D@PRT) VALUE(6)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PWF41)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
             CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&PSIRE *EQ '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO

             IF         (&PSIRK *EQ ' ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. SUPPLIER')
             GOTO       STP1
             ENDDO

             CHGVAR     VAR(&WNOHZ) VALUE(&PNOHZ)
             IF         (%SUBSTRING(&WNOHZ 1 4) *LT '2000') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 5 2) *GT '12') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 5 2) *LT '01') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 7 2) *GT '31') GOTO STP2
             IF         (%SUBSTRING(&WNOHZ 7 2) *LT '01') GOTO STP2
             GOTO       STP3

 STP2:       CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1

 STP3:       IF         (&PNOBI *EQ 0) DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. BIN')
             GOTO       STP1
             ENDDO
 /* TCH */
 STP7:
/* TCHK3 */  IF         COND((&D@PRT *NE '1') *AND +
                             (&D@PRT *NE '3') *AND +
                             (&D@PRT *NE '4') *AND +
                             (&D@PRT *NE '5') *AND +
                             (&D@PRT *NE '6') *AND +
                             (&D@PRT *NE '7') *AND +
                             (&D@PRT *NE '8') *AND +
                             (&D@PRT *NE '9') *AND +
                             (&D@PRT *NE 'X')) +
             THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PRINTER OPTION NOT CORRECT')
             GOTO       STP1
             ENDDO
             IF         COND(&D@PRT *EQ '1') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT02))
/* TCHK3     IF         COND(&D@PRT *EQ '2') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT07)) */
             IF         COND(&D@PRT *EQ '3') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT08))
             IF         COND(&D@PRT *EQ '4') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT03))
             IF         COND(&D@PRT *EQ '5') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QPRINTA))
             IF         COND(&D@PRT *EQ '6') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT09))
/* TCHK1 */  IF         COND(&D@PRT *EQ '7') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT10))
/* TCHK1 */  IF         COND(&D@PRT *EQ '8') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT05))
/* TCHK1 */  IF         COND(&D@PRT *EQ '9') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QDKT))
/* JW1   */  IF         COND(&D@PRT *EQ 'X') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QDKT))

             CHGVAR     VAR(&WREDT) VALUE(&PREDT)
             IF         (%SUBSTRING(&WREDT 1 4) *LT '2000') GOTO STP4
             IF         (%SUBSTRING(&WREDT 5 2) *GT '12') GOTO STP4
             IF         (%SUBSTRING(&WREDT 5 2) *LT '01') GOTO STP4
             IF         (%SUBSTRING(&WREDT 7 2) *GT '31') GOTO STP4
             IF         (%SUBSTRING(&WREDT 7 2) *LT '01') GOTO STP4
             GOTO       STP5

 STP4:       CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1
 STP5:
   /* QTY/CONT CHECK */
             CALL       PGM(ABFR03) PARM(&PSIRE &PDOCK &PNOHZ &PNOBI +
                          &PREDT &QCK)
             IF         COND(&QCK *EQ '9') THEN(GOTO CMDLBL(END))


             IF         (&IN05 *EQ '0') GOTO STP1

             CHGJOB     SWS(00000000)

 SKIP1:    /* INPUT SCREEN */
             CALL       PGM(AB#RFA) PARM(&PSIRE &PSIRK &PDOCK &PNOHZ +
                          &PNOBI &PREDT)

             DLTF       FILE(AB#WPF0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WPF0) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP30) TOFILE(&WLIB/AB#WPF0)

/* CREATE W/F */
/* AB#PP10 -> AB#WP30 */
             CALL       PGM(AB#R3H) PARM(&PSIRE &PSIRK &PNOHZ &PREDT +
                          &PNOBI &PDOCK &PMANI)

             IF         (%SWITCH(0XXXXXXX)) DO

 STP6: /*JW1 SNDPGMMSG  MSG('( G ) SINCE THERE IS NO DATA INPUT. +     */
          /*              LIST OUTPUT CANNOT BE MADE  < G-ENTER >') +  */
          /*              TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)    */
          /* RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +       */
          /*              MSG(&KOTAE)                                  */
          /* IF         COND((&KOTAE = 'G') *OR (&KOTAE = '') +        */
          /*                *OR (&KOTAE = 'g')  +                      */
          /*                *OR (&KOTAE = '')) +                       */
          /*              THEN(GOTO CMDLBL(END))                       */
          /* GOTO       STP6                                           */

             CALL       PGM(QUILNGTX) PARM('There is no data to +
                          print. The program will be cancelled...' +
                          X'00000046' ' ' ' ' X'00000000')
             GOTO       CMDLBL(END)

             ENDDO

             IF         COND(&D@P1 *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&PTYPE) VALUE('01')
/* CHECK LIST TYPE */
             CALL       PGM(AB#R91) PARM(&PSIRE &PTYPE &PPICK &PCUST +
                          &TRAN &CTYP &PCNAM)

             DLTF       FILE(AB#WPFB)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WPFB) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((&WLIB/AB#WPF0)) +
                          OUTFILE(&WLIB/AB#WPFB) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S4F) +
                          OPTION(*NOPRT)

/* PICK-UP LIST */
    /* %0001 */
             CRTDUPOBJ  OBJ(AB#WP37) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP37
             OVRDBF     FILE(AB#WP37) TOFILE(QTEMP/AB#WP37)
             OVRDBF     FILE(AB#WP31) TOFILE(&WLIB/AB#WPFB)

             IF         COND(&PPICK *EQ 0) THEN(CHGVAR VAR(&PPICK) +
                          VALUE(1))

 /* %0001 SAVE ORIGINAL OUTQ */
             CHGVAR VAR(&ORGOUT) VALUE(&POUT)

 /* CHECK LIST TYPE SWITCHING MASTER */
             CALL       PGM(AB#R9S) PARM(&PSIRE &PLTP)

    /* NOT PRINT IF ONLY NEW LAYOUT */
             IF         COND(&PLTP *EQ 'N') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QDKT))

             OVRPRTF    FILE(AB#PR3I) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)
             CALL       PGM(AB#R3I) PARM(&PSIRE &PREDT &PPS# &PMANI +
                          &D@SHDT)

    /* %0001 */
    /* NOT PRINT IF ONLY OLD LAYOUT */
             IF         COND(&PLTP *EQ 'O') THEN(GOTO CMDLBL(SKIP2))

    /* NEW PACKING LIST */
             CHGVAR     VAR(&POUT) VALUE(&ORGOUT)
    /* NEW PACKING LIST */
             OVRPRTF    FILE(AB#PR3K) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)
             CALL       PGM(AB#R30)

/* SAVE AB#WP37 */
             CALL       PGM(EDSR03)
             CLRPFM     FILE(QTEMP/AB#WP37)
 SKIP2:

             ENDDO

/* MIXED PALLET SHEET */
             IF         COND(&D@P2 *EQ 'Y') THEN(DO)
/* CHANGED ONLY */
             IF         COND(&D@CHG *EQ 'N') THEN(DO)
             CALL       PGM(AB#RG3) PARM(&PSIRE &PDOCK &PNOHZ &PNOBI +
                          &PREDT)
             ENDDO

             OVRPRTF    FILE(AB#PRF8) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&POUT)    +
                          FORMTYPE(K6S1) COPIES(1)
             CALL       PGM(AB#RF8) PARM(&PSIRE &PDOCK &PNOHZ &PNOBI +
                          &PREDT &PPS# &PMANI)

             ENDDO

             DLTOVR     FILE(*ALL)

 END:        ENDPGM
