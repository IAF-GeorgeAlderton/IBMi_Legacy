             PGM
             /** ALDC00Y **********************************/
             /* HEADING/ROLLING SCAN MENU                */
             /*     LEC            07/22/2024            */
             /********************************************/

             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USR)

             IF         COND(&USR *NE 'TEST') THEN(DO)
             ADDLIBLE   LIB(HWFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HFILE1)
             MONMSG     MSGID(CPF0000)
             ADDLIBLE   LIB(HOBJ1)
             MONMSG     MSGID(CPF0000)
             ENDDO

             CALL       PGM(ALDR00Y)

             SIGNOFF

             ENDPGM
