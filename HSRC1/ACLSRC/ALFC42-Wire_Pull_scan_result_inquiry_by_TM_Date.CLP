             PGM

  /** ALFC42 *************************************/
  /* WIRE PULL SCAN RESULT INQUIRY               */
  /*    LEC       2018.02.07                     */
  /***********************************************/

             DLTF       FILE(QTEMP/ALFWP42)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/ALFWP4D)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(ALFWP42) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ALFWP4D) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALFWP42) TOFILE(QTEMP/ALFWP42)
             OVRDBF     FILE(ALFWP4D) TOFILE(QTEMP/ALFWP4D)
             CALL       PGM(ALFR42)

             ENDPGM
