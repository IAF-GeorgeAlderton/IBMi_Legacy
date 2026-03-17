             PGM
             /** MYCC80 **************************************/
             /*  DELETED PART MASTER DOWNLOAD (FCEPP01)      */
             /*  JW      2023.12.21                          */
             /************************************************/

             CLRPFM     FILE(HWFILE1/MYCWP80)

             CALL       PGM(MYCR80)

             CALL       PGM(APLC94) PARM('2' 'MYCWP80' 'HWFILE1' +
                          'DELETED PART MASTER' 'Y' ' ' 'Y')

 END:        ENDPGM
