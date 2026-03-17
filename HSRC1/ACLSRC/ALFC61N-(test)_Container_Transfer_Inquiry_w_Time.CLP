             PGM

  /** ALFC61 *******************************************************/
  /* CONTAINER TRANSFER SCAN RESULT INQUIRY WITH TIME SELECTION    */
  /* JW   2021.04.26 (COPIED FROM ALFC61)                          */
  /*                 ADD TIME SELECTION                            */
  /*****************************************************************/

             DLTF       FILE(QTEMP/ALFWP61)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(ALFWP61) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALFWP61) TOFILE(QTEMP/ALFWP61)
             CALL       PGM(ALFR61N)

             ENDPGM
