             PGM        PARM(&FILNAM &LIBNAM)

             DCL        VAR(&FILNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBNAM) TYPE(*CHAR) LEN(10)

  /******************************************************************/
  /*    delete file/field definition workfile                       */
             DLTF       FILE(HWFILE1/##FILFMT)
             MONMSG     MSGID(CPF0000)

  /******************************************************************/
  /*  create file/field definition workfile                         */

             DSPFFD     FILE(&LIBNAM/&FILNAM) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/##FILFMT)

             MONMSG     MSGID(CPF0000)

  /******************************************************************/
  /*    add file's field definitions to data dictionary wf          */
             CALL       PGM(UTLR02F)

  /******************************************************************/

             ENDPGM
