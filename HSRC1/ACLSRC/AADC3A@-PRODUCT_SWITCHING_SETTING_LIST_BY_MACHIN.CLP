             PGM
/** AADC31 ************************************************/
/*  機番別品種切替設定リストの作成<CL>                  */
/*                 K.YASUDA   94.05.10                    */
/* TCHK1 06/24/09 CHG ASJ SOURCE CONVERT                  */
/************************************************ AADC31 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
/* TCHK1 */  DCL        VAR(&WKSID) TYPE(*CHAR) LEN(03)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USME) TYPE(*CHAR) LEN(15)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(APLR00) PARM(&USER &USME)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
/* TCHK1 */  CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))
             CHGVAR     VAR(&FILE1) VALUE('AADWP30' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('AADWP31' *CAT &WS)
             CHGVAR     VAR(&FILE3) VALUE('AADWP3A' *CAT &WS)

             DLTF       FILE(&WLIB/&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK1     CRTPF      FILE(&WLIB/&FILE3) RCDLEN(256) + */
/* TCHK1 */  CRTPF      FILE(&WLIB/&FILE3) RCDLEN(020) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AADWP3A) TOFILE(&FILE3)

             /*  ﾍlﾑco mﾞｰj  ﾝｰh s pｬcﾒｭh  */
             CALL       PGM(AADR35) PARM(&PRN &LST &OUT)
             IF         COND(%SWITCH(XXXX0XXX)) THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
             /*  ﾝｰh ﾎｦbﾓ ﾅhﾈb  */
                   /*  AADWP30 & AADWP31  */

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AADWP30) TOFILE(&FILE1)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AADWP31) TOFILE(&FILE2)

             CHGJOB     RUNPTY(40) SWS(00000000)

             CALL       PGM(AADR30) PARM(&LST)
             CALL       PGM(AADR3A) PARM(&LST)

             RTVMBRD    FILE(&FILE1) NBRCURRCD(&KEN)
             IF         COND(&KEN *EQ 0) THEN(GOTO SKIP)
             /*  ﾒﾇnﾌｮﾃc PGM  */
                    /* A = AADR31 / B = AADR32 */

             IF         (&LST *EQ 'B') GOTO STEP3

             IF         (&PRN *EQ '2') GOTO STEP2
             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AADS30) +
                          OPTION(*NOPRT)
             GOTO       STEP5

 STEP2:      FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AADS31) +
                          OPTION(*NOPRT)

 STEP5:
/* TCHK1     IF         (&OUT *EQ 'B') GOTO END */
/* TCHK1 */  IF         (&OUT *EQ 'B') THEN(DO)
             CHKOBJ     OBJ(AADWP31W) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(AADWP31W) MBR(&WKSID))
             CLRPFM     FILE(AADWP31W) MBR(&WKSID)
             OVRDBF     FILE(AADWP31W) TOFILE(AADWP31W) MBR(&WKSID)
             CALL       PGM(AADR31W)
             GOTO       END
             ENDDO

             OVRPRTF    FILE(QPRINT) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(AADR31) PARM(&PRN)
             GOTO       END

 STEP3:      IF         (&PRN *EQ '2') GOTO STEP4
             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AADS3A) +
                          OPTION(*NOPRT)
             GOTO       STEP6

 STEP4:      FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AADS3B) +
                          OPTION(*NOPRT)

 STEP6:
/* TCHK1     IF         (&OUT *EQ 'B') GOTO END */
/* TCHK1 */  IF         (&OUT *EQ 'B') THEN(DO)
             CHKOBJ     OBJ(AADWP32W) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(AADWP32W) MBR(&WKSID))
             CLRPFM     FILE(AADWP32W) MBR(&WKSID)
             OVRDBF     FILE(AADWP32W) TOFILE(AADWP31W) MBR(&WKSID)
             CALL       PGM(AADR32W)
             GOTO       END
             ENDDO

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          OVRFLW(60) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES)

             CALL       PGM(AADR32) PARM(&PRN)

             CHGJOB     RUNPTY(20)
             DLTF       &FILE1
          /* DLTF       &FILE2 */
             GOTO       CMDLBL(END)
 SKIP:       SNDPGMMSG  MSG('NO PRINTING DATA.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO)
 END:        DLTOVR     FILE(*ALL)
          /* DLTF       &FILE3 */
             ENDPGM
