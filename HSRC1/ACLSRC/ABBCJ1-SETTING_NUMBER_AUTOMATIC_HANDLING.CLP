             PGM        PARM(&PKBN &PYM)
             /** ABBCJ1 *********************************/
             /*  ..SETTING NUMBER AUTOMATIC HANDLING..  */
             /*  ..JOBQ                                 */
             /*     I-HASADA               86.10.01     */
             /*     N-HYOTO              2001.03.12     */
             /********************************* ABBCJ1 **/
             DCL        VAR(&ABBDS1) TYPE(*CHAR) LEN(54)
             DCL        VAR(&ABBDS2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ABDDS1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABDDS11) TYPE(*CHAR) LEN(6)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ZKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PZYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHIZ1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PHIZ2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&@CD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMM1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMM2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMM3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCD1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD2) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PN1DD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PN2DD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PJ1DD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PJ2DD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PJ3DD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&ZKBN) VALUE(&PKBN)
             RTVDTAARA  DTAARA(ABBDS1) RTNVAR(&ABBDS1)
             RTVDTAARA  DTAARA(ABBDS2) RTNVAR(&ABBDS2)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             CHGDTAARA  DTAARA(BZCDS3) VALUE(&PKBN)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&PZYM) VALUE(%SST(&ABBDS3 1 6))

             /*--------------------------------------------*/
             /* ..FROM USER PRODUCT DEMAND FORECAST DATA.. */
             /* ..FORECAST DATA INPUT                      */
             /*--------------------------------------------*/
             CALL       PGM(ABBC61) PARM(&PYM)

             CALL       PGM(ABBR12) PARM(&PN1DD &PN2DD &PJ1DD &PJ2DD +
                          &PJ3DD)

             DLTF       FILE(ABBWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP02) RCDLEN(250) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(ABBR04) PARM(&PKBN &PHIZ1 &PHIZ2 &PCD)
             IF         (%SWITCH(0XXXXXXX)) GOTO STP5

 STP6:       SNDPGMMSG  MSG('( G ) CALENDAR IS BEING WRONG, PLEASE +
                          CONTACT YOU TO EDP SECTION  < G-ENTER >') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(SEND))
             GOTO       STP6

 STP5:       DLTF       FILE(ABBWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP03) RCDLEN(250) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ABBWP02)) +
                          OUTFILE(&WLIB/ABBWP03) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS05) OPTION(*NOPRT)
             DLTF       FILE(ABBWP02)

             DLTF       FILE(ABBWP04)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP04) RCDLEN(250) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(ABBR05)
             DLTF       FILE(ABBWP03)

             DLTF       FILE(ABBWP07)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP07) RCDLEN(70) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(ABBWP05)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP05) RCDLEN(70) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(ABBR06) PARM(&PHIZ1 &PHIZ2)

             DLTF       FILE(ABBWP06)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(ABBWP18)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/ABBWP06) RCDLEN(70) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             CRTPF      FILE(&WLIB/ABBWP18) RCDLEN(70) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ABBWP05)) +
                          OUTFILE(&WLIB/ABBWP06) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS07) OPTION(*NOPRT)
             FMTDTA     INFILE((&WLIB/ABBWP05)) +
                          OUTFILE(&WLIB/ABBWP18) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS18) OPTION(*NOPRT)
             DLTF       FILE(ABBWP05)

             CALL       PGM(ABBR07)
             DLTF       FILE(ABBWP06)

             DLTF       FILE(ABBWP08)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP08) RCDLEN(250) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(ABBR08) PARM(&PKBN &PCD)
             DLTF       FILE(ABBWP04)
             DLTF       FILE(ABBWP07)

             GOTO       STP12

 STP10:      CHKOBJ     OBJ(AKEIKAKU) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP8))

 STP9:       SNDPGMMSG  MSG('( G ) PLAN NOTICE PUBLICATION SYSTEM +
                          WORKING,YOU CAN NOT USE IT AND CALL TO +
                          PLAN SECTION  < G-ENTER >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP9))
             GOTO       STP10

 STP8:       CHGJOB     SWS(00000000)

