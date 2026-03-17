             PGM

  /** AM#C48  ************************************/
  /* PALLET RETURN SCAN RESULT INQUIRY           */
  /*    LEC       2019.11.20                     */
  /***********************************************/

             DLTF       FILE(QTEMP/AM#WP45P)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/AM#WP45P)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AM#WP45P) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AM#WP45D) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AM#WP45P) TOFILE(QTEMP/AM#WP45P)
             OVRDBF     FILE(AM#WP45D) TOFILE(QTEMP/AM#WP45D)
             CALL       PGM(AM#R45P)

             ENDPGM
