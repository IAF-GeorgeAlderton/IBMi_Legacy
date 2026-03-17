             PGM
             /** GCEC3A ********************************************/
             /* .. ISSUE LABEL DISPLAYING DAILY SHIPMENT OF AN ADDRESS */
             /*           A-IDOTA           1987.08.22             */
             /*           H-AMANO           2003.04.09             */
             /*                                                    */
             /* TCHK1 03/28/07 CHG GCEWP32 QTEMP ---> HWFILE1      */
             /* TCHK2 07/09/07 RMV GCER3C(PRINT PROCESS)           */
             /* TCHK3 08/10/07 ADD FINAL PROCESS 'JC','KRO' 1/2 HAKO */
             /**********************************************GCEC3A**/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SKUB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SLCT) TYPE(*CHAR) LEN(1)
/*JW*/       DCL        VAR(&OPT8) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WS)
             CHGJOB     RUNPTY(40) SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
 STP1:
             MONMSG     MSGID(CPF9999)
             CHGJOB     OUTQ(&PRTG)
 /* 品番マスターの作成 */
    /*JW      CALL       PGM(GCER30) PARM(&SKUB &SLCT)      */
    /*JW*/    CALL       PGM(GCER30) PARM(&SKUB &SLCT &OPT8)
              IF         (%SWITCH(1XXXXXXX)) GOTO END
              /******/

  /* 専用品番マスターの作成 */
              IF         COND(&SKUB = 'Y') THEN(DO)
              CLRPFM     FILE(GCENP30)
              CALL       PGM(GCER33)
              ENDDO
              /******/
  /* ラベルの内容作成 */
             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) OVRFLW(63) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) HOLD(*YES) /* KANBAN +
                          UNMATCH LIST */
             CALL       PGM(GCER3A) PARM(&SLCT)
              DLTOVR     FILE(QPRINT)
              DLTF       FILE(QTEMP/GCEWP31)
              MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/GCEWP31) RCDLEN(100) +
                          TEXT('ISSUE LABEL DISPLAYING DAILY +
                          SHIPMENT OF AN ADD') OPTION(*NOLIST) +
                          SIZE(5000) LVLCHK(*NO)
/* TCHK1     DLTF       FILE(QTEMP/GCEWP32) */
/* TCHK1 */  DLTF       FILE(HWFILE1/GCEWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK1     CRTPF      FILE(QTEMP/GCEWP32) RCDLEN(100) + */
/* TCHK1 */  CRTPF      FILE(HWFILE1/GCEWP32) RCDLEN(100) +
                          TEXT('ISSUE LABEL DISPLAYING DAILY +
                          SHIPMENT OF AN ADD') OPTION(*NOLIST) +
                          SIZE(5000) LVLCHK(*NO)
/* TCHK3 */  DLTF       FILE(HWFILE1/GCEWP34)
/* TCHK3 */  MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK3 */  CRTPF      FILE(HWFILE1/GCEWP34) RCDLEN(100) +
                          TEXT('ISSUE LABEL DISPLAYING DAILY +
                          SHIPMENT OF AN ADD #2') OPTION(*NOLIST) +
                          SIZE(5000) LVLCHK(*NO)
             /******/
 /* 差のチェック */
             CALL       PGM(GCER3B)
/* JW1 ADJUST GCEWP31 BOX/DAY VALUE  */
              IF         COND(&OPT8 = 'Y') THEN(DO)
              CALL       PGM(GCER3E)
              CALL       PGM(GCER3F)
              ENDDO

/* TCHK1     FMTDTA     INFILE((QTEMP/GCEWP31)) +
                          OUTFILE(QTEMP/GCEWP32) SRCFILE(FMTSRC) +
                          SRCMBR(GCES31) OPTION(*NOPRT) */
/* TCHK1 */  FMTDTA     INFILE((QTEMP/GCEWP31)) +
                          OUTFILE(HWFILE1/GCEWP32) SRCFILE(FMTSRC) +
                          SRCMBR(GCES31) OPTION(*NOPRT)
             /******/

/* TCHK3 */  CALL       PGM(GCER3D)

             /******/
 /* ラベルの発行 */
/* TCHK2     OVRPRTF    FILE(GCEPR3C) DEVTYPE(*AFPDS) LPI(6) +
                          FOLD(*YES) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(D997) */ /* nﾃﾜﾌﾞ]kﾍajﾒﾆｬｮf [sﾞﾓ */
/* TCHK2     MONMSG     MSGID(CPF5004)                              */
/* TCHK2     CALL       PGM(GCER3C)                                 */
/* TCHK2     DLTOVR     FILE(GCEPR3C)                               */
             CLRPFM     FILE(GCEWP30)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
