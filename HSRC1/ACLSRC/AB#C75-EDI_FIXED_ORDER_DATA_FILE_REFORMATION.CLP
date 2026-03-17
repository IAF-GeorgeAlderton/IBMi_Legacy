             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /** AB#C75 ********************************************/
             /*  ..  EDI FIXED ORDER DATA FILE REFORMATION  ..     */
             /*       K.OKACHI                    1998.03.18       */
             /*       N.HYOTO 2000.11.06 NIRVANA                   */
             /******************************************** AB#C75 **/
             DCLF       FILE(AB#PW75)
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

             CHKOBJ     OBJ(AB#C75ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(AB#C75ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PW751)
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


 @XTP1:      CLRPFM     FILE(AB#WP75)
             CALL       PGM(AB#R75) PARM(&WNUKI &WRECD &WKENS)

             RMVM       FILE(AB#PL11) MBR(AB#PL11)
             RMVM       FILE(AB#PL12) MBR(AB#PL12)
             RMVM       FILE(AB#PL13) MBR(AB#PL13)
             RMVM       FILE(AB#PL14) MBR(AB#PL14)
             RMVM       FILE(AB#PL15) MBR(AB#PL15)
             RMVM       FILE(AB#PL16) MBR(AB#PL16)
             RMVM       FILE(AB#PL17) MBR(AB#PL17)
             RMVM       FILE(AB#PL18) MBR(AB#PL18)
             RMVM       FILE(AB#PL19) MBR(AB#PL19)
             RMVM       FILE(AB#PL1A) MBR(AB#PL1A)
             RMVM       FILE(AB#PL1B) MBR(AB#PL1B)
             RMVM       FILE(AB#PL08) MBR(AB#PL08)

             CPYF       FROMFILE(AB#WP75) TOFILE(AB#PP10) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)

             ADDLFM     FILE(AB#PL11) MBR(AB#PL11)
             ADDLFM     FILE(AB#PL12) MBR(AB#PL12)
             ADDLFM     FILE(AB#PL13) MBR(AB#PL13)
             ADDLFM     FILE(AB#PL14) MBR(AB#PL14)
             ADDLFM     FILE(AB#PL15) MBR(AB#PL15)
             ADDLFM     FILE(AB#PL16) MBR(AB#PL16)
             ADDLFM     FILE(AB#PL17) MBR(AB#PL17)
             ADDLFM     FILE(AB#PL18) MBR(AB#PL18)
             ADDLFM     FILE(AB#PL19) MBR(AB#PL19)
             ADDLFM     FILE(AB#PL1A) MBR(AB#PL1A)
             ADDLFM     FILE(AB#PL1B) MBR(AB#PL1B)
             ADDLFM     FILE(AB#PL08) MBR(AB#PL08)

             CLRPFM     FILE(AB#WP75)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 END:        DLTDTAARA  DTAARA(AB#C75ACT)

 SEND:       ENDPGM
