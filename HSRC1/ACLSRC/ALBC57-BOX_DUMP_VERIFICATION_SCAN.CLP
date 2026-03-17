             PGM

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

             ADDLIBLE   LIB(HWFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HOBJ1)
             MONMSG     MSGID(CPF0000)

 /*******************************************************************/
 /*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

 /*******************************************************************/
 /*  BOX DUMP VERIFICATION SCAN                                     */
             IF         COND(&VALID = 'Y') THEN(DO)
                         CALL       PGM(ALBR57) PARM(&WKCD &USER)
                                           ENDDO

 /*******************************************************************/

 /*****      SIGNOFF  * * * * * * * * * * * * * * * * * * * * * * ***/

             ENDPGM
