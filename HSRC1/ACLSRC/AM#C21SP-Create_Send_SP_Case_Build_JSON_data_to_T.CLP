             PGM        PARM(&WORKER &USER &TT)

             /** AM#C21SP ****************************************************/
             /* LOADING - GET TOKEN,                                         */
             /*   CALL PGM TO CREATE/SEND JSON FOR CASE BUILD.               */
             /*   LEC.             2022.03.10                                */
             /****************************************************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TT) TYPE(*CHAR) LEN(25)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50) +
                          VALUE('RESPONSE.JSON')
             DCL        VAR(&TOKEN) TYPE(*CHAR) LEN(2500)
             DCL        VAR(&APPID) TYPE(*CHAR) LEN(20)

  /********************************************************************/

             ADDLIBLE   LIB(YAJL) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

             ADDLIBLE   LIB(GETURI) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)

  /********************************************************************/
  /*   Send Request for SCS Token for data transmission...            */
  /********************************************************************/
             CHGVAR     VAR(&APPID) VALUE('TOKEN')

             CALL       PGM(AM#R405) PARM(&APPID)

  /********************************************************************/
  /* Consume JSON response from the token request...                  */
  /********************************************************************/

             CALL       PGM(AM#R406) PARM(&APPID &FILE &TOKEN)

  /********************************************************************/
  /* Call program to scan SP Case labels and Send JSON data to SCS... */
  /********************************************************************/

             CALL       PGM(AM#R21SP) PARM(&WORKER &USER &TT &TOKEN)

  /********************************************************************/

             RMVLIBLE   LIB(YAJL)
             MONMSG     MSGID(CPF0000)

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

 #END:       ENDPGM
