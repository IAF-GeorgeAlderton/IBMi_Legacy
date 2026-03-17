             PGM

             DCL        VAR(&SHIPDT) TYPE(*CHAR) LEN(8)

             ADDLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

 /*  send packing data to IAFDB...                         */
             CALL       PGM(RDBR03) PARM(&SHIPDT)
 /*  send packing data to SQL01...                         */
             CALL       PGM(RDBR13) PARM(&SHIPDT)

 /*  send pallet return data to IAFDB...                   */
             CALL       PGM(RDBR04) PARM(&SHIPDT)
 /*  send pallet return data to SQL01...                   */
             CALL       PGM(RDBR14) PARM(&SHIPDT)

             RMVLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

             ENDPGM
