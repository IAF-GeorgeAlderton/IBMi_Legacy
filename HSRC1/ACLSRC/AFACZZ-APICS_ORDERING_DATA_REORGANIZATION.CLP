             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /*- AFACZZ ------------------------------------*/
             /*  ..A-PICS ORDERING DATA REORGANIZATIONI..   */
             /*                                             */
             /* CODING:K.OKACHI    2002.06.12               */
             /* MODIFY:K.WATANABE  2016.06.03  -JW1         */
             /*---------------------------------------------*/
             DCLF       FILE(AFAPWZZ)
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
             CHGVAR     VAR(&PYM) VALUE(&WNUKI)

           /*--JW1---------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

           /*--JW1---------------------------------------*/
           /*    ACTIVE CHECK                            */
           /*--------------------------------------------*/
             CHKOBJ     OBJ(&WLIB/AFACZZACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(&WLIB/AFACZZACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AFAPWZZ1)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR   VAR(&IN02) VALUE('0')
             CHGVAR   VAR(&IN99) VALUE('0')

             IF         (&PYM *EQ '        ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE IS NOT INPUT.')
             GOTO       STP1
             ENDDO

             IF         (%SST(&PYM 1 4) *LT '1984') GOTO STP2
             IF         (%SST(&PYM 5 2) *GT '12') GOTO STP2
             IF         (%SST(&PYM 5 2) *LT '01') GOTO STP2
             IF         (%SST(&PYM 7 2) *GT '31') GOTO STP2
             IF         (%SST(&PYM 7 2) *LT '01') GOTO STP2
             GOTO       STP3
 STP2:       CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE IS NOT CORRECT.')
             GOTO       STP1

 STP3:       IF         (&IN05 *EQ '0') GOTO STP1
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTIM)

         /*--JW1-----------------------------*/
         /* 灝▴橕鯫�　　　　　　　　　　　*/
         /*----------------------------------*/
             CALL       PGM(VJBC12) PARM(&LIBL)

         /*  CPYF       FROMFILE(AU#PP11) TOFILE(DB_BACK/AU#PP11) +  */
         /*               MBROPT(*REPLACE) CRTFILE(*YES)             */
         /*  MONMSG     MSGID(CPF0000)                               */

         /*--JW1-----------------------------*/
         /* �硠�橑胗�橒��　　　　　*/
         /*----------------------------------*/
             CRTDUPOBJ  OBJ(AU#PP11) FROMLIB(&PLIB) OBJTYPE(*FILE) +
                          TOLIB(&LIBL)
             MONMSG     MSGID(CPF2130)

             OVRDBF     FILE(AU#PP11B) TOFILE(&LIBL/AU#PP11)
             CALL       PGM(AFARZZ) PARM(&PYM &WRECD &WKENS)
             DLTOVR     FILE(AU#PP11B)

         /*--JW1-----------------------------*/
         /*  RGZPFM                          */
         /*----------------------------------*/
             RGZPFM     FILE(AU#PP11)
             MONMSG     MSGID(CPF2981)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)
             CHGVAR     VAR(&WNUKI) VALUE(&PYM)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 END:        DLTDTAARA  DTAARA(&WLIB/AFACZZACT)

 SEND:       ENDPGM
