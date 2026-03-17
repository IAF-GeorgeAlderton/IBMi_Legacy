             PGM

             CPYF       FROMFILE(MEKI_RST17/RESULTFILE) +
                          TOFILE(AJUWP10) MBROPT(*REPLACE) +
                          INCCHAR(*RCD 1 *EQ 'D') FMTOPT(*NOCHK)

             CPYF       FROMFILE(AJUWP10) TOFILE(AJUPP10) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)

             ENDPGM
