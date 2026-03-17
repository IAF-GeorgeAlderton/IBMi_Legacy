             PGM
             /*** GDGC87 *************************************/
             /*  REQUEST OF RE-PRINT ASJ KANBAN DATA PRODUCT */
             /*      GBC                    2004.01.13       */
             /*      K.YASUDA               2004.04.21       */
             /* ------------------------------------------   */
             /* JW  2026.01.20 CHG GCLSRC --> ACLSRC          */
             /************************************************/
             DCLF       FILE(GDGPW8A)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(1)

             DCL        VAR(&SYSNAME) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSYS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WFILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPGM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE)   TYPE(*CHAR) LEN(6)


             RTVNETA    SYSNAME(&SYSNAME)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DATE)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&WSYS) VALUE(%SST(&SYSNAME 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)

/*  DTAARA CHECK  */
             CHKOBJ     OBJ(GDGC87ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO STP1)
             SNDBRKMSG  MSG('SOMEONE ELSE IS USING THE MENU. +
                          PLEASE TRY AGAIN LATER.') TOMSGQ(&WSID)
             GOTO @END

 STP1:       CRTDTAARA  DTAARA(GDGC87ACT) TYPE(*CHAR) LEN(10)

             CLRPFM     FILE(&WLIB/GDGWP89) /* ASJ KANNBANN REISSUE +
                          REQUEST */
             CLRPFM     FILE(&WLIB/GDGWP87) /* OFF-LINE KANBAN ISSUE +
                          REQUEST */

 STEP0:      CHGVAR     VAR(&@NO) VALUE(' ')
             SNDRCVF    DEV(&WSID) RCDFMT(GDGPW8A1)
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(STEP4))

             IF         (&@NO *EQ '1') GOTO STEP1
             IF         (&@NO *EQ '2') GOTO STEP2
       /*    IF         (&@NO *EQ '3') GOTO STEP3   */
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('INCORRECT INPUT NUMBER')
             GOTO       STEP0

             /*-----------------------------------------*/
             /*  ...KANBAN REISSUE REQUEST...           */
             /*-----------------------------------------*/

/* CHECK FILE LOCK   */
STEP1:       CHGVAR     VAR(&FILE) VALUE('GDGWP89')
             CHGVAR     VAR(&ID) VALUE('1')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)

             IF         COND(&OK *EQ 'NO') THEN(DO)
             SNDBRKMSG  MSG('SOMEONE ELSE IS USING THE ORDER FILE. +
                          PLEASE TRY AGAIN LATER.') TOMSGQ(&WSID)
             GOTO @END
             ENDDO

             CALL       PGM(GDGR89) PARM(&SYSNAME)
             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)
 /* UNLOCK */
             CHGVAR     VAR(&ID) VALUE('2')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)

             GOTO       STEP0
             ENDDO

             GOTO       STEP4

             /*-----------------------------------------*/
             /*  ...OFF-LINE KANBAN ISSUE REQUEST...    */
             /*-----------------------------------------*/

/* CHECK FILE LOCK   */
STEP2:       CHGVAR     VAR(&FILE) VALUE('GDGWP87')
             CHGVAR     VAR(&ID) VALUE('1')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)

             IF         COND(&OK *EQ 'NO') THEN(DO)
             SNDBRKMSG  MSG('SOMEONE ELSE IS USING THE ORDER FILE. +
                          PLEASE TRY AGAIN LATER.') TOMSGQ(&WSID)
             GOTO @END
             ENDDO

             CALL       PGM(GDGR87) PARM(&SYSNAME)
             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)
 /* UNLOCK */
             CHGVAR     VAR(&ID) VALUE('2')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)

             GOTO       STEP0
             ENDDO

             GOTO       STEP4

             /*-----------------------------------------*/
             /*  ...SPECIAL ORDER...                    */
             /*-----------------------------------------*/
