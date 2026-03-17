             PGM
             /** AB#CF2 *****************************************************/
             /*  CUSTOM SHEET                                               */
             /*       N-HYOTO                              2000.02.03       */
             /*  PARAMETER FOR NAME OF COUNTRY IS ADDED                     */
             /*       K-KASHIWAGI                          2001.03.15       */
             /*                                                             */
             /* TCHK1 04/09/08   ADD PRINTER CONTROL                        */
             /* TCHK2 02/24/09   ADD PARAMETER FOR AB#R4F                   */
             /* JW    02/11/16   ADD IF CONDITION 'g'                       */
             /* JW2   2023.04.11 ADD PDF PROGRAM (SPLC20)                   */
             /* JW3   2025.11.19 CHG MSG-ANS PROCESS                        */
             /***************************************************************/
             DCLF       FILE(AB#PWF2)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PPICK) TYPE(*DEC) LEN(2)
             DCL        VAR(&PCUST) TYPE(*DEC) LEN(2)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TRAN)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&PCNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CTYP)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&QDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(8)
/* TCHK1 */  DCL        VAR(&POUT)  TYPE(*CHAR) LEN(10)
/** JW3 **/  DCL        VAR(&MSG1 ) TYPE(*CHAR) LEN(30) VALUE(' ')
/** JW3 **/  DCL        VAR(&MSG2 ) TYPE(*CHAR) LEN(30) VALUE(' ')

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CVTDAT     DATE(&QDATE) TOVAR(&SDATE) FROMFMT(*SYSVAL) +
                          TOFMT(*YYMD) TOSEP(*NONE)
             CHGVAR     VAR(&PNOHZ) VALUE(&SDATE)
             CHGVAR     VAR(&PDEHZ) VALUE(&SDATE)
             CHGVAR     VAR(&PBIN) VALUE(01)
/* TCHK1 */  CHGVAR     VAR(&D@PRT) VALUE('1')

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PWF21)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
/* TCHK1 */  CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&PSIRE *EQ '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTER DELIVERY CODE')
             GOTO       STP1
             ENDDO

             IF         (&PSIRK *EQ ' ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTER FACTORY')
             GOTO       STP1
             ENDDO

             IF         (&PDOCK *EQ '    ') DO
             CHGVAR     VAR(&IN08) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTER DOCK')
             GOTO       STP1
             ENDDO

             IF         (%SUBSTRING(&PNOHZ 1 4) *LT '2000') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 5 2) *GT '12') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 5 2) *LT '01') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 7 2) *GT '31') GOTO STP2
             IF         (%SUBSTRING(&PNOHZ 7 2) *LT '01') GOTO STP2
             GOTO       STP3
 STP2:       CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE(YYMMDD) IS NOT CORRECT')
             GOTO       STP1

 STP3:       IF         (&PBIN *EQ 00) DO
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ENTER BIN#')
             GOTO       STP1
             ENDDO

             IF         (%SUBSTRING(&PDEHZ 1 4) *LT '2000') GOTO STP4
             IF         (%SUBSTRING(&PDEHZ 5 2) *GT '12') GOTO STP4
             IF         (%SUBSTRING(&PDEHZ 5 2) *LT '01') GOTO STP4
             IF         (%SUBSTRING(&PDEHZ 7 2) *GT '31') GOTO STP4
             IF         (%SUBSTRING(&PDEHZ 7 2) *LT '01') GOTO STP4
             GOTO       STP45

 STP4:       CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('DATE(YYMMDD) IS NOT CORRECT')
             GOTO       STP1

/* TCHK1 START */
 STP45:      IF         (&D@PRT *EQ '1') GOTO STP46
             IF         (&D@PRT *EQ '3') GOTO STP46
             IF         (&D@PRT *EQ '4') GOTO STP46
             IF         (&D@PRT *EQ '5') GOTO STP46
             IF         (&D@PRT *EQ '6') GOTO STP46
             IF         (&D@PRT *EQ '7') GOTO STP46
             IF         (&D@PRT *EQ '8') GOTO STP46
             IF         (&D@PRT *EQ '9') GOTO STP46
             IF         (&D@PRT *EQ 'X') GOTO STP46
             IF         (&D@PRT *EQ 'Y') GOTO STP46
             CHGVAR     VAR(&IN09) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INVALID PRINTER')
             GOTO       STP1

 STP46:      CALL       PGM(AB#R91) PARM(&PSIRE &PTYPE &PPICK &PCUST +
                          &TRAN &CTYP &PCNAM)
