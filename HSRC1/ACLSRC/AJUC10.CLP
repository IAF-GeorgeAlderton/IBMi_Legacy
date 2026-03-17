             PGM

             CPYF       FROMFILE(MEKI_RST17/RESULT) TOFILE(AJUWP10) +
                          MBROPT(*REPLACE) INCCHAR(*RCD 1 *EQ 'D') +
                          FMTOPT(*NOCHK)

             CPYF       FROMFILE(AJUWP10) TOFILE(AJUPP10) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

             ENDPGM
