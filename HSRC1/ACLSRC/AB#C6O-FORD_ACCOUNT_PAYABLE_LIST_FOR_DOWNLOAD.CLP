             PGM        PARM(&DATE &TIME)
             /** AB#C6O ***********************************/
             /*  ..FORD ACCOUNT PAYBALE LIST FOR DOWNLOAD */
             /*                                           */
             /*********************************************/
             DCL        VAR(&DATE) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&TIME) TYPE(*DEC) LEN(6 0)

             CLRPFM     FILE(AB#PP6S)
             CLRPFM     FILE(AB#PP6T)

             CALL       PGM(AB#R6O) PARM(&DATE &TIME)

             ENDPGM