/*JW1*/
             IF         (&PCUST *EQ 0) DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('No Data Found!  Check +
                          Selected Option.')
             GOTO       STP1
             ENDDO

 STP5:       IF         (&IN05 *EQ '0') GOTO STP1

 /*== PRINT CUSTOME SHEET ===============================================*/

             DLTF       FILE(AB#WP3K1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP3K1) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)


             CHGVAR     VAR(&PFLG) VALUE(' ')
             CALL       PGM(AB#R3K) PARM(&PSIRE &PSIRK &PDOCK &PNOHZ +
                          &PBIN &PDEHZ &PFLG)
             IF         (%SWITCH(0XXXXXXX)) DO
 /** JW3 **/
             CHGVAR VAR(&MSG1) VALUE('!! NO DATA FOUND !!')
             CALL       PGM(UTLC96 ) PARM(&MSG1 &MSG2)
             MONMSG     MSGID(CPF0000)
             GOTO       STP1

 /**JW3 STP6:SNDPGMMSG  MSG('''( G ) THERE IS NO DATA CORRESPONDS TO +     **/
 /**                      FRS.  < ENTER G >') TOMSGQ(&WSID) +              **/
 /**                      MSGTYPE(*INQ) KEYVAR(&MBAN)                      **/
 /**         RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) MSG(&KOTAE) **/
 /**         IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g') *OR +       **/
 /**                      (&KOTAE = ' ')) THEN(GOTO STP1)                  **/
 /**         GOTO       STP6                                               **/

             ENDDO


/* MAKE W/F FOR CUSTOME SHEET */

             DLTF       FILE(AB#WP3K2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP3K2) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AB#WP3K1)) +
                          OUTFILE(&WLIB/AB#WP3K2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S38) +
                          OPTION(*NOPRT)
             DLTF       FILE(AB#WP3K1)

/* TCHK1 START */
             IF  COND(&D@PRT *EQ '1') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT02))
             IF  COND(&D@PRT *EQ '3') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT08))
             IF  COND(&D@PRT *EQ '4') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT03))
             IF  COND(&D@PRT *EQ '5') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT04))
             IF  COND(&D@PRT *EQ '6') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT09))
             IF  COND(&D@PRT *EQ '7') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT10))
             IF  COND(&D@PRT *EQ '8') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT05))
             IF  COND(&D@PRT *EQ '9') THEN(CHGVAR VAR(&POUT) VALUE(QDKT    ))
             IF  COND(&D@PRT *EQ 'X') THEN(CHGVAR VAR(&POUT) VALUE(EPRINT3 ))
             IF  COND(&D@PRT *EQ 'Y') THEN(CHGVAR VAR(&POUT) VALUE(EPRINT3 ))

/* TCHK1 */  OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUT)    +
                          FORMTYPE(K6S1) COPIES(&PCUST) IGCDTA(&PIGCD)

/* CALL FORD CUSTOM SHEET PROGRAM */
/* TCHK2 */  CALL       PGM(AB#R4F) PARM(&PSIRE &PSIRK &PDOCK &PNOHZ +
                          &PBIN &PDEHZ &PCNAM &TRAN)
             DLTOVR     FILE(*ALL)

             IF         (&PFLG *EQ '*') DO
             SNDPGMMSG  MSG('PLEASE REGISTER UNIT PRICE BEFORE +
                          ISSUING INVOICE AND CUSTOM SHEET.') +
                          TOMSGQ(&WSID)
             ENDDO

/* JW2 PDF*/
             IF         COND(&D@PRT *EQ 'Y') THEN(DO)
             CALL       PGM(SPLC20) PARM('FORD CUSTOM SHEET' &PSIRE +
                          'QPRINT' 'Y')
             ENDDO

 END:        ENDPGM
