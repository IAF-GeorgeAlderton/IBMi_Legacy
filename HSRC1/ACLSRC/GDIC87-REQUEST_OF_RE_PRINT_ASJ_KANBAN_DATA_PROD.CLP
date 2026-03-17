             PGM
             /*** GDIC87 *************************************/
             /*  REQUEST OF RE-PRINT ASJ KANBAN DATA PRODUCT */
             /*       2004.01.13                             */
             /* ------------------------------------------   */
             /* JW  2026.01.20 CHG GCLSRC --> ACLSRC         */
             /************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(1)

             DCL        VAR(&SYSNAME) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSYS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WFILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPGM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE)   TYPE(*CHAR) LEN(6)


             RTVNETA    SYSNAME(&SYSNAME)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DATE)

             CHGVAR     VAR(&WSYS) VALUE(%SST(&SYSNAME 1 3))
             CHGVAR     VAR(&WFILE1) VALUE('GDIWP88' *CAT &WSYS)
             CHGVAR     VAR(&PPGM) VALUE('GSTC81')


/* CHECK FILE LOCK   */
             CHGVAR     VAR(&FILE) VALUE('GDIWP87')
             CHGVAR     VAR(&ID) VALUE('1')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)
             IF         COND(&OK *EQ 'NO') THEN(DO)
             SNDBRKMSG  MSG('SOMEONE ELSE IS USING THE ORDER FILE. +
                          PLEASE TRY AGAIN LATER.') TOMSGQ(&WSID)
             GOTO @END
             ENDDO

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)


             DLTF       FILE(GDIWP87)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDIWP87) SRCFILE(HSRC1/ADDSSRC) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WFILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&WFILE1) RCDLEN(150) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(GDIWP87) TOFILE(&WLIB/GDIWP87)

             CALL       PGM(GDIR87) PARM(&SYSNAME)

             RTVMBRD    FILE(&WLIB/GDIWP87) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@SKIP))


          /* OVRPRTF    FILE(GDIPR88)  PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(QPRINTE) +
                          FORMTYPE(K6S1)  */
             OVRPRTF    FILE(GDIPR88) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1) HOLD(*YES)
             OVRDBF     FILE(GDIWP88) TOFILE(&WLIB/&WFILE1)

             CALL       PGM(GDIR88) PARM(&SYSNAME)

       /*    SNDNETF    FILE(&WLIB/&WFILE1) TOUSRID((QFILE +
                          SYSTEM1))   */
             /*------------------------------------------*/
             /*   ...SBMNETJOB rｮnﾝｰh ﾆﾞｭﾎﾞ ﾉ ncpｬc...   */
             /*------------------------------------------*/
             /*---------------------------------*/
             /*   ...rｮnﾝｰh ﾎﾟﾜhﾞ[w ﾉ s]ﾃc...   */
             /*---------------------------------*/
             /*---------------------------------*/
             /* GDGT13 WO GDGTTT NI HENKOU SURU.TEST NO TAME  */
             /* GDGR14 NO NAIBU MO HENKOU SURU.           */
             /*---------------------------------*/
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

         /*  SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE +
                          SYSTEM1)) MBR(GDGT13)   */


 @SKIP:
             DLTOVR     FILE(*ALL)

 /* UNLOCK */
             CHGVAR     VAR(&FILE) VALUE('GDIWP87')
             CHGVAR     VAR(&ID) VALUE('2')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)

 @END:

             ENDPGM
