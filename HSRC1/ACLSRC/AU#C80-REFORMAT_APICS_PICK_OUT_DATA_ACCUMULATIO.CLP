             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /** AU#C80 ****************************************/
             /*  A-PICS PICK OUT DATA ACCUMULATION FILE REFORM */
             /*       I-HASADA                 87.10.28        */
             /*  JW1: J-WATANABE             2016.06.02        */
             /**************************************** *********/
             DCLF       FILE(AU#PW80)
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
             DCL        VAR(&WRECD) TYPE(*CHAR) LEN(9)
             DCL        VAR(&WKENS) TYPE(*CHAR) LEN(9)

             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&LIBL)   TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&PHIZ) VALUE(&WNUKI)

           /*--JW1---------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

           /*--JW1---------------------------------------*/
           /*    ACTIVE CHECK                            */
           /*--------------------------------------------*/
             CHKOBJ     OBJ(&WLIB/AU#C80ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(&WLIB/AU#C80ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AU#PW801)
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
             CHGVAR     VAR(&MSG) VALUE('THE DATE IS NOT INPUT.')
             GOTO       STP1

 STP3:       IF         (&IN05 *EQ '0') GOTO STP1
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTIM)

         /*--JW1-----------------------------*/
         /* 灝▴橕鯫�　　　　　　　　　　　*/
         /*----------------------------------*/
             CALL       PGM(VJBC12) PARM(&LIBL)

         /*--JW1-----------------------------*/
         /* �硠�橑胗�橒��　　　　　*/
         /*----------------------------------*/
             CRTDUPOBJ  OBJ(AU#PP21) FROMLIB(&PLIB) OBJTYPE(*FILE) +
                          TOLIB(&LIBL)
             MONMSG     MSGID(CPF2130)

             OVRDBF     FILE(AU#PP21B) TOFILE(&LIBL/AU#PP21)
 @XTP1:      CLRPFM     FILE(AU#WP80)
             CALL       PGM(AU#R80) PARM(&PHIZ &WRECD &WKENS)

             RMVM       FILE(AU#PL21) MBR(AU#PL21)
             RMVM       FILE(AU#PL22) MBR(AU#PL22)
             RMVM       FILE(AU#PL23) MBR(AU#PL23)
             RMVM       FILE(AU#PL24) MBR(AU#PL24)

             CPYF       FROMFILE(AU#WP80) TOFILE(AU#PP21) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817)

             ADDLFM     FILE(AU#PL21) MBR(AU#PL21)
             ADDLFM     FILE(AU#PL22) MBR(AU#PL22)
             ADDLFM     FILE(AU#PL23) MBR(AU#PL23)
             ADDLFM     FILE(AU#PL24) MBR(AU#PL24)

             CLRPFM     FILE(AU#WP80)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)
             CHGVAR     VAR(&WNUKI) VALUE(&PHIZ)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

             DLTOVR     FILE(AU#PP21B)

 END:        DLTDTAARA  DTAARA(&WLIB/AU#C80ACT)

 SEND:       ENDPGM
