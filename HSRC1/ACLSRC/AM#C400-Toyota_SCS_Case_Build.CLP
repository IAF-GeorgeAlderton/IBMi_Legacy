             PGM        PARM(&WORKER &CASE &NONY &TOKEN)

  /** AM#C400   **********************************/
  /* TOYOTA SCS CASE BUILD FOR SERVICE PARTS     */
  /*    LEC       2021.12.22                     */
  /***********************************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CASE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20) VALUE('CASES')
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)

             ADDLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

  /*******************************************************************/
  /* check all parts scanned to case# for existence in SCS COO master*/
  /*   if not in AM#PP435, send part# to SCS to be inserted.         */
             CALL       PGM(AM#R4005) PARM(&CASE)

  /*******************************************************************/
  /* build service parts json file for SCS...                               */
             CALL       PGM(AM#R400) PARM(&APPID &CASE &NONY)

             ADDLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&FILE) VALUE('CASE_' *TCAT &CASE +
                          *TCAT  '.JSON')

  /*******************************************************************/
  /* post service parts json file to toyota website api...                  */
             CALL       PGM(AM#R407) PARM(&APPID &FILE &TOKEN)

  /*******************************************************************/
  /*   process results received from case build POST...              */
  /*     and log the transaction...                                  */

             CALL       PGM(AM#R408) PARM(&APPID &CASE &WORKER)

  /*******************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             ENDPGM
