             PGM
             /*** AAVC40 ***************/
             /*  在庫推移調査リスト  */
             /*  A.IDOTA   1990.01.19  */
             /*************** AAVC40 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9) /* WORK FILE1 */
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9) /* WORK FILE2 */
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9) /* WORK FILE3 */
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSNO 1 2))
             CHGVAR     VAR(&FILE1) VALUE('AAVWP40' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('AAVWP41' *CAT &WT)
             CHGVAR     VAR(&FILE3) VALUE('AAVWP42' *CAT &WT)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

/* 画面指定 */
             DLTF       FILE(QTEMP/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(5000 2000 3) LVLCHK(*NO)

/* MSK 98.04.03 */
             CRTDUPOBJ  OBJ(AAVPP40) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AAVPP40)
             MONMSG     MSGID(CPF0000)


             OVRDBF     FILE(AAVPP40) TOFILE(QTEMP/AAVPP40)

             OVRDBF     FILE(AAVWP40) TOFILE(QTEMP/&FILE1)
             CALL       PGM(AAVR40)
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
             DLTF       FILE(QTEMP/&FILE1)
             GOTO       END
             ENDDO

/* データ作成 */
             DLTF       FILE(QTEMP/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(5000 2000 3) LVLCHK(*NO)
             OVRDBF     FILE(AAVWP41) TOFILE(QTEMP/&FILE2)
             CALL       PGM(AAVR41)
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
             DLTF       FILE(QTEMP/&FILE1)
             DLTF       FILE(QTEMP/&FILE2)
             GOTO       END
             ENDDO

 /* ＳＯＲＴ */
             DLTF       FILE(QTEMP/&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/&FILE3) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(5000 2000 3) LVLCHK(*NO)
             FMTDTA     INFILE((QTEMP/&FILE2)) OUTFILE(QTEMP/&FILE3) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAVS40) +
                          OPTION(*NOPRT) /* nﾃﾜﾌﾞ]k｣ﾍ]ﾌﾞ] */
  /* リスト印刷 */
             OVRPRTF    FILE(AAVPR40) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES) IGCDTA(&PIGCD)
             OVRDBF     FILE(AAVWP42) TOFILE(QTEMP/&FILE3)
             CALL       PGM(AAVR42)

             DLTF       FILE(QTEMP/&FILE1)
             DLTF       FILE(QTEMP/&FILE2)
             DLTF       FILE(QTEMP/&FILE3)

 END:        DLTOVR     FILE(*ALL)
             ENDPGM
