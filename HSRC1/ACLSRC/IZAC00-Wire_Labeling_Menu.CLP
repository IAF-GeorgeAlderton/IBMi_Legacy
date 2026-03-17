             PGM
             /** IZAC00 ***********************************************/
             /* WIRE LABELING MENU                                    */
             /*                                                       */
             /* LEC  CREATE 2025/12/18                                */
             /*                                                       */
             /*********************************************************/

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

  /*   have TM enter worker code...                         */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

  /*  if worker code was valid, continue...                 */
             IF         COND(&VALID *NE 'Y') THEN(GOTO CMDLBL(#END))

             CALL       PGM(IZAR00) PARM(&WKCD &USER)

 #END:       SIGNOFF

             ENDPGM
