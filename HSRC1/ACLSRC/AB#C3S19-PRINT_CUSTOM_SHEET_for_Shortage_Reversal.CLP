             PGM
             /** AB#C3S19 ********************************************/
             /*  PRINT CUSTOM SHEET -- FOR SHORTAGE REVERSALS        */
             /*                                                      */
             /*  JW1   2025.12.19 ADD OPTION N TO TRIAL PART (&D@P6) */
             /********************************************************/
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4) VALUE('3503')
             DCL        VAR(&PSIRK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PNOHZC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PNOHZ) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PNOBN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PWEIG) TYPE(*DEC) LEN(5 2) VALUE(1.07)
             DCL        VAR(&PNUKE) TYPE(*CHAR) LEN(4)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNOBI) TYPE(*DEC) LEN(1)
             DCL        VAR(&PMANI) TYPE(*CHAR) LEN(18)
             DCL        VAR(&PPALT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PPICK) TYPE(*DEC) LEN(2)
             DCL        VAR(&PCUST) TYPE(*DEC) LEN(2)
             DCL        VAR(&PGROS) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TRANS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&PCNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CTYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PNUKE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PODRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTP) TYPE(*CHAR) LEN(1) VALUE('4')
             DCL        VAR(&POUT) TYPE(*CHAR) LEN(10)
 /*JW1*/     DCL        VAR(&D@P6) TYPE(*CHAR) LEN(1) VALUE('N')

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&PTYPE) VALUE('  ')
             CHGVAR     VAR(&PPICK) VALUE(0)
             CHGVAR     VAR(&PCUST) VALUE(0)

             IF         COND(&PTP *EQ '1') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT02))
             IF         COND(&PTP *EQ '2') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT07))
             IF         COND(&PTP *EQ '3') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT08))
             IF         COND(&PTP *EQ '4') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT03))
             IF         COND(&PTP *EQ '5') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT04))
             IF         COND(&PTP *EQ '6') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT09))
             IF         COND(&PTP *EQ '7') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT10))
             IF         COND(&PTP *EQ '8') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT05))
             IF         COND(&PTP *EQ '9') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QDKT))
             IF         COND(&PRT *EQ 'A') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT06))


             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)



             DLTF       FILE(QTEMP/AB#WP38)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP38) RCDLEN(110) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP38) TOFILE(QTEMP/AB#WP38)


             CHGVAR     VAR(&PFLG) VALUE(' ')
             CALL      PGM(AB#R3N19) PARM(&PFLG)
             IF         COND(&PFLG = '1') THEN(DO)

/* MAKE W/F FOR CUSTOM SHEET */
             CALL       PGM(AB#R91) PARM(&PSIRE &PTYPE &PPICK &PCUST +
                          &TRANS &CTYPE &PCNAM)

             DLTF       FILE(QTEMP/AB#WP39)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP39) RCDLEN(110) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((QTEMP/AB#WP38)) +
                          OUTFILE(QTEMP/AB#WP39) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S39) +
                          OPTION(*NOPRT)

             DLTF       FILE(QTEMP/AB#WP38)
             RNMOBJ     OBJ(QTEMP/AM#WP39) OBJTYPE(*FILE) +
                          NEWOBJ(AM#WP38)
             MONMSG     MSGID(CPF0000)

             IF         COND(&POUT *NE 'LANPRT02') THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1) SAVE(*YES)
             ENDDO


   /* **  if lanprt02, then make it pull from drawer 2...   ** */
             IF         COND(&POUT *EQ 'LANPRT02') THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) DRAWER(2) +
                          OUTQ(&POUT) FORMTYPE(K6S1) SAVE(*YES)
             ENDDO

/* CALL (COMMMON) CUSTOM SHEET PROGRAM */
             IF         (&CTYPE *EQ '01') DO

 /********   CALL       PGM(AB#R39) PARM(&PWEIG &TRANS &PCNAM) ***/
 /* JW1 */   CALL       PGM(AB#R39) PARM(&PWEIG &TRANS &PCNAM &D@P6)

             ENDDO

/* CALL (HONDA) CUSTOM SHEET PROGRAM */
             IF         (&CTYPE *EQ '02') DO

 /********   CALL       PGM(AB#R4D) PARM(&PWEIG &PSIRE &PCNAM &TRANS)  ***/
 /* JW1 */   CALL       PGM(AB#R4D) PARM(&PWEIG &PSIRE &PCNAM &TRANS &D@P6)

             ENDDO

             ENDDO

             ENDPGM
