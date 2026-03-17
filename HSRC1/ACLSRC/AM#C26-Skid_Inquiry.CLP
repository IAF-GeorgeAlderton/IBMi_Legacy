             PGM

  /** AM#C26 *************************************/
  /* SKID INQUIRY                                */
  /*    LEC       2018.11.02                     */
  /***********************************************/


             DLTF       FILE(QTEMP/AM#WP26)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AM#WP26) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AM#WP26) TOFILE(QTEMP/AM#WP26)
             CALL       PGM(AM#R26)

             ENDPGM
