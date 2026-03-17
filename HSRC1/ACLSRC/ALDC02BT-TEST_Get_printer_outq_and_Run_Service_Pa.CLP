             PGM

             DCL        VAR(&WKCD)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR20)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&PID)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&OUTQ)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&USER)
             CHGVAR     VAR(&USR20) VALUE(&USER)

  /*   have TM enter worker code...                         */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

  /*  if worker code was valid, continue...                 */
             IF         COND(&VALID *NE 'Y') THEN(GOTO CMDLBL(#END))

  /*  call pgm to get outq for label printing...                       */
             CALL       PGM(UTLR692) PARM(&PID &OUTQ &RTN)

  /*  if user hit F1 to end program....                                */
             IF         COND(&RTN = '*') THEN(GOTO CMDLBL(#END))

  /*  call regular service part scan pgm, passing the outq for print...*/
             CALL       PGM(ALDR4S) PARM(&WKCD &USR20 &OUTQ)

 #END:       SIGNOFF

             ENDPGM
