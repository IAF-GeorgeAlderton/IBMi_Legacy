             PGM

  /** AM#C2E   ***********************************/
  /* WRAPPER SCAN CONFIRMATION INQUIRY           */
  /*    LEC       2020.05.21                     */
  /***********************************************/


             DLTF       FILE(QTEMP/AM#WP25W)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AM#WP25W) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AM#WP25W) TOFILE(QTEMP/AM#WP25W)
             CALL       PGM(AM#R25W)

             ENDPGM
