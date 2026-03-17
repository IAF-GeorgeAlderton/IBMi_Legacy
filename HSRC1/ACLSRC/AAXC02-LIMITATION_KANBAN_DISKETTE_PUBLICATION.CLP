             PGM
             /** AAXC02 **********************************/
             /*   LIMITATION KANBAN DISKETTE PUBLICATION   */
             /* AAXC01 PROGRAM CHANGE */
             /* Y DAILY HANDLING                    */
             /*N REISSUE                            */
             /*        I-HASADA            87.10.13      */
             /********************************** AAXC02 **/
             DCLF       FILE(AAXPW02)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE8) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WTIME) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PK) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&HK1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HK2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HAKOHB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             RTVDTAARA  DTAARA(HAKOHBS) RTNVAR(&HAKOHB)
             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     RUNPTY(40) SWS(00000000)

             CHGVAR     VAR(&WTIME) VALUE(%SUBSTRING(&TIME 1 4))
             CHGVAR     VAR(&RKUBN) VALUE('Y')

             CHGVAR     VAR(%SUBSTRING(&DATE8 3 6)) VALUE(&DATE)
             CHGVAR     VAR(%SUBSTRING(&DATE8 1 2)) VALUE('20')
             IF         COND(%SUBSTRING(&DATE 1 2) *GE '90') +
                          THEN(CHGVAR VAR(%SUBSTRING(&DATE8 1 2)) +
                          VALUE('19'))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHKOBJ     OBJ(AAXACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL($STP1))

 $STP2:      SNDPGMMSG  MSG('( G ) TRIAL MFG KANBAN DISKETTE +
                          PUBLICATION HANDLING IS ACTIVE,WAIT FOR A +
                          WHILE') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL($STP2))
             GOTO       $END

 $STP1:      CRTDTAARA  DTAARA(AAXACT) TYPE(*CHAR) LEN(10) +
                          TEXT('DURING TRIAL MFG KANBAN DISKETTE +
                          PUBLICATION HANDL') AUT(*ALL)

             CHKOBJ     OBJ(RCLACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BTP1))
 BTP2:       SNDPGMMSG  MSG('( G ) LIMITATION KANBAN TEMPORARY +
                          ACCUMULATION DATA IS ACTIVE, WAIT FOR A +
                          WHILE ...') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(BTP2))
             GOTO       END

 BTP1:       CRTDTAARA  DTAARA(RCLACT) TYPE(*CHAR) LEN(10) +
                          TEXT('FOR LIMIT KANBAN TEMP ACCUMULATION +
                          DATA HANDL CHK') AUT(*ALL)

             CLRPFM     FILE(RCLWP32)

             CALL       PGM(RCLR32) PARM(&PK)

             IF         (&PK *EQ '5') GOTO FTP1
             CLRPFM     FILE(RCLWP32)
             GOTO       SEND

 FTP1:       CLRPFM     FILE(FCLNP11)
             CPYF       FROMFILE(RCLWP32) TOFILE(FCLNP11) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
             CLRPFM     FILE(RCLWP32)
             DLTDTAARA  DTAARA(RCLACT)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AAXPW021)

             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 = '1') GOTO END
             IF         (&RKUBN *EQ 'N') GOTO STP2

             IF         COND(&RKUBN *EQ 'Y') THEN(DO)
             IF         COND(%SUBSTRING(&HAKOHB 1 6) *EQ &DATE *AND +
                          %SUBSTRING(&HAKOHB 7 2) *GE '05') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('IT IS PROCESSED TO 5 BIN ALREADY FOR TODAY')
             GOTO       STP1
             ENDDO
             GOTO       CMDLBL(STP3)
             ENDDO

             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ITEM ( Y.N )')
             GOTO       STP1


 STP2:       CHGVAR     VAR(&RHIZK) VALUE('        ')
             CHGVAR     VAR(&RTIME) VALUE('    ')

 STP4:       SNDRCVF    DEV(&WSID) RCDFMT(AAXPW022)

             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 = '1') GOTO END
             IF         (&IN02 *EQ '0') GOTO STP9
             CHGVAR     VAR(&RKUBN) VALUE('Y')
             GOTO       STP1

 STP9:       IF         (%SUBSTRING(&RHIZK 1 4) *LT '1981') GOTO STP5
             IF         (%SUBSTRING(&RHIZK 5 2) *LT '01') GOTO STP5
             IF         (%SUBSTRING(&RHIZK 5 2) *GT '12') GOTO STP5
             IF         (%SUBSTRING(&RHIZK 7 2) *LT '01') GOTO STP5
             IF         (%SUBSTRING(&RHIZK 7 2) *GT '31') GOTO STP5
             GOTO       STP6
 STP5:       CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE ( YYYYMMDD ) ISN')
             GOTO       STP4

 STP6:       IF         (%SUBSTRING(&RTIME 1 2) *EQ '  ') GOTO STP7
             IF         (%SUBSTRING(&RTIME 1 2) *GT '23') GOTO STP7
             IF         (%SUBSTRING(&RTIME 3 2) *EQ '  ') GOTO STP7
             IF         (%SUBSTRING(&RTIME 3 2) *GT '59') GOTO STP7
             GOTO       STP8
 STP7:       CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('TIME ( HHMM ) ISN')
             GOTO       STP4

 STP8:       IF         (&RHIZK *LE &DATE8) GOTO STP3
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('IT CAN NOT INPUT DATE FROM TOMORROW')
             GOTO       STP4

 STP3:       IF         (&RKUBN *EQ 'N') GOTO STP10
             CHGVAR     VAR(&RHIZK) VALUE(&DATE8)
             CHGVAR     VAR(&RTIME) VALUE(&WTIME)

 STP10:      DLTF       FILE(AAXWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(RCLWP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(RCLWP42)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(RCLWP43)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(RCLWP44)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(RCLWP45)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/AAXWP01) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)
             CRTPF      FILE(&WLIB/RCLWP41) RCDLEN(355) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)
             CRTPF      FILE(&WLIB/RCLWP42) RCDLEN(232) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)
             CRTPF      FILE(&WLIB/RCLWP43) RCDLEN(80) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)
             CRTPF      FILE(&WLIB/RCLWP44) RCDLEN(70) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)
             CRTPF      FILE(&WLIB/RCLWP45) RCDLEN(80) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(AAXR01) PARM(&RKUBN &RHIZK &RTIME 'S')

             IF         (%SWITCH(0XXXXXXX)) GOTO STP11
             IF         (%SWITCH(XXXX1XXX)) GOTO STP11
             GOTO       STP12

 STP11:      DLTF       FILE(AAXWP01)
             DLTF       FILE(RCLWP41)
             DLTF       FILE(RCLWP42)
             DLTF       FILE(RCLWP43)
             DLTF       FILE(RCLWP44)
             DLTF       FILE(RCLWP45)

             IF         (%SWITCH(XXXX0XXX)) GOTO END
 STP13:      SNDPGMMSG  MSG('** ( G ) CALENDAR FILE BEING WRONG. +
                        CONTACT YOU TO EDP SECTION  **') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP13

 STP12:      CALL       PGM(RCLR42) PARM(&RHIZK &RTIME)

             /*--------------------------*/
             /*   LIMITATION KANBAN INSTRUCTION   */
             /*--------------------------*/
             DLTF       FILE(RCLWP46)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/RCLWP46) RCDLEN(232) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/RCLWP42)) +
                          OUTFILE(&WLIB/RCLWP46) SRCFILE(FMTSRC) +
                          SRCMBR(AAXS02) OPTION(*NOPRT)
             DLTF       FILE(RCLWP42)

             OVRPRTF    FILE(AAXPR02) DEVTYPE(&PDEVT) PAGESIZE(66) +
                          LPI(6) OVRFLW(57) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(AAXR02) PARM(&RHIZK &RTIME)
             DLTOVR     FILE(AAXPR02)
             DLTF       FILE(RCLWP46)

             /*--------------------*/
             /*   PROCESSING STATEMENT OF DELIVERY   */
             /*--------------------*/
             IF         (%SWITCH(XXXXXX0X)) DO
             DLTF       FILE(AAXWP01)
             ENDDO
             ELSE       DO

             DLTF       FILE(AAXWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAXWP03) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AAXWP01)) +
                          OUTFILE(&WLIB/AAXWP03) SRCFILE(FMTSRC) +
                          SRCMBR(AAXS07) OPTION(*NOPRT)
             DLTF       FILE(AAXWP01)

    /* OVRPRTF FILE(AAXPR03) PAGESIZE(24) LPI(6) OVRFLW(24) + */
    /*               RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(D641) */
    /* CALL PGM(AAXR03) PARM(&US)                                 */
    /* DLTOVR FILE(AAXPR03)                                       */
    /* DLTF FILE(AAXWP03)                                         */
             ENDDO

             /*--------------------------------*/
             /*   LIMITATION / THE TRIAL MFG. PART MATERIALS DETAILS   */
             /*--------------------------------*/
             IF         (%SWITCH(X0XXXXXX)) GOTO STP14

             DLTF       FILE(RCLWP47)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/RCLWP47) RCDLEN(80) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/RCLWP43)) +
                          OUTFILE(&WLIB/RCLWP47) SRCFILE(FMTSRC) +
                          SRCMBR(AAXS03) OPTION(*NOPRT)
             DLTF       FILE(RCLWP43)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(RCLR44) PARM(&RHIZK &RTIME &WSID)
             DLTF       FILE(RCLWP47)
             DLTOVR     FILE(QPRINT)

 STP14:      DLTF       FILE(RCLWP44)
             MONMSG     MSGID(CPF3261 CPF2105)

             /*----------------------------------------*/
             /*   LIMITATION PART / THE TRIAL MFG. PART COMPONENTS DETAILS   */
             /*----------------------------------------*/
             IF         (%SWITCH(XX0XXXXX)) GOTO STP16

             DLTF       FILE(RCLWP49)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/RCLWP49) RCDLEN(80) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/RCLWP45)) +
                          OUTFILE(&WLIB/RCLWP49) SRCFILE(FMTSRC) +
                          SRCMBR(AAXS04) OPTION(*NOPRT)
             DLTF       FILE(RCLWP45)

             DLTF       FILE(RCLWP49A)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(RCLWP49B)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/RCLWP49A) RCDLEN(80) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL) /* PRODUCTION MANAGEMENTL SECTION */
             CRTPF      FILE(&WLIB/RCLWP49B) RCDLEN(80) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL) /* SUPPLY MANAGEMENT SECTION */

             CALL       PGM(RCLR48) PARM(&HK1 &HK2)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             IF         COND(&HK1 *EQ '*') THEN(DO)
             CALL       PGM(RCLR49) PARM(&RHIZK &RTIME &WSID &US)
             ENDDO

             IF         COND(&HK2 *EQ '*') THEN(DO)
             CALL       PGM(RCLR50) PARM(&RHIZK &RTIME &WSID &US)
             ENDDO

             DLTF       FILE(RCLWP49)
             DLTF       FILE(RCLWP49A)
             DLTF       FILE(RCLWP49B)
             DLTOVR     FILE(QPRINT)

 STP16:      DLTF       FILE(RCLWP50)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(RCLWP51)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/RCLWP50) RCDLEN(355) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/RCLWP41)) +
                          OUTFILE(&WLIB/RCLWP50) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAXS05) +
                          OPTION(*NOPRT)
        /* DLTF FILE(RCLWP41) */

             CALL       PGM(AAXC05) PARM(&RKUBN)
        /* DLTF FILE(RCLWP50) */
             GOTO       CMDLBL(END)

 SEND:       DLTDTAARA  DTAARA(RCLACT)

 END:        DLTDTAARA  DTAARA(AAXACT)
             CHGJOB     RUNPTY(20)

 $END:       ENDPGM
