             PGM

  /** AM#C434   **********************************/
  /* TOYOTA SCS - CREATE COMPLIANCE RDA JSON     */
  /*    LEC       2022.03.30                     */
  /***********************************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&SUPPCD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RESP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PRETTY) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SENDF) TYPE(*CHAR) LEN(1)

  /*******************************************************************/
             ADDLIBLE   LIB(YAJL) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GETURI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

  /*******************************************************************/
             CHGVAR     VAR(&APPID) VALUE('TOKEN')
             CHGVAR     VAR(&RESP)  VALUE('RESPONSE.JSON')

  /* Request to Get Token...                                         */
             CALL       PGM(AM#R405) PARM(&APPID)

  /* Consume response from request to get actual token               */
             CALL       PGM(AM#R406) PARM(&APPID &RESP &TOKEN)

  /*******************************************************************/
  /* post service parts RDA compliance detail ...                    */

             CHGVAR     VAR(&APPID) VALUE('COMPDETL')
             CHGVAR     VAR(&SUPPCD) VALUE('0242C')

             CALL       PGM(AM#R434) PARM(&WORKER &SUPPCD &APPID +
                        &PRETTY &FILE &SENDF)

  /*******************************************************************/
  /* call program to POST RDA compliance details...                  */

             IF         COND(&SENDF = 'Y') THEN(DO)
                CALL       PGM(AM#R407) PARM(&APPID &FILE &TOKEN)
             ENDDO

  /*******************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             ENDPGM
