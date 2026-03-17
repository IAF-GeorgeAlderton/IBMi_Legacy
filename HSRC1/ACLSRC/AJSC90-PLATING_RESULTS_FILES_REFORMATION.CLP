/* TCHK5     PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI) */
/* TCHK5 */  PGM
             /** AJSC90 ********************************************/
             /*      .. PLATING RESULTS FILES REFORMATION  ..      */
             /*       K.OKACHI                    2000.03.16       */
             /*                                                    */
             /* TCHK1 10/29/06 CHG                                 */
             /* TCHK2 01/13/08 CHG                                 */
             /* TCHK3 01/25/09 CHG                                 */
             /* TCHK4 07/09/10 RMV TAPE HANDLING(GOTO MAMNUAL)     */
             /******************************************** AJSC90 **/
             DCLF       FILE(AJSPW90)
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

             CHKOBJ     OBJ(AJSC90ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(AJSC90ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AJSPW901)
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
                          &BYYMM *CAT ' < AJSPP10 & AJSPP20 & +
                          AJSPP60 >') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(@XTP1))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       @XTP0

 @XTP1:
    /* ------------- AJSPP10 ----------- */
             CLRPFM     FILE(AJSWP60)
             CLRPFM     FILE(AJSWP61)


             CALL       PGM(AJSR90) PARM(&WNUKI &WRECD &WKENS)

/* TCHK2     RMVM       FILE(AJSPL12) MBR(AJSPL12) */
/* TCHK2     RMVM       FILE(AJSPL13) MBR(AJSPL13) */
/* TCHK2     RMVM       FILE(AJSPL14) MBR(AJSPL14) */
/* TCHK2     RMVM       FILE(AJSPL15) MBR(AJSPL15) */
/* TCHK2     RMVM       FILE(AJSPL16) MBR(AJSPL16) */

             CPYF       FROMFILE(AJSWP60) TOFILE(AJSPP10) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817)

/* TCHK2     ADDLFM     FILE(AJSPL12) MBR(AJSPL12) */
/* TCHK2     ADDLFM     FILE(AJSPL13) MBR(AJSPL13) */
/* TCHK2     ADDLFM     FILE(AJSPL14) MBR(AJSPL14) */
/* TCHK2     ADDLFM     FILE(AJSPL15) MBR(AJSPL15) */
/* TCHK2     ADDLFM     FILE(AJSPL16) MBR(AJSPL16) */
    /* ------------- AJSPP20 ----------- */
             CLRPFM     FILE(AJSWP62)
             CLRPFM     FILE(AJSWP63)


             CALL       PGM(AJSR92) PARM(&WNUKI &WRECD &WKENS)

/* TCHK2     RMVM       FILE(AJSPL21) MBR(AJSPL21) */
/* TCHK2     RMVM       FILE(AJSPL22) MBR(AJSPL22) */
/* TCHK2     RMVM       FILE(AJSPL23) MBR(AJSPL23) */
/* TCHK2     RMVM       FILE(AJSPL24) MBR(AJSPL24) */
/* TCHK2     RMVM       FILE(AJSPL25) MBR(AJSPL25) */
/* TCHK2     RMVM       FILE(AJSPL26) MBR(AJSPL26) */
/* TCHK2     RMVM       FILE(AJSPL27) MBR(AJSPL27) */
/* TCHK2     RMVM       FILE(AJSPL28) MBR(AJSPL28) */
/* TCHK2     RMVM       FILE(AJSPL29) MBR(AJSPL29) */

             CPYF       FROMFILE(AJSWP62) TOFILE(AJSPP20) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817)

/* TCHK2     ADDLFM     FILE(AJSPL21) MBR(AJSPL21) */
/* TCHK2     ADDLFM     FILE(AJSPL22) MBR(AJSPL22) */
/* TCHK2     ADDLFM     FILE(AJSPL23) MBR(AJSPL23) */
/* TCHK2     ADDLFM     FILE(AJSPL24) MBR(AJSPL24) */
/* TCHK2     ADDLFM     FILE(AJSPL25) MBR(AJSPL25) */
/* TCHK2     ADDLFM     FILE(AJSPL26) MBR(AJSPL26) */
/* TCHK2     ADDLFM     FILE(AJSPL27) MBR(AJSPL27) */
/* TCHK2     ADDLFM     FILE(AJSPL28) MBR(AJSPL28) */
/* TCHK2     ADDLFM     FILE(AJSPL29) MBR(AJSPL29) */

    /* ------------- AJSPP60 ----------- */
             CLRPFM     FILE(AJSWP64)
             CLRPFM     FILE(AJSWP65)

             CALL       PGM(AJSR94) PARM(&WNUKI &WRECD &WKENS)

/* TCHK2     RMVM       FILE(AJSPL62) MBR(AJSPL62) */
/* TCHK2     RMVM       FILE(AJSPL63) MBR(AJSPL63) */
/* TCHK2     RMVM       FILE(AJSPL64) MBR(AJSPL64) */
/* TCHK2     RMVM       FILE(AJSPL65) MBR(AJSPL65) */
/* TCHK2     RMVM       FILE(AJSPL66) MBR(AJSPL66) */
/* TCHK2     RMVM       FILE(AJSPL68) MBR(AJSPL68) */
/* TCHK2     RMVM       FILE(AJSPL69) MBR(AJSPL69) */

             CPYF       FROMFILE(AJSWP64) TOFILE(AJSPP60) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817)

/* TCHK2     ADDLFM     FILE(AJSPL62) MBR(AJSPL62) */
/* TCHK2     ADDLFM     FILE(AJSPL63) MBR(AJSPL63) */
/* TCHK2     ADDLFM     FILE(AJSPL64) MBR(AJSPL64) */
/* TCHK2     ADDLFM     FILE(AJSPL65) MBR(AJSPL65) */
/* TCHK2     ADDLFM     FILE(AJSPL66) MBR(AJSPL66) */
/* TCHK2     ADDLFM     FILE(AJSPL68) MBR(AJSPL68) */
/* TCHK2     ADDLFM     FILE(AJSPL69) MBR(AJSPL69) */

/* TCHK4     INZTAP     DEV(TAP04) NEWVOL(IAF) CHECK(*NO)           */
/* TCHK4                                                            */
/* TCHK4     SAVOBJ     OBJ(AJSWP61 AJSWP63 AJSWP65) LIB(HWFILE1) + */
/* TCHK4                  DEV(TAP04) OBJTYPE(*FILE) VOL(IAF) +      */
/* TCHK4                  ENDOPT(*UNLOAD)                           */

             CLRPFM     FILE(AJSWP60)
/* TCHK3     CLRPFM     FILE(AJSWP61) */
             CLRPFM     FILE(AJSWP62)
/* TCHK3     CLRPFM     FILE(AJSWP63) */
             CLRPFM     FILE(AJSWP64)
/* TCHK3     CLRPFM     FILE(AJSWP65) */

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 @XTP2:      SNDPGMMSG  MSG('( G )REMOVE THE BACKUP TAPE < AJSPP10 & +
                          AJSPP20 & AJSPP60>') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       @XTP2

 END:        DLTDTAARA  DTAARA(AJSC90ACT)

 SEND:       ENDPGM
