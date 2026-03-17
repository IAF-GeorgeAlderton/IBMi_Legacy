             PGM
             /** ALDR98 **********************************/

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(20)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

   /*   have TM enter worker code...                         */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USR &VALID)

   /*  if worker code was valid, continue...                 */
             IF         COND(&VALID *NE 'Y') THEN(GOTO CMDLBL(#END))
             CHGVAR     VAR(&USER) VALUE(&USR)
             CALL       PGM(TOBJ1/ALDR98) PARM((&WKCD) (&USER))
             SIGNOFF

 #END:       ENDPGM
