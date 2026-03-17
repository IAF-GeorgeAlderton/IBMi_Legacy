             PGM        PARM(&PFILE &PLIBR)
             /** AJBC64 **************************************/
             /*  ..AS/400 AOYAMA--->IAF DATABASE TRANSFER..  */
             /*      I-HASADA                  97.12.22      */
             /************************************** AJBC64 **/
             DCL        VAR(&PFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIBR) TYPE(*CHAR) LEN(10)

             DLTF       FILE(APSAVLIB/&PFILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(IAFFILE/&PFILE)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTSAVF    FILE(APSAVLIB/&PFILE) AUT(*ALL)

             RCVNETF    FROMFILE(&PFILE) TOFILE(APSAVLIB/&PFILE) +
                          USER(TFILE)

             RSTOBJ     OBJ(&PFILE) SAVLIB(&PLIBR) DEV(*SAVF) +
                          OBJTYPE(*ALL) SAVF(APSAVLIB/&PFILE) +
                          MBROPT(*ALL) RSTLIB(IAFFILE)

             DLTF       FILE(APSAVLIB/&PFILE)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
