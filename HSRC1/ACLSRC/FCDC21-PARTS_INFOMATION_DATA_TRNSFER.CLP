             PGM
/** FCDC21 ************************************************/
/*部品情報マスターから必要情報の抽出                    */
/*       M-OKUDA      02.12.04                            */
/* TCHK1 06/22/09 CREATE(CONVERT ASJ SOURCE)              */
/************************************************ FCDC21 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID) TYPE(*CHAR) LEN(03)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&IPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OSTTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OKONA) TYPE(*CHAR) LEN(15)
             DCL        VAR(&KINP)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&MSG)   TYPE(*CHAR) LEN(256)

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGVAR     VAR(&FILE1) VALUE(%SUBSTRING(&US 1 5))
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             /* 部品情報マスター選択後のデータ作成*/
 STEP04:
             CHKOBJ     OBJ(FCDWP22) OBJTYPE(*FILE) MBR(&US)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(FCDWP22) MBR(&US))
             CLRPFM     FILE(FCDWP22) MBR(&US)

             OVRDBF     FILE(FCDWP22) TOFILE(FCDWP22) MBR(&US)

             CHGJOB     SWS(00000000)

             CALL       PGM(FCDR22)

             IF         (%SWITCH(1XXXXXXX)) GOTO STEP99
             IF         (%SWITCH(XX1XXXXX)) GOTO STEP99
             GOTO STEP01

             /* ＤＤＳのフィールド選択ＳＯＵＲＣＥの作成 */
 STEP01:
             OVRDBF     FILE(INPUT) TOFILE(HSRC1/ADDSSRC) +
                          MBR(FCDWP22) POSITION(*START)

             CHKOBJ     OBJ(FCDWPSO) OBJTYPE(*FILE) MBR(&US)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM +
                          FILE(FCDWPSO) MBR(&US))
             CLRPFM     FILE(FCDWPSO) MBR(&US)

             OVRDBF     FILE(OUTPUT) TOFILE(FCDWPSO) +
                          MBR(&US) POSITION(*START)

             CALL       PGM(FCDR23)

             IF         (%SWITCH(XX1XXXXX)) GOTO STEP99

             DLTOVR     FILE(INPUT)
             DLTOVR     FILE(OUTPUT)

             /* 選択フィールドのみでＰＦの作成 */
             DLTF       FILE(HWFILE1/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) +
                          SRCFILE(HWFILE1/FCDWPSO) SRCMBR(&US) +
                          TEXT('パソコン取込みデータ') +
                          OPTION(*NOSOURCE *NOLIST) SIZE(30000 +
                          10000) LVLCHK(*NO)
             /* 選択フィールドのみの複写 */
             CPYF       FROMFILE(HWFILE1/FCDWP22) +
                          TOFILE(HWFILE1/&FILE1) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*DROP *MAP)

 STEP02:
             GOTO       STEP06

 STEP03:
          /* DSPDBM     FILE(WORKLIB/&FILE1) */

 STEP99:
             GOTO       END
 STEP06:

 END:        ENDPGM
