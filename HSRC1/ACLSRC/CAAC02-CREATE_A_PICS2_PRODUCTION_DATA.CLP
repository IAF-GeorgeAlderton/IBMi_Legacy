             PGM        PARM(&USER &PHS &IAFSRC &IAFFILE &IAFWFILE +
                          &PDEVT &PIGCD &PRTG)
             /** CAAC02 ************************************/
             /*  A-PICS2 PRODUCTION DATA CREATE            */
             /*          DIVIDE QUANTITY                   */
             /*          ORDER ACCUMULATE                  */
             /************************************ CAAC02 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PHS) TYPE(*CHAR) LEN(6)
             DCL        VAR(&IAFSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IAFFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IAFWFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             CHKOBJ     OBJ(CAAWP02) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&IAFWFILE/CAAWP02) RCDLEN(100) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(CAAWP02)

             /*----------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ　データ選別..      */
             /*  ..Ａ－ＰＩＣＳⅡ受注累積ファイル    */
             /*----------------------------------------*/
 @STP1:      OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(CAAR02) PARM(&USER)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(CAAR02) +
                          < RETRY-R +
                          CABCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         (&RPY *EQ 'R') GOTO @STP1
             RETURN
             ENDDO
             DLTOVR     FILE(QPRINT)

             IF         COND(%SWITCH(X1XXXXXX)) THEN(DO)
             SNDPGMMSG  MSG('A-PICS2 TAKE PART M/F UNMATCH LITO TO +
                          MASS PRODUCTION TEAM SUPERVISOR.') +
                          TOMSGQ(QSYSOPR)
             ENDDO

             /*------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ　品番毎に数量合計..  */
             /*------------------------------------------*/
             CHKOBJ     OBJ(CAAWP22) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&IAFWFILE/CAAWP22) RCDLEN(100) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(CAAWP22)

             FMTDTA     INFILE((CAAWP02)) OUTFILE(CAAWP22) +
                          SRCFILE(&IAFSRC/FMTSRC) SRCMBR(CAAS22) +
                          OPTION(*NOPRT)

             CHKOBJ     OBJ(CAAWP03) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&IAFWFILE/CAAWP03) RCDLEN(100) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(CAAWP03)

 @STP3:      CALL       PGM(CAAR22)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(CAAR22) +
                          < RETRY-R +
                          CABCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         (&RPY *EQ 'R') GOTO @STP3
             RETURN
             ENDDO

             /*----------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ　数量割振..              */
             /*  ..Ａ－ＰＩＣＳⅡ平準化確定発注ファイル    */
             /*----------------------------------------------*/
 @STP2:      CALL       PGM(CAAR03)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(CAAR03) +
                          < RETRY-R +
                          CABCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         (&RPY *EQ 'R') GOTO @STP2
             RETURN
             ENDDO

             /*----------------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ計画発行　生産指示データ作成..  */
             /*  ..マイナス箱数・プラス箱数                      */
             /*----------------------------------------------------*/
             IF         (&PHS *EQ '000000') DO
             CALL       PGM(CTAR02)
             ENDDO

             ENDPGM
