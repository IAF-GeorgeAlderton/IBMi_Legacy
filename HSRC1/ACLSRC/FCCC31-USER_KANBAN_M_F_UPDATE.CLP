             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /** FCCC31 ****************************/
             /*   ...ﾏｰﾅﾞｰf]ﾌﾞ] uﾇjｰ   ﾅbs]ﾈb...   */
             /*        I-HASADA    87.10.28        */
             /**************************** FCCC31 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFILE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIBR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WNUKI) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSKRE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WSKHI) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WKTIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSTIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WRECD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WKENS) TYPE(*CHAR) LEN(7)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTIM)
             GOTO       @EX

 @EX:        CHKOBJ     OBJ(FCCC31ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(HFILE1/FCCC31ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

             DLTF       FILE(VJBWP15)
             MONMSG     MSGID(CPF3261 CPF2105)
             DSPFD      FILE(FCCPP11) TYPE(*MBR) OUTPUT(*OUTFILE) +
                          OUTFILE(HFILE1/VJBWP15) FILEATR(*PF)
             CALL       PGM(VJBR15) PARM(&WRECD &WKENS)
             DLTF       FILE(VJBWP15)

             CLRPFM     FILE(FCCWP31)
             CALL       PGM(FCCR31) PARM(&WKENS)

             RMVM       FILE(FCCPL11) MBR(FCCPL11)
             RMVM       FILE(FCCPL12) MBR(FCCPL12)
             RMVM       FILE(FCCPL13) MBR(FCCPL13)
             RMVM       FILE(FCCPL14) MBR(FCCPL14)
             RMVM       FILE(FCCTL12) MBR(FCCTL12)
             RMVM       FILE(FCCTL13) MBR(FCCTL13)
             RMVM       FILE(FCCTL14) MBR(FCCTL14)
             RMVM       FILE(FCCTL15) MBR(FCCTL15)

             CPYF       FROMFILE(FCCWP31) TOFILE(FCCPP11) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)

             ADDLFM     FILE(FCCPL11) MBR(FCCPL11)
             ADDLFM     FILE(FCCPL12) MBR(FCCPL12)
             ADDLFM     FILE(FCCPL13) MBR(FCCPL13)
             ADDLFM     FILE(FCCPL14) MBR(FCCPL14)
             ADDLFM     FILE(FCCTL12) MBR(FCCTL12)
             ADDLFM     FILE(FCCTL13) MBR(FCCTL13)
             ADDLFM     FILE(FCCTL14) MBR(FCCTL14)
             ADDLFM     FILE(FCCTL15) MBR(FCCTL15)

             CLRPFM     FILE(FCCWP31)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 END:        DLTDTAARA  DTAARA(FCCC31ACT)

 SEND:       ENDPGM
