             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /** FCCC82 **************************************/
             /*  KANBAN M/F INPUT NO. FILE REFORMATION       */
             /*       I-HASADA                 91.06.28      */
             /************************************** FCCC82 **/
             DCLF       FILE(FCCPW82)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WFILE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIBR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WNUKI) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSKRE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WSKHI) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WKTIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSTIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WRECD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WKENS) TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&PHIZ) VALUE(&WNUKI)

             CHKOBJ     OBJ(FCCC82ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(HFILE1/FCCC82ACT) TYPE(*CHAR) +
                          LEN(10) AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(FCCPW821)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&PHIZ *EQ '        ') DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE IS NOT INPUT.')
             GOTO       STP1
             ENDDO

             IF         (%SST(&PHIZ 1 4) *LT '1984') GOTO STP2
             IF         (%SST(&PHIZ 5 2) *GT '12') GOTO STP2
             IF         (%SST(&PHIZ 5 2) *LT '01') GOTO STP2
             IF         (%SST(&PHIZ 7 2) *GT '31') GOTO STP2
             IF         (%SST(&PHIZ 7 2) *LT '01') GOTO STP2
             GOTO       STP3
 STP2:       CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE IS NOT CORRECT.')
             GOTO       STP1

 STP3:       IF         (&IN05 *EQ '0') GOTO STP1

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTIM)
             GOTO       @EX

 @EX:        CLRPFM     FILE(FCCWP82)
             CALL       PGM(FCCR82) PARM(&PHIZ &WRECD &WKENS)

             RMVM       FILE(FCCPL32) MBR(FCCPL32)
             RMVM       FILE(FCCPL33) MBR(FCCPL33)

             CPYF       FROMFILE(FCCWP82) TOFILE(FCCPP32) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

             ADDLFM     FILE(FCCPL32) MBR(FCCPL32)
             ADDLFM     FILE(FCCPL33) MBR(FCCPL33)

             CLRPFM     FILE(FCCWP82)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)
             CHGVAR     VAR(&WNUKI) VALUE(&PHIZ)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 END:        DLTDTAARA  DTAARA(FCCC82ACT)

 SEND:       ENDPGM
