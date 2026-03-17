             PGM
             /** ABFC70 ***************************/
             /*  海外工場設定数データ送信     */
             /*      MSK......         2005.08.12 */
             /*************************** ABFC70 **/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&SYS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&FILE)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNT)      TYPE(*DEC)  LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&FILE) VALUE('ABFPP70IAF')
             /*---------------------------------*/
             /*   月間必要数更新ファイル作成  */
             /*---------------------------------*/
             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF2105 CPF3261)
             CRTPF      FILE(HWFILE1/&FILE) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ABFPP70) +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 2000 5) LVLCHK(*NO)

             OVRDBF     FILE(ABFPP70) TOFILE(HWFILE1/&FILE)
             CALL       PGM(ABFR70)
             RTVMBRD    FILE(HWFILE1/&FILE) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(GOTO CMDLBL(END))


             /*  ATC  >  ASJ   */
             CHGVAR     VAR(&SYS) VALUE('SYSTEM1')

             SNDNETF    FILE(HWFILE1/&FILE) TOUSRID((QFILE &SYS))
             /*------------------------------------------*/
             /*   ...SBMNETJOB rｮnﾝｰh ﾆﾞｭﾎﾞ ﾉ ncpｬc...   */
             /*------------------------------------------*/
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE &SYS)) +
                          MBR(ABFT41)
END:
             ENDPGM
