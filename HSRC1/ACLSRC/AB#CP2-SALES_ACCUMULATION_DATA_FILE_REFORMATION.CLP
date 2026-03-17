/* TCHK2     PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI) */
/* TCHK2 */  PGM
             /** AB#CP2 *************************************/
             /*   SALES ACCUMULATION DATA FILE REFORMATION  */
             /*     I-HASADA            87.10.29            */
             /*                                             */
             /* TCHK1 07/09/10 RMV TAPE HANDLING            */
             /*                RMV AB#R88 AFTER CLEAR AB#WP88 */
             /* TCHK2 08/14/11 RMV PARM                     */
             /************************************* AB#CP2 **/
             DCLF       FILE(AB#PW88)
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
             CHGVAR     VAR(&PHIZ) VALUE(&WNUKI)

             CHKOBJ     OBJ(AB#CP2ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(AB#CP2ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AB#PW881)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR   VAR(&IN99) VALUE('0')

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
             CHGVAR     VAR(&BYYMM) VALUE(%SST(&PHIZ 1 6))
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTIM)

  /*         CALL       PGM(AJAC45)     */

 STP4:       SNDPGMMSG  MSG('( G.C ) SET THE BACKUP TAPE IN '  +
                          *CAT &BYYMM *CAT  ' < AB#PP01 >') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STP5))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP4

 STP5:       CLRPFM     FILE(AB#WPCP)
             CLRPFM     FILE(AB#WP88)

/* TCHK1     INZTAP     DEV(TAP04) NEWVOL(IAF) CHECK(*NO) */

             CALL       PGM(AB#R88) PARM(&PHIZ &WRECD &WKENS)

             RMVM       FILE(AB#PL01) MBR(AB#PL01)
             RMVM       FILE(AB#PL02) MBR(AB#PL02)
             RMVM       FILE(AB#PL03) MBR(AB#PL03)
             RMVM       FILE(AB#PL04) MBR(AB#PL04)
             RMVM       FILE(AB#PL05) MBR(AB#PL05)
             RMVM       FILE(AB#PL06) MBR(AB#PL06)
             RMVM       FILE(AB#PL07) MBR(AB#PL07)
             RMVM       FILE(AB#PL09) MBR(AB#PL09)
             RMVM       FILE(AB#PL0A) MBR(AB#PL0A)
             RMVM       FILE(AB#PL99) MBR(AB#PL99)

             CPYF       FROMFILE(AB#WPCP) TOFILE(AB#PP01) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817)

             ADDLFM     FILE(AB#PL01) MBR(AB#PL01)
             ADDLFM     FILE(AB#PL02) MBR(AB#PL02)
             ADDLFM     FILE(AB#PL03) MBR(AB#PL03)
             ADDLFM     FILE(AB#PL04) MBR(AB#PL04)
             ADDLFM     FILE(AB#PL05) MBR(AB#PL05)
             ADDLFM     FILE(AB#PL06) MBR(AB#PL06)
             ADDLFM     FILE(AB#PL07) MBR(AB#PL07)
             ADDLFM     FILE(AB#PL09) MBR(AB#PL09)
             ADDLFM     FILE(AB#PL0A) MBR(AB#PL0A)
             ADDLFM     FILE(AB#PL99) MBR(AB#PL99)

/* TCHK1     SAVOBJ     OBJ(AB#WP88) LIB(HWFILE1) DEV(TAP04) +
                          OBJTYPE(*FILE) VOL(IAF) ENDOPT(*UNLOAD) */

             CLRPFM     FILE(AB#WPCP)
/* TCHK1     CLRPFM     FILE(AB#WP88) */

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)
             CHGVAR     VAR(&WNUKI) VALUE(&PHIZ)

/* TCHK2     CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS) */

 END:        DLTDTAARA  DTAARA(AB#CP2ACT)

 SEND:       ENDPGM
