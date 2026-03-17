             PGM
/*** GTBC12 ************************************************/
/* PRINT OF ORDER SHEET                                    */
/*    G.B.C                 98/01/12                       */
/*                                                         */
/* TCHK  10/05/12 CREATE(COPY FROM GDGC12)                 */
/***********************************************************/
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
             DCL        VAR(&WSYS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PPGM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WFILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&ENDDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JNBR) TYPE(*CHAR) LEN(6)

             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRNTR) TYPE(*CHAR) LEN(8)

             RTVNETA    SYSNAME(&SYSNAME)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) NBR(&JNBR) DATE(&DATE)
/* CHECK DATE */
             RTVDTAARA  DTAARA(GTBC12DATE) RTNVAR(&ENDDATE)
             IF         COND(&DATE *EQ &ENDDATE) THEN(DO)
   STEP000:  SNDPGMMSG  MSG('THIS JOB OF TODAY ALREADY +
                          FINISHED.(C=CANCEL)') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *EQ 'C') GOTO @END
             GOTO STEP000
             ENDDO

   STEP001:
/* CHECK FILE LOCK   */
             CHGVAR     VAR(&FILE) VALUE('GTBPP10')
             CHGVAR     VAR(&ID) VALUE('1')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)
             IF         COND(&OK *EQ 'NO') THEN(DO)
             SNDBRKMSG  MSG('SOMEONE ELSE IS USING THE ORDER FILE. +
                          PLEASE TRY AGAIN LATER.') TOMSGQ(&WSID)
             GOTO @END
             ENDDO

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)


             CHGVAR     VAR(&PPGO) VALUE('  ')
             CALL       PGM(GTBR12) PARM(&PPUSER &PPGO &PRNTR)

             IF         COND(&PPGO = 'GO') THEN(DO)

             DLTF       FILE(&WLIB/GTBWPE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GTBWPE1) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

       /*  MSK 2004.11.10  */
             DLTF       FILE(&WLIB/GTBWP9Y)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GTBWP9Y) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/GTBWP9Z)) +
                          OUTFILE(&WLIB/GTBWP9Y) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GTBSY1) +
                          OPTION(*NOPRT)

             CHKOBJ     OBJ(&WLIB/GTBPPY1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)

             CRTPF      FILE(&WLIB/GTBPPY1) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(GTBPPY1) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)
             ENDDO

             CALL       PGM(GTBRY1)

             CLRPFM     FILE(&WLIB/GTBWP9Z)

             CLRPFM     FILE(&WLIB/GTBWP13)
             OVRDBF     FILE(GTBWP13) TOFILE(&WLIB/GTBWP13)

             CALL       PGM(GTBR13)

             CPYF       FROMFILE(GTBPP10) TOFILE(TFILE1/GTBPP10) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

             CLRPFM FILE(GTBPP10)

             CHGDTAARA  DTAARA(GTBC12DATE) VALUE(&DATE)

             ENDDO

 /* UNLOCK */
             CHGVAR     VAR(&FILE) VALUE('GTBPP10')
             CHGVAR     VAR(&ID) VALUE('2')
             CALL       PGM(GDGR00) PARM(&FILE &OK &ID)

 @END:

             ENDPGM
