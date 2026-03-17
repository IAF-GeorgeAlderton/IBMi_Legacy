             PGM
             /** ALDC9XL ******************************/
             /* STORE IN LOCATION FOR HD AND RL       */
             /*    LEC       2024.07.18               */
             /*****************************************/

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WKNM) TYPE(*CHAR) LEN(20)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SECT) TYPE(*CHAR) LEN(1) VALUE('2')
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

  /*---------------------------------------------------------------*/
  /*   have TM enter worker code...                                */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

  /*  if worker code was valid, continue...  if not, end pgm       */
             IF         COND(&VALID *NE 'Y') THEN(GOTO CMDLBL(#END))
             CHGVAR     VAR(&WKNM) VALUE(&USER)

  /*---------------------------------------------------------------*/
             OVRDSPF    FILE(ALDPW9X) TOFILE(TOBJ1/ALDPW9X)

             CALL       PGM(ALDR9XL) PARM(&WKCD &WKNM &SECT &PFLG)

  /*---------------------------------------------------------------*/

 #END:       SIGNOFF

             ENDPGM
