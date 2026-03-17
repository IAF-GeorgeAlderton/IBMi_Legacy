/** ALCC79 ************************************************/
/*   TPS SCAN MENU                                        */
/*       SAKAKI        2019.12.05                         */
/**********************************************************/
             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(20)
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
 /*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

 /*******************************************************************/
 /*  CONVEYANCE SYSTEM MENU                                         */
             IF         COND(&VALID = 'Y') THEN(DO)
                         CALL       PGM(ALCR79) PARM(&WKCD &USER)
                                           ENDDO

 /*******************************************************************/

             SIGNOFF


 ENDPGM
