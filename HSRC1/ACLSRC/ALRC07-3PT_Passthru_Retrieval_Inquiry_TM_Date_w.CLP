             PGM

  /** ALRC07 *************************************/
  /* 3PT Passthru Retrieval Scan Inquiry         */
  /*    LEC       2016.07.20                     */
  /***********************************************/

             DLTF       FILE(QTEMP/ALRWP05)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/ALRWP5D)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(ALRWP05) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ALRWP5D) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALRWP05) TOFILE(QTEMP/ALRWP05)
             OVRDBF     FILE(ALRWP5D) TOFILE(QTEMP/ALRWP5D)
             CALL       PGM(ALRR07)

             ENDPGM
