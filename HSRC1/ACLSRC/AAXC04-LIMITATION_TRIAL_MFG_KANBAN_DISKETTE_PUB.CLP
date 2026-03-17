             PGM        PARM(&RKUBN)
             /** AAXC04 ****************************************/
             /*   LIMITATION / TRIAL MFG. KANBAN DISKETTE PUBLICATION   */
             /*        S.YAMAGAMI                94.08.03      */
             /**************************************** AAXC04 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCHKS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCHKZ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HAKOHB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&BIN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&BN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILEZ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILES) TYPE(*CHAR) LEN(9)
             DCL        VAR(&RKUBN) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

          /* PULL OUT LAST TIME BIN   */
             RTVDTAARA  DTAARA(HAKOHB) RTNVAR(&HAKOHB)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE)

          /* REISSUE */
             IF         COND(&RKUBN *EQ 'N') THEN(GOTO CMDLBL(TOBI))

          /* THIS TIME BIN CREATE */
             IF         COND(%SUBSTRING(&HAKOHB 1 6) *NE &DATE) +
                          THEN(DO)
             CHGVAR     VAR(&HAKOHB) VALUE(&DATE *CAT '00')
             ENDDO

             CHGVAR     VAR(&BIN) VALUE(%SUBSTRING(&HAKOHB 7 2))
             CHGVAR     VAR(&BIN) VALUE(&BIN + 1)
             CHGVAR     VAR(&BN) VALUE(&BIN)
             CHGVAR     VAR(&HAKOHB) VALUE(%SUBSTRING(&HAKOHB 1 6) +
                          *CAT &BN)

          /* THIS TIME BIN DATA CREATE */
 TOBI:       DLTF       FILE(RCLWPZZZ)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/RCLWPZZZ) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(100 100 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(RCLWPSS)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/RCLWPSS) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(100 100 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(RCLWPZZ) TOFILE(RCLWPZZZ)
             CALL       PGM(AAXR04) PARM(&PCHKS &PCHKZ &HAKOHB)
             DLTOVR     FILE(RCLWPZZ)
             CHGDTAARA  DTAARA(HAKOHB) VALUE(&HAKOHB)
             IF         COND(&RKUBN *EQ 'N') THEN(GOTO CMDLBL(END))

          /* BACKUP */
             CHGVAR     VAR(&FILEZ) VALUE('RCLWPZZ' *CAT &BN)
             CHGVAR     VAR(&FILES) VALUE('RCLWPSS' *CAT &BN)

             DLTF       FILE(&FILEZ)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HWFILE1/RCLWPZZZ) +
                          TOFILE(HWFILE1/&FILEZ) CRTFILE(*YES)

     /* DLTF FILE(&FILES)                                         */
     /* MONMSG MSGID(CPF3261 CPF2105)                             */
     /* CPYF FROMFILE(APWRKLIB/RCLWPSS) +                         */
     /*                  TOFILE(APWRKLIB/&FILES) CRTFILE(*YES) */

 END:        ENDPGM
