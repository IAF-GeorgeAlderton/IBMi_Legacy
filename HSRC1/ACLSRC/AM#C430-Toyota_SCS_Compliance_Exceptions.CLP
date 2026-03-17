             PGM

  /** AM#C430   **********************************/
  /* TOYOTA SCS COMPLIANCE EXCEPTIONS            */
  /*    LEC       2022.03.04                     */
  /***********************************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&SUPPCD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RESP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)

  /*******************************************************************/
             ADDLIBLE   LIB(YAJL) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GETURI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

  /*******************************************************************/
             CHGVAR     VAR(&APPID) VALUE('TOKEN')
             CHGVAR     VAR(&RESP)  VALUE('RESPONSE.JSON')

      /* Request to Get Token...                                      */
             CALL       PGM(AM#R405) PARM(&APPID)

      /* Consume response from request to get actual token            */
             CALL       PGM(AM#R406) PARM(&APPID &RESP &TOKEN)

  /*******************************************************************/
  /* post service parts request for compliance exceptions...                */

             CHGVAR     VAR(&APPID) VALUE('COMPEXCP')
             CHGVAR     VAR(&SUPPCD) VALUE('0242C')

             CALL       PGM(AM#R430) PARM(&WORKER &SUPPCD &APPID +
                          &TOKEN)

  /*******************************************************************/
  /* consume compliance exceptions json response...                  */

             CLRPFM     FILE(AM#PP430)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(AM#R431) PARM(&APPID &SUPPCD)

  /*******************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             ENDPGM
