             PGM        PARM(&PFILE &PLIBR)
             /** AJBC68 **************************************/
             /*  ..AS/400 IAF--->AOYAMA DATABASE TRANSFER..  */
             /*      I-HASADA                  97.12.22      */
             /************************************** AJBC68 **/
             DCL        VAR(&PFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIBR) TYPE(*CHAR) LEN(10)

             DLTF       FILE(APSAVLIB/&PFILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(IAFFILE/&PFILE)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTSAVF    FILE(APSAVLIB/&PFILE) AUT(*ALL)

             RCVNETF    FROMFILE(&PFILE) TOFILE(APSAVLIB/&PFILE) +
                          USER(QFILE)

             RSTOBJ     OBJ(&PFILE) SAVLIB(&PLIBR) DEV(*SAVF) +
                          OBJTYPE(*FILE) SAVF(APSAVLIB/&PFILE) +
                          MBROPT(*ALL) RSTLIB(IAFFILE)

             DLTF       FILE(APSAVLIB/&PFILE)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
