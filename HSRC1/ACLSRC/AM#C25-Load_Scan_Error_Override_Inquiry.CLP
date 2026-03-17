             PGM

  /** AM#C25 *************************************/
  /* LOAD SCAN ERROR/OVERRIDE INQUIRY            */
  /*    LEC       2018.10.05                     */
  /***********************************************/


             DLTF       FILE(QTEMP/AM#WP25)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AM#WP25) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AM#WP25) TOFILE(QTEMP/AM#WP25)
             CALL       PGM(AM#R25)

             ENDPGM
