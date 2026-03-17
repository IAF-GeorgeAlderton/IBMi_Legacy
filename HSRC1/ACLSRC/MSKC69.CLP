             PGM

             DLTF       FILE(HWFILE1/MSKWP69)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MSKWP69) RCDLEN(1024) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 10000 +
                          5) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MSKR69)

             ENDPGM
