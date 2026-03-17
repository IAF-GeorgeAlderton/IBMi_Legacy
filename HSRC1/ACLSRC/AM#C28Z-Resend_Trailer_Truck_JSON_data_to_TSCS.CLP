             PGM        PARM(&WORKER &TT)
             /** AM#C28Z ******************************/
             /* LOADING - CREATE AND RESEND JSON FOR  */
             /*   TRAILER BUILD.                      */
             /*   LEC.             2023.12.18         */
             /*****************************************/

             DCLF       FILE(AM#PW21M)

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TT) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SURT) TYPE(*CHAR) LEN(9)
             DCL        VAR(&SHID) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SHIT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SHTM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TRLR#) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DRNMF) TYPE(*CHAR) LEN(9)
             DCL        VAR(&DRNML) TYPE(*CHAR) LEN(12)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20) +
                          VALUE('TRAILER')
             DCL        VAR(&SUPPCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EXISTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRETTY) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&SCAC) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&STS14060) TYPE(*CHAR) LEN(2)
             DCL        VAR(&STS1731B) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SENDSTS) TYPE(*CHAR) LEN(2) VALUE('OK')
             DCL        VAR(&SEND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&XTT) TYPE(*CHAR) LEN(19)

  /********************************************************************/
  /*     Retrieve Route, Ship Date, Ship Time from Truck Ticket       */
  /********************************************************************/
             CHGVAR     VAR(&SURT) VALUE(%SUBSTRING(&TT 1 7))
             CHGVAR     VAR(&SHID) VALUE(%SUBSTRING(&TT 8 8))
             CHGVAR     VAR(&SHIT) VALUE(%SUBSTRING(&TT 16 4))
             CHGVAR     VAR(&SHTM) VALUE(%SUBSTRING(&TT 16 6))

  /********************************************************************/

             ADDLIBLE   LIB(YAJL) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GETURI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

  /********************************************************************/
  /*   Trailer Build for Non TMMC                                     */
  /********************************************************************/
             CHGVAR     VAR(&SUPPCD) VALUE('14060')

      /* Get Truck information from SCS Transmission Log file  */
             CALL       PGM(AM#R28Z) PARM(&SUPPCD &SURT &SHID &SHTM +
                          &TRLR# &DRNMF &DRNML &SCAC &SEND)

  /********************************************************************/
      /* File name...              */
             CHGVAR     VAR(&FILE) VALUE(&SHID *TCAT '_' *TCAT &SURT +
                          *TCAT '_' *TCAT &SUPPCD *TCAT '.json')

      /* Delete Old Files...       */
             CALL       PGM(AM#R421D) PARM(&APPID &FILE)

      /* Create JSON Data for TSCS trailer build...*/
             CALL       PGM(AM#R421) PARM(&WORKER &SUPPCD &SURT +
                          &SHID &SHIT &TRLR# &DRNMF &DRNML &APPID +
                          &EXISTS &PRETTY &SCAC &FILE)


             IF         COND(&EXISTS = 'Y' *AND &SEND = 'Y') THEN(DO)

      /* Send JSON Data To TSCS....*/
             CALL       PGM(AM#R401) PARM(&APPID &FILE)

      /* Process result messages to Outfile and Log the Transaction...*/
             CALL       PGM(AM#R422) PARM(&APPID &SURT &SHID &SHIT +
                          &SUPPCD &STS14060 &SCAC &DRNMF &DRNML &TRLR#)

             IF         COND(&STS14060 = 'NG') THEN(DO)
                        CHGVAR VAR(&SENDSTS) VALUE('NG')
                                                 ENDDO

                                                              ENDDO

  /********************************************************************/
  /*   Trailer Build for TMMC                                         */
  /********************************************************************/

             CHGVAR     VAR(&SUPPCD) VALUE('1731B')

      /* Get Truck information from SCS Transmission Log file  */
             CALL       PGM(AM#R28Z) PARM(&SUPPCD &SURT &SHID &SHTM +
                          &TRLR# &DRNMF &DRNML &SCAC &SEND)

  /********************************************************************/
      /* File name...              */
             CHGVAR     VAR(&FILE) VALUE(&SHID *TCAT '_' *TCAT &SURT +
                          *TCAT '_' *TCAT &SUPPCD *TCAT '.JSON')

      /* Delete Old Files...       */
             CALL       PGM(AM#R421D) PARM(&APPID &FILE)

      /* Create JSON Data for TSCS trailer build...*/
             CALL       PGM(AM#R421) PARM(&WORKER &SUPPCD &SURT +
                          &SHID &SHIT &TRLR# &DRNMF &DRNML &APPID +
                          &EXISTS &PRETTY &SCAC &FILE)

             IF         COND(&EXISTS = 'Y' *AND &SEND = 'Y') THEN(DO)

      /* Send JSON Data To TSCS....*/
             CALL       PGM(AM#R401) PARM(&APPID &FILE)

      /* Process result messages to Outfile and Log the Transaction...*/
             CALL       PGM(AM#R422) PARM(&APPID &SURT &SHID &SHIT +
                          &SUPPCD &STS1731B &SCAC &DRNMF &DRNML &TRLR#)

             IF         COND(&STS1731B = 'NG') THEN(DO)
                        CHGVAR VAR(&SENDSTS) VALUE('NG')
                                                 ENDDO

                                                               ENDDO

  /********************************************************************/
  /* If Transmission was Confirmed, then Post data to Sales           */
  /********************************************************************/

             CHGVAR     VAR(&XTT) VALUE(&TT)

             IF         COND(&SENDSTS = 'OK') THEN(CALL PGM(AM#C450) +
                          PARM((&WORKER) (&XTT)))

  /********************************************************************/
  /* Display Confirmation Statuses for Trailer Send                   */

             IF         COND(&STS14060 = '  ' *AND &STS1731B = '  ') +
                          THEN(DO)
                           SNDRCVF  RCDFMT(DSP03)
                           GOTO #END
                          ENDDO

             IF         COND(&SENDSTS = 'OK') THEN(SNDRCVF +
                          RCDFMT(DSP01))

             IF         COND(&SENDSTS = 'NG') THEN(DO)
                          SNDRCVF RCDFMT(DSP02)
                          CALL    PGM(AM#R25E) PARM((&XTT))
                                              ENDDO

  /********************************************************************/

 #END:       RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)


             ENDPGM
