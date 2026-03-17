             PGM        PARM(&PGRP)

  /** ALDCZ9 *************************************/
  /* TM SCAN SIGN-ON/OFF LOCK/UNLOCK LOG INQUIRY */
  /*    LEC       2018.03.08                     */
  /***********************************************/

             DCL        VAR(&PGRP) TYPE(*DEC) LEN(2 0)

             DLTF       FILE(QTEMP/ALDWPZY)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/ALDWPZD)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(ALDWPZY) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ALDWPZD) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALDWPZY) TOFILE(QTEMP/ALDWPZY)
             OVRDBF     FILE(ALDWPZD) TOFILE(QTEMP/ALDWPZD)
             CALL       PGM(ALDRZ9) PARM(&PGRP)

             ENDPGM
