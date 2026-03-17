             PGM        PARM(&PCMD)
             /** FBCC29A *********************************/
             /*  UNIT PRICE M/F INQ BY CUST PART# V.2    */
             /*  JW   2023.06.21                         */
             /********************************************/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)

             DLTF       FILE(QTEMP/FBCWP29)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(FBCWP29) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CLRPFM     FILE(QTEMP/FBCWP29)

             OVRDBF     FILE(FBCWP29) TOFILE(QTEMP/FBCWP29)

             CALL       PGM(FBCR29A) PARM(&PCMD)

 ENDP:       ENDPGM
