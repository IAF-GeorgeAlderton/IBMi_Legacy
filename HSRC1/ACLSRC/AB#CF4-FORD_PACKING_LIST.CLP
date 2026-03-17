             PGM
             /** AB#CF4 *******************************************************/
             /*  FORD PACKING LIST                                            */
             /*  T.SAKAKI      %0001 06/04/15 ADD LANPRT04                    */
             /*  T.SAKAKI      %0002 06/18/18 ADD NEW COMMON LAYOUT           */
             /*  J.WATANABE    JW1   07/12/18 CHG MESSAGE                     */
             /*  J.WATANABE    JW2 2023.01.12 ADD UEXR90A                     */
             /*  J.WATANABE    JW3 2023.03.30 ADD PRINT Y: PDF                */
             /*****************************************************************/
             DCLF       FILE(AB#PWF04)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTYPE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPICK)  TYPE(*DEC) LEN(2)
             DCL        VAR(&PCUST)  TYPE(*DEC) LEN(2)
             DCL        VAR(&PSIREX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TRAN)   TYPE(*CHAR) LEN(30)
             DCL        VAR(&CTYP)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDOCK)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PMANI)  TYPE(*CHAR) LEN(11)
             DCL        VAR(&WNOHZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WREDT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PPS#)   TYPE(*DEC) LEN(6 0)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PEND)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDOCKX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNONY)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNONN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&QCK)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT)   TYPE(*CHAR) LEN(10)
 /*%0002*/   DCL        VAR(&ORGOUT) TYPE(*CHAR) LEN(10)
 /*%0002*/   DCL        VAR(&PLTP)   TYPE(*CHAR) LEN(1) VALUE(' ')

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
/* TCHK3 */  CHGVAR     VAR(&D@PRT) VALUE(6)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PWF41)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
/* TCHK2 */  CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END
/* TCHK2 S */ /* TCHK4 */
             IF        ((&PFLAG *NE ' ') *AND +
                        (&PFLAG *NE '1') *AND +
                        (&PFLAG *NE '2') *AND +
                        (&PFLAG *NE '3') *AND +
                        (&PFLAG *NE '4')) DO
             CHGVAR     VAR(&IN09) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INVALID PROCESS TYPE')
             GOTO       STP1
             ENDDO
/* TCHK2 E */

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
             CHGVAR     VAR(&PNONY) VALUE(&PSIRE)
             CHGVAR     VAR(&PNONN) VALUE(&PSIRE)
             CALL       PGM(ABFR02) PARM(&PNONY &PDOCK &PNOHZ &PNOBI +
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
 /* TCH */
 STP7:
/* TCHK3 */  IF         COND((&D@PRT *NE '1') *AND +
/* %0001 */                  (&D@PRT *NE '2') *AND +
                             (&D@PRT *NE '3') *AND +
                             (&D@PRT *NE '4') *AND +
                             (&D@PRT *NE '5') *AND +
                             (&D@PRT *NE '6') *AND +
                             (&D@PRT *NE '7') *AND +
                             (&D@PRT *NE '8') *AND +
                             (&D@PRT *NE '9') *AND +
                             (&D@PRT *NE 'X') *AND +
/*JW3*/                      (&D@PRT *NE 'Y')) +
             THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PRINTER OPTION NOT CORRECT')
             GOTO       STP1
             ENDDO
             IF         COND(&D@PRT *EQ '1') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT02))
/* %0001 */  IF         COND(&D@PRT *EQ '2') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT04))
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
 /*JW3*/     IF         COND(&D@PRT *EQ 'Y') THEN(CHGVAR VAR(&POUT) +
                          VALUE(EPRINT3))

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

/* TCHK2 */  IF         (&PFLAG  *GE '1') DO
             CHGVAR     VAR(&PSIREX) VALUE('0000')
             CHGVAR     VAR(&PDOCKX) VALUE('    ')
             CHGVAR     VAR(&PEND)   VALUE(' ')
             ENDDO
 LOOP:
             CHGJOB     SWS(00000000)

/* TCHK2 */  CALL       PGM(AB#RFK) PARM(&PSIREX &PDOCKX &PEND &PFLAG)
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

  /* CREATE W/F */
  /* AB#PP10 -> AB#WP30 */
             CALL       PGM(AB#R3H) PARM(&PSIRE &PSIRK &PNOHZ &PREDT +
                          &PNOBI &PDOCK &PMANI)

             IF         (%SWITCH(0XXXXXXX)) DO

/* TCHK2 */  IF         (&PFLAG  *GE '1') DO
             GOTO LOOP
             ENDDO

             CALL       PGM(QUILNGTX) PARM('There is no data to +
                          print. The program will be cancelled...' +
                          X'00000046' ' ' ' ' X'00000000')
             GOTO       CMDLBL(END)
             ENDDO

  /* CHECK LIST TYPE */
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
    /* %0002 */
             CRTDUPOBJ  OBJ(AB#WP37) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP37
             OVRDBF     FILE(AB#WP37) TOFILE(QTEMP/AB#WP37)
             OVRDBF     FILE(AB#WP31) TOFILE(&WLIB/AB#WPFB)

             IF         COND(&PPICK *EQ 0) THEN(CHGVAR VAR(&PPICK) +
                          VALUE(1))

 /* %0002 SAVE ORIGINAL OUTQ */
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

    /* %0002 */
    /* NOT PRINT IF ONLY OLD LAYOUT */
             IF         COND(&PLTP *EQ 'O') THEN(GOTO CMDLBL(SKIP))

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
/* JW3 PDF */
             IF         COND(&D@PRT *EQ 'Y') THEN(DO)
             CALL       PGM(SPLC20) PARM('FORD PACKING LIST' &PSIRE +
                          'AB#PR3K' 'Y')
             CALL       PGM(SPLC20) PARM('FORD PALLET LIST' &PSIRE +
                          'AB#PRF8' 'N')
             ENDDO
 SKIP:

/* PACKING SLIP */

             IF         COND(&D@CHG *EQ 'N') THEN(DO)
             CALL       PGM(AB#RG3) PARM(&PSIRE &PDOCK &PNOHZ &PNOBI +
                          &PREDT)
             ENDDO

             OVRPRTF    FILE(AB#PRF8) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&POUT)    +
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
/* TT */
             GOTO STP1

 END:
  /** JW1 SET PACKING LIST# IN AB#PP10 **/
             CALL       PGM(UEXR90A) PARM('Y')

             ENDPGM