STEP3:       GOTO       STEP4

             /*-----------------------------------------*/
             /*  ...KANBAN REISSUE REQUEST...           */
             /*-----------------------------------------*/
 STEP4:      RTVMBRD    FILE(&WLIB/GDGWP89) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)

             CHGVAR     VAR(&WFILE1) VALUE('GDGWP8A' *CAT &WSYS)
             DLTF       FILE(&WLIB/&WFILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&WFILE1) RCDLEN(150) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)


             OVRPRTF    FILE(GDGPR89) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1) HOLD(*YES)

             CHGVAR     VAR(&PRTF) VALUE('GDGPR8A')
             OVRPRTF    FILE(&PRTF) DEVTYPE(*SCS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(GDOUTQ) +
                          FORMTYPE(K6H1) HOLD(*NO)
             OVRDBF     FILE(GDGWP8A) TOFILE(&WLIB/&WFILE1)

             CALL       PGM(GDGR8A) PARM(&SYSNAME)

             DLTSPLF    FILE(GDGPR89) SPLNBR(*LAST)
             SNDNETF    FILE(&WLIB/&WFILE1) TOUSRID((QFILE +
                          SYSTEM1))

             SNDNETSPLF FILE(&PRTF) TOUSRID((V0035 SYSTEM1)) +
                          SPLNBR(*LAST) DTAFMT(*ALLDATA)
             DLTSPLF    FILE(&PRTF) SPLNBR(*LAST)
             /*------------------------------------------*/
             /*   ...SBMNETJOB rｮnﾝｰh ﾆﾞｭﾎﾞ ﾉ ncpｬc...   */
             /*------------------------------------------*/
             /*---------------------------------*/
             /*   ...rｮnﾝｰh ﾎﾟﾜhﾞ[w ﾉ s]ﾃc...   */
             /*---------------------------------*/
             CHGVAR     VAR(&PPGM) VALUE('GSTC81')
             DLTF       FILE(&WLIB/GDGT13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HSRC1/ACLSRC) +
                          TOFILE(&WLIB/GDGT13) FROMMBR(GDGT13) +
                          CRTFILE(*YES)

             CALL       PGM(GDGR14) PARM(&WFILE1 &PPGM)

             CPYF       FROMFILE(&WLIB/GDGT13) +
                          TOFILE(HSRC1/ACLSRC) TOMBR(GDGT13) +
                          MBROPT(*REPLACE)

             DLTF       FILE(&WLIB/GDGT13)
             MONMSG     MSGID(CPF3261 CPF2105)

             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE +
                          SYSTEM1)) MBR(GDGT13)

             ENDDO

             /*-----------------------------------------*/
             /*  ...OFF-LINE KANBAN ISSUE REQUEST...    */
             /*-----------------------------------------*/

             RTVMBRD    FILE(&WLIB/GDGWP87) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)

             CHGVAR     VAR(&WFILE1) VALUE('GDGWP88' *CAT &WSYS)
             DLTF       FILE(&WLIB/&WFILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&WFILE1) RCDLEN(150) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRPRTF    FILE(GDGPR87) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1) HOLD(*YES)

             CHGVAR     VAR(&PRTF) VALUE('GDGPR88')
             OVRPRTF    FILE(&PRTF) DEVTYPE(*SCS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(GDOUTQ) +
                          FORMTYPE(K6H1) HOLD(*NO)
             OVRDBF     FILE(GDGWP88) TOFILE(&WLIB/&WFILE1)

             CALL       PGM(GDGR88) PARM(&SYSNAME &PPUSER)

             DLTSPLF    FILE(GDGPR87) SPLNBR(*LAST)
             SNDNETF    FILE(&WLIB/&WFILE1) TOUSRID((QFILE +
                          SYSTEM1))

             SNDNETSPLF FILE(&PRTF) TOUSRID((V0035 SYSTEM1)) +
                          SPLNBR(*LAST) DTAFMT(*ALLDATA)
             DLTSPLF    FILE(&PRTF) SPLNBR(*LAST)
             /*------------------------------------------*/
             /*   ...SBMNETJOB rｮnﾝｰh ﾆﾞｭﾎﾞ ﾉ ncpｬc...   */
             /*------------------------------------------*/
             /*---------------------------------*/
             /*   ...rｮnﾝｰh ﾎﾟﾜhﾞ[w ﾉ s]ﾃc...   */
             /*---------------------------------*/
             CHGVAR     VAR(&PPGM) VALUE('GSTC81')
             DLTF       FILE(&WLIB/GDGT13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HSRC1/ACLSRC) +
                          TOFILE(&WLIB/GDGT13) FROMMBR(GDGT13) +
                          CRTFILE(*YES)

             CALL       PGM(GDGR14) PARM(&WFILE1 &PPGM)

             CPYF       FROMFILE(&WLIB/GDGT13) +
                          TOFILE(HSRC1/ACLSRC) TOMBR(GDGT13) +
                          MBROPT(*REPLACE)

             DLTF       FILE(&WLIB/GDGT13)
             MONMSG     MSGID(CPF3261 CPF2105)

             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE +
                          SYSTEM1)) MBR(GDGT13)

             ENDDO

             /*-----------------------------------------*/
             /*  ...SPECIAL ORDER...                    */
             /*-----------------------------------------*/

             DLTOVR     FILE(*ALL)

 /* UNLOCK */
             CHGVAR     VAR(&ID) VALUE('2')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)

             DLTDTAARA  DTAARA(GDGC87ACT)

 @END:

             ENDPGM
