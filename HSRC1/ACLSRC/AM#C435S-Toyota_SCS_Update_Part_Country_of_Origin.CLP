             PGM        PARM(&WORKER &MHIN)

  /** AM#C435S  ************************************/
  /* TOYOTA SCS - UPDATE PART COUNTRY OF ORIGIN    */
  /*    LEC       2022.05.23                       */
  /*************************************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SUPPCD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RESP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MHIN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)

  /*******************************************************************/
             ADDLIBLE   LIB(YAJL) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GETURI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

  /*******************************************************************/
  /* Consume response from request to get actual token               */

             CHGVAR     VAR(&APPID) VALUE('TOKEN')
             CHGVAR     VAR(&RESP)  VALUE('RESPONSE.JSON')

             CALL       PGM(AM#R406) PARM(&APPID &RESP &TOKEN)

  /*******************************************************************/
  /* create service parts request for part country of origin...      */

             CHGVAR     VAR(&APPID) VALUE('COO')
             CHGVAR     VAR(&SUPPCD) VALUE('0242C')
             CHGVAR     VAR(&FILE) VALUE('PART_' *TCAT &MHIN +
                          *TCAT  '.JSON')

             CALL       PGM(AM#R435S) PARM(&APPID &WORKER &SUPPCD +
                          &MHIN &FILE)
  /*******************************************************************/
  /* post service parts json file to toyota website api...                  */
             CALL       PGM(AM#R407) PARM(&APPID &FILE &TOKEN)

  /*******************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             ENDPGM
