             PGM

  /** ALFC62 *************************************/
  /* CONTAINER TRANSFER SCAN RESULT INQUIRY      */
  /*    LEC       2019.12.06                     */
  /***********************************************/

             DLTF       FILE(QTEMP/ALFWP62)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/ALFWP6D)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(ALFWP62) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ALFWP6D) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALFWP62) TOFILE(QTEMP/ALFWP62)
             OVRDBF     FILE(ALFWP6D) TOFILE(QTEMP/ALFWP6D)
             CALL       PGM(ALFR62)

             ENDPGM
