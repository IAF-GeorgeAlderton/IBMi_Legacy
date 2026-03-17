             PGM        PARM(&FILE &RTN1)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PF)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATR ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTNX) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RSN)  TYPE(*CHAR) LEN(20)

             CHGVAR     VAR(&RTN1) VALUE(' ')

             RTVJOBA    JOB(&WSID)
             RTVOBJD    OBJ(&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9812 CPA0701 CPD0078 CPF0001) EXEC(DO)
             CHGVAR     VAR(&RSN) VALUE(&FILE *CAT ' NOT FOUND!')
             CHGVAR     VAR(&RTN1) VALUE('1')
             GOTO       CMDLBL(ERR)
             ENDDO

  /* GET PF  */
             CALL       PGM(UTLC04) PARM(&FILE &PF &ATR &RTNX)

  /* IF ERROR            */
             IF         COND(&RTNX *NE ' ') THEN(DO)
             CHGVAR     VAR(&RSN) VALUE('(NO PF)')
             CHGVAR     VAR(&RTN1) VALUE('2')
             GOTO       CMDLBL(ERR)
             ENDDO

  /* GET HFILE1/HWFILE1) */
  NEXT1A:    CHKOBJ     OBJ(HFILE1/&PF) OBJTYPE(*FILE) MBR(&PF)
             MONMSG     MSGID(CPF9801) EXEC(GOTO NEXT1B)
             MONMSG     MSGID(CPF9815) EXEC(GOTO NEXT1B)
             CHGVAR     VAR(&HLIB) VALUE('HFILE1')
             GOTO       NEXT2A

  NEXT1B:    CHKOBJ     OBJ(HWFILE1/&PF) OBJTYPE(*FILE) MBR(&PF)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&RSN) VALUE('(HFILE1 NOT EXIST)')
             CHGVAR     VAR(&RTN1) VALUE('3')
             GOTO       CMDLBL(ERR)
             ENDDO

             MONMSG     MSGID(CPF9815) EXEC(DO)
             CHGVAR     VAR(&RSN) VALUE('(HFILE1 NOT EXIST)')
             CHGVAR     VAR(&RTN1) VALUE('4')
             GOTO       CMDLBL(ERR)
             ENDDO
             CHGVAR     VAR(&HLIB) VALUE('HWFILE1')
             GOTO       NEXT2A

  /* GET TFILE1/TWFILE1) */
  NEXT2A:    CHKOBJ     OBJ(TFILE1/&PF) OBJTYPE(*FILE) MBR(&PF)
             MONMSG     MSGID(CPF9801) EXEC(GOTO NEXT2B)
             MONMSG     MSGID(CPF9815) EXEC(GOTO NEXT2B)
             CHGVAR     VAR(&TLIB) VALUE('TFILE1')
             GOTO       CPY

  NEXT2B:    CHKOBJ     OBJ(TWFILE1/&PF) OBJTYPE(*FILE) MBR(&PF)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&RSN) VALUE('(TFILE1 NOT EXIST)')
             CHGVAR     VAR(&RTN1) VALUE('5')
             GOTO       CMDLBL(ERR)
             ENDDO

             MONMSG     MSGID(CPF9815) EXEC(DO)
             CHGVAR     VAR(&RSN) VALUE('(TFILE1 NOT EXIST)')
             CHGVAR     VAR(&RTN1) VALUE('6')
             GOTO       CMDLBL(ERR)
             ENDDO

             CHGVAR     VAR(&TLIB) VALUE('TWFILE1')
             GOTO       CPY

  CPY:       CPYF       FROMFILE(&HLIB/&PF) TOFILE(&TLIB/&PF) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(&TLIB/&PF))

        /**  SNDPGMMSG  MSG(&PF *BCAT 'Cﾁﾂｻｶｵ ﾐﾕｴｴｶﾐｷﾕｾｾﾙ... Fﾊﾁｿ:' +**/
        /**               *BCAT &HLIB *BCAT ' Tﾁ:' *BCAT &TLIB) +    **/
        /**               TOMSGQ(&WSID) MSGTYPE(*INFO)               **/
             GOTO       END

 ERR:   /**  SNDPGMMSG  MSG('Nﾁﾔ Cﾁﾂｻｶｵ!' *ｳｴｲﾔ &ﾊﾐﾀ) +    **/
        /**               TOMSGQ(&WSID) MSGTYPE(*INFO)     **/

  END:       ENDPGM
