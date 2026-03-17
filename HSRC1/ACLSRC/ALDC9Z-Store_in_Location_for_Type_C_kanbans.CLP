             PGM
             /** ALDC9C  ******************************/
             /* STORE IN LOCATION FOR TYPE C KANBANS  */
             /*    LEC       2024.11.12               */
             /*****************************************/

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LOCN) TYPE(*CHAR) LEN(20)
             DCL        VAR(&QRCD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&WKNM) TYPE(*CHAR) LEN(20)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SECT) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

  /*---------------------------------------------------------------*/
  /*   have TM enter worker code...                                */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

  /*  if worker code was valid, continue...  if not, end pgm       */
             IF         COND(&VALID *NE 'Y') THEN(GOTO CMDLBL(#END))
             CHGVAR     VAR(&WKNM) VALUE(&USER)

  /*---------------------------------------------------------------*/

  /********  CALL       PGM(ALDR9Z) PARM((&LOCN) (&QRCD) (&WKCD)****/
  /********               (&WKNM) (&SECT) (&PFLG))              ****/

             CALL       PGM(TOBJ1/ALDR9X) PARM((&WKCD) (&WKNM) +
                          (&SECT) (&PFLG))

  /*---------------------------------------------------------------*/

 #END:
             SIGNOFF


             ENDPGM
