             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /** AB#C96 ********************************/
             /*  .. MANIFEST NUMBER REFORMATION ..     */
             /*       K.YASUDA          1999.07.19     */
             /******************************** AB#C96 **/
             DCLF       FILE(AB#PW96)
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

             CHKOBJ     OBJ(AB#C96ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(AB#C96ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PW961)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&WNUKI *EQ '        ') DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('''THE DATE IS NOT INPUT.')
             GOTO       STP1
             ENDDO

             IF         (%SST(&WNUKI 1 4) *LT '1994') GOTO STP2
             IF         (%SST(&WNUKI 5 2) *GT '12') GOTO STP2
             IF         (%SST(&WNUKI 5 2) *LT '01') GOTO STP2
             IF         (%SST(&WNUKI 7 2) *GT '31') GOTO STP2
             IF         (%SST(&WNUKI 7 2) *LT '01') GOTO STP2
             GOTO       STP3
 STP2:       CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE IS NOT CORRECT.')
             GOTO       STP1

 STP3:       IF         (&IN05 *EQ '0') GOTO STP1

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTIM)
             GOTO       @XTP1


 @XTP1:      CLRPFM     FILE(AB#WP96)
             CALL       PGM(AB#R96) PARM(&WNUKI &WRECD &WKENS)

             RMVM       FILE(AB#PL95) MBR(AB#PL95)

             CPYF       FROMFILE(AB#WP96) TOFILE(AB#PP95) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)

             ADDLFM     FILE(AB#PL95) MBR(AB#PL95)

             CLRPFM     FILE(AB#WP96)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 END:        DLTDTAARA  DTAARA(AB#C96ACT)

 SEND:       ENDPGM
