             PGM

     /* TAKE BACKUP */
             CPYF       FROMFILE(HFILE1/GBFPP51) +
                          TOFILE(SAKAKI/GBFPP51) MBROPT(*REPLACE) +
                          CRTFILE(*YES)

             CLRPFM     FILE(IAFFCE/GBFPP51)

             OVRDBF     FILE(GBFIN  ) TOFILE(HFILE1/GBFPP51)
             OVRDBF     FILE(GBFOUT ) TOFILE(IAFFCE/GBFPP51)

             CALL       PGM(CNVR02)

             DLTOVR     FILE(GBFIN GBFOUT)

             ENDPGM
