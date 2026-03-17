             /** EDSC88 ************************************/
             /**********************************************/

             CPYF       FROMFILE(TFILE1/AB#EP63) +
                          TOFILE(TFILE1/EB#EP63) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             CPYF       FROMFILE(TFILE1/AB#EP64) +
                          TOFILE(TFILE1/EB#EP64) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             CPYF       FROMFILE(TFILE1/AB#EP65) +
                          TOFILE(TFILE1/EB#EP65) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             CPYF       FROMFILE(TFILE1/AB#EP66) +
                          TOFILE(TFILE1/EB#EP66) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             CLRPFM     FILE(TFILE1/OUTPUT)
             CLRPFM     FILE(TFILE1/EB#EP63S)
             CLRPFM     FILE(TFILE1/EB#EP64S)
             CLRPFM     FILE(TFILE1/EB#EP65S)
             CLRPFM     FILE(TFILE1/EB#EP66S)


 @EXIT:      ENDPGM
