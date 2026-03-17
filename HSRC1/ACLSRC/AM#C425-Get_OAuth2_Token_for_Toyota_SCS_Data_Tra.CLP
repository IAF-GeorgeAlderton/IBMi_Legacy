             PGM

  /** AM#C425   **********************************/
  /* GET OAUTH2 TOKEN FOR TOYOTA SCS DATA TRANS  */
  /*    LEC       2025.08.08                     */
  /***********************************************/

             DCL        VAR(&TKID) TYPE(*CHAR) LEN(20) VALUE('MPTOKEN')

             ADDLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

  /*******************************************************************/
  /* call program to request OAuth2 token                            */
             CALL       PGM(AM#R425) PARM(&TKID)

  /*******************************************************************/

             RMVLIBLE   LIB(GETURI)
             MONMSG     MSGID(CPF0000)

             ENDPGM
