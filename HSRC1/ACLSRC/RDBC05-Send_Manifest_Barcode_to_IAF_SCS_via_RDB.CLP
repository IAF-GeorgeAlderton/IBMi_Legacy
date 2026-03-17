             PGM        PARM(&MFBC &WKCD)

             DCL        VAR(&MFBC) TYPE(*CHAR) LEN(50)
             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)

             ADDLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

 /*  send manifest barcode to IAF SCS                      */
             CALL       PGM(RDBR05) PARM(&MFBC &WKCD)

             RMVLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

             ENDPGM
