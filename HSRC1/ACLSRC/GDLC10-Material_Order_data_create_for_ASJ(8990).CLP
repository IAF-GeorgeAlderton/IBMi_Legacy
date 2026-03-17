             PGM
/** GDLC10 ************************************************/
/*  MATERIAL ORDER SHEET PRINT SYSTEM                     */
/*               K.YASUDA  2000.07.11                     */
/*               N.HYOTO   2001.03.19                     */
/*               H.AMANO   2003.08.21                     */
/*                 ADD DATARA                             */
/*               N.HAYA    2004.03.24                     */
/*                 ADD SNDNETSPLF                         */
/*               ADD PRINTER SELECTION                    */
/*               H.AMANO   2004.10.28                     */
/*                 FIXED BUG                              */
/* TCHK  09/12/05 CHG SNDNETAPLF ONLY ASJ                 */
/* TCHK1 10/14/05 CHG FOR ONLY ASJ(CALL FROM GDLC1A)      */
/* TCHK2 04/19/06 CHG PROCESS SEQ CHANGE                  */
/* TCHK3 10/02/07 CHG SPOOL CONTROL                       */
/* TCHK4 01/01/08 CHG 0002 TO 8990                        */
/* TCHK5 03/18/08 ADD PROCESS UNLOCK WHEN F1 PRESS        */
/* JW  2026.01.20 CHG GCLSRC --> ACLSRC                   */
/************************************************ GDLC10 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PODR1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PODR2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PODR3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&P2)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(46)
             DCL        VAR(&MSGX)  TYPE(*CHAR) LEN(35)
             DCL        VAR(&SMB)  TYPE(*CHAR) LEN(10)
/* TCHK3 */  DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

