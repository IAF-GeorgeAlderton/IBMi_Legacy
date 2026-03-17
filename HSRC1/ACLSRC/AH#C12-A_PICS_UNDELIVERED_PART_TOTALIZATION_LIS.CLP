             PGM
             /** AH#C12 **********************************/
             /* A-PICS UNDELIVERED PART TOTALIZATION LIST   */
             /*.                             WORST 20... */
             /* A-IDOTA                 1987.12.07       */
             /********************************** AH#C12 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE5) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE6) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE7) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE8) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE9) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILEA) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILEB) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILEC) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILED) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILEE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KUBU) TYPE(*CHAR) LEN(1)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MFBHZ) TYPE(*CHAR) LEN(54)
             DCL        VAR(&PLIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JUNI) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVDTAARA  DTAARA(HFILE1/MFBHZ) RTNVAR(&MFBHZ)
             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)

             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('AH#WP12' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('AH#WP13' *CAT &WT)
             CHGVAR     VAR(&FILE3) VALUE('AH#WP14' *CAT &WT)
             CHGVAR     VAR(&FILE4) VALUE('AH#WP15' *CAT &WT)
             CHGVAR     VAR(&FILE5) VALUE('AH#WP16' *CAT &WT)
             CHGVAR     VAR(&FILE6) VALUE('AH#WP17' *CAT &WT)
             CHGVAR     VAR(&FILE7) VALUE('AH#WP18' *CAT &WT)
             CHGVAR     VAR(&FILE8) VALUE('AH#WP19' *CAT &WT)
             CHGVAR     VAR(&FILE9) VALUE('AH#WP20' *CAT &WT)
             CHGVAR     VAR(&FILEA) VALUE('AH#WP21' *CAT &WT)
             CHGVAR     VAR(&FILEB) VALUE('AH#WP52' *CAT &WT)
             CHGVAR     VAR(&FILEC) VALUE('AH#WP53' *CAT &WT)
             CHGVAR     VAR(&FILED) VALUE('AH#NP50' *CAT &WT)
             CHGVAR     VAR(&FILEE) VALUE('AH#NP12' *CAT &WT)
             CHGJOB     RUNPTY(40) SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP1:       CHGJOB     OUTQ(&PRTG)
 /* WORK FILE CREATE AH#WP12 */
             OVRDBF     FILE(AH#WP12) TOFILE(&FILE1)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

 /* WORK FILE CREATE AH#NP12 */
             OVRDBF     FILE(AH#NP12) TOFILE(&FILEE)

             DLTF       FILE(&FILEE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILEE) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#NP12) OPTION(*NOLIST *NOSRC) +
                          SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)

             /* UNDELIVERED PART DATA WRITE IN A FILE */
             CALL       PGM(AH#R12) PARM(&KUBU &PLIST &JUNI)
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
               DLTF       FILE(&FILE1)
               DLTF       FILE(&FILEE)
               GOTO       CMDLBL(END2)
             ENDDO

             IF         (&KUBU *EQ '5') GOTO STPB

 /* WORK FILE CREATE AH#WP13 */
             OVRDBF     FILE(AH#WP13) TOFILE(&FILE2)
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S12) OPTION(*NOPRT) /* SECTION +
                          PART NUMBER */

 /* WORK FILE CREATE AH#WP14 */
             OVRDBF     FILE(AH#WP14) TOFILE(&FILE3)
             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(110) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             /* PART NUMBER TOTALIZED CALCULATION ETC */
             CALL       PGM(AH#R13)

             IF         (&KUBU *EQ '2') GOTO STPA
             IF         (&KUBU *EQ '4') GOTO STPA

 /* WORK FILE CREATE AH#WP15 */
             OVRDBF     FILE(AH#WP15) TOFILE(&FILE4)
             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE4) RCDLEN(110) +
                          TEXT('A-PICS UNDELIVERED PART +
                          TOTALIZATION APWRKILB') OPTION(*NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((HWFILE1/&FILE3)) +
                          OUTFILE(HWFILE1/&FILE4) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S13) OPTION(*NOPRT) /* SECTION +
                          PART NBR TOTAL PART NBR */

             /* UNDELIVERED PART LIST OUTPUT */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) HOLD(*NO) IGCDTA(&PIGCD)
             IF         (&PLIST *EQ '1') DO
             CALL       PGM(AH#R14) PARM(&US &JUNI)
             ENDDO
             ELSE       DO
             CALL       PGM(AH#R43) PARM(&US &JUNI)
             ENDDO

          /* DLTF       FILE(&FILE4) */

             DLTOVR     FILE(QPRINT)

             IF         (&KUBU *EQ '1') GOTO END

     /*  UNDELIVERED TOTALIZATION BY MACHINE NO */

 STPA:
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(59) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) HOLD(*NO) IGCDTA(&PIGCD)
 /* WORK FILE CREATE AH#WP16 */
             OVRDBF     FILE(AH#WP16) TOFILE(&FILE5)
             DLTF       FILE(&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE5) RCDLEN(50) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             /* REFERENCE TO NECESSARY MACHINE NO */
             IF         COND(&KUBU *EQ '4') THEN(DO)
             CALL       PGM(AH#R54)
             ENDDO
             ELSE       CMD(DO)
             CALL       PGM(AH#R15)
             ENDDO

 /* WORK FILE CREATE AH#WP17 */
             OVRDBF     FILE(AH#WP17) TOFILE(&FILE6)
             DLTF       FILE(&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE6) RCDLEN(50) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             FMTDTA     INFILE((HWFILE1/&FILE5)) +
                          OUTFILE(HWFILE1/&FILE6) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S14) OPTION(*NOPRT) /* SECTION +
                          PART NBR TOTAL PART NBR */
 /* WORK FILE CREATE AH#WP18 */
             OVRDBF     FILE(AH#WP18) TOFILE(&FILE7)
             DLTF       FILE(&FILE7)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE7) RCDLEN(60) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             /* ADDITION TO ACTUAL ALLOTMENT*/
             CALL       PGM(AH#R16)

 /* WORK FILE CREATE AH#WP19 */
             OVRDBF     FILE(AH#WP19) TOFILE(&FILE8)
             DLTF       FILE(&FILE8)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE8) RCDLEN(60) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HRFILE') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             /* RESULTS. UNIFICATION OF ETC   */
             CALL       PGM(AH#R17)

 /* WORK FILE CREATE AH#WP20 */
             OVRDBF     FILE(AH#WP20) TOFILE(&FILE9)
             DLTF       FILE(&FILE9)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE9) RCDLEN(60) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             FMTDTA     INFILE((HWFILE1/&FILE8)) +
                          OUTFILE(HWFILE1/&FILE9) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S15) OPTION(*NOPRT) /* SECTION +
                          PART NBR TOTAL PART NBR */

 /* WORK FILE CREATE AH#WP21 */
             OVRDBF     FILE(AH#WP21) TOFILE(&FILEA)
             DLTF       FILE(&FILEA)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILEA) RCDLEN(60) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             IF         COND(&KUBU *EQ '4') THEN(DO)
 /* WORK FILE CREATE AH#NP50 */
             OVRDBF     FILE(AH#NP50) TOFILE(&FILED)
             DLTF       FILE(&FILED)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILED) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#NP50) TEXT('A-PICS UNDELIVERED +
                          PART TOTALIZATION HWFILE1') OPTION(*NOLIST +
                          *NOSOURCE) SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)
 /* WORK FILE CREATE AH#WP52 */
             OVRDBF     FILE(AH#WP52) TOFILE(&FILEB)
             DLTF       FILE(&FILEB)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILEB) RCDLEN(100) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
 /* WORK FILE CREATE AH#WP53 */
             OVRDBF     FILE(AH#WP53) TOFILE(&FILEC)
             DLTF       FILE(&FILEC)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILEC) RCDLEN(100) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             CALL       PGM(AH#R51)
             CALL       PGM(AH#R50)
             CALL       PGM(AH#R52)
             FMTDTA     INFILE((HWFILE1/&FILEB)) +
                          OUTFILE(HWFILE1/&FILEC) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S52) OPTION(*NOPRT)
             CALL       PGM(AH#R53) PARM(&US &MFBHZ &JUNI)
             DLTF       FILE(&FILEB)
             DLTF       FILE(&FILEC)
             DLTF       FILE(&FILED)
             ENDDO

             ELSE       CMD(DO)
             /* OPERATION DAYS. CALCULATION  OF ETC */
             CALL       PGM(AH#R18)
             /* OUTPUT BY MACHINE NO */
             CALL       PGM(AH#R19) PARM(&US &MFBHZ &JUNI)
             ENDDO

             DLTF       FILE(&FILE5)
             DLTF       FILE(&FILE6)
             DLTF       FILE(&FILE7)
             DLTF       FILE(&FILE8)
             DLTF       FILE(&FILE9)
        /*   DLTF       FILE(&FILEA) */
             DLTOVR     FILE(QPRINT)
             GOTO       CMDLBL(END)

     /* UNDELIVERED TOTALIZATION BY DATE */

 /* WORK FILE CREATE AH#WP13 */
 STPB:       OVRDBF     FILE(AH#WP13) TOFILE(&FILE2)
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S44) OPTION(*NOPRT)

 /* WORK FILE CREATE AH#WP14 */
             OVRDBF     FILE(AH#WP14) TOFILE(&FILE3)
             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(110) +
                          TEXT('A-PICS UNDELIVERED PART TOTALIZATION HWFILE1') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             /* PART NUMBER TOTAL CALCULATION ETC */
             CALL       PGM(AH#R45)

             /* UNDELIVERED PART LIST OUTPUT */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             CALL       PGM(AH#R44) PARM(&US)

             DLTOVR     FILE(QPRINT)

 END:
      /*     DLTF       FILE(&FILE1) */
      /*     DLTF       FILE(&FILE2) */
      /**    DLTF       FILE(&FILE3) */
      /*     DLTF       FILE(&FILEE) */
 END2:
             DLTOVR     FILE(*ALL)
             CHGJOB     RUNPTY(20)
             ENDPGM
