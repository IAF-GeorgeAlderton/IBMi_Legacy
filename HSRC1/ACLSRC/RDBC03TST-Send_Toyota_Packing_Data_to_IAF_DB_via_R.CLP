             PGM        PARM(&SHIPDT)

             DCL        VAR(&SHIPDT) TYPE(*CHAR) LEN(8)

             ADDLIBLE   LIB(RDB40)
             MONMSG     MSGID(CPF0000)

 /*  send packing data to IAFDB...                         */
             CALL       PGM(RDBR03) PARM(&SHIPDT)

 /*  send pallet return data to IAFDB...                   */
             CALL       PGM(RDBR04) PARM(&SHIPDT)

             ENDPGM
