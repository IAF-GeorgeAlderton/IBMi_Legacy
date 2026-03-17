             PGM
             /** MYCC97 *********************************/
             /*  BPT KANBAN MASTER DOWNLOAD (AANPP01)   */
             /*  JW     2021.02.15                      */
             /*******************************************/

             CLRPFM     FILE(HWFILE1/MYCWP98)

             CALL       PGM(MYCR98)

 /* DOWNLOAD TO CSV */
             CALL       PGM(APLC93N) PARM('2' 'MYCWP98 ' 'HWFILE1' +
                          'BPT KANBAN MASTER DOWNLOAD' 'Y' ' ' 'Y')

             ENDPGM
