             PGM        PARM(&FILE)

  /** AM#C25FIX **********************************/
  /* MANIFEST BATCH SEND TO HULFT                */
  /*    LEC       2020.08.17                     */
  /***********************************************/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)

             OVRDBF     FILE(MFBCFILE) TOFILE(HWFILE1/&FILE)

             CALL       PGM(AM#R25FIX)

             DLTOVR     FILE(*ALL)

             ENDPGM
