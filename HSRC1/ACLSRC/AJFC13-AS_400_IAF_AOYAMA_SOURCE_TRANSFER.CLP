             PGM        PARM(&POBJ &PMBR &PSRC)
             /** AJFC13 ************************************/
             /*  ..AS/400 IAF<-->AOYAMA SOURCE TRANSFER..  */
             /*    I-HASADA                    97.09.19    */
             /************************************ AJFC13 **/
             DCL        VAR(&POBJ) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSRC) TYPE(*CHAR) LEN(7)

             DLTF       FILE(IKOULIB/&POBJ)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(APSAVLIB/&POBJ)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTSAVF    FILE(APSAVLIB/&POBJ) AUT(*ALL)

             RCVNETF    FROMFILE(&POBJ) TOFILE(APSAVLIB/&POBJ) +
                          NBR(&PMBR) USER(TFILE)

             RSTOBJ     OBJ(&POBJ) SAVLIB(IKOULIB) DEV(*SAVF) +
                          OBJTYPE(*FILE) SAVF(APSAVLIB/&POBJ) +
                          MBROPT(*ALL)

             CPYSRCF    FROMFILE(IKOULIB/&POBJ) +
                          TOFILE(IAFHSRC/&PSRC) FROMMBR(&POBJ) +
                          TOMBR(&POBJ)
             MONMSG     MSGID(CPF2952 CPF9999 RPG9001)

             DLTF       FILE(IKOULIB/&POBJ)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(APSAVLIB/&POBJ)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
