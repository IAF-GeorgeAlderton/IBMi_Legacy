             PGM        PARM(&BAR &NONY &PRNT &PLT &RTN)
             /** AC#C11***************************************************/
             /*  PRINT CONSOLIDATED CUSTOM SHEET                         */
             /*  J.WATANABE  2017.03.28                                  */
             /*********************************************** AB#C3S *****/
             DCL        VAR(&BAR)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRNT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PLT ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTQ)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR )   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT )   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&PTYP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CTYP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CCPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LCPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MCPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BMAX) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TRAN) TYPE(*CHAR) LEN(30)
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USR)

             IF COND(&PRNT *EQ '1') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT02))
             IF COND(&PRNT *EQ '2') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT07))
             IF COND(&PRNT *EQ '3') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT08))
             IF COND(&PRNT *EQ '4') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT03))
             IF COND(&PRNT *EQ '5') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT04))
             IF COND(&PRNT *EQ '6') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT09))
             IF COND(&PRNT *EQ '7') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT10))
             IF COND(&PRNT *EQ '8') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT05))
             IF COND(&PRNT *EQ '9') THEN(CHGVAR VAR(&OUTQ) VALUE(QDKT))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

  /*JW       DLTF       FILE(QTEMP/AB#WP38)                            */
  /*JW       MONMSG     MSGID(CPF3261 CPF2105)                         */
  /*JW       CRTPF      FILE(QTEMP/AB#WP38) RCDLEN(110) +              */
  /*JW                    OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL) */
  /*JW       OVRDBF     FILE(AB#WP38) TOFILE(QTEMP/AB#WP38)            */
  /*JW                                                                 */
  /*JW       CHGVAR     VAR(&PFLG) VALUE(' ')                          */
  /*JW       CALL      PGM(AB#R3N) PARM(&PSIRE &PSIRK &PNOHZ &PNOBN +  */
  /*JW                    &PNUKE &PODRN &PFLG)                         */

/* MAKE W/F FOR CUSTOM SHEET */
  /*JW       CALL       PGM(AB#R91) PARM(&PSIRE &PTYPE &PPICK &PCUST + */
  /*JW                    &TRANS &CTYPE &PCNAM)                        */

  /*JW       DLTF       FILE(QTEMP/AB#WP39)                            */
  /*JW       MONMSG     MSGID(CPF3261 CPF2105)                         */
  /*JW       CRTPF      FILE(QTEMP/AB#WP39) RCDLEN(110) +              */
  /*JW                    OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)        */
  /*JW                                                                 */
  /*JW       FMTDTA     INFILE((QTEMP/AB#WP38)) +                      */
  /*JW                    OUTFILE(QTEMP/AB#WP39) +                     */
  /*JW                    SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S39) +       */
  /*JW                    OPTION(*NOPRT)                               */
  /*JW       DLTF       FILE(QTEMP/AB#WP38)                            */
  /*JW                                                                 */
  /*JW       OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) + */
  /*JW                    LPI(6) RPLUNPRT(*YES) OUTQ(&OUTQ) +          */
  /*JW                    FORMTYPE(K6S1)                               */

/* CREATE WORK FILE */
             CALL       PGM(AC#C20) PARM(&BAR)

/* RETRIEVE PACKING LIST INFORMATION */
             CALL       PGM(UTLR52) PARM(&NONY &PTYP &PCPY &CTYP +
                          &CCPY &CNAM &LTYP &LCPY &MCPY &SUPP &BMAX +
                          &TRAN &RTN1)

             OVRPRTF    FILE(QPRINT)  DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)

/* CALL (CANADA) CUSTOM SHEET PROGRAM */
             IF         (&CTYP *EQ '01') DO
          /* CALL       PGM(AB#R39) PARM(&PWEIG &TRANS &PCNAM)        */
             CALL       PGM(AC#R11) PARM(&BAR &PLT)
             ENDDO

/* CALL (HONDA) CUSTOM SHEET PROGRAM */
             IF         (&CTYP *EQ '02') DO
          /* CALL       PGM(AB#R4D) PARM(&PWEIG &PSIRE &PCNAM &TRANS) */
             CALL       PGM(AC#R12) PARM(&BAR &PLT)
             ENDDO

             DLTOVR     FILE(*ALL)

  /*JW       IF         (&PFLG *EQ '*') DO                          */
  /*JW       SNDPGMMSG  MSG('PLEASE REGISTER UNIT PRICE BEFORE +    */
  /*JW                    ISSUING EDI INVOICE DATA AND CANADA +     */
  /*JW                    CUSTOM SHEET.') TOMSGQ(&WSID)             */
  /*JW       ENDDO                                                  */

             ENDPGM
