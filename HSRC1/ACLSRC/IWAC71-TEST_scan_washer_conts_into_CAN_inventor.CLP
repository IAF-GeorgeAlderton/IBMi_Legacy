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

             OVRDBF     FILE(GDMPP80) TOFILE(TFILE1/GDMPP80)
             OVRDBF     FILE(GDMPL80) TOFILE(TFILE1/GDMPL80)
             OVRDBF     FILE(GDMPL81) TOFILE(TFILE1/GDMPL81)
             OVRDBF     FILE(GDMPP90) TOFILE(TFILE1/GDMPP90)
             OVRDBF     FILE(GDMPL90) TOFILE(TFILE1/GDMPL90)
             OVRDBF     FILE(GDMPL91) TOFILE(TFILE1/GDMPL91)

             CALL       PGM(TOBJ1/GDMR810) PARM((&WKCD) (&USRID))

                                           ENDDO
             SIGNOFF

 ENDPGM
