             PGM
  /** AM#C44E   **********************************/
  /* PRINT NEW EXPDEDITE TRUCK TICKETS           */
  /*    LEC       2021.02.04                     */
  /***********************************************/

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

  /* print expedite truck tickets...                                        */
             CALL       PGM(AM#R44E)

             ENDPGM
