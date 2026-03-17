             PGM
             /** GCEC30 ********************************************/
             /* .. ISSUE LABEL DISPLAYING DAILY SHIPMENT OF AN ADDRESS */
             /*           A-IDOTA           1987.08.22             */
             /**********************************************GCEC30**/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SKUB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WS)
             CHGJOB     RUNPTY(40) SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
 STP1:
             MONMSG     MSGID(CPF9999)
             CHGJOB     OUTQ(&PRT)
 /* 品番マスターの作成 */
              CALL       PGM(GCER30) PARM(&SKUB)
              IF         (%SWITCH(1XXXXXXX)) GOTO END
              /******/
  /* 専用品番マスターの作成 */
              IF         COND(&SKUB = 'Y') THEN(DO)
              CLRPFM     FILE(GCENP30)
              CALL       PGM(GCER33)
           /* CALL       PGM(GCER34) */
              ENDDO
              /******/
  /* ラベルの内容作成 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) OVRFLW(63) +
                          RPLUNPRT(*YES) OUTQ(QPRINTC) +
                          FORMTYPE(K6S1) HOLD(*YES) /* KANBAN +
                          UNMATCH LIST */
              CALL       PGM(GCER32)
              DLTOVR     FILE(QPRINT)
              DLTF       FILE(GCEWP31)
              MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCEWP31) RCDLEN(100) +
                          TEXT('ISSUE LABEL DISPLAYING DAILY +
                          SHIPMENT OF AN ADD') OPTION(*NOLIST) +
                          SIZE(5000) LVLCHK(*NO)
             DLTF       FILE(GCEWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GCEWP32) RCDLEN(100) +
                          TEXT('ISSUE LABEL DISPLAYING DAILY +
                          SHIPMENT OF AN ADD') OPTION(*NOLIST) +
                          SIZE(5000) LVLCHK(*NO)
             /******/
 /* 差のチェック */
             CALL       PGM(GCER36)
             FMTDTA     INFILE((HWFILE1/GCEWP31)) +
                          OUTFILE(HWFILE1/GCEWP32) SRCFILE(FMTSRC) +
                          SRCMBR(GCES31) OPTION(*NOPRT)
          /* DLTF       FILE(GCEWP31) */
             /******/
 /* ラベルの発行 */
             OVRPRTF    FILE(GCEPR30) DEVTYPE(*AFPDS) LPI(6) +
                          FOLD(*YES) RPLUNPRT(*YES) OUTQ(QPRINTC) +
                          FORMTYPE(D997) /* nﾃﾜﾌﾞ]kﾍajﾒﾆｬｮf [sﾞﾓ */
             MONMSG     MSGID(CPF5004)
             CALL       PGM(GCER31)
             DLTOVR     FILE(GCEPR30)
             CLRPFM     FILE(GCEWP30)
          /* DLTF       FILE(GCEWP32)  */

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
