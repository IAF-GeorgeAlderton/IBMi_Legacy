             PGM        PARM(&FILE &FILE1)
             /** GSTC6H *********************/
             /*   RETURN OF THE NETWORK JOB     (FROM ATC) */
             /*   < PRODUCTS INVOICE DATA > */
             /*       K.YASUDA  2004.01.30  */
             /********************* GSTC6H **/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMBRN) TYPE(*CHAR) LEN(6)
             CALL       PGM(AJFC40) PARM(&FILE &PMBRN)

             DLTF       FILE(APSAVLIB/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTSAVF    FILE(APSAVLIB/&FILE) AUT(*ALL)

             RCVNETF    FROMFILE(&FILE) TOFILE(APSAVLIB/&FILE) +
                          USER(QFILE)

             RSTOBJ     OBJ(&FILE) SAVLIB(ATCWFILE) DEV(*SAVF) +
                          OBJTYPE(*FILE) SAVF(APSAVLIB/&FILE) +
                          MBROPT(*ALL) ALWOBJDIF(*ALL) +
                          FRCOBJCVN(*YES) RSTLIB(QGPL)
             MONMSG     MSGID(CPF3773)

             CPYF       FROMFILE(QGPL/&FILE) TOFILE(HWFILE1/&FILE1) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK)

             DLTF       FILE(QGPL/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             ENDPGM
