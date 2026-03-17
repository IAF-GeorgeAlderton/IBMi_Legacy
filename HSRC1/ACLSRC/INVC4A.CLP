             PGM

             DLTF       FILE(HWFILE1/INVWP4A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/INVWP4A) RCDLEN(2015) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(INVR4A)

             EDTDTA     FILE(INVWP4A)

             ENDPGM
