             PGM

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR20) TYPE(*CHAR) LEN(20)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SECT) TYPE(*CHAR) LEN(1) VALUE('2')

 /*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USRID &VALID)

 /*******************************************************************/
             IF         COND(&VALID = 'Y') THEN(DO)

             CHGVAR     VAR(&USR20) VALUE(&USRID)

 /*  RUN CV WIRE SCAN TO VIRTUAL LOCATION                         */
             CALL       PGM(ALFR73) PARM(&WKCD &USR20)

                                           ENDDO
             SIGNOFF

 ENDPGM
