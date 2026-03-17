/********************************************************************/
/*                                                                  */
/* 5716SS1 V3R7M0 961108      RTVCLSRC出力     97.03.18 14:32:22  */
/*                                                                  */
/* プログラム名 . . . . . . . . . . . . . :   AJSCA5            PN*/
/* ライブラリー名 . . . . . . . . . . . . :   HOBJ1             PL*/
/* 元の原始ファイル . . . . . . . . . . . :   ACLSRC            SN*/
/* ライブラリー名 . . . . . . . . . . . . :   HSRC1             SL*/
/* 元の原始メンバー . . . . . . . . . . . :   AJSCA5            SM*/
/* 原始ファイル変更                                               */
/*   日付／時刻 . . . . . . . . . . . . . :   96.12.09 14:22:27 SC*/
/* パッチ・オプション . . . . . . . . . . :   *NOPATCH          PO*/
/* ユーザー・プロファイル . . . . . . . . :   *USER             UP*/
/* テキスト :  MAKING FA M/F PLATING DKT FOR PERSONAL COMPUTER  TX*/
/* 所有者 . . . . . . . . . . . . . . . . :   QPGMR             OW*/
/* パッチ変更ID . . . . . . . . . . . . . :                     PC*/
/* パッチAPAR ID. . . . . . . . . . . . . :                     PA*/
/* ユーザー変更フラグ . . . . . . . . . . :   *YES              UM*/
/*                                                                ED*/
/********************************************************************/
     PGM
     DCLF FILE(AJSPW15)
     DCL VAR(&WSID) TYPE(*CHAR) LEN(10)
     DCL VAR(&PRT) TYPE(*CHAR) LEN(7)
     DCL VAR(&TYPE) TYPE(*CHAR) LEN(1)
     DCL VAR(&PRTG) TYPE(*CHAR) LEN(10)
     DCL VAR(&IN01) TYPE(*LGL) LEN(1)
     DCL VAR(&MBAN) TYPE(*CHAR) LEN(4)
     DCL VAR(&ANS) TYPE(*CHAR) LEN(1)
     RTVJOBA JOB(&WSID)
     CALL PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
     CHGJOB OUTQ(&PRTG) RUNPTY(40)
     CHKOBJ OBJ(HFILE1/FAPURMAK) OBJTYPE(*DTAARA) AUT(*ALL)
     MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(STP2))
STP1: +
     SNDPGMMSG MSG('( G ) IT IS USING AT ANOTHER TV. PLEASE WAIT FOR -
A WHILE.') TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
     RCVMSG MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) MSG(&ANS)
             IF         COND((&ANS *NE 'G') *AND (&ANS *NE 'g')) +
                          THEN(GOTO CMDLBL(STP1))
     GOTO CMDLBL(END)
STP2: +
     CRTDTAARA DTAARA(HFILE1/FAPURMAK) TYPE(*CHAR) LEN(1) VALUE('*') -
AUT(*ALL)
STEP1: +
     SNDRCVF DEV(&WSID) RCDFMT(AJSPW151)
     CHGVAR VAR(&IN99) VALUE('0')
     IF COND(&IN01 *EQ '1') THEN(DO)
     DLTDTAARA DTAARA(HFILE1/FAPURMAK)
     GOTO CMDLBL(END)
     ENDDO
     IF COND(&TVMENT *EQ '1') THEN(GOTO CMDLBL(GOOD))
     IF COND(&TVMENT *EQ '2') THEN(GOTO CMDLBL(GOOD))
     CHGVAR VAR(&IN99) VALUE('1')
     GOTO CMDLBL(STEP1)
GOOD: +
     DLTF FILE(HWFILE1/AJSWP15)
     MONMSG MSGID(CPF3261 CPF2105)
     CRTPF FILE(HWFILE1/AJSWP15) RCDLEN(145) TEXT('FOR CYUBU RIKA FA -
M/F PERSONAL COMPUTER DKT OUTPUT') OPTION(*NOLIST) SIZE(4000 500) -
LVLCHK(*NO) AUT(*ALL)
     GRTOBJAUT OBJ(AJSWP15) OBJTYPE(*FILE) USER(*PUBLIC) AUT(*ALL)
             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(BZOUTQ) FORMTYPE(K6H1)
     CALL PGM(AJSR15) PARM(&TVMENT)
             DLTOVR     FILE(QPRINT)
     DLTDTAARA DTAARA(HFILE1/FAPURMAK)
END: +
     CHGJOB RUNPTY(20)
     ENDPGM
