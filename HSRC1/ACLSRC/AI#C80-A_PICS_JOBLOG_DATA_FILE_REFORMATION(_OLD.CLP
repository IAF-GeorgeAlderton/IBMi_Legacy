             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /** AI#C80 ********************************************/
             /*    ..  A-PICS JOBLOG DATA FILE REFORMATION  ..     */
             /*       CODING:K.OKACHI             2000.03.15       */
             /******************************************** AI#C80 **/
             DCLF       FILE(AI#PW80)
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
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             RTVJOBA    JOB(&WSID)

             CHKOBJ     OBJ(AI#C80ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(AI#C80ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AI#PW801)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&WNUKI *EQ '        ') DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE IS NOT INPUT.')
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


 @XTP1:      CLRPFM     FILE(AI#WP80)
             CALL       PGM(AI#R80) PARM(&WNUKI &WRECD &WKENS)

             RMVM       FILE(AI#PL02) MBR(AI#PL02)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/AI#WP80) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CPYF       FROMFILE(AI#WP80) TOFILE(AI#PP01) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             ENDDO

             ADDLFM     FILE(AI#PL02) MBR(AI#PL02)

             CLRPFM     FILE(AI#WP80)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 END:        DLTDTAARA  DTAARA(AI#C80ACT)

 SEND:       ENDPGM
