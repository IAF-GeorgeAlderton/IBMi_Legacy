             PGM

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

 /*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USRID &VALID)

 /*******************************************************************/
             IF         COND(&VALID = 'Y') THEN(DO)

 /*  RECEIVE WASHER INTO INVENTORY                                  */

             OVRDBF     FILE(ALFPP01) TOFILE(TFILE1/ALFPP01)

             CALL       PGM(TOBJ1/ALFR01) PARM((&WKCD) (&USRID))

                                           ENDDO
             SIGNOFF

 ENDPGM
