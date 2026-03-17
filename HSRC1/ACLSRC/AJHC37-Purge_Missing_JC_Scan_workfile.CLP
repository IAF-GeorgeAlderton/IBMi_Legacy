             PGM

/* purge all records already printed and emailed        */
             CALL       PGM(AJHR37)

/* reorganize file and remove deleted records           */
             RGZPFM     FILE(AJHWPS1)
             MONMSG     MSGID(CPF0000)

             ENDPGM
