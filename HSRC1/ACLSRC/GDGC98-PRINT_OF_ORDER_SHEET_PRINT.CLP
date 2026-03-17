             PGM
             /*** GDGC12 *****************************/
             /*  PRINT OF ORDER SHEET       / PRINT  */
             /*    G.B.C                 98/01/12    */
             /*  GDGR20 ->ASJOUTQ         05/13/04   */
             /* ----------------------------------   */
             /* JW  2026.01.20 CHG GCLSRC --> ACLSRC */
             /****************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPGO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&WFILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSNAME) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSYS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DATE)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&ENDDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PPGM) TYPE(*CHAR) LEN(6)

             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)

             RTVNETA    SYSNAME(&SYSNAME)
             RTVJOBA    JOB(&WSID) USER(&PPUSER)
/* CHECK DATE */
             RTVDTAARA  DTAARA(GDGC12DATE) RTNVAR(&ENDDATE)
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


   STEP001:
             CHGVAR     VAR(&WSYS) VALUE(%SST(&SYSNAME 1 3))
             CHGVAR     VAR(&WFILE1) VALUE('GDGWP13' *CAT &WSYS)
             CHGVAR     VAR(&WFILE2) VALUE('GDIWP13' *CAT &WSYS)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)

             OVRPRTF    FILE(GDIPR13) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(GDIR13) PARM(&PPUSER)
             CLRPFM     FILE(GDIPP10)
             DLTOVR     FILE(*ALL)

             SNDNETF    FILE(&WLIB/&WFILE1) TOUSRID((QFILE SYSTEM1))
             SNDNETF    FILE(&WLIB/&WFILE2) TOUSRID((QFILE SYSTEM1))

             /*------------------------------------------*/
             /*   ...SBMNETJOB rｮnﾝｰh ﾆﾞｭﾎﾞ ﾉ ncpｬc...   */
             /*------------------------------------------*/
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE SYSTEM1)) +
                          MBR(GDGT13)

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
             OVRPRTF    FILE(QPRINT) OVRFLW(52) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)
             CALL       PGM(GDIR20) PARM(&PPUSER)
             DLTOVR     FILE(*ALL)
             CLRPFM     FILE(&WLIB/GIGWP53)
             ENDDO

 @END:
             ENDPGM
