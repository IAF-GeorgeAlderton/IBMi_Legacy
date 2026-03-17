             PGM
             /** ALDC02 **********************************/
             /* MATCHING SHIPPING SYSTEM IN IAF(CONTROL) */
             /* TCH(N.HYOTO)       09/13/99              */
             /********************************************/
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USR)

             IF         (&USR   *EQ 'A') DO
             ADDLIBLE   LIB(TWFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(TOBJ1)
             MONMSG     MSGID(CPF0000)
             GOTO       STP1
             ENDDO

        /**  IF         (&USR   *NE 'A') DO **/
        /**  ADDLIBLE   LIB(HWFILE1)        **/
        /**  MONMSG     MSGID(CPF0000)      **/
        /**  ADDLIBLE   LIB(HFILE1)         **/
        /**  MONMSG     MSGID(CPF0000)      **/
        /**  ADDLIBLE   LIB(HOBJ1)          **/
        /**  MONMSG     MSGID(CPF0000)      **/
        /**  GOTO       STP1                **/
        /**  ENDDO                          **/
STP1:
             CALL       PGM(ALDR00) PARM(&USR)

             SIGNOFF

             ENDPGM
