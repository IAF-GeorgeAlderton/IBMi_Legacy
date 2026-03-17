             PGM        PARM(&PS)
             /** AJEC10 ********************************/
             /*   PASS THROUGH MENU ABNORMAL SCREEN    */
             /* I-HASADA                 91.05.23      */
             /******************************** AJEC10 **/
             DCLF       FILE(AJEPW06)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AJEDS1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ISNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SNM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&VWS) TYPE(*CHAR) LEN(2)
             RTVNETA    SYSNAME(&PSYS)
             RTVDTAARA  DTAARA(AJEDS1) RTNVAR(&AJEDS1)
             RTVJOBA    JOB(&WSNO) USER(&US)
             CHGVAR     VAR(&ISNO) VALUE(&WSNO)

             IF         (&WSNO *EQ 'DSP01     ') DO
             CHGVAR     VAR(&WSNO) VALUE('WJ        ')
             ENDDO

             CHGVAR     VAR(&WSID) VALUE(%SUBSTRING(&WSNO 1 2))

             /*--------------------------*/
             /* HEAD OFFICE NO.2 MACHINE */
             /*--------------------------*/
             IF         (&PSYS *EQ 'APICS   ') DO
             IF         (&AJEDS1 *EQ 'N') DO

             IF         ((%SST(&WSNO 1 1) *EQ 'V') *OR (%SST(&WSNO 1 +
                          1) *EQ 'X')) DO

             SNDRCVF    DEV(&ISNO) RCDFMT(AJEPW061)

             IF         (&IN01 *EQ '1') DO
             RMVMSG     MSGQ(&ISNO) CLEAR(*ALL)
             SIGNOFF
             ENDDO

             RMVMSG     MSGQ(&ISNO) CLEAR(*ALL)
             ENDPASTHR

             ENDDO
             ENDDO
             ENDDO

             /*--------------------*/
             /*   KANI FACTORY     */
             /*--------------------*/
             IF         (&PSYS *EQ 'KANI    ') DO

             IF         ((%SST(&WSNO 1 1) *EQ 'V') *OR (%SST(&WSNO 1 +
                          1) *EQ 'X')) DO

             SNDRCVF    DEV(&ISNO) RCDFMT(AJEPW061)

             IF         (&IN01 *EQ '1') DO
             RMVMSG     MSGQ(&ISNO) CLEAR(*ALL)
             SIGNOFF
             ENDDO

             RMVMSG     MSGQ(&ISNO) CLEAR(*ALL)
             ENDPASTHR

             ENDDO

             /*--------------------------------*/
             /* THE PASS THROUGH SPOT TERMINAL */
             /*--------------------------------*/
             IF         (%SST(&WSNO 1 2) *EQ 'WN') DO

             CHGVAR     VAR(&VWS) VALUE(&WSID)
             CHGVAR     VAR(%SST(&VWS 1 1)) VALUE('T')
             CHGVAR     VAR(&SNM) VALUE('AOYAMA')
             CHGVAR     VAR(&US) VALUE('B3999     ')
             CHGVAR     VAR(&PS) VALUE('KONY      ')

             STRPASTHR  RMTLOCNAME(&SNM) VRTDEV(&VWS) RMTUSER(&US) +
                          RMTPWD(&PS) RMTINLPGM(B#EC11)

             MONMSG     MSGID(CPF8921 CPF8916) EXEC(DO)
             SNDRCVF    DEV(&ISNO) RCDFMT(AJEPW062)
             ENDDO

             MONMSG     MSGID(CPF8936 CPF0001) EXEC(DO)
             SNDRCVF    DEV(&ISNO) RCDFMT(AJEPW063)
             ENDDO

             MONMSG     MSGID(CPF8905 CPF8933) EXEC(DO)
             SNDRCVF    DEV(&ISNO) RCDFMT(AJEPW064)
             ENDDO

             RMVMSG     MSGQ(&ISNO) CLEAR(*ALL)
             SIGNOFF

             ENDDO
             ENDDO

             /*--------------------*/
             /* KUMAMOTO FACTORY   */
             /*--------------------*/
             IF         (&PSYS *EQ 'KUMAMOTO') DO

             IF         ((%SST(&WSNO 1 1) *EQ 'V') *OR (%SST(&WSNO 1 +
                          1) *EQ 'X')) DO

             SNDRCVF    DEV(&ISNO) RCDFMT(AJEPW061)

             IF         (&IN01 *EQ '1') DO
             RMVMSG     MSGQ(&ISNO) CLEAR(*ALL)
             SIGNOFF
             ENDDO

             RMVMSG     MSGQ(&ISNO) CLEAR(*ALL)
             ENDPASTHR

             ENDDO
             ENDDO

             /*--------------------------------------*/
             /*   PASS THROUGH MENU SCREEN           */
             /*--------------------------------------*/
             IF         (&PSYS *EQ 'APICS   ') DO

             CHGVAR     VAR(&VWS) VALUE(&WSID)

             IF         (&PSYS *EQ 'APICS   ') DO
             CHGVAR     VAR(%SST(&VWS 1 1)) VALUE('V')
             ENDDO

             CHGVAR     VAR(&SNM) VALUE('AOYAMA')

             STRPASTHR  RMTLOCNAME(&SNM) VRTDEV(&VWS) RMTUSER(&US) +
                          RMTPWD(&PS)

             MONMSG     MSGID(CPF8921 CPF8916) EXEC(DO)
             SNDRCVF    DEV(&ISNO) RCDFMT(AJEPW062)
             ENDDO

             MONMSG     MSGID(CPF8936 CPF0001) EXEC(DO)
             SNDRCVF    DEV(&ISNO) RCDFMT(AJEPW063)
             ENDDO

             MONMSG     MSGID(CPF8905 CPF8933) EXEC(DO)
             SNDRCVF    DEV(&ISNO) RCDFMT(AJEPW064)
             ENDDO

             RMVMSG     MSGQ(&ISNO) CLEAR(*ALL)
             SIGNOFF

             ENDDO
             ENDPGM
