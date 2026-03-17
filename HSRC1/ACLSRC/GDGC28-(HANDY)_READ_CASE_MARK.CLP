             PGM
             /** GDGC28 **********************************************/
             /*  (HANDY) READ CASE MARK                              */
             /*       SEEK                      2023.02.21           */
             /********************************************************/
             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&USER)

             /*************************/
             /*  TEAM MEMBER SIGN-ON  */
             /*************************/
             CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

             /*************************/
             /*  READ CASE MARK       */
             /*************************/
             IF (&VALID = 'Y')    (CALL GDGR28 (&WKCD &USER))

             SIGNOFF

             ENDPGM
