             PGM

  /** ALDCZ1 *****************************************/
  /* TM SCAN SIGN-ON/OFF LOCK/UNLOCK INQ FOR SHIPPING*/
  /*    LEC       2018.03.08                         */
  /***************************************************/

             DCL        VAR(&PGRP) TYPE(*DEC) LEN(2 0) VALUE(1)

             CALL       PGM(ALDCZ9) PARM(&PGRP)

             ENDPGM
