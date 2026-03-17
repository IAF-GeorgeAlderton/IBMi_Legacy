             PGM

  /** AM#C435   ************************************/
  /* TOYOTA SCS - VIEW ALL PARTS COUNTRY OF ORIGIN */
  /*    LEC       2022.05.17                       */
  /*************************************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&SUPPCD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RESP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)

  /*******************************************************************/
             ALCOBJ     OBJ((AM#PP435 *FILE *EXCL))
             MONMSG     MSGID(CPF0000)

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
  /* post service parts request for view all pos...                         */

             CHGVAR     VAR(&APPID) VALUE('VIEWCOC')
             CHGVAR     VAR(&SUPPCD) VALUE('0242C')

             CALL       PGM(AM#R435) PARM(&WORKER &SUPPCD &APPID +
                          &TOKEN)

  /*******************************************************************/
             CLRPFM     FILE(AM#PP435)
             MONMSG     MSGID(CPF0000)

  /*******************************************************************/
  /* consume view all Parts COO json response...                     */

             CALL       PGM(AM#R435C) PARM(&APPID &SUPPCD)

  /*******************************************************************/
             DLCOBJ     OBJ((AM#PP435 *FILE *EXCL))
             MONMSG     MSGID(CPF0000)

  /*******************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             ENDPGM