/*           CRTDTAARA  DTAARA(AKEIKAKU) TYPE(*CHAR) LEN(10) +            */
/*                        TEXT('FOR PLAN NOTICE HANDLING CHECK') +        */
/*                        AUT(*ALL)                                       */

             CRTDTAARA  DTAARA(AKEIKAKU) TYPE(*CHAR) LEN(10) +
                          TEXT('FOR PLAN NOTICE HANDLING CHECK') +
                          AUT(*ALL)

             DLTF       FILE(AAUWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(AAUWP101)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/AAUWP10) RCDLEN(60) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             CRTPF      FILE(&WLIB/AAUWP101) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(AAUR10) PARM('J' ' ' &PZYM)
             IF         (%SWITCH(1XXXXXXX)) GOTO STP11
             DLTF       FILE(AAUWP10)
             DLTF       FILE(AAUWP101)
             DLTDTAARA  DTAARA(AKEIKAKU)
             GOTO       STP12

 STP11:      DLTF       FILE(AAUWP101)

             DLTF       FILE(AAUWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AAUWP11) RCDLEN(60) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AAUWP10)) +
                          OUTFILE(&WLIB/AAUWP11) SRCFILE(FMTSRC) +
                          SRCMBR(AAUS11) OPTION(*NOPRT)
             DLTF       FILE(AAUWP10)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) ALIGN(*YES) OUTQ(&PRTG) +
                          FORMTYPE(D622) IGCDTA(&PIGCD)
             CALL       PGM(AAUR11) PARM(' ' '    ' '    ')
             DLTOVR     FILE(QPRINT)
             DLTDTAARA  DTAARA(AKEIKAKU)

 STP12:      CHGJOB     SWS(00000000)

             CLRPFM     FILE(ABBNP09)

             DLTF       FILE(ABBWP09)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP09) RCDLEN(120) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRPRTF    FILE(QPRINT3) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) OVRFLW(82) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             CALL       PGM(ABBR09) PARM(&PKBN &PHIZ1 &PHIZ2 &PYM +
                          &PCD &PZYM &PMM1 &PMM2 &PMM3 &PCD1 &PCD2 +
                          &PCD3 &PN1DD &PN2DD &PJ1DD &PJ2DD &PJ3DD)
             DLTOVR     FILE(QPRINT3)

             IF         (%SWITCH(0XXXXXXX)) GOTO STP13

 STP14:      SNDPGMMSG  MSG('( G ) CALENDAR IS BEING WRONG, PLEASE +
                          CONTACT YOU TO EDP SECTION  < G-ENTER >') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(SEND))
             GOTO       STP14

 STP13:      DLTF       FILE(ABBWP08)

             CLRPFM     FILE(ABBNP17)

             CALL       PGM(ABBR18) PARM(&PYM)
             DLTF       FILE(ABBWP18)

             CALL       PGM(ABBR17) PARM(&PKBN &PYM)
             CLRPFM     FILE(ABBNP17)

             CLRPFM     FILE(ABBWP15)
             DLTF       FILE(ABBWP16)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/ABBWP16) RCDLEN(12) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(ABBR15) PARM(&PKBN &PYM &PZYM &@CD)

             IF         (%SWITCH(XXXXX1XX)) DO

 STP21:      SNDPGMMSG  MSG('( G ) CALENDAR IS BEING WRONG, PLEASE +
                          CONTACT YOU TO EDP SECTION  < G-ENTER >') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(SEND))
             GOTO       STP21
             ENDDO

             CALL       PGM(ABBR16)
             CLRPFM     FILE(ABBWP15)

             CALL       PGM(ABBC23) PARM(&PYM &PHIZ1 &PHIZ2 &PMM1 +
                          &PMM2 &PMM3 &PCD &PCD1 &PCD2 &PCD3)

             CHGVAR     VAR(&ABBDS2) VALUE(&PYM)
             CHGDTAARA  DTAARA(ABBDS2) VALUE(&ABBDS2)
             IF         (%SWITCH(X1XXXXXX)) GOTO STP15

             DLTF       FILE(ABBWP09)
             MONMSG     MSGID(CPF3261 CPF2105)
             GOTO       STP16

 STP15:      DLTF       FILE(ABBWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP11) RCDLEN(120) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ABBWP09)) +
                          OUTFILE(&WLIB/ABBWP11) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS10) OPTION(*NOPRT)
             DLTF       FILE(ABBWP09)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             CALL       PGM(ABBR10)
             DLTOVR     FILE(QPRINT)

 STP16:      CALL       PGM(NCHCAA)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          COPIES(3) MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          COPIES(2) MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
/*           CALL       PGM(ABBR11) PARM(&PYM)                  */
             CALL       PGM(ABBC15)
             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(QPRINT2)

             CALL       PGM(ABBC13) PARM(&PYM)

             /*-----------------------------------------------*/
             /*   THE KANBAN INCREASE AND DECREASE HANDLING   */
             /*-----------------------------------------------*/
 END:        IF         (%SWITCH(XXXX0XXX)) GOTO SEND
             CALL       PGM(ABCC01) PARM(&ZKBN &@CD &PYM)

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&ABDDS11)
             CHGVAR     VAR(%SST(&ABDDS1 3 6)) VALUE(&ABDDS11)
             CHGVAR     VAR(%SST(&ABDDS1 1 2)) VALUE('20')

             IF         (%SST(&ABDDS1 3 2) *GE '97') DO
             CHGVAR     VAR(%SST(&ABDDS1 1 2)) VALUE('19')
             ENDDO

             CHGDTAARA  DTAARA(ABDDS1) VALUE(&ABDDS1)

             CHGDTAARA  DTAARA(ABBDS4) VALUE(&ABBDS3)
             CHGVAR     VAR(%SST(&ABBDS3 1 6)) VALUE(&PYM)
             CHGVAR     VAR(%SST(&ABBDS3 7 1)) VALUE('1')
             CHGDTAARA  DTAARA(ABBDS3) VALUE(&ABBDS3)

             /*------------------------------------------------------------*/
             /* A-PICS1 SETTING NUMBER FIXED INCREASE AND DECREASE LISTS   */
             /*------------------------------------------------------------*/
             CALL       PGM(ABDC0B)

 SEND:       ENDPGM
