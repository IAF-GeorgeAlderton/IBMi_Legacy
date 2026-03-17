             PGM        PARM(&FILNAM &FILDSC)

             DCL        VAR(&FILNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILDSC) TYPE(*CHAR) LEN(50)

  /******************************************************************/
  /*  get file description from dds source member for file          */

             CHGVAR     VAR(&SRCFILE) VALUE('ADDSSRC')

             RTVMBRD    FILE(HSRC1/&SRCFILE) MBR(&FILNAM) TEXT(&FILDSC)
             MONMSG     MSGID(CPF0000)

  /******************************************************************/

             ENDPGM
