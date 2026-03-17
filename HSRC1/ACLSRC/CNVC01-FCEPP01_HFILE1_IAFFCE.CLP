             PGM

     /* TAKE BACKUP */
             CPYF       FROMFILE(HFILE1/FCEPP01) +
                          TOFILE(SAKAKI/FCEPP01) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             CPYF       FROMFILE(HFILE1/FCEPP01) +
                          TOFILE(SAKAKI2/FCEPP01) MBROPT(*REPLACE) +
                          CRTFILE(*YES)

             CLRPFM     FILE(IAFFCE/FCEPP01)

  /* OLD */  OVRDBF     FILE(FCEIN  ) TOFILE(HFILE1/FCEPP01)
  /* NEW */  OVRDBF     FILE(FCEOUT ) TOFILE(IAFFCE/FCEPP01)

             CALL       PGM(CNVR01)

             DLTOVR     FILE(FCEIN FCEOUT)

             ENDPGM
