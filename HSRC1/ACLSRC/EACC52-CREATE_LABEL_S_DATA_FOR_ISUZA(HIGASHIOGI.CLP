             PGM        PARM(&FILE2)
         /*** EACC52 ***********************************/
         /* CREATE LABEL'S DATA FOR ISUZA(HIGASHIOGISHIMA) */
         /*                                            */
         /* DATE (CODING):1996.07.29          K.OKACHI */
         /*********************************** EACC52 ***/
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             OVRDBF     FILE(DACWP12) TOFILE(&FILE2)

             DLTF       FILE(EACWP52)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE0/EACWP52) RCDLEN(100) +
                          TEXT('ISUZU FOR LABEL PUBLICATION WROK FILE')

             CALL       PGM(EACR52)
             DLTOVR     FILE(*ALL)
             ENDPGM
