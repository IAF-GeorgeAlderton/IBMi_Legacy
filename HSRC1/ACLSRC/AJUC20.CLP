             PGM

             CPYF       FROMFILE(MEKI_RST18/RESULT) +
                          TOFILE(AJUWP20) MBROPT(*REPLACE) +
                          INCCHAR(*RCD 1 *EQ 'D') FMTOPT(*NOCHK)

             CPYF       FROMFILE(AJUWP20) TOFILE(AJUPP20) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

             ENDPGM
