             PGM
             /*** GDGC13 *****************************/
             /*  PRINT OF ORDER SHEET(TO ATC) PRINT  */
             /*    G.B.C                 98/01/12    */
             /*  MAMIYA&NANCY 2001.04.23 ADD DTAARA  */
             /*  ADD FILE LOCK AND UNLOCK PGM        */
             /*       07/19/01                       */
             /*  ADD PRINTER SELECTION    03/24/04   */
             /*  GDGR20 ->ASJOUTQ         05/13/04   */
             /* TCHK1 01/03/11 ADD ASJ WASHER ORDER KANBAN PROC */
             /* TCHK2 02/18/11 RMV ASJ WASHER ORDER KANBAN PROC */
             /* TCHK3 01/22/13 CHG SAKASHITA --> TFILE1         */
             /* TCHK4 08/07/14 ADD ASJ WORKING DATE CHECK       */
             /* JW  2026.01.20 CHG GCLSRC --> ACLSRC            */
             /****************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPGO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(1)

             DCL        VAR(&SYSNAME) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSYS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&PPGM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&WFILE1)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFILE2)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&ENDDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JNBR)    TYPE(*CHAR) LEN(6)

             DCL        VAR(&MBAN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRNTR)   TYPE(*CHAR) LEN(8)
/* TCHK4 */  DCL        VAR(&RSLT)    TYPE(*CHAR) LEN(1)

             RTVNETA    SYSNAME(&SYSNAME)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) NBR(&JNBR) DATE(&DATE)
/* CHECK DATE */
             RTVDTAARA  DTAARA(GDGC13DATE) RTNVAR(&ENDDATE)
             IF         COND(&DATE *EQ &ENDDATE) THEN(DO)
   STEP000:  SNDPGMMSG  MSG('THIS JOB OF TODAY ALREADY +
                          FINISHED.(C=CANCEL)') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *EQ 'C') GOTO @END
         /*  IF         (&KOTAE *EQ 'I') GOTO STEP001   */
             GOTO STEP000
             ENDDO

/* CHECK ORDER DATA */
             CALL       PGM(GDGR1Z) PARM('ATC' &REC)
             IF         COND(&REC  *EQ 0) THEN(DO)
             SNDBRKMSG  MSG('NO ORDER DATA TO ASJ.') TOMSGQ(&WSID)
             GOTO @END
             ENDDO


/* TCHK4 S */
             CALL       PGM(GDGR99) PARM(&RSLT)
             IF         COND(&RSLT *EQ '1') THEN(DO)
             SNDBRKMSG  MSG('TODAY ASJ NOT WORKING DAY. CANNOT ORDER +
                          PLEASE TRY AGAIN LATER.') TOMSGQ(&WSID)
             GOTO @END
             ENDDO
/* TCHK4 E */

   STEP001:
             CHGVAR     VAR(&WSYS) VALUE(%SST(&SYSNAME 1 3))
             CHGVAR     VAR(&WFILE1) VALUE('GDGWP13' *CAT &WSYS)
             CHGVAR     VAR(&WFILE2) VALUE('GDIWP13' *CAT &WSYS)
             CHGVAR     VAR(&PPGM) VALUE('GSTC80')


/* CHECK FILE LOCK   */
             CHGVAR     VAR(&FILE) VALUE('GDGPP10')
             CHGVAR     VAR(&ID) VALUE('1')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)
             IF         COND(&OK *EQ 'NO') THEN(DO)
             SNDBRKMSG  MSG('SOMEONE ELSE IS USING THE ORDER FILE. +
                          PLEASE TRY AGAIN LATER.') TOMSGQ(&WSID)
             GOTO @END
             ENDDO

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)

             CHKOBJ     OBJ(TRANS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(TRANS) TYPE(*CHAR) +
                          LEN(2) TEXT('IAF->ASJ TRANSFER CHECK'))
             CHKOBJ     OBJ(TRANSA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(TRANSA) TYPE(*CHAR) +
                          LEN(2) TEXT('IAF->ATC TRANSFER CHECK'))

             CHGVAR     VAR(&PPGO) VALUE('  ')
             CALL       PGM(GDGR12) PARM(&PPUSER &PPGO &PRNTR 'ATC')




     /** &PPGP='GO' START *******************************************/
             IF         COND(&PPGO = 'GO') THEN(DO)

             DLTF       FILE(&WFILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&WFILE1) RCDLEN(160) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/GDGWPE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDGWPE1) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

       /*  MSK 2004.11.10  */
             DLTF       FILE(&WLIB/GDGWP9Y)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDGWP9Y) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/GDGWP9Z)) +
                          OUTFILE(&WLIB/GDGWP9Y) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDGSY1) +
                          OPTION(*NOPRT)

             CHKOBJ     OBJ(&WLIB/GDGPPY1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)

             CRTPF      FILE(&WLIB/GDGPPY1) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(GDGPPY1) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)
             ENDDO

             CALL  GDGRY1
             CLRPFM     FILE(&WLIB/GDGWP9Z)
       /*------------------*/

             OVRPRTF    FILE(GDGPR13) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(&PRNTR) +
                          FORMTYPE(K6S1)
             OVRPRTF    FILE(GDGPR14) DEVTYPE(*SCS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(GDOUTQ) +
                          FORMTYPE(K6H1) HOLD(*NO)  SAVE(*YES)
             OVRDBF     FILE(GDGWP13) TOFILE(&WLIB/&WFILE1)

             CALL       PGM(GDGR13) PARM(&SYSNAME 'ATC')

     /* IAF-S */
             IF         COND(&SYSNAME *EQ 'IAF     ') THEN(DO)
             SNDNETSPLF FILE(GDGPR14) TOUSRID((V0035 SYSTEM7)) +
                          SPLNBR(*LAST) DTAFMT(*ALLDATA)
             MONMSG     MSGID(CPF3309 CPF0000)
             DLTSPLF    FILE(GDGPR14) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3309 CPF0000)
             ENDDO
     /* IAF-E */

