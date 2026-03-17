             PGM
             /** AM#C0Y **********************************/
             /* MATCHING SHIPPING SYSTEM I               */
             /*     ITS.           06/08/2015            */
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

             CALL       PGM(AM#R0Y)

             SIGNOFF

             ENDPGM
