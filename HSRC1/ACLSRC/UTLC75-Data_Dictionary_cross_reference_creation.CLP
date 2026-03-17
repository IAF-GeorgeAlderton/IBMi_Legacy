             PGM        PARM(&LIBR)

             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)

  /******************************************************************/
  /*    delete list of files...                                     */
             DLTF       FILE(HWFILE1/##FILLST)
             MONMSG     MSGID(CPF0000)

  /******************************************************************/
  /*  create list of files in library...                            */

             DSPOBJD    OBJ(&LIBR/*ALL) OBJTYPE(*FILE) +
                          OUTPUT(*OUTFILE) OUTFILE(HWFILE1/##FILLST)
             MONMSG     MSGID(CPF0000)

  /******************************************************************/
  /*    process the list of files and create file format   */
             CALL       PGM(UTLR00F)

             ENDPGM
