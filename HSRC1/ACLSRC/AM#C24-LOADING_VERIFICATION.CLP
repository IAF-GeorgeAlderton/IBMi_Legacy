             PGM

  /** AM#C24 *************************************/
  /* LOADING VERIFICATION                        */
  /*    LEC       2018.10.02                     */
  /***********************************************/


             DLTF       FILE(QTEMP/AM#WP24)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AM#WP24) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AM#WP24) TOFILE(QTEMP/AM#WP24)
             CALL       PGM(AM#R24)

             ENDPGM
