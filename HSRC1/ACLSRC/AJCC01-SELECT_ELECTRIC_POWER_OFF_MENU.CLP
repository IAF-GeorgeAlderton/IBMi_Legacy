             PGM
             /** AJCC01 *****************************/
             /* ..SELECT ELECTRIC POWER OFF MENU..  */
             /*    I-HASADA            97.01.22     */
             /***************************** AJCC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGMSGQ    MSGQ(&WSID) DLVRY(*BREAK)

             IF         (&USER *NE 'QSECOFR   ') DO
 STPA:       SNDPGMMSG  MSG('( G ) +
                          SIGNON WITH PASSWORD(QSECOFR)+
                          ') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(SIGNOFF)
             GOTO       STPA
             ENDDO

             CALL       PGM(AJCR01)

             ENDPGM
