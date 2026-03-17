             PGM        PARM(&WORKER &SURT &SHID &SHIT &TRLR +
                        &DRFN &DRLN &SCAC)

             /** AM#C28SP **********************/
             /* LOADING - CREATE/SEND JSON FOR */
             /*   TRAILER BUILD FOR SERVICE    */
             /*   PARTS.                       */
             /*   LEC.             2024.04.02  */
             /**********************************/

             DCLF       FILE(AM#PW21M)

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SURT) TYPE(*CHAR) LEN(9)
             DCL        VAR(&SHID) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SHIT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TRLR) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DRFN) TYPE(*CHAR) LEN(9)
             DCL        VAR(&DRLN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUPPCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EXISTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRETTY) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&SCAC) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)
             DCL        VAR(&RESP) TYPE(*CHAR) LEN(50)

  /********************************************************************/
  /*  If Truck Ticket Info was not passed in, display screen for input*/
             IF         COND(&WORKER *EQ '  ') THEN(DO)
             CALL       PGM(AM#R21PR) PARM(&SURT &SHID &SHIT &TRLR +
                          &DRFN &DRLN &PCMD &SCAC)
                                             ENDDO
  /********************************************************************/

             IF         COND(&PCMD *NE '03') THEN(DO)


             ADDLIBLE   LIB(YAJL) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GETURI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

  /********************************************************************/
  /*   Trailer Build for Service Parts -  vendor code 0242C           */
  /********************************************************************/

             CHGVAR     VAR(&APPID) VALUE('SPTRAILER')
             CHGVAR     VAR(&SUPPCD) VALUE('0242C')
             CHGVAR     VAR(&FILE) VALUE(&SHID *TCAT '_' *TCAT &SURT +
                          *TCAT '_' *TCAT &SUPPCD *TCAT '.JSON')

      /* Delete Old Files...       */
             CALL       PGM(AM#R421D) PARM(&APPID &FILE)

      /* Create JSON Data for SP trailer build...                    */
             CHGVAR     VAR(&EXISTS) VALUE('N')

             CALL       PGM(AM#R403) PARM(&WORKER &SUPPCD &SURT +
                          &SHID &SHIT &TRLR &DRFN &DRLN &APPID +
                          &EXISTS &PRETTY &SCAC &FILE)

             IF         COND(&EXISTS = 'Y') THEN(DO)

             CHGVAR     VAR(&APPID) VALUE('TOKEN')
             CHGVAR     VAR(&RESP)  VALUE('RESPONSE.JSON')

      /* Request to Get Token...                                      */
             CALL       PGM(AM#R405) PARM(&APPID)

      /* Consume response from request to get actual token            */
             CALL       PGM(AM#R406) PARM(&APPID &RESP &TOKEN)

      /* Send Trailer Build JSON Data To TSCS....                     */
             CHGVAR     VAR(&APPID) VALUE('SPTRAILER')
             CALL       PGM(AM#R407) PARM(&APPID &FILE &TOKEN)

      /* Process result messages to Outfile and Log the Transaction...*/
             CALL       PGM(AM#R409) PARM(&APPID &SHID &SHIT &TRLR +
                          &DRFN &DRLN &SURT &SCAC &SUPPCD &WORKER)

                                               ENDDO

  /********************************************************************/

                        ENDDO

             ENDPGM
