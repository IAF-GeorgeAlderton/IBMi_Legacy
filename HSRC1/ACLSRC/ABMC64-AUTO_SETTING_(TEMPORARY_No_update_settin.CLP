             PGM
             /** ABMC64 **************************************/
             /* AUTO SETTING (TEMPORARY, NO UPDATE SETTING # */
             /*   SAKAKI               2020.03.24            */
             /*------------------------------------          */
             /*   JW1   2025.07.01 CHG ABMR19 TO ABMR19A     */
             /************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&P@NTYM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P@ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG@) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM  ) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&PPUSER)

             CHGVAR     VAR(&PGM ) VALUE('ABMC64  ')
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

 STP00:
             CRTDTAARA  DTAARA(&WLIB/AAVACT) TYPE(*CHAR) LEN(10) +
                          TEXT('PART INFORMATION M/F UPDATE +
                          HANDLING') AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(DO)
 STP2:
             SNDPGMMSG  MSG('( G ) KANBAN M/F LIST HANDLING OR +
                          PROD ORDER BOOK MAKING  HANDLING OR +
                          INTRA-PROCESS LOCATION CODE M/F IS +
                          ACTIVE, WAIT FOR A WHILE') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP2))
             GOTO       CMDLBL(END)
             ENDDO
 STP10:
      /*--------------------- */
      /* DISPLAY SCREEN       */
      /*--------------------- */
             OVRDBF     FILE(ABMPW10) TOFILE(ABMPW19)
             CALL       PGM(ABMR10) PARM(&P@NTYM &PCMD &PRTG@)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#END))

      /*--------------------- */
      /* TAKE BACKUP          */
      /*--------------------- */
             CALL       PGM(ABMC62)

      /*--------------------- */
      /* UPDATE FORECAST FILE */
      /*--------------------- */
      /* UPDATE ABBPP01 */
             CALL       PGM(ABMC50) PARM(&P@ERR &PRTG@)
             IF         COND(&P@ERR *EQ '9') THEN(GOTO CMDLBL(#END))

      /*----------------------------------------*/
      /* WRITE ABMPP00   PROCESS LOG            */
      /*----------------------------------------*/
      /*JW1* CALL       PGM(ABMR19)  PARM(&P@NTYM) ***/
             CALL       PGM(ABMR19A) PARM(&P@NTYM &PGM)

 #END:
             DLTDTAARA  DTAARA(&WLIB/AAVACT)

 END:        ENDPGM
