             PGM
             /*** FBCC81B **************************************/
             /* READ FBCWP81 AND UTPUT TO FBCWP81B (CSV)       */
             /* JW (SRA)     2025.03.10                        */
             /**************************************************/
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CLRPFM FBCWP81B

             OVRDBF     FILE(FBCWP81) TOFILE(HWFILE1/FBCWP81BK)
             CALL       PGM(FBCR81B)

             CHGVAR     VAR(&FNAM) VALUE('FORD APR UPLOADED REPORT')
             CALL       PGM(APLC94) PARM('2' 'FBCWP81B' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
             ENDPGM
