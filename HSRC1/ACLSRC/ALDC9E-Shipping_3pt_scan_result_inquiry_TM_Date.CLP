             PGM

  /** ALDC9E *************************************/
  /* SHIPPING 3PT SCAN RESULT INQUIRY            */
  /*    LEC       2016.06.03                     */
  /***********************************************/

             DLTF       FILE(QTEMP/ALDWP2Y)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/ALDWP2D)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(ALDWP2Y) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ALDWP2D) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALDWP2Y) TOFILE(QTEMP/ALDWP2Y)
             OVRDBF     FILE(ALDWP2D) TOFILE(QTEMP/ALDWP2D)
             CALL       PGM(ALDR9E)

             ENDPGM
