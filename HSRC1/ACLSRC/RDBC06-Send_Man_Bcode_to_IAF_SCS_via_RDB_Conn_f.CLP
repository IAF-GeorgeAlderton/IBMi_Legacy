             PGM        PARM(&SURT &SHID &SHIT &WKCD)

             DCL        VAR(&SURT) TYPE(*CHAR) LEN(9)
             DCL        VAR(&SHID) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SHIT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)

             ADDLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

 /*  send manifest barcodes to IAF SCS for Truck            */
             CALL       PGM(RDBR06) PARM(&SURT &SHID &SHIT &WKCD)

             RMVLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

             ENDPGM
