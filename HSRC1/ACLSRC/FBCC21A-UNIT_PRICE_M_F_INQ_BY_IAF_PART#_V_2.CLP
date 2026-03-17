             PGM        PARM(&PCMD)
             /** FBCC21A *********************************/
             /*  UNIT PRICE M/F INQ BY IAF PART# V.2     */
             /*  JW   2023.06.21                         */
             /********************************************/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(1)

             DLTF       FILE(QTEMP/FBCWP21)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(FBCWP21) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CLRPFM     FILE(QTEMP/FBCWP21)

             OVRDBF     FILE(FBCWP21) TOFILE(QTEMP/FBCWP21)

             CALL       PGM(FBCR21A) PARM(&PCMD)

 ENDP:       ENDPGM
