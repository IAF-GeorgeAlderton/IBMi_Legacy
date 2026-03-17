             PGM        PARM(&POBJ &PMBR)
             /** AJFC16 ****************************************/
             /*  ..AS/400 IAF ATC<-->AOYAMA SOURCE TRANSFER..  */
             /*  ..SRCMBR SRCFILE LIBRARY                      */
             /*    I-HASADA                      2001.04.20    */
             /**************************************** AJFC16 **/
             DCL        VAR(&POBJ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMBR) TYPE(*CHAR) LEN(10)

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
                          TOFILE(IAFHSRC/IAFHSRC) FROMMBR(&POBJ) +
                          TOMBR(&POBJ)
             MONMSG     MSGID(CPF2952)

             DLTF       FILE(IKOULIB/&POBJ)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(APSAVLIB/&POBJ)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
