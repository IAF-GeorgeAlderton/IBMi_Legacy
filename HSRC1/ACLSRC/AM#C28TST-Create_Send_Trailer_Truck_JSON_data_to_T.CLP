             PGM        PARM(&WORKER)
             /** AM#C28 ************************/
             /* LOADING - CREATE/SEND JSON FOR */
             /*   TRAILER BUILD.               */
             /*   LEC.             2020.11.24  */
             /*   LEC. OAuth2      2024.04.03  */
             /**********************************/

             DCLF       FILE(AM#PW21M)

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SURT) TYPE(*CHAR) LEN(9)
             DCL        VAR(&SHID) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SHIT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TRLR) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DRFN) TYPE(*CHAR) LEN(9)
             DCL        VAR(&DRLN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20) +
                          VALUE('TRAILER')
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUPPCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EXISTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRETTY) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&SCAC) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&STS14060) TYPE(*CHAR) LEN(2)
             DCL        VAR(&STS1731B) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SENDSTS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)
             DCL        VAR(&RESP) TYPE(*CHAR) LEN(50) +
                          VALUE('RESPONSE.JSON')
             DCL        VAR(&TKID) TYPE(*CHAR) LEN(20) +
                          VALUE('QATOKEN')

  /********************************************************************/
  /*     Get Input parameters for Trailer Build...                    */
  /********************************************************************/
             CALL       PGM(AM#R21PR) PARM(&SURT &SHID &SHIT &TRLR +
                          &DRFN &DRLN &PCMD &SCAC)

             IF         COND(&PCMD *NE '03') THEN(DO)

             CHGVAR     VAR(&SENDSTS) VALUE('OK')

  /********************************************************************/

             ADDLIBLE   LIB(YAJL) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GETURI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

  /********************************************************************/
  /*   Trailer Build for Non TMMC                                     */
  /********************************************************************/
             CHGVAR     VAR(&SUPPCD) VALUE('14060')
             CHGVAR     VAR(&FILE) VALUE(&SHID *TCAT '_' *TCAT &SURT +
                          *TCAT '_' *TCAT &SUPPCD *TCAT '.json')

      /* Delete Old Files...       */
             CALL       PGM(AM#R421D) PARM(&APPID &FILE)

      /* Create JSON Data for TSCS trailer build...*/
             CALL       PGM(AM#R421) PARM(&WORKER &SUPPCD &SURT +
                          &SHID &SHIT &TRLR &DRFN &DRLN &APPID +
                          &EXISTS &PRETTY &SCAC &FILE)


             IF         COND(&EXISTS = 'Y') THEN(DO)

      /* Request to Get Token...                                      */
             CALL       PGM(AM#R425) PARM(&TKID)

      /* Consume token request response -- extract TOKEN              */
             CALL       PGM(AM#R426) PARM(&TKID &RESP &TOKEN)

      /* Send JSON Data To TSCS....*/
             CALL       PGM(AM#R401NEW) PARM(&APPID &FILE &TOKEN)

      /* Process result messages to Outfile and Log the Transaction...*/
             CALL       PGM(AM#R422) PARM(&APPID &SURT &SHID &SHIT +
                          &SUPPCD &STS14060 &SCAC &DRFN &DRLN &TRLR)

             IF         COND(&STS14060 = 'NG') THEN(DO)
                        CHGVAR VAR(&SENDSTS) VALUE('NG')
                                                 ENDDO

                                              ENDDO

  /********************************************************************/
  /*   Trailer Build for TMMC                                         */
  /********************************************************************/

             CHGVAR     VAR(&SUPPCD) VALUE('1731B')
             CHGVAR     VAR(&FILE) VALUE(&SHID *TCAT '_' *TCAT &SURT +
                          *TCAT '_' *TCAT &SUPPCD *TCAT '.JSON')

      /* Delete Old Files...       */
             CALL       PGM(AM#R421D) PARM(&APPID &FILE)

      /* Create JSON Data for TSCS trailer build...*/
             CALL       PGM(AM#R421) PARM(&WORKER &SUPPCD &SURT +
                          &SHID &SHIT &TRLR &DRFN &DRLN &APPID +
                          &EXISTS &PRETTY &SCAC &FILE)

             IF         COND(&EXISTS = 'Y') THEN(DO)

      /* Send JSON Data To TSCS....*/
             CALL       PGM(AM#R401NEW) PARM(&APPID &FILE &TOKEN)

      /* Process result messages to Outfile and Log the Transaction...*/
             CALL       PGM(AM#R422) PARM(&APPID &SURT &SHID &SHIT +
                          &SUPPCD &STS1731B &SCAC &DRFN &DRLN &TRLR)

             IF         COND(&STS1731B = 'NG') THEN(DO)
                        CHGVAR VAR(&SENDSTS) VALUE('NG')
                                                 ENDDO

                                               ENDDO

  /********************************************************************/
  /*   Trailer Build for Service Parts -  vendor code 0242C           */
  /********************************************************************/

  /*******   CALL       PGM(AM#C28SP) PARM(&WORKER &SURT &SHID &SHIT /*******/
  /*******              &TRLR &DRFN &DRLN &SCAC)                     /*******/

  /********************************************************************/
  /* Display Confirmation Statuses for Trailer Send                   */

             IF         COND(&SENDSTS = 'OK') THEN(SNDRCVF +
                          RCDFMT(DSP01))

             IF         COND(&SENDSTS = 'NG') THEN(SNDRCVF +
                          RCDFMT(DSP02))

  /********************************************************************/

                        ENDDO

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)


             ENDPGM
