             PGM
             /** ABBC50 *************************/
             /*  ..SETTING NUMBER CHECK LIST..  */
             /*    I-HASADA         97.11.14    */
             /*    N-HYOTO          00.11.28    */
             /*    H.AMANO          01.07.23    */
             /* UPDATE:K.OKACHI    2002.05.30    %0001 */
             /* UPDATE:TCHK1       2006.02.08    TCHK1 */
             /* UPDATE:T.SAKAKI    2015.09.05 OUTQ:MONTHLY */
             /************************* ABBC50 **/
             DCLF       FILE(ABBPW50)
             DCL        VAR(&ABBDS2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ABDDS1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABDDS11) TYPE(*CHAR) LEN(6)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYMD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PZYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHIZ1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PHIZ2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCD) TYPE(*CHAR) LEN(3)
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
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)

/* %0001 */  DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)



             RTVDTAARA  DTAARA(ABBDS2) RTNVAR(&ABBDS2)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&PYMD)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(&PRTG) VALUE('MONTHLY   ')

             CHGVAR     VAR(%SST(&PYM 3 4)) VALUE(%SST(&PYMD 1 4))
             CHGVAR     VAR(%SST(&PYM 1 2)) VALUE('19')
             IF         (%SST(&PYM 3 2) *LT '97') DO
             CHGVAR     VAR(%SST(&PYM 1 2)) VALUE('20')
             ENDDO

 STPA:       SNDRCVF    DEV(&WSID) RCDFMT(ABBPW501)

             IF         (&IN01 *EQ '1') GOTO SEND

             IF         (&IN05 *EQ '0') GOTO STPA

             CHGVAR     VAR(&PKBN) VALUE('A')

             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&PZYM) VALUE(%SST(&ABBDS3 1 6))

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
/*    %0001    */
             DLTF       FILE(ABBWPA0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWPA0) RCDLEN(250) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             CALL ABBRA0
             RTVMBRD    FILE(&WLIB/ABBWPA0) NBRCURRCD(&REC)
             IF ( &REC *NE 0 ) DO
                 CPYF       FROMFILE(&WLIB/ABBWPA0) +
                          TOFILE(&WLIB/ABBWP08) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             ENDDO

             RTVMBRD    FILE(&WLIB/ABBWP08) NBRCURRCD(&REC)
             IF ( &REC *NE 0 ) DO
                 FMTDTA     INFILE((&WLIB/ABBWP08)) +
                          OUTFILE(&WLIB/ABBWP08) SRCFILE(FMTSRC) +
                          SRCMBR(ABBSA0) OPTION(*NOPRT)
             ENDDO
/*    %0001    */


             CHGJOB     SWS(00000000)

             CLRPFM     FILE(ABBNP09)
             CLRPFM     FILE(ABBWP50)

             DLTF       FILE(ABBWP09)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP09) RCDLEN(120) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(ABBWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP10) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CLRPFM     FILE(ABBWP5X)

             OVRPRTF    FILE(QPRINT3) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) OVRFLW(82) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) +
                          MAXRCDS(*NOMAX) HOLD(*YES) SAVE(*YES) +
                          IGCDTA(&PIGCD)
             CALL       PGM(ABBR50) PARM(&PKBN &PHIZ1 &PHIZ2 &PYM +
                          &PCD &PZYM &PMM1 &PMM2 &PMM3 &PCD1 &PCD2 +
                          &PCD3 &PN1DD &PN2DD &PJ1DD &PJ2DD &PJ3DD)
             DLTOVR     FILE(QPRINT3)

/* TCHK1     DLTF       FILE(ABBWP11)                                */
/* TCHK1     MONMSG     MSGID(CPF3261 CPF2105)                       */
/* TCHK1     CRTPF      FILE(&WLIB/ABBWP11) RCDLEN(256) +            */
/* TCHK1                  OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) + */
/* TCHK1                  AUT(*ALL)                                  */
/* TCHK1                                                             */
/* TCHK1     RTVMBRD    FILE(&WLIB/ABBWP10) NBRCURRCD(&REC)          */
/* TCHK1     IF (&REC *NE 0) DO                                      */
/* TCHK1         FMTDTA     INFILE((&WLIB/ABBWP10)) +                */
/* TCHK1                  OUTFILE(&WLIB/ABBWP11) SRCFILE(FMTSRC) +   */
/* TCHK1                  SRCMBR(ABBS11) OPTION(*NOPRT)              */
/* TCHK1                                                             */
/* TCHK1         OVRPRTF    FILE(QPRINT3) DEVTYPE(&PDEVT) PAGESIZE(88 + */
/* TCHK1                  132) LPI(8) OVRFLW(82) RPLUNPRT(*YES) +    */
/* TCHK1                  OUTQ(&PRTG) FORMTYPE(K6H1) +               */
/* TCHK1                  MAXRCDS(*NOMAX) IGCDTA(&PIGCD)             */
/* TCHK1         CALL       PGM(ABBR51)                              */
/* TCHK1         DLTOVR     FILE(QPRINT3)                            */
/* TCHK1     ENDDO                                                   */

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

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          COPIES(3) MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          COPIES(2) MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
/*           CALL       PGM(ABBR11) PARM(&PYM)             */

             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(QPRINT2)

             CALL       PGM(ABBC15)

             CHGVAR     VAR(&ABBDS2) VALUE(&PYM)
             CHGDTAARA  DTAARA(ABBDS2) VALUE(&ABBDS2)

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

 SEND:       ENDPGM
