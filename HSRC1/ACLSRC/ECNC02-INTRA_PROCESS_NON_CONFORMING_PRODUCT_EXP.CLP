             PGM
             /** ECNC02 ****************************/
             /* INTRA-PROCESS NON-CONFORMING PRODUCT EXPLANATION MATERIAL */
             /* I-HASADA              87.04.02     */
             /**************************** ECNC02 **/
             DCLF       FILE(ECNPW02)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DMM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FWP03) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FWP04) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FWW05) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FWP05) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FWP06) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FWP09) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FWW10) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FWP10) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FWP16) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FWW17) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FWP17) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FTP02) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FTP03) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FTP05) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FTP06) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FTP15) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FTP18) TYPE(*CHAR) LEN(9)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&IN20) VALUE('1')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&FWP03) VALUE('ECNWP03' *CAT &WS)
             CHGVAR     VAR(&FWP04) VALUE('ECNWP04' *CAT &WS)
             CHGVAR     VAR(&FWW05) VALUE('ECNWW05' *CAT &WS)
             CHGVAR     VAR(&FWP05) VALUE('ECNWP05' *CAT &WS)
             CHGVAR     VAR(&FWP06) VALUE('ECNWP06' *CAT &WS)
             CHGVAR     VAR(&FWP09) VALUE('ECNWP09' *CAT &WS)
             CHGVAR     VAR(&FWW10) VALUE('ECNWW10' *CAT &WS)
             CHGVAR     VAR(&FWP10) VALUE('ECNWP10' *CAT &WS)
             CHGVAR     VAR(&FWP16) VALUE('ECNWP16' *CAT &WS)
             CHGVAR     VAR(&FWW17) VALUE('ECNWW17' *CAT &WS)
             CHGVAR     VAR(&FWP17) VALUE('ECNWP17' *CAT &WS)
             CHGVAR     VAR(&FTP02) VALUE('ECNTP02' *CAT &WS)
             CHGVAR     VAR(&FTP03) VALUE('ECNTP03' *CAT &WS)
             CHGVAR     VAR(&FTP05) VALUE('ECNTP05' *CAT &WS)
             CHGVAR     VAR(&FTP06) VALUE('ECNTP06' *CAT &WS)
             CHGVAR     VAR(&FTP15) VALUE('ECNTP15' *CAT &WS)
             CHGVAR     VAR(&FTP18) VALUE('ECNTP18' *CAT &WS)
             /*-------------------------*/
             /* ...SCREEN 1... */
             /*-------------------------*/
 VG1:        SNDRCVF    DEV(&WSID) RCDFMT(ECNPW021)
             IF         (&IN01 = '1') GOTO SEND

             CHGVAR     VAR(&IN16) VALUE('0')
             CHGVAR     VAR(&IN18) VALUE('0')
             CHGVAR     VAR(&IN23) VALUE('0')
             CHGVAR     VAR(&IN25) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&PKBN *EQ '01') GOTO STP1
             IF         (&PKBN *EQ '02') GOTO VG2

             CHGVAR     VAR(&IN16) VALUE('1')
             CHGVAR     VAR(&IN20) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SELECT INSTRUCTION < 1.2 >')
             GOTO       VG1

 VG2:        CHGVAR     VAR(&IN20) VALUE('0')
             CHGVAR     VAR(&IN21) VALUE('1')
             CHGVAR     VAR(&IN22) VALUE('0')

             IF         (&IN17 *EQ '1') GOTO VG5
             CHGVAR     VAR(&IN17) VALUE('1')
             GOTO       VG1

 VG5:        IF         (%SUBSTRING(&PHIZ 1 4) *LT '1985') GOTO VG3
             IF         (%SUBSTRING(&PHIZ 5 2) *GT '12') GOTO VG3
             IF         (%SUBSTRING(&PHIZ 5 2) *LT '01') GOTO VG3
             GOTO       VG4

 VG3:        CHGVAR     VAR(&IN18) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE IS NOT RIGHT')
             GOTO       VG1

 VG4:        IF         (&IN14 *EQ '0') GOTO VG1

             IF         (&PKBN *EQ '02') CHGVAR VAR(&PBMON) +
                          VALUE('0111')

             CHGVAR     VAR(&DTNO) VALUE('1')
             CHGVAR     VAR(&DJAB) VALUE('A')
             CHGVAR     VAR(&DTKI) VALUE(&PHIZ)
             CHGVAR     VAR(&DRNO) VALUE('1')
             CHGVAR     VAR(&DBKA) VALUE('01')
             GOTO       STEP2

             /*-------------------------*/
             /* ...SCREEN 2... */
             /*-------------------------*/
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ECNPW022)
             IF         (&IN01 = '1') GOTO SEND

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
             CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN13) VALUE('0')
             CHGVAR     VAR(&IN15) VALUE('0')
             CHGVAR     VAR(&IN26) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN19 *EQ '0') GOTO STEP4
             CHGVAR     VAR(&IN17) VALUE('0')
             CHGVAR     VAR(&IN18) VALUE('0')
             CHGVAR     VAR(&IN20) VALUE('1')
             CHGVAR     VAR(&IN21) VALUE('0')
             CHGVAR     VAR(&PKBN) VALUE('  ')
             GOTO       VG1

 STEP4:      IF         (&PBMON *EQ '    ') DO
                CHGVAR     VAR(&IN26) VALUE('1')
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR     VAR(&MSG)  VALUE('SECTION IS NOT INPUT')
                GOTO       STP1
             ENDDO

             IF         (&DRNO *EQ '1') GOTO STP2
             IF         (&DRNO *EQ '2') GOTO STP2
             IF         (&DRNO *EQ '3') GOTO STP2

             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT  LIST KIND NO')
             GOTO       STP1

 STP2:       IF         (&DTNO *EQ '1') GOTO STP3
             IF         (&DTNO *EQ '2') GOTO STP3
             IF         (&DTNO *EQ '3') GOTO STP3

             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT LIST FORM NO')
             GOTO       STP1

 STP3:       IF         (&DRNO *EQ '1') GOTO STEP1
             CHGVAR     VAR(&IN12) VALUE('1')
             IF         (&DJAB *EQ 'A') GOTO STEP1
             IF         (&DJAB *EQ 'B') GOTO STEP1

             CHGVAR     VAR(&IN13) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('( A.B ) INPUT EITHER OF THEM')
             GOTO       STP1

 STEP1:      IF         (&DBKA *NE '  ') GOTO STEP3
             CHGVAR     VAR(&IN15) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT DEPARTMENT AND SECTION')
             GOTO       STP1

 STEP3:      IF         (&DTNO *EQ '1') GOTO STP4
             IF         (&DTNO *EQ '2') GOTO STP5

             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&DTKI) VALUE('      ')
             CHGVAR     VAR(&DJKI) VALUE('      ')
             CHGVAR     VAR(&DJUN) VALUE(' ')

             IF         (&DHIZ1 *NE '        ') GOTO STP6
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT THE DATE OF NUMBER 1')
             GOTO       STP1

 STP6:       IF         (%SUBSTRING(&DHIZ1 1 4) *LT '1985') GOTO STP7
             IF         (%SUBSTRING(&DHIZ1 5 2) *GT '12') GOTO STP7
             IF         (%SUBSTRING(&DHIZ1 5 2) *LT '01') GOTO STP7
             IF         (%SUBSTRING(&DHIZ1 7 2) *GT '31') GOTO STP7
             IF         (%SUBSTRING(&DHIZ1 7 2) *LT '01') GOTO STP7
             GOTO       STP8

 STP7:       CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF NUMBER 1 IS NOT RIGHT')
             GOTO       STP1

 STP8:       IF         (&DHIZ2 *NE '        ') GOTO STP9
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT THE DATE OF NUMBER 2')
             GOTO       STP1

 STP9:       IF         (%SUBSTRING(&DHIZ2 1 4) *LT '1985') GOTO STP10
             IF         (%SUBSTRING(&DHIZ2 5 2) *GT '12') GOTO STP10
             IF         (%SUBSTRING(&DHIZ2 5 2) *LT '01') GOTO STP10
             IF         (%SUBSTRING(&DHIZ2 7 2) *GT '31') GOTO STP10
             IF         (%SUBSTRING(&DHIZ2 7 2) *LT '01') GOTO STP10
             GOTO       STP11

 STP10:      CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE OF NUMBER 2 IS NOT RIGHT')
             GOTO       STP1

 STP11:      IF  (&DHIZ1 *LE &DHIZ2) GOTO STP12

             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT THE DATE OF NUMBER 1 AGAIN ')
             GOTO       STP1

 STP4:       CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&DJKI) VALUE('      ')
             CHGVAR     VAR(&DJUN) VALUE(' ')
             CHGVAR     VAR(&DHIZ1) VALUE('        ')
             CHGVAR     VAR(&DHIZ2) VALUE('        ')

             IF         (&DTKI *NE '      ') GOTO STP13
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE IS NOT INPUT')
             GOTO       STP1

 STP13:      IF         (%SUBSTRING(&DTKI 1 4) *LT '1985') GOTO STP14
             IF         (%SUBSTRING(&DTKI 5 2) *GT '12') GOTO STP14
             IF         (%SUBSTRING(&DTKI 5 2) *LT '01') GOTO STP14
             GOTO       STP12

 STP14:      CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE IS NOT RIGHT')
             GOTO       STP1

 STP5:       CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&DTKI) VALUE('      ')
             CHGVAR     VAR(&DHIZ1) VALUE('        ')
             CHGVAR     VAR(&DHIZ2) VALUE('        ')

             IF         (&DJKI *NE '      ') GOTO STP15
             CHGVAR     VAR(&IN08) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE IS NOT INPUT')
             GOTO       STP1

 STP15:      IF         (%SUBSTRING(&DJKI 1 4) *LT '1985') GOTO STP16
             IF         (%SUBSTRING(&DJKI 5 2) *GT '12') GOTO STP16
             IF         (%SUBSTRING(&DJKI 5 2) *LT '01') GOTO STP16
             GOTO       STP17

 STP16:      CHGVAR     VAR(&IN08) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE IS NOT RIGHT')
             GOTO       STP1

 STP17:      IF  (&DJUN *EQ '1') GOTO STP12
             IF  (&DJUN *EQ '2') GOTO STP12
             IF  (&DJUN *EQ '3') GOTO STP12

             CHGVAR     VAR(&IN09) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('TEN DAYS NO IS NOT INPUT')
             GOTO       STP1

 STP12:      IF         (&IN14 = '1') GOTO STEP2
             GOTO       STP1

 STEP2:      CHGVAR     VAR(&FWP03) VALUE('ECNWP03' *CAT &WS)
             CHGVAR     VAR(&FWP04) VALUE('ECNWP04' *CAT &WS)
             CHGVAR     VAR(&FWW05) VALUE('ECNWW05' *CAT &WS)
             CHGVAR     VAR(&FWP05) VALUE('ECNWP05' *CAT &WS)
             CHGVAR     VAR(&FWP06) VALUE('ECNWP06' *CAT &WS)
             CHGVAR     VAR(&FWP09) VALUE('ECNWP09' *CAT &WS)
             CHGVAR     VAR(&FWW10) VALUE('ECNWW10' *CAT &WS)
             CHGVAR     VAR(&FWP10) VALUE('ECNWP10' *CAT &WS)
             CHGVAR     VAR(&FWP16) VALUE('ECNWP16' *CAT &WS)
             CHGVAR     VAR(&FWW17) VALUE('ECNWW17' *CAT &WS)
             CHGVAR     VAR(&FWP17) VALUE('ECNWP17' *CAT &WS)
             CHGVAR     VAR(&FTP02) VALUE('ECNTP02' *CAT &WS)
             CHGVAR     VAR(&FTP03) VALUE('ECNTP03' *CAT &WS)
             CHGVAR     VAR(&FTP05) VALUE('ECNTP05' *CAT &WS)
             CHGVAR     VAR(&FTP06) VALUE('ECNTP06' *CAT &WS)
             CHGVAR     VAR(&FTP15) VALUE('ECNTP15' *CAT &WS)
             CHGVAR     VAR(&FTP18) VALUE('ECNTP18' *CAT &WS)

             CHGJOB     SWS(00000000)

             DLTF       FILE(&FWP03)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP04)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWW05)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP05)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP06)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP09)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWW10)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP10)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP16)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWW17)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP17)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP02)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP03)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP05)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP06)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP15)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP18)
             MONMSG     MSGID(CPF3261 CPF2105)

             IF  (&DTNO *EQ '1') CHGVAR VAR(&DMM) VALUE(&DTKI)
             IF  (&DTNO *EQ '2') CHGVAR VAR(&DMM) VALUE(&DJKI)

             CRTPF      FILE(HWFILE1/&FTP02) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP02) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             OVRDBF     FILE(ECNTP02) TOFILE(&FTP02)
             CALL       PGM(ECNR02) PARM(&DTNO &DJUN &DMM &DHIZ1 +
                          &DHIZ2 &DJRYO &DFRNO &DKINO &DBKA &PBMON)

             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       SEND
             ENDDO

             DLTOVR     FILE(ECNTP02)
             CRTPF      FILE(HWFILE1/&FWP03) RCDLEN(60) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FTP02)) +
                          OUTFILE(HWFILE1/&FWP03) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS02) OPTION(*NOPRT)

             CRTPF      FILE(HWFILE1/&FTP03) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP03) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             IF         (&DRNO *NE '1') GOTO STP18

             OVRDBF     FILE(ECNWP03) TOFILE(&FWP03)
             OVRDBF     FILE(ECNTP03) TOFILE(&FTP03)
             CALL       PGM(ECNR03)
             DLTOVR     FILE(ECNWP03)
             DLTOVR     FILE(ECNTP03)

             CRTPF      FILE(HWFILE1/&FWP04) RCDLEN(60) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FWP03)) +
                          OUTFILE(HWFILE1/&FWP04) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS03) OPTION(*NOPRT)

             DLTF       FILE(&FWP03)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             OVRDBF     FILE(ECNWP04) TOFILE(&FWP04)
             OVRDBF     FILE(ECNTP03) TOFILE(&FTP03)
             CALL       PGM(ECNR04) PARM(&DTNO &DJUN &DMM &DHIZ1 +
                          &DHIZ2 &DJRYO &PBMON)
             DLTOVR     FILE(ECNWP04)
             DLTOVR     FILE(ECNTP03)

             DLTF       FILE(&FTP02)
             DLTF       FILE(&FTP03)
             DLTF       FILE(&FWP04)
             DLTOVR     FILE(QPRINT)

             GOTO       SEND

 STP18:      CRTPF      FILE(HWFILE1/&FWW05) RCDLEN(60) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             CRTPF      FILE(HWFILE1/&FWP05) RCDLEN(40) TEXT('INTRA-PROCESS +
                        NON-CONFORMING WORK-PF') OPTION(*NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             IF         (&DRNO *EQ '3') GOTO STP19
             IF         (&DJAB *EQ 'B') GOTO STP20

             FMTDTA     INFILE((HWFILE1/&FWP03)) +
                          OUTFILE(HWFILE1/&FWW05) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS05) OPTION(*NOPRT)

             DLTF       FILE(&FWP03)

             CRTPF      FILE(HWFILE1/&FTP05) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP05) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             OVRDBF     FILE(ECNWW05) TOFILE(&FWW05)
             OVRDBF     FILE(ECNWP05) TOFILE(&FWP05)
             OVRDBF     FILE(ECNTP05) TOFILE(&FTP05)
             CALL       PGM(ECNR05)
             DLTOVR     FILE(ECNWW05)
             DLTOVR     FILE(ECNWP05)
             DLTOVR     FILE(ECNTP05)

             CRTPF      FILE(HWFILE1/&FTP06) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP06) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)
             CRTPF      FILE(HWFILE1/&FWP06) RCDLEN(40) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FWP05)) +
                          OUTFILE(HWFILE1/&FWP06) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS06) OPTION(*NOPRT)
             DLTF       FILE(&FWP05)

             OVRDBF     FILE(ECNWP06) TOFILE(&FWP06)
             OVRDBF     FILE(ECNTP06) TOFILE(&FTP06)
             CALL       PGM(ECNR06)
             DLTOVR     FILE(ECNWP06)
             DLTOVR     FILE(ECNTP06)

             GOTO       STP21

 STP20:      FMTDTA     INFILE((HWFILE1/&FWP03)) +
                          OUTFILE(HWFILE1/&FWW05) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS05) OPTION(*NOPRT)
             DLTF       FILE(&FWP03)

             CRTPF      FILE(HWFILE1/&FTP05) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP05) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             OVRDBF     FILE(ECNWW05) TOFILE(&FWW05)
             OVRDBF     FILE(ECNWP05) TOFILE(&FWP05)
             OVRDBF     FILE(ECNTP05) TOFILE(&FTP05)
             CALL       PGM(ECNR07)
             DLTOVR     FILE(ECNWW05)
             DLTOVR     FILE(ECNWP05)
             DLTOVR     FILE(ECNTP05)

             CRTPF      FILE(HWFILE1/&FTP06) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP06) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             CRTPF      FILE(HWFILE1/&FWP06) RCDLEN(40) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FWP05)) +
                          OUTFILE(HWFILE1/&FWP06) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS07) OPTION(*NOPRT)
             DLTF       FILE(&FWP05)

             OVRDBF     FILE(ECNWP06) TOFILE(&FWP06)
             OVRDBF     FILE(ECNTP06) TOFILE(&FTP06)
             CALL       PGM(ECNR06)
             DLTOVR     FILE(ECNWP06)
             DLTOVR     FILE(ECNTP06)

 STP21:      OVRDBF     FILE(ECNWP06) TOFILE(&FWP06)
             OVRDBF     FILE(ECNTP02) TOFILE(&FTP02)
             OVRDBF     FILE(ECNTP03) TOFILE(&FTP03)
             CALL       PGM(ECNR08)
             DLTOVR     FILE(ECNWP06)
             DLTOVR     FILE(ECNTP02)
             DLTOVR     FILE(ECNTP03)

             DLTF       FILE(&FWP06)
             CRTPF      FILE(HWFILE1/&FWP09) RCDLEN(20) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             OVRDBF     FILE(ECNTP02) TOFILE(&FTP02)
             OVRDBF     FILE(ECNWP09) TOFILE(&FWP09)
             CALL       PGM(ECNR09)
             DLTOVR     FILE(ECNTP02)
             DLTOVR     FILE(ECNWP09)

             CRTPF      FILE(HWFILE1/&FWW10) RCDLEN(20) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FWP09)) +
                          OUTFILE(HWFILE1/&FWW10) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS09) OPTION(*NOPRT)
             DLTF       FILE(&FWP09)

             CRTPF      FILE(HWFILE1/&FWP10) RCDLEN(63) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             OVRDBF     FILE(ECNWW10) TOFILE(&FWW10)
             OVRDBF     FILE(ECNWP10) TOFILE(&FWP10)
             OVRDBF     FILE(ECNTP02) TOFILE(&FTP02)
             CALL       PGM(ECNR10)
             DLTOVR     FILE(ECNWW10)
             DLTOVR     FILE(ECNWP10)
             DLTOVR     FILE(ECNTP02)

             DLTF       FILE(&FWW10)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)

             OVRDBF     FILE(ECNWP10) TOFILE(&FWP10)
             OVRDBF     FILE(ECNTP05) TOFILE(&FTP05)
             OVRDBF     FILE(ECNTP06) TOFILE(&FTP06)
             OVRDBF     FILE(ECNTP03) TOFILE(&FTP03)
             CALL       PGM(ECNR11) PARM(&DTNO &DJUN &DMM &DHIZ1 +
                          &DHIZ2 &DJAB &DJRYO &DFRNO &PBMON)
             DLTOVR     FILE(ECNWP10)
             DLTOVR     FILE(ECNTP05)
             DLTOVR     FILE(ECNTP06)
             DLTOVR     FILE(ECNTP03)

             DLTF       FILE(&FTP02)
             DLTF       FILE(&FTP03)
             DLTF       FILE(&FTP05)
             DLTF       FILE(&FTP06)
             DLTF       FILE(&FWP10)
             DLTOVR     FILE(QPRINT)

             GOTO       SEND

 STP19:      IF         (&DJAB *EQ 'B') GOTO STP22

             FMTDTA     INFILE((HWFILE1/&FWP03)) +
                          OUTFILE(HWFILE1/&FWW05) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS13) OPTION(*NOPRT)

             DLTF       FILE(&FWP03)

             CRTPF      FILE(HWFILE1/&FTP05) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP05) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             OVRDBF     FILE(ECNWW05) TOFILE(&FWW05)
             OVRDBF     FILE(ECNWP05) TOFILE(&FWP05)
             OVRDBF     FILE(ECNTP05) TOFILE(&FTP05)
             CALL       PGM(ECNR12)
             DLTOVR     FILE(ECNWW05)
             DLTOVR     FILE(ECNWP05)
             DLTOVR     FILE(ECNTP05)

             CRTPF      FILE(HWFILE1/&FTP06) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP06) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)
             CRTPF      FILE(HWFILE1/&FWP06) RCDLEN(40) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FWP05)) +
                          OUTFILE(HWFILE1/&FWP06) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS12) OPTION(*NOPRT)

             DLTF       FILE(&FWP05)

             OVRDBF     FILE(ECNWP06) TOFILE(&FWP06)
             OVRDBF     FILE(ECNTP06) TOFILE(&FTP06)
             CALL       PGM(ECNR13)
             DLTOVR     FILE(ECNWP06)
             DLTOVR     FILE(ECNTP06)

             GOTO       STP23

 STP22:      FMTDTA     INFILE((HWFILE1/&FWP03)) +
                          OUTFILE(HWFILE1/&FWW05) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS13) OPTION(*NOPRT)

             DLTF       FILE(&FWP03)

             CRTPF      FILE(HWFILE1/&FTP05) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP05) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             OVRDBF     FILE(ECNWW05) TOFILE(&FWW05)
             OVRDBF     FILE(ECNWP05) TOFILE(&FWP05)
             OVRDBF     FILE(ECNTP05) TOFILE(&FTP05)
             CALL       PGM(ECNR14)
             DLTOVR     FILE(ECNWW05)
             DLTOVR     FILE(ECNWP05)
             DLTOVR     FILE(ECNTP05)

             CRTPF      FILE(HWFILE1/&FTP06) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP06) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             CRTPF      FILE(HWFILE1/&FWP06) RCDLEN(40) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FWP05)) +
                          OUTFILE(HWFILE1/&FWP06) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS14) OPTION(*NOPRT)

             DLTF       FILE(&FWP05)

             OVRDBF     FILE(ECNWP06) TOFILE(&FWP06)
             OVRDBF     FILE(ECNTP06) TOFILE(&FTP06)
             CALL       PGM(ECNR13)
             DLTOVR     FILE(ECNWP06)
             DLTOVR     FILE(ECNTP06)

 STP23:      CRTPF      FILE(HWFILE1/&FTP15) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP15) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             CPYF       FROMFILE(&FTP02) TOFILE(&FTP15) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2869 CPF2817)

             OVRDBF     FILE(ECNWP06) TOFILE(&FWP06)
             OVRDBF     FILE(ECNTP15) TOFILE(&FTP15)
             OVRDBF     FILE(ECNTP03) TOFILE(&FTP03)
             CALL       PGM(ECNR15)
             DLTOVR     FILE(ECNWP06)
             DLTOVR     FILE(ECNTP15)
             DLTOVR     FILE(ECNTP03)

             DLTF       FILE(&FWP06)

             CRTPF      FILE(HWFILE1/&FWP16) RCDLEN(20) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             OVRDBF     FILE(ECNTP15) TOFILE(&FTP15)
             OVRDBF     FILE(ECNWP16) TOFILE(&FWP16)
             CALL       PGM(ECNR16)
             DLTOVR     FILE(ECNTP15)
             DLTOVR     FILE(ECNWP16)

             CRTPF      FILE(HWFILE1/&FWW17) RCDLEN(20) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FWP16)) +
                          OUTFILE(HWFILE1/&FWW17) SRCFILE(FMTSRC) +
                          SRCMBR(ECNS16) OPTION(*NOPRT)

             DLTF       FILE(&FWP16)

             CRTPF      FILE(HWFILE1/&FWP17) RCDLEN(60) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             OVRDBF     FILE(ECNWW17) TOFILE(&FWW17)
             OVRDBF     FILE(ECNWP17) TOFILE(&FWP17)
             OVRDBF     FILE(ECNTP15) TOFILE(&FTP15)
             CALL       PGM(ECNR17)
             DLTOVR     FILE(ECNWW17)
             DLTOVR     FILE(ECNWP17)
             DLTOVR     FILE(ECNTP15)

             DLTF       FILE(&FWW17)

             CRTPF      FILE(HWFILE1/&FTP18) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECNTP18) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             CPYF       FROMFILE(&FTP06) TOFILE(&FTP18) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2869 CPF2817)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             OVRDBF     FILE(ECNWP17) TOFILE(&FWP17)
             OVRDBF     FILE(ECNTP05) TOFILE(&FTP05)
             OVRDBF     FILE(ECNTP18) TOFILE(&FTP18)
             OVRDBF     FILE(ECNTP03) TOFILE(&FTP03)
             CALL       PGM(ECNR18) PARM(&DTNO &DJUN &DMM &DHIZ1 +
                          &DHIZ2 &DJAB &DJRYO &DKINO &PBMON)
             DLTOVR     FILE(ECNWP17)
             DLTOVR     FILE(ECNTP05)
             DLTOVR     FILE(ECNTP18)
             DLTOVR     FILE(ECNTP03)

             DLTF       FILE(&FTP02)
             DLTF       FILE(&FTP03)
             DLTF       FILE(&FTP05)
             DLTF       FILE(&FTP06)
             DLTF       FILE(&FTP15)
             DLTF       FILE(&FTP18)
             DLTF       FILE(&FWP17)

             DLTOVR     FILE(QPRINT)

 SEND:       DLTF       FILE(&FWP03)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP04)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWW05)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP05)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP06)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP09)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWW10)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP10)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP16)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWW17)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FWP17)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP02)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP03)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP05)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP06)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP15)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FTP18)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
