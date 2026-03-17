             PGM        PARM(&PSIRE &PSIRK &PNOHZC &PNOBN &PWEIG +
                         &PNUKE &PODRN &PTP)
             /** AB#C3M******************************************************/
             /*  PRINT CUSTOM SHEET                                  */
             /*  K-KASHIWAGI 2001.01.19                              */
             /*  ADD PARAMETER FOR NAME OF COUNTRY                   */
             /*  CUSTOM SHEET TYPE 03 IS NOT USED ANY MORE           */
             /*  K-KASHIWAGI 2001.03.15                              */
             /*  N-HYOTO     2001.04.25                              */
             /*  TCHK1       2005.12.26 CHG PRINTER CONTROL          */
             /*  TCHK2       2006.08.24 BUG FIX                      */
             /*  TCHK3       2007.01.12 CHG PRINTER CONTROL          */
             /*  JW1         2025.03.07 CHG ERROR MSG TO HAVE PART#  */
             /*********************************************** AB#C3M***C38 **/
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PNOHZC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PNOHZ) TYPE(*DEC) LEN(8 0)
/* TCHK2     DCL        VAR(&PNOBN) TYPE(*CHAR) LEN(1) */
/* TCHK2 */  DCL        VAR(&PNOBN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PWEIG) TYPE(*DEC) LEN(5 2)
             DCL        VAR(&PNUKE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PODRN) TYPE(*CHAR) LEN(10)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMHIN) TYPE(*CHAR) LEN(20)

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
             DCL        VAR(&PTP)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT)  TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&PNOHZ) VALUE(&PNOHZC)
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
/* TCHK3                  VALUE(QPRINTA)) */
/* TCHK1 */  IF         COND(&PTP *EQ '6') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT09))
/* TCHK1 */  IF         COND(&PTP *EQ '7') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT10))
/* TCHK1 */  IF         COND(&PTP *EQ '8') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT05))
/* TCHK1 */  IF         COND(&PTP *EQ '9') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QDKT))
/* JW    */  IF         COND(&PTP *EQ 'X') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QDKT))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)


             CHGVAR     VAR(&PWEIG) VALUE(1.07)

             DLTF       FILE(QTEMP/AB#WP38)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP38) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP38) TOFILE(QTEMP/AB#WP38)


             CHGVAR     VAR(&PFLG) VALUE(' ')

/**JW1       CALL      PGM(AB#R3N) PARM(&PSIRE &PSIRK &PNOHZ &PNOBN + ***/
/*********                &PNUKE &PODRN &PFLG)                        ***/

             CALL      PGM(AB#R3N) PARM(&PSIRE &PSIRK &PNOHZ &PNOBN +
                          &PNUKE &PODRN &PFLG &PMHIN)

/* MAKE W/F FOR CUSTOM SHEET */
             CALL       PGM(AB#R91) PARM(&PSIRE &PTYPE &PPICK &PCUST +
                          &TRANS &CTYPE &PCNAM)

 /*          IF         COND(&PCUST *NE 0) THEN(DO)  */

             DLTF       FILE(QTEMP/AB#WP39)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP39) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((QTEMP/AB#WP38)) +
                          OUTFILE(QTEMP/AB#WP39) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S38) +
                          OPTION(*NOPRT)
             DLTF       FILE(QTEMP/AB#WP38)

             IF         COND(&POUT *NE 'LANPRT02') THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1)
             ENDDO


   /* **  if lanprt02, then make it pull from drawer 2...   ** */
             IF         COND(&POUT *EQ 'LANPRT02') THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1) DRAWER(2)
             ENDDO

/* CALL (COMMMON) CUSTOM SHEET PROGRAM */
             IF         (&CTYPE *EQ '01') DO
             CALL       PGM(AB#RSL) PARM(&PWEIG &TRANS &PCNAM)
             ENDDO

/* CALL (HONDA) CUSTOM SHEET PROGRAM */
             IF         (&CTYPE *EQ '02') DO
             CALL       PGM(AB#RSM) PARM(&PWEIG &PSIRE &PCNAM &TRANS)
             ENDDO


             DLTOVR     FILE(*ALL)


             IF         (&PFLG *EQ '*') DO
             SNDPGMMSG  MSG('PLEASE REGISTER UNIT PRICE BEFORE +
                          ISSUING EDI INVOICE DATA AND CANADA +
                          CUSTOM SHEET. (AB#CSL)') TOMSGQ(&WSID)
             ENDDO


             ENDPGM
