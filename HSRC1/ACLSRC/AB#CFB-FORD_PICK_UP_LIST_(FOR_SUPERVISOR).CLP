  PGM
/** AB#CFB *******************************************************/
/*  FORD PICK-UP LIST                                            */
/*  N-HYOTO       2000.02.01                                     */
/*  G.ALKHUTOVA   2000.03.03 CHANGE PRINT SIZE                   */
/*  N-HYOTO       2000.05.08 CLEAR FIELD AFTER 1PROCESS          */
/*  N-HYOTO       2000.06.15 ADD DOCK TO AB#R3H                  */
/*  N-HYOTO       2000.20.28 NIRVANA                             */
/*  K-KASHIWAGI   2001.03.15 ADD PARAMETER COUNTRY NAME          */
/*  N-HYOTO       2001.04.19 OMIT AFPDS                          */
/*  H-AMANO       2002.03.26 CHECK 2ND TRIAL OR NOT.             */
/*  H-AMANO       2003.08.21 CHECK QTY/BOX CHECK.                */
/*  TCHK1         2005.12.24 CHG SCREEN                          */
/*  TCHK2         2007.05.17 ADD &KOTAE='g'                      */
/*  T.SAKAKI      2018.07.01 ADD NEW COMMON LAYOUT  %0001        */
/******************************************************* AB#CFB **/
/* TCHK1 */  DCLF       FILE(AB#PWFB)
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
             DCL        VAR(&PSIREX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TRAN)   TYPE(*CHAR) LEN(30)
             DCL        VAR(&CTYP)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDOCK)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PMANI)  TYPE(*CHAR) LEN(11)
             DCL        VAR(&WNOHZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WREDT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PPS#) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PEND)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDOCKX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNONN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QCK) TYPE(*CHAR) LEN(1)
 /*%0001*/   DCL        VAR(&POUT)  TYPE(*CHAR) LEN(10)
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
             CHGVAR     VAR(&D@CHG) VALUE('Y')
             CHGVAR     VAR(&D@PRT) VALUE(1)     /* TCHK1 */

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PWFB1)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
             CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&PFLAG *EQ ' ') DO
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
/* CHECK ALREADY PRINTED */
             IF         COND(&SND *EQ '1' *AND &PNONN *NE &PSIRE) +
                          THEN(CHGVAR VAR(&SND) VALUE(' '))

             IF         COND(&SND *EQ ' ') THEN(DO)
             CHGVAR     VAR(&PNONY) VALUE(&PSIRE)
             CHGVAR     VAR(&PNONN) VALUE(&PSIRE)
             CALL       PGM(ABFR02) PARM(&PNONY &PDOCK &PNOHZ &PNOBI +
                          &PREDT &PFLG)
             IF         COND(&PFLG *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE(&PNONY *CAT ': ISSUED +
                          ALREADY. TO RE-CREATE, HIT F5.')
             CHGVAR     VAR(&SND) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1
             ENDDO
             ENDDO

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
             CALL       PGM(ABFR03) PARM(&PNONY &PDOCK &PNOHZ &PNOBI +
                          &PREDT &QCK)
             IF         COND(&QCK *EQ '9') THEN(GOTO CMDLBL(END))

             IF         (&IN05 *EQ '0') GOTO STP1

             IF         (&PFLAG  *EQ ' ') DO
             GOTO SKIP1
             ENDDO

             IF         (&PFLAG  *EQ '1') DO
             CHGVAR     VAR(&PSIREX) VALUE('0000')
             CHGVAR     VAR(&PDOCKX) VALUE('    ')
             CHGVAR     VAR(&PEND)   VALUE(' ')
             ENDDO
 LOOP:
             CHGJOB     SWS(00000000)

             CALL       PGM(AB#RFK) PARM(&PSIREX &PDOCKX &PEND &PFLAG)
             CHGVAR     VAR(&PSIRE)  VALUE(&PSIREX)
             CHGVAR     VAR(&PDOCK)  VALUE(&PDOCKX)
             CHGVAR     VAR(&PSIRK) VALUE('0')

             IF         (&PEND   *EQ '1') DO
             GOTO END
             ENDDO

 SKIP1:

             DLTF       FILE(AB#WPF0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WPF0) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP30) TOFILE(&WLIB/AB#WPF0)

             CALL       PGM(AB#R3H) PARM(&PSIRE &PSIRK &PNOHZ &PREDT +
                          &PNOBI &PDOCK &PMANI)

             IF         (%SWITCH(0XXXXXXX)) DO

             IF         (&PFLAG  *EQ '1') DO
             GOTO LOOP
             ENDDO

 STP6:       SNDPGMMSG  MSG('( G ) SINCE THERE IS NO DATA INPUT. +
                          LIST OUTPUT CANNOT BE MADE  < G-ENTER >') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = '') +
                            *OR (&KOTAE = 'g')  +
                            *OR (&KOTAE = '')) +
                          THEN(GOTO CMDLBL(END))          /**GA**/
             GOTO       STP6
             ENDDO

             CHGVAR     VAR(&PTYPE) VALUE('01')
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

             OVRDBF     FILE(AB#WP4B) TOFILE(&WLIB/AB#WPFB)

             CALL       PGM(AB#RF6) PARM(&US &PSIRE &PNOHZ +
                          &PNOBI &PMANI &PREDT &PDOCK &PPS#)

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
             CHGVAR     VAR(&POUT) VALUE('LANPRT02  ')
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
             CLRPFM     FILE(QTEMP/AB#WP37)
 SKIP2:

/* PACKING SLIP */
             IF         COND(&D@CHG *EQ 'N') THEN(DO)
             CALL       PGM(AB#RG3) PARM(&PSIRE &PDOCK &PNOHZ &PNOBI +
                          &PREDT)
             ENDDO

             OVRPRTF    FILE(AB#PRF8) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1) COPIES(1)

             CALL       PGM(AB#RF8) PARM(&PSIRE &PDOCK &PNOHZ &PNOBI +
                          &PREDT &PPS# &PMANI)
             DLTOVR     FILE(*ALL)


             IF         (&PFLAG  *EQ ' ') DO
             GOTO END
             ENDDO

             IF         (&PEND  *EQ ' ') DO
             GOTO LOOP
             ENDDO

             GOTO STP1


 END:        ENDPGM
