             PGM
             /** GCEC3A ********************************************/
             /* .. ISSUE LABEL DISPLAYING DAILY SHIPMENT OF AN ADDRESS */
             /*           A-IDOTA           1987.08.22             */
             /*           H-AMANO           2003.04.09             */
             /**********************************************GCEC3A**/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SKUB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SLCT) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WS)
             CHGJOB     RUNPTY(40) SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
 STP1:
             MONMSG     MSGID(CPF9999)
             CHGJOB     OUTQ(&PRTG)
              /******/
  /* ラベルの内容作成 */
              DLTF       FILE(QTEMP/GCEWP31)
              MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/GCEWP31) RCDLEN(100) +
                          TEXT('ISSUE LABEL DISPLAYING DAILY +
                          SHIPMENT OF AN ADD') OPTION(*NOLIST) +
                          SIZE(5000) LVLCHK(*NO)
             DLTF       FILE(QTEMP/GCEWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/GCEWP32) RCDLEN(100) +
                          TEXT('ISSUE LABEL DISPLAYING DAILY +
                          SHIPMENT OF AN ADD') OPTION(*NOLIST) +
                          SIZE(5000) LVLCHK(*NO)
             /******/
 /* 差のチェック */
             CALL       PGM(GCER3BX)
             FMTDTA     INFILE((QTEMP/GCEWP31)) +
                          OUTFILE(QTEMP/GCEWP32) SRCFILE(FMTSRC) +
                          SRCMBR(GCES31) OPTION(*NOPRT)
             /******/
 /* ラベルの発行 */
             OVRPRTF    FILE(GCEPR3C) DEVTYPE(*AFPDS) LPI(6) +
                          FOLD(*YES) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(D997) /* nﾃﾜﾌﾞ]kﾍajﾒﾆｬｮf [sﾞﾓ */
             MONMSG     MSGID(CPF5004)
             CALL       PGM(GCER3C)
             DLTOVR     FILE(GCEPR3C)
             CLRPFM     FILE(GCEWP30)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