/* TCHK3     RTVJOBA    JOB(&WSID) USER(&USER)           */
/* TCHK3 */  RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGJOB     SWS(00000000)

 /* TCHK1    CHKOBJ     OBJ(HFILE1/GDLCACT) OBJTYPE(*DTAARA)          */
 /* TCHK1    MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SKIP))        */
 /* TCHK1                                                             */
 /* TCHK1    CHGVAR     VAR(&MSGX) VALUE('IS USING THIS +             */
 /* TCHK1                 PROGRAM.(GDLCACT)')                         */
 /* TCHK1    RTVDTAARA  DTAARA(HFILE1/GDLCACT (1 10)) RTNVAR(&SMB)    */
 /* TCHK1    CHGVAR     VAR(&MSG) VALUE(&SMB *CAT &MSGX)              */
 /* TCHK1    CALL       PGM(QUILNGTX) PARM(&MSG X'00000046' '       + */
 /* TCHK1                 ' '                    ' X'00000000')       */
 /* TCHK1    GOTO       END2                                          */
 SKIP:
 /* TCHK1    CRTDTAARA  DTAARA(HFILE1/GDLCACT) TYPE(*CHAR) LEN(10) +  */
 /* TCHK1                 VALUE(&USER) TEXT('MATERIAL ORDER +         */
 /* TCHK1                 PROCESSING') AUT(*ALL)                      */

             CHGVAR     VAR(&P1)    VALUE('1')
             CHGVAR     VAR(&P2)    VALUE(' ')
             CALL       PGM(GDLR99) PARM(&P1 &P2)

  /*         IF         (&P2 *EQ '1') DO                        */
  /*         SNDPGMMSG  MSG('THIS PROGRAM IS OPENED ON OTHER  + */
  /*                      COMPUTER.PLEASE MAKE SURE THAT THIS + */
  /*                      PROGRAM IS CLOSED ON ALL OTHER +      */
  /*                      COMPUTERS.') TOMSGQ(&WSID)            */
  /*         GOTO END2                                          */
  /*         ENDDO                                              */


             IF         (&P2 *EQ '2') DO
             SNDPGMMSG  MSG('MATERIAL ORDER HAS BEEN PROCESSED FOR +
                          TODAY.PLEASE TRY THIS PROCESS TOMMOROW. +
                          ') TOMSGQ(&WSID)
             GOTO END1
             ENDDO

             IF         (&P2 *EQ '3') DO
             SNDPGMMSG  MSG('IT HAS HAPPENED SYSTEMS ERROR. PLEASE +
                          CONTACT SYSTEMS PERSON.') TOMSGQ(&WSID)
             GOTO END1
             ENDDO

      /*     OVRPRTF    FILE(GDLPR10) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1)   */
/* TCHK3 */  OVRPRTF    FILE(GDLPR10) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT03) +
                          FORMTYPE(K6S1)
             OVRPRTF    FILE(GDLPR11) DEVTYPE(*SCS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(GDOUTQ) +
                          FORMTYPE(K6H1) HOLD(*NO) SAVE(*YES)

             DLTF       FILE(GDLWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDLWP10) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(GDLR10) PARM(&USER &PSIRE &PODR1 &PODR2 +
                          &PODR3)
             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
/* TCHK5 */  CALL       PGM(GDLR97) PARM('2' '8990' ' ')
             GOTO       END
             ENDDO

/* TCHK4     IF         COND(&PSIRE *EQ '0002') THEN(DO) */
/* TCHK4 */  IF         COND(&PSIRE *EQ '8990') THEN(DO)
             SNDNETSPLF FILE(GDLPR11) TOUSRID((V0035 SYSTEM1)) +
                          SPLNBR(*LAST) DTAFMT(*ALLDATA)
/* TCHK3     DLTSPLF    FILE(GDLPR11) SPLNBR(*LAST) */
/* TCHK3 */  CHGSPLFA   FILE(GDLPR11) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST) OUTQ(SAVEOUTQ)      +
                          SAVE(*NO)
/* TCHK3 */  MONMSG     MSGID(CPF0000)
/* TCHK */   ENDDO


/*           OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)  */

/*           CALL       PGM(GDLR13) PARM(&USER &PSIRE &PODR1 &PODR2 +
                          &PODR3)                     */

             CLRPFM     FILE(GDLWP02)

             CALL       PGM(GDLR11)

/* TCHK2     CLRPFM     FILE(GDLPP01)                               */
/* TCHK2     RTVMBRD    FILE(GDLWP02) NBRCURRCD(&KEN)               */
/* TCHK2     IF         COND(&KEN *NE 0) THEN(DO)                   */
/* TCHK2     CPYF       FROMFILE(GDLWP02) TOFILE(GDLPP01) +         */
/* TCHK2                  MBROPT(*REPLACE) FMTOPT(*MAP *DROP)       */
/* TCHK2     MONMSG     MSGID(CPF0000)                              */
/* TCHK2     ENDDO                                                  */

/* TCHK4     IF         COND(&PSIRE *NE '0002') THEN(GOTO CMDLBL(END)) */
/* TCHK4 */  IF         COND(&PSIRE *NE '8990') THEN(GOTO CMDLBL(END))
             RTVMBRD    FILE(&WLIB/GDLWP10) NBRCURRCD(&KEN)
             IF         COND(&KEN *NE 0) THEN(DO)
             SNDNETF    FILE(&WLIB/GDLWP10) TOUSRID((QFILE SYSTEM1))

             /*------------------------------------------*/
             /*   ...SBMNETJOB rｮnﾝｰh ﾆﾞｭﾎﾞ ﾉ ncpｬc...   */
             /*------------------------------------------*/
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE SYSTEM1)) +
                          MBR(GDLT10)
             ENDDO

/* TCHK2 S */
             CLRPFM     FILE(GDLPP01)
             RTVMBRD    FILE(GDLWP02) NBRCURRCD(&KEN)
             IF         COND(&KEN *NE 0) THEN(DO)
             CPYF       FROMFILE(GDLWP02) TOFILE(GDLPP01) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* TCHK2 E */
 END:
             CHGVAR     VAR(&P1)    VALUE('2')
             CHGVAR     VAR(&P2)    VALUE(' ')
             CALL       PGM(GDLR99) PARM(&P1 &P2)

 END1:
 /* TCHK1    DLTDTAARA  DTAARA(HFILE1/GDLCACT) */
 /* TCHK1    MONMSG     MSGID(CPF2105)         */
 END2:

             ENDPGM
