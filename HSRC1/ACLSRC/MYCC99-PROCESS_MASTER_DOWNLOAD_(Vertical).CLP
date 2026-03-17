             PGM
             /** MYCC99 **************************************/
             /*  PROCESS MASTER DOWNLOAD - VERTICAL          */
             /*  JW      2023.03.14                          */
             /************************************************/

             CLRPFM     FILE(HWFILE1/GHCWP21A)

             CALL       PGM(MYCR99)

             CALL       PGM(APLC94) PARM('2' 'GHCWP21A' 'HWFILE1' +
                          'PROCESS MASTER (VERTICAL)' 'Y' 'Y' 'Y')

 END:        ENDPGM
