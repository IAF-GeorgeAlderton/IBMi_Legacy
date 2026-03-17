             PGM

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

  /*/        ADDLIBLE   LIB(TWFILE1)                     /*/
  /*/        MONMSG     MSGID(CPF0000)                   /*/
  /*/        ADDLIBLE   LIB(TFILE1)                      /*/
  /*/        MONMSG     MSGID(CPF0000)                   /*/
  /*/        ADDLIBLE   LIB(TOBJ1)                       /*/
  /*/        MONMSG     MSGID(CPF0000)                   /*/

 /*******************************************************************/
 /*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&WKCD &USER &VALID)

 /*******************************************************************/
 /*  3PT SHIPPING SCAN                                              */
             IF         COND(&VALID = 'Y') THEN(DO)
             CALL       PGM(TOBJ1/ALDR2Z) PARM(&WKCD &USER)
                                           ENDDO

 /*******************************************************************/

             SIGNOFF

             ENDPGM
