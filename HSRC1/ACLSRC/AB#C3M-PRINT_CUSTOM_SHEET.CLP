             PGM        PARM(&PSIRE &PSIRK &PNOHZC &PNOBN &PWEIG +
                         &PNUKE &PODRN &POUTQ &D@P6)
             /** AB#C3M******************************************************/
             /*  PRINT CUSTOM SHEET                                         */
             /*  K-KASHIWAGI 2001.01.19                                     */
             /*  ADD PARAMETER FOR NAME OF COUNTRY                          */
             /*  CUSTOM SHEET TYPE 03 IS NOT USED ANY MORE                  */
             /*  K-KASHIWAGI 2001.03.15                                     */
             /*  N-HYOTO     2001.04.25                                     */
             /*  TCH         2005.03.08 TCH47 PRINTER                       */
             /*  TCHK1       2006.08.28 CHG &PNOBN LENGTH                   */
             /*  TCHK2       2014.09.23 CHG LENGTH                          */
             /*  JW1         2016.04.07 CHG &PWEIG (WGT)                    */
             /*  JW2         2025.03.07 CHG ERROR MSG TO HAVE PART#         */
             /*  JW3         2025.12.19 ADD OPTION Y TO TRIAL PART (&D@P6)  */
             /***************************************************************/
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PNOHZC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PNOHZ) TYPE(*DEC) LEN(8 0)
/* TCHK1 */  DCL        VAR(&PNOBN) TYPE(*CHAR) LEN(2)
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
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PNUKE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PODRN) TYPE(*CHAR) LEN(10)
 /*TCH47*/   DCL        VAR(&POUTQ) TYPE(*CHAR) LEN(08)
 /*JW4*/     DCL        VAR(&D@P6)  TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&PNOHZ) VALUE(&PNOHZC)
             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&PTYPE) VALUE('  ')
             CHGVAR     VAR(&PPICK) VALUE(0)
             CHGVAR     VAR(&PCUST) VALUE(0)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             DLTF       FILE(&WLIB/AB#WP38)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP38) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             CHGVAR     VAR(&PFLG) VALUE(' ')

/***JW2      CALL      PGM(AB#R3N) PARM(&PSIRE &PSIRK &PNOHZ &PNOBN + ****/
/*********                &PNUKE &PODRN &PFLG)                        ****/

             CALL      PGM(AB#R3N) PARM(&PSIRE &PSIRK &PNOHZ &PNOBN +
                          &PNUKE &PODRN &PFLG &PMHIN)
    /* NO RECORD */
             IF         (%SWITCH(0XXXXXXX)) DO
             SNDBRKMSG  MSG('THERE IS NO DATA MACHING YOUR +
                          SELECTION.') TOMSGQ(&WSID)
             GOTO       @END
             ENDDO
/* MAKE W/F FOR CUSTOM SHEET */
             CALL       PGM(AB#R91) PARM(&PSIRE &PTYPE &PPICK &PCUST +
                          &TRANS &CTYPE &PCNAM)

             IF         COND(&PCUST *NE 0) THEN(DO)

             DLTF       FILE(&WLIB/AB#WP39)
             MONMSG     MSGID(CPF3261 CPF2105)
/* THHK2     CRTPF      FILE(&WLIB/AB#WP39) RCDLEN(100) +       */
/*                        OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL) */
/* THHK2 */  CRTPF      FILE(&WLIB/AB#WP39) RCDLEN(110) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AB#WP38)) +
                          OUTFILE(&WLIB/AB#WP39) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S38) +
                          OPTION(*NOPRT)
             DLTF       FILE(&WLIB/AB#WP38)

  /* TCH47   OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1) COPIES(&PCUST)        */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(&POUTQ)   +
                          FORMTYPE(K6S1) COPIES(&PCUST)

/* CALL (COMMMON) CUSTOM SHEET PROGRAM */
             IF         (&CTYPE *EQ '01') DO

/********    CALL       PGM(AB#R39) PARM(&PWEIG &TRANS &PCNAM)  ****/
/**JW3**/    CALL       PGM(AB#R39) PARM(&PWEIG &TRANS &PCNAM &D@P6)

             ENDDO

/* CALL (HONDA) CUSTOM SHEET PROGRAM */
             IF         (&CTYPE *EQ '02') DO

/********    CALL       PGM(AB#R4D) PARM(&PWEIG &PSIRE &PCNAM &TRAN) ****/
/**JW3**/    CALL       PGM(AB#R4D) PARM(&PWEIG &PSIRE &PCNAM &TRANS &D@P6)

             ENDDO

/* CALL (HONDA) CUSTOM SHEET PROGRAM */
             IF         (&CTYPE *EQ '03') DO

/**JW3***    CALL       PGM(AB#R4D@) PARM(&PWEIG &PSIRE &PCNAM &TRANS) ****/

             ENDDO

/* CALL (MEXICO) CUSTOM SHEET PROGRAM */
/*           IF         (&CTYPE *EQ '03') DO              */
/*           CALL       PGM(AB#R3Z) PARM(&PWEIG &TRANS)   */
/*           ENDDO                                        */

             DLTOVR     FILE(*ALL)
             ENDDO


             IF         (&PFLG *EQ '*') DO
             SNDPGMMSG  MSG('PLEASE REGISTER UNIT PRICE BEFORE +
                          ISSUING EDI INVOICE DATA AND CANADA +
                          CUSTOM SHEET. (AB#C3M)') TOMSGQ(&WSID)
             ENDDO
  @END:

             ENDPGM
