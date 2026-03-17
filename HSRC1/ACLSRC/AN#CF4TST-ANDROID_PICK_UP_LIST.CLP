  PGM
/** AN#CF4 ************************************************/
/*  ANDROID PICK-UP LIST                                  */
/*                                                        */
/* TCHK1 07/13/06 CREATE(COPY FROM AB#CF4)                */
/**********************************************************/
             DCLF       FILE(HOBJ1/AN#PWF04)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PTYPE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPICK)  TYPE(*DEC)  LEN(2)
             DCL        VAR(&PCUST)  TYPE(*DEC)  LEN(2)
             DCL        VAR(&PSIREX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TRAN)   TYPE(*CHAR) LEN(30)
             DCL        VAR(&CTYP)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDOCK)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PMANI)  TYPE(*CHAR) LEN(11)
             DCL        VAR(&WNOHZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WREDT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PPS#)   TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PEND)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDOCKX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNONY)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNONN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SND)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&QCK)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT)   TYPE(*CHAR) LEN(10)

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
             CHGVAR     VAR(&D@CHG) VALUE('N')
             CHGVAR     VAR(&D@PRT) VALUE(1)

 STP1:
             SNDRCVF    DEV(&WSID) RCDFMT(AN#PWF41)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
             CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')


             IF         (&IN01 *EQ '1') GOTO END


             IF         COND((&PFLAG *NE ' ') *AND (&PFLAG *NE '1')) +
                          THEN(DO)
             CHGVAR     VAR(&IN09) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('OPTION NOT CORRECT')
             GOTO       STP1
             ENDDO

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

 STP2:
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1

 STP3:
             IF         (&PNOBI *EQ 0) DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO. BIN')
             GOTO       STP1
             ENDDO

/* CHECK ALREADY PRINTED */
             CHGVAR     VAR(&PNONY) VALUE(&PSIRE)
             CHGVAR     VAR(&PNONN) VALUE(&PSIRE)
             CALL       PGM(ANFR02) PARM(&PNONY &PDOCK &PNOHZ &PNOBI +
                          &PREDT &PFLG)

             IF         COND(&PFLG *EQ '1') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE(&PNONY *CAT ': ISSUED +
                          ALREADY. TO RE-CREATE, ASK YOUR SUPERVISOR.')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1
             ENDDO

             IF         COND(&PFLG *EQ '2') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE(&PNONY *CAT ': IS NOT +
                          REGISTERED IN PICK UP LIST MASTER +
                          (MENU#999).')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1
             ENDDO

 STP7:
             IF         COND((&D@PRT *GT '9') *OR (&D@PRT *EQ ' ')) +
                          THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PRINTER OPTION NOT CORRECT')
             GOTO       STP1
             ENDDO

             IF         COND(&D@PRT *EQ '1') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT02))
             IF         COND(&D@PRT *EQ '2') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT07))
             IF         COND(&D@PRT *EQ '3') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT08))
             IF         COND(&D@PRT *EQ '4') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT03))
             IF         COND(&D@PRT *EQ '5') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QPRINTA))
             IF         COND(&D@PRT *EQ '6') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT09))
             IF         COND(&D@PRT *EQ '7') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT10))
             IF         COND(&D@PRT *EQ '8') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT05))
             IF         COND(&D@PRT *EQ '9') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QDKT))

             CHGVAR     VAR(&WREDT) VALUE(&PREDT)
             IF         (%SUBSTRING(&WREDT 1 4) *LT '2000') GOTO STP4
             IF         (%SUBSTRING(&WREDT 5 2) *GT '12') GOTO STP4
             IF         (%SUBSTRING(&WREDT 5 2) *LT '01') GOTO STP4
             IF         (%SUBSTRING(&WREDT 7 2) *GT '31') GOTO STP4
             IF         (%SUBSTRING(&WREDT 7 2) *LT '01') GOTO STP4
             GOTO       STP5

 STP4:
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE (YYMMDD) IS NOT RIGHT')
             GOTO       STP1

 STP5:
   /* QTY/CONT CHECK */
/* TEST */   OVRDBF     FILE(AB#PL14) TOFILE(TFILE1/AB#PL14)
/* TEST */   OVRDBF     FILE(AB#PL16) TOFILE(TFILE1/AB#PL16)
             CALL       PGM(ANFR03) PARM(&PNONY &PDOCK &PNOHZ &PNOBI +
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

/* BUG       CALL       PGM(AN#RFK) PARM(&PSIREX &PDOCKX &PEND) */
/* BBB */    CALL       PGM(AN#RFK) PARM(&PSIREX &PDOCKX &PEND &PFLAG)
             CHGVAR     VAR(&PSIRE)  VALUE(&PSIREX)
             CHGVAR     VAR(&PDOCK)  VALUE(&PDOCKX)
             CHGVAR     VAR(&PSIRK) VALUE('0')


             IF         (&PEND   *EQ '1') DO
             GOTO       END
             ENDDO

 SKIP1:

             DLTF       FILE(AN#WPF0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AN#WPF0) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AN#WPF0) TOFILE(&WLIB/AN#WPF0)

             CALL       PGM(AN#R3H) PARM(&PSIRE &PSIRK &PNOHZ &PREDT +
                          &PNOBI &PDOCK &PMANI)

             IF         (%SWITCH(0XXXXXXX)) DO

             IF         (&PFLAG  *EQ '1') DO
             GOTO       LOOP
             ENDDO

 STP6:
             SNDPGMMSG  MSG('( G ) SINCE THERE IS NO DATA INPUT. +
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

             DLTF       FILE(AN#WPFB)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AN#WPFB) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((&WLIB/AN#WPF0)) +
                          OUTFILE(&WLIB/AN#WPFB) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S4F) +
                          OPTION(*NOPRT)

             OVRDBF     FILE(AN#WPFB) TOFILE(&WLIB/AN#WPFB)

             CALL       PGM(AN#RF6) PARM(&US &PSIRE &PNOHZ +
                          &PNOBI &PMANI &PREDT &PDOCK &PPS#)

/* PICK-UP LIST */
             IF         COND(&PPICK *EQ 0) THEN(CHGVAR VAR(&PPICK) +
                          VALUE(1))

             OVRPRTF    FILE(AN#PR3I) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(QDKT)     +
                          FORMTYPE(K6S1) COPIES(&PPICK)

/* TEST */   OVRDBF     FILE(AB#PL75) TOFILE(TFILE1/AB#PL75)

             CALL       PGM(AN#R3I) PARM(&PSIRE &PREDT &PPS# &PMANI +
                          &D@SHDT)

/* PACKING SLIP */
             IF         COND(&D@CHG *EQ 'N') THEN(DO)
             CALL       PGM(AN#RG3) PARM(&PSIRE &PDOCK &PNOHZ &PNOBI +
                          &PREDT)
             ENDDO

             OVRPRTF    FILE(AN#PRF8) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&POUT)    +
                          FORMTYPE(K6S1) COPIES(1)

             CALL       PGM(AN#RF8) PARM(&PSIRE &PDOCK &PNOHZ &PNOBI +
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
