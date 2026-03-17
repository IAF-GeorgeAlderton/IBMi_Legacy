             PGM
             /** ALCC0Z **********************************/
             /* HT/HT OQ SCANNING                        */
             /*     T.SAKAKI           2019.11.15        */
             /********************************************/
             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&USER)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             ADDLIBLE   LIB(HWFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HOBJ1)
             MONMSG     MSGID(CPF0000)
             ENDDO

 /*******************************************************************/
 /*  CHECK AND UNLOCK SIGN-ON INFORMATION FOR HANDY TERMINAL        */
             CALL       PGM(ALDRZ5)

 /*******************************************************************/
 /*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

 /*******************************************************************/
 /*  OQ SCANNING SYSTEM MENU                                        */
             IF         COND(&VALID = 'Y') THEN(DO)
                         CALL       PGM(ALCR0A) PARM(&WKCD &USER)
                                           ENDDO

 /*******************************************************************/

             SIGNOFF

             ENDPGM
