             PGM        PARM(&FILE)
             /** GIGC97 *********************/
             /*   RETURN OF THE NETWORK JOB */
             /*   < PRODUCTS INVOICE DATA > */
             /*       K.YASUDA  1997.10.06  */
             /********************* GIGC97 **/
             DCL        VAR(&FILE)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMBRN) TYPE(*CHAR) LEN(6)
             CALL       PGM(AJFC40) PARM(&FILE &PMBRN)

             DLTF       FILE(APSAVLIB/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTSAVF    FILE(APSAVLIB/&FILE) AUT(*ALL)

             RCVNETF    FROMFILE(&FILE) TOFILE(APSAVLIB/&FILE) +
                          USER(QFILE)

             RSTOBJ     OBJ(&FILE) SAVLIB(WORKLIB) DEV(*SAVF) +
                          OBJTYPE(*FILE) SAVF(APSAVLIB/&FILE) +
                          MBROPT(*ALL) ALWOBJDIF(*ALL) +
                          FRCOBJCVN(*YES) RSTLIB(QGPL)
             MONMSG     MSGID(CPF3773)

             CPYF       FROMFILE(QGPL/&FILE) TOFILE(HWFILE1/&FILE) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             DLTF       FILE(QGPL/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             ENDPGM
