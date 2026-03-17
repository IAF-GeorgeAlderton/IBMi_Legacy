             PGM

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR20) TYPE(*CHAR) LEN(20)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SECT) TYPE(*CHAR) LEN(1) VALUE('2')
             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1)

 /*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USRID &VALID)

 /*******************************************************************/
             IF         COND(&VALID = 'Y') THEN(DO)

 /*  RECEIVE WASHER INTO INVENTORY                                  */

             OVRDBF     FILE(ALDPP35) TOFILE(TFILE1/ALDPP35)

             CALL       PGM(TOBJ1/ALDR9X) PARM((&WKCD) (&USR20) +
                          (&SECT) (&FLG))

                                           ENDDO
             SIGNOFF

 ENDPGM
