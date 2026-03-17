             PGM        PARM(&JOB)
             /** EJKC55 ********************************/
             /*  HULFT  OBSERVATION FOR ABNORMAL END   */
             /*    **ORIGINAL IS JK911C FROM ASJ**     */
             /*  T.SAKAKI            2016.10.12        */
             /******************************************/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HANT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(11)
             DCL        VAR(&PTTL)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

     /*--------------------------*/
     /*    CHECK ABNORMAL END    */
     /*--------------------------*/
             CALL       PGM(EJKR55) PARM(&JOB &HANT)

             IF         COND(&HANT *EQ ' ') THEN(GOTO CMDLBL(@END))

             CHGVAR     VAR(&MSG) VALUE('QSYSOPR    ')

        /* NOTIFICATION BY E-MAIL */
             CHGVAR     VAR(&PTTL) VALUE(&JOB *CAT ' GOT AN ERROR')
             CHGVAR     VAR(&PMSG) VALUE('PREVIOUS ' *CAT &JOB *TCAT +
                          '* JOB WAS ABNORMAL END, PLEASE SEE #56-4 +
                          in QPGMR.AND THEN ENTER "G" TO RETRY IN +
                          QSYSOPR')
        /* NOTIFICATION BY E-MAIL */
             CALL       PGM(MSGC10) PARM(&PTTL &PMSG)

 STP1:       SNDPGMMSG  MSG(&PMSG) TOMSGQ(&MSG) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP1))

 /* IF ERROR HAPPENS, PLEASE CHECK TRANSFER STATUS LIST */
 /* IN HULFT MAIN MENU (CALL EHLC00) */

 @END:
             ENDPGM
