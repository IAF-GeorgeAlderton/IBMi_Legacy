             PGM

  /** ALFC61 *************************************/
  /* CONTAINER TRANSFER SCAN RESULT INQUIRY      */
  /*    LEC       2019.12.12                     */
  /*    JW1       2021.04.26 CHG ALFR61          */
  /***********************************************/

             DLTF       FILE(QTEMP/ALFWP61)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(ALFWP61) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALFWP61) TOFILE(QTEMP/ALFWP61)
  /**JW1 *** CALL       PGM(ALFR61) **********/
             CALL       PGM(ALFR61N)

             ENDPGM
