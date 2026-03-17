             PGM
             /** MYCC99B ********************************************/
             /*  PROCESS MASTER DOWNLOAD - (HORIZONTAL+VERTICAL)    */
             /*  JW      2023.03.16                                 */
             /*******************************************************/

             CLRPFM     FILE(HWFILE1/GHCWP21B)

             CALL       PGM(MYCR99B)

             CALL       PGM(APLC94) PARM('2' 'GHCWP21B' 'HWFILE1' +
                          'PROCESS MASTER-MIX' 'Y' 'Y' 'Y')

 END:        ENDPGM