/* TCHK3     CPYF       FROMFILE(GDGPP10) TOFILE(SAKASITA/GDGPP10) + */
/* TCHK3 */  CPYF       FROMFILE(GDGPP10) TOFILE(HFILE1/GDGPP10@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

/* TCHK2 TCHK1    CALL       PGM(GDMC320) */

    /******* CLRPFM FILE(GDGPP10) ********/
    /* GDGWP13 --> GDGPP10 <DELET>  */
             OVRDBF     FILE(GDGWP13) TOFILE(&WLIB/&WFILE1)
             CALL       PGM(GDGR1D)


             CLRPFM     FILE(GDIWP10)
             CALL       PGM(GDIR14)
             CPYF       FROMFILE(GDIWP10) TOFILE(GDIPP10) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(&WFILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&WFILE2) RCDLEN(150) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/GDGWPE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDGWPE2) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRPRTF    FILE(GDIPR13) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(&PRNTR) +
                          FORMTYPE(K6S1)
             OVRPRTF    FILE(GDIPR14) DEVTYPE(*SCS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(GDOUTQ) +
                          FORMTYPE(K6H1)  HOLD(*NO) SAVE(*YES)
             OVRDBF     FILE(GDIWP13) TOFILE(&WLIB/&WFILE2)

             CALL       PGM(GDIR13) PARM(&SYSNAME)

     /* IAF-S */
             IF         COND(&SYSNAME *EQ 'IAF     ') THEN(DO)
             SNDNETSPLF FILE(GDIPR14) TOUSRID((V0035 SYSTEM7)) +
                          SPLNBR(*LAST) DTAFMT(*ALLDATA)
             MONMSG     MSGID(CPF3309 CPF0000)
             DLTSPLF    FILE(GDIPR14) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3309 CPF0000)
             ENDDO
     /* IAF-E */

             CLRPFM FILE(GDIPP10)

             DLTOVR     FILE(*ALL)


     /* IAF-S */
             IF         COND(&SYSNAME *EQ 'IAF     ') THEN(DO)

             RTVMBRD    FILE(&WLIB/&WFILE1) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(SNDNETF +
                          FILE(&WLIB/&WFILE1) TOUSRID((QFILE SYSTEM7)))
          /* RTVMBRD    FILE(&WLIB/&WFILE2) NBRCURRCD(&REC)             */
          /* IF         COND(&REC *NE 0) THEN(SNDNETF +                 */
          /*              FILE(&WLIB/&WFILE2) TOUSRID((QFILE SYSTEM7))) */

             /*------------------------------------------*/
             /*   ...SBMNETJOB rｮnﾝｰh ﾆﾞｭﾎﾞ ﾉ ncpｬc...   */
             /*------------------------------------------*/
             DLTF       FILE(&WLIB/GDGT13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HSRC1/ACLSRC) +
                          TOFILE(&WLIB/GDGT13) FROMMBR(GDGT13) +
                          CRTFILE(*YES)

             CALL       PGM(GDGR14) PARM(&WFILE1 &PPGM)

             CPYF       FROMFILE(&WLIB/GDGT13) +
                          TOFILE(HSRC1/ACLSRC) TOMBR(GDGT13) +
                          MBROPT(*REPLACE)

          /* SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE + */
          /*              SYSTEM1)) MBR(GDGT13)             */

             CALL       PGM(GDGR14) PARM(&WFILE2 &PPGM)

             CPYF       FROMFILE(&WLIB/GDGT13) +
                          TOFILE(HSRC1/ACLSRC) TOMBR(GDGT13) +
                          MBROPT(*REPLACE)

          /* SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE + */
          /*              SYSTEM1)) MBR(GDGT13)             */

             ENDDO
     /* IAF-E */

             CHGDTAARA  DTAARA(TRANSA) VALUE('  ')
             CHGDTAARA  DTAARA(GDGC13DATE) VALUE(&DATE)

             ENDDO
     /** &PPGP='GO' END *********************************************/

             /*----------------------------*/
             /*   シッピング情報の更新   */
             /*----------------------------*/
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&WLIB/GIGWP52) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             OVRDBF     FILE(INFILE) TOFILE(&WLIB/GIGWP52)
             OVRPRTF    FILE(QPRINT) OVRFLW(52) OUTQ(ASJOUTQ) +
                          FORMTYPE(K6H1)
             CALL       PGM(GDGR20) PARM(&PPUSER)
             DLTOVR     FILE(*ALL)
             CLRPFM     FILE(&WLIB/GIGWP52)
             ENDDO

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&WLIB/GIGWP53) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             OVRDBF     FILE(INFILE) TOFILE(&WLIB/GIGWP53)
             OVRPRTF    FILE(QPRINT) OVRFLW(52) OUTQ(ASJOUTQ) +
                          FORMTYPE(K6H1)
             CALL       PGM(GDIR20) PARM(&PPUSER)
             DLTOVR     FILE(*ALL)
             CLRPFM     FILE(&WLIB/GIGWP53)
             ENDDO
 /* UNLOCK */
             CHGVAR     VAR(&FILE) VALUE('GDGPP10')
             CHGVAR     VAR(&ID) VALUE('2')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)

 @END:

             ENDPGM
