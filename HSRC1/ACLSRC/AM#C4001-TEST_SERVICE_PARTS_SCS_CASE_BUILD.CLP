             PGM        PARM(&CASE)

  /** AM#C4001  **********************************/
  /* TEST --- SERVICE PARTS SCS CASE BUILD       */
  /*    LEC       2022.01.21                     */
  /***********************************************/

             DCL        VAR(&CASE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50) +
                          VALUE('RESPONSE.JSON')
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)
             DCL        VAR(&PATH) TYPE(*CHAR) LEN(500) +
                          VALUE('/toyota/scs/serviceparts/json/post/')
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NEWPATH) TYPE(*CHAR) LEN(500)

  /*******************************************************************/
  /*   consume SP response -- extract TOKEN                          */

             ADDLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&APPID) VALUE('TOKEN')

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
  /*   pull json from IFS into workfile to be transferred to text    */

             CHGVAR     VAR(&NEWPATH) VALUE(&PATH *TCAT &APPID *TCAT +
                          '/' *TCAT &FILE)

             CPYFRMSTMF FROMSTMF(&NEWPATH) +
                          TOMBR('/QSYS.LIB/HWFILE1.LIB/TESTJSON.FILE/+
                          TESTJSON.MBR') MBROPT(*REPLACE) +
                          CVTDTA(*AUTO) ENDLINFMT(*ALL) TABEXPN(*YES)

  /*******************************************************************/
  /*   pull case POST results header...                              */

             CHGVAR     VAR(&NEWPATH) VALUE(&PATH *TCAT &APPID *TCAT +
                          '/' *TCAT 'RESULTS/' *TCAT &FILE)

             CPYFRMSTMF FROMSTMF(&NEWPATH) +
                          TOMBR('/QSYS.LIB/HWFILE1.LIB/CASE_RHDR.FILE/+
                          CASE_RHDR.MBR') MBROPT(*REPLACE) +
                          CVTDTA(*AUTO) ENDLINFMT(*ALL) TABEXPN(*YES)

  /*******************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             ENDPGM
