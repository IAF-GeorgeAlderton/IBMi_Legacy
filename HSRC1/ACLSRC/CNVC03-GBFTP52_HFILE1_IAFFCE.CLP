             PGM

     /* TAKE BACKUP */
             CPYF       FROMFILE(HFILE1/GBFTP52) +
                          TOFILE(SAKAKI/GBFTP52) MBROPT(*REPLACE) +
                          CRTFILE(*YES)

             CLRPFM     FILE(IAFFCE/GBFTP52)

             OVRDBF     FILE(GBFIN  ) TOFILE(HFILE1/GBFTP52)
             OVRDBF     FILE(GBFOUT ) TOFILE(IAFFCE/GBFTP52)

             CALL       PGM(CNVR03)

             DLTOVR     FILE(GBFIN GBFOUT)

             ENDPGM
