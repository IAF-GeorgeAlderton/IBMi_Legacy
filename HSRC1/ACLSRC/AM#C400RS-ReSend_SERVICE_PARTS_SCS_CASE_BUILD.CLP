             PGM        PARM(&CASE)

  /** AM#C400RS **********************************/
  /* RESEND -- SERVICE PARTS SCS CASE BUILD      */
  /*    LEC       2022.06.21                     */
  /***********************************************/

             DCL        VAR(&CASE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20) VALUE('CASES')
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4) VALUE('0323')

  /*******************************************************************/
  /*   consume SP response -- extract TOKEN                          */

             ADDLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&APPID) VALUE('TOKEN')
             CHGVAR     VAR(&FILE) VALUE('response.json')

             CALL       PGM(AM#R406) PARM(&APPID &FILE &TOKEN)

  /*******************************************************************/
  /*   create SP case build json data...                             */

             CHGVAR     VAR(&APPID) VALUE('CASES')
             CHGVAR     VAR(&NONY) VALUE('0323')

             CALL       PGM(AM#R400) PARM(&APPID &CASE &NONY)

  /*******************************************************************/
  /*   post service parts json file to toyota website api...         */

             ADDLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)
  /*                                                                 */

             CHGVAR     VAR(&FILE) VALUE('CASE_' *TCAT &CASE +
                          *TCAT  '.JSON')

             CALL       PGM(AM#R407) PARM(&APPID &FILE &TOKEN)

  /*******************************************************************/
  /*   process results received from case build POST...              */

             CALL       PGM(AM#R408) PARM(&APPID &CASE &WORKER)

  /*******************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             ENDPGM
