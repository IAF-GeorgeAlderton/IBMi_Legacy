             PGM
             /** BSDCD0 **************************************/
             /*CHECK SIGN-ON DATA AREA                     */
             /*        T.SAKAKI        2015.10.13            */
             /************************************************/
             DCLF       FILE(BSDPWD0)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TACD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PASS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DTAR) TYPE(*CHAR) LEN(13)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(LA328R) PARM(&PASS)

             CHGVAR     VAR(&DTAR) VALUE('ALD' *CAT &WSID)

 /*データエリア存在チェック*/
 @STEP00:
             CHKOBJ     OBJ(&WLIB/&DTAR) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@END))
             RTVDTAARA  DTAARA(&WLIB/&DTAR) RTNVAR(&D1TXT)
             GOTO       CMDLBL(@DSP)
 /*パスワード入力*/
 @DSP:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             IF         COND(&D1PASS *NE &PASS) THEN(GOTO CMDLBL(@DSP))

             DLTDTAARA  DTAARA(&WLIB/&DTAR)
             GOTO       CMDLBL(@END)
 @END:
             ENDPGM
