/* TCHK4     PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI) */
/* TCHK4 */  PGM
             /** ALDC80 ********************************************/
             /*  .. OUT-GOING TRACK DATA FILE REFORMATION  ..      */
             /*       K.OKACHI                    1998.03.21       */
             /* TCHK1 01/13/08 CHG                                 */
             /* TCHK2 01/25/09 CHG                                 */
             /* TCHK3 07/09/10 RMV TAPE HANDLING(GOTO MANUAL)      */
             /* TCHK4 08/14/11 RMV PARM                            */
             /******************************************** ALDC80 **/
             DCLF       FILE(ALDPW80)
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


             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHKOBJ     OBJ(ALDC80ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(ALDC80ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ALDPW801)
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

 @XTP0:      CHGVAR     VAR(&BYYMM) VALUE(%SST(&WNUKI 1 6))

             SNDPGMMSG  MSG('( G.C ) SET THE BACKUP TAPE IN ' *CAT +
                          &BYYMM *CAT ' < ALDPP20 & ALDPP30 >') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(@XTP1))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       @XTP0

 @XTP1:
    /* ------------- ALDPP30 ----------- */
       /*    CLRPFM     FILE(ALDWP80)    */
       /*    CLRPFM     FILE(ALDWP81)    */

             DLTF       FILE(&WLIB/ALDWP80)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ALDWP80) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ALDPP30) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000000 10000 5) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/ALDWP81)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ALDWP81) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ALDPP30) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000000 10000 5) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(ALDR80) PARM(&WNUKI &WRECD &WKENS)

/* TCHK1     RMVM       FILE(ALDPL30) MBR(ALDPL30) */
/* TCHK1     RMVM       FILE(ALDPL31) MBR(ALDPL31) */
/* TCHK1     RMVM       FILE(ALDPL32) MBR(ALDPL32) */
/* TCHK1     RMVM       FILE(ALDPL33) MBR(ALDPL33) */
/* TCHK1     RMVM       FILE(ALDPL34) MBR(ALDPL34) */
/* TCHK1     RMVM       FILE(ALDPL35) MBR(ALDPL35) */

             CPYF       FROMFILE(ALDWP80) TOFILE(ALDPP30) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817)

/* TCHK1     ADDLFM     FILE(ALDPL30) MBR(ALDPL30) */
/* TCHK1     ADDLFM     FILE(ALDPL31) MBR(ALDPL31) */
/* TCHK1     ADDLFM     FILE(ALDPL32) MBR(ALDPL32) */
/* TCHK1     ADDLFM     FILE(ALDPL33) MBR(ALDPL33) */
/* TCHK1     ADDLFM     FILE(ALDPL34) MBR(ALDPL34) */
/* TCHK1     ADDLFM     FILE(ALDPL35) MBR(ALDPL35) */
    /* ------------- ALDPP20 ----------- */
       /*    CLRPFM     FILE(ALDWP82)   */
       /*    CLRPFM     FILE(ALDWP83)   */
             DLTF       FILE(&WLIB/ALDWP82)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ALDWP82) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ALDPP20) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000000 10000 5) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/ALDWP83)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ALDWP83) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ALDPP20) OPTION(*NOLIST *NOSRC) +
                          SIZE(1000000 10000 5) LVLCHK(*NO) AUT(*ALL)


             CALL       PGM(ALDR82) PARM(&WNUKI &WRECD &WKENS)

/* TCHK1     RMVM       FILE(ALDPL20) MBR(ALDPL20) */
/* TCHK1     RMVM       FILE(ALDPL21) MBR(ALDPL21) */
/* TCHK1     RMVM       FILE(ALDPL22) MBR(ALDPL22) */
/* TCHK1     RMVM       FILE(ALDPL23) MBR(ALDPL23) */
/* TCHK1     RMVM       FILE(ALDPL24) MBR(ALDPL24) */
/* TCHK1     RMVM       FILE(ALDPL25) MBR(ALDPL25) */

             CPYF       FROMFILE(ALDWP82) TOFILE(ALDPP20) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817)

/* TCHK1     ADDLFM     FILE(ALDPL20) MBR(ALDPL20) */
/* TCHK1     ADDLFM     FILE(ALDPL21) MBR(ALDPL21) */
/* TCHK1     ADDLFM     FILE(ALDPL22) MBR(ALDPL22) */
/* TCHK1     ADDLFM     FILE(ALDPL23) MBR(ALDPL23) */
/* TCHK1     ADDLFM     FILE(ALDPL24) MBR(ALDPL24) */
/* TCHK1     ADDLFM     FILE(ALDPL25) MBR(ALDPL25) */

/* TCHK3     INZTAP     DEV(TAP04) NEWVOL(IAF) CHECK(*NO)              */
/* TCHK3     SAVOBJ     OBJ(ALDWP81 ALDWP83) LIB(HWFILE1) DEV(TAP04) + */
/* TCHK3                  OBJTYPE(*FILE) VOL(IAF) ENDOPT(*UNLOAD)      */

      /*     CLRPFM     FILE(ALDWP80)     */
      /*     CLRPFM     FILE(ALDWP81)     */
      /*     CLRPFM     FILE(ALDWP82)     */
      /*     CLRPFM     FILE(ALDWP83)     */
             DLTF       FILE(&WLIB/ALDWP80)
             MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK2     DLTF       FILE(&WLIB/ALDWP81)     */
/* TCHK2     MONMSG     MSGID(CPF3261 CPF2105)  */
             DLTF       FILE(&WLIB/ALDWP82)
             MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK2     DLTF       FILE(&WLIB/ALDWP83)     */
/* TCHK2     MONMSG     MSGID(CPF3261 CPF2105)  */

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)

/* TCHK4     CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS) */

 @XTP2:      SNDPGMMSG  MSG('( G )REMOVE THE BACKUP TAPE < ALDPP20 & +
                          ALDPP30>') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       @XTP2

 END:        DLTDTAARA  DTAARA(ALDC80ACT)

 SEND:       ENDPGM
