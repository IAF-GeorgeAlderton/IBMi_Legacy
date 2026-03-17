/* TCHK5     PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI) */
/* TCHK5 */  PGM
             /** ECSC8A ********************************************/
             /*  DIE IN/OUT RESULTS FILES REFORMATIONTION          */
             /*       Y.MAEDA                     2017.10.17       */
             /******************************************** ECSC8A **/
             DCLF       FILE(ECSPW8A)
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
             DCL        VAR(&BYYMM) TYPE(*CHAR) LEN(6)
             RTVJOBA    JOB(&WSID)

             CHKOBJ     OBJ(ECSC90ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(ECSC90ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ECSPW8A1)
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
             GOTO       @XTP0

 @XTP0:      CHGVAR     VAR(&BYYMM) VALUE(%SST(&WNUKI 1 6))

             SNDPGMMSG  MSG('( G.C ) SET THE BACKUP TAPE IN ' *CAT +
                          &BYYMM *CAT ' < ECSPP80 >') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(@XTP1))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       @XTP0

 @XTP1:
    /* ------------- AJSPP10 ----------- */
             CLRPFM     FILE(ECSWP8A)
             CLRPFM     FILE(ECSWP8B)


             CALL       PGM(ECSR8A) PARM(&WNUKI &WRECD &WKENS)

             CPYF       FROMFILE(ECSWP8A) TOFILE(ECSPP80) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817)

    /* ------------- AJSPP20 ----------- */
             CLRPFM     FILE(ECSWP8A)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 @XTP2:      SNDPGMMSG  MSG('( G )REMOVE THE BACKUP TAPE < ECSPP80 +
                          >') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       @XTP2

 END:        DLTDTAARA  DTAARA(ECSC90ACT)

 SEND:       ENDPGM
