/* RE-PRINT PICK UP LIST/PALLETIZED LIST   */
/*     CALLED FROM AB#RG1                  */
/*              MAY/30/02   TCH            */
/*  T.SAKAKI  07/01/18 ADD NEW COMMON LAYOUT  %0001                           */
/*                                         */
/*-----------------------------------------*/
             PGM        PARM(&PSIRE &PSIRK &PNOHZ &PREDT &PNOBN +
                          &PDOCK &POPTN &PSHDT &D@PRT)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDOCK) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNOHZ) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PREDT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PSHDT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PNOBN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PMANI) TYPE(*CHAR) LEN(11)
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PPICK) TYPE(*DEC) LEN(2)
             DCL        VAR(&PCUST) TYPE(*DEC) LEN(2)
             DCL        VAR(&TRAN)   TYPE(*CHAR) LEN(30)
             DCL        VAR(&CTYP)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPS#) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(2)
 /*%0001*/   DCL        VAR(&D@PRT)  TYPE(*CHAR) LEN(1)
 /*%0001*/   DCL        VAR(&POUT)  TYPE(*CHAR) LEN(10)
 /*%0001*/   DCL        VAR(&ORGOUT)  TYPE(*CHAR) LEN(10)
 /*%0001*/   DCL        VAR(&PLTP) TYPE(*CHAR) LEN(1) VALUE(' ')

             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

             IF         COND(&D@PRT *EQ '1') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT02))
             IF         COND(&D@PRT *EQ '2') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT04))
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

  /* CKECK LIST TYPE */
             CHGVAR     VAR(&PTYPE) VALUE('01')
             CALL       PGM(AB#R91) PARM(&PSIRE &PTYPE &PPICK &PCUST +
                          &TRAN &CTYP &PCNAM)

  /* PICK UP LIST */
             IF         COND(&POPTN *NE '2') THEN(DO)

             DLTF       FILE(QTEMP/AB#WPF0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WPF0) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP30) TOFILE(QTEMP/AB#WPF0)

  /* CREATE WORK FILE FROM AB#PP10  */
             CALL       PGM(AB#R3H) PARM(&PSIRE &PSIRK &PNOHZ &PREDT +
                          &PNOBN &PDOCK &PMANI)

             IF         (%SWITCH(1XXXXXXX)) DO

             DLTF       FILE(QTEMP/AB#WPFB)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WPFB) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((QTEMP/AB#WPF0)) +
                          OUTFILE(QTEMP/AB#WPFB) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S4F) +
                          OPTION(*NOPRT)

/* PICK-UP LIST */
    /* %0001 */
             CRTDUPOBJ  OBJ(AB#WP37) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP37
             OVRDBF     FILE(AB#WP37) TOFILE(QTEMP/AB#WP37)
             OVRDBF     FILE(AB#WP31) TOFILE(QTEMP/AB#WPFB)

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
                          &PSHDT)
             DLTOVR     FILE(*ALL)

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
             CLRPFM     FILE(QTEMP/AB#WP37)
 SKIP:

             ENDDO
             ENDDO

/* PALLETIZED LIST */
             IF         COND(&POPTN *NE '1') THEN(DO)

             OVRPRTF    FILE(AB#PRF8) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1) COPIES(1)

             CALL       PGM(AB#RG3) PARM(&PSIRE &PDOCK &PNOHZ &PNOBN +
                          &PREDT)
             CALL       PGM(AB#RF8) PARM(&PSIRE &PDOCK &PNOHZ &PNOBN +
                          &PREDT &PPS# &PMANI)
             DLTOVR     FILE(*ALL)

             ENDDO

             ENDPGM
